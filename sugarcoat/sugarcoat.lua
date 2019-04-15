
sugar = {}
sugar.S = {}

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


local events = require("sugarcoat/sugar_events")

for k,e in pairs(events) do
  love[k] = e
end


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
          half_flip() -- do the custom flip (minus present())
          
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
          
          sugar_step()
          
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