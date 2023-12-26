local lsp_helpers = require("user.lsp_helpers")

---@alias cursorPos {lnum:number, col:number}

---@param pos cursorPos|nil
local function diagnostic_move_pos(pos)
    local win_id = vim.api.nvim_get_current_win()

    if not pos then
        vim.api.nvim_echo({ { 'No more valid diagnostics to move to', 'WarningMsg' } }, true, {})
        return
    end

    vim.api.nvim_win_call(win_id, function()
        -- Save position in the window's jumplist
        vim.cmd("normal! m'")
        vim.api.nvim_win_set_cursor(win_id, { pos.lnum + 1, pos.col })
        -- Open folds under the cursor
        vim.cmd('normal! zv')
    end)
end

---@param position cursorPos
---@param search_forward boolean
---@param refcode luals_err_codes
local function next_diagnostic(position, search_forward, refcode)
    local diags = lsp_helpers.getDiagnostics(refcode)
    if not diags then return end
    if search_forward then
        for _, diag in ipairs(diags) do
            if diag.lnum > position.lnum or (diag.lnum == position.lnum and diag.col >= position.col) then
                return diag
            end
        end
    else
        for i = #diags, 1, -1 do
            local diag = diags[i]
            if diag.lnum < position.lnum or (diag.lnum == position.lnum and diag.col <= position.col) then
                return diag
            end
        end
    end
end



--- Get the next/prev diagnostic closest to the cursor position.
---
---@param refcode luals_err_codes
---@param search_forward boolean
---@return Diagnostic|nil Next_diagnostic
local function get_next(refcode, search_forward)
    local win_id = vim.api.nvim_get_current_win()
    local cursor_position = vim.api.nvim_win_get_cursor(win_id)
    local to_lsp_pos = { lnum = cursor_position[1], col = cursor_position[2] }
    return next_diagnostic(to_lsp_pos, search_forward, refcode)
end


---@param refcode luals_err_codes
---@param search_forward boolean
---@return cursorPos|nil
local function get_next_pos(refcode, search_forward)
    local next = get_next(refcode, search_forward)
    if not next then
        return nil
    end

    return { lnum = next.lnum, col = next.col } ---@type cursorPos
end

---@param refcode luals_err_codes
---@param search_forward boolean
local function goToNextRefCode(refcode, search_forward)
    return diagnostic_move_pos(get_next_pos(refcode, search_forward))
end


function GoToNextUnusedLocal()
    local ref_code = lsp_helpers.luals_err_codes.unusedLocal
    local search_forward = true
    goToNextRefCode(ref_code, search_forward)
end

function GoToPrevUnusedLocal()
    local ref_code = lsp_helpers.luals_err_codes.unusedLocal
    local search_forward = false
    goToNextRefCode(ref_code, search_forward)
end

local L_map = lvim.builtin.which_key.mappings.l
-- L_map.j = { "<cmd>lua GoToNextUnusedLocal()<cr>", "next unused local" }
-- L_map.k = { "<cmd>lua GoToPrevUnusedLocal()<cr>", "prev unused local" }
lvim.builtin.which_key.mappings.l = L_map
