sugar = sugar or {}
sugar.gfx = sugar.gfx or {}

require("sugarcoat/debug")
require("sugarcoat/utility")

local _D = require("sugarcoat/gfx_vault")


local function load_font(ttf_filepath, size, key, use_it)
  local fnt = love.graphics.newFont(ttf_filepath, size, "mono")
  fnt:setFilter("nearest", "nearest", 0)

  if not key then
    key = #_D.font_list + 1
  end
  
  _D.font_list[key] = fnt
  
  sugar.debug.log("Loaded the '"..key.."' TTF font.")
  
  if use_it then
    use_font(key)
  end
end

local function delete_font(key)
  _D.font_list[key] = nil
  
  sugar.debug.log("Deleted the '"..key.."' font.")
end


local function use_font(key)
  if not key then
    key = _D.default_font
  end
  
  local fnt = _D.font_list[key]
  if not fnt then
    sugar.debug.r_log("Attempt to use inexistant font '"..key.."'.")
    return
  end
  
  love.graphics.setFont(fnt)
  _D.current_font = key
end

local function get_font()
  return _D.current_font
end


local function str_px_width(str, font)
  local fnt
  if font then
    fnt = _D.font_list[font]
  else
    fnt = _D.font_list[_D.current_font]
  end
  
  return fnt:getWidth(str)
end

local _flr = math.floor
local function print(str, x, y, c)
  if c then color(c) end
  
  love.graphics.print(str, _flr(x)+0.5, _flr(y)+0.5)
end

local B = require("bit")
local function printp(a, b, c, d)
  _D.print_pattern = {{},{},{}}
  
  if not a then
    return
  end
  
  if b or c or d then
    a = {a, b, c, d}
  end
  
  for i = 0, 3 do
    local mask = a[i+1]
    
    for j = 0,3 do
      local n = bit.band(mask, 0xf)
      if n > 3 then n = 3 end
      
      if n > 0 then
        local lvl = _D.print_pattern[n]
        if not lvl[i] then lvl[i] = {} end
        add(lvl[i], j)
      end
      
      mask = bit.rshift(mask, 4)
    end
  end
  
end

local function printp_color(c1, c2, c3)
  _D.printp_col1 = c1 or _D.printp_col1 or 0
  _D.printp_col2 = c2 or _D.printp_col2 or 0
  _D.printp_col3 = c3 or _D.printp_col3 or 0

  _D.printp_love_col1 = {
    (sugar.maths.flr(_D.printp_col1) % 10) /10,
    (sugar.maths.flr(_D.printp_col1/10) % 10) /10,
    (sugar.maths.flr(_D.printp_col1/100) % 10) /10,
    1.0
  }
  
  _D.printp_love_col2 = {
    (sugar.maths.flr(_D.printp_col2) % 10) /10,
    (sugar.maths.flr(_D.printp_col2/10) % 10) /10,
    (sugar.maths.flr(_D.printp_col2/100) % 10) /10,
    1.0
  }
  
  _D.printp_love_col3 = {
    (sugar.maths.flr(_D.printp_col3) % 10) /10,
    (sugar.maths.flr(_D.printp_col3/10) % 10) /10,
    (sugar.maths.flr(_D.printp_col3/100) % 10) /10,
    1.0
  }
end

local function pprint(str, x, y, c1, c2, c3)
  if c1 then
    printp_color(c1, c2, c3)
  end
  
  x, y = _flr(x)+0.5, _flr(y)+0.5
  
  local ptrn = _D.print_pattern
  
  local lvl = ptrn[3]
  love.graphics.setColor(_D.printp_love_col3)
  for dy,xs in pairs(lvl) do
    for _,dx in pairs(xs) do
      love.graphics.print(str, x+dx, y+dy)
    end
  end
  
  local lvl = ptrn[2]
  love.graphics.setColor(_D.printp_love_col2)
  for dy,xs in pairs(lvl) do
    for _,dx in pairs(xs) do
      love.graphics.print(str, x+dx, y+dy)
    end
  end
  
  local lvl = ptrn[1]
  love.graphics.setColor(_D.printp_love_col1)
  for dy,xs in pairs(lvl) do
    for _,dx in pairs(xs) do
      love.graphics.print(str, x+dx, y+dy)
    end
  end
  
  love.graphics.setColor(_D.love_color)
end


local text = {
  load_font    = load_font,
  delete_font  = delete_font,
  
  use_font     = use_font,
  get_font     = get_font,
  
  str_px_width = str_px_width,
  print        = print,
  
  printp       = printp,
  printp_color = printp_color,
  pprint       = pprint
}

sugar.utility.merge_tables(sugar.gfx, text)

sugar.S = sugar.S or {}
for k,v in pairs(text) do
  sugar.S[k] = v
end

return sugar.gfx