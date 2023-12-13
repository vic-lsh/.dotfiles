vim.opt.termguicolors = false

vim.api.nvim_set_hl(0, 'ColorColumn', {ctermbg='DarkGrey'})
vim.api.nvim_set_hl(0, 'SignColumn', {})
vim.api.nvim_set_hl(0, 'Pmenu', {bg='black', fg='white'})
-- maybe tweak comment's color to something less obstrusive
vim.api.nvim_set_hl(0, 'Comment', {ctermfg='Grey'})
