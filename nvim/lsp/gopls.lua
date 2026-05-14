local hints = {
    assignVariableTypes = true,
    compositeLiteralFields = true,
    compositeLiteralTypes = true,
    constantValues = true,
    functionTypeParameters = true,
    parameterNames = true,
    rangeVariableTypes = true
}

-- Регистрируем новый тип файла 'gotmpl' для расширения .gotmpl
vim.filetype.add({
    extension = {
        gotmpl = 'gotmpl'
        -- Если у вас есть другие похожие расширения, их тоже можно добавить
        -- tpl = 'gotmpl',
    }
})

return {
    cmd = {"gopls"},
    filetypes = {"go", "gomod", "gowork", "gotmpl"},
    root_markers = {"go.work", "go.mod", ".git"},
    -- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
    -- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md
    -- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
    -- https://github.com/golang/tools/blob/master/gopls/doc/inlayHints.md
    settings = {
        gopls = {
            codelenses = {
                test = true,
                regenerate_cgo = true,
                gc_details = true,
                generate = true,
                run_govulncheck = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true
            },
            gofumpt = true,
            completeUnimported = true,
            usePlaceholders = true,
            diagnosticsDelay = "100ms",
            staticcheck = true,
            directoryFilters = {
                "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules"
            },
            semanticTokens = true,
            hints = hints,
            analyses = {
                modernize = true,
                unusedparams = true,
                framepointer = true,
                sigchanyzer = true,
                unreachable = true,
                stdversion = true,
                unusedwrite = true,
                unusedvariable = true,
                useany = true,
                nilness = true
            }
        }
    }
}
