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
  vim.api.nvim_create_user_command("Dict", function(args)
    local word = args.fargs[1]
    if word then
      dict.backend(word, dict.databases, function(sysopts)
        print(sysopts.stdout)
        print(sysopts.stderr)
      end)
    end
  end, { nargs = 1, desc = "Call the dictionary backend to look up a word passed via command line args." })
end

return dict
