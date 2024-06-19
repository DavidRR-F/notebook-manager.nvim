local config = require('notebook_manager.config')

local KernelManager = {}
KernelManager.__index = KernelManager

function KernelManager:new()
  local instance = setmetatable({}, KernelManager)
  instance.path = config.options.kernel_dir
  instance.cli = config.options.kernel_tool
  return instance
end

function KernelManager:create_kernel(name, manager)
  local cmd
  local tool

  -- Set the command based on the kernel manager
  if self.cli == "ipykernel" then
    if self.path == "default" then
      tool = "ipykernel install --user --name="
    else
      tool = "ipykernel install --user --prefix=" .. self.path .. " --name="
    end
  elseif self.cli == "jupyter" then
    if self.path == "default" then
      tool = "jupyter kernelspec install --user --name="
    else
      tool = "jupyter kernelspec install " .. self.path .. " --user --name="
    end
  else
    error("Invalid kernel manager: " .. self.cli)
  end

  -- Add manager if it exists
  if manager then
    cmd = manager .. "run python -m " .. tool .. name
  else
    cmd = "python -m " .. tool .. name
  end

  -- Run the command
  local output = vim.fn.systemlist(cmd)
  local exit_code = vim.v.shell_error

  -- Check if the command was successful
  if exit_code ~= 0 then
    -- Command failed, print an error message
    print("Error running command: " .. cmd)
    for _, line in ipairs(output) do
      print(line)
    end
  else
    -- Command succeeded, print the output
    for _, line in ipairs(output) do
      print(line)
    end
  end
end
