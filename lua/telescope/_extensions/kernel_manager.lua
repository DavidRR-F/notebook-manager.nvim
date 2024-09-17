local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local previewers = require("telescope.previewers")
local utils = require("telescope.previewers.utils")
local config = require("telescope.config").values
local themes = require('telescope.themes')
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

M.config = {}

M.setup = function(ext_config)
  M.config = ext_config or {}
end

M.show_kernels = function(opts)
  opts = opts or {}

  opts = vim.tbl_deep_extend("force", M.config, opts)

  -- Apply the theme if specified
  if opts.theme then
    opts = themes["get_" .. opts.theme](opts)
  end

  pickers.new(opts, {
    prompt_title = "Jupyter Kernels",
    finder = finders.new_table({
      results = get_kernels(),
      entry_maker = function(entry)
        return {
          value = entry.resource_dir,
          display = string.format("%s (%s)", entry.display_name, entry.resource_dir),
          ordinal = entry.name,
        }
      end,
    }),
    sorter = config.generic_sorter(opts),
    previewer = previewers.new_buffer_previewer({
      title = "Kernel Details",
      define_preview = function(self, entry)
        local kernel_json_path = entry.value .. "/kernel.json"
        local file = io.open(kernel_json_path, "r")
        if file then
          -- Read the entire file content
          local content = file:read("*a")
          file:close()

          -- Display the content in the preview buffer
          vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, vim.split(content, "\n"))
        else
          -- If the file doesn't exist or couldn't be opened, show an error message
          vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, { "Error: Could not open kernel.json" })
        end      
        utils.highlighter(self.state.bufnr, "json")
      end
    })
  }):find()
end

return require('telescope').register_extension({
  exports = {
    show_kernels = M.show_kernels
  },
  setup = M.setup,
})
