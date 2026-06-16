-- в init.lua
local function create_repo(backup_dir)
    if vim.fn.isdirectory(backup_dir) == 0 then
        vim.fn.mkdir(backup_dir, "p")
        vim.fn
            .system({"git", "-C", backup_dir, "init", "--initial-branch=main"})
        print(
            "Создан Git-репозиторий для бэкапов в " ..
                backup_dir)

        -- Устанавливаем политику хранения
        vim.fn.system({
            "git", "-C", backup_dir, "config", "gc.reflogExpire", "30 days"
        })
        vim.fn.system({
            "git", "-C", backup_dir, "config", "gc.reflogExpireUnreachable",
            "7 days"
        })
        vim.fn.system({
            "git", "-C", backup_dir, "config", "gc.pruneExpire", "14 days"
        })

        -- Включаем автоочистку с умеренными порогами
        vim.fn.system({"git", "-C", backup_dir, "config", "gc.auto", "500"}) -- 500 объектов
        vim.fn.system({
            "git", "-C", backup_dir, "config", "gc.autoPackLimit", "30"
        })

        print(
            "✅ Git backup: автоматическая очистка настроена")
    end
end

local function git_backup()
    -- Путь для сохранения в бэкапе (сохраняем полный путь от /home)
    local backup_dir = vim.fn.stdpath("state") .. "/backup-repo"
    create_repo(backup_dir)

    local file = vim.fn.expand("%:p")
    if file == "" then
        return -- Нет файла (буфер без имени)
    end

    -- Проверяем размер файла (в байтах)
    local size = vim.fn.getfsize(file)
    if size == -1 or size == -2 then
        return -- Файл не найден или недоступен
    end

    local max_size_bytes = 30 * 1024 * 1024 -- 30 МБ
    if size > max_size_bytes then
        print("⚠️ Файл пропущен: размер " ..
                  string.format("%.1f", size / 1024 / 1024) .. " МБ > 30 МБ")
        return
    end

    -- Убираем ведущий слеш и заменяем / на _ для безопасного имени файла
    local relative_path = file:sub(2) -- убираем первый символ '/'
    local backup_file_path = backup_dir .. "/" .. relative_path

    -- Создаём директорию для бэкапа файла, если её нет
    local backup_file_dir = vim.fn.fnamemodify(backup_file_path, ":h")
    print(backup_file_dir)
    vim.fn.mkdir(backup_file_dir, "p") -- создаём родительские директории рекурсивно

    -- Копируем файл в репозиторий с сохранением структуры
    vim.fn.system({"cp", file, backup_file_path})

    -- Проверяем, скопировался ли файл
    if vim.fn.filereadable(backup_file_path) == 0 then
        print("❌ Ошибка копирования файла")
        return
    end

    -- Git операции
    vim.fn.system({"git", "-C", backup_dir, "add", relative_path})
    vim.fn.system({"git", "-C", backup_dir, "commit", "-m", "Backup: " .. file})
end

vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*", -- для всех файлов
    callback = git_backup
})
