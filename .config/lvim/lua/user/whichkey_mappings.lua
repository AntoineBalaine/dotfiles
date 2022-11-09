lvim.builtin.which_key.mappings["t"] = {
    name = "Diagnostics",
    t = { "<cmd>TroubleToggle<cr>", "trouble" },
    w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "workspace" },
    d = { "<cmd>TroubleToggle document_diagnostics<cr>", "document" },
    q = { "<cmd>TroubleToggle quickfix<cr>", "quickfix" },
    l = { "<cmd>TroubleToggle loclist<cr>", "loclist" },
    r = { "<cmd>TroubleToggle lsp_references<cr>", "references" },
}

local refactor_nvim = require('refactoring')
-- Extract block supports only normal mode
lvim.builtin.which_key.vmappings["r"] = {
    name = "Refactor",
    {
        f = { function() refactor_nvim.refactor('Extract Function') end, "Extract Function" },
        F = { function() refactor_nvim.refactor('Extract Function To File') end, "Extract Function To File" },
        v = { function() refactor_nvim.refactor('Extract Variable') end, "Extract Variable" },
        i = { function() refactor_nvim.refactor('Inline Variable') end, "Inline Variable" },
    }
}
lvim.builtin.which_key.mappings["r"] = {
    name = "Refactor",
    f = { function() refactor_nvim.refactor('Inline Function') end, "Inline Function" },
    v = { function() refactor_nvim.refactor('Inline Variable') end, "Inline Variable" },
    b = { function() refactor_nvim.refactor('Extract Block') end, "Extract Block" },
    B = { function() refactor_nvim.refactor('Extract Block To File') end, "Extract Block To File" },
}
