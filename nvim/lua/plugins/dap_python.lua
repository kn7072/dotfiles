-- nvim-dap is a Debug Adapter Protocol client implementation for Neovim.
-- https://github.com/mfussenegger/nvim-dap
-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
local dap = require("dap")
-- Путь к Python из Mason, где установлен debugpy - именно туда его устновил mason - это сервер
local debugpy_adapter_path = vim.fn.stdpath("data") ..
                                 "/mason/packages/debugpy/venv/bin/python"

local pythonPath = function()
    -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
    -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
    -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
    local cwd = vim.fn.getcwd()
    local interpreter = ""
    if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
        interpreter = cwd .. "/venv/bin/python"
    elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
        interpreter = cwd .. "/.venv/bin/python"
    else
        -- системный
        interpreter = "python3"
    end
    require("notify")("interpreter is " .. interpreter)
    return interpreter
end

dap.adapters.python = function(cb, config)
    vim.env.PYTHONPATH = string.format("%s:%s", "./..", vim.env.PYTHONPATH)

    if config.request == "attach" then
        local port = (config.connect or config).port
        local host = (config.connect or config).host or "127.0.0.1"
        cb({
            type = "server",
            port = assert(port,
                          "`connect.port` is required for a python `attach` configuration"),
            host = host,
            options = {source_filetype = "python"}
        })
    else
        cb({
            type = "executable",
            -- ✅ ВАЖНО: используем Python из Mason для запуска debugpy.adapter
            command = debugpy_adapter_path, -- каким Python запускать сам отладчик (адаптер)
            args = {"-m", "debugpy.adapter"},
            options = {source_filetype = "python"}
        })
    end
end

dap.configurations.python = {
    { -- The first three options are required by nvim-dap
        type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
        request = "launch",
        name = "Launch file",
        console = "integratedTerminal",
        justMyCode = false,
        -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options
        program = "${file}", -- This configuration will launch the current file if used.
        -- ✅ ВАЖНО: указываем, каким Python запускать сам код
        python = pythonPath() -- каким Python запускать код проекта

    }, -- {
    --         type = 'python',
    --         request = 'launch',
    --         name = 'DAP Django',
    --         program = vim.loop.cwd() .. '/manage.py',
    --         args = {'runserver', '--noreload'},
    --         justMyCode = true,
    --         django = true,
    --         console = "integratedTerminal",
    --     },
    {
        type = "python",
        request = "attach",
        name = "Attach remote",
        connect = function()
            return {host = "127.0.0.1", port = 5678}
        end

    }, {
        type = "python",
        request = "launch",
        name = "Launch file with arguments",
        program = "${file}",
        args = function()
            local args_string = vim.fn.input("Arguments: ")
            return vim.split(args_string, " +")
        end,
        console = "integratedTerminal",
        python = pythonPath() -- каким Python запускать код проекта

    }
}
