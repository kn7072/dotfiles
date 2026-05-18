---@brief
---
--- https://github.com/sqls-server/sqls
---
--- ```lua
--- vim.lsp.config('sqls', {
---   cmd = {"path/to/command", "-config", "path/to/config.yml"};
---   ...
--- })
--- ```
--- Sqls can be installed via `go install github.com/sqls-server/sqls@latest`. Instructions for compiling Sqls from the source can be found at [sqls-server/sqls](https://github.com/sqls-server/sqls).
---@type vim.lsp.Config
return {
    cmd = {'sqls'},
    filetypes = {'sql', 'mysql'},
    root_markers = {'config.yml'},
    settings = {
        sqls = {
            -- Подключение к реальной БД (опционально)
            -- connections = {
            --   {
            --     driver = "postgresql",
            --     dataSourceName = "host=localhost user=postgres password=${PGPASSWORD} dbname=mydb".
            --     dataSourceName = "host=localhost user=postgres dbname=mydb sslmode=disable",
            --   },
            -- },
            -- Автоматически ищет config.yml в корне проекта
            -- Если файла нет, можно задать схему явно:
            -- schemaFilePath = vim.fn.expand("~/.config/nvim/lsp/schema.sql"),
        }
    }
}
