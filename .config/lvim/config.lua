require("mason-registry")
require("neodev").setup({})
require("user.tree-sitter_config")
lvim.plugins = {
    { "Mofiqul/vscode.nvim" },
    { "tpope/vim-surround", },
    { "p00f/nvim-ts-rainbow" },
    { "folke/trouble.nvim", },
    { "francoiscabrol/ranger.vim" },
    { "jbyuki/venn.nvim" },
    { "epwalsh/obsidian.nvim" },
    { "phaazon/hop.nvim", },
    { "pest-parser/pest.vim" },
    { "nvim-treesitter/playground" },
    { "folke/tokyonight.nvim" },
    { "lervag/vimtex" },
    { "davidgranstrom/osc.nvim" },
    { "madskjeldgaard/reaper-nvim" },
    { "ThePrimeagen/refactoring.nvim" },
    { "bluz71/vim-moonfly-colors" },
    { "nvim-treesitter/nvim-treesitter-textobjects" },
    { "github/copilot.vim" },
    { "APZelos/blamer.nvim" },
    { "junegunn/fzf" },
    { "jay-babu/mason-nvim-dap.nvim" },
    { "rcarriga/nvim-dap-ui" },
    { "ravenxrz/DAPInstall.nvim" },
    { "jbyuki/one-small-step-for-vimkind" }, --https://github.com/jbyuki/one-small-step-for-vimkind/blob/94b06d81209627d0098c4c5a14714e42a792bf0b/doc/osv.txt#L44-L69
}
require("user.theme")
require("user.whichkey_mappings")
require("user.helpers")
require("user.lua_adventures")
require("user.lsp_refactors")
require("user.lsp_rg_calls")
require("lvim.lsp.manager").setup("lua_ls", {})
require("lvim.lsp.manager").setup("tsserver", {})
require('hop').setup { keys = 'etovxqpdygfblzhckisuran' }
require("user.obsidian")
-- require("user.tree-sitter_queries")
require("dap-install").setup({
    installation_path = vim.fn.stdpath("data") .. "/dapinstall/",
    verbosely_call_debuggers = true,
})
-- require("mason-nvim-dap").setup()


-- general
lvim.log.level = "warn"
lvim.format_on_save = false
lvim.colorscheme = "vscode"
-- to disable icons and use a minimalist setup, uncomment the following
-- lvim.use_icons = false

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
vim.g.maplocalleader = ","
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
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
-- lvim.lsp.installer.setup.ensure_installed = {
--     "sumeko_lua",
--     "jsonls",
-- }
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
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pyright", opts)

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
  {"tpope/vim-surround"},
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
  {"folke/tokyonight.nvim"},
  -- {
  --   "folke/trouble.nvim",
  --   cmd = "TroubleToggle",
  -- },
  {"Mofiqul/vscode.nvim"},
-- {"hrsh7th/cmp-nvim-lsp-signature-help"},
-- {"hrsh7th/cmp-nvim-lsp-document-symbol"},
{"decaycs/decay.nvim"},
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


vim.opt.conceallevel = 2
vim.opt.concealcursor = 'nc'
---setup zathura and tectonic for working with latex
vim.g.vimtex_view_method = "zathura"
vim.g.vimtex_compiler_method = "tectonic"
vim.g.vimtex_compiler_cleanup = 1
lvim.builtin.terminal.open_mapping = "<c-t>"
lvim.builtin.dap.active = true -- change this to enable/disable debugging
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

if lvim.builtin.dap.active then
    require("user.dap").config()
    ---add a keymap for running the current file in vimKind
    local debugCmd = ":lua require(\"osv\").run_this({lvim=true})<cr>"
    local Debug_map = lvim.builtin.which_key.mappings.d
    Debug_map.v = { debugCmd, "vimKind run this" }
    lvim.builtin.which_key.mappings.d = Debug_map
end

vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.keymap.set('i', '<C-h>', 'copilot#Accept("<CR>")', {
    expr = true,
    replace_keycodes = false
})

---enable git blame
vim.g.blamer_enabled = false
vim.g.blamer_delay = 100
vim.cmd("highlight Blamer guifg=grey")

-- Which fuzzy finder to use with reaper-nvim: Can be either "fzf" or "skim"
vim.g.reaper_fuzzy_command = "fzf"
-- Target port of the Reaper session receiving these osc messages
vim.g.reaper_target_port = 8000
-- Target ip
vim.g.reaper_target_ip = "127.0.0.1"
-- Browser command used for opening links
vim.g.reaper_browser_command = "firefox"

vim.api.nvim_set_keymap("n", "j", ":HopChar2<cr>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-PageUp>", ":BufferLineCyclePrev<cr>", { silent = false })
vim.api.nvim_set_keymap("n", "<C-PageDown>", ":BufferLineCycleNext<cr>", { silent = false })

-- vim.cmd [[:map <F5> :Gitsigns next_hunk<CR>]]
-- use vim.lsp to jump to next diagnostic
vim.cmd [[:map <F9> :lua vim.diagnostic.goto_next()<CR>]]
vim.api.nvim_set_keymap("n", "<F8>",
    "lua function() vim.lsp.diagnostic.goto_next({ max = vim.diagnostic.severity.ERROR, min = vim.diagnostic.severity.HINT }) end <CR>",
    { silent = false })

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

---Steno commands for working with plover.
---Enable the steno in insert mode, and disable it in normal mode
vim.api.nvim_create_autocmd("InsertLeave", {
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

vim.api.nvim_set_keymap("n", "gr", ":lua require'telescope.builtin'.lsp_references({layout_strategy='vertical',layout_config={width=0.99, height=0.99}})<cr>", { silent = true })
vim.api.nvim_set_keymap("n", "gt", ":lua require'telescope.builtin'.lsp_type_definitions{}<cr>", { silent = true })

vim.opt.list = true
lvim.builtin.indentlines.space_char_blankline = " "
lvim.builtin.indentlines.show_current_context = true
lvim.builtin.indentlines.show_current_context_start = true


-- vim.o.updatetime = 300
-- vim.wo.signcolumn = 'yes'
vim.o.updatetime = 30
