lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true
lvim.builtin.treesitter.highlight.additional_vim_regex_highlighting = { "markdown" }
lvim.builtin.treesitter.rainbow.enable = true


-- local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
-- parser_config.abc = {
--     install_info = {
--         url = "~/Documents/Experiments/Abcjs/tree-sitter-abc", -- local path or git repo
--         files = { "src/parser.c" },
--         -- optional entries:
--         branch = "main",                        -- default branch in case of git repo if different from master
--         generate_requires_npm = false,          -- if stand-alone parser without npm dependencies
--         requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
--     },
--     filetype = "abc",                           -- if filetype does not match the parser name
-- }


---@type TSConfig
local conf = {
    modules = {},
    sync_install = false,
    ensure_installed = {
        "bash",
        "c",
        "javascript",
        "json",
        "lua",
        "python",
        "typescript",
        "tsx",
        "css",
        "rust",
        "java",
        "yaml",
        "markdown",
        "markdown_inline",
    },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = { "markdown" },
    },
    auto_install = true,
    ignore_install = {},
    textobjects = {
        lsp_interop = {
            enable = true,
            border = 'none',
            floating_preview_opts = {},
            peek_definition_code = {
                -- ["<leader>df"] = "@function.outer",
                -- ["<leader>dF"] = "@class.outer",
            },
        },
        select = {
            enable = true,
            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,
            keymaps = {
                ["AF"] = "@function.outer",
                ["Af"] = "@function.inner",
                ["ib"] = "@block.inner",
                ["ab"] = "@block.outer",
            },
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                ["]f"] = "@function.outer",
                ["]i"] = "@conditional.outer",
                ["]b"] = "@block.outer",
            },
            goto_next_end = {
                ["]F"] = "@function.outer",
                ["]I"] = "@conditional.outer",
                ["]B"] = "@block.outer",
            },
            goto_previous_start = {
                ["[f"] = "@function.outer",
                ["[i"] = "@conditional.outer",
                ["[b"] = "@block.outer",
            },
            goto_previous_end = {
                ["[F"] = "@function.outer",
                ["[I"] = "@conditional.outer",
                ["[B"] = "@block.outer",
            },
            -- Below will go to either the start or the end, whichever is closer.
            -- Use if you want more granular movements
            -- Make it even more gradual by adding multiple queries and regex.
            -- goto_next = {
            -- 	["]i"] = "@conditional.outer",
            -- 	["]f"] = "@function.outer",
            -- },
            -- goto_previous = {
            -- 	["[i"] = "@conditional.outer",
            -- 	["[f"] = "@function.outer",
            -- },
        },
    },
    playground = {
        enable = true,
        disable = {},
        updatetime = 25,         -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = false, -- Whether the query persists across vim sessions
        keybindings = {
            toggle_query_editor = 'o',
            toggle_hl_groups = 'i',
            toggle_injected_languages = 't',
            toggle_anonymous_nodes = 'a',
            toggle_language_display = 'I',
            focus_language = 'f',
            unfocus_language = 'F',
            update = 'R',
            goto_node = '<cr>',
            show_help = '?',
        },
    },
    query_linter = {
        enable = true,
        use_virtual_text = true,
        lint_events = { "BufWrite", "CursorHold" },
    },
}


require("nvim-treesitter.configs").setup(conf)
-- return conf
