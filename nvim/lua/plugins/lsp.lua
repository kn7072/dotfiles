-- vim.lsp.set_log_level("debug")
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
    "gopls", "pyright", "ts_ls", "lua_ls", "marksman", "bashls", "cssls",
    "yamlls", "html" -- ,"golangci_lint"
})

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(event)
        -- 'event.buf'  - номер буфера
        -- 'event.data.client_id' - ID подключившегося LSP-клиента
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        local bufnr = event.buf

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
        set_keymap("n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>",
                   get_opts({
            buffer = bufnr,
            desc = "Lists all diagnostics to the quickfix window"
        }))

        -- Set some keybinds conditional on server capabilities
        -- :lua vim.lsp.get_active_clients()[1].server_capabilities
        if client:supports_method("textDocument/formatting") then
            set_keymap("n", "<leader>fo", "<cmd>lua vim.lsp.buf.format()<CR>",
                       get_opts({buffer = bufnr}))
        elseif client:supports_method("textDocument/rangeFormatting") then
            set_keymap("n", "<leader>fr",
                       "<cmd>lua vim.lsp.buf.range_formatting()<CR>",
                       get_opts({buffer = bufnr}))
        end

        if client:supports_method("textDocument/inlayHint") then
            vim.keymap.set("n", "<leader>lih", function()
                vim.lsp.inlay_hint.enable(
                    not vim.lsp.inlay_hint.is_enabled({bufnr = bufnr}),
                    {bufnr = bufnr})
            end, get_opts({buffer = bufnr, desc = "Toggle Inlay Hints"}))
        end

        -- А здесь можно добавить логику для конкретного сервера, например, для Biome
        -- if client.name == "biome" then
        --     -- Ваша специфичная настройка для Biome
        --     vim.keymap.set("n", "<leader>bf", function()
        --         vim.lsp.buf.code_action({
        --             context = {only = {"source.fixAll.biome"}},
        --             apply = true
        --         })
        --     end, opts)
        -- end
    end
})

