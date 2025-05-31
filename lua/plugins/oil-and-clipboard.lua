return {
  -- File explorer with oil.nvim
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      -- Oil configuration
      default_file_explorer = true,
      columns = {
        "icon",
        "permissions",
        "size",
        "mtime",
      },
      -- Buffer-local options for oil buffers
      buf_options = {
        buflisted = false,
        bufhidden = "hide",
      },
      -- Window-local options for oil buffers
      win_options = {
        wrap = false,
        signcolumn = "no",
        cursorcolumn = false,
        foldcolumn = "0",
        spell = false,
        list = false,
        conceallevel = 3,
        concealcursor = "nvic",
      },
      keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["<C-v>"] = "actions.select_vsplit",
        ["<C-s>"] = "actions.select_split",
        ["<C-t>"] = "actions.select_tab",
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = "actions.close",
        ["<C-r>"] = "actions.refresh",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["`"] = "actions.cd",
        ["~"] = "actions.tcd",
        ["gs"] = "actions.change_sort",
        ["gx"] = "actions.open_external",
        ["g."] = "actions.toggle_hidden",
      },
      -- Set to false to disable all of the above keymaps
      use_default_keymaps = true,
      view_options = {
        -- Show files and directories that start with "."
        show_hidden = false,
        -- This function defines what is considered a "hidden" file
        is_hidden_file = function(name, _)
          return vim.startswith(name, ".")
        end,
      },
    },
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "-", "<CMD>Oil<CR>", desc = "Open parent directory with Oil" },
    },
  },

  -- Configure clipboard integration
  {
    "LazyVim/LazyVim",
    opts = function(_, opts)
      -- Set clipboard to use system clipboard
      vim.opt.clipboard = "unnamedplus"

      -- Add Ctrl+A to select all text and copy to clipboard
      vim.keymap.set("n", "<C-a>", function()
        vim.cmd("normal! ggVG")
        vim.cmd("normal! \"+y")
        vim.notify("File content copied to clipboard", vim.log.levels.INFO)
      end, { desc = "Select all content and copy to clipboard" })
    end,
  },
}