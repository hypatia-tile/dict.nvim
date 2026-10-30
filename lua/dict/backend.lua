---@alias dict.Backend fun(word: string, dbs: table, cb: fun(out: vim.SystemCompleted))

local B = {}

---@param host string
---@return dict.Backend
function B.new(host)
  return function(word, dbs, cb)
    for _, db in ipairs(dbs) do
      vim.system({ "dict", "-d", db, "-h", host, word }, { text = true }, cb)
    end
  end
end

return B
