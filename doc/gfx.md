## `sugar. gfx`
#### `sugar.gfx. init_gfx (window_name, w, h, scale)`
- Initializes the gfx subsystem of sugar.
- Is called by `init_sugar(...)`.
- `w` and `h` are the width and height you want for your simulated screen resolution.
- `scale` is the scale factor you want for stretching your simulated resolution. You can change the behavior around scaling with the various `sugar.gfx.screen_...` functions.

#### `sugar.gfx. shutdown_gfx ()`
- Shuts down the gfx subsystem.
- Is called by `sugar.shutdown_sugar ()`.

#### `sugar.gfx. flip ()`
- Shows the result of your draw operations on the screen.
- Is called automatically around `love.draw ()`.

---

#### `sugar.gfx. camera ([x = 0, y = 0])`
- Sets a coordinate offset of {-x, -y} for the following draw operations.
- Calling `camera ()` resets this.

#### `sugar.gfx. camera_move (dx, dy)`
- Offsets the coordinate offset so that it becomes {-x-dx, -y-dy}

#### `sugar.gfx. get_camera ()`
- Gets the current (inversed) drawing coordinate offset.
- Returns:
  - camera_x
  - camera_y

#### `sugar.gfx. clip (x, y, w, h)`
- Sets the clip area so that nothing gets drawn outside of it.

#### `sugar.gfx. get_clip ()`
- Gets the current clip area.
- Returns:
  - clip_x
  - clip_y
  - clip_w
  - clip_h

