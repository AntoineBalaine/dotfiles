local neodev = require("neodev").setup({})
--[[
lvim is the global options object

Linters should be
filled in as strings with either
a global executable or a path to
an executable
]]
-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT

-- general
lvim.log.level = "warn"
lvim.format_on_save = true
lvim.colorscheme = "vscode"
-- to disable icons and use a minimalist setup, uncomment the following
-- lvim.use_icons = false

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
-- lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
-- lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"
-- unmap a default keymapping
-- vim.keymap.del("n", "<C-Up>")
-- override a default keymapping
-- lvim.keys.normal_mode["<C-q>"] = ":q<cr>" -- or vim.keymap.set("n", "<C-q>", ":q<cr>" )

-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
-- local _, actions = pcall(require, "telescope.actions")
-- lvim.builtin.telescope.defaults.mappings = {
--   -- for input mode
--   i = {
--     ["<C-j>"] = actions.move_selection_next,
--     ["<C-k>"] = actions.move_selection_previous,
--     ["<C-n>"] = actions.cycle_history_next,
--     ["<C-p>"] = actions.cycle_history_prev,
--   },
--   -- for normal mode
--   n = {
--     ["<C-j>"] = actions.move_selection_next,
--     ["<C-k>"] = actions.move_selection_previous,
--   },
-- }

-- Use which-key to add extra bindings with the leader-key prefix
-- lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
-- lvim.builtin.which_key.mappings["t"] = {
--   name = "+Trouble",
--   r = { "<cmd>Trouble lsp_references<cr>", "References" },
--   f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
--   d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
--   q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
--   l = { "<cmd>Trouble loclist<cr>", "LocationList" },
--   w = { "<cmd>Trouble workspace_diagnostics<cr>", "Workspace Diagnostics" },
-- }

-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false
vim.api.nvim_command("set wrap")
vim.api.nvim_command("set relativenumber")
lvim.builtin.lualine.style = "default"
vim.opt.scrolloff = 0

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
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
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true
lvim.builtin.treesitter.highlight.additional_vim_regex_highlighting = { "markdown" }

-- generic LSP settings

-- -- make sure server will always be installed even if the server is in skipped_servers list
lvim.lsp.installer.setup.ensure_installed = {
  "jsonls",
  "tsserver"
}
-- -- change UI setting of `LspInstallInfo`
-- -- see <https://github.com/williamboman/nvim-lsp-installer#default-configuration>
-- lvim.lsp.installer.setup.ui.check_outdated_servers_on_open = false
-- lvim.lsp.installer.setup.ui.border = "rounded"
-- lvim.lsp.installer.setup.ui.keymaps = {
--     uninstall_server = "d",
--     toggle_server_expand = "o",
-- }

-- ---@usage disable automatic installation of servers
-- lvim.lsp.installer.setup.automatic_installation = false

-- ---configure a server manually. !!Requires `:LvimCacheReset` to take effect!!
-- ---see the full default list `:lua print(vim.inspect(lvim.lsp.automatic_configuration.skipped_servers))`
-- vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "pyright" })
local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pyright", opts)
require("lvim.lsp.manager").setup("tsserver", opts)
require("lvim.lsp.manager").setup("lua_ls", opts)
-- ---remove a server from the skipped list, e.g. eslint, or emmet_ls. !!Requires `:LvimCacheReset` to take effect!!
-- ---`:LvimInfo` lists which server(s) are skipped for the current filetype
-- lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(server)
--   return server ~= "emmet_ls"
-- end, lvim.lsp.automatic_configuration.skipped_servers)

-- -- you can set a custom on_attach function that will be used for all the language servers
-- -- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end

-- -- set a formatter, this will override the language server formatting capabilities (if it exists)
-- local formatters = require "lvim.lsp.null-ls.formatters"
-- formatters.setup {
--   { command = "black", filetypes = { "python" } },
--   { command = "isort", filetypes = { "python" } },
--   {
--     -- each formatter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
--     command = "prettier",
--     ---@usage arguments to pass to the formatter
--     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
--     extra_args = { "--print-with", "100" },
--     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
--     filetypes = { "typescript", "typescriptreact" },
--   },
-- }

