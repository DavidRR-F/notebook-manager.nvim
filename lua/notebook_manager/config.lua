local M = {}

M.options = {
  notebook_dir = "./notebooks",
  kernel_dir = "~/.local/share/jupyter/kernels",
  ignore_package_manager = false,
}

M.keymaps = {}

M.setup = function(opts, keys)
  M.options = vim.tbl_deep_extend("force", M.options, opts or {})
  M.keymaps = vim.tbl_deep_extend("force", M.keymaps, keys or {})
end

return M
