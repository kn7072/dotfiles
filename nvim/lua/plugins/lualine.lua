-- Bubbles config for lualine
-- Author: lokesh-krishna
-- MIT license, see LICENSE for more details.
-- stylua: ignore
local colors = {
    blue = '#80a0ff',
    cyan = '#79dac8',
    black = '#080808',
    white = '#c6c6c6',
    red = '#ff5189',
    violet = '#d183e8',
    grey = '#303030'
}

--- Получает полный путь текущего буфера и сокращает имена каталогов.
-- Если имя каталога длиннее 4 символов, оно обрезается до 4 символов 
-- и к нему добавляется тильда (~). Имя файла не изменяется.
-- @return string Сокращенный путь или пустая строка, если буфер не сохранен.
function get_shortened_buffer_path()
    local path = vim.api.nvim_buf_get_name(0)

    -- Если буфер еще не сохранен (нет имени), возвращаем пустую строку
    if path == "" then
        return ""
    end

    -- Нормализуем разделители к '/' (на случай Windows, где используется '\')
    path = path:gsub("\\", "/")

    -- Находим позицию последнего слэша, чтобы отделить имя файла от пути
    local last_slash = path:find("/[^/]*$")

    -- Если слэша нет, значит это просто имя файла без директорий
    if not last_slash then
        return path
    end

    local dir_part = path:sub(1, last_slash - 1)
    local file_part = path:sub(last_slash + 1)

    -- Сокращаем названия каталогов в dir_part
    -- Мы ищем любые последовательности символов между слэшами
    local shortened_dir = dir_part:gsub("([^/]+)", function(match)
        if #match > 4 then
            return match:sub(1, 4) .. "~"
        end
        return match
    end)

    -- Собираем путь обратно
    return shortened_dir .. "/" .. file_part
end
local bubbles_theme = {
    normal = {
        a = {fg = colors.black, bg = colors.violet},
        b = {fg = colors.white, bg = colors.grey},
        c = {fg = colors.black, bg = colors.black}
    },

    insert = {a = {fg = colors.black, bg = colors.blue}},
    visual = {a = {fg = colors.black, bg = colors.cyan}},
    replace = {a = {fg = colors.black, bg = colors.red}},

    inactive = {
        a = {fg = colors.white, bg = colors.black},
        b = {fg = colors.white, bg = colors.black},
        c = {fg = colors.black, bg = colors.black}
    }
}

require('lualine').setup {
    options = {
        theme = bubbles_theme,
        component_separators = '|',
        section_separators = {left = '', right = ''}
    },
    sections = {
        lualine_a = {{'mode', separator = {left = ''}, right_padding = 2}},
        lualine_b = {
            get_shortened_buffer_path
            -- require("lsp-progress").progress  
        },
        lualine_c = {'fileformat'},
        lualine_x = {},
        lualine_y = {'branch', 'filetype', 'progress'},
        lualine_z = {
            {'location', separator = {right = ''}, left_padding = 2}
        }
    },
    inactive_sections = {
        lualine_a = {'filename'},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {'location'}
    },
    tabline = {},
    extensions = {}
}

vim.cmd([[
augroup lualine_augroup
    autocmd!
    autocmd User LspProgressStatusUpdated lua require("lualine").refresh()
augroup END
]])
