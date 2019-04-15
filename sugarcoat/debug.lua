sugar = sugar or {}

if castle and not sugar.castle_print then
  sugar.castle_print = print
end
local castle_print = sugar.castle_print


local logfile
local function start_log(file_name)
  file_name = file_name or "log.txt"
  
  logfile = love.filesystem.newFile(file_name, "w")
end

local function end_log()
  logfile:close()
end

local function _log(prefix, str)
  str = prefix.." "..str
  
  logfile:write(str.."\r\n")
  
  if castle then
    castle_print(str)
  end
end

local function log(str)
  _log(" . ", str)
end

local function w_log(str)
  _log("/!\\", str)
end

local function r_log(str)
  _log("ERR", str)
end

local function assert(condition, str)
  if not condition then
    abort("Assert Failed: "..str)
  end
end

local function abort(str)
  if str then
    _log("ABORT", str)
  end
  
  shutdown_sugar();
  error(str or "Program was aborted through Sugarcoat.");
end

local function abort_brutal(str)
  error(str or "Program was aborted through Sugarcoat.")
end


local function write_clipboard(str)
  return love.system.setClipboardText(str)
end

local function read_clipboard()
  return love.system.getClipboardText()
end


sugar.debug = {
  start_log       = start_log,
  end_log         = end_log,
  
  log             = log,
  w_log           = w_log,
  r_log           = r_log,
  
  assert          = assert,
  abort           = abort,
  abort_brutal    = abort_brutal,
  
  write_clipboard = write_clipbaord,
  read_clipboard  = read_clipboard
}

sugar.S = sugar.S or {}
for k,v in pairs(sugar.debug) do
  sugar.S[k] = v
end

return sugar.debug