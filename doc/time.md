## `sugar. time`

- Contents:
  - [`init_time()`](#sugartime-init_time-)
  - [`update_time()`](#sugartime-update_time-)
  - [`set_frame_waiting(fps)`](#sugartime-set_frame_waiting-fps)
  - [`t()`](#sugartime-t-)
  - [`time()`](#sugartime-time-)
  - [`dt()`](#sugartime-dt-)
  - [`delta_time()`](#sugartime-delta_time-)
  - [`sleep(sec)`](#sugartime-sleep-sec)
  - [`freeze(sec)`](#sugartime-freeze-sec)
  - [`fps()`](#sugartime-fps-)
  - [`fps_raw()`](#sugartime-fps_raw-)
  - [`frame_time()`](#sugartime-frame_time-)
  - [`frame_time_raw()`](#sugartime-frame_time_raw-)
  - [`sys_ltime()`](#sugartime-sys_ltime-)
  - [`sys_gtime()`](#sugartime-sys_gtime-)

&#8202;

#### `sugar.time. init_time ()`
- Initializes the time subsystem of Sugar.
- Is called by `init_sugar()`.

&#8202;

#### `sugar.time. update_time ()`
- Updates the time subsystem.
- Is automatically called around `love.update()`.

&#8202;

#### `sugar.time. set_frame_waiting ([fps])`
- Sets a cap to the number of frames per second.
- Sugarcoat will wait so that `1/fps` seconds passes between each frame.
- Call `set_frame_waiting()` to remove the fps cap.
- Sugarcoat doesn't set any fps cap until you call this function. 

&#8202;

#### `sugar.time. t ()`
- Returns the time in seconds since the program's start-up.

&#8202;

#### `sugar.time. time ()`
- Alias for `t()`.

&#8202;

#### `sugar.time. dt ()`
- Returns the time between this frame and the previous one.

&#8202;

#### `sugar.time. delta_time ()`
- Alias for `dt()`.

&#8202;

#### `sugar.time. sleep (sec)`
- Stops the program for `sec` seconds.
- Using this function will affect `dt()`.

&#8202;

#### `sugar.time. freeze (sec)`
- Stops the program for `sec` seconds.
- Using this function will **not** affect `dt()`.

&#8202;

#### `sugar.time. fps ()`
- Returns the current averaged number of frames-per-second.
- This is affected by `set_frame_waiting(...)`.

&#8202;

#### `sugar.time. fps_raw ()`
- Returns the current raw number of frames-per-second.
- This is affected by `set_frame_waiting(...)`.

&#8202;

#### `sugar.time. frame_time ()`
- Returns the averaged time to complete one of the 16 last frames.
- This can be used to mesure performance. The lower frame time, the better performance.

&#8202;

#### `sugar.time. frame_time_raw ()`
- Returns the raw time to complete the last frame.

&#8202;

#### `sugar.time. sys_ltime ()`
- Get the system time in the local time zone.
- Returns, in this order:
  - seconds (`0 - 59`)
  - minutes (`0 - 59`)
  - hour (`0 - 23`)
  - day (`1 - 31`)
  - month (`1 - 12`)
  - year (full year)
  - week day (`1 - 7`)

&#8202;

#### `sugar.time. sys_gtime ()`
- Get the system time as UTC time.
- Returns, in this order:
  - seconds (`0 - 59`)
  - minutes (`0 - 59`)
  - hour (`0 - 23`)
  - day (`1 - 31`)
  - month (`1 - 12`)
  - year (full year)
  - week day (`1 - 7`)