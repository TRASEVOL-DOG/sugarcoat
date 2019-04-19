# `sugar`

- Contents:
  - [`init_sugar(window_name, w, h, scale)`](#sugar-init_sugar-window_name-w-h-scale)
  - [`sugar_step()`](#sugar-sugar_step-)
  - [`shutdown_sugar()`](#sugar-shutdown_sugar-)
  - [`sys_battery()`](#sugar-sys_battery-)
  - [`S`](#sugar-S)
  - [`debug`](#sugar-debug)
  - [`gfx`](#sugar-gfx)
  - [`input`](#sugar-input)
  - [`maths`](#sugar-maths)
  - [`time`](#sugar-time)
  - [`audio`](#sugar-audio)
  - [`utility`](#sugar-utility)
  
&#8202;

#### `sugar. init_sugar (window_name, w, h, scale)`
- Initializes Sugarcoat for use.
- `w` and `h` are the width and height you want for your simulated screen resolution.
- `scale` is the scale factor you want for stretching your simulated resolution. You can change the behavior around scaling with the various `sugar.gfx.screen_...` functions.

&#8202;

#### `sugar. sugar_step ()`
- Updates the sugar subsystems that need updating.
- This function will already be called automatically if you use `love.update()` - otherwise you will have to call it in your code once every frame.

&#8202;

#### `sugar. shutdown_sugar ()`
- Shuts down the various sugarcoat subsystems.
- This function is automatically called on closing the application, unless you are using your own `love.run`.
- Since Love2D has a garbage collector (contrarily to C++ SUGAR), this function doesn't actually need to be called at any time.

&#8202;

#### `sugar. sys_battery ()`
- Get the state of the system's battery.
- Returns, in this order:
  - Percents of battery left
  - Whether the system is on battery (true) or if it is plugged in (false)
  - Battery life remaining (in seconds)

&#8202;

#### `sugar. S`
- A table that contains the content of all the subpackages in sugarcoat.
- You may call any sugarcoat function through `sugar.S.foo()`.

&#8202;

---

The listed features in the following subpackage are not comprehensive, they're only big points.

&#8202;

#### [`sugar. debug`](/doc/debug.md#sugar-debug)
- The debug subpackage of sugar.
- Features logs and reading + writing to clipboard.

&#8202;

#### [`sugar. gfx`](/doc/gfx.md#sugar-gfx)
- The graphics subpackage of sugar.
- Features a framework for low-resolution graphics, a palette system, a surface and spritesheet system, text drawing, and primitive drawing.

&#8202;

#### [`sugar. input`](/doc/input.md#sugar-input)
- The input subpackage of sugar.
- Features a simple system where you assign inputs to buttons and then check for those button's state.
- Has controller support.

&#8202;

#### [`sugar. maths`](/doc/maths.md#sugar-maths)
- The maths subpackage of sugar.
- Features turn-based angles and determinative random number generation.

&#8202;

#### [`sugar. time`](/doc/time.md#sugar-time)
- The time subpackage of sugar.
- Features frames-per-second locking.

&#8202;

#### `sugar. audio`
- The audio subpackage of sugar.
- Features a collection system where you load sfx and musics, then play them through their index in the collection.

&#8202;

#### `sugar. utility`
- The utility subpackage of sugar.
- This subpackage is unique to sugarcoat, it doesn't exist in the original Sugar.
- Features functions to work with Lua tables.
- Contains `using_package(p, override)`.
