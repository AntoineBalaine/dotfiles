myglobal = ":w"
local function getAST()
    -- get current buffer
    local bufnr = vim.api.nvim_get_current_buf()
    local parser = vim.treesitter.get_parser(bufnr, "lua")
    local tree = parser:parse()
    local root = tree[1]:root()
    return bufnr, root
end

local queries = {}
---Define a function to find occurences of a variable in the current file
---@param variable_name string
function queries.has_global(variable_name)
    local bufnr, root = getAST()

    local query_start = [[
(assignment_statement
 (variable_list
   (identifier) @name (#eq? @name "]]
    local fullQuery = query_start .. variable_name .. '")))'
    P(fullQuery)
    local query = vim.treesitter.query.parse('lua', fullQuery)

    for _, captures, _ in query:iter_matches(root, bufnr, 0, -1) do
        if #captures > 1 then
            return true
        end
    end
    return false
end

---@class LineRange
---@field startLine number
---@field endLine number

---Find all global assignments in the current buffer
---@param line_range? LineRange line range to search in
---@return TSNode[]
function queries.findGlobals(line_range)
    local bufnr, root = getAST()
    local nodes = {}

    local query_str = [[
(assignment_statement
    (variable_list
        (identifier) @name)
)
]]
    local query = vim.treesitter.query.parse('lua', query_str)
    for _, match, _ in query:iter_matches(root, bufnr, 0, -1) do
        for _, node in ipairs(match) do
            local name = vim.treesitter.get_node_text(node, bufnr)
            local startrow, _, endrow, _ = vim.treesitter.get_node_range(node)
            if line_range then
                if startrow >= line_range.startLine and line_range.endLine >= endrow then
                    table.insert(nodes, node)
                    -- goto continue
                end
            else
                table.insert(nodes, node)
            end
        end
    end
    return nodes
end

return queries
