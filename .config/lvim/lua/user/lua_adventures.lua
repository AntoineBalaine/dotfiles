local lsp_helpers = require("user.lsp_helpers")
function CallReaperAction()
    vim.cmd("silent exec '!reaper -nonewinst /home/antoine/.config/lvim/lua/user/reaperscript.lua &'")
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

---start by making sure that your luarc.json ignores all other errors
function Find_all_undefined_globals()
    local ref_code = lsp_helpers.luals_err_codes.undefinedGlobal
    local diags, buf, clients = lsp_helpers.getDiagnostics(ref_code)
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
    local diags, buf, clients = lsp_helpers.getDiagnostics(ref_code)
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

function UndefDiags()
    local undef_code = "undefined-global"
    local undef_diags, _, _ = lsp_helpers.getDiagnostics(undef_code)
    P(#undef_diags)
end

function RemoveLineAtUnusedDiag()
    UndefDiags()
    local ref_code = lsp_helpers.luals_err_codes.unusedLocal
    local diags, buf, clients = lsp_helpers.getDiagnostics(ref_code)
    if not diags or not buf or not clients then return end
    local text = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

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
