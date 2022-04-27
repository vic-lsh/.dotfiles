" list of plugins. using vimplug
call plug#begin("~/.config/nvim/plugged")
Plug 'tpope/vim-fugitive'       "for git blame and stuff

Plug 'dstein64/vim-startuptime'

Plug 'airblade/vim-gitgutter'
Plug 'itchyny/lightline.vim'
Plug 'ap/vim-css-color'

" C/C++
Plug 'rhysd/vim-clang-format'
Plug 'octol/vim-cpp-enhanced-highlight'

" File tree stuff
Plug 'kyazdani42/nvim-web-devicons' " for file icons
Plug 'kyazdani42/nvim-tree.lua'

Plug 'windwp/nvim-autopairs'        "auto-close brackets, etc

" Collection of common configurations for the Nvim LSP client
Plug 'neovim/nvim-lspconfig'

Plug 'hrsh7th/nvim-cmp'         " Completion framework
Plug 'hrsh7th/cmp-nvim-lsp'     " LSP completion source for nvim-cmp
Plug 'hrsh7th/cmp-vsnip'        " Snippet completion source for nvim-cmp
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-buffer'
" See hrsh7th's other plugins for more completion sources!

" To enable more of the features of rust-analyzer, such as inlay hints and more!
Plug 'simrat39/rust-tools.nvim'

" Fuzzy finder
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" More syntax highlighting
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

call plug#end()
