-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Make Space+w close the current buffer
vim.keymap.set("n", "<leader>w", function()
  -- Check if buffer is modified
  if vim.bo.modified then
    -- Ask user to confirm before closing unsaved buffer
    local choice = vim.fn.confirm("Buffer has unsaved changes. Save changes?", "&Yes\n&No\n&Cancel", 1)
    if choice == 1 then     -- Yes
      vim.cmd("write")
      vim.cmd("bdelete")
    elseif choice == 2 then -- No
      vim.cmd("bdelete!")
    end
    -- For choice == 3 (Cancel), do nothing
  else
    -- Close buffer directly if not modified
    vim.cmd("bdelete")
  end
end, { desc = "Close current buffer" })
