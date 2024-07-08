-- This file can be loaded by calling `lua require('plugins')` from your init.vim
--

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- for some reason lazy.nvim resets leader key? need to re-setup here
vim.g.mapleader = " "

return require('lazy').setup({
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.3',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },

  {
      "nvim-treesitter/nvim-treesitter", 
      build = ":TSUpdate",
      config = function () 
        local configs = require("nvim-treesitter.configs")

        configs.setup({
            -- ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html" },
            sync_install = false,
            highlight = { enable = true },
            indent = { enable = true },  
          })
      end
  },

  'alexghergh/nvim-tmux-navigation',
  'itchyny/lightline.vim',
  'airblade/vim-gitgutter',

  -- -- use('kyazdani42/nvim-web-devicons')
  'kyazdani42/nvim-tree.lua',

  'windwp/nvim-autopairs',

  'sbdchd/neoformat',

  -- theme
  'morhetz/gruvbox',

  {
      'numToStr/Comment.nvim',
      opts = {
          -- add any options here
      },
      lazy = false,
  },

  'github/copilot.vim',

  {
      'VonHeikemen/lsp-zero.nvim',
      dependencies = {
    	  -- LSP Support
    	  'neovim/nvim-lspconfig',
    	  'williamboman/mason.nvim',
    	  'williamboman/mason-lspconfig.nvim',

    	  -- Autocompletion
    	  'hrsh7th/nvim-cmp',
    	  'hrsh7th/cmp-nvim-lsp',

    	  -- Snippets
    	  'L3MON4D3/LuaSnip',
      }
  },

  -- additional go support (lsp-zero's go lsp is broken)
  -- {
  --   "ray-x/go.nvim",
  --   dependencies = {  -- optional packages
  --     "ray-x/guihua.lua",
  --     "neovim/nvim-lspconfig",
  --     "nvim-treesitter/nvim-treesitter",
  --   },
  --   config = function()
  --     require("go").setup()
  --   end,
  --   event = {"CmdlineEnter"},
  --   ft = {"go", 'gomod'},
  --   build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
  -- }
})
