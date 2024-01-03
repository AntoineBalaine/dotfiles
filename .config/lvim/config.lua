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
-- to disable icons and use a minimalist setup, uncomment the following
-- lvim.use_icons = false
lvim.builtin.which_key.mappings["b"]["d"] = { "<cmd>bd<cr>", "delete" }
lvim.builtin.alpha.active = true
vim.opt.spell = false
vim.api.nvim_set_option('virtualedit', "block")
vim.opt.conceallevel = 0
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

vim.api.nvim_create_user_command('SumColumn',
    "<line1>,<line2>!awk -F '|' '{print; sum+=$('<args>' + 1); columns+=\"| |\"} END { print columns '<args>' sum}'",
    { nargs = 1, range = "%" })

vim.api.nvim_set_keymap("n", "gx", "<cmd>execute '!firefox ' . shellescape(expand('<cfile>'), 1)<CR>", { silent = true })



vim.api.nvim_create_autocmd("BufEnter", {
    pattern = { "*.tex" },
    callback = function()
        lvim.format_on_save = true
        require("lvim.lsp.manager").setup("texlab")
        lvim.builtin.which_key.mappings["x"] = {
            name = "Tex",
            ["c"] = { ":VimtexCompile<cr>",
                "Compile doc", { silent = true } }
        }
    end
})

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = { "*.json" },
    callback = function()
        lvim.format_on_save = true
        require("lvim.lsp.manager").setup("jsonls")
    end
})

--[[
--for an example of full-on crazy-complete lunarvim config:
--visit https://github.com/abzcoding/lvim
--]]
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = { "/home/antoine/.config/REAPER/Scripts/BryanChi/BryanChi-FX-Devices/**/*" },
    callback = function()
        lvim.format_on_save = false
    end
})


vim.api.nvim_create_autocmd("BufEnter", {
    pattern = { "*.lua" },
    callback = function()
        require 'reaper-nvim'.setup()
        vim.g.reaper_fuzzy_command = "fzf"
    end
})
