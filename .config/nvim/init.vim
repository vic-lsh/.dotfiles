set number
set noerrorbells
set belloff=all
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent

set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set signcolumn=yes
set colorcolumn=80
set noshowmode  " no -- INSERT -- because of a fancier status bar

" case-insensitive search when /lowercase
" case-sensitive search when /ContainsUppercase
set ignorecase
set smartcase

set wildignore+=*.o

" jsonc syntax highlighting
autocmd FileType json syntax match Comment +\/\/.\+$+

highlight clear SignColumn

highlight ColorColumn ctermbg=233
" change color of popup menu
highlight Pmenu ctermbg=black guibg=black guifg=white ctermfg=white
" change color of vertical pane separator
highlight VertSplit cterm=NONE

" highlight Comment ctermfg=grey

source $HOME/.config/nvim/plugins.vim

lua require('lsp_config')
lua require('nvimtree_config')
lua require('telescope_config')
lua require('hrsh7th_cmp_config')
lua require('treesitter_config')

if executable('rg')
    let g:rg_derive_root='true'
endif

let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '>'
let g:gitgutter_sign_removed = '-'
let g:gitgutter_sign_removed_first_line = '^'
let g:gitgutter_sign_modified_removed = '<'

let g:lightline = {
      \ 'colorscheme': 'powerlineish',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead',
      \   'filename': 'FilenameForLightline'
      \ },
      \ }

" Show full path of filename
function! FilenameForLightline()
    return fnamemodify(expand("%"), ":~:.")
endfunction

let mapleader=" "

" filetree tweaks
let g:netrw_browse_split=2
let g:netrw_banner=0
let g:netrw_winsize=25
let g:nvim_tree_show_icons = {
    \ 'git': 1,
    \ 'folders': 0,
    \ 'files': 0,
    \ 'folder_arrows': 0,
    \ }

" clang-format settings
let g:clang_format#detect_style_file=1
let g:clang_format#auto_format=1

" ctrl-w wincmd remaps
nnoremap <leader>h :wincmd h<CR>    
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>
nnoremap <leader><Left> :wincmd h<CR>    
nnoremap <leader><Down> :wincmd j<CR>
nnoremap <leader><Up> :wincmd k<CR>
nnoremap <leader><Right> :wincmd l<CR>

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>gl <cmd>Telescope git_commits<cr>
nnoremap <leader>gs <cmd>Telescope git_status<cr>
nnoremap <leader>gb <cmd>Telescope git_branches<cr>

" Code navigation shortcuts
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> L     <cmd>lua vim.diagnostic.open_float()<CR>
nnoremap <silent> gi    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> rn    <cmd>lua vim.lsp.buf.rename()<CR>

" quickly switch between source / header file (C/C++)
nnoremap <leader>a :ClangdSwitchSourceHeader<CR>
nnoremap <silent> <c-a> :ClangdSwitchSourceHeader<CR>

nnoremap <C-n> :NvimTreeToggle<CR>

" go to prev / next buffer
nnoremap <C-p> :bp<CR>
nnoremap <C-n> :bn<CR>

" nvim-tmux-navigator configs
nnoremap <silent> <C-h> :lua require'nvim-tmux-navigation'.NvimTmuxNavigateLeft()<cr>
nnoremap <silent> <C-j> :lua require'nvim-tmux-navigation'.NvimTmuxNavigateDown()<cr>
nnoremap <silent> <C-k> :lua require'nvim-tmux-navigation'.NvimTmuxNavigateUp()<cr>
nnoremap <silent> <C-l> :lua require'nvim-tmux-navigation'.NvimTmuxNavigateRight()<cr>
nnoremap <silent> <C-\> :lua require'nvim-tmux-navigation'.NvimTmuxNavigateLastActive()<cr>
nnoremap <silent> <C-Space> :lua require'nvim-tmux-navigation'.NvimTmuxNavigateNext()<cr>

nnoremap <silent> <C-t> :ToggleTerm<cr>

" auto-format
" autocmd! BufWritePre <buffer> lua vim.lsp.buf.formatting()
autocmd BufWritePre * lua vim.lsp.buf.format { async = true }

" Ignore files (for ctrl-p, among other things)
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ }

" Set completeopt to have a better completion experience
" :help completeopt
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect

" Avoid showing extra messages when using completion
set shortmess+=c

" C/C++ setup
lua <<EOF
require'lspconfig'.clangd.setup{
    filetypes = { "c", "cpp", "objc", "objcpp", "cc" }
}
EOF

" Golang setup
lua <<EOF
require'lspconfig'.gopls.setup{}
EOF

" Rust setup
lua <<EOF
require('rust-tools').setup({
    tools = {
        autoSetHints = false
    },
    server = {
        settings = {
            ["rust-analyzer"] = {
                checkOnSave = {
                    command = "clippy"
                }
            }
        }
    }
})
EOF

" Python setup
lua <<EOF
require'lspconfig'.pyright.setup{}
EOF

"auto-close config
lua <<EOF
require('nvim-autopairs').setup{}
EOF

" toggle term
lua <<EOF
require("toggleterm").setup{}
EOF
