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
  if btn(0) then apple.vx = apple.vx - acc end
  if btn(1) then apple.vx = apple.vx + acc end
  if btn(2) then apple.vy = apple.vy - acc end
  if btn(3) then apple.vy = apple.vy + acc end
  
  apple.x = apple.x + apple.vx * dt()
  apple.y = apple.y + apple.vy * dt()
  
  apple.vx = apple.vx * 0.5
  apple.vy = apple.vy * 0.5
  
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
  
  local n = 8
  local x, y = 64, 32
  
  for i = 1, n do
    local part = {
      x = x,
      y = y
    }
    
    if i == 1 then -- defining sprite + ball radius
      part.s = 64
      part.r = 4
    elseif i > n - 2 then
      local v = i - (n - 2)
      part.s = 66 + v * 2
      part.r = 4 - v
    else
      part.s = 66
      part.r = 4
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
    aspr(96, head.x, head.y, head.a, 1, 1, 0.5-v*0.75)
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
        board[i][j] = irnd(9)
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


function define_controls()
  register_btn(0, 0, {input_id("keyboard", "left"),
                      input_id("keyboard", "a")})
  register_btn(1, 0, {input_id("keyboard", "right"),
                      input_id("keyboard", "d")})
  register_btn(2, 0, {input_id("keyboard", "up"),
                      input_id("keyboard", "w")})
  register_btn(3, 0, {input_id("keyboard", "down"),
                      input_id("keyboard", "s")})
end