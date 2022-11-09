lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true
lvim.builtin.treesitter.highlight.additional_vim_regex_highlighting = { "markdown" }
lvim.builtin.treesitter.rainbow.enable = true

local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.abc = {
  install_info = {
    url = "~/Documents/Experiments/Abcjs/tree-sitter-abc", -- local path or git repo
    files = { "src/parser.c" },
    -- optional entries:
    branch = "main", -- default branch in case of git repo if different from master
    generate_requires_npm = false, -- if stand-alone parser without npm dependencies
    requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
  },
  filetype = "abc", -- if filetype does not match the parser name
}

parser_config.ziggy = {
  install_info = {
    url = "https://github.com/kristoff-it/ziggy",
    includes = { "tree-sitter-ziggy/src" },
    files = { "tree-sitter-ziggy/src/parser.c" },
    branch = "main",
    generate_requires_npm = false,
    requires_generate_from_grammar = false,
  },
  filetype = "ziggy",
}

parser_config.ziggy_schema = {
  install_info = {
    url = "https://github.com/kristoff-it/ziggy",
    files = { "tree-sitter-ziggy-schema/src/parser.c" },
    branch = "main",
    generate_requires_npm = false,
    requires_generate_from_grammar = false,
  },
  filetype = "ziggy-schema",
}

parser_config.supermd = {
  install_info = {
    url = "https://github.com/kristoff-it/supermd",
    includes = { "tree-sitter/supermd/src" },
    files = {
      "tree-sitter/supermd/src/parser.c",
      "tree-sitter/supermd/src/scanner.c",
    },
    branch = "main",
    generate_requires_npm = false,
    requires_generate_from_grammar = false,
  },
  filetype = "supermd",
}

parser_config.supermd_inline = {
  install_info = {
    url = "https://github.com/kristoff-it/supermd",
    includes = { "tree-sitter/supermd-inline/src" },
    files = {
      "tree-sitter/supermd-inline/src/parser.c",
      "tree-sitter/supermd-inline/src/scanner.c",
    },
    branch = "main",
    generate_requires_npm = false,
    requires_generate_from_grammar = false,
  },
  filetype = "supermd_inline",
}

parser_config.superhtml = {
  install_info = {
    url = "https://github.com/kristoff-it/superhtml",
    includes = { "tree-sitter-superhtml/src" },
    files = {
      "tree-sitter-superhtml/src/parser.c",
      "tree-sitter-superhtml/src/scanner.c",
    },
    branch = "main",
    generate_requires_npm = false,
    requires_generate_from_grammar = false,
  },
  filetype = "superhtml",
}

vim.filetype.add({
  extension = {
    smd = "supermd",
    shtml = "superhtml",
    ziggy = "ziggy",
    ["ziggy-schema"] = "ziggy_schema",
  },
})

vim.api.nvim_set_keymap("n", "h", "", { silent = true })

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
    select = {
      enable = true,
      keymaps = {
        ["xf"] = "@function.outer",
        ["af"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["ib"] = "@block.inner",
        ["ab"] = "@block.outer",
      },
    },
  },
  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = "o",
      toggle_hl_groups = "i",
      toggle_injected_languages = "t",
      toggle_anonymous_nodes = "a",
      toggle_language_display = "I",
      focus_language = "f",
      unfocus_language = "F",
      update = "R",
      goto_node = "<cr>",
      show_help = "?",
    },
  },
  query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = { "BufWrite", "CursorHold" },
  },
}

require("nvim-treesitter.configs").setup(conf)
return conf
