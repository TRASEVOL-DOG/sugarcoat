sugar = sugar or {}

require("sugarcoat/debug")
require("sugarcoat/utility")
require("sugarcoat/gfx")
require("sugarcoat/input")
require("sugarcoat/time")
require("sugarcoat/audio")
require("sugarcoat/maths")

local S = sugar

local function init_sugar(window_name, w, h, scale)
  if castle then
    S.debug.start_log(window_name.."_log.txt")
  else
    S.debug.start_log("log.txt")
  end
  
  S.debug.log("Initializing SUGARcoat.")
  
  local love_va, love_vb, love_vc = love.getVersion()
  S.debug.log("Using Love v"..love_va.."."..love_vb.."."..love_vc.." .")
  
  if castle then
    S.debug.log("Running in Castle.")
  end
  
  if SUGAR_SERVER_MODE then
    S.debug.w_log("Running in server mode - no gfx, input or audio.")
    S.time.init_time()
  else
    S.gfx.init_gfx(window_name, w, h, scale)
    S.input.init_input()
    S.time.init_time()
    S.audio.init_audio()
  end

  -- init RNG with local time as seed
  local a, b, c, d, e, f = sugar.time.sys_ltime()
  sugar.maths.srand(a + b*10 + c*100 + d*1000 + e*10000 + f*100000);

  S.debug.log("All systems initialized.");
  S.debug.log("");
end

local function sugar_step()
  S.time.update_time()
  S.input.update_input()
end

if SUGAR_SERVER_MODE then
  sugar_step = function()
    S.time.update_time()
  end
end

local function shutdown_sugar()
  S.debug.log("")
  S.debug.log("Initiating shutdown.")
  
  if not SUGAR_SERVER_MODE then
    S.gfx.shutdown_gfx()
    S.input.shutdown_input()
    S.audio.shutdown_audio()
  end

  S.debug.log("Application ran for "..S.time.t().." seconds.")

  S.debug.log("All systems shut down.")
  S.debug.end_log()
  
  if not castle then
    love.event.push("quit")
  end
end


-- returns percent left, whether the system is on battery ( = not plugged in), battery life remaining (in seconds)
local function sys_battery()
  local state, percent, life = love.system.getPowerInfo()
  
  return percent, (state == "battery"), life
end


sugar.utility.merge_tables(sugar, {
  init_sugar = init_sugar,
  sugar_step = sugar_step,
  shutdown_sugar = shutdown_sugar,
  
  sys_battery = sys_battery
})

sugar.S = sugar.S or {}
for k,v in pairs(sugar) do
  sugar.S[k] = v
end

return sugar