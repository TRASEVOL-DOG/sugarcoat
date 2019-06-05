if CASTLE_PREFETCH then
  CASTLE_PREFETCH({
    "test.png"
  })
end

require("sugarcoat/sugarcoat")

local S = sugar.S

S.using_package(S, true)

local px,py
local dy

function love.load()
  init_sugar("Hello world!", 128, 128, 3)
  
--  screen_render_integer_scale(false)
  --screen_render_stretch(true)
  --screen_resizeable(true, 3)
  
  screen_shader([[
    varying vec2 v_vTexcoord;
    varying vec4 v_vColour;
    
    vec4 effect(vec4 color, Image texture, vec2 coords, vec2 screen_coords)
    {
      vec4 col = Texel_color(texture, coords);
      
      vec2 co = mod(coords * SCREEN_SIZE, 1.0);
      float k = 1.0 - max(co.x * co.x, co.y * co.y);
      
      return (0.75*k + 0.75) * col;
    }
  ]])
  
  load_png("spritesheet", "test.png", nil, true)
  
  register_btn(0, 0, {input_id("keyboard", "left"),
                      input_id("keyboard", "a")})
  register_btn(1, 0, {input_id("keyboard", "right"),
                      input_id("keyboard", "d")})
  register_btn(2, 0, {input_id("keyboard", "up"),
                      input_id("keyboard", "w")})
  register_btn(3, 0, {input_id("keyboard", "down"),
                      input_id("keyboard", "s")})
  
  register_btn(4, 0, input_id("keyboard", "return"))
  
  register_btn(5, 0, input_id("mouse_button", "scroll_y"))
  
  px, py = 64, 64
  dy = 64
  
  log("init done!")
end

function love.update()
  if btn(0) then px = px - 1 end
  if btn(1) then px = px + 1 end
  if btn(2) then py = py - 1 end
  if btn(3) then py = py + 1 end
  
  dy = dy + btnv(5)
end

function love.draw()
--  camera()

  color(0)
  cls()

  color(1)
  
  rectfill(32,32,96,96)
  
  circfill(64,64,32,2)
  
  rect(34,34,98,98,3)
  circ(66,66,32)
  
  pset(32,32,2)
  pset(96,96,2)
  
  local a = t()/4
  trifill(
    64+32*cos(a), 64+32*sin(a),
    64+32*cos(a+0.333), 64+32*sin(a+0.333),
    64+32*cos(a+0.666), 64+32*sin(a+0.666), 3
  )
  
  tri(
    64+36*cos(a), 64+36*sin(a),
    64+36*cos(a+0.333), 64+36*sin(a+0.333),
    64+36*cos(a+0.666), 64+36*sin(a+0.666), 3
  )
  
  printp(0x4440, 0x4140, 0x4240, 0x4400)
  printp_color(3,0,1)
  
  pprint("Hello world!", 0, 0)
  
  printp(0x2120, 0x3230, 0x0300, 0x0000)
  local str = "This is Sugarcoat!"
  local x, y = 1, 12
  for i = 1, #str do
    local c = str:sub(i,i)
    pprint(c, x, y + 3*cos(-a * 2 + i/5))
    x = x + str_px_width(c)
  end
  
  spr(1, btnp(5) and 4 or 0, dy)

  if btnr(4) then
    aspr(0, px, py, -a, 2, 2, nil, nil, 3, 3)
  elseif btn(4) then
    aspr(0, px, py, -a, 2, 2, nil, nil, 2, 2)
  else
    aspr(0, px, py, -a, 2, 2)
  end
end