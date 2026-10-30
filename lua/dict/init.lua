---@class dict.Opts
---@field databases? string[]
---@field host? string

---@class dict.Main
---@field databases string[]
---@field backend dict.Backend
local dict = {}

---@param opts? dict.Opts
function dict.setup(opts)
  local databases, host = require("dict.default").set_opts(opts or {})
  dict.databases = databases
  dict.backend = require("dict.backend").new(host)
end

return dict
