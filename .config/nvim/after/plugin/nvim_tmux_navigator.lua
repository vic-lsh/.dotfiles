local navigator = require('nvim-tmux-navigation')

vim.keymap.set('n', '<C-h>', navigator.NvimTmuxNavigateLeft, {})
vim.keymap.set('n', '<C-j>', navigator.NvimTmuxNavigateDown, {})
vim.keymap.set('n', '<C-k>', navigator.NvimTmuxNavigateUp, {})
vim.keymap.set('n', '<C-l>', navigator.NvimTmuxNavigateRight, {})
