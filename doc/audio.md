## `sugar. audio`

- Contents:
  - [`init_audio(sfx_vol, music_vol)`](#sugaraudio-init_audio-sfx_vol--1-music_vol--1)
  - [`shutdown_audio()`](#sugaraudio-shutdown_audio-)
  - [`load_sfx(file, id, volume)`](#sugaraudio-load_sfx-filepath-id-volume--1)
  - [`load_music(file, id, volume)`](#sugaraudio-load_music-file-id-volume--1)
  - [`sfx_volume(v)`](#sugaraudio-sfx_volume-v)
  - [`music_volume(v)`](#sugaraudio-music_volume-v)
  - [`unload_sfx(id)`](#sugaraudio-unload_sfx-id)
  - [`unload_music(id)`](#sugaraudio-unload_music-id)
  - [`sfx(id, distance, stereo_angle, pitch)`](#sugaraudio-sfx-id-distance--0-stereo_angle--0-pitch--1)
  - [`music(id, loop)`](#sugaraudio-music-id-loop)

&#8202;

Any volume value here is always between `0` and `1`.

&#8202;

#### `sugar.audio. init_audio ([sfx_vol = 1, music_vol = 1])`
- Initializes the audio subsystem of Sugar.
- Is called by `init_sugar(...)`.

&#8202;

#### `sugar.audio. shutdown_audio ()`
- Shuts down the audio subsystem.
- Is called by `shutdown_sugar()`.

&#8202;

#### `sugar.audio. load_sfx (filepath, [id], [volume = 1])`
- Loads the file at `filepath` as the sound effect `id`.
- If `id` isn't set, the next available numeral sfx id is used.
- `volume` will only be applied on this sound effect. It is multiplicative with `sfx_volume(v)`.
- Returns the sound effect's id.

&#8202;

#### `sugar.audio. load_music (file, [id], [volume = 1])`
- Loads the file at `filepath` as the music `id`.
- If `id` isn't set, the next available numeral music id is used.
- `volume` will only be applied on this music. It is multiplicative with `sfx_volume(v)`.
- Returns the music's id.

&#8202;

#### `sugar.audio. sfx_volume (v)`
- Sets the volume for sound effects. (`0 - 1`)

&#8202;

#### `sugar.audio. music_volume (v)`
- Sets the volume for music. (`0 - 1`)

&#8202;

#### `sugar.audio. unload_sfx (id)`
- Unloads the sound effect `id`.

&#8202;

#### `sugar.audio. unload_music (id)`
- Unloads the music `id`.

&#8202;

#### `sugar.audio. sfx (id, [distance = 0, [stereo_angle = 0]], [pitch = 1])`
- Plays the sound effect `id`.
- If `distance` is set, volume is decreased accordingly.
- If `setreo_angle` is set, the sound effect is directed accordingly in stereo. (`0` is center, `-0.25` is left, `0.25` is right)
- If `pitch` is set, the sound effect is pitched accordingly. `0.5` is down an octave, `2` is up an octave.

&#8202;

#### `sugar.audio. music ([id, [loop]])`
- Plays the music `id`.
- If `loop` is `true`, the music will start over after it ends.
- Call `music()` with no arguments to stop the playing music.