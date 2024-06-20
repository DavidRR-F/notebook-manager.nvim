# Notebook Manager



### Dependecies
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
