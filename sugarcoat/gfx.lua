sugar = sugar or {}
sugar.gfx = sugar.gfx or {}

require("sugarcoat/debug")
require("sugarcoat/utility")
require("sugarcoat/maths")
require("sugarcoat/window")
require("sugarcoat/text")

local _D = require("sugarcoat/gfx_vault")
local events = require("sugarcoat/sugar_events")
local _flr = math.floor


local _index_colors = {}
local _custom_shader = false
local _shader_vars = {}
local _shader_arrays = {}

local function _load_shaders()
  _D.shader_code = {
    color_to_index = [[
      varying vec2 v_vTexcoord;
      varying vec4 v_vColour;
      
      extern int pal_size;
      extern vec3 opal[256];
      
      float sqr(float a) {
        return a*a;
      }
      
      vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
      {
        vec4 col = Texel( texture, texture_coords );
        
        float sqrdist = 3.0;
        float c = 0.0;
        for (int i = 0; i < pal_size; i++){
          float sqrd = sqr(col.r - opal[i].r) + sqr(col.g - opal[i].g) + sqr(col.b - opal[i].b);
          float b = max(sign(sqrdist - sqrd), 0.0);
          
          c = b * float(i) + (1.0 - b) * c;
          sqrdist = b * sqrd + (1.0 - b) * sqrdist;
        }
      
        float cb = float(c);
        
        vec3 icol = vec3(
          mod(cb, 10.0),
          mod(floor(cb / 10.0), 10.0),
          mod(floor(cb / 100.0), 10.0)
        );
        
        return vec4(icol * 0.1, 1.0);
      }
    ]],
    
    index_to_index = [[
      varying vec2 v_vTexcoord;
      varying vec4 v_vColour;
      
      extern float swaps[256];
      extern float trsps[256];
      
      vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
      {
        vec4 col = Texel( texture, texture_coords );
        
        int c = int(floor(col.r * 10.0 + 0.5) + floor(col.g * 10.0 + 0.5)*10.0 + floor(col.b * 10.0 + 0.5) * 100.0);
        
        float trsp = 1.0-trsps[c];
        
        float cb = swaps[c];
        
        vec3 icol = vec3(
          mod(cb, 10.0),
          mod(floor(cb / 10.0), 10.0),
          mod(floor(cb / 100.0), 10.0)
        );
        
        return vec4(icol * 0.1, trsp);
      }
    ]],
    
    index_to_color = [[
      extern vec3 PALETTE[256]; extern int SWAPS[256]; int Texel_index(Image texture, vec2 coords); vec4 Texel_color(Image texture, vec2 coords);
      varying vec2 v_vTexcoord;
      varying vec4 v_vColour;
      
      vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
      {
        vec4 col = Texel( texture, texture_coords );
        return vec4(PALETTE[ SWAPS[int(floor(col.r * 10.0 + 0.5) + floor(col.g * 10.0 + 0.5)*10.0 + floor(col.b * 10.0 + 0.5) * 100.0)] ], 1.0);
      }
    ]]
  }
  
  _D.shaders = {}
  for name, code in pairs(_D.shader_code) do
    local status, message = love.graphics.validateShader(true, code)
    if status then
      _D.shaders[name] = love.graphics.newShader(code)
    else
      sugar.debug.r_log("Could not validate '"..name.."' shader: "..message)
    end
  end
  
  _custom_shader = false
end

