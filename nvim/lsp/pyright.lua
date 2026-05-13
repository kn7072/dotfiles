return {
    cmd = {"pyright-langserver", "--stdio"},
    -- filetypes = {"python"},
    -- root_markers = {
    --     "pyproject.toml", "pyrightconfig.json", "setup.py", "setup.cfg",
    --     "requirements.txt", "Pipfile", ".git"
    -- },
    -- settings = {
    --     pyright = {
    --         plugins = {
    --             black = {enabled = true},
    --             autopep8 = {enabled = true},
    --             yapf = {enabled = true},
    --             pylint = {enabled = true},
    --             pyflakes = {enabled = true},
    --             pycodestyle = {enabled = true},
    --             pylsp_mypy = {enabled = true},
    --             jedi_completion = {fuzzy = true},
    --             pyls_isort = {enabled = true},
    --             sort = {enabled = true}
    --         }
    --     }
    -- }

    --[[ Determines if a server is
    started without a matching root directory. See lspconfig-single-file-support. ]]
    single_file_support = true,
    settings = {
        python = {
            pythonPath = "/home/che/git/Machine-learning/.venv/bin/python",
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
