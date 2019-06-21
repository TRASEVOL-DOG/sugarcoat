sugar = sugar or {}

local _initial_time
local _last_time
local _delta_time
local _wait_frame
local _frame_time

local _frame_time_buffer = {}
local _frame_time_idx = 0
local _real_frame_time_buffer = {}
local _real_frame_time_idx = 0

local function init_time()
  _initial_time = love.timer.getTime()--os.clock()
  _last_time = 0
  _delta_time = 0
  
  for i = 0,15 do
    _frame_time_buffer[i] = 0
    _real_frame_time_buffer[i] = 0
  end
  
  sugar.time.set_frame_waiting()
  
  sugar.debug.log("Time system initialized.")
end

local function update_time()
  if not _initial_time then return end

  local new_time = sugar.time.t()
  _delta_time = new_time - _last_time
  
  _real_frame_time_idx = (_real_frame_time_idx + 1) % 16
  _real_frame_time_buffer[_real_frame_time_idx] = _delta_time
  
  if _wait_frame and _delta_time < _frame_time then
    sugar.time.sleep(_frame_time - _delta_time)
    local newer_time = sugar.time.t()
    
    _delta_time = newer_time - _last_time
    _last_time = newer_time
  else
    _last_time = new_time
  end
  
  _frame_time_idx = (_frame_time_idx + 1) % 16
  _frame_time_buffer[_frame_time_idx] = _delta_time
end


local function set_frame_waiting(fps)
  if fps and fps > 0 then
    _wait_frame = true
    _frame_time = 1/fps
  else
    _wait_frame = false
    _frame_time = 0
  end
end


local function t()
  return love.timer.getTime() - (_initial_time or 0)
end
local time = t

local function dt()
  return _delta_time
end
local delta_time = dt


local function sleep(sec)
  love.timer.sleep(sec)
end

local function freeze(sec)
  love.timer.sleep(sec)
  _last_time = _last_time + sec
end


local function fps()
  local total = 0
  for i = 0, 15 do
    total = total + _frame_time_buffer[i]
  end
  return 16 / total
end

local function fps_raw()
  return 1 / _frame_time_buffer[_frame_time_idx]
end

local function frame_time()
  local total = 0
  for i = 0, 15 do
    total = total + _real_frame_time_buffer[i]
  end
  return 16 / total
end

local function frame_time_raw()
  return _real_frame_time_buffer[_real_frame_time_idx]
end


local function sys_ltime()
  local info = os.date("*t")
  
  return info.sec, info.min, info.hour, info.day, info.month, info.year, info.wday
end

local function sys_gtime()
  local info = os.date("!*t")
  
  return info.sec, info.min, info.hour, info.day, info.month, info.year, info.wday
end


sugar.time = {
  init_time         = init_time,
  update_time       = update_time,
  
  set_frame_waiting = set_frame_waiting,
  
  t                 = t,
  time              = time,
  dt                = dt,
  delta_time        = delta_time,
  
  sleep             = sleep,
  freeze            = freeze,
  
  fps               = fps,
  fps_raw           = fps_raw,
  frame_time        = frame_time,
  frame_time_raw    = frame_time_raw,
  
  sys_ltime         = sys_ltime,
  sys_gtime         = sys_gtime
}

sugar.S = sugar.S or {}
for k,v in pairs(sugar.time) do
  sugar.S[k] = v
end

return sugar.time