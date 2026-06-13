local root_markers = {
    ".venv", "pyproject.toml", "pyrightconfig.json", "setup.py", "setup.cfg",
    "requirements.txt", "Pipfile", ".git"
}

-- Функция для поиска интерпретатора
local function get_python_path()
    -- находим корень проекта
    local root_dir = vim.fs.root(0, root_markers)
    -- Проверяем .venv в корне проекта

    local venv_path = root_dir .. "/.venv/bin/python"
    if vim.uv.fs_stat(venv_path) then
        return venv_path
    end
    -- Если нет .venv, возвращаем nil (Pyright использует системный)
    return nil
end

return {
    cmd = {"pyright-langserver", "--stdio"}, -- , "--verbose"

    filetypes = {"python"},
    root_markers = root_markers,
    on_init = function(client, initialize_result)
        -- Даем серверу 200мс после ответа на initialize, чтобы он "успокоился"
        vim.defer_fn(function()
            -- Мы НЕ создаем new_settings. Мы берем то, что уже есть в client.config.settings
            -- и просим сервер применить это прямо сейчас.
            client:notify('workspace/didChangeConfiguration',
                          {settings = client.config.settings})
        end, 200)
    end,
    --[[ Determines if a server is
    started without a matching root directory. See lspconfig-single-file-support. ]]
    single_file_support = true,
    root_dir = vim.fs.root(0, root_markers),
    settings = {
        python = {
            -- pythonPath = "/home/stepan/temp/test_convert_book/.venv/bin/python",
            pythonPath = get_python_path(),
            -- pythonPath = "",
            analysis = {
                autoImportCompletions = true,
                autoSearchPaths = true,
                diagnosticMode = "openFilesOnly", -- openFilesOnly, workspace
                typeCheckingMode = "basic", -- off, basic, strict
                useLibraryCodeForTypes = true
            }
        }
    }
}
