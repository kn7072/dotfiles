-- local lsp_common = require("plugins.lsp_common")
local function get_opts(custom_opts)
    local opts = {noremap = true, silent = true}
    if custom_opts then
        for k, v in pairs(custom_opts) do
            opts[k] = v
        end
    end
    return opts
end

local function set_keymap(...)
    vim.keymap.set(...)
end

vim.lsp.enable({
    "gopls", "pyright", -- "ts_ls", 
    "lua_ls"
    -- "rust", "eslint", "angularls", "cssls",
    -- "emmet", "yamlls", "html"
    -- "golangci_lint",
})

-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Пример современного подхода. Этот блок кода живет в вашем основном конфиге один раз.
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(event)
        -- 'event.buf'  - номер буфера
        -- 'event.data.client_id' - ID подключившегося LSP-клиента
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        local bufnr = event.buf

        -- Опции для маппинга, чтобы клавиши работали только в этом буфере
        -- local opts = { buffer = bufnr }

        -- Mappings.
        set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>",
                   get_opts({
            buffer = bufnr,
            desc = "Jumps to the declaration of the symbol under the cursor"
        }))
        -- Переход к определению слова (функции, переменной...) под курсором
        set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>",
                   get_opts({
            buffer = bufnr,
            desc = "Jumps to the definition of the symbol under the cursor"
        }))
        set_keymap("n", "<leader>ga", "<Cmd>lua vim.lsp.buf.code_action()<CR>",
                   get_opts({buffer = bufnr}))
        set_keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", get_opts({
            buffer = bufnr,
            desc = "Displays hover information about the symbol under the cursor"
        }))
        set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>",
                   get_opts({
            buffer = bufnr,
            desc = "Lists all the implementations for the symbol under the cursor in the quickfix window"
        }))
        set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>",
                   get_opts({
            buffer = bufnr,
            desc = "Displays signature about the symbol under the cursor"
        }))
        set_keymap("n", "<leader>wa",
                   "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>",
                   get_opts({buffer = bufnr}))
        set_keymap("n", "<leader>wr",
                   "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>",
                   get_opts({buffer = bufnr}))
        set_keymap("n", "<leader>wl",
                   "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
                   get_opts({buffer = bufnr}))
        set_keymap("n", "<leader>D",
                   "<cmd>lua vim.lsp.buf.type_definition()<CR>",
                   get_opts({buffer = bufnr}))
        -- Переименование указанной сущности
        set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>",
                   get_opts({buffer = bufnr, desc = "rename symbol"}))
        -- Выводим в quickfix все упоминания искомого слова
        set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>",
                   get_opts({
            buffer = bufnr,
            desc = "Lists all the references to the symbol under the cursor in the quickfix window"
        }))
        set_keymap("n", "<leader>n",
                   '<cmd>lua vim.diagnostic.open_float(0, {scope="line"})<CR>',
                   get_opts({
            buffer = bufnr,
            desc = "Displays diagnostic information in a float window"
        }))

        set_keymap("n", "[d",
                   "<cmd>lua vim.diagnostic.jump({ count = -1 })<CR>",
                   get_opts({buffer = bufnr, desc = "goto prev diagnostic"}))
        set_keymap("n", "]d", "<cmd>lua vim.diagnostic.jump({ count = 1 })<CR>",
                   get_opts({buffer = bufnr, desc = "goto next diagnostic"}))
        set_keymap("n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", -- setloclist setqflist
                   get_opts({
            buffer = bufnr,
            desc = "Lists all diagnostics to the quickfix window"
        }))

        -- Set some keybinds conditional on server capabilities
        -- :lua vim.lsp.get_active_clients()[1].server_capabilities
        if client.server_capabilities.documentFormattingProvider then
            set_keymap("n", "<leader>fo", "<cmd>lua vim.lsp.buf.format()<CR>",
                       get_opts({buffer = bufnr}))
        elseif client.server_capabilities.rangeFormatting then
            set_keymap("n", "<leader>fr",
                       "<cmd>lua vim.lsp.buf.range_formatting()<CR>",
                       get_opts({buffer = bufnr}))
        end

        -- Здесь живут ВСЕ ваши LSP маппинги
        -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        -- vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)

        -- А здесь можно добавить логику для конкретного сервера, например, для Biome
        if client.name == "biome" then
            -- Ваша специфичная настройка для Biome
            vim.keymap.set('n', '<leader>bf', function()
                vim.lsp.buf.code_action({
                    context = {only = {"source.fixAll.biome"}},
                    apply = true
                })
            end, opts)
        end
    end
})

-- Sntup language servers.
-- https://github.com/microsoft/pyright/blob/main/docs/settings.md
-- local lspconfig = require('lspconfig')

