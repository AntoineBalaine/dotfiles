local lsp_helpers = {}

---@enum luals_err_codes
lsp_helpers.luals_err_codes = {
    ambiguity = "ambiguity-1",
    assignTypeMismatch = "assign-type-mismatch",
    duplicateIndex = "duplicate-index",
    emptyBlock = "empty-block",
    lowercaseGlobal = "lowercase-global",
    missingParam = "missing-parameter",
    missingReturn = "missing-return",
    missingRetVal = "missing-return-value",
    need = "need-check-nil",
    param = "param-type-mismatch",
    redefined = "redefined-local",
    redundantParam = "redundant-parameter",
    redundantVal = "redundant-value",
    unbalanced = "unbalanced-assignments",
    undefinedDocName = "undefined-doc-name",
    undefinedDocParam = "undefined-doc-param",
    undefinedField = "undefined-field",
    undefinedGlobal = "undefined-global",
    unsupportedSymbol = "unsupport-symbol",
    unusedFunction = "unused-function",
    unusedLocal = "unused-local"
}


---remove diagnostics that point to same line
---@private
---@param input_table Diagnostic[]
local function remove_duplicates(input_table)
    local seen = {}
    local result = {}

    for _, value in ipairs(input_table) do
        if not seen[value.lnum .. ""] then
            table.insert(result, value)
            seen[value.lnum .. ""] = true
        end
    end

    return result
end

---Get current buffer's number
---and get LSPclients for this buffer
---that have rename capability
---@return number|nil buf, LspClient[]|nil clients
function lsp_helpers.getBuf_getClients()
    local buf = vim.api.nvim_get_current_buf()
    ---@type LspClient[]
    local clients = vim.lsp.get_active_clients({ bufnr = buf })
    -- Clients must at least support rename, prepareRename is optional
    clients = vim.tbl_filter(function(client)
        return client.supports_method('textDocument/rename')
    end, clients)

    if not buf then return end
    if #clients == 0 then
        vim.notify('[LSP] no client for this buffer')
        return
    end
    return buf, clients
end

---get diagnostics for the current buffer
---@param ref_code luals_err_codes
---@return Diagnostic[]|nil, number|nil, LspClient[]|nil
lsp_helpers.getDiagnostics = function(ref_code)
    local buf, clients = lsp_helpers.getBuf_getClients()

    ---filter diagnostics by code
    local diags = vim.tbl_filter(function(diag)
        return (diag.code == ref_code and diag.bufnr == buf)
    end, vim.diagnostic.get())

    if #diags == 0 then
        vim.notify('[LSP] no diagnostics for this buffer')
        return
    end

    table.sort(diags, function(a, b)
        return a.lnum < b.lnum
    end)
    diags = remove_duplicates(diags)

    return diags, buf, clients
end

---@param diag Diagnostic
---@param buf number
---@param clients unknown[]
---@param new_name string
function lsp_helpers.renameVarToUpperCase(diag, buf, clients, new_name)
    client = clients[1]
    local lines = vim.api.nvim_buf_get_lines(buf, diag.lnum, diag.lnum + 1, false)
    local var_name = lines[1]:sub(diag.col + 1, diag.end_col)
    local new_name = var_name:gsub("^%l", string.upper)
    local request_obj = {
        textDocument = { uri = vim.uri_from_bufnr(buf or 0) },
        position = { line = diag.lnum, character = diag.col },
        newName = new_name
    }
    vim.lsp.buf.rename(new_name, { name = clients[1].name })
    -- clients[1].request("textDocument/rename", request_obj, vim.lsp.handlers['textDocument/rename'], buf)
end

return lsp_helpers