-- -- set additional linters
-- local linters = require "lvim.lsp.null-ls.linters"
-- linters.setup {
--   { command = "flake8", filetypes = { "python" } },
--   {
--     -- each linter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
--     command = "shellcheck",
--     ---@usage arguments to pass to the formatter
--     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
--     extra_args = { "--severity", "warning" },
--   },
--   {
--     command = "codespell",
--     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
--     filetypes = { "javascript", "python" },
--   },
-- }

-- Additional Plugins

lvim.plugins = {
  { "lunarvim/colorschemes" },
  { "tpope/vim-surround" },
  { "p00f/nvim-ts-rainbow" },
  { "folke/trouble.nvim", },
  { "francoiscabrol/ranger.vim" },
  -- { "edluffy/hologram.nvim",},
  { "jbyuki/venn.nvim" },
  { "epwalsh/obsidian.nvim" },
  {
    "phaazon/hop.nvim",
  },

  { "pest-parser/pest.vim" },
  { "folke/tokyonight.nvim" },
  -- {
  --   "folke/trouble.nvim",
  --   cmd = "TroubleToggle",
  -- },
  { "Mofiqul/vscode.nvim" },
  -- {"hrsh7th/cmp-nvim-lsp-signature-help"},
  -- {"hrsh7th/cmp-nvim-lsp-document-symbol"},
  { "decaycs/decay.nvim" },
  { "Mofiqul/vscode.nvim" },
}
lvim.builtin.treesitter.rainbow.enable = true
-- Autocommands (https://neovim.io/doc/user/autocmd.html)
-- vim.api.nvim_create_autocmd("BufEnter", {
--   pattern = { "*.json", "*.jsonc" },
--   -- enable wrap mode for json files only
--   command = "setlocal wrap",
-- })
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "zsh",
--   callback = function()
--     -- let treesitter use bash highlight for zsh files as well
--     require("nvim-treesitter.highlight").attach(0, "bash")
--   end,
-- })
lvim.builtin.which_key.mappings["r"] = {
  "<cmd>Ranger<CR>", "Ranger"
}

lvim.builtin.which_key.mappings["t"] = {
  name = "Diagnostics",
  t = { "<cmd>TroubleToggle<cr>", "trouble" },
  w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "workspace" },
  d = { "<cmd>TroubleToggle document_diagnostics<cr>", "document" },
  q = { "<cmd>TroubleToggle quickfix<cr>", "quickfix" },
  l = { "<cmd>TroubleToggle loclist<cr>", "loclist" },
  r = { "<cmd>TroubleToggle lsp_references<cr>", "references" },
}

lvim.builtin.which_key.mappings["b"]["d"] = { "<cmd>bd<cr>", "delete" }

-- require('hologram').setup({auto_display = true})
-- function HologramTest()
--   local Image = require('hologram.image')
--   local source = vim.fn.expand('~/Pictures/cafes.png')
--   local img = Image:new(source, {})
--   local buf = vim.api.nvim_get_current_buf()
--   img:display(1, 1, buf, {})
-- end
lvim.builtin.alpha.active = true

vim.opt.spell = false
vim.api.nvim_set_option('virtualedit', "block")
-- invoke :VBox on a block selection to have lines or block drawn
vim.o.timeoutlen = 300
require("nvim-treesitter.configs").setup({
  ensure_installed = { "markdown", "markdown_inline", ... },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = { "markdown" },
  },
})


-- Tree-sitter configuration
require 'nvim-treesitter.configs'.setup {
  -- If TS highlights are not enabled at all, or disabled via `disable` prop, highlighting will fallback to default Vim syntax highlighting
  highlight = {
    enable = true,
  },
}


vim.opt.conceallevel = 0
vim.opt.concealcursor = 'nc'


vim.api.nvim_create_autocmd("BufEnter", {
  command = "set nospell",
})


