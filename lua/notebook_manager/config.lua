local M = {}

M.options = {
    notebook_directory = "./notebooks",
}

M.setup = function(opts)
    M.options = vim.tbl_deep_extend("force", M.options, opts or {})
end

return M

