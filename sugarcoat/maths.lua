sugar = sugar or {}


local function cos(a) return math.cos(a*2*math.pi) end
local function sin(a) return math.sin(a*2*math.pi) end
local function atan2(x,y) return math.atan2(y,x)/(2*math.pi) end
local function lerp(a,b,i) return (1-i)*a+i*b end
local function round(a) return flr(a+0.5) end
local function sgn(a) return a>0 and 1 or a<0 and -1 or 0 end

local function sqr(a) return a*a end
local function cub(a) return a*a*a end

local pow  = math.pow
local sqrt = math.sqrt
local flr  = math.floor
local ceil = math.ceil
local abs  = math.abs
local min  = math.min
local max  = math.max


local function angle_diff(a1,a2)
  local a=a2-a1
  return (a+0.5)%1-0.5
end

local function dist(x1,y1,x2,y2)
  local x,y
  if x2 then
    x=x2-x1
    y=y2-y1
  else
    x=x1
    y=y1
  end
  
  return sugar.maths.sqrt(sqrdist(x,y))
end

local function sqrdist(x,y)
  return sqr(x)+sqr(y)
end

local function mid(a, b, c)
  if a>b then
    a,b = b,a
  end
  
  if b>c then
    b,c = c,b
  end
  
  if a>b then
    a,b = b,a
  end
  
  return b
end


local UINT32_MAX = 0xffffffff
local x, y, z, w, v = 123456789, 362436069, 521288629, 88675123, 886756453

local function srand(seed)
  seed = seed or 0

  if seed % 1 ~= 0 then
    seed = flr(seed * 1000)
  end

  x = abs(seed);
  y = 362436069;
  z = 521288629;
  w = 88675123;
  v = 886756453;
end

local B = require("bit")
local function raw_rnd()
  local t = B.bxor(x, B.rshift(x, 7))
  x, y, z, w = y, z, w, v
  v = B.bxor(B.bxor(v, B.lshift(v, 6)), B.bxor(t, B.lshift(t, 13)))
  return B.tobit((y + y + 1) * v)
end

local function rnd(n)
  n = n or 1
  return ((raw_rnd() / 4294967295 + 0.5) * n);
end

local function irnd(n)
  return (raw_rnd() + 2147483648) % n;
end

local function pick(tab)
  local i = irnd(#tab) + 1
  return tab[i], i
end


sugar.maths = {
  cos        = cos,
  sin        = sin,
  atan2      = atan2,

  angle_diff = angle_diff,
  dist       = dist,
  sqrdist    = sqrdist,
  lerp       = lerp,

  sqr        = sqr,
  cub        = cub,

  pow        = pow,
  sqrt       = sqrt,

  flr        = flr,
  round      = round,
  ceil       = ceil,

  abs        = abs,
  sgn        = sgn,
  
  min        = min,
  max        = max,
  mid        = mid,

  srand      = srand,
  raw_rnd    = raw_rnd,
  rnd        = rnd,
  irnd       = irnd,
  pick       = pick
}

sugar.S = sugar.S or {}
for k,v in pairs(sugar.maths) do
  sugar.S[k] = v
end

return sugar.maths