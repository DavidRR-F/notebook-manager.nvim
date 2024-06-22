# Notebook Manager

Notebook Manager let you create and manage jupyter notebooks and kernels via neovim.

You can create notebooks and kernels using the active python
environment or with one of the supported package managers `poetry`, `rye`,
`pipenv`. If your project directory has a toml configuration file the plugin
will default to using your package manager running commands and populating
notebook metadata.

Use notebook navigator with the following plugins to complete your vim notebook workflow:
- ![Jupytext](https://github.com/GCBallesteros/jupytext.nvim)
- ![NotebookNavigator](https://github.com/GCBallesteros/NotebookNavigator.nvim)
- ![VenvSelector](https://github.com/linux-cultist/venv-selector.nvim)

### Requirements
- Neovim ^9.0
- Python ^3.8
- Required Python Packages
    - `ipykernel` (for initializing kernels)
    - `jupyter` (for managing existing kernels)
 
## Usage

### Notebooks
- `CreateBook`: Create `.ipynb` file in configured directory
- `DeleteBook`: Delete `.ipynb`/`.py` file in configured directory

https://github.com/DavidRR-F/notebook-manager.nvim/assets/99210748/33222faf-1b54-4843-941f-e6ce2fa26ba1

### Kernel Menu
- `j/k`: Navigate Menu
- `a`: Create a new kernel 
- `d`: Delete selected kernel

https://github.com/DavidRR-F/notebook-manager.nvim/assets/99210748/6ba89002-9a9c-41ce-b947-a8726c3a91ad

## Basic Setup

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
    "KernelMenu",
  },
  opts = {
    notebook_dir = "./notebooks",
    ignore_package_manager = false,
  },
  keys = {
    { "<leader>km", "<cmd>:KernelMenu<cr>", desc = "Show Kernels" },
  }
}
```
##### Packer
```lua
use {
  'DavidRR-F/notebook-manager.nvim',
  requires = { 'nvim-lua/plenary.nvim' },
  cmd = {
    "CreateBook",
    "DeleteBook",
    "CreateKernel",
    "DeleteKernel",
    "KernelMenu",
  },
  config = function()
    require('notebook-manager').setup{
      notebook_dir = "./notebooks",
      ignore_package_manager = false,
    }
  end,
  keys = {
    { "<leader>km", "<cmd>:KernelMenu<cr>", desc = "Show Kernels" },
  }
}
```
##### Vim-plug
```vim
call plug#begin('~/.vim/plugged')

Plug 'nvim-lua/plenary.nvim'
Plug 'DavidRR-F/notebook-manager.nvim'

call plug#end()

" Lazy load commands
autocmd! VimEnter * command! -nargs=* CreateBook lua require('notebook-manager.commands').create_notebook(<f-args>)
autocmd! VimEnter * command! -nargs=* DeleteBook lua require('notebook-manager.commands').delete_notebook(<f-args>)
autocmd! VimEnter * command! -nargs=* CreateKernel lua require('notebook-manager.commands').create_kernel(<f-args>)
autocmd! VimEnter * command! -nargs=* DeleteKernel lua require('notebook-manager.commands').delete_kernel(<f-args>)
autocmd! VimEnter * command! KernelMenu lua require('notebook-manager.commands').kernel_menu_show()

" Configuration
lua << EOF
require('notebook-manager').setup{
  notebook_dir = "./notebooks",
  ignore_package_manager = false,
}
EOF

" Keybindings
nmap <leader>km :KernelMenu<CR>

```

## Options

| Option | Description |
|:-------|:------------|
| notebook_dir | directory to manage notebook files |
| ignore_package_manager | use active python evironment rather than projects package manager |
