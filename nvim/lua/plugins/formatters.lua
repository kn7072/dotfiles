-- https://github.com/stevearc/conform.nvim?ysclid=mp43imm3t2292477501#list_all_formatters
require("conform").setup({
    -- Map of filetype to formatters
    formatters_by_ft = {
        lua = {"lua-format"},
        c = {"clang-format"},
        cpp = {"clang-format"},
        -- shfmt
        bash = {"shfmt"},
        sh = {"shfmt"},
        -- prettierd
        html = {"prettierd"},
        json = {"prettierd"},
        yaml = {"prettierd"},
        markdown = {"prettierd"},
        -- Conform will run multiple formatters sequentially
        go = {"goimports", "gofumpt"},
        -- You can also customize some of the format options for the filetype
        rust = {"rustfmt", lsp_format = "fallback"},
        python = {"ruff_format", "ruff_organize_imports"},
        -- Use the "*" filetype to run formatters on all filetypes.
        ["*"] = {"codespell"},

        -- Use the "_" filetype to run formatters on filetypes that don't
        -- have other formatters configured.
        ["_"] = {"trim_whitespace"}
    },
    -- If this is set, Conform will run the formatter on save.
    -- It will pass the table to conform.format().
    -- This can also be a function that returns the table.
    format_on_save = {
        -- I recommend these options. See :help conform.format for details.
        lsp_format = "fallback",
        timeout_ms = 500
    },
    -- If this is set, Conform will run the formatter asynchronously after save.
    -- It will pass the table to conform.format().
    -- This can also be a function that returns the table.
    format_after_save = {lsp_format = "fallback"},
    -- Set the log level. Use `:ConformInfo` to see the location of the log file.
    log_level = vim.log.levels.ERROR,
    -- Conform will notify you when a formatter errors
    notify_on_error = true,
    -- Conform will notify you when no formatters are available for the buffer
    notify_no_formatters = true,
    -- Custom formatters and overrides for built-in formatters
    formatters = {
        ["lua-format"] = {
            prepend_args = {
                "--config",
                vim.fn.stdpath("config") .. "/plugin_configs/lua-format.yaml"
            }
        },
        ["clang-format"] = {
            prepend_args = {
                string.format("--style=file:%s", vim.fn.stdpath("config") ..
                                  "/plugin_configs/.clang-format")
            }
        },
        shfmt = {
            args = {"-filename", "$FILENAME"},
            prepend_args = {"-i", "2", "-ci"}
        },
        ruff_format = {
            prepend_args = {
                "--config",
                vim.fn.stdpath("config") .. "/plugin_configs/ruff.toml"
            }
        }
    }
})
