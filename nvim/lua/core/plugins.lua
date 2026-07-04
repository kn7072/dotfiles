local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local path_to_my_plugin = vim.fn.stdpath('config') .. "/my_plugins/"

if not vim.loop.fs_stat(lazypath) then
    vim.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git", "--branch=stable", -- latest stable release
        lazypath
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {
        'smoka7/hop.nvim',
        version = "*",
        opts = {keys = 'etovxqpdygfblzhckisuran'}
    }, {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        dependencies = {
            "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim", "s1n7ax/nvim-window-picker"
        }
    }, {
        'nvim-treesitter/nvim-treesitter',
        branch = "main",
        lazy = false,
        build = ':TSUpdate'
    }, {"neovim/nvim-lspconfig"}, {"mason-org/mason.nvim", opts = {}},
    -- {"williamboman/mason.nvim", build = ":MasonUpdate"},
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = {"mason-org/mason.nvim"},
        config = function()
            require("mason-tool-installer").setup({
                ensure_installed = {
                    "clangd", "debugpy", "gofumpt", "goimports",
                    "golangci-lint", "revive", -- "delve", 
                    "lua-language-server", "luaformatter", "prettierd",
                    "pyright", "shellcheck", "stylua", "bash-language-server",
                    "bash-debug-adapter", "texlab", "ruff", "marksman",
                    "codespell", "typescript-language-server",
                    "yaml-language-server", "checkmake", "tree-sitter-cli",
                    "sqlfluff", "sqls", "ast-grep", "tinymist"
                    -- "flake8", "isort", "pylint", "black" 
                },
                start_delay = 0
            })
        end
    }, {'sainnhe/gruvbox-material', lazy = false, priority = 1000},
    -- {"hrsh7th/cmp-nvim-lsp"}, {"hrsh7th/cmp-buffer"}, {"hrsh7th/cmp-path"},
    -- {"hrsh7th/cmp-cmdline"}, {"rcarriga/cmp-dap"}, 
    -- {"hrsh7th/cmp-nvim-lsp-signature-help"}, {"saadparwaiz1/cmp_luasnip"},

    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline", "hrsh7th/cmp-nvim-lsp-signature-help",
            "rcarriga/cmp-dap", "saadparwaiz1/cmp_luasnip"
        }
        -- enabled = false
    }, {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            {"nvim-lua/plenary.nvim"},
            {"nvim-telescope/telescope-live-grep-args.nvim"}
        }
    }, {'mfussenegger/nvim-lint'}, {"stevearc/conform.nvim", opts = {}},
    {"akinsho/toggleterm.nvim", version = "*", config = true},
    {"akinsho/bufferline.nvim", dependencies = {"nvim-tree/nvim-web-devicons"}},
    {
        "glepnir/dashboard-nvim",
        event = "VimEnter",
        dependencies = {{"nvim-tree/nvim-web-devicons"}}
    }, {"lewis6991/gitsigns.nvim"}, {
        "linrongbin16/lsp-progress.nvim",
        event = {"VimEnter"},
        dependencies = {"nvim-tree/nvim-web-devicons"},
        config = function()
            require("lsp-progress").setup()
        end
    }, {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons", "linrongbin16/lsp-progress.nvim"
        }
    }, {"folke/which-key.nvim"}, {"windwp/nvim-autopairs"},
    {"numToStr/Comment.nvim"}, {"mfussenegger/nvim-dap"},
    {"nvim-tree/nvim-web-devicons"}, {"ryanoasis/vim-devicons"}, {
        "rcarriga/nvim-dap-ui",
        dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"}
    }, {"leoluz/nvim-dap-go"}, {"jbyuki/one-small-step-for-vimkind"},
    {"rcarriga/nvim-notify"}, {"yorickpeterse/nvim-window", config = true}, {
        "L3MON4D3/LuaSnip",
        build = "make install_jsregexp",
        dependencies = {"rafamadriz/friendly-snippets"}
    }, {"rafamadriz/friendly-snippets"}, {"mbbill/undotree"}, {
        "ThePrimeagen/refactoring.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter"
        }
    }, {"kevinhwang91/nvim-ufo", dependencies = {"kevinhwang91/promise-async"}},
    {"mmarchini/bpftrace.vim"}, {
        "Wansmer/langmapper.nvim",
        lazy = false,
        priority = 1, -- High priority is needed if you will use `autoremap()`
        config = function()
            require("langmapper").setup({ --[[ your config ]] })
        end
    }, {"chentoast/marks.nvim", event = "VeryLazy", opts = {}},
    {"tpope/vim-surround"}, {"tpope/vim-fugitive"}, {
        -- плагины для отрбражения картинок
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
            -- add options here
            -- or leave it empty to use the default settings
        },
        keys = {
            -- suggested keymap
            {
                "<leader>p",
                "<cmd>PasteImage<cr>",
                desc = "Paste image from system clipboard"
            }
        }
    }, {
        "iamcco/markdown-preview.nvim",
        cmd = {
            "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop"
        },
        build = "cd app && npm install",
        init = function()
            vim.g.mkdp_filetypes = {"markdown"}
        end,
        ft = {"markdown"}
    }, {
        "lervag/vimtex",
        lazy = false, -- we don't want to lazy load VimTeX
        -- tag = "v2.15", -- uncomment to pin to a specific release
        init = function()
            -- VimTeX configuration goes here, e.g.
            vim.g.vimtex_view_general_viewer = "okular"
        end
    }, {"hat0uma/csvview.nvim"}, {
        'MagicDuck/grug-far.nvim',
        -- Note (lazy loading): grug-far.lua defers all it's requires so it's lazy by default
        -- additional lazy config to defer loading is not really needed...
        config = function()
            -- optional setup call to override plugin options
            -- alternatively you can set options with vim.g.grug_far = { ... }
            require('grug-far').setup({
                -- options, see Configuration section below
                -- there are no required options atm
                -- engine = 'astgrep'
            });
        end
    }, {'kevinhwang91/nvim-bqf'}, {
        'chomosuke/typst-preview.nvim',
        lazy = false, -- or ft = 'typst'
        version = '1.*',
        opts = {} -- lazy.nvim will implicitly calls `setup {}`
    }, {
        "theHamsta/nvim-dap-virtual-text",
        dependencies = {
            "mfussenegger/nvim-dap", "nvim-treesitter/nvim-treesitter"
        },
        config = function()
            require("nvim-dap-virtual-text").setup({
                enabled = true, -- Включить плагин
                enabled_commands = true, -- Создать команды :DapVirtualTextEnable, :DapVirtualTextDisable и т.д.
                highlight_changed_variables = true, -- Подсвечивать переменные, значения которых изменились
                highlight_new_as_changed = true, -- Подсвечивать новые переменные как измененные
                show_stop_reason = true, -- Показывать причину остановки (breakpoint, step, etc.)
                commented = false, -- Не добавлять комментарии перед значениями
                only_first_definition = true, -- Показывать значение только у первого определения переменной
                all_references = false, -- Не показывать значения у всех ссылок на переменную
                filter_references_pattern = '<module', -- Фильтр для references
                virt_text_pos = 'eol', -- Позиция виртуального текста: 'eol', 'overlay', 'right_align'
                all_frames = false, -- Показывать значения для всех фреймов стека
                virt_lines = false, -- Не показывать значения на отдельных строках
                virt_text_win_col = nil -- Не привязывать к определенной колонке окна

            })
        end
    }, {
        "yetone/avante.nvim",
        -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
        -- ⚠️ must add this setting! ! !
        build = vim.fn.has("win32") ~= 0 and
            "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" or
            "make",
        event = "VeryLazy",
        version = false, -- Never set this value to "*"! Never!
        ---@module 'avante'
        ---@type avante.Config
        opts = {
            -- add any opts here
            -- this file can contain specific instructions for your project
            instructions_file = "avante.md",
            -- for example
            -- provider = "lmstudio",
            -- provider = "openrouter",
            provider = "ollama",
            providers = {
                ollama = {
                    -- Наследуем протокол от OpenAI
                    __inherited_from = "openai",

                    -- OpenAI-совместимый эндпоинт Ollama
                    endpoint = "http://127.0.0.1:11434/v1",

                    -- Имя модели, которую вы скачали через `ollama pull`
                    -- model = "qwen2.5-coder:7b",
                    model = "qwen2.5:3b",

                    -- Ollama локально не требует API-ключа
                    api_key_name = "",

                    -- Локальные модели работают медленнее, увеличиваем таймаут
                    timeout = 60000,

                    -- Опциональная тонкая настройка
                    extra_request_body = {
                        temperature = 0.3, -- Низкая температура для кода
                        max_tokens = 2048, -- 4096,
                        repetition_penalty = 1.1, -- Помогает избежать зацикливания
                        top_k = 40 -- Ограничивает выбор (ускоряет генерацию)
                    }
                },
                openrouter = {
                    -- Наследуем логику запросов от OpenAI, так как OpenRouter совместим с ним
                    __inherited_from = "openai",

                    -- Эндпоинт OpenRouter
                    endpoint = "https://openrouter.ai/api/v1",

                    -- Формат модели в OpenRouter: "провайдер/название_модели"
                    -- Например: "anthropic/claude-3.5-sonnet", "openai/gpt-4o", "meta-llama/llama-3.1-405b-instruct"
                    model = "google/gemma-4-31b-it:free",

                    -- Имя переменной окружения, где будет храниться ваш ключ
                    -- export OPENROUTER_API_KEY=your-claude-api-key
                    api_key_name = "OPENROUTER_API_KEY",

                    -- Опционально: можно настроить температуру и лимит токенов
                    extra_request_body = {temperature = 0.7, max_tokens = 4096}
                },
                lmstudio = {
                    __inherited_from = "openai", -- Наследуем протокол и логику от OpenAI
                    endpoint = "http://127.0.0.1:1234/v1", -- Стандартный адрес локального сервера LM Studio
                    model = "local-model", -- Имя модели (см. пояснение ниже)
                    api_key_name = "", -- Пустая строка отключает требование API-ключа
                    timeout = 60000 -- Увеличиваем таймаут (в мс), так как локальные модели работают медленнее
                },
                claude = {
                    endpoint = "https://api.anthropic.com",
                    model = "claude-sonnet-4-20250514",
                    timeout = 30000, -- Timeout in milliseconds
                    extra_request_body = {
                        temperature = 0.75,
                        max_tokens = 20480
                    }
                },
                moonshot = {
                    endpoint = "https://api.moonshot.ai/v1",
                    model = "kimi-k2-0711-preview",
                    timeout = 30000, -- Timeout in milliseconds
                    extra_request_body = {
                        temperature = 0.75,
                        max_tokens = 32768
                    }
                }
            },
            behaviour = {
                -- Enable image paste support from clipboard when img-clip.nvim is available.
                -- support_paste_from_clipboard = true,
                auto_suggestions = false
            }
        },
        dependencies = {
            "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim",
            --- The below dependencies are optional,
            "nvim-mini/mini.pick", -- for file_selector provider mini.pick
            "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
            "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
            "ibhagwan/fzf-lua", -- for file_selector provider fzf
            "stevearc/dressing.nvim", -- for input provider dressing
            "folke/snacks.nvim", -- for input provider snacks
            "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
            "zbirenbaum/copilot.lua", -- for providers='copilot'
            {
                -- support for image pasting
                "HakonHarnes/img-clip.nvim",
                event = "VeryLazy",
                opts = {
                    -- recommended settings
                    default = {
                        embed_image_as_base64 = false,
                        prompt_for_file_name = false,
                        drag_and_drop = {insert_mode = true},
                        -- required for Windows users
                        use_absolute_path = true
                    }
                }
            }, {
                -- Make sure to set this up properly if you have lazy=true
                'MeanderingProgrammer/render-markdown.nvim',
                opts = {file_types = {"markdown", "Avante"}},
                ft = {"markdown", "Avante"}
            }
        }
    }, -- {
    --     "stuckinsnow/rg-lua.nvim",
    --     dependencies = {
    --         "ibhagwan/fzf-lua" -- optional
    --     },
    --     config = function()
    --         require("rg-lua").setup()
    --     end
    -- }, {
    --     "nvim-tree/nvim-tree.lua",
    --     version = "*",
    --     lazy = false,
    --     dependencies = {"nvim-tree/nvim-web-devicons"}
    -- }
    -- автокомлит, но к сожалению по не поддерживате автодополение в dap
    -- {
    --     'saghen/blink.cmp',
    --     version = '1.*',
    --     dependencies = {'rafamadriz/friendly-snippets'},
    --     opts = {} -- Пустой opts, вся конфигурация будет в вашем отдельном модуле
    -- }, 
    -- подключение собстввенных плагинов
    {dir = path_to_my_plugin .. "switch_buffer"},
    {dir = path_to_my_plugin .. "surround"}
})
