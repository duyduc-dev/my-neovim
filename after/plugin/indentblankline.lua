--vim.opt.termguicolors = true
--vim.cmd [[highlight IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine]]


--	vim.opt.list = true
--vim.opt.listchars:append "space:⋅"

require("indent_blankline").setup {
    -- for example, context is off by default, use this to turn it on
    char = "│",
    filetype_exclude = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason" },
    show_current_context = false,
    show_end_of_line = true,
    space_char_blankline = " ",
    --char_highlight_list = {
    --    "IndentBlanklineIndent1",
    --},
    show_trailing_blankline_indent = true,

}
