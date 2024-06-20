# Notebook Manager



### Python Dependecies
- jupyter

```js
return {
  "DavidRR-F/notebook-manager",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  cmd = { 
    "CreateBook", 
    "DeleteBook", 
    "CreateKernel",
    "DeleteKernel",
  },
  opts = {
    notebook_dir = "./notebooks",
    kernel_dir = "default",
  }
}
```

## TODO
- Add env to kernel.json
- Kernel/Notebook Listing
- add ignore package manager option
- add rye/pipenv package manager support