-- lspconfig.pyright.setup {
--     capabilities = capabilities,
--     on_attach = lsp_common.on_attach,
--     --[[ Determines if a server is
--     started without a matching root directory. See lspconfig-single-file-support. ]]
--     single_file_support = true,
--     settings = {
--         python = {
--             pythonPath = "/home/che/git/Machine-learning/.venv/bin/python",
--             analysis = {
--                 autoImportCompletions = true,
--                 autoSearchPaths = true,
--                 diagnosticMode = "openFilesOnly", -- openFilesOnly, workspace
--                 typeCheckingMode = "basic", -- off, basic, strict
--                 useLibraryCodeForTypes = true
--             }
--         }
--     }
-- }

-- lspconfig.ts_ls.setup {}
-- lspconfig.prismals.setup {}
-- -- lsp для markdown
-- lspconfig.marksman.setup {
--     capabilities = capabilities,
--     on_attach = lsp_common.on_attach
-- }
-- -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#texlab
-- lspconfig.texlab.setup {
--     capabilities = capabilities,
--     on_attach = lsp_common.on_attach
-- }
-- -- lsp для bash
-- lspconfig.bashls.setup {
--     capabilities = capabilities,
--     on_attach = lsp_common.on_attach
-- }
--
-- lspconfig.cssls.setup {capabilities = capabilities}
--
-- -- https://clangd.llvm.org/installation.html
-- lspconfig.clangd.setup {
--     capabilities = capabilities,
--     on_attach = lsp_common.on_attach,
--     cmd = {"clangd", "--offset-encoding=utf-16"}
-- }
--
-- -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#lua_ls
-- -- https://luals.github.io/wiki/formatter/
-- lspconfig.lua_ls.setup {
--     capabilities = capabilities,
--     on_attach = lsp_common.on_attach,
--     -- enabled = false,
--     single_file_support = true,
--     settings = {
--         Lua = {
--             runtime = {
--                 -- Tell the language server which version of Lua you're using
--                 -- (most likely LuaJIT in the case of Neovim)
--                 version = 'LuaJIT'
--             },
--
--             workspace = {checkThirdParty = false},
--             completion = {
--                 enable = true,
--                 workspaceWord = true,
--                 callSnippet = "Both"
--             },
--             misc = {
--                 parameters = {
--                     -- "--log-level=trace",
--                 }
--             },
--             hint = {
--                 enable = true,
--                 setType = false,
--                 paramType = true,
--                 paramName = "All",
--                 semicolon = "All",
--                 arrayIndex = "Disable"
--             },
--             doc = {privateName = {"^_"}},
--             type = {castNumberToInteger = true},
--             diagnostics = {
--                 enable = true,
--                 disable = {"incomplete-signature-doc", "trailing-space"},
--                 -- enable = false,
--                 groupSeverity = {strong = "Warning", strict = "Warning"},
--                 groupFileStatus = {
--                     ["ambiguity"] = "Opened",
--                     ["await"] = "Opened",
--                     ["codestyle"] = "None",
--                     ["duplicate"] = "Opened",
--                     ["global"] = "Opened",
--                     ["luadoc"] = "Opened",
--                     ["redefined"] = "Opened",
--                     ["strict"] = "Opened",
--                     ["strong"] = "Opened",
--                     ["type-check"] = "Opened",
--                     ["unbalanced"] = "Opened",
--                     ["unused"] = "Opened"
--                 },
--                 unusedLocalExclude = {"_*"},
--                 globals = {'vim'}
--
--             },
--             format = {
--                 enable = false,
--                 defaultConfig = {
--                     indent_style = "space",
--                     indent_size = "4",
--                     continuation_indent_size = "4"
--                 }
--             }
--         }
--     }
--
-- }
--
-- lspconfig.gopls.setup {
--     cmd = {'gopls'},
--     -- for postfix snippets and analyzers
--     capabilities = capabilities,
--     settings = {
--         -- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
--         -- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md
--         -- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
--         -- https://github.com/golang/tools/blob/master/gopls/doc/inlayHints.md
--         gopls = {
--             experimentalPostfixCompletions = true,
--             gofumpt = true,
--             codelenses = {
--                 gc_details = true,
--                 generate = true,
--                 regenerate_cgo = true,
--                 run_govulncheck = true,
--                 test = true,
--                 tidy = true,
--                 upgrade_dependency = true,
--                 vendor = true
--             },
--
--             analyses = {
--                 fieldalignment = true,
--                 nilness = true,
--                 unusedparams = true,
--                 unusedwrite = true,
--                 useany = true,
--                 shadow = true
--                 -- simplifyslice = true
--             },
--             hints = {
--                 assignVariableTypes = true,
--                 compositeLiteralFields = true,
--                 compositeLiteralTypes = true,
--                 constantValues = true,
--                 functionTypeParameters = true,
--                 parameterNames = true,
--                 rangeVariableTypes = true
--             },
--             usePlaceholders = true,
--             completeUnimported = true,
--             staticcheck = true,
--             directoryFilters = {
--                 "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules"
--             },
--             semanticTokens = true
--
--         }
--     },
--     on_attach = lsp_common.on_attach
-- }

-- vim.lsp.set_log_level("debug")
