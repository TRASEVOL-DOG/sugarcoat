if CASTLE_PREFETCH then
  CASTLE_PREFETCH({
    "sugarcoat/TeapotPro.ttf",
    "sugarcoat/audio.lua",
    "sugarcoat/core.lua",
    "sugarcoat/debug.lua",
    "sugarcoat/gfx.lua",
    "sugarcoat/gfx_vault.lua",
    "sugarcoat/input.lua",
    "sugarcoat/maths.lua",
    "sugarcoat/map.lua",
    "sugarcoat/sprite.lua",
    "sugarcoat/text.lua",
    "sugarcoat/time.lua",
    "sugarcoat/utility.lua",
    "sugarcoat/window.lua",
    "sugarcoat/sugarcoat.lua"
  })
end

sugar = {}
sugar.S = {}

local events = require("sugarcoat/sugar_events")

local active_canvas
local old_love = love

local function arrange_call(v, before, after)
  return function(...)
    -- wrap before
    if active_canvas then
      old_love.graphics.setCanvas(active_canvas)
    end
    
    if before then before() end
    
    local args = {...}
    local r = {pcall(function() v(unpack(args)) end)}
    
    if after then after() end
    
    active_canvas = old_love.graphics.getCanvas()
    old_love.graphics.setCanvas()
    
    if r[1] then
      return r[2]
    else
      error(r[2], 0)
    end
  end
end

love = setmetatable({}, {
  __index = old_love,
  __newindex = function(t, k, v)
    if type(v) == "function" then
      if k == "draw" then
        old_love[k] = arrange_call(v, nil, sugar.gfx.half_flip)
        
      elseif k == "update" then
        old_love[k] = arrange_call(v, sugar_step, nil)
        
      elseif events[k] then
        old_love[k] = arrange_call(v, events[k], nil)
      
      else
        old_love[k] = arrange_call(v)
      end
    else
      old_love[k] = v
    end
  end
})


require("sugarcoat/utility")
require("sugarcoat/debug")
require("sugarcoat/maths")
require("sugarcoat/gfx")
require("sugarcoat/sprite")
require("sugarcoat/text")
require("sugarcoat/time")
require("sugarcoat/input")
require("sugarcoat/audio")
require("sugarcoat/core")

local function quit()
  sugar.shutdown_sugar()
end

love.quit = quit
events.quit = quit

for k,e in pairs(events) do
  old_love[k] = e
end



