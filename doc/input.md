## `sugar. input`

Contents:
- [`init_input()`](#sugarinput-init_input-)
- [`update_input()`](#sugarinput-update_input-)
- [`shutdown_input()`](#sugarinput-shutdown_input-)
- [`exit_required()`](#sugarinput-exit_required-)
- [`require_exit()`](#sugarinput-require_exit-)
- [`new_player()`](#sugarinput-new_player-)
- [`input_type`](#sugarinput-input_type)
- [`input_id(type, id)`](#sugarinput-input_id-type-id)
- [`register_btn(btn_id, player, inputs)`](#sugarinput-register_btn-btn_id-player-inputs)
- [`btn(id, player)`](#sugarinput-btn-id-player--0)
- [`btnp(id, player)`](#sugarinput-btnp-id-player--0)
- [`btnr(id, player)`](#sugarinput-btnr-id-player--0)
- [`btnv(id, player)`](#sugarinput-btnv-id-player--0)
- [`ctrlr_list()`](#sugarinput-ctrlr_list-)
- [`ctrlr_count()`](#sugarinput-ctrlr_count-)
- [`player_assign_ctrlr(player, controller)`](#sugarinput-player_assign_ctrlr-player-controller)
- [`ctrlr_has_default_bindings(controller)`](#sugarinput-ctrlr_has_default_bindings-controller)
- [`ctrlr_name(controller)`](#sugarinput-ctrlr_name-controller)

&#8202;

#### `sugar.input. init_input ()`
- Initializes the input subsystem of Sugar.
- Is called by `init_sugar(...)`.

&#8202;

#### `sugar.input. update_input ()`
- Updates the input subsystem.
- Is automatically called around love.update().
- Should be called once every frame.

&#8202;

#### `sugar.input. shutdown_input ()`
- Shuts down the input subsystem.
- Is called be `shutdown_sugar()`.

&#8202;

#### `sugar.input. exit_required ()`
- Returns whether the user has required the program to shut down.

&#8202;

#### `sugar.input. require_exit ()`
- Shuts down the program.

&#8202;

---

#### `sugar.input. new_player ()`
- Creates a new player to register and check buttons for.
- Returns the index of the created player.
- Player 0 is created on `init_sugar()`.

&#8202;

#### `sugar.input. input_type`
- A table containing the available input types.
- Here are the input types and their corresponding available input ids:
  - `"keyboard"`
    - [Same as the Love2D KeyConstants.](https://love2d.org/wiki/KeyConstant)
  - `"keyboard_scancode"`
    - [Same as the Love2D Scancodes.](https://love2d.org/wiki/Scancode)
    - _(Scancodes indicate the position of a key rather than the key's function - The scancode `q` corresponds to the `a` key on an azerty keyboard)_
  - `"mouse_position"`
    - `"x"`
    - `"y"`
    - `"dx"` _(horizontal movement since the last frame)_
    - `"dy"` _(vertical movement since the last frame)_
  - `"mouse_button"`
    - `"lb"`
    - `"rb"`
    - `"mb"`
    - `"x1"`
    - `"x2"`
    - `"scroll_x"`
    - `"scroll_y"`
  - `"controller_button"`
    - `"a"`
    - `"b"`
    - `"x"`
    - `"y"`
    - `"back"`
    - `"guide"`
    - `"start"`
    - `"leftstick"`
    - `"rightstick"`
    - `"leftshoulder"`
    - `"rightshoulder"`
    - `"dpup"` _(D-pad up)_
    - `"dpdown"` _(D-pad down)_
    - `"dpleft"` _(D-pad left)_
    - `"dpright"` _(D-pad right)_
  - `"controller_axis"`
    - `"leftx"`
    - `"lefty"`
    - `"rightx"`
    - `"righty"`
    - `"triggerleft"`
    - `"triggerright"`

&#8202;

#### `sugar.input. input_id (type, id)`
- Returns a formated table for the given input type and input id.
- You should use this function to format input data before passing it to `register_btn(...)`

&#8202;

#### `sugar.input. register_btn (btn_id, player, input_or_inputs)`
- Registers the button `btn_id` for the player `player`, binding it to the given `input_or_inputs`.
- `input_or_inputs` may be a single input, e.g:
```lua
register_btn("left", 0, input_id("keyboard", "left"))
```
- or it maybe a table of inputs, e.g:
```lua
register_btn("left", 0, {input_id("keyboard", "left"),
                         input_id("keyboard", "a"),
                         input_id("controller_button", "dpleft"),
                         input_id("controller_axis", "leftx")})
```

&#8202;

#### `sugar.input. btn (id, [player = 0])`
- Returns the state (`true`/`false`) of the button `id` for that `player`.

&#8202;

#### `sugar.input. btnp (id, [player = 0])`
- "btnp" is short for "button press".
- Returns whether the button `id` for that `player` is pressed but wasn't during the previous frame.

&#8202;

#### `sugar.input. btnr (id, [player = 0])`
- "btnr" is short for "button release".
- Returns whether the button `id` for that `player` was pressed the previous frame but isn't anymore.

&#8202;

#### `sugar.input. btnv (id, [player = 0])`
- "btnv" is short for "button value".
- Returns a decimal number representing the state of the button.
- Particularly useful for controller axes and mouse position.
- Simple buttons (keyboard keys, controller buttons, etc) will return 1 when pressed and 0 when not.

&#8202;

---

#### `sugar.input. ctrlr_list ()`
- Returns a list of available controller ids.

&#8202;

#### `sugar.input. ctrlr_count ()`
- Returns the number of controllers currently available.

&#8202;

#### `sugar.input. player_assign_ctrlr (player, controller)`
- Assigns that `controller` to this `player`.
- `controller` should be an id from `ctrlr_list()`.
- Buttons assigned to this `player` will use that `controller` for checking on controller inputs.

&#8202;

#### `sugar.input. ctrlr_has_default_bindings (controller)`
- Returns whether this controller has default bindings, allowing you to use the known input ids with it.
- If this returns false, you won't be able to use that controller with the current version of Sugarcoat, sorry. :(
- `controller` should be an id from `ctrlr_list()`.

&#8202;

#### `sugar.input. ctrlr_name (controller)`
- Returns the name of that `controller` as a string.
- `controller` should be an id from `ctrlr_list()`.