local dap_config = {}
local adapters_path =
".local/share/lunarvim/site/pack/lazy/opt/mason-nvim-dap.nvim/lua/mason-nvim-dap/mappings/adapters"

dap_config.config = function()
    local mason_path = vim.fn.glob(vim.fn.stdpath "data" .. "/mason/")
    local function sep_os_replacer(str)
        local result = str
        local path_sep = package.config:sub(1, 1)
        result = result:gsub("/", path_sep)
        return result
    end
    local join_path = require("lvim.utils").join_paths

    local status_ok, dap = pcall(require, "dap")
    if not status_ok then
        return
    else
        dap.configurations.lua = {
            {
                type = 'nlua',
                request = 'attach',
                name = "Attach to running Neovim instance",
            }
        }

        dap.adapters.nlua = function(callback, config)
            callback({ type = 'server', host = config.host or "127.0.0.1", port = config.port or 8086 })
        end
        -- dap.adapters["local-lua"] = {
        --     type = "executable",
        --     command = "node",
        --     args = {
        --         "/home/antoine/Documents/Experiments/lua/local-lua-debugger-vscode/extension/debugAdapter.js"
        --     },
        --     enrich_config = function(config, on_config)
        --         if not config["extensionPath"] then
        --             local c = vim.deepcopy(config)
        --             -- 💀 If this is missing or wrong you'll see
        --             -- "module 'lldebugger' not found" errors in the dap-repl when trying to launch a debug session
        --             c.extensionPath = "/home/antoine/Documents/Experiments/lua/local-lua-debugger-vscode/"
        --             on_config(c)
        --         else
        --             on_config(config)
        --         end
        --     end,
        -- }
    end

    -- dap.configurations.lua = {
    --     {
    --         type = "local-lua",
    --         request = "launch",
    --         name = "Neovim attach",
    --         -- host = function()
    --         --     local value = vim.fn.input "Host [127.0.0.1]: "
    --         --     if value ~= "" then
    --         --         return value
    --         --     end
    --         --     return "127.0.0.1"
    --         -- end,
    --         -- port = function()
    --         --     local val = tonumber(vim.fn.input "Port: ")
    --         --     assert(val, "Please provide a port number")
    --         --     return val
    --         -- end,
    --     },
    -- }
end

return dap_config
