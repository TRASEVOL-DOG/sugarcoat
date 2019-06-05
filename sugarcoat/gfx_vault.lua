

-- /!\ This file should not be accessed outside of the library /!\ --

local data = {
  init = false,
  
  surf_list = {},
  surf_data = {},
  
  palette = {},
  palette_norm = {},
  palette_size = 0,
  
  love_color = {1,1,1,1},
  
  shaders = {},
  shader_code = {},
  
  screen = "__screen__",
  
  window_scale = 2,
  
  screen_x = 0,
  screen_y = 0,
  screen_sca_x = 2,
  screen_sca_y = 2,
  
  cam_x = 0,
  cam_y = 0,
  clip_x = 0,
  clip_y = 0,
  clip_w = 0xffff,
  clip_h = 0xffff,
  
  target = nil,
  color = 0,
  
  pltswp_dw = {},
  pltswp_fp = {},
  
  spritesheet = nil,
  spsh_gw = 8,
  spsh_gh = 8,
  spsh_nx = 0,
  spsh_ny = 0,
  
  transparency = {},
  
  font_list = {},
  default_font = "__font__",
  current_font = nil,
  print_pattern = {},
  printp_col1 = 0,
  printp_col2 = 0,
  printp_col3 = 0
}

return data