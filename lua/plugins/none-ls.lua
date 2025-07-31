return {
  {
    "nvimtools/none-ls.nvim",
    event = "BufReadPre",
    config = function()
      -- 2. null-ls setup with formatter and autoformat on save
      local null_ls = require("null-ls")

      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.pg_format, -- pgformatter integration
          null_ls.builtins.formatting.goimports, -- go integration
          null_ls.builtins.formatting.stylua, -- lua formatter
          null_ls.builtins.formatting.prettier, -- js/ts formatter
          -- add more sources if needed
        },
        on_attach = function(client, bufnr)
          if client:supports_method("textDocument/formatting") then
            -- Create (or get) the augroup once
            local group = vim.api.nvim_create_augroup("LspFormatting", { clear = false })

            -- Clear any existing autocmds in this group for this buffer
            vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })

            -- Create autocmd to format before save
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = group,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({
                  bufnr = bufnr,
                  filter = function(format_client)
                    return format_client.name == "null-ls" -- only use null-ls to format
                  end,
                })
              end,
            })
          end
        end,
      })
    end,
  },
}
