## `sugar. gfx`

- Contents:
  - General
    - [`init_gfx(window_name, w, h, scale)`](#sugargfx-init_gfx-window_name-w-h-scale)
    - [`shutdown_gfx()`](#sugargfx-shutdown_gfx-)
    - [`flip()`](#sugargfx-flip-)
    - [`render_to_canvas(canvas)`](#sugargfx-render_to_canvas-canvas)
  - Draw parameters
    - [`camera(x, y)`](#sugargfx-camera-x--0-y--0)
    - [`camera_move(dx, dy)`](#sugargfx-camera_move-dx-dy)
    - [`get_camera()`](#sugargfx-get_camera-)
    - [`clip(x, y, w, h)`](#sugargfx-clip-x-y-w-h)
    - [`get_clip()`](#sugargfx-get_clip-)
    - [`color(i)`](#sugargfx-color-i)
    - [`pal(ca, cb, flip_level)`](#sugargfx-pal-ca-cb-flip_level--false)
    - [`palt(c, make_transparent)`](#sugargfx-palt-c-make_transparent)
  - Draw operations
    - [`clear(c)`](#sugargfx-clear-c--0)
    - [`cls(c)`](#sugargfx-cls-c--0)
    - [`rectfill(xa, ya, xb, yb, c)`](#sugargfx-rectfill-xa-ya-xb-yb-c)
    - [`rect(xa, ya, xb, yb, c)`](#sugargfx-rect-xa-ya-xb-yb-c)
    - [`circfill(x, y, r, c)`](#sugargfx-circfill-x-y-r-c)
    - [`circ(x, y, r, c)`](#sugargfx-circ-x-y-r-c)
    - [`trifill(xa, ya, xb, yb, xc, yc, c)`](#sugargfx-trifill-xa-ya-xb-yb-xc-yc-c)
    - [`tri(xa, ya, xb, yb, xc, yc, c)`](#sugargfx-tri-xa-ya-xb-yb-xc-yc-c)
    - [`line(xa, ya, xb, yb, c)`](#sugargfx-line-xa-ya-xb-yb-c)
    - [`pset(x, y, c)`](#sugargfx-pset-x-y-c)
    - [`pget(x, y)`](#sugargfx-pget-x-y)
  - Palette
    - [`use_palette(plt)`](#sugargfx-use_palette-plt)
    - [`get_palette()`](#sugargfx-get_palette-)
    - [`palette_len()`](#sugargfx-palette_len-)
    - [`palettes`](#sugargfx-palettes)
  - Surfaces
    - [`new_surface(w, h, key)`](#sugargfx-new_surface-w-h-key)
    - [`load_png(key, file_name, palette, use_as_spritesheet)`](#sugargfx-load_png-key-file_name-palette-use_as_spritesheet)
    - [`delete_surface(key)`](#sugargfx-delete_surface-key)
    - [`surface_size(key)`](#sugargfx-surface_size-key)
    - [`surface_exists(key)`](#sugargfx-surface_exists-key)
    - [`surfshot(surf_key, scale, file_name)`](#sugargfx-surfshot-surf_key-scale-file_name)
    - [`surfshot_data(surf_key, scale)`](#sugargfx-surfshot_data-surf_key-scale)
    - [`target(surf_key)`](#sugargfx-target-surf_key)
    - [`get_target()`](#sugargfx-get_target-)
    - [`target_size()`](#sugargfx-target_size-)
    - [`target_w()`](#sugargfx-target_w-)
    - [`target_h()`](#sugargfx-target_h-)
    - [`scan_surface(surf_key)`](#sugargfx-scan_surface-surf_key)
  - Sprites
    - [`spritesheet(surf_key)`](#sugargfx-spritesheet-surf_key)
    - [`get_spritesheet()`](#sugargfx-get_spritesheet-)
    - [`spritesheet_grid(w, h)`](#sugargfx-spritesheet_grid-w--8-h--8)
    - [`get_spritesheet_grid()`](#sugargfx-get_spritesheet_grid-)
    - [`spr(s, x, y, w, h, flip_x, flip_y)`](#sugargfx-spr-s-x-y-w--1-h--1-flip_x-flip_y)
    - [`aspr(s, x, y, a, w, h, anchor_x, anchor_y, scale_x, scale_y)`](#sugargfx-aspr-s-x-y-a-w--1-h--1-anchor_x--05-anchor_y--05-scale_x-scale_y)
    - [`sspr(sx, sy, sw, sh, dx, dy, dw, dh)`](#sugargfx-sspr-sx-sy-sw-sh-dx-dy-dw--sw-dh--sh)
    - [`spr_sheet(key, x, y, dw, dh)`](#sugargfx-spr_sheet-key-x-y-dw-dh)
    - [`sget(x, y, key)`](#sugargfx-sget-x-y-key)
  - Text rendering
    - [`load_font(ttf_filepath, size, key, use_it)`](#sugargfx-load_font-ttf_filepath-size-key-use_it)
    - [`delete_font(key)`](#sugargfx-delete_font-key)
    - [`use_font(key)`](#sugargfx-use_font-key)
    - [`get_font()`](#sugargfx-get_font-)
    - [`str_px_width(str, font)`](#sugargfx-str_px_width-str-font)
    - [`print(str, x, y, c)`](#sugargfx-print-str-x-y-c)
    - [`printp(a, b, c, d)`](#sugargfx-printp-a-b-c-d)
    - [`printp_color(c1, c2, c3)`](#sugargfx-printp_color-c1-c2-c3)
    - [`pprint(str, x, y, c1, c2, c3)`](#sugargfx-pprint-str-x-y-c1-c2-c3)
  - Screen size and render modes
    - [`screen_size()`](#sugargfx-screen_size-)
    - [`screen_w()`](#sugargfx-screen_w-)
    - [`screen_h()`](#sugargfx-screen_h-)
    - [`screen_scale()`](#sugargfx-screen_scale-)
    - [`screen_render_stretch(enable)`](#sugargfx-screen_render_stretch-enable)
    - [`screen_render_integer_scale(enable)`](#sugargfx-screen_render_integer_scale-enable)
    - [`screen_resizeable(enable, scale, on_resize_callback)`](#sugargfx-screen_resizeable-enable-scale-on_resize_callback)
    - [`screen_resize(w, h, resize_window)`](#sugargfx-screen_resize-w-h-resize_window)
    - [`update_screen_size()`](#sugargfx-update_screen_size-)
    - [`screen_get_render_stretch()`](#sugargfx-screen_get_render_stretch-)
    - [`screen_get_render_integer_scale()`](#sugargfx-screen_get_render_integer_scale-)
    - [`screen_get_resizeable()`](#sugargfx-screen_get_resizeable-)
    - [`set_background_color(c)`](#sugargfx-set_background_color-c)
    - [`window_size(w, h)`](#sugargfx-window_size-w-h)
  - Post-processing shader
    - [`screen_shader(shader_code)`](#sugargfx-screen_shader-shader_code)
    - [`screen_shader_input(value_table)`](#sugargfx-shader_input-value_table)

&#8202;

#### `sugar.gfx. init_gfx (window_name, w, h, scale)`
- Initializes the gfx subsystem of Sugar.
- Is called by `init_sugar(...)`.
- `w` and `h` are the width and height you want for your simulated screen resolution.
- `scale` is the scale factor you want for stretching your simulated resolution. You can change the behavior around scaling with the various `sugar.gfx.screen_...` functions.

&#8202;

#### `sugar.gfx. shutdown_gfx ()`
- Shuts down the gfx subsystem.
- Is called by `sugar.shutdown_sugar ()`.

&#8202;

#### `sugar.gfx. flip ()`
- Shows the result of your draw operations on the screen.
- Is called automatically around `love.draw ()`.

&#8202;

#### `sugar.gfx. render_to_canvas ([canvas])`
- If set, `canvas` has to be a love2D canvas, built with `love.graphics.newCanvas(...)`.
- If `canvas` is set, Sugarcoat will draw the simulated screen to this love2D canvas instead of directly to the real screen.
- This can be used in pair with the `sugar.after_render` callback to do post-processing on Sugarcoat's output.

&#8202;

---

#### `sugar.gfx. camera ([x = 0, y = 0])`
- Sets a coordinate offset of {-x, -y} for the following draw operations.
- Calling `camera ()` resets this.

&#8202;

#### `sugar.gfx. camera_move (dx, dy)`
- Offsets the coordinate offset so that it becomes {-x-dx, -y-dy}

&#8202;

#### `sugar.gfx. get_camera ()`
- Gets the current (inversed) drawing coordinate offset.
- Returns:
  - camera_x
  - camera_y

&#8202;

#### `sugar.gfx. clip (x, y, w, h)`
- Sets the clip area so that nothing gets drawn outside of it.

&#8202;

#### `sugar.gfx. get_clip ()`
- Gets the current clip area.
- Returns:
  - clip_x
  - clip_y
  - clip_w
  - clip_h

&#8202;

#### `sugar.gfx. color (i)`
- Sets the color to use for drawing functions to `i`.
- `i` is an index to a color in the currently used [palette](#sugargfx-use_paletteplt).

&#8202;

#### `sugar.gfx. pal (ca, cb, [flip_level = false])`
- Swaps the color `ca` with the color `cb` in the following draw operations. (if `flip_level` is `false`)
- `ca` and `cb` are both indexes in the currently used palette.
- If `flip_level` is true, the swap will only take effect on display.

&#8202;

#### `sugar.gfx. palt (c, make_transparent)`
- Makes the color `c` transparent or not, for sprite operations.
- `c` is an index in the currently used palette.
- `0` is transparent by default. Use `palt(0, false)` for the color `0` to be drawn from sprites.

&#8202;

---

#### `sugar.gfx. clear ([c = 0])`
- Clears the screen with the color `c`.

&#8202;

#### `sugar.gfx. cls ([c = 0])`
- Alias for `clear(c)`.

&#8202;

#### `sugar.gfx. rectfill (xa, ya, xb, yb, [c])`
- Draws a filled rectangle.

&#8202;

#### `sugar.gfx. rect (xa, ya, xb, yb, [c])`
- Draws an empty rectangle.

&#8202;

#### `sugar.gfx. circfill (x, y, r, [c])`
- Draws a filled circle.

&#8202;

#### `sugar.gfx. circ (x, y, r, [c])`
- Draws an empty circle.

&#8202;

#### `sugar.gfx. trifill (xa, ya, xb, yb, xc, yc, [c])`
- Draws a filled triangle.

&#8202;

#### `sugar.gfx. tri (xa, ya, xb, yb, xc, yc, [c])`
- Draws an empty triangle.

&#8202;

#### `sugar.gfx. line (xa, ya, xb, yb, [c])`
- Draws a line.

&#8202;

#### `sugar.gfx. pset (x, y, [c])`
- Sets the Color of one pixel.

&#8202;

#### `sugar.gfx. pget (x, y)`
- Gets the palette index of the pixel at {x; y} on the screen.
- Changes made to the screen will not be reflected until you call [`scan_surface()`](#sugargfx-scan_surface-surf_key).

&#8202;

---

#### `sugar.gfx. use_palette (plt)`
- Sets the given palette as palette to use.
- The palette has to be a table of hexadecimal colors. (e.g. 0xff00ff)
- Can be used with the pre-defined palettes in [`palettes`](#sugargfx-palettes).

&#8202;

#### `sugar.gfx. get_palette ()`
- Returns a copy of the palette in use.

&#8202;

#### `sugar.gfx. palette_len ()`
- Returns the length of the currently used palette.

&#8202;

#### `sugar.gfx. palettes`
- A table containing pre-defined palettes.
- The default palette of Sugarcoat is `palettes.kirokaze_gb`
- Here are the palettes contained:
  - [`palettes. kirokaze_gb`](https://lospec.com/palette-list/kirokaze-gameboy)
  - [`palettes. gb_chocolate`](https://lospec.com/palette-list/gb-chocolate)
  - [`palettes. black_zero_gb`](https://lospec.com/palette-list/nintendo-gameboy-black-zero)
  - [`palettes. pokemon_gb`](https://lospec.com/palette-list/pokemon-sgb)
  - [`palettes. blessing`](https://lospec.com/palette-list/blessing)
  - [`palettes. oil6`](https://lospec.com/palette-list/oil-6)
  - [`palettes. nyx8`](https://lospec.com/palette-list/nyx8)
  - [`palettes. equpix15`](https://lospec.com/palette-list/equpix15)
  - [`palettes. pico8`](https://lospec.com/palette-list/pico-8)
  - [`palettes. sweetie16`](https://lospec.com/palette-list/sweetie-16)
  - [`palettes. grunge_shift`](https://lospec.com/palette-list/grunge-shift)
  - [`palettes. bubblegum16`](https://lospec.com/palette-list/bubblegum-16)
  - [`palettes. mail24`](https://lospec.com/palette-list/mail-24)
  - [`palettes. arcade29`](https://lospec.com/palette-list/arcade-standard-29)
  - [`palettes. ufo50`](https://lospec.com/palette-list/ufo-50)
  - [`palettes. famicube`](https://lospec.com/palette-list/famicube)
  - [`palettes. aap_splendor128`](https://lospec.com/palette-list/aap-splendor128)

&#8202;

---

#### `sugar.gfx. new_surface (w, h, [key])`
- Creates a surface with a width of `w` and a height of `h`.
- The surface can be used in the other surface functions with its key.
- If `key` is not set, key is the next available numeral key.
- Returns the surface's key.

&#8202;

#### `sugar.gfx. load_png (key, file_name, [palette], [use_as_spritesheet])`
- Loads the file `file_name` as a new surface.
- The file will be converted to an indexed surface using the `palette`. If `palette` isn't set, the currently used palette will be used.
- The surface becomes the new spritesheet if `use_as_spritesheet` is true.
- The program will crash if `file_name` cannot be found.
- If used in Castle, `file_name` may be an URL to a picture hosted online.

&#8202;

#### `sugar.gfx. delete_surface (key)`
- Deletes the surface `key`. _(duh.)_

&#8202;

#### `sugar.gfx. surface_size (key)`
- Returns:
  - width of the surface
  - height of the surface

&#8202;

#### `sugar.gfx. surface_exists (key)`
- Returns `true` if there is a surface for `key`, returns `false` otherwise.

&#8202;

#### `sugar.gfx. surfshot (surf_key, scale, file_name)`
- Saves the surface `surf_key`, upscaled by `scale`, as `file_name`, as a PNG.
- The picture will be saved locally, at `%appdata%\LOVE\[project  (or Castle)]` if on Windows, and at `/Users/user/Library/Application Support/LOVE/[project  (or castle)]` if on Mac.
- If `surf_key` is `nil`, saves the screen surface.

&#8202;

#### `sugar.gfx. surfshot_data (surf_key, scale)`
- Returns an ImageData representing the surface `surf_key`, upscaled by `scale`.
- If `surf_key` is `nil`, it uses the screen surface instead.
- ImageData is [a Love2D data type](https://love2d.org/wiki/ImageData).

&#8202;

#### `sugar.gfx. target ([surf_key])`
- Sets the target of the following draw operations to that surface.
- `target()` resets it.

&#8202;

#### `sugar.gfx. get_target ()`
- Returns the key of the currently used target.
- If the current target is the screen, this will return `__screen__`.

&#8202;

#### `sugar.gfx. target_size ()`
- Returns:
  - width of the current target
  - height of the current target

&#8202;

#### `sugar.gfx. target_w ()`
- Returns the width of the current target.

&#8202;

#### `sugar.gfx. target_h ()`
- Returns the height of the current target.

&#8202;

#### `sugar.gfx. scan_surface([surf_key])`
- Updates the pixel info to be querried with `pget(...)` and `sget(...)`.
- If `surf_key` is set, updates the info for the surface `surf_key`.
- If `surf_key` isn't set, updates the info for the screen surface.
- This function can be slow. Avoid using it more than a few times per frame.

&#8202;

---

Note that the spritesheet drawing functions will fail if no spritesheet surface was set.

&#8202;

#### `sugar.gfx. spritesheet (surf_key)`
- Use the surface `surf_key` as spritesheet.

&#8202;

#### `sugar.gfx. get_spritesheet ()`
- Get the key for the current spritesheet.

&#8202;

#### `sugar.gfx. spritesheet_grid ([w = 8, h = 8])`
- Sets the tile size to use for the spritesheet's grid.
- Default tile size is 8x8.

&#8202;

#### `sugar.gfx. get_spritesheet_grid ()`
- Returns:
  - the grid's tile width
  - the grid's tile height

&#8202;

#### `sugar.gfx. spr (s, x, y, [w = 1, h = 1, [flip_x, flip_y]])`
- Draws the sprite at the position `s` on the spritesheet grid, at the coordinates {x; y}
- `w` and `h` are the size of the sprite **in tiles**.
- If `flip_x` is true, flips the sprite horizontally
- If `flip_y` is true, flips the sprite vertically

&#8202;

#### `sugar.gfx. aspr (s, x, y, a, [w = 1, h = 1, [anchor_x = 0.5, anchor_y = 0.5, [scale_x, scale_y]]])`
- Draws the sprite at the position `s` on the spritesheet grid, at the coordinates {x; y}, with the rotation `a`. _('a' is a turn-based angle)_
- `w` and `h` are the size of the sprite **in tiles**.
- `anchor_x` and `anchor_y` define the rotation point of the sprite. {0; 0} is upper-left corner, {1; 1} is down-right corner.
- `scale_x` and `scale_y` are scale factors.

&#8202;

#### `sugar.gfx. sspr (sx, sy, sw, sh, dx, dy, [dw = sw, dh = sh])`
- Draws and stretches the rectangle {sx, sy, sw, sh} from the sprite-sheet as the rectangle {dx, dy, dw, dh} on the target surface.

&#8202;

#### `sugar.gfx. spr_sheet (key, x, y, [dw, dh])`
- Draws the entire surface `key` at the coordinates {x; y}.
- If `key` is `nil`, draws the current spritesheet instead.
- If `dw` and `dh` are set, resizes the surface to that size.

&#8202;

#### `sugar.gfx. sget (x, y, [surf_key])`
- Gets the palette index of the pixel at {x; y} on the spritesheet.
- If `surf_key` is set, gets the pixel from the surface `key` instead.
- Changes made to the surface will not be reflected by `sget(...)` until you call [`scan_surface(surf_key)`](#sugargfx-scan_surface-surf_key).

&#8202;

---

The default font in Sugarcoat is TeapotPro by [Eeve Somepx](https://twitter.com/somepx)! Support him!

&#8202;

#### `sugar.gfx. load_font (ttf_filepath, size, [key], [use_it])`
- Loads the font from the file at `ttf_filepath`.
- If you're unsure about the size, try 16 or 12.
- If `key` is not set, key is the next available numeral font key.
- If `use_it` is true, the loaded font becomes the active font.
- The program will crash if `ttf_filepath` cannot be found.

&#8202;

#### `sugar.gfx. delete_font (key)`
- Deletes the font `key`. _(duh.)_

&#8202;

#### `sugar.gfx. use_font (key)`
- Sets the font `key` as current active font.

&#8202;

#### `sugar.gfx. get_font ()`
- Returns the key for the current active font.

&#8202;

#### `sugar.gfx. str_px_width (str, [font])`
- Returns the width in pixels of the string `str` as displayed with the font `font`.
- Font defaults to the current active font.

&#8202;

#### `sugar.gfx. print (str, x, y, [c])`
- Draws the string `str` on the screen at the coordinates {x; y}.

&#8202;

#### `sugar.gfx. printp (a, b, c, d)`
- Defines the print pattern for `pprint(...)`.
- This function should be called like this:
```lua
  printp( 0x1200,
          0x2300,
          0x0000,
          0x0000 )
```
- `a, b, c, d` represent the four lines of the pattern, with each hexadecimal number being a cell of the pattern.
- The hexadecimal number defines the viewing priority: 1 will always be visible, 2 may be hidden by 1 but not by 3, 3 may be hidden by 1 and 2, 0 will not be drawn.
- The position of those numbers on the grid defines the offset with which they should be drawn.
- Those numbers also correspond to the colors you set with `printp_color(c1, c2, c3)`.
- With the example above, `pprint(text, x, y)` will render `text` at `x+1, y+1` with color 3, then at `x+1, y` and `x, y+1` with color 2, and finally at `x, y` with color 1.

&#8202;

#### `sugar.gfx. printp_color (c1, c2, c3)`
- Sets the colors for `pprint(...)`.

&#8202;

#### `sugar.gfx. pprint (str, x, y, [c1, c2, c3])`
- Renders the string `str` with the pattern defined by the last `printp(...)` call, at the coordonates `x, y`.
- `c1, c2, c3` are optional, you may call `printp_color(c1, c2, c3)` beforehand instead.

&#8202;

---

#### `sugar.gfx. screen_size ()`
- Returns:
  - the width of the simulated screen resolution
  - the height of the simulated screen resolution

&#8202;

#### `sugar.gfx. screen_w ()`
- Returns the width of the simulated screen resolution

&#8202;

#### `sugar.gfx. screen_h ()`
- Returns the height of the simulated screen resolution

&#8202;

#### `sugar.gfx. screen_scale ()`
- Returns the scale of the simulated resolution to be rendered on the actual screen.

&#8202;

#### `sugar.gfx. screen_render_stretch (enable)`
- Sets whether the simulated screen should be stretched to fill the entire game window.
- Only in this mode may the width and height factors not be the same.

&#8202;

#### `sugar.gfx. screen_render_integer_scale (enable)`
- Sets whether to only use integer factors to stretch the simulated screen.

&#8202;

#### `sugar.gfx. screen_resizeable (enable, scale, [on_resize_callback])`
- Sets whether the simulated resolution should change according to the window size.
- The new resolution will always be [window_size / `scale`].
- `on_resize_callback` is a function to be called on resizing. Alternatively, you may define `love.resize()`.

&#8202;

#### `sugar.gfx. screen_resize (w, h, [resize_window])`
- Resizes the simulated resolution to the given size.

&#8202;

#### `sugar.gfx. update_screen_size ()`
- Updates the screen rendering after window changes.
- Should get called internally whenever necessary.

&#8202;

#### `sugar.gfx. screen_get_render_stretch ()`
- Returns whether the render stretch is enabled.

&#8202;

#### `sugar.gfx. screen_get_render_integer_scale ()`
- Returns whether the render integer scale is enabled.

&#8202;

#### `sugar.gfx. screen_get_resizeable ()`
- Returns whether the simulated screen is resizeable.

&#8202;

#### `sugar.gfx. set_background_color ([c])`
- Changes the window color around the simulated screen to the color `c` in the palette.
- If `c` isn't set, the window color is set to black. (#000000)

&#8202;

#### `sugar.gfx. window_size ([w, h])`
- If `w` and `h` are set, resizes the window to that size.
- In any case, returns:
  - the width of the window
  - the height of the window

&#8202;

---

#### `sugar.gfx. screen_shader ([shader_code])`
- Attempts to compile the string `shader_code` as a GLSL ES shader.
- If compiled successfully, the shader is used to render the simulated screen onto the actual full-size screen.
- If the compilation failed, an error will be shown in the log, along with why it failed.
- In your shader code, you can use the following functions and variables:
  - `Texel_color(Image texture, vec2 coords)` returns the texture's color at those coordinates. You should use this function instead of `Texel(...)` because the latter will return encoded values.
  - `Texel_index(Image texture, vec2 coords)` returns the palette index for the color at those coordinates, as an `int`.
  - `SCREEN_SIZE` is a `vec2` containing the width and the height of the simulated screen.
  - `PALETTE` is an array of `vec4`, containing the colors of the palette.
  - `SWAPS` is an array of `int` containing the [palette swaps](#sugargfx-pal-ca-cb-flip_level--false) made at flip level.
- If `shader_code` is not set, this will reset to the default rendering shader.

&#8202;

#### `sugar.gfx. screen_shader_input(value_table)`
- Feeds data into `extern` variables in the current screen shader.
- For each key in `value_table`, if a corresponding `extern` variable exists in the shader, it will receive the corresponding value.
- Both array values and vector values should be passed as list-style tables.
- Surfaces can be passed as Image variables in the shader.
- `value_table` has to be defined as a table such as this:
```lua
{
  [key_A] = value,
  [key_B] = {array_v1, array_v2, ...},
  [key_C] = {vec_x, vec_y, vec_z},
  ...
}
```

