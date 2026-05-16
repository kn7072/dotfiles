local lint = require('lint')

-- добавил параметр конфиг
lint.linters.ruff.args = vim.list_extend(lint.linters.ruff.args or {}, {
    "--config",
    vim.fn.expand(vim.fn.stdpath("config") .. "/plugin_configs/ruff.toml")
})

lint.linters_by_ft = {
    python = {"ruff"},
    go = {"revive", "golangcilint"},
    make = {"checkmake"}
}

local my_augroup = vim.api.nvim_create_augroup("MyLintingGroup", {clear = true})

-- Отдельный обработчик для BufWritePost - После сохранения файла
vim.api.nvim_create_autocmd("BufWritePost", {
    group = my_augroup,
    callback = function()
        require("lint").try_lint()
    end
})

-- срабатывает после того, как содержимое файла было прочитано в буфер, но до его окончательной обработки
vim.api.nvim_create_autocmd("BufReadPost", {
    group = my_augroup,
    callback = function()
        require("lint").try_lint()
    end
})

-- Отдельный обработчик для InsertLeave - При выходе из режима вставки
vim.api.nvim_create_autocmd("InsertLeave", {
    group = my_augroup,
    callback = function()
        require("lint").try_lint()
    end
})
