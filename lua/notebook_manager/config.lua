local M = {}

M.options = {
  notebook_dir = "./notebooks",
  kernel_dir = "default",
  kernel_tool = "ipykernel",
}

M.setup = function(opts)
  M.options = vim.tbl_deep_extend("force", M.options, opts or {})
end

return M
