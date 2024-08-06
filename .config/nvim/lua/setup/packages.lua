local vim = vim
local Plug = vim.fn['plug#']

vim.call('plug#begin')

Plug('nvim-telescope/telescope.nvim')
Plug('nvim-lua/plenary.nvim')  -- telescope.nvim dependency
Plug('alexghergh/nvim-tmux-navigation')
Plug('itchyny/lightline.vim')
Plug('airblade/vim-gitgutter')
Plug('kyazdani42/nvim-tree.lua')
Plug('sbdchd/neoformat')
Plug('catppuccin/nvim')
Plug('nvim-treesitter/nvim-treesitter')
Plug('windwp/nvim-autopairs')
Plug('numToStr/Comment.nvim')

Plug('VonHeikemen/lsp-zero.nvim')
-- various lsp-dependencies
Plug('neovim/nvim-lspconfig')
Plug('williamboman/mason.nvim')
Plug('williamboman/mason-lspconfig.nvim')
Plug('hrsh7th/nvim-cmp')
Plug('hrsh7th/cmp-buffer')
Plug('hrsh7th/cmp-path')
Plug('saadparwaiz1/cmp_luasnip')
Plug('hrsh7th/cmp-nvim-lsp')
Plug('hrsh7th/cmp-nvim-lua')


vim.call('plug#end')