local function _update_shader_palette()
  local pal = {_D.palette_norm[0], unpack(_D.palette_norm)}
  
  _D.shaders.color_to_index:send("opal", unpack(pal))
  _D.shaders.color_to_index:send("pal_size", #pal)
  
  if (not _custom_shader) or _shader_vars["PALETTE"] then
    _D.shaders.index_to_color:send("PALETTE", unpack(pal))
  end
end

function _D.use_color_index_shader()
  local shader = _D.shaders.color_to_index
  
  love.graphics.setShader(shader)
end

function _D.use_index_index_shader()
  local shader = _D.shaders.index_to_index
  
  shader:send("swaps", _D.pltswp_dw[0], unpack(_D.pltswp_dw))
  shader:send("trsps", _D.transparency[0], unpack(_D.transparency))
  
  love.graphics.setShader(shader)
end

function _D.use_index_color_shader()
  local shader = _D.shaders.index_to_color
  
  if (not _custom_shader) or _shader_vars["SWAPS"] then
    shader:send("SWAPS", _D.pltswp_fp[0], unpack(_D.pltswp_fp))
  end
  
  love.graphics.setShader(shader)
end

function _D.reset_shader()
  love.graphics.setShader()
end



local _love_present
local _love_pump

local function init_gfx(window_name, w, h, scale)
  if _D.init then
    return
  end
  
  -- Love2D rendering settings
  love.mouse.setVisible(false)
  love.graphics.setDefaultFilter("nearest","nearest",0)
  love.graphics.setPointSize(1)
  love.graphics.setLineWidth(1)
  love.graphics.setLineStyle("rough")
  love.graphics.setLineJoin("miter")
  
  _load_shaders()
  
  _D.surf_list = {}
  _D.font_list = {}
  
  
  -- window size setting
  local win_w, win_h
  if castle then
    win_w, win_h = love.graphics.getDimensions()
  else
    win_w = w * scale
    win_h = h * scale
    love.window.setMode(win_w, win_h, {resizable = true})
  end
  
  love.window.setTitle(window_name or "~ Untitled ~")
  
  -- debug: using w x h window 'window_name'.
  sugar.debug.log("Using "..win_w.."x"..win_h.." window '"..window_name.."'.")
  
  -- register window scale
  _D.window_scale = scale;
  
  -- create screen
  _D.screen = sugar.gfx.new_surface(w, h, _D.screen)
  
  -- screen last size (for resizing)
  _D.screen_last_w = w;
  _D.screen_last_h = h;
  
  -- set default palette
  sugar.gfx.use_palette(sugar.gfx.palettes.kirokaze_gb)
  
  -- misc initializations
  
  -- target() clip() clear() pal() color(0)
  sugar.gfx.target()
  sugar.gfx.clip()
  sugar.gfx.camera()
  sugar.gfx.clear(0)
  sugar.gfx.pal()
  sugar.gfx.color(0)
  
  -- spritesheet_grid()
  
  
  -- default font
  sugar.gfx.load_font("sugarcoat/TeapotPro.ttf", 16, _D.default_font)
  sugar.gfx.use_font()
  sugar.gfx.printp()
  sugar.gfx.printp_color()
    
  _D.init = true;

  sugar.gfx.screen_render_stretch(false)
  sugar.gfx.screen_render_integer_scale(true)
  
  sugar.debug.log("GFX system initialized.");
end

local function shutdown_gfx()
  love.graphics.present = _love_present
  
  if _love_pump then
    love.event.pump = _love_pump
  end
  
  love.graphics.setCanvas()
  
  _D.surf_list = nil
  _D.font_list = nil
  
  _D.init = false
  
  sugar.debug.log("GFX system shut down.")
end


local _render_target
local function render_to_canvas(canvas)
  _render_target = canvas
  sugar.gfx.update_screen_size()
end


local _bg_color = {0,0,0}
local function _clear_window()
  local ocanv = love.graphics.getCanvas()
  
  love.graphics.setCanvas()
  love.graphics.clear(unpack(_bg_color))
  
  love.graphics.setCanvas(ocanv)
end

local function screen_render_stretch(enable)
  if enable then
    sugar.gfx.screen_render_integer_scale(false);
  end
  
  _D.render_stretch = enable
  
  sugar.gfx.update_screen_size()
end

local function screen_render_integer_scale(enable)
  if enable then
    sugar.gfx.screen_render_stretch(false)
  end
  
  _D.render_integer_scale = enable
  
  sugar.gfx.update_screen_size()
end

local function screen_resizeable(enable, scale, on_resize_callback)
  _D.screen_resizeable = enable
  
  if scale and scale > 0 then
    _D.window_scale = scale
  end
  
  if on_resize_callback then
    sugar.on_resize = on_resize_callback
  end
  
  sugar.gfx.update_screen_size()
end

local function screen_resize(w, h, resize_window)
  sugar.gfx.delete_surface(_D.screen)
  sugar.gfx.new_surface(w, h, _D.screen)
  sugar.gfx.target()
  
  if resize_window then
    sugar.gfx.window_size(w * _D.window_scale, h * _D.window_scale)
  end
  
  if not _D.screen_resizeable then
    sugar.gfx.update_screen_size()
  end
end

local _prev_win_w = 0
local _prev_win_h = 0
local function update_screen_size()
  if not _D.init then return end

  local win_w, win_h-- = sugar.gfx.window_size()
  if _render_target then
    win_w, win_h = _render_target:getDimensions()
  else
    win_w, win_h = sugar.gfx.window_size()
  end
  
  local scr_w, scr_h = sugar.gfx.screen_size()

  if _D.screen_resizeable then
    local scale = _D.window_scale
  
    local nw = sugar.maths.flr(win_w / scale)
    local nh = sugar.maths.flr(win_h / scale)
  
    if nw ~= scr_w or nh ~= scr_h then
      sugar.gfx.screen_resize(nw, nh, false)
    end
    
    _D.screen_sca_x = scale
    _D.screen_sca_y = scale
    
    _D.screen_x = (win_w - nw * scale) * 0.5
    _D.screen_y = (win_h - nh * scale) * 0.5
    
  elseif _D.render_stretch then
    _D.screen_x = 0
    _D.screen_y = 0

    _D.screen_sca_x = win_w / scr_w
    _D.screen_sca_y = win_h / scr_h
    
  elseif _D.render_integer_scale then
    local scale = sugar.maths.flr(sugar.maths.min(win_w / scr_w, win_h / scr_h))
    
    _D.screen_sca_x = scale
    _D.screen_sca_y = scale
    
    _D.screen_x = sugar.maths.flr((win_w - _D.screen_sca_x * scr_w) * 0.5)
    _D.screen_y = sugar.maths.flr((win_h - _D.screen_sca_y * scr_h) * 0.5)
    
  else
    local scale = sugar.maths.min(win_w / scr_w, win_h / scr_h)
    
    _D.screen_sca_x = scale
    _D.screen_sca_y = scale
    
    _D.screen_x = (win_w - _D.screen_sca_x * scr_w) * 0.5
    _D.screen_y = (win_h - _D.screen_sca_y * scr_h) * 0.5
  end
  
  _clear_window()
  
  if win_w == _prev_win_w and win_h == _prev_win_h then
    return
  else
    _prev_win_w = win_w
    _prev_win_h = win_h
  end
  
  if _D.shaders.index_to_color:hasUniform("SCREEN_SIZE") then
    local w,h = screen_size()
    _D.shaders.index_to_color:send("SCREEN_SIZE", {w, h})
  end

  if sugar.on_resize then
    sugar.on_resize()
  end
end
events.resize = update_screen_size
love.resize = update_screen_size

local function screen_get_render_stretch()
  return _D.render_stretch
end

local function screen_get_render_integer_scale()
  return _D.render_integral_scale
end

local function screen_get_resizeable()
  return _D.screen_resizeable
end

local function screen_size()
  return _D.surf_list[_D.screen]:getDimensions()
end

local function screen_w()
  return select(1, _D.surf_list[_D.screen]:getDimensions())
end

local function screen_h()
  return select(2, _D.surf_list[_D.screen]:getDimensions())
end

local function screen_scale()
  return _D.screen_sca_x, _D.screen_sca_y
end

local function set_background_color(c)
  if not c then
    _bg_color = {0, 0, 0}
  else
    _bg_color = _D.palette_norm[c]
  end

  _clear_window()
end


local function half_flip()
  local active_canvas = love.graphics.getCanvas()
  
  _clear_window()
  
  if active_canvas then
    love.graphics.setColor(1,1,1,1)
    love.graphics.setCanvas(_render_target)
    love.graphics.origin()

    _D.use_index_color_shader()
    
    local screen_canvas = _D.surf_list[_D.screen]
    love.graphics.draw(screen_canvas, _D.screen_x, _D.screen_y, 0, _D.screen_sca_x, _D.screen_sca_y)

    _D.reset_shader()
	
	if sugar.after_render then
    love.graphics.setCanvas()
	  sugar.after_render()
	end

    love.graphics.setColor(_D.love_color)
  end
  
  love.graphics.setCanvas(active_canvas)
end

local function flip()
  local active_canvas = love.graphics.getCanvas()
  
  _clear_window()
  
  if active_canvas then
    love.graphics.setColor(1,1,1,1)
    love.graphics.setCanvas(_render_target)
    love.graphics.origin()
    
    _D.use_index_color_shader()
    local screen_canvas = _D.surf_list[_D.screen]
    love.graphics.draw(screen_canvas, _D.screen_x, _D.screen_y, 0, _D.screen_sca_x, _D.screen_sca_y)

    _D.reset_shader()
    
    if sugar.after_render then
      love.graphics.setCanvas()
	  sugar.after_render()
	end
    
    love.graphics.setColor(_D.love_color)
  end
  
  love.graphics.present()
  
  love.graphics.setCanvas(active_canvas)
end


---- SHADERS ----

local function _default_screen_shader()
  _D.shaders.index_to_color = love.graphics.newShader(_D.shader_code.index_to_color)
  _update_shader_palette()
  
  _custom_shader = false
  _shader_vars, _shader_arrays = {}, {}
end

local function screen_shader(shader_code)
  if not shader_code then
    _default_screen_shader();
    return
  end
  
  -- ADD extern vec2 SCREEN_SIZE
  -- + update on resize
  
  local pre = "extern vec2 SCREEN_SIZE; extern vec3 PALETTE[256]; extern int SWAPS[256]; int Texel_index(Image texture, vec2 coords); vec4 Texel_color(Image texture, vec2 coords); "
  local after = [[
    int Texel_index(Image texture, vec2 coords){
	    vec4 col = Texel( texture, coords );
	    int c = int(floor(col.r * 10.0 + 0.5) + floor(col.g * 10.0 + 0.5)*10.0 + floor(col.b * 10.0 + 0.5) * 100.0);
	  
	    return SWAPS[c];
	  }
	  
	  vec4 Texel_color(Image texture, vec2 coords){
	    return vec4(PALETTE[ Texel_index(texture, coords) ], 1.0);
	  }
  ]]
  
  shader_code = pre..shader_code..after
  
  local status, message = love.graphics.validateShader(true, shader_code)
  if status then
    _D.shaders.index_to_color = love.graphics.newShader(shader_code)
    
    _shader_vars, _shader_arrays = {}, {}
    for var_dec in shader_code:gmatch('extern.-;') do
      local var = var_dec:match('extern.-%a+.-([%a_]+).-;')
      local is_array = var_dec:find('%[') ~= nil
      
      _shader_vars[var] = true
      if is_array then
        _shader_arrays[var] = true
      end
    end
    
    _update_shader_palette()
    if _shader_vars["SCREEN_SIZE"] then
      local w,h = screen_size()
      _D.shaders.index_to_color:send("SCREEN_SIZE", {w, h})
    end
    
    _custom_shader = true
  else
    sugar.debug.r_log("Could not validate custom screen shader: "..message)
  end
end

local function screen_shader_input(value_table)
  for key, value in pairs(value_table) do
    if _shader_vars[key] then
      if _shader_arrays[key] then
        _D.shaders.index_to_color:send(key, unpack(value))
      else
        _D.shaders.index_to_color:send(key, value)
      end
    end
  end
end


---- DRAWING ----

local function camera(x, y)
  x = x or 0
  y = y or 0
  
  love.graphics.origin()
  love.graphics.translate(-_flr(x), -_flr(y))
  
  _D.cam_x = x
  _D.cam_y = y
end

local function camera_move(dx, dy)
  _D.cam_x = _D.cam_x + dx
  _D.cam_y = _D.cam_y + dy
  
  love.graphics.origin()
  love.graphics.translate(-_flr(_D.cam_x), -_flr(_D.cam_y))
end

local function get_camera()
  return _D.cam_x, _D.cam_y
end

local function clip(x, y, w, h)
  if x and y then
    love.graphics.setScissor(flr(x-_D.cam_x), flr(y-_D.cam_y), w, h)
  else
    love.graphics.setScissor()
  end
  
  _D.clip_x = x or 0
  _D.clip_y = y or 0
  _D.clip_w = w or sugar.gfx.target_w()
  _D.clip_h = h or sugar.gfx.target_h()
end

local function get_clip()
  return _D.clip_x, _D.clip_y, _D.clip_w, _D.clip_h
end

--local function color(ia, ib)
--  if not ib then
--    ib = ((ia % 0x10000) - (ia % 0x100)) / 0x100
--    ia = (ia % 0x100) - (ia % 0x1)
--  else
--    ia = (ia % 0x100) - (ia % 0x1)
--    ib = (ib % 0x100) - (ib % 0x1)    
--  end
--end

local function color(i)
  if i == _D.color then return end

  --i = i % _D.palette_size
  i = _D.pltswp_dw[flr(i) % _D.palette_size]
  
  _D.love_color = _index_colors[i]
  
  love.graphics.setColor(_D.love_color)
  
  _D.color = i
end

local function pal(ca, cb, flip_level)
  if not ca then
    for i=0,#_D.palette do
      _D.pltswp_dw[i] = i
      _D.pltswp_fp[i] = i
    end
    
    return
  end

  local swaps
  if flip_level then
    swaps = _D.pltswp_fp
  else
    swaps = _D.pltswp_dw
  end

  swaps[ca] = cb % _D.palette_size
end


local function clear(c)
  love.graphics.clear(_index_colors[c or 0])
end

local cls = clear

local function rectfill(xa, ya, xb, yb, c)
  if c then color(c) end
  
  xa,xb,ya,yb = _flr(xa)+0.5, _flr(xb)+0.5, _flr(ya)+0.5, _flr(yb)+0.5
  
  if xa > xb then xa,xb = xb,xa end
  if ya > yb then ya,yb = yb,ya end

  love.graphics.rectangle("fill", xa, ya, xb-xa+1, yb-ya+1)
end

local function rect(xa, ya, xb, yb, c)
  if c then color(c) end
  
  xa,xb,ya,yb = _flr(xa)+0.5, _flr(xb)+0.5, _flr(ya)+0.5, _flr(yb)+0.5
  
  love.graphics.rectangle("line", xa, ya, xb-xa, yb-ya)
end

local function circfill(x, y, r, c)
  if c then color(c) end
  
  love.graphics.circle("fill", _flr(x)+0.5, _flr(y)+0.5, _flr(r)+0.45)
end

local function circ(x, y, r, c)
  if c then color(c) end
  
  love.graphics.circle("line", _flr(x)+0.5, _flr(y)+0.5, _flr(r)+0.45)
end

local function trifill(xa, ya, xb, yb, xc, yc, c)
  if c then color(c) end
  
  love.graphics.polygon("fill", _flr(xa)+0.5, _flr(ya)+0.5, _flr(xb)+0.5, _flr(yb)+0.5, _flr(xc)+0.5, _flr(yc)+0.5)
end

local function tri(xa, ya, xb, yb, xc, yc, c)
  if c then color(c) end
  
  love.graphics.polygon("line", _flr(xa)+0.5, _flr(ya)+0.5, _flr(xb)+0.5, _flr(yb)+0.5, _flr(xc)+0.5, _flr(yc)+0.5)
end

local function line(xa, ya, xb, yb, c)
  if c then color(c) end
  
  love.graphics.line(_flr(xa)+0.5, _flr(ya)+0.5, _flr(xb)+0.5, _flr(yb)+0.5)
end

local function pset(x, y, c)
  if c then color(c) end
  
  love.graphics.points(_flr(x)+0.5, _flr(y)+0.5)
end

local function pget(x, y) -- use `scan_surface() first!`
  local data = _D.surf_data[_D.target]
  
  if not data then return 0 end
  
  local w, h = data:getDimensions()
  if x < 0 or y < 0 or x >= w or y >= h then
    return 0
  end
  
  local r, g, b = data:getPixel(x, y)
  
  local n = round(r * 10) + round(g * 10) * 10 + round(b * 10) * 100
  
  return n
end


---- PALETTE ----

local function use_palette(plt)
  if not plt then
    sugar.debug.r_log("Attempt to use inexistant palette.")
    return
  end
  
  if not plt[0] then
    local reordered = {}
    for i,c in ipairs(plt) do
      reordered[i-1] = c
    end
    plt = reordered
  end
  
  _D.palette = plt
  
    
  _D.palette_norm = {}
  for i = 0, #plt do
    local c = plt[i]
    
    local col = {
      ((c % 0x1000000) - (c % 0x10000)) / 0xff0000,
      ((c % 0x10000) - (c % 0x100)) / 0xff00,
      ((c % 0x100) - (c % 0x1)) / 0xff
    }
    
    _D.palette_norm[i] = col
  end
  
  _D.palswaps={}
  for i=0,#_D.palette do
    _D.pltswp_dw[i] = i
    _D.pltswp_fp[i] = i
    _D.transparency[i] = 0
  end
  _D.transparency[0] = 1
  
  _D.palette_size = #_D.palette + 1
  
  _index_colors = {}
  for i = 0, #_D.palette do
    _index_colors[i] = {
      (sugar.maths.flr(i) % 10) /10,
      (sugar.maths.flr(i/10) % 10) /10,
      (sugar.maths.flr(i/100) % 10) /10,
      1.0
    }
  end
  
  _update_shader_palette()
  
  sugar.debug.log("Now using a ".._D.palette_size.."-colors palette.")
end

local function get_palette()
  return sugar.utility.copy_table(_D.palette)
end

local function palette_len()
  return #_D.palette
end


---- SURFACE ----

local function new_surface(w, h, key)
  if key then
    if _D.surf_list[key] then
      sugar.debug.w_log("Surface '"..key.."' already exists. Overriding.")
      delete_surface(key)
    end
  else
    key = #_D.surf_list + 1
  end
  
  _D.surf_list[key] = love.graphics.newCanvas(w, h, {dpiscale = 1})
  
  sugar.debug.log("Successfully created "..w.."x"..h.." surface '"..key.."'.")
  
  return key
end

local function delete_surface(key)
  if key == _D.screen then
    sugar.debug.w_log("Deleting screen surface!")
  end

  if key == _D.target then
    target()
  end
  
  local canvas = _D.surf_list[key]
  local w,h = canvas:getDimensions()
  
  _D.surf_list[key] = nil
  
  sugar.debug.log("Deleted "..w.."x"..h.." surface '"..key.."'.");
end

local function surface_size(key)
  local canvas = _D.surf_list[key]
  
  if canvas then
    return canvas:getDimensions()
  else
    sugar.debug.r_log("Attempt to get size of inexistant surface '"..key.."'.")
  end
end

local function surface_exists(key)
  return _D.surf_list[key] ~= nil
end


local function target(surf_key)
  if surf_key then
    if not _D.surf_list[surf_key] then
      sugar.debug.r_log("Attempt to set inexistant surface '"..surf_key.."' as target.")
      return
    end
  else
    surf_key = _D.screen
  end
  
  _D.target = surf_key
  
  love.graphics.setCanvas(_D.surf_list[surf_key])
  
  sugar.gfx.clip()
  sugar.gfx.camera()
end

local function get_target()
  return _D.target
end

local function target_size()
  return _D.surf_list[_D.target]:getDimensions()
end

local function target_w()
  return select(1, _D.surf_list[_D.target]:getDimensions())
end

local function target_h()
  return select(2, _D.surf_list[_D.target]:getDimensions())
end


local function scan_surface(key)
  key = key or _D.screen
  
  local surf = _D.surf_list[key]
  
  if not surf then
    r_log("Attempt to scan inexistent surface '"..key.."'.")
    return
  end
  
  if love.graphics.getCanvas() == surf then
    love.graphics.setCanvas()
    _D.surf_data[key] = surf:newImageData()
    love.graphics.setCanvas(surf)
  else
    _D.surf_data[key] = surf:newImageData()
  end
end


local function surfshot_data(surf_key, scale)
  local surf = _D.surf_list[surf_key or _D.screen]
  if not surf then
    sugar.debug.r_log("Attempt to use 'surfshot(...)' on inexistent surface '"..surf_key.."'.")
  end

  local w, h = surf:getDimensions()
  local shot = love.graphics.newCanvas(w * scale, h * scale, {dpiscale = 1})
  
  local active_canvas = love.graphics.getCanvas()
  
  love.graphics.setColor(1,1,1,1)
  love.graphics.setCanvas(shot)
  love.graphics.origin()
  
  _D.use_index_color_shader()
  love.graphics.draw(surf, 0, 0, 0, scale, scale)
  _D.reset_shader()
  
  love.graphics.setColor(_D.love_color)
  love.graphics.setCanvas(active_canvas)
  love.graphics.translate(-_flr(_D.cam_x), -_flr(_D.cam_y))
  
  return shot:newImageData()
end

local function surfshot(surf_key, scale, file_name)
  local data = surfshot_data(surf_key, scale)
  
  if data then
    data:encode("png", file_name)
  end
end


---- COLORS ----

--local B = require("bit")
--uint8_t  get_color_r(uint32_t color){ return (color >> 16) & 0xff; }
--uint8_t  get_color_g(uint32_t color){ return (color >> 8) & 0xff; }
--uint8_t  get_color_b(uint32_t color){ return color & 0xff; }
--
--uint32_t set_color_r(uint32_t color, uint8_t r){ return (color & 0xff00ffff) + (r << 16); }
--uint32_t set_color_g(uint32_t color, uint8_t g){ return (color & 0xffff00ff) + (g << 8); }
--uint32_t set_color_b(uint32_t color, uint8_t b){ return (color & 0xffffff00) + b; }
--
--uint32_t rgb_color(uint8_t r, uint8_t g, uint8_t b){ return 0xff000000 | (r << 16) | (g << 8) | b; }
--uint32_t hsv_color(uint8_t h, uint8_t s, uint8_t v){
--  float c = v / 255.0f * s / 255.0f;
--  float m = v / 255.0f - c;  
--  float x = c * (1.0f - math::abs(math::mod(h * 6.0f / 256.0f, 2.0f) - 1.0f));
--  
--  float rr,gg,bb;
--  int hh = h * 6 / 256;
--  switch (hh){
--    case 0:
--      rr = c;    gg = x;    bb = 0.0f;
--      break;
--    case 1:
--      rr = x;    gg = c;    bb = 0.0f;
--      break;
--    case 2:
--      rr = 0.0f; gg = c;    bb = x;
--      break;
--    case 3:
--      rr = 0.0f; gg = x;    bb = c;
--      break;
--    case 4:
--      rr = x;    gg = 0.0f; bb = c;
--      break;
--    case 5:
--      rr = c;    gg = 0.0f; bb = x;
--      break;
--  }
--  
--  uint8_t r = (rr + m) * 255;
--  uint8_t g = (gg + m) * 255;
--  uint8_t b = (bb + m) * 255;
--  
--  return rgb_color(r, g, b);
--}



local palettes = {
  kirokaze_gb = {
    0x332c50, 0x46878f, 0x94e344, 0xe2f3e4
  },
  
  gb_chocolate = {
    0xffe4c2, 0xdca456, 0xa9604c, 0x422936
  },
  
  black_zero_gb = {
    0x2e463d, 0x385d49, 0x577b46, 0x7e8416
  },
  
  pokemon_gb = {
    0x181010, 0x84739c, 0xf7b58c, 0xffefff
  },
  
  blessing = {
    0x74569b, 0x96fbc7, 0xf7ffae, 
    0xffb3cb, 0xd8bfd8
  },
  
  oil6 = {
    0xfbf5ef, 0xf2d3ab, 0xc69fa5,
    0x8b6d9c, 0x494d7e, 0x272744
  },
  
  nyx8 = {
    0x08141e, 0x0f2a3f, 0x20394f, 0x4e495f,
    0x816271, 0x997577, 0xc3a38a, 0xf6d6bd
  },
  
  equpix15 = {
    0x101024, 0x2a2a3a, 0x523c4e, 0x3e5442, 
    0x38607c, 0x84545c, 0x5c7a56, 0xb27e56, 
    0xd44e52, 0x55a894, 0x80ac40, 0xec8a4b, 
    0x8bd0ba, 0xffcc68, 0xfff8c0
  },
  
  pico8 = {
    0x000000, 0x1D2B53, 0x7E2553, 0x008751,
    0xAB5236, 0x5F574F, 0xC2C3C7, 0xFFF1E8,
    0xFF004D, 0xFFA300, 0xFFEC27, 0x00E436,
    0x29ADFF, 0x83769C, 0xFF77A8, 0xFFCCAA
  },
    
  sweetie16 = {
    0x1a1c2c, 0x572956, 0xb14156, 0xee7b58,
    0xffd079, 0xa0f072, 0x38b86e, 0x276e7b,
    0x29366f, 0x405bd0, 0x4fa4f7, 0x86ecf8,
    0xf4f4f4, 0x93b6c1, 0x557185, 0x324056
  },
  
  grunge_shift = {
    0x000000, 0x242424, 0x240024, 0x482400,
    0x6c2424, 0xb42400, 0xd8b490, 0xb49000,
    0x6c6c00, 0x484800, 0x00fcd8, 0x4890fc,
    0x486c90, 0x244890, 0x9048b4, 0xd86cb4
  },
  
  bubblegum16 = {
    0x16171a, 0x7f0622, 0xd62411, 0xff8426,
    0xffd100, 0xfafdff, 0xff80a4, 0xff2674,
    0x94216a, 0x430067, 0x234975, 0x68aed4,
    0xbfff3c, 0x10d275, 0x007899, 0x002859
  },
  
  mail24 = {
    0x17111a, 0x372538, 0x7a213a, 0xe14141,
    0xffa070, 0xc44d29, 0xffbf36, 0xfff275,
    0x753939, 0xcf7957, 0xffd1ab, 0x39855a,
    0x83e04c, 0xdcff70, 0x243b61, 0x3898ff,
    0x6eeeff, 0x682b82, 0xbf3fb3, 0xff80aa,
    0x3e375c, 0x7884ab, 0xb2bcc2, 0xffffff
  },
  
  arcade29 = {
    0xff4d4d, 0x9f1e31, 0xffc438, 0xf06c00,
    0xf1c284, 0xc97e4f, 0x973f3f, 0x57142e,
    0x72cb25, 0x238531, 0x0a4b4d, 0x30c5ad,
    0x2f7e83, 0x69deff, 0x33a5ff, 0x3259e2,
    0x28237b, 0xc95cd1, 0x6c349d, 0xffaabc,
    0xe55dac, 0xf1f0ee, 0x96a5ab, 0x586c79,
    0x2a3747, 0x17191b, 0xb9a588, 0x7e6352,
    0x412f2f
  },
  
  ufo50 = {
    0xffffff, 0xa48080, 0xfeb854, 0xe8ea4a,
    0x58f5b1, 0x64a4a4, 0xcc68e4, 0xfe626e,
    0xc8c8c8, 0xe03c32, 0xfe7000, 0x63b31d,
    0xa4f022, 0x27badb, 0xfe48de, 0xd10f4c,
    0x707070, 0x991515, 0xca4a00, 0xa3a324,
    0x008456, 0x006ab4, 0x9600dc, 0x861650,
    0x000000, 0x4c0000, 0x783450, 0x8a6042,
    0x003d10, 0x202040, 0x340058, 0x4430ba
  },
  
  famicube = {
    0x000000, 0x00177D, 0x024ACA, 0x0084FF,
    0x5BA8FF, 0x98DCFF, 0x9BA0EF, 0x6264DC,
    0x3D34A5, 0x211640, 0x5A1991, 0x6A31CA,
    0xA675FE, 0xE2C9FF, 0xFEC9ED, 0xD59CFC,
    0xCC69E4, 0xA328B3, 0x871646, 0xCF3C71,
    0xFF82CE, 0xFFE9C5, 0xF5B784, 0xE18289,
    0xDA655E, 0x823C3D, 0x4F1507, 0xE03C28,
    0xE2D7B5, 0xC59782, 0xAE6C37, 0x5C3C0D,
    0x231712, 0xAD4E1A, 0xF68F37, 0xFFE737,
    0xFFBB31, 0xCC8F15, 0x939717, 0xB6C121,
    0xEEFFA9, 0xBEEB71, 0x8CD612, 0x6AB417,
    0x376D03, 0x172808, 0x004E00, 0x139D08,
    0x58D332, 0x20B562, 0x00604B, 0x005280,
    0x0A98AC, 0x25E2CD, 0xBDFFCA, 0x71A6A1,
    0x415D66, 0x0D2030, 0x151515, 0x343434,
    0x7B7B7B, 0xA8A8A8, 0xD7D7D7, 0xFFFFFF
  },
  
  aap_splendor128 = {
    0x050403, 0x0e0c0c, 0x2d1b1e, 0x612721,
    0xb9451d, 0xf1641f, 0xfca570, 0xffe0b7,
    0xffffff, 0xfff089, 0xf8c53a, 0xe88a36,
    0xb05b2c, 0x673931, 0x271f1b, 0x4c3d2e,
    0x855f39, 0xd39741, 0xf8f644, 0xd5dc1d,
    0xadb834, 0x7f8e44, 0x586335, 0x333c24,
    0x181c19, 0x293f21, 0x477238, 0x61a53f,
    0x8fd032, 0xc4f129, 0xd0ffea, 0x97edca,
    0x59cf93, 0x42a459, 0x3d6f43, 0x27412d,
    0x14121d, 0x1b2447, 0x2b4e95, 0x2789cd,
    0x42bfe8, 0x73efe8, 0xf1f2ff, 0xc9d4fd,
    0x8aa1f6, 0x4572e3, 0x494182, 0x7864c6,
    0x9c8bdb, 0xceaaed, 0xfad6ff, 0xeeb59c,
    0xd480bb, 0x9052bc, 0x171516, 0x373334,
    0x695b59, 0xb28b78, 0xe2b27e, 0xf6d896,
    0xfcf7be, 0xecebe7, 0xcbc6c1, 0xa69e9a,
    0x807b7a, 0x595757, 0x323232, 0x4f342f,
    0x8c5b3e, 0xc68556, 0xd6a851, 0xb47538,
    0x724b2c, 0x452a1b, 0x61683a, 0x939446,
    0xc6b858, 0xefdd91, 0xb5e7cb, 0x86c69a,
    0x5d9b79, 0x486859, 0x2c3b39, 0x171819,
    0x2c3438, 0x465456, 0x64878c, 0x8ac4c3,
    0xafe9df, 0xdceaee, 0xb8ccd8, 0x88a3bc,
    0x5e718e, 0x485262, 0x282c3c, 0x464762,
    0x696682, 0x9a97b9, 0xc5c7dd, 0xe6e7f0,
    0xeee6ea, 0xe3cddf, 0xbfa5c9, 0x87738f,
    0x564f5b, 0x322f35, 0x36282b, 0x654956,
    0x966888, 0xc090a9, 0xd4b8b8, 0xeae0dd,
    0xf1ebdb, 0xddcebf, 0xbda499, 0x886e6a,
    0x594d4d, 0x33272a, 0xb29476, 0xe1bf89,
    0xf8e398, 0xffe9e3, 0xfdc9c9, 0xf6a2a8,
    0xe27285, 0xb25266, 0x64364b, 0x2a1e23
  }
}

local gfx = {
  init_gfx                       = init_gfx,
  shutdown_gfx                   = shutdown_gfx,
  
  render_to_canvas               = render_to_canvas,
  
  screen_render_stretch          = screen_render_stretch,
  screen_render_integer_scale    = screen_render_integer_scale,
  screen_resizeable              = screen_resizeable,
  screen_resize                  = screen_resize,
  update_screen_size             = update_screen_size,
  
  screen_get_render_stretch      = screen_get_render_stretch,
  screen_get_render_integer_scale= screen_get_render_integer_scale,
  screen_get_resizeable          = screen_get_resizeable,
  screen_size                    = screen_size,
  screen_w                       = screen_w,
  screen_h                       = screen_h,
  screen_scale                   = screen_scale,
  set_background_color           = set_background_color,
  
  half_flip                      = half_flip,
  flip                           = flip,
  
  screen_shader                  = screen_shader,
  screen_shader_input            = screen_shader_input,
  
  camera                         = camera,
  camera_move                    = camera_move,
  get_camera                     = get_camera,
  clip                           = clip,
  get_clip                       = get_clip,
  color                          = color,
  pal                            = pal,
  
  clear                          = clear,
  cls                            = cls,
  rectfill                       = rectfill,
  rect                           = rect,
  circfill                       = circfill,
  circ                           = circ,
  trifill                        = trifill,
  tri                            = tri,
  line                           = line,
  pset                           = pset,
  pget                           = pget,
  
  use_palette                    = use_palette,
  get_palette                    = get_palette,
  palette_len                    = palette_len,
  
  new_surface                    = new_surface,
  delete_surface                 = delete_surface,
  surface_size                   = surface_size,
  surface_exists                 = surface_exists,
  
  target                         = target,
  get_target                     = get_target,
  target_size                    = target_size,
  target_w                       = target_w,
  target_h                       = target_h,
  
  scan_surface                   = scan_surface,
  
  surfshot                       = surfshot,
  surfshot_data                  = surfshot_data,
  
  palettes                       = palettes
}

sugar.utility.merge_tables(sugar.gfx, gfx)

sugar.S = sugar.S or {}
for k,v in pairs(gfx) do
  sugar.S[k] = v
end

return sugar.gfx