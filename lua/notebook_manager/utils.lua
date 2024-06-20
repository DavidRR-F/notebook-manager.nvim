local Path = require('plenary.path')
local popup = require('plenary.popup')

local M = {}

M.ensure_directory_exists = function(dir)
  local path = Path:new(dir)
  if not path:exists() then
    path:mkdir({ parents = true })
  end
end

M.create_file = function(file, content)
  local path = Path:new(file)
  if not path:exists() then
    path:touch()
    path:write(content, 'w')
    return true
  end
  return false
end

M.menu = function(opts, window)
  local borderchars = {
    "─", "│", "─", "│", "╭", "╮", "╯", "╰"
  }
  local menu = popup.create(opts, {
    title = window.title,
    highlight = "Normal",
    borderhighlight = "FloatBorder",
    line = math.floor((vim.o.lines - window.height) / 2),
    col = math.floor((vim.o.columns - window.width) / 2),
    minwidth = window.width,
    minheight = window.height,
    borderchars = borderchars,
    zindex = 100
  })
  return menu
end

M.confirm_prompt = function(prompt, item, fn)
  vim.ui.input({ prompt = string.format(prompt, item) }, function(input)
    if input == 'yes' or input == 'y' then
      fn(item)
    end
  end)
end
return M
