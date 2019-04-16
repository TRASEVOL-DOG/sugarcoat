# sugarcoat
An interface to use the SUGAR API with Castle &amp; Love2D

[SUGAR](https://trasevol.dog/sugar/) is a retro-inspired, limitation-led C++ game engine!
It features a minimalist API and a retro graphics infrastructure for making authentic low-resolution games.
Sugarcoat is an attempt to reproduce most of SUGAR's behavior in [Castle](https://castle.games/) & [Love2D](https://love2d.org/).

 

## Getting started
First of all, make sure the folder `sugarcoat` is in your project's folder and is complete.
Then do `require("sugarcoat/sugarcoat")` at the top of your `main.lua`.

 

Next, I recommend that you do either of these lines: *(not both)*
```lua
local S = sugar.S
```
OR
```lua
sugar.utility.using_package(sugar.S, true)
```

`sugar.S` is intended to serve as a shortcut - it has the content of all the subpackages in sugar. So instead of calling `sugar.input.btn(0)`, you may write `sugar.S.btn(0)` or, after the `local S` line, `S.btn(0)`.

`sugar.utility.using_package(package, override)` merges the given package into the global environment. In other words: the content of the package will now be global. By using it on `sugar.S`, you will be able to use all of sugarcoat's functions as global functions. So, with the previous example, you could simply use `btn(0)`.

 

Then you can simply use `love.load`, `love.update` and `love.draw` to make your game. Make sure to use `sugar.init_sugar(window_name, w, h, scale)` at the top of `love.load`. The rest of the sugar systems will automatically update around `love.update()`, `love.draw()`.

(you may change the screen stretching style with the various `sugar.gfx.screen_...` functions)

In case you do not intend to use `love.update()` and `love.draw()`, you should call `sugar.sugar_step()` to update the input and time subsystems, and `sugar.gfx.flip()` to render the screen.

 

And that is the essentials. I do recommend you at least skim through the rest of the manual to be aware of the various functions available to you.

Here is a very quick example showing some of the basics:

```lua
require("sugarcoat/sugarcoat")
sugar.utility.using_package(sugar.S)

local x = 64
local y = 64

function love.load()
  init_sugar("Hello world!", 128, 128, 3)
  
  set_frame_waiting(60)
  
  register_btn(0, 0, input_id("keyboard", "left"))
  register_btn(1, 0, input_id("keyboard", "right"))
  register_btn(2, 0, input_id("keyboard", "up"))
  register_btn(3, 0, input_id("keyboard", "down"))
end

function love.update()
  if btn(0) then x = x - 2 end
  if btn(1) then x = x + 2 end
  if btn(2) then y = y - 2 end
  if btn(3) then y = y + 2 end
end

function love.draw()
  cls()
  circfill(x, y, 4 + 2 * cos(time()), 3)
end
```

Have fun!

 

---
## sugar

Here are the available packages and their functions:
(this is a placeholder for the upcoming actual documentation)

* `sugar`
  - `init_sugar(window_name, w, h, scale)`
  - `sugar_step()`
  - `shutdown_sugar()`
  - `sys_battery()`
  
  - `debug`
    - `start_log(file_name)`
    - `end_log()`
    - `log(str)`
    - `w_log(str)`
    - `r_log(str)`
    - `assert(condition, str)`
    - `abort(str)`
    - `abort_brutal(str)`
    - `write_clipboard(str)`
    - `read_clipboard()`
  
  - `gfx`
    - `init_gfx(window_name, w, h, scale)`
    - `shutdown_gfx()`
    - `screen_render_stretch(enable)`
    - `screen_render_integer_scale(enable)`
    - `screen_resizeable(enable, scale, on_resize_callback)`
    - `screen_resize(w, h, resize_window)`
    - `update_screen_size()`
    - `screen_get_render_stretch()`
    - `screen_get_render_integer_scale()`
    - `screen_get_resizeable()`
    - `screen_size()`
    - `screen_w()`
    - `screen_h()`
    - `screen_scale()`
    - `half_flip()`
    - `flip()`
    - `camera(x, y)`
    - `camera_move(dx, dy)`
    - `get_camera()`
    - `clip(x, y, w, h)`
    - `get_clip()`
    - `color(i)`
    - `pal(ca, cb, flip_level)`
    - `clear(c)`
    - `cls(c)`
    - `rectfill(xa, ya, xb, yb, c)`
    - `rect(xa, ya, xb, yb, c)`
    - `circfill(x, y, r, c)`
    - `circ(x, y, r, c)`
    - `trifill(xa, ya, xb, yb, xc, yc, c)`
    - `tri(xa, ya, xb, yb, xc, yc, c)`
    - `line(xa, ya, xb, yb, c)`
    - `pset(x, y, c)`
    - `use_palette(plt)`
    - `get_palette()`
    - `palette_len()`
    - `new_surface(w, h, key)`
    - `delete_surface(key)`
    - `surface_size(key)`
    - `target(surf_key)`
    - `get_target()`
    - `target_size()`
    - `target_w()`
    - `target_h()`
    - `palettes` [a table]
    - `spritesheet(surf_key)`
    - `get_spritesheet()`
    - `load_png(key, file_name, palette, use_as_spritesheet)`
    - `spritesheet_grid(w, h)`
    - `get_spritesheet_grid(w, h)`
    - `palt(c, make_transparent)`
    - `spr(s, x, y, w, h, flip_x, flip_y)`
    - `aspr(s, x, y, a, w, h, anchor_x, anchor_y, scale_x, scale_y)`
    - `sspr(sx, sy, sw, sh, dx, dy, dw, dh)`
    - `spr_sheet(x, y, key)`
    - `load_font(ttf_filepath, size, key, use_it)`
    - `delete_font(key)`
    - `use_font(key)`
    - `get_font()`
    - `str_px_width(str, font)`
    - `print(str, x, y, c)`
    - `printp(a, b, c, d)`
    - `printp_color(c1, c2, c3)`
    - `pprint(str, x, y, c1, c2, c3)`
    - `window_size(w, h)`
    
  - `input`
    - `init_input()`
    - `update_input()`
    - `shutdown_input()`
    - `exit_required()`
    - `require_exit()`
    - `new_player()`
    - `input_type` [a table]
    - `input_id(type, id)`
    - `register_btn(btn_id, player, inputs)`
    - `btn(id, player)`
    - `btnp(id, player)`
    - `btnr(id, player)`
    - `btnv(id, player)`
    - `ctrlr_list()`
    - `ctrlr_count()`
    - `player_assign_ctrlr(player, controller)`
    - `ctrlr_has_default_bindings(controller)`
    - `ctrlr_name(controller)`
    
  - `maths`
    - `cos(a)`
    - `sin(a)`
    - `atan2(x, y)`
    - `lerp(a, b, i)`
    - `round(a)`
    - `sgn(a)`
    - `pow(a, b)`
    - `sqrt(a)`
    - `flr(a)`
    - `ceil(a)`
    - `abs(a)`
    - `min(a, b)`
    - `max(a, b)`
    - `mid(a, b, c)`
    - `angle_diff(a1, a2)`
    - `dist(x1, y1, x2, y2)`
    - `sqrdist(x, y)`
    - `srand(seed)`
    - `raw_rnd()`
    - `rnd(n)`
    - `irnd(n)`
    - `pick(tab)`
    
  - `time`
    - `init_time()`
    - `update_time()`
    - `set_frame_waiting(fps)`
    - `t()`
    - `time()`
    - `dt()`
    - `delta_time()`
    - `sleep(sec)`
    - `freeze(sec)`
    - `fps()`
    - `fps_raw()`
    - `frame_time()`
    - `frame_time_raw()`
    - `sys_ltime()`
    - `sys_gtime()`

  - `utility`
    - `using_package(p, do_override)`
    - `all(ar)`
    - `del(ar, val)`
    - `del_at(ar, n)`
    - `add(ar, v)`
    - `sort(ar)`
    - `merge_tables(dst, src)`
    - `copy_table(ar, deep)`
  
  - `S` [contains everything]
