local lsp_helpers = require("user.lsp_helpers")
local ts_query = require("user.tree-sitter_queries")

---Make sure to add double escape to string regex calls
-- vim.fn.systemlist('rg "\\bmsg\\b"')
---@param regex string
local function callRipGrep(regex)
    return vim.fn.systemlist('rg ' .. regex)
end

---@class LspClient
---@field handlers unknown
---@field offset_encoding unknown
---@field request unknown
---@field supports_method unknown

---@param idx number
---@param diags Diagnostic[]
---@param buf number
---@param client LspClient
local function tryToRename(buf, client, idx, diags)
    -- P(client.handlers['textDocument/rename'])

    local diag = diags[idx]
    if not diag then
        if idx ~= #diags then vim.notify('[LSP] no diagnostic here') end
        return
    end
    local lines = vim.api.nvim_buf_get_lines(diag.bufnr, diag.lnum, diag.lnum + 1, false)
    ---pull var name from line and upper case it
    local name = lines[1]:sub(diag.col + 1, diag.end_col)
    local new_name = name:gsub("^%l", string.upper)
    ---Does the new name already exist in the project?
    if ts_query.has_global(new_name) then
        new_name = new_name .. '_CONFLICT'
    end
    local params = {
        textDocument = { uri = vim.uri_from_bufnr(diag.bufnr or 0) },
        position = { line = diag.lnum, character = diag.col },
        newName = new_name
    }

    client.request('textDocument/rename', params, function(...)
        local handler = client.handlers['textDocument/rename']
            or vim.lsp.handlers['textDocument/rename']
        handler(...)
        tryToRename(buf, client, idx + 1, diags)
    end, buf)
end

---take the lowercase globals in the file,
---and rename each variable that is being pointed out
---by upper-casing its first letter.
function RenameAllLowerCaseVars()
    local ref_code = lsp_helpers.luals_err_codes.lowercaseGlobal
    local diags, buf, clients = lsp_helpers.getDiagnostics(ref_code)
    if not buf or not clients or not diags then
        vim.notify('[LSP] no client for this buffer')
        return
    else
        assert(#diags ~= 0, 'No diagnostics in buffer')
        assert(#clients ~= 0, 'No clients')
    end
    tryToRename(buf, clients[1], 1, diags)
end

---@param bufnr number
---@param prefix string
---@param nodes TSNode[]
---@param client LspClient
function AddPrefixToTSNodeVariable(bufnr, client, prefix, nodes, idx)
    local node = nodes[idx]
    local new_name = prefix .. vim.treesitter.get_node_text(node, bufnr)
    local startrow, startcol, endrow, _ = vim.treesitter.get_node_range(node)
    local params = {
        textDocument = { uri = vim.uri_from_bufnr(bufnr or 0) },
        position = { line = startrow, character = startcol },
        newName = new_name
    }
    client.request('textDocument/rename', params, function(...)
        local handler = client.handlers['textDocument/rename']
            or vim.lsp.handlers['textDocument/rename']
        handler(...)
        AddPrefixToTSNodeVariable(bufnr, client, prefix, nodes, idx + 1)
    end, bufnr)
end

---@param line_range LineRange
function findAllGlobalsInFile(line_range)
    local nodes = ts_query.findGlobals(line_range)
    local bufnr, clients = lsp_helpers.getBuf_getClients()
    if not bufnr or not clients then return end
    AddPrefixToTSNodeVariable(bufnr, clients[1], "FxdCtx.", nodes, 1)
end
