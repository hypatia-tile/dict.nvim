local D = {}

--- set default database if not defined
--- default databases: wn (WordNet) and wiktionary
---@param dbs string[]
---@return string[]
local function set_dbs_def(dbs)
  local has = false
  for _, _ in ipairs(dbs) do
    has = true
    break
  end
  return has and dbs or { "wn", "wiktionary" }
end

--- set default host if not defined
--- default host: "127.0.0.1"
---@param host string?
---@return string host
local function set_host_def(host)
  return host or "127.0.0.1"
end

---@param opts dict.Opts
---@return string[] databases
---@return string host
function D.set_opts(opts)
  local databases = set_dbs_def(opts.databases or {})
  local host = set_host_def(opts.host)
  return databases, host
end

return D
