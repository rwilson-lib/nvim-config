return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path", -- source for text in buffer
    { "L3MON4D3/LuaSnip", build = "make install_jsregexp" },
    "saadparwaiz1/cmp_luasnip", -- for autocompletion
    "rafamadriz/friendly-snippets", -- useful snippets
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    -- Load VSCode-style snippets from installed plugins (e.g. friendly-snippets)
    require("luasnip.loaders.from_vscode").lazy_load()

    cmp.setup({
      completion = {
        completeopt = "menu,menuone,preview,noselect",
      },
      snippet = { -- Configure how nvim-cmp interacts with snippet engine
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({ -- Corrected mapping preset usage
        ["<C-k>"] = cmp.mapping.select_prev_item(), -- Previous suggestion
        ["<C-j>"] = cmp.mapping.select_next_item(), -- Next suggestion
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(), -- Show completion suggestions
        ["<C-e>"] = cmp.mapping.abort(), -- Close completion window
        ["<CR>"] = cmp.mapping.confirm({ select = false }), -- Confirm selection
      }),
      -- Sources for autocompletion
      sources = cmp.config.sources({
        { name = "nvim_lsp" }, -- lsp
        { name = "luasnip" }, -- Snippets
        { name = "buffer" },  -- Text in current buffer
        { name = "path" },    -- File system paths
      }),
    })
  end,
}


