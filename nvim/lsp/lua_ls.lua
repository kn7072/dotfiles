return {
    cmd = {'lua-language-server'},
    -- Файлы, для которых этот сервер будет включаться
    filetypes = {'lua'},
    single_file_support = true,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using
                -- (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT'
            },

            workspace = {checkThirdParty = false},
            completion = {
                enable = true,
                workspaceWord = true,
                callSnippet = "Both"
            },
            misc = {
                parameters = {
                    -- "--log-level=trace",
                }
            },
            hint = {
                enable = true,
                setType = false,
                paramType = true,
                paramName = "All",
                semicolon = "All",
                arrayIndex = "Disable"
            },
            doc = {privateName = {"^_"}},
            type = {castNumberToInteger = true},
            diagnostics = {
                enable = true,
                disable = {"incomplete-signature-doc", "trailing-space"},
                -- enable = false,
                groupSeverity = {strong = "Warning", strict = "Warning"},
                groupFileStatus = {
                    ["ambiguity"] = "Opened",
                    ["await"] = "Opened",
                    ["codestyle"] = "None",
                    ["duplicate"] = "Opened",
                    ["global"] = "Opened",
                    ["luadoc"] = "Opened",
                    ["redefined"] = "Opened",
                    ["strict"] = "Opened",
                    ["strong"] = "Opened",
                    ["type-check"] = "Opened",
                    ["unbalanced"] = "Opened",
                    ["unused"] = "Opened"
                },
                unusedLocalExclude = {"_*"},
                globals = {
                    "vim", "assert", "describe", "it", "before_each",
                    "after_each", "pending", "clear", "G_P", "G_R"
                }

            },
            format = {
                enable = false,
                defaultConfig = {
                    indent_style = "space",
                    indent_size = "4",
                    continuation_indent_size = "4"
                }
            }
        }
    }
}
