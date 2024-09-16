local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local config = require("telescope.config").values
local Job = require("plenary.job")
local log = require("plenary.log"):new()
log.level = 'info'
local M = {}

local function get_kernels()
  local results = {}
  Job:new({
    command = "jupyter",
    args = { "kernelspec", "list", "--json" },
    on_exit = function(j, return_val)
      if return_val == 0 then
        local output = table.concat(j:result(), "")
        local success, decoded_output = pcall(vim.json.decode, output)
        if not success then
          log.error("Failed to decode JSON: ", output)
          return
        end
        for name, kernel_info in pairs(decoded_output.kernelspecs) do
          table.insert(results, {
            name = name,
            display_name = kernel_info.spec.display_name,
            resource_dir = kernel_info.resource_dir,
          })
        end
      else
        log.error("Error running jupyter command")
      end
    end,
  }):sync()
  return results
end

M.show_kernels = function(opts)
  opts = opts or {}

  pickers.new(opts, {
    prompt_title = "Jupyter Kernels",
    finder = finders.new_table({
      results = get_kernels(),
      entry_maker = function(entry)
        return {
          value = entry.name,
          display = string.format("%s (%s)", entry.display_name, entry.resource_dir),
          ordinal = entry.name,
        }
      end,
    }),
    sorter = config.generic_sorter(opts),
  }):find()
end

return require('telescope').register_extension({
  exports = {
    show_kernels = M.show_kernels
  }
})
