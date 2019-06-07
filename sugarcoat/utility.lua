sugar = sugar or {}

-- this subpackage is specific to sugarcoat.
-- i.e. it is not normally a part of SUGAR.

-- puts package's content into global environment
-- will not replace already existing global content unless 'do_override' is true.
local _overridden = {}
local function using_package(p, do_override)
  local env = getfenv(2)

  for n,v in pairs(p) do
    if env[n] then
      if do_override then
        sugar.debug.w_log("Overriding key \'"..n.."\' through using_package.")
        _overridden[n] = env[n]
        env[n] = v
      end
    else
      env[n] = v
    end
  end
end

local function overriden_globals()
  return _overridden
end


local function all(ar)
  local i=0
  local k=#ar
  local lr=nil
  
  return function()
    if lr==ar[i] then
      i=i+1
    end
    lr=ar[i]
    
    if i<=k then
      return ar[i]
    end
  end
end

local function del(ar,val) for i,v in ipairs(ar) do if v==val then table.remove(ar,i) return end end end


local function merge_tables(dst, src) -- merges src's content into dst + returns dst
  for k,v in pairs(src) do
    dst[k] = v
  end

  return dst
end

local function copy_table(ar, deep) -- /!\ be cautious with deep copy: avoid double-linked tables!
  local arr = {}
  
  if deep then
    for k,v in pairs(ar) do
      if type(v) == "table" then
        arr[k] = copy_table(v, true)
      else
        arr[k] = v
      end
    end
  else
    for k,v in pairs(ar) do
      arr[k] = v
    end
  end
  
  return arr
end


sugar.utility = {
  using_package = using_package,

  all           = all,
  
  del           = del,
  del_at        = table.remove,
  add           = table.insert,
  sort          = table.sort,
  
  merge_tables  = merge_tables,
  copy_table    = copy_table
}

sugar.S = sugar.S or {}
for k,v in pairs(sugar.utility) do
  sugar.S[k] = v
end

return sugar.utility