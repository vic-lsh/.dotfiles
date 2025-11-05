-- lua/plugins.lua (or wherever you load it from)
-- Must be at the very top of your init
if vim.loader then vim.loader.enable() end

-- Disable unused external providers early
vim.g.loaded_python_provider  = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider    = 0
vim.g.loaded_perl_provider    = 0
vim.g.loaded_node_provider    = 0

-- lazy.nvim bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- leader must be set before plugins
vim.g.mapleader = " "

require("lazy").setup({
  ---------------------------------------------------------------------------
  -- UI / Theme
  ---------------------------------------------------------------------------
  {
    "projekt0n/github-nvim-theme",
    lazy = false,
    priority = 1000, -- make its hl groups available early when loaded
    opts = { options = { transparent = false } },
    config = function(_, opts)
      require("github-theme").setup(opts)
      vim.cmd.colorscheme("github_dark_high_contrast")
    end,
  },
  -- {
  --   "morhetz/gruvbox",
  --   lazy = true,
  --   priority = 1000,
  -- },

  -- Light statusline; load after UI is up, not at time 0
  { "itchyny/lightline.vim", event = "VeryLazy" },

  ---------------------------------------------------------------------------
  -- Core UX
  ---------------------------------------------------------------------------
  -- Icons: keep devicons but make it lazy (or swap to mini.icons for speed)
  { "nvim-tree/nvim-web-devicons", lazy = true, opts = {} },

  -- File explorer: only when you ask for it
  {
    "nvim-tree/nvim-tree.lua",      -- NOTE: new repo (kyazdani42 -> nvim-tree)
    lazy = false,
    cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFindFile" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "File explorer" },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    init = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
    config = function()
      require("nvim-tree").setup({
        hijack_netrw = false,
        disable_netrw = true,
        renderer = {
          icons = {
            show = {
              git = false,
              modified = false,
              diagnostics = false,
              bookmarks = false,
            },
          },
          indent_markers = {
            enable = true,
          },
        },
        update_focused_file = {
          enable = true,
          update_cwd = false,
          ignore_list = {},
        },
        git = {
          enable = true,
          ignore = false,
          timeout = 400,
        },
        view = {
          adaptive_size = true,
          width = 30,
          side = "right",
        },
      })

      local api = require("nvim-tree.api")
      vim.keymap.set("n", "<C-g>", api.tree.toggle, { desc = "Toggle nvim-tree" })

      local autocmd_group = vim.api.nvim_create_augroup("nvim_tree_auto_close", { clear = true })
      vim.api.nvim_create_autocmd("BufEnter", {
        group = autocmd_group,
        pattern = "NvimTree_*",
        nested = true,
        callback = function()
          if #vim.api.nvim_list_wins() == 1 then
            vim.cmd("quit")
          end
        end,
      })
    end,
  },

  -- Telescope: load on command
  {
    "nvim-telescope/telescope.nvim",
    version = "0.1.3",
    cmd = "Telescope",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find files" },
      { "<leader>fg", function() require("telescope.builtin").live_grep() end, desc = "Live grep" },
      { "<leader>fb", function() require("telescope.builtin").buffers() end, desc = "Buffers" },
      { "<leader>fh", function() require("telescope.builtin").help_tags() end, desc = "Help tags" },
      { "<leader>gl", function() require("telescope.builtin").git_commits() end, desc = "Git commits" },
      { "<leader>gs", function() require("telescope.builtin").git_status() end, desc = "Git status" },
      { "<leader>gb", function() require("telescope.builtin").git_branches() end, desc = "Git branches" },
    },
    config = function()
      require("telescope").setup({})
    end,
  },

  -- Treesitter: only once a buffer is about to open
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")
      configs.setup({
        -- ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html" },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
        textobjects = {
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = { query = "@class.outer", desc = "Next class start" },
              ["]o"] = "@loop.*",
              ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
              ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[]"] = "@class.outer",
            },
            goto_next = {
              ["]d"] = "@conditional.outer",
            },
            goto_previous = {
              ["[d"] = "@conditional.outer",
            },
          },
        },
      })

      local function neutralize_ts_inactive()
        for _, grp in ipairs({
          "@inactive",
          "@c.inactive",
          "@preproc.inactive",
          "@conditional.inactive",
        }) do
          pcall(vim.api.nvim_set_hl, 0, grp, { link = "Normal" })
        end
      end

      neutralize_ts_inactive()
      vim.api.nvim_create_autocmd("ColorScheme", { callback = neutralize_ts_inactive })
    end,
  },

  -- Comment: load on first use of keymaps
  {
    "numToStr/Comment.nvim",
    keys = {
      { "gc", mode = { "n", "v" }, desc = "Comment toggle" },
      { "gb", mode = { "n", "v" }, desc = "Block comment toggle" },
    },
    opts = {},
  },

  -- Autopairs: only when you start typing
  { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },

  -- Git signs (you use gitgutter; keep it but defer it)
  { "airblade/vim-gitgutter", event = "BufReadPre" },

  -- Copilot: don’t initialize at time 0
  { "github/copilot.vim", event = "InsertEnter" },

  -- Neoformat: only when you run the command
  { "sbdchd/neoformat", cmd = { "Neoformat" } },

  -- Tmux nav: binds are cheap; defer to VeryLazy to avoid time-0 work
  {
    "alexghergh/nvim-tmux-navigation",
    event = "VeryLazy",
    config = function()
      local navigator = require("nvim-tmux-navigation")
      navigator.setup({})
      vim.keymap.set("n", "<C-h>", navigator.NvimTmuxNavigateLeft, { desc = "TMUX left" })
      vim.keymap.set("n", "<C-j>", navigator.NvimTmuxNavigateDown, { desc = "TMUX down" })
      vim.keymap.set("n", "<C-k>", navigator.NvimTmuxNavigateUp, { desc = "TMUX up" })
      vim.keymap.set("n", "<C-l>", navigator.NvimTmuxNavigateRight, { desc = "TMUX right" })
    end,
  },

  -- Config-local: only when entering a dir/file; not at cold boot
  {
    "klen/nvim-config-local",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      config_files = { ".nvim.lua", ".nvimrc", ".exrc" },
      hashfile = vim.fn.stdpath("data") .. "/config-local",
      autocommands_create = true,
      commands_create = true,
      silent = false,
      lookup_parents = false,
    },
  },

  ---------------------------------------------------------------------------
  -- LSP stack (defer to file open)
  ---------------------------------------------------------------------------
  {
    "VonHeikemen/lsp-zero.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      -- LSP
      { "neovim/nvim-lspconfig" },
      { "williamboman/mason.nvim", build = ":MasonUpdate", cmd = "Mason" },
      { "williamboman/mason-lspconfig.nvim" },

      -- Autocomplete
      {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
          "hrsh7th/cmp-buffer",
          "hrsh7th/cmp-path",
          "saadparwaiz1/cmp_luasnip",
          "hrsh7th/cmp-nvim-lsp",
          "hrsh7th/cmp-nvim-lua",
        },
        config = function()
          local cmp = require("cmp")
          cmp.setup({
            sources = {
              { name = "nvim_lsp" },
            },
            mapping = cmp.mapping.preset.insert({
              ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = "select" }),
              ["<C-n>"] = cmp.mapping.select_next_item({ behavior = "select" }),
              ["<CR>"] = cmp.mapping.confirm({ select = false }),
              ["<C-Space>"] = cmp.mapping.complete(),
              ["<C-u>"] = cmp.mapping.scroll_docs(-4),
              ["<C-d>"] = cmp.mapping.scroll_docs(4),
            }),
            snippet = {
              expand = function(args)
                vim.snippet.expand(args.body)
              end,
            },
          })
        end,
      },

      -- Snippets
      { "rafamadriz/friendly-snippets", event = "InsertEnter" },
    },
    config = function()
      vim.opt.signcolumn = "yes"

      local lspconfig = require("lspconfig")
      local lspconfig_defaults = lspconfig.util.default_config

      local capabilities = lspconfig_defaults.capabilities
      local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      if ok then
        capabilities = vim.tbl_deep_extend("force", capabilities, cmp_nvim_lsp.default_capabilities())
      end
      lspconfig_defaults.capabilities = capabilities

      vim.api.nvim_create_autocmd("LspAttach", {
        desc = "LSP actions",
        callback = function(event)
          local opts = { buffer = event.buf }

          vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
          vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
          vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
          vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
          vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
          vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
          vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
          vim.keymap.set("n", "rn", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
          vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
          vim.keymap.set("n", "ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
          vim.keymap.set("n", "<leader>vd", "<cmd>lua vim.diagnostic.open_float()<cr>", opts)
        end,
      })

      require("mason").setup({})
      require("mason-lspconfig").setup({
        handlers = {
          function(server_name)
            lspconfig[server_name].setup({})
          end,
        },
      })
    end,
  },
}, {
  -- 👇 Global lazy settings & perf tweaks
  defaults = { lazy = true },            -- opt-in lazy-loading for all
  install  = { colorscheme = { "habamax" } }, -- super-light fallback
  checker  = { enabled = false },        -- no background update checks at startup
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip", "zipPlugin", "tarPlugin", "tohtml",
        "netrw", "netrwPlugin", "netrwSettings", "netrwFileHandlers",
        "rplugin", "tutor",
      },
    },
  },
})
