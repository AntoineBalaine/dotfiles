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
  end

  dap.configurations.lua = {
    {
      type = "nlua",
      request = "attach",
      name = "Neovim attach",
      host = function()
        local value = vim.fn.input "Host [127.0.0.1]: "
        if value ~= "" then
          return value
        end
        return "127.0.0.1"
      end,
      port = function()
        local val = tonumber(vim.fn.input "Port: ")
        assert(val, "Please provide a port number")
        return val
      end,
    },
  }
  dap.adapters.nlua = function(callback, config)
    callback { type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 }
  end

  local custom_adapter = "pwa-node-custom"
  dap.adapters[custom_adapter] = function(cb, config)
    if config.preLaunchTask then
      local async = require "plenary.async"
      local notify = require("notify").async

      async.run(function()
        ---@diagnostic disable-next-line: missing-parameter
        notify("Running [" .. config.preLaunchTask .. "]").events.close()
      end, function()
        vim.fn.system(config.preLaunchTask)
        config.type = "pwa-node"
        dap.run(config)
      end)
    end
  end

  dap.adapters.node2 = {
    type = 'executable',
    command = 'node',
    args = { os.getenv('HOME') .. '/home/antoine/.local/share/lvim/mason/packages/node-debug2-adapter/out/src/extension.js' },
  }

  dap.configurations.typescript = {
    --[[
    {
      type = "node2",
      name = "node attach",
      request = "attach",
      program = "${file}",
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
      protocol = "inspector",
    },
    {
      name = "Launch",
      type = "pwa-node",
      request = "launch",
      program = "${file}",
      rootPath = "${workspaceFolder}",
      cwd = "${workspaceFolder}",
      sourceMaps = true,
      skipFiles = { "<node_internals>/**" },
      protocol = "inspector",
      console = "integratedTerminal",
    },
    {
      name = "Attach to node process",
      type = "pwa-node",
      request = "attach",
      rootPath = "${workspaceFolder}",
      processId = require("dap.utils").pick_process,
    },
    ]]
    {
      type = "pwa-node",
      request = "launch",
      name = "Debug Jest Tests",
      -- trace = true, -- include debugger info
      runtimeExecutable = "node",
      runtimeArgs = {
        "./node_modules/jest/bin/jest.js",
        "--runInBand",
      },
      rootPath = "${workspaceFolder}",
      cwd = "${workspaceFolder}",
      console = "integratedTerminal",
      internalConsoleOptions = "neverOpen",
    },
    {
      name = "Launch via PNPM",
      request = "launch",
      runtimeArgs = { "run-script", "test" },
      runtimeExecutable = "pnpm",
      skipFiles = { "<node_internals>/**" },
      type = "node2",
    }
  }

  dap.configurations.typescriptreact = dap.configurations.typescript
  dap.configurations.javascript = dap.configurations.typescript
  dap.configurations.javascriptreact = dap.configurations.typescript
end

return dap_config
