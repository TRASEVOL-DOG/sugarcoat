if CASTLE_PREFETCH then
  CASTLE_PREFETCH({
    "sheet.png"
  })
end


require("sugarcoat/sugarcoat")

sugar.utility.using_package(sugar.S, true)

function love.load()
  init_sugar("Apple!", 128, 128, 3)
  screen_render_integer_scale(false)
  
  set_frame_waiting(30)
  
  use_palette(palettes.bubblegum16)
  set_background_color(15)
  
  load_png("spritesheet", "sheet.png", nil, true)
  
  define_controls()
  
  init_game()
  
  log("Game initialized.")
end

function love.update()
  update_game()
end

function love.draw()
  draw_game()
end


function init_game()
  init_board()
  
  new_apple()
  new_snake()
  
  
end

function update_game()
  update_apple()
  update_snake()
end

function draw_game()
  palt(0, false) -- 0 is not the transparent color here
  
  cls(0)
  
  palt(11, false) -- the board tiles use that color
  
  draw_board()
  
  palt(11, true) -- the other sprites use that color for transparency
  
  draw_apple()
  draw_snake()
  
  draw_bottomfence()
  
  rectfill(0, 0, 127, 15, 0)
  local str = "chillin' with snek"
--  print(str, 1, 2, 11)
--  print(str, 1, 1, 5)

  local x, y = 2, 0
  for i = 1, #str do
    local ch = str:sub(i, i)
    local yy = y + 3 * cos(i/24.5 - t() * 0.25)
    
    print(ch, x-1, yy+1, 10)
    print(ch, x, yy+1, 11)
    print(ch, x-1, yy, 11)
    print(ch, x, yy, 5)
    
    x = x + str_px_width(ch)
  end
  
  -- drawing mouse cursor
  palt(11, false)
  palt(12, true)
  local mx, my = btnv(6), btnv(7)
  if btn(8) then
    spr(99, mx, my, 1, 2)
  else
    spr(98, mx, my, 1, 2)
  end
  palt(12, false)
end


function new_apple()
  apple = {
    x = 64,
    y = 72,
    vx = 0,
    vy = 0,
    t = 0
  }
end

function update_apple()
  local acc = dt() * 15 * 30
  
  if btn(4) or btn(5) then
    apple.vx = apple.vx + btnv(4) * acc
    apple.vy = apple.vy + btnv(5) * acc
  end
  
  if btn(8) then
    local mx, my = btnv(6), btnv(7)
    local a = atan2(mx - apple.x, my - apple.y)
    
    apple.vx = apple.vx + cos(a) * acc
    apple.vy = apple.vy + sin(a) * acc
  end
  
  if btn(0) then apple.vx = apple.vx - acc end
  if btn(1) then apple.vx = apple.vx + acc end
  if btn(2) then apple.vy = apple.vy - acc end
  if btn(3) then apple.vy = apple.vy + acc end
  
  apple.x = apple.x + apple.vx * dt()
  apple.y = apple.y + apple.vy * dt()
  
  apple.vx = apple.vx * 0.5
  apple.vy = apple.vy * 0.5
  
  -- controlling game space borders
  local hw, hh = 4, 1
  if apple.x - hw < 8   then apple.x = 8 + hw   end
  if apple.x + hw > 120 then apple.x = 120 - hw end
  if apple.y - hh < 24  then apple.y = 24 + hh  end
  if apple.y + hh > 120 then apple.y = 120 - hh end
  
  apple.t = apple.t + dt()
end

