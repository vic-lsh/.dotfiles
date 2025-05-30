vim.cmd([[
" auto close nvimtree if it's the last window
autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif
]])

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- setup with all defaults
-- each of these are documented in `:help nvim-tree.OPTION_NAME`
-- nested options are documented by accessing them with `.` (eg: `:help nvim-tree.view.mappings.list`).
require'nvim-tree'.setup { -- BEGIN_DEFAULT_OPTS
  renderer = {
      indent_markers = {
        enable = true,
      },
      icons = {
          show = {
              -- file = false,
              -- folder = false,
              -- folder_arrow = false,
          },
          glyphs = {
              git = {
                  unstaged = "*",
                  staged = "S",
                  unmerged = "!!",
                  renamed = "➜",
                  untracked = "U",
                  deleted = "D",
                  ignored = "◌",
              }
          }
      },
  },
  update_focused_file = {
    enable = true,
    update_cwd = false,
    ignore_list = {},
  },
--   auto_reload_on_write = true,
--   create_in_closed_folder = false,
--   disable_netrw = false,
--   hijack_cursor = false,
--   hijack_netrw = true,
--   hijack_unnamed_buffer_when_opening = false,
--   open_on_tab = true,
--   sort_by = "name",
--   update_cwd = false,
--   reload_on_bufenter = false,
--   respect_buf_cwd = false,
   view = {
     adaptive_size = true,
     width = 30,
     -- hide_root_folder = false,
     side = "right",
     -- preserve_window_proportions = false,
     -- number = false,
     -- relativenumber = false,
     -- signcolumn = "yes",
   },
--   -- renderer = {
--   --   add_trailing = false,
--   --   group_empty = false,
--   --   highlight_git = false,
--   --   highlight_opened_files = "none",
--   --   root_folder_modifier = ":~",
--   --   indent_markers = {
--   --     enable = false,
--   --     icons = {
--   --       corner = "└ ",
--   --       edge = "│ ",
--   --       none = "  ",
--   --     },
--   --   },
--   --   -- icons = {
--   --   --   webdev_colors = true,
--   --   --   git_placement = "before",
--   --   --   padding = " ",
--   --   --   symlink_arrow = " ➛ ",
--   --   --   show = {
--   --   --     file = true,
--   --   --     folder = true,
--   --   --     folder_arrow = true,
--   --   --     git = true,
--   --   --   },
--   --   --   glyphs = {
--   --   --     default = "",
--   --   --     symlink = "",
--   --   --     folder = {
--   --   --       arrow_closed = "",
--   --   --       arrow_open = "",
--   --   --       default = "",
--   --   --       open = "",
--   --   --       empty = "",
--   --   --       empty_open = "",
--   --   --       symlink = "",
--   --   --       symlink_open = "",
--   --   --     },
--   --   --     git = {
--   --   --       unstaged = "*",
--   --   --       staged = "S",
--   --   --       unmerged = "!!",
--   --   --       renamed = "➜",
--   --   --       untracked = "U",
--   --   --       deleted = "D",
--   --   --       ignored = "◌",
--   --   --     },
--   --   --   },
--   --   -- },
--   --   special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
--   -- },
--   hijack_directories = {
--     enable = true,
--     auto_open = true,
--   },
--   update_focused_file = {
--     enable = true,
--     update_cwd = false,
--     ignore_list = {},
--   },
--   system_open = {
--     cmd = "",
--     args = {},
--   },
--   diagnostics = {
--     enable = false,
--     show_on_dirs = false,
--     icons = {
--       hint = "",
--       info = "",
--       warning = "",
--       error = "",
--     },
--   },
--   filters = {
--     dotfiles = false,
--     custom = {},
--     exclude = {},
--   },
   git = {
     enable = true,
     ignore = false,
     timeout = 400,
   },
--   actions = {
--     use_system_clipboard = true,
--     change_dir = {
--       enable = true,
--       global = false,
--       restrict_above_cwd = false,
--     },
--     expand_all = {
--       max_folder_discovery = 300,
--     },
--     open_file = {
--       quit_on_open = false,
--       resize_window = true,
--       window_picker = {
--         enable = true,
--         chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
--         exclude = {
--           filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
--           buftype = { "nofile", "terminal", "help" },
--         },
--       },
--     },
--     remove_file = {
--       close_window = true,
--     },
--   },
--   trash = {
--     cmd = "trash",
--     require_confirm = true,
--   },
--   live_filter = {
--     prefix = "[FILTER]: ",
--     always_show_folders = true,
--   },
--   log = {
--     enable = false,
--     truncate = false,
--     types = {
--       all = false,
--       config = false,
--       copy_paste = false,
--       diagnostics = false,
--       git = false,
--       profile = false,
--     },
--   },
} -- END_DEFAULT_OPTS

local nvim_tree = require('nvim-tree.api')
vim.keymap.set('n', '<C-g>', nvim_tree.tree.toggle, {})

