-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- vim.keymap.set(
--   "n",
--   "<leader>sx",
--   require("telescope.builtin").resume,
--   { noremap = true, silent = true, desc = "Resume" }
-- )

-- Function to map keys in insert mode ('i')
local function imap(lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap("i", lhs, rhs, options)
end

-- Function to map keys in normal mode ('n')
local function nmap(lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap("n", lhs, rhs, options)
end

-- Function to map keys in visual mode ('v')
local function vmap(lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap("v", lhs, rhs, options)
end

-- Function to map keys in selection mode ('s')
local function smap(lhs, rhs, opts)
  local options = { noremap = true, silent = true }

  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap("s", lhs, rhs, options)
end

-- Arbitrary mode key mapping function
-- modes: {"i", "n"} to do both insert and normal mode for example
local function keymap(modes, lhs, rhs, opts)
  local options = { noremap = true, silent = true }

  if opts then
    options = vim.tbl_extend("force", options, opts)
  end

  for index, value in ipairs(modes) do
    vim.api.nvim_set_keymap(value, lhs, rhs, options)
  end
end

-- Navbuddy
nmap("<C-k>", "<cmd>Navbuddy<CR>")
imap("<C-k>", "<Esc><cmd>Navbuddy<CR>")

-- Arrow keys more natural in normal mode
nmap("<C-Right>", "<S-Right>", {})
nmap("<C-Left>", "<S-Left>", {})

-- Mapping for CTRL + W (close the currently open tab)
imap("<C-w>", "<Esc><cmd>bd<CR>", {})
nmap("<C-w>", "<cmd>bd<CR>", {})

-- Mapping for CTRL + N (new buffer/tab)
imap("<C-n>", "<Esc><cmd>enew<CR>", {})
nmap("<C-n>", "<cmd>enew<CR>", {})

-- Fun fact: To open the terminal, it is CTRL + /
-- if I need a separate terminal tab, it would be :term

-- Scrolling
nmap("<C-Up>", "<C-Y>")
nmap("<C-Down>", "<C-E>")
imap("<C-Up>", "<C-O><C-Y>")
imap("<C-Down>", "<C-O><C-E>")

-- Switch tabs
-- next
imap("<C-E>", "<C-O>:bnext<CR>", {})
nmap("<C-E>", "<cmd>bnext<CR>", {})
-- prev
imap("<C-Q>", "<C-O>:bprev<CR>", {})
nmap("<C-Q>", "<cmd>bprev<CR>")

-- Fix CTRL + Backspace
imap("<C-H>", "<C-O>:call novim_mode#EnterSelectionMode('left')<CR><C-S-Left><Backspace>", {})
imap("<C-bs>", "<C-O>:call novim_mode#EnterSelectionMode('left')<CR><C-S-Left><Backspace>", {})

-- Mass Commenting with ALT+x
local comment_api = require("Comment.api")
vim.keymap.set("s", "<A-x>", comment_api.call("toggle.linewise", "g@"), { expr = true })
vim.keymap.set("v", "<A-x>", comment_api.call("toggle.linewise", "g@"), { expr = true })
--smap("<A-x>", "<C-O>:call novim_mode#EnterSelectionMode('comment')<CR>")

-- Fix keys like CTRL+C, CTRL+Z, even CTRL+V
-- keymap({ "n", "v", "s" }, "<C-z>", "u")
-- keymap({ "v" }, "<C-c>", '"+y')
-- keymap({ "n", "v", "s" }, "<C-v>", '"+pi')
nmap("<C-z>", "u")
vmap("<C-z>", "u")
vmap("<C-c>", '"+y')
nmap("<C-v>", '"+pi')

--TODO: fix the bug where backspace/delete on selection copies it

-- Low-effort esc (ALT + Q)
imap("<A-q>", "<Esc>")

-- Move to end of a line immediately while in insert mode
-- Actually, who needs this when you got the arrow keys of going to the next line and coming back??? Genius ik
--imap("<C-;>", "<Esc>$i")

--NOTE: the functions below MUST be global (no local indicator) in order to run in the string commands

-- Will move to the previous line if at the start of a line
function attempt_move_left()
  if vim.fn.col(".") ~= 1 then
    -- Base case: do nothing
    vim.cmd("normal! h") -- literally just move left
  else
    -- Move to end of previous line
    vim.cmd("normal! k$")
  end
end

-- Will move to the next line if at the end of a line
function attempt_move_right()
  if vim.fn.col(".") ~= vim.fn.col("$") then
    -- Base Case
    vim.cmd("normal! l") -- literally just move right
  else
    -- Move to start of next line
    vim.cmd("normal! j0")
  end
end

-- Will move to the start of the line if on the first line
function attempt_move_up()
  if vim.fn.line(".") ~= 1 then
    -- Base Case
    vim.cmd("normal! k") -- literally just move up
  else
    -- Move to the start of the line
    vim.cmd("normal! 0")
  end
end

-- Will move to the end of the line if on the last line
function attempt_move_down()
  if vim.fn.line(".") ~= vim.fn.line("$") then
    -- Base Case
    vim.cmd("normal! j") -- literally just move down
  else
    -- Move to end of the line
    vim.cmd("normal! $")
  end
end

-- NOTE: if all these arrow hax start acting up, comment them out. They are a bit sus

-- Left
nmap("<Left>", "<cmd>lua attempt_move_left()<CR>")
imap("<Left>", "<C-O><cmd>lua attempt_move_left()<CR>")

-- Right
nmap("<Right>", "<cmd>lua attempt_move_right()<CR>")
imap("<Right>", "<C-O><cmd>lua attempt_move_right()<CR>")

-- Up
nmap("<Up>", "<cmd>lua attempt_move_up()<CR>")
imap("<Up>", "<C-O><cmd>lua attempt_move_up()<CR>")

-- Down
--keymap({ "i", "n" }, "<Down>", "<Down>")
nmap("<Down>", "<cmd>lua attempt_move_down()<CR>")
imap("<Down>", "<C-O><cmd>lua attempt_move_down()<CR>")

-- Better suggestions; CTRL + Space behaves like vscode
--imap("<C-space>", "<C-p>")