require("obsidian").setup({
  dir = "~/Documents/Obsidian/Notes",
  completion = {
    nvim_cmp = true, -- if using nvim-cmp, otherwise set to false
  }
})
vim.keymap.set(
  "n",
  "gf",
  function()
    if require('obsidian').util.cursor_on_markdown_link() then
      return "<cmd>ObsidianFollowLink<CR>"
    else
      return "gf"
    end
  end,
  { noremap = false, expr = true }
)


require 'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
vim.api.nvim_set_keymap("n", "j", ":HopChar2<cr>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-PageUp>", ":BufferLineCyclePrev<cr>", { silent = false })
vim.api.nvim_set_keymap("n", "<C-PageDown>", ":BufferLineCycleNext<cr>", { silent = false })

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.md" },
  callback = function()
    lvim.builtin.which_key.mappings["O"] = {
      name = "myWiki",
      ["j"] = { ":lua require 'telescope.builtin'.live_grep({ default_text = vim.fn.expand \"%:t:r\" })<cr>",
        "search backlinks" }
    }
  end
})

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.md" },
  callback = function()
    if vim.fn.expand("%:t") == "projects.md" then
      vim.api.nvim_buf_set_option(vim.fn.bufnr(), "filetype", "org")
    end
  end
})


--[[ vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = { "*.md" },
  callback = function()
    vim.api.nvim_command('silent! !plover -s plover_send_command suspend')
  end
})
vim.api.nvim_create_autocmd("InsertEnter", {
  pattern = { "*.md" },
  callback = function()
    vim.api.nvim_command('silent! !plover -s plover_send_command resume')
  end
})
 ]]

vim.api.nvim_create_user_command('SumColumn',
  "<line1>,<line2>!awk -F '|' '{print; sum+=$('<args>' + 1); columns+=\"| |\"} END { print columns '<args>' sum}'",
  { nargs = 1, range = "%" })

vim.api.nvim_set_keymap("n", "gx", "<cmd>execute '!firefox ' . shellescape(expand('<cfile>'), 1)<CR>", { silent = true })

vim.api.nvim_set_keymap("n", "gr",
  ":lua require'telescope.builtin'.lsp_references({layout_strategy='vertical',layout_config={width=0.99, height=0.99}})<cr>",
  { silent = true })


vim.api.nvim_set_keymap("n", "gt", ":lua require'telescope.builtin'.lsp_type_definitions{}<cr>", { silent = true })

-- lvim.lsp.buffer_mappings.normal_mode["gr"] = {  "<cmd>Telescope lsp_references<cr>", "Go to Definiton" }
lvim.lsp.buffer_mappings.normal_mode["gr"] = {
  ":lua require'telescope.builtin'.lsp_references({layout_strategy='vertical',layout_config={width=0.99, height=0.99}})<cr>",
  "Go to Definiton" }


vim.opt.list = true
lvim.builtin.indentlines.space_char_blankline = " "
lvim.builtin.indentlines.show_current_context = true
lvim.builtin.indentlines.show_current_context_start = true


-- vim.o.updatetime = 300
-- vim.wo.signcolumn = 'yes'
vim.o.updatetime = 30

-- ---see the full default list `:lua print(vim.inspect(_G))`
---reduce the vim scopes in lua,
---alias display table<string, string>
--[[
  display: key is concatenation of all the nested methods
          value is the doc/md string.
  eg "vim.opt.aw": "<doc string>"
]]

---use with `Redir lua=vim.tbl_keys(package.loaded)`
vim.api.nvim_create_user_command('Redir', function(ctx)
  local lines = vim.split(vim.api.nvim_exec(ctx.args, true), '\n', { plain = true })
  vim.cmd('new')
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  vim.opt_local.modified = false
end, { nargs = '+', complete = 'command' })

require('vscode').setup({
  -- Enable italic comment
  italic_comments = true,

  -- Disable nvim-tree background color
  disable_nvimtree_bg = true,

  -- Override colors (see ./lua/vscode/colors.lua)
  color_overrides = {
    vscBack = '#000000',
  },
})
T = require("nvim-treesitter.ts_utils")
function P(data)
  vim.print(vim.inspect(data))
end
