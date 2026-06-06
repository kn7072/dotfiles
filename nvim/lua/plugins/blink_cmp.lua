local blink = require('blink.cmp')

blink.setup({
    -- === SNIPPET (аналог nvim-cmp) ===
    snippets = {
        preset = 'luasnip', -- Используем luasnip как движок
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end
    },

    -- === ВНЕШНИЙ ВИД (window + formatting) ===
    appearance = {nerd_font_variant = 'mono'},

    -- Окна с рамками (аналог bordered())
    windows = {
        completion = {border = 'single'},
        documentation = {border = 'single'}
    },

    -- Форматирование (аналог formatting)
    completion = {
        documentation = {auto_show = true},
        -- Поля и их порядок
        menu = {
            draw = {
                columns = {
                    {"label", "label_description", gap = 1},
                    {"kind_icon", "kind"}
                },
                components = {
                    kind_icon = {
                        text = function(ctx)
                            return ctx.kind_icon
                        end
                    }
                }
            }
        },
        -- Кастомные иконки для источников (аналог menu_icon)
        ghost_text = {enabled = false}
    },

    -- === КЛАВИШИ (mapping) ===
    keymap = {
        preset = 'default', -- Базовые маппинги
        ['<C-p>'] = {'select_prev', fallback = true},
        ['<C-n>'] = {'select_next', fallback = true},
        ['<C-d>'] = {'scroll_documentation_up', fallback = true},
        ['<C-f>'] = {'scroll_documentation_down', fallback = true},
        ['<C-Space>'] = {'show', 'show_documentation', 'hide_documentation'},
        ['<C-e>'] = {'hide', fallback = true},
        ['<CR>'] = {'accept', fallback = true},
        ['<Tab>'] = {
            function(cmp)
                if cmp.is_visible() then
                    cmp.select_next()
                else
                    return false
                end
            end, 'fallback'
        },
        ['<S-Tab>'] = {
            function(cmp)
                if cmp.is_visible() then
                    cmp.select_prev()
                else
                    return false
                end
            end, 'fallback'
        }
    },

    -- === ИСТОЧНИКИ (sources) ===
    sources = {
        default = {'lsp', 'path', 'snippets', 'buffer'},
        providers = {
            lsp = {name = 'lsp', module = 'blink.cmp.sources.lsp'},
            path = {name = 'path', module = 'blink.cmp.sources.path'},
            snippets = {
                name = 'snippets',
                module = 'blink.cmp.sources.snippets'
            },
            buffer = {
                name = 'buffer',
                module = 'blink.cmp.sources.buffer',
                -- Аналог keyword_length и get_bufnrs из nvim-cmp
                opts = {
                    min_keyword_length = 1, -- аналог keyword_length = 1
                    -- Аналог get_bufnrs с фильтрацией по размеру
                    get_bufnrs = function()
                        local api = vim.api
                        local limit = 1024 * 1024 -- 1 MB
                        local bufs = {}
                        for _, buf in ipairs(api.nvim_list_bufs()) do
                            if api.nvim_buf_is_valid(buf) then
                                local line_count = api.nvim_buf_line_count(buf)
                                if line_count > 0 then
                                    local byte_size =
                                        api.nvim_buf_get_offset(buf, line_count)
                                    if byte_size < limit then
                                        table.insert(bufs, buf)
                                    end
                                end
                            end
                        end
                        return bufs
                    end
                }
            }
        }
    },

    -- === РАЗРЕШЕНИЕ В DAP БУФЕРАХ (enabled) ===
    enabled = function()
        local buftype = vim.api.nvim_get_option_value("buftype", {buf = 0})
        -- Включаем в DAP буферах (аналог cmp_dap.is_dap_buffer)
        if buftype == "prompt" then
            -- В blink.cmp есть встроенная проверка DAP буферов
            return require('blink.cmp').is_dap_buffer()
        end
        return buftype ~= "prompt"
    end,

    -- Настройка командной строки
    cmdline = {
        ['/'] = {
            keymap = {preset = 'cmdline'},
            sources = {default = {'buffer'}}
        },
        ['?'] = {
            keymap = {preset = 'cmdline'},
            sources = {default = {'buffer'}}
        },
        [':'] = {
            keymap = {preset = 'cmdline'},
            sources = {default = {'path', 'cmdline'}}
        }
    },

    -- Настройка для DAP
    filetype = {
        ['dap-repl'] = {sources = {default = {'dap'}}},
        ['dapui_watches'] = {sources = {default = {'dap'}}},
        ['dapui_hover'] = {sources = {default = {'dap'}}}
    }
})

