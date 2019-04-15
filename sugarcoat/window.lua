sugar = sugar or {}
sugar.gfx = sugar.gfx or {}


local function window_size(w, h)
  if w and h then
    love.window.setMode(w, h, {})
  end
  
  return love.graphics.getDimensions()
end



local window = {
  window_size = window_size
}

sugar.utility.merge_tables(sugar.gfx, window)

sugar.S = sugar.S or {}
for k,v in pairs(window) do
  sugar.S[k] = v
end

return sugar.gfx