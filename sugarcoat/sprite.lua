sugar = sugar or {}
sugar.gfx = sugar.gfx or {}

require("sugarcoat/debug")
require("sugarcoat/utility")

local _D = require("sugarcoat/gfx_vault")


local function spritesheet(surf_key)
  local canv = _D.surf_list[surf_key]
  if not canv then
    sugar.debug.r_log("Attempt to use inexistant surface '"..surf_key.."' as spritesheet.")
    return
  end
  
  _D.spritesheet = surf_key
  _D.love_spritesheet = canv
  
  local sw, sh = canv:getDimensions()
  _D.spsh_nx = sw / _D.spsh_gw;
  _D.spsh_ny = sh / _D.spsh_gh;
end

local function get_spritesheet()
  return _D.spritesheet
end


local function load_png(key, file_name, palette, use_as_spritesheet)
  -- load image from file path 
  -- (unless an "image" type was passed in)
  local image;
  if type(file_name) == "string" then
    image = love.graphics.newImage(file_name)    
  else
    image = file_name
  end
  
  local w, h = image:getDimensions()
  key = sugar.gfx.new_surface(w, h, key)
  
  local ptarget = sugar.gfx.get_target()
  
  local canvas = _D.surf_list[key]
  
  love.graphics.setCanvas(canvas)
  
  sugar.gfx.target(key)
  
  local opalette
  if palette then
    opalette = sugar.gfx.get_palette()
    use_palette(palette)
  end
  
  _D.use_color_index_shader()
  
  love.graphics.draw(image, 0, 0)
  
  _D.reset_shader()
  
  if opalette then
    use_palette(opalette)
  end
  
  sugar.gfx.target(ptarget)
  
  sugar.gfx.scan_surface(key)
  
  if use_as_spritesheet then
    spritesheet(key)
  end
end


local function spritesheet_grid(w, h)
  _D.spsh_gw = w or 8
  _D.spsh_gh = h or 8
  
  if _D.spritesheet then
    local sw, sh = surface_size(_D.spritesheet)
    _D.spsh_nx = sw / _D.spsh_gw
    _D.spsh_ny = sh / _D.spsh_gh
  else
    _D.spsh_nx = 0
    _D.spsh_ny = 0
  end
end

local function get_spritesheet_grid()
  return _D.spsh_gw, _D.spsh_gh
end


local function palt(c, make_transparent)
  if not c then
    for i = 1, #_D.palette do
      _D.transparency[i] = 0
    end
    
    _D.transparency[0] = 1
  end

  _D.transparency[c] = make_transparent and 1 or 0
end

local function spr(s, x, y, w, h, flip_x, flip_y)
  s, x, y = s or 0, x or 0, y or 0
  
  if w then w = sugar.maths.flr(w) * _D.spsh_gw
  else w = _D.spsh_gw end
  
  if h then h = sugar.maths.flr(h) * _D.spsh_gh
  else h = _D.spsh_gh end
  
  s,x,y = sugar.maths.flr(s), sugar.maths.flr(x), sugar.maths.flr(y)
  
  local sx = (s % _D.spsh_nx) * _D.spsh_gw
  local sy = flr(s / _D.spsh_nx) * _D.spsh_gh
  
  local quad = love.graphics.newQuad(sx, sy, w, h, _D.love_spritesheet:getDimensions())
  
  _D.use_index_index_shader()
  love.graphics.draw(_D.love_spritesheet, quad, x, y, 0, flipx and -1 or 1, flipy and -1 or 1, 0, 0)
  _D.reset_shader()
end

local function aspr(s, x, y, a, w, h, anchor_x, anchor_y, scale_x, scale_y)
  s, x, y = s or 0, x or 0, y or 0
  
  if w then w = sugar.maths.flr(w) * _D.spsh_gw
  else w = _D.spsh_gw end
  
  if h then h = sugar.maths.flr(h) * _D.spsh_gh
  else h = _D.spsh_gh end
  
  anchor_x, anchor_y = anchor_x or 0.5, anchor_y or 0.5
  scale_x, scale_y = scale_x or 1, scale_y or 1
  
  s = sugar.maths.flr(s)
  
  local sx = (s % _D.spsh_nx) * _D.spsh_gw
  local sy = flr(s / _D.spsh_nx) * _D.spsh_gh
  
  local quad = love.graphics.newQuad(sx, sy, w, h, _D.love_spritesheet:getDimensions())
  
  _D.use_index_index_shader()
  love.graphics.draw(_D.love_spritesheet, quad, x, y, a * 2*math.pi, scale_x, scale_y, anchor_x * w, anchor_y * h)
  _D.reset_shader()
end

local function sspr(sx, sy, sw, sh, dx, dy, dw, dh)
  dw, dh = dw or sw, dh or sh
  
  sx, sy, sw, sh, dx, dy, dw, dh = sugar.maths.flr(sx), sugar.maths.flr(sy), sugar.maths.flr(sw), sugar.maths.flr(sh), sugar.maths.flr(dx), sugar.maths.flr(dy), sugar.maths.flr(dw), sugar.maths.flr(dh)
  
  local quad = love.graphics.newQuad(sx, sy, sw, sh, _D.love_spritesheet:getDimensions())
  
  _D.use_index_index_shader()
  love.graphics.draw(_D.love_spritesheet, quad, dx, dy, 0, dw/sw, dh/sh, 0, 0)
  _D.reset_shader()
end

local function spr_sheet(key, x, y, dw, dh)
  local canvas
  if key then
    canvas = _D.surf_list[key]
  else
    canvas = _D.love_spritesheet
  end

  _D.use_index_index_shader()
  
  if dw or dh then
    local sw, sh = canvas:getDimensions()
    love.graphics.draw(canvas, x, y, 0, (dw or sw)/sw, (dh or sh)/sh)
  else
    love.graphics.draw(canvas, x, y)
  end
  
  _D.reset_shader()
end

local function sget(x, y, surf_key) -- use `scan_surface() first!`
  local data = _D.surf_data[surf_key or _D.spritesheet]
  
  if not data then return 0 end
  
  local w, h = data:getDimensions()
  if x < 0 or y < 0 or x >= w or y >= h then
    return 0
  end
  
  local r, g, b = data:getPixel(x, y)
  
  local n = round(r * 10) + round(g * 10) * 10 + round(b * 10) * 100
  
  return n
end



local sprite = {
  spritesheet          = spritesheet,
  get_spritesheet      = get_spritesheet,
  
  load_png             = load_png,
  
  spritesheet_grid     = spritesheet_grid,
  get_spritesheet_grid = get_spritesheet_grid,
  
  palt                 = palt,
  
  spr                  = spr,
  aspr                 = aspr,
  sspr                 = sspr,
  spr_sheet            = spr_sheet,
  sget                 = sget
}

sugar.utility.merge_tables(sugar.gfx, sprite)

sugar.S = sugar.S or {}
for k,v in pairs(sprite) do
  sugar.S[k] = v
end

return sugar.gfx