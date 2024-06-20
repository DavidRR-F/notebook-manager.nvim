local config = require('notebook_manager.config')
local core = require('notebook_manager.core')

local function setup(opts)
  config.setup(opts)
  core.setup()
end

return {
  setup = setup
}
