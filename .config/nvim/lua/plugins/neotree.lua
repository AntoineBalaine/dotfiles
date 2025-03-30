return {
  "nvim-neo-tree/neo-tree.nvim",
  ---@module "neo-tree"
  ---@type neotree.Config?
  opts = {
    event_handlers = {
      {
        event = "neo_tree_buffer_enter",
        handler = function(_)
          vim.opt_local.relativenumber = true
        end,
      },
    },
    filesystem = {
      bind_to_cwd = true,
      follow_current_file = { enabled = true },

      filtered_items = {
        visible = true,
        show_hidden_count = true,
        hide_dotfiles = false,
        hide_gitignored = true,
        hide_by_name = {
          -- '.git',
          -- '.DS_Store',
          -- 'thumbs.db',
        },
        never_show = {},
      },

      window = {
        mappings = {
          ["g/"] = "grep_in_folder",
          ["gf"] = "grep_filter",
          ["<C-x>"] = "clear_filter",
        },
      },
      commands = {
        grep_in_folder = function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          require("telescope.builtin").live_grep({ search_dirs = { path } })
        end,

        grep_filter = function(state)
          -- Check if ripgrep is installed
          if vim.fn.executable("rg") ~= 1 then
            print("Error: ripgrep (rg) is not installed or not in PATH")
            return
          end

          -- Get the current node (where cursor is placed)
          local node = state.tree:get_node()
          local path = node:get_id()

          -- If node is a directory, use it as the search root
          -- Otherwise, use its parent directory
          if node.type ~= "directory" then
            path = vim.fn.fnamemodify(path, ":h")
          end

          print("Using search path: " .. path)

          -- Create an input popup for the search term
          require("neo-tree.ui.inputs").input("Grep Pattern: ", "", function(pattern)
            if not pattern or pattern == "" then
              return
            end

            -- Store the original tree to restore later
            state.grep_pattern = pattern
            state.original_tree = vim.deepcopy(state.tree)

            -- Use ripgrep to find files containing the pattern
            local cmd = "rg --files-with-matches --hidden --glob '!.git/' "
              .. vim.fn.shellescape(pattern)
              .. " "
              .. vim.fn.shellescape(path)

            print("Executing: " .. cmd)

            local handle = io.popen(cmd)
            if not handle then
              print("Failed to execute grep command")
              return
            end

            -- Collect matching files
            local matching_files = {}
            local count = 0
            for file in handle:lines() do
              matching_files[file] = true
              count = count + 1
              print("Match: " .. file)
            end
            handle:close()

            print("Found " .. count .. " files matching pattern: " .. pattern)

            if count == 0 then
              print("No files found containing pattern: " .. pattern)
              return
            end

            -- First, build a set of paths to keep (matching files and all parent directories)
            local paths_to_keep = {}

            -- Add a path and all its parent directories to the keep set
            local function add_path_and_parents(path)
              -- Add the path itself
              paths_to_keep[path] = true
              print("  Keeping path: " .. path)

              -- Add all parent directories
              local current = path
              while true do
                local parent = vim.fn.fnamemodify(current, ":h")
                if parent == current then
                  print("  Reached root: " .. parent)
                  break -- We've reached the root
                end
                paths_to_keep[parent] = true
                print("  Keeping parent: " .. parent)
                current = parent
              end
            end

            -- Add all matching files and their parent directories to the keep set
            print("Building paths_to_keep set...")
            for file_path, _ in pairs(matching_files) do
              print("Adding to keep set: " .. file_path)
              add_path_and_parents(file_path)
            end

            -- Print all paths we're keeping
            print("All paths to keep:")
            local keep_count = 0
            for path, _ in pairs(paths_to_keep) do
              keep_count = keep_count + 1
              print("  " .. keep_count .. ": " .. path)
            end
            print("Total paths to keep: " .. keep_count)

            -- Now traverse the tree and remove nodes that aren't in our keep set
            local function should_keep_node(node)
              local path = node:get_id()
              local keep = paths_to_keep[path] ~= nil
              if keep then
                print("Should keep: " .. path)
              else
                print("Should remove: " .. path)
              end
              return keep
            end

            -- Collect nodes to remove (bottom-up to avoid issues)
            local nodes_to_remove = {}

            local function collect_nodes_to_remove(node_id)
              local node = state.tree:get_node(node_id)
              local path = node:get_id()
              print("Checking node: " .. path .. " (type: " .. node.type .. ")")

              -- Process children first (depth-first)
              if node.type == "directory" and node:has_children() then
                local child_ids = node:get_child_ids()
                print("  Directory has " .. #child_ids .. " children")
                for _, child_id in ipairs(child_ids) do
                  collect_nodes_to_remove(child_id)
                end
              end

              -- Check if this node should be kept
              if not should_keep_node(node) then
                table.insert(nodes_to_remove, node_id)
                print("  Marked for removal: " .. path)
              else
                print("  Keeping: " .. path)
              end
            end

            -- Collect all nodes to remove
            print("Identifying nodes to remove...")
            local roots = state.tree:get_nodes()
            print("Tree has " .. #roots .. " root nodes")
            for i, root in ipairs(roots) do
              print("Processing root " .. i .. ": " .. root:get_id())
              collect_nodes_to_remove(root:get_id())
            end

            -- Remove nodes in reverse order (bottom-up)
            print("Removing " .. #nodes_to_remove .. " nodes...")
            for i = #nodes_to_remove, 1, -1 do
              local node_id = nodes_to_remove[i]
              local node = state.tree:get_node(node_id)
              if node then
                local path = node:get_id()
                print("Removing: " .. path)
                state.tree:remove_node(node_id)
              else
                print("Node " .. node_id .. " no longer exists")
              end
            end

            -- Check what's left in the tree
            print("After filtering, tree has " .. #state.tree:get_nodes() .. " root nodes")
            for i, node in ipairs(state.tree:get_nodes()) do
              print("Root " .. i .. ": " .. node:get_id())
            end

            -- Add a message to the first node indicating we're in grep filter mode
            local first_node = state.tree:get_nodes()[1]
            if first_node then
              first_node.name = "Filtered by: " .. pattern .. " (Press <C-x> to clear)"
            end

            -- Custom function to expand directories containing matching files
            print("Expanding directories containing matching files...")

            -- Create a custom expander function that specifically targets directories
            -- containing files returned by ripgrep
            local function expand_matching_directories(state, matching_files)
              -- Create a set of directories that contain matching files
              local directories_to_expand = {}

              -- For each matching file, add all its parent directories to the set
              for file_path, _ in pairs(matching_files) do
                local current = file_path
                while true do
                  -- Get the parent directory
                  local parent = vim.fn.fnamemodify(current, ":h")
                  if parent == current then
                    break -- We've reached the root
                  end
                  directories_to_expand[parent] = true
                  current = parent
                end
              end

              print("Found " .. vim.tbl_count(directories_to_expand) .. " directories to expand")

              -- Function to expand a node if it's in our list of directories to expand
              local function expand_if_matching(node_id)
                local node = state.tree:get_node(node_id)

                -- If this is a directory that should be expanded
                if node.type == "directory" then
                  -- Check if this directory is in our list
                  if directories_to_expand[node:get_id()] then
                    -- Expand this node
                    if not node:is_expanded() then
                      node:expand()
                      print("Expanded directory: " .. node:get_id())
                    end

                    -- Recursively process children
                    if node:has_children() then
                      for _, child_id in ipairs(node:get_child_ids()) do
                        expand_if_matching(child_id)
                      end
                    end
                  end
                end
              end

              -- Start expanding from root nodes
              for _, root in ipairs(state.tree:get_nodes()) do
                expand_if_matching(root:get_id())
              end
            end

            -- Call our custom expander function
            expand_matching_directories(state, matching_files)

            -- Redraw the tree
            print("Redrawing tree...")
            require("neo-tree.ui.renderer").redraw(state)
          end)
        end,

        -- Override the clear_filter command to handle our grep filter
        clear_filter = function(state)
          if state.grep_pattern then
            -- Restore the original tree
            state.tree = vim.deepcopy(state.original_tree)
            state.grep_pattern = nil
            state.original_tree = nil
            state.filter_matcher = nil
            state.using_custom_filter = nil

            -- Restore original root name if it was saved
            if state.original_root_name then
              local first_node = state.tree:get_nodes()[1]
              if first_node then
                first_node.name = state.original_root_name
              end
              state.original_root_name = nil
            end

            require("neo-tree.ui.renderer").redraw(state)
            vim.notify("Content filter cleared", vim.log.levels.INFO)
          else
            -- Call the original clear_filter command
            local cmds = require("neo-tree.sources.filesystem.commands")
            cmds.clear_filter(state)
          end
        end,
      },
    },
  },
}
