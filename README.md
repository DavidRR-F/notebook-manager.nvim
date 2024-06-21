# Notebook Manager

Notebook Manager let you create and manage jupyter notebooks and kernels via neovim.

You can create notebooks and kernels using the active python
environment or with one of the supported package managers `poetry`, `rye`,
`pipenv`. If your project directory has a toml configuration file the plugin
will default to using your package manager running commands and populating
notebook metadata


### Requirements
- Neovim ^9.0
- Python ^3.8
- Required Python Packages
    - `ipykernel` (for initializing kernels)
    - `jupyter` (for managing existing kernels)

### Installation

##### Lazy.vim
```lua
return {
  "DavidRR-F/notebook-manager.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  cmd = {
    "CreateBook",
    "DeleteBook",
    "CreateKernel",
    "DeleteKernel",
    "ShowKernels",
  },
  opts = {
    notebook_dir = "./notebooks",
    ignore_package_manager = false,
  },
  keys = {
    { "<leader>km", "<cmd>:ShowKernels<cr>", desc = "Show Kernels" },
  }
}
```

### Kernel Menu
- `j/k`: Navigate Menu
- `a`: Create a new kernel 
- `d`: Delete selected kernel
