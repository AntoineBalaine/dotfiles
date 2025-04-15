return {
  "jbyuki/one-small-step-for-vimkind",
}

--[[
-- .nvim.lua
-- Vimkind config for plugin debugging

-- 1. Open a Neovim instance (server instance)
-- 2. Launch the DAP server with server
--     :lua require"osv".launch({port=8086})
-- 3. Open another Neovim instance (client instance )
-- 4. Open `myscript.lua` (client)
-- 5. Place a breakpoint using client
--     :lua require"dap".toggle_breakpoint()
-- 6. Connect the DAP client using client
--     :lua require"dap".continue()
-- 7. Run `myscript.lua` in the server instance
--     :luafile myscript.lua
-- 8. The breakpoint should hit and freeze the client

-- NVIM CONFIG --
local dap = require('dap')
dap.configurations.lua = {
    {
        type = 'nlua',
        request = 'attach',
        name = 'Attach to running Neovim instance',
    },
}

dap.adapters.nlua = function(callback, config)
    callback({ type = 'server', host = config.host or '127.0.0.1', port = config.port or 8086 })
end

-- VSCODE CONFIG --
-- if you prefer using vscode’s debugger client.
-- .vscode/launch.json
-- {
--   "version": "0.2.0",
--   "configurations": [
--     {
--       "name": "attach",
--       "type": "lua",
--       "request": "attach",
--       "stopOnEntry": true,
--       "address": "127.0.0.1:8086"
--     }
--   ]
-- }

function LaunchVSCodeDebugSession()
    -- Step 1: Start the debug server in current Neovim instance
    require('osv').launch({ port = 8086 })
    print('Debug server started on port 8086')

    -- Step 2: Get the path to your project (where launch.json is located)
    local current_file = vim.fn.expand('%:p')
    local project_path = vim.fn.getcwd()
    local current_line = vim.fn.line('.')

    -- Step 3: Launch VSCode with the project and start debugging
    local vscode_cmd
    if vim.fn.has('win32') == 1 then
        -- Windows command
        vscode_cmd =
            string.format('start code "%s" "%s" --goto "%s:%d"', project_path, current_file, current_file, current_line)
    elseif vim.fn.has('mac') == 1 then
        -- macOS command
        vscode_cmd = string.format(
            'open -a "Visual Studio Code" "%s" --args "%s" --goto "%s:%d"',
            current_file,
            project_path,
            current_file,
            current_line
        )
    else
        -- Linux command
        vscode_cmd =
            string.format('code "%s" "%s" --goto "%s:%d"', project_path, current_file, current_file, current_line)
    end

    -- Step 4: Execute the command
    vim.fn.system(vscode_cmd)

    print('VSCode debugger launched. Set breakpoints and run your plugin commands in this Neovim instance.')
end

-- Create a command
vim.api.nvim_create_user_command('LaunchVSCodeDebug', LaunchVSCodeDebugSession, {})

--]]
