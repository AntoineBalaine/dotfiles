function SetupQuery()
    local buf = vim.api.nvim_get_current_buf()
    local lang_tree = vim.treesitter.get_parser(buf, "lua")
    local ast = lang_tree:parse()
    local root = ast[1]:root()
    local query = vim.treesitter.query.parse(lang_tree:lang(), [[
        (function_declaration
            name: (identifier) @func.name
        )
    ]])
    for _, match in query:iter_matches(root, buf, 0, -1) do
        for k, node in pairs(match) do
            local text = vim.treesitter.get_node_text(node, buf)
            P(text)
        end
    end
end