#### `sugar.gfx. color (i)`
- Sets the color to use for drawing functions to `i`.
- `i` is an index to a color in the currently used [palette](#sugargfx-use_paletteplt).

#### `sugar.gfx. pal (ca, cb, [flip_level = false])`
- Swaps the color `ca` with the color `cb` in the following draw operations. (if `flip_level` is `false`)
- `ca` and `cb` are both indexes in the currently used palette.
- If `flip_level` is true, the swap will only take effect on display.

#### `sugar.gfx. palt (c, make_transparent)`
- Makes the color `c` transparent or not, for sprite operations.
- `c` is an index in the currently used palette.

---

#### `sugar.gfx. clear ([c = 0])`
- Clears the screen with the color `c`.

#### `sugar.gfx. cls ([c = 0])`
- Alias for `clear(c)`.

#### `sugar.gfx. rectfill (xa, ya, xb, yb, [c])`
- Draws a filled rectangle.

#### `sugar.gfx. rect (xa, ya, xb, yb, [c])`
- Draws an empty rectangle.

#### `sugar.gfx. circfill (x, y, r, [c])`
- Draws a filled circle.

#### `sugar.gfx. circ (x, y, r, [c])`
- Draws an empty circle.

#### `sugar.gfx. trifill (xa, ya, xb, yb, xc, yc, [c])`
- Draws a filled triangle.

#### `sugar.gfx. tri (xa, ya, xb, yb, xc, yc, [c])`
- Draws an empty triangle.

#### `sugar.gfx. line (xa, ya, xb, yb, [c])`
- Draws a line.

#### `sugar.gfx. pset (x, y, [c])`
- Sets the Color of one pixel.

---

#### `sugar.gfx. use_palette (plt)`
- Sets the given palette as palette to use.
- The palette has to be a table of hexadecimal colors. (e.g. 0xff00ff)
- Can be used with the pre-defined palettes in [`palettes`](#sugargfx-palettes).

#### `sugar.gfx. get_palette ()`
- Returns a copy of the palette in use.

#### `sugar.gfx. palette_len ()`
- Returns the length of the currently used palette.

#### `sugar.gfx. palettes`
- A table containing pre-defined palettes.
- The default palette of Sugarcoat is `palettes.kirokaze_gb`



---

#### `sugar.gfx. new_surface (w, h, [key])`
- Creates a surface with a width of `w` and a height of `h`.
- The surface can be used in the other surface functions with its key.
- If `key` is not set, key is the next available numeral key.
- Returns the surface's key.

#### `sugar.gfx. load_png (key, file_name, [palette], [use_as_spritesheet])`
- Loads the file `file_name` as a new surface.
- The file will be converted to an indexed surface using the `palette`. If `palette` isn't set, the currently used palette will be used.
- The surface becomes the new spritesheet if `use_as_spritesheet` is true.
- The program will crash if `file_name` cannot be found.

#### `sugar.gfx. delete_surface (key)`
- Deletes the surface `key`. _(duh.)_

#### `sugar.gfx. surface_size (key)`
- Returns:
  - width of the surface
  - height of the surface

#### `sugar.gfx. target ([surf_key])`
- Sets the target of the following draw operations to that surface.
- `target()` resets it.

#### `sugar.gfx. get_target ()`
- Returns the key of the currently used target.
- If the current target is the screen, this will return `__screen__`.

#### `sugar.gfx. target_size ()`
- Returns:
  - width of the current target
  - height of the current target

#### `sugar.gfx. target_w ()`
- Returns the width of the current target.

#### `sugar.gfx. target_h ()`
- Returns the height of the current target.

---

Note that the spritesheet drawing functions will fail if no spritesheet surface was set.

#### `sugar.gfx. spritesheet (surf_key)`
- Use the surface `surf_key` as spritesheet.

#### `sugar.gfx. get_spritesheet ()`
- Get the key for the current spritesheet.

#### `sugar.gfx. spritesheet_grid ([w = 8, h = 8])`
- Sets the tile size to use for the spritesheet's grid.
- Default tile size is 8x8.

#### `sugar.gfx. get_spritesheet_grid (w, h)`
- Returns:
  - the grid's tile width
  - the grid's tile height

#### `sugar.gfx. spr (s, x, y, [w = 1, h = 1, [flip_x, flip_y]])`
- Draws the sprite at the position `s` on the spritesheet grid, at the coordinates {x; y}
- `w` and `h` are the size of the sprite **in tiles**.
- If `flip_x` is true, flips the sprite horizontally
- If `flip_y` is true, flips the sprite vertically

#### `sugar.gfx. aspr (s, x, y, a, [w = 1, h = 1, [anchor_x = 0.5, anchor_y = 0.5, [scale_x, scale_y]]])`
- Draws the sprite at the position `s` on the spritesheet grid, at the coordinates {x; y}, with the rotation `a`. _('a' is a turn-based angle)_
- `w` and `h` are the size of the sprite **in tiles**.
- `anchor_x` and `anchor_y` define the rotation point of the sprite. {0; 0} is upper-left corner, {1; 1} is down-right corner.
- `scale_x` and `scale_y` are scale factors.

#### `sugar.gfx. sspr (sx, sy, sw, sh, dx, dy, [dw = sw, dh = sh])`
- Draws and stretches the rectangle {sx, sy, sw, sh} from the sprite-sheet as the rectangle {dx, dy, dw, dh} on the target surface.

#### `sugar.gfx. spr_sheet (x, y, [key])`
- Draws the whole spritesheet at the coordinates {x; y}.
- If `key` is set, draws the surface `key` instead of the spritesheet.

---

The default font in Sugarcoat is TeapotPro by [Eeve Somepx](https://twitter.com/somepx)! Support him!

#### `sugar.gfx. load_font (ttf_filepath, size, [key], [use_it])`
- Loads the font from the file at `ttf_filepath`.
- If you're unsure about the size, try 16 or 12.
- If `key` is not set, key is the next available numeral font key.
- If `use_it` is true, the loaded font becomes the active font.
- The program will crash if `ttf_filepath` cannot be found.

#### `sugar.gfx. delete_font (key)`
- Deletes the font `key`. _(duh.)_

#### `sugar.gfx. use_font (key)`
- Sets the font `key` as current active font.

#### `sugar.gfx. get_font ()`
- Returns the key for the current active font.

#### `sugar.gfx. str_px_width (str, [font])`
- Returns the width in pixels of the string `str` as displayed with the font `font`.
- Font defaults to the current active font.

#### `sugar.gfx. print (str, x, y, [c])`
- Draws the string `str` on the screen at the coordinates {x; y}.

#### `sugar.gfx. printp (a, b, c, d)`
- Defines the print pattern for `pprint(...)`.
- `a, b, c, d` are to be defined as such:
```lua
  printp( 0x3330,
          0x3130,
          0x3230,
          0x3330 )
```
- The text will be drawn multiple times, with offsets according to the numbers' positions on the pattern, with the colors defined in "printp_color(...)". 2 will be drawn on top of 3, and 1 will be drawn on top of 2.


#### `sugar.gfx. printp_color (c1, c2, c3)`
#### `sugar.gfx. pprint (str, x, y, c1, c2, c3)`

---

#### `sugar.gfx. screen_size ()`
#### `sugar.gfx. screen_w ()`
#### `sugar.gfx. screen_h ()`
#### `sugar.gfx. screen_scale ()`
#### `sugar.gfx. screen_render_stretch (enable)`
#### `sugar.gfx. screen_render_integer_scale (enable)`
#### `sugar.gfx. screen_resizeable (enable, scale, on_resize_callback)`
#### `sugar.gfx. screen_resize (w, h, resize_window)`
#### `sugar.gfx. update_screen_size ()`
#### `sugar.gfx. screen_get_render_stretch ()`
#### `sugar.gfx. screen_get_render_integer_scale ()`
#### `sugar.gfx. screen_get_resizeable ()`

#### `sugar.gfx. window_size (w, h)`

