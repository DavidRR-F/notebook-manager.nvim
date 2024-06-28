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
  instance.maxheight = 20
  instance.minheight = 10
  instance.zindex = 100
  instance.title = "Jupyter Kernels"
  instance.buf = nil
  instance.win = nil
  instance.kernels = {}
  return instance
end

function KernelMenu:get_instance()
  if not self.instance then
    self.instance = new()
  end
  return self.instance
end

function KernelMenu:open()
  self.kernels = self.manager:get_kernels(self.package)
  self.win = popup.create(
    self.kernels,
    {
      title = self.title,
      highlight = "Normal",
      borderhighlight = "FloatBorder",
      cursorline = true,
      maxwidth = self.width,
      maxheight = self.maxheight,
      line = math.floor((vim.o.lines - self.minheight) / 2),
      col = math.floor((vim.o.columns - self.width) / 2),
      minwidth = self.width,
      minheight = self.minheight,
      borderchars = self.borderchars,
      zindex = self.zindex
    }
  )

  self.buf = vim.api.nvim_win_get_buf(self.win)

  vim.bo[self.buf].buftype = 'nofile'
  vim.bo[self.buf].bufhidden = 'wipe'
  vim.bo[self.buf].filetype = 'popup'

  vim.api.nvim_command('highlight PopupCursor guifg=none guibg=none')

  self.kernels = self.manager:get_kernels(self.package)
  self.win = popup.create(
    self.kernels,
    {
      title = self.title,
      highlight = "Normal",
      borderhighlight = "FloatBorder",
      cursorline = true,
      maxwidth = self.width,
      maxheight = self.maxheight,
      line = math.floor((vim.o.lines - self.minheight) / 2),
      col = math.floor((vim.o.columns - self.width) / 2),
      minwidth = self.width,
      minheight = self.minheight,
      borderchars = self.borderchars,
      zindex = self.zindex
    }
  )

  self.buf = vim.api.nvim_win_get_buf(self.win)

  vim.bo[self.buf].buftype = 'nofile'
  vim.bo[self.buf].bufhidden = 'wipe'
  vim.bo[self.buf].filetype = 'popup'

  -- Register keymaps
  vim.api.nvim_buf_set_keymap(self.buf, 'n', 'd',
    [[<cmd>lua require('notebook_manager.commands').kernel_menu_delete()<CR>]],
    { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(self.buf, 'n', 'a',
    [[<cmd>lua require('notebook_manager.commands').kernel_menu_create()<CR>]],
    { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(self.buf, 'n', 'q',
    [[<cmd>lua require('notebook_manager.commands').kernel_menu_close()<CR>]],
    { noremap = true, silent = true })

  -- Disable Keys
  vim.api.nvim_buf_set_keymap(self.buf, 'n', 'h', '', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(self.buf, 'n', 'l', '', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(self.buf, 'n', '<Left>', '', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(self.buf, 'n', '<Right>', '', { noremap = true, silent = true })

  vim.api.nvim_buf_set_var(self.buf, 'kernels', self.kernels)

  -- Triggers
  vim.api.nvim_create_autocmd('BufLeave', {
    buffer = self.buf,
    callback = function()
      vim.defer_fn(function()
        if vim.api.nvim_get_current_win() ~= self.win or vim.api.nvim_get_current_buf() ~= self.buf then
          if self.win ~= nil then
            vim.api.nvim_set_current_win(self.win)
            vim.api.nvim_echo({ { 'Notebook Manager: Press q to exit menu', 'WarningMsg' } }, false, {})
          end
        end
      end, 10)
    end,
  })

  vim.api.nvim_create_autocmd("CursorMoved", {
    buffer = self.buf,
    callback = function()
      self:update_lines()
    end
  })

  self:update_lines()
end

function KernelMenu:update_lines()
  local lines = {}
  local current_line = vim.api.nvim_win_get_cursor(self.win)[1]
  for i, kernel in ipairs(self.kernels) do
    if i == current_line then
      table.insert(lines, "> " .. kernel)
    else
      table.insert(lines, "  " .. kernel)
    end
  end
  vim.api.nvim_buf_set_lines(self.buf, 0, -1, false, lines)
end

function KernelMenu:create()
  local exit = function(j, return_val)
    if return_val == 0 then
      vim.schedule(function()
        local result = table.concat(j:result(), "\n")
        local new_kernel_name = string.match(result, "Installed kernelspec (%S+) in")
        if new_kernel_name then
          table.insert(self.kernels, new_kernel_name)
          vim.api.nvim_buf_set_lines(self.buf, 0, -1, false, self.kernels)
          vim.api.nvim_buf_set_var(self.buf, 'kernels', self.kernels)
        else
          vim.notify("Failed to create kernel", vim.log.levels.ERROR)
        end
      end)
    end
  end
  vim.ui.input({ prompt = "Create kernel (name): " }, function(input)
    if input then
      self.manager:create_kernel(input, self.package, exit)
    end
  end)
end

function KernelMenu:delete()
  local line = vim.api.nvim_win_get_cursor(0)[1]
  local kernel_name = self.kernels[line]
  local exit = function(j, return_val)
    if return_val == 0 then
      vim.schedule(function()
        for i, k in ipairs(self.kernels) do
          if k == kernel_name then
            table.remove(self.kernels, i)
            break
          end
        end
        vim.api.nvim_buf_set_lines(self.buf, 0, -1, false, self.kernels)
        vim.api.nvim_buf_set_var(self.buf, 'kernels', self.kernels)
      end)
    end
  end
  vim.ui.input({ prompt = "Delete kernel " .. kernel_name .. " [y/n]: " }, function(input)
    if input == 'y' then
      self.manager:delete_kernel(kernel_name, self.package, exit)
    end
  end)
end

function KernelMenu:close()
  vim.api.nvim_win_close(self.win, true)
  vim.api.nvim_command('bd')
  self.win = nil
  self.buf = nil
end

function KernelMenu:toggle()
  if self.win ~= nil and vim.api.nvim_win_is_valid(self.win) then
    self:close()
    return
  end
  self:open()
end

return KernelMenu
