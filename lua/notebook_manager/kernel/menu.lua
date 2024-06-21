local popup = require('plenary.popup')
local KernelManager = require('notebook_manager.kernel.manager')
local TomlManager = require('notebook_manager.toml.manager')

local KernelMenu = {}
KernelMenu.__index = KernelMenu

local function new()
  local instance = setmetatable({}, KernelMenu)
  instance.manager = KernelManager:get_instance()
  instance.package = TomlManager:get_instance()
  instance.borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }
  instance.width = 50
  instance.height = 20
  instance.zindex = 100
  instance.title = "Jupyter Kernels"
  return instance
end

function KernelMenu:get_instance()
  if not self.instance then
    self.instance = new()
  end
  return self.instance
end

function KernelMenu:show()
  local kernels = self.manager:get_kernels(self.package)
  local menu = popup.create(
    kernels,
    {
      title = self.title,
      highlight = "Normal",
      borderhighlight = "FloatBorder",
      line = math.floor((vim.o.lines - self.height) / 2),
      col = math.floor((vim.o.columns - self.width) / 2),
      minwidth = self.width,
      minheight = self.height,
      borderchars = self.borderchars,
      zindex = self.zindex
    }
  )

  local buf = vim.api.nvim_win_get_buf(menu)

  -- Register keymaps
  vim.api.nvim_buf_set_keymap(buf, 'n', 'd',
    [[<cmd>lua require('notebook_manager.kernel.menu').get_instance():delete()<CR>]],
    { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '<cmd>bwipeout!<CR>', { noremap = true, silent = true })

  -- Disable left/right movement
  vim.api.nvim_buf_set_keymap(buf, 'n', 'h', '', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', 'l', '', { noremap = true, silent = true })

  -- Disable movement in the header
  vim.api.nvim_buf_set_keymap(buf, 'n', 'k', 'gk', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', 'j', 'gj', { noremap = true, silent = true })
  vim.api.nvim_buf_set_var(buf, 'kernels', kernels)
end

function KernelMenu:delete()
  local buf = vim.api.nvim_get_current_buf()
  local line = vim.api.nvim_win_get_cursor(0)[1]
  local kernels = vim.api.nvim_buf_get_var(buf, 'kernels')
  local kernel_name = kernels[line]
  local exit = function(j, return_val)
    if return_val == 0 then
      vim.schedule(function()
        -- Remove the deleted kernel from the list
        for i, k in ipairs(kernels) do
          if k == kernel_name then
            table.remove(kernels, i)
            break
          end
        end
        -- Update the buffer with the new list of kernels
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, kernels)
        -- Update the kernels variable in the buffer
        vim.api.nvim_buf_set_var(buf, 'kernels', kernels)
      end)
    end
  end
  vim.ui.input({ prompt = "Delete kernel: " .. kernel_name .. " [y/n]? " }, function(input)
    if input == 'y' then
      self.manager:delete_kernel(kernel_name, self.package.manager.cli, exit)
    end
  end)
end

return KernelMenu