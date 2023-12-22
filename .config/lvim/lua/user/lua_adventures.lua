function CallReaperAction()
    vim.cmd("silent exec '!reaper -nonewinst /home/antoine/.config/lvim/lua/user/reaperscript.lua &'")
end

---@param diag table
---@param buf number
---@param clients table
local function renameVar(diag, buf, clients)
    local lines = vim.api.nvim_buf_get_lines(buf, diag.lnum, diag.lnum + 1, false)
    local var_name = lines[1]:sub(diag.col + 1, diag.end_col)
    local new_name = var_name:gsub("^%l", string.upper)
    local request_obj = {
        textDocument = { uri = vim.uri_from_bufnr(buf or 0) },
        position = { line = diag.lnum, character = diag.col },
        newName = new_name
    }

    clients[1].request("textDocument/rename", request_obj, vim.lsp.handlers['textDocument/rename'], buf)
end

---@param ref_code string
---@return Diagnostic[]|nil, number|nil, table|nil
local function getDiagnostics(ref_code)
    local buf = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_active_clients({ bufnr = buf })
    -- Clients must at least support rename, prepareRename is optional
    clients = vim.tbl_filter(function(client)
        return client.supports_method('textDocument/rename')
    end, clients)

    if not buf then return end
    if not clients then return end
    if #clients == 0 then
        vim.notify('[LSP] no client for this buffer')
        return
    end
    ---filter diagnostics by code
    local diags = vim.tbl_filter(function(diag)
        return diag.code == ref_code
    end, vim.diagnostic.get())

    return diags, buf, clients
end

---take the first diagnosticc in the file,
---and rename the variable that is being pointed out
---by upper-casing its first letter.
function RenameAllLowerCaseVars()
    local ref_code = "lowercase-global"
    local diags, buf, clients = getDiagnostics(ref_code)
    if not diags or not buf or not clients then return end
    for _, k in ipairs(diags) do
        renameVar(k, buf, clients)
    end
end

function F_update()
    vim.cmd("source %")
    RenameAllLowerCaseVars()
end

function List_luals_err_codes()
    ---@type Diagnostic[]
    local diags = vim.diagnostic.get()
    -- iterate all diagnostics and get all codes
    local codes = {}
    for _, diag in ipairs(diags) do
        codes[diag.code] = true
    end
    -- reduce codes to an array
    local codes_arr = {}
    for k, _ in pairs(codes) do
        table.insert(codes_arr, k)
    end
    pipe(codes_arr)
end

---@enum luals_err_codes
local luals_err_codes = {
    "ambiguity-1",
    "assign-type-mismatch",
    "duplicate-index",
    "empty-block",
    "lowercase-global",
    "missing-parameter",
    "missing-return",
    "missing-return-value",
    "need-check-nil",
    "param-type-mismatch",
    "redefined-local",
    "redundant-parameter",
    "redundant-value",
    "unbalanced-assignments",
    "undefined-doc-name",
    "undefined-doc-param",
    "undefined-field",
    "undefined-global",
    "unsupport-symbol",
    "unused-function",
    "unused-local"
}


---start by making sure that your luarc.json ignores all other errors
function Find_all_undefined_globals()
    local ref_code = "undefined-global"
    local diags, buf, clients = getDiagnostics(ref_code)
    if not diags or not buf or not clients then return end
    --- reduce diags to a table of unique names
    local names = {}
    for _, diag in ipairs(diags) do
        -- example message = "Undefined global `ReadFXFile`.",
        -- remove anything except what's between the backticks
        if (not diag.message) then goto continue end
        local t = diag.message:match("`[%a%d]+`")
        if not t then goto continue end
        local var_name = t:gsub("`", "")
        if names[var_name] == nil then
            --why is this code failing?
            names[var_name] = 1
        else
            names[var_name] = names[var_name] + 1
        end
        ::continue::
    end
    pipe(names)
end

---@param bufnr number
---@param diagnostic Diagnostic
local function replace_chars_with_diagnostics(bufnr, diagnostic)
    local start_line = diagnostic.lnum -- Convert 0-indexed to 1-indexed
    local start_col = diagnostic.col   -- Convert 0-indexed to 1-indexed
    local end_line = diagnostic.end_lnum and diagnostic.end_lnum or start_line
    local end_col = diagnostic.end_col and diagnostic.end_col or start_col

    -- Replace the characters with a placeholder string (e.g., "FIX")
    vim.api.nvim_buf_set_text(bufnr, start_line, start_col, end_line, end_col, { "_" })
end

function Find_all_unused_V()
    local ref_code = "unused-local"
    local diags, buf, clients = getDiagnostics(ref_code)
    if not diags or not buf or not clients then return end
    --- reduce diags to a table of unique names
    for _, diag in ipairs(diags) do
        -- example message = "Undefined global `ReadFXFile`.",
        -- remove anything except what's between the backticks
        if (not diag.message) then goto continue end
        local t = diag.message:match("Unused local `rv`")
        if not t then goto continue end
        ---substitute the variable name by an underscore in the buffer
        replace_chars_with_diagnostics(buf, diag)

        ::continue::
    end
end

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

function UndefDiags()
    local undef_code = "undefined-global"
    local undef_diags, _, _ = getDiagnostics(undef_code)
    P(#undef_diags)
end

function RemoveLineAtUnusedDiag()
    UndefDiags()
    local ref_code = "unused-local"
    local diags, buf, clients = getDiagnostics(ref_code)
    if not diags or not buf or not clients then return end
    local text = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    table.sort(diags, function(a, b)
        return a.lnum < b.lnum
    end)
    diags = remove_duplicates(diags)

    for i = #diags, 1, -1 do
        local diag = diags[i]
        if (not diag.message) then goto continue end
        ---find if there is a comma in the line
        local line = text[diag.lnum + 1]
        --- TODO double check this thing
        local t = line:match("[,][^=]*=")
        if t then goto continue end
        ---remove the line
        table.remove(text, diag.lnum + 1)
        ::continue::
    end
    vim.api.nvim_buf_set_lines(buf, 0, -1, true, text)
end
