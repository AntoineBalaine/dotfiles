local lsp_helpers = require("user.lsp_helpers")

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

    P(#diags .. " diagnostics")
    P(idx .. " index")
    local diag = diags[idx]
    if not diag then
        if idx ~= #diags then vim.notify('[LSP] no diagnostic here') end
        return
    end
    local lines = vim.api.nvim_buf_get_lines(diag.bufnr, diag.lnum, diag.lnum + 1, false)
    ---pull var name from line and upper case it
    local name = lines[1]:sub(diag.col + 1, diag.end_col)
    local new_name = name:gsub("^%l", string.upper)
    local params = {
        textDocument = { uri = vim.uri_from_bufnr(diag.bufnr or 0) },
        position = { line = diag.lnum, character = diag.col },
        newName = new_name
    }

    client.request('textDocument/rename', params, function(...)
        P("rename callback")
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
