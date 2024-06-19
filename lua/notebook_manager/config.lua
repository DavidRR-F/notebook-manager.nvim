local M = {}

M.options = {
  dir = "./notebooks",
  cells = {
    {
      cell_type = "code",
      execution_count = nil,
      metadata = {},
      outputs = {},
      source = { "" }
    },
  },
  metadata = {
    kernelspec = {
      name = "python3",
      display_name = "Python 3",
      language = "python"
    },
    language_info = {
      name = "python",
      mimetype = "text/x-python",
      codemirror_mode = {
        name = "ipython",
        version = 3
      },
      pygments_lexer = "ipython3",
      nbconvert_exporter = "python",
      file_extension = ".py"
    },
    version = "1.0"
  },
  nbformat = 4,
  nbformat_minor = 2
}

M.setup = function(opts)
  M.options = vim.tbl_deep_extend("force", M.options, opts or {})
end

return M
