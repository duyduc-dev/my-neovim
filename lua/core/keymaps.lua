

-- define function map()
local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.keymap.set(mode, lhs, rhs, options)
end


-- tab
-- -- BufferLine
map('n', '<tab>', '<cmd>BufferLineCycleNext<cr>');
map('n', '<s-tab>', '<cmd>BufferLineCyclePrev<cr>');


-- save file
map({"i", "v", "n", "s"}, "<C-s>", "<cmd>w<cr><esc>");

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })
