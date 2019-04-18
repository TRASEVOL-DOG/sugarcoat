## `sugar.gfx`
#### `sugar.gfx.init_gfx(window_name, w, h, scale)`
#### `sugar.gfx.shutdown_gfx()`

#### `sugar.gfx.half_flip()`
#### `sugar.gfx.flip()`

#### `sugar.gfx.camera(x, y)`
#### `sugar.gfx.camera_move(dx, dy)`
#### `sugar.gfx.get_camera()`
#### `sugar.gfx.clip(x, y, w, h)`
#### `sugar.gfx.get_clip()`
#### `sugar.gfx.color(i)`
#### `sugar.gfx.pal(ca, cb, flip_level)`
#### `sugar.gfx.palt(c, make_transparent)`

#### `sugar.gfx.clear(c)`
#### `sugar.gfx.cls(c)`
#### `sugar.gfx.rectfill(xa, ya, xb, yb, c)`
#### `sugar.gfx.rect(xa, ya, xb, yb, c)`
#### `sugar.gfx.circfill(x, y, r, c)`
#### `sugar.gfx.circ(x, y, r, c)`
#### `sugar.gfx.trifill(xa, ya, xb, yb, xc, yc, c)`
#### `sugar.gfx.tri(xa, ya, xb, yb, xc, yc, c)`
#### `sugar.gfx.line(xa, ya, xb, yb, c)`
#### `sugar.gfx.pset(x, y, c)`

#### `sugar.gfx.use_palette(plt)`
#### `sugar.gfx.get_palette()`
#### `sugar.gfx.palette_len()`

#### `sugar.gfx.new_surface(w, h, key)`
#### `sugar.gfx.load_png(key, file_name, palette, use_as_spritesheet)`
#### `sugar.gfx.delete_surface(key)`
#### `sugar.gfx.surface_size(key)`
#### `sugar.gfx.target(surf_key)`
#### `sugar.gfx.get_target()`
#### `sugar.gfx.target_size()`
#### `sugar.gfx.target_w()`
#### `sugar.gfx.target_h()`

#### `sugar.gfx.palettes` [a table]

#### `sugar.gfx.spritesheet(surf_key)`
#### `sugar.gfx.get_spritesheet()`
#### `sugar.gfx.spritesheet_grid(w, h)`
#### `sugar.gfx.get_spritesheet_grid(w, h)`
#### `sugar.gfx.spr(s, x, y, w, h, flip_x, flip_y)`
#### `sugar.gfx.aspr(s, x, y, a, w, h, anchor_x, anchor_y, scale_x, scale_y)`
#### `sugar.gfx.sspr(sx, sy, sw, sh, dx, dy, dw, dh)`
#### `sugar.gfx.spr_sheet(x, y, key)`

#### `sugar.gfx.load_font(ttf_filepath, size, key, use_it)`
#### `sugar.gfx.delete_font(key)`
#### `sugar.gfx.use_font(key)`
#### `sugar.gfx.get_font()`
#### `sugar.gfx.str_px_width(str, font)`
#### `sugar.gfx.print(str, x, y, c)`

#### `sugar.gfx.printp(a, b, c, d)`
#### `sugar.gfx.printp_color(c1, c2, c3)`
#### `sugar.gfx.pprint(str, x, y, c1, c2, c3)`

#### `sugar.gfx.screen_size()`
#### `sugar.gfx.screen_w()`
#### `sugar.gfx.screen_h()`
#### `sugar.gfx.screen_scale()`
#### `sugar.gfx.screen_render_stretch(enable)`
#### `sugar.gfx.screen_render_integer_scale(enable)`
#### `sugar.gfx.screen_resizeable(enable, scale, on_resize_callback)`
#### `sugar.gfx.screen_resize(w, h, resize_window)`
#### `sugar.gfx.update_screen_size()`
#### `sugar.gfx.screen_get_render_stretch()`
#### `sugar.gfx.screen_get_render_integer_scale()`
#### `sugar.gfx.screen_get_resizeable()`

#### `sugar.gfx.window_size(w, h)`