-- В данном модуле находятся пользовательские команды
local api = vim.api

-- Подцветка строки у которой длина превышает заданное значение
vim.cmd([[highlight OverLength ctermbg=darkred guibg=#592929]])
-- функция для подцвечивания строк, превышающих заданное количество симвоов
local function highlight_overlong_lines()
    local regex = '\\%>' .. vim.bo.textwidth .. 'v.\\+'
    vim.fn.matchadd("OverLength", regex)
end

-- Молчаливое выполнение передаваемых команд
local function silent_cmd(command)
    -- https://neovim.io/doc/user/vimfn.html#winrestview()
    local view = vim.fn.winsaveview()
    -- silent - для молчаливого выполнения команды, 
    -- т.е обычные сообщения не будут отправлены или добавлены в историю сообщений.
    -- keepjumps необходим для того, чтобы не сохранялся jumplist
    -- https://neovim.io/doc/user/motion.html#%3Akeepjumps
    -- keeppatterns Выполнить команду {command}, не добавляя ничего в историю поиска
    vim.cmd('silent keepjumps keeppatterns ' .. command)
    vim.fn.winrestview(view)
end

-- функция для переноса строк при превышении заданного значения
local function split_overlong_lines()
    silent_cmd('g/\\%>' .. vim.bo.textwidth .. 'v.\\+/normal gwl')
end

-- Ищет слово под курсором в файле tags (созданный утилитой ctags)
api.nvim_create_user_command('Tags', function(opts)
    local cursor_word = vim.fn.expand("<cword>")
    print(cursor_word)
    print(vim.inspect(vim.fn.taglist(string.format("^%s", cursor_word))))
end, {desc = "Find tags"})

-- Переводит слово под курсоком в верхний регист
api.nvim_create_user_command('Upper', function(opts)
    local current_word = vim.fn.expand("<cword>")
    local current_word_upper = string.upper(current_word)
    vim.cmd("normal! diwi" .. current_word_upper)
end, {})

-- Переводит слово под курсоком в нижний регист
api.nvim_create_user_command('Lower', function(opts)
    local current_word = vim.fn.expand("<cword>")
    local current_word_upper = string.lower(current_word)
    vim.cmd("normal! diwi" .. current_word_upper)
end, {})

-- Переводит название сущности в snake case
api.nvim_create_user_command('SnakeCase', function(opts)
    local current_word = vim.fn.expand("<cword>")
    -- change case to snake case
    local snake_case = current_word:gsub("(%u)", "_%1"):gsub("(%u)",
                                                             string.lower):gsub(
                           "^_", "")
    vim.cmd("normal! diwi" .. snake_case)
end, {})

-- Переводит название сущности в camel case
api.nvim_create_user_command('CamalCase', function(opts)
    local current_word = vim.fn.expand("<cword>")
    -- change case to camal case
    local camal_case = current_word:gsub("_(.)", string.upper):gsub("^(.)",
                                                                    string.upper)
    vim.cmd("normal! diwi" .. camal_case)
end, {})

-- Обращение snake case в camel case и наоборот
api.nvim_create_user_command('ToggleCase', function(opts)
    local current_word = vim.fn.expand("<cword>")
    if current_word:match("_") then
        vim.cmd("CamalCase")
    else
        vim.cmd("SnakeCase")
    end
end, {})

-- команда для переноса строк при превышении заданного значения
api.nvim_create_user_command('SplitLinesInBuffer', function(opts)
    split_overlong_lines()
end, {})
api.nvim_create_user_command('HighlightOverLongLines', function(opts)
    highlight_overlong_lines()
end, {})

-- получить информацию о слове

local function split(str, sep)
    local result = {}
    local regex = ("([^%s]+)"):format(sep)
    for each in str:gmatch(regex) do
        local res, _ = each:gsub("\n", "")
        table.insert(result, res)
    end
    return result
end

local eng_win_id = -1
local bufnr = -1

api.nvim_create_user_command('Eng', function(opts)
    local file_path =
        "/home/stepan/git_repos/kn7072/ANKI/TelegramBot/all_words.json"
    local path_to_synonym =
        "/home/stepan/git_repos/kn7072/ANKI/Синонимы/clear_dict.txt"
    local cmd_for_all_words = string.format(
                                  [[jq 'to_entries[] | select(.key | test("^%s.*"))' "%s"]],
                                  opts.args, file_path)
    local cmd_for_synonym = string.format(
                                [[cat "%s" | grep -Ei -A 7 --color "%s"]],
                                path_to_synonym, opts.args)

    local content_word = vim.fn.system(cmd_for_all_words)
    local content_synonym = vim.fn.system(cmd_for_synonym)
    content_word = content_word .. content_synonym

    local current_win = api.nvim_get_current_win()

    if not api.nvim_buf_is_valid(bufnr) then
        bufnr = api.nvim_create_buf(false, true)
        -- print(string.format("%s", bufnr))
        api.nvim_buf_set_name(bufnr, 'English')

    end

    local lines = split(content_word, "\n")
    local count_lines = api.nvim_buf_line_count(bufnr)

    -- api.nvim_buf_set_lines(bufnr, 0, 0, false, lines) -- если необходимо продолжить писать в тот же буфер
    api.nvim_buf_set_lines(bufnr, 0, count_lines, false, lines)
    if not api.nvim_win_is_valid(eng_win_id) then
        local window_opt = {win = current_win, split = 'right'} -- , split = 'left'
        eng_win_id = api.nvim_open_win(bufnr, false, window_opt) -- window_opt
    end

    api.nvim_set_current_win(eng_win_id)

    -- print(eng_win_id)
    vim.cmd('redraw')

end, {desc = "English", nargs = 1})
