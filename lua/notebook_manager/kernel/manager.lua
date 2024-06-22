local config = require('notebook_manager.config')
local Job = require('plenary.job')

local KernelManager = {}
KernelManager.__index = KernelManager

local function new()
  local instance = setmetatable({}, KernelManager)
  instance.path = config.options.kernel_dir
  instance.std_fn = function(err, data)
    if err then
      vim.notify(err)
    elseif data then
      vim.notify(data)
    end
  end
  return instance
end

function KernelManager:get_instance()
  if not self.instance then
    self.instance = new()
  end
  return self.instance
end

function KernelManager:create_kernel(name, package, on_exit)
  local cmd
  local args

  if package then
    cmd = package.manager.cli
    args = { "run", "python", "-m", "ipykernel", "install", "--user", "--name=" .. name }
  else
    cmd = "python"
    args = { "-m", "ipykernel", "install", "--user", "--name=" .. name }
  end

  Job:new({
    command = cmd,
    args = args,
    on_stdout = self.std_fn,
    on_exit = on_exit
  }):sync()
end

function KernelManager:delete_kernel(name, package, on_exit)
  local cmd
  local args

  if package then
    cmd = package.manager.cli
    args = { "run", "jupyter", "kernelspec", "remove", name, "-y" }
  else
    cmd = "jupyter"
    args = { "kernelspec", "remove", name, "-y" }
  end

  Job:new({
    command = cmd,
    args = args,
    on_stdout = self.std_fn,
    on_exit = on_exit
  }):sync()
end

function KernelManager:get_kernels(package)
  local results = {}
  local command
  local args

  if package then
    command = package.manager.cli
    args = { "run", "jupyter", "kernelspec", "list" }
  else
    command = "jupyter"
    args = { "kernelspec", "list" }
  end

  Job:new({
    command = command,
    args = args,
    on_exit = function(j, return_val)
      if return_val == 0 then
        for _, line in ipairs(j:result()) do
          if line:match('%*') then -- Skip the header
            goto continue
          end
          local name = line:match('(%S+)')
          if name then
            table.insert(results, name)
          end
          ::continue::
        end
      end
    end,
  }):sync()
  table.remove(results, 1)
  return results
end

return KernelManager
