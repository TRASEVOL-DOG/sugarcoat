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
love = setmetatable({}, {
  __index = old_love,
  __newindex = function(t, k, v)
    if type(v) == "function" then
      if k == "draw" then
        old_love[k] = function(...)
          -- wrap before
          if active_canvas then
            old_love.graphics.setCanvas(active_canvas)
          end
          
          local r = v(...)
          
          -- wrap after
          sugar.gfx.half_flip() -- do the custom flip (minus present())
          
          active_canvas = love.graphics.getCanvas()
          love.graphics.setCanvas()
          
          return r
        end
        
      elseif k == "update" then
        old_love[k] = function(...)
          -- wrap before
          if active_canvas then
            old_love.graphics.setCanvas(active_canvas)
          end
          
          sugar.sugar_step()
          
          local r = v(...)
          
          -- wrap after
          active_canvas = love.graphics.getCanvas()
          love.graphics.setCanvas()
          
          return r
        end
        
      elseif events[k] then
        old_love[k] = function(...)
          -- wrap before
          if active_canvas then
            old_love.graphics.setCanvas(active_canvas)
          end
          
          events[k]()
          
          local r = v(...)
          
          -- wrap after
          active_canvas = love.graphics.getCanvas()
          love.graphics.setCanvas()
          
          return r
        end
      
      else
        old_love[k] = function(...)
          -- wrap before
          if active_canvas then
            old_love.graphics.setCanvas(active_canvas)
          end
          
          local r = v(...)
          
          -- wrap after
          active_canvas = love.graphics.getCanvas()
          love.graphics.setCanvas()
          
          return r
        end
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


for k,e in pairs(events) do
  old_love[k] = e
end



