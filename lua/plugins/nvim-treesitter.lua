return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      event = { "BufReadPost", "BufNewFile" },
    },
  },
  run = ":TSUpdate", -- Automatically update treesitter parsers after installation
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("nvim-ts-autotag").setup({
      ensure_installed = { "lua", "javascript", "go", "markdown", "markdown_inline" }, -- Add any additional languages you need
      ignore_install = { "phpdoc" },
      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true, -- Enable highlighting based on Treesitter
        additional_vim_regex_highlighting = { "sql" },
      },
      indent = {
        enable = true, -- Enable indentation based on Treesitter
      },
      -- === Treesitter Modules (Corrected Placement) ===
      -- These modules are configured directly within the main 'setup' table,
      -- as peer-level options to 'highlight' and 'indent'.
      -- The 'modules' key itself is not a valid top-level field.
      --
      modules = {},

      -- Textobjects (requires 'nvim-treesitter/nvim-treesitter-textobjects' plugin)
      -- Provides smart text selections (e.g., va), motions (e.g., dab), and swaps
      textobjects = {
        enable = true,
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            -- You can optionally set descriptions to the mappings (used in the desc parameter of
            -- nvim_buf_set_keymap) which plugins like which-key display
            ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
            -- You can also use captures from other query groups like `locals.scm`
            ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
          },
          selection_modes = {
            ["@parameter.outer"] = "v", -- charwise
            ["@function.outer"] = "V", -- linewise
            ["@class.outer"] = "<c-v>", -- blockwise
          },
          include_surrounding_whitespace = true,
        },
        move = {
          enable = true,
          -- See nvim-treesitter-textobjects documentation for 'move' keymaps
        },
        swap = {
          enable = true,
          swap_next = {
            ["<M-j>"] = "@parameter.inner",
          },
          swap_previous = {
            ["<M-k>"] = "@parameter.inner",
          },
        }, -- For a full list of built-in textobjects, check:
        -- :help nvim-treesitter-textobjects.builtin
      },

      -- Incremental Selection (requires 'nvim-treesitter/nvim-treesitter-incremental-selection' plugin)
      -- Allows you to incrementally expand or shrink a visual selection based on syntax nodes.
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>", -- Start incremental selection
          node_incremental = "<C-space>", -- Expand selection
          node_decremental = "<bs>", -- Shrink selection
          scope_incremental = "<tab>", -- Expand scope
        },
      },

      -- Context Commentstring (requires 'nvim-treesitter/nvim-treesitter-context-commentstring' plugin)
      -- Provides a smart comment string based on the current context (e.g., Lua `---`, HTML `<!-- -->`).
      context_commentstring = {
        enable = true,
        -- Options can be found in its plugin documentation
      },

      -- Autotag (requires 'windwp/nvim-ts-autotag' plugin - popular choice, often used with Treesitter)
      -- Automatically closes HTML/XML/JSX tags and renames paired tags.
      autotag = {
        enable = true,
      },
      -- Add other modules as needed, e.g., playground, refactor, folding
      --
    })
  end,
}