function draw_apple()
  local anim
  local flipx
  if abs(apple.vx) + abs(apple.vy) > 0.1 then
    -- run animation
    anim = {34, 36, 38, 40, 42}
    flipx = (apple.vx < 0)
  else
    -- idle animation
    anim = {32, 32, 32, 32, 32, 44, 44, 32, 46, 46, 32, 44, 44, 32, 46, 46, 32, 44, 44, 32, 32, 32, 32, 32}
  end
  
  local s = anim[flr(apple.t / 0.06) % #anim + 1]
  
  spr(s, apple.x - 8, apple.y - 8, 2, 2)
end


function new_snake()
  snake = {}
  
  local n = 32
  local x, y = 64, 32
  
  for i = 1, n do
    local part = {
      x = x,
      y = y
    }
    
    if i == 1 then -- defining sprite + ball radius
      part.s = 64
      part.r = 1
    elseif i > n - 4 then
      local v = (i - (n - 4))/2
      part.s = 66 + ceil(v) * 2
      part.r = 1--2 - v/2
    else
      part.s = 66
      part.r = 1
    end
  
    add(snake, part)
  end
  
  snake[1].a = 0.0
  snake[1].spd = 25
end

function update_snake()
  local head = snake[1]
  
  local target_a = atan2(apple.x - head.x, apple.y - head.y)
  local diff_a = angle_diff(head.a, target_a)
  
  head.a = head.a + 1 * dt() * diff_a
  
  local wave = 0.1 * cos(t()/2)
  head.x = head.x + head.spd * cos(head.a + wave) * dt()
  head.y = head.y + head.spd * sin(head.a + wave) * dt()
  
  -- controlling game space borders
  local hw, hh = 3, 0
  if head.x - hw < 8   then head.x = 8 + hw   end
  if head.x + hw > 120 then head.x = 120 - hw end
  if head.y - hh < 24  then head.y = 24 + hh  end
  if head.y + hh > 120 then head.y = 120 - hh end

  for i = 2, #snake do
    local part = snake[i]
    local prev = snake[i-1]
    
    local d = dist(prev.x, prev.y, part.x, part.y)
    local md = prev.r + part.r
    if d > md then
      part.x = lerp(part.x, prev.x, (d-md)/d)
      part.y = lerp(part.y, prev.y, (d-md)/d)
    end
  end
end

function draw_snake()
  local head = snake[1]
  if t()%4 < 0.25 or t()%7 < 0.25 or t()%13 < 0.25 then
    local v = cos(0.75 + t() * 2)
    aspr(96, head.x, head.y, head.a, 1, 1, 0.5-v, 3.5/8)
  end

  for i = #snake, 1, -1 do
    local part = snake[i]
    spr(part.s + 8, part.x-8, part.y-8, 2, 2)
  end
  
  for i = #snake, 1, -1 do
    local part = snake[i]
    spr(part.s, part.x-8, part.y-8, 2, 2)
  end
  
  aspr(97, head.x, head.y, head.a, 1, 1, 0.4)
end


function update_titlescreen()

end

function draw_titlescreen()

end


function init_board()
  -- initializing the board tables with a sprite id for each tile, to draw on draw_table().

  board = {}
  for i = 0, 13 do
    board[i] = {}
  end
  
  for i = 1, 12 do
    for j = 1, 14 do
      if rnd(8) > 1 then
        --board[i][j] = flr(rnd(4))
        board[i][j] = irnd(4)
      else
        --board[i][j] = flr(rnd(9))
        board[i][j] = irnd(10)
      end
    end
    
    board[i][0] = 18
    board[i][15] = 19
  end
  
  for i = 1,14 do
    board[0][i] = 16
    board[13][i] = 17
  end
  
  board[0][0] = 20
  board[0][15] = 21
  board[13][0] = 22
  board[13][15] = 23
end

function draw_board()
  local y = 16
  for i = 0, 13 do
    local x = 0
    local line = board[i]
    
    for j = 0, 15 do
      spr(line[j], x, y)
    
      x = x + 8
    end
    
    y = y + 8
  end
end

function draw_bottomfence()
  for i = 1, 14 do
    spr(24, i*8, 120)
  end
end


function define_controls()
  player_assign_ctrlr(0, 0)

  register_btn(0, 0, {input_id("keyboard", "left"),
                      input_id("keyboard", "a"),
                      input_id("controller_button", "dpleft")})
  register_btn(1, 0, {input_id("keyboard", "right"),
                      input_id("keyboard", "d"),
                      input_id("controller_button", "dpright")})
  register_btn(2, 0, {input_id("keyboard", "up"),
                      input_id("keyboard", "w"),
                      input_id("controller_button", "dpup")})
  register_btn(3, 0, {input_id("keyboard", "down"),
                      input_id("keyboard", "s"),
                      input_id("controller_button", "dpdown")})
  
  register_btn(4, 0, input_id("controller_axis", "leftx"))
  register_btn(5, 0, input_id("controller_axis", "lefty"))
  
  register_btn(6, 0, input_id("mouse_position", "x"))
  register_btn(7, 0, input_id("mouse_position", "y"))
  register_btn(8, 0, input_id("mouse_button", "lb"))
end