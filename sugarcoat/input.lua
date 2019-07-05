sugar = sugar or {}

require("sugarcoat/debug")
require("sugarcoat/utility")

local _init = false
local _exit_required = false

local _players = {}
local _controllers = {}


local function init_input()
  if _init then return end
  
  love.keyboard.setKeyRepeat(true)
  love.keyboard.setTextInput(false)
  
  _controllers = {}
  for i, j in pairs(love.joystick.getJoysticks()) do
    _controllers[i] = j
  end
  sugar.debug.log(sugar.input.ctrlr_count().." game controllers were detected.")
  
  sugar.input.new_player()
  
  _init = true
  
  sugar.debug.log("Input system initialized.")
end

local function shutdown_input()
  _players = {}
  _controllers = {}

  _init = false
  sugar.debug.log("Input system shut down.")
end


local function exit_required()
  return _exit_required
end

local function require_exit()
  _exit_required = true
  love.event.push("quit")
end


local function new_player()
  local i
  if _players[0] then
    i = #_players + 1
  else
    i = 0
  end
  
  _players[i] = {
    buttons    = {},
    controller = nil
  }
  
  sugar.debug.log("Player "..i.." has been added.")
  
  return i
end



local input_type = {
  "keyboard",
  "keyboard_scancode",
  "mouse_position",
  "mouse_button",
  "controller_button",
  "controller_axis",
  "controller_hat",
  "controller_ball"
}

--local ctrlr_binded_button = love.joystick.GamepadButton
--local ctrlr_binded_axis = love.joystick.GamepadAxis
--local keyboard_key = KeyConstant
--local keyboard_scankey = love.keyboard.Scancode
--
--local mouse_btn = {
--  "lb",
--  "rb",
--  "mb",
--  "x1",
--  "x2",
--  "scroll_x",
--  "scroll_y"
--}
--
--local mouse_pos = {
--  "x",
--  "y",
--  "dx",
--  "dy"
--}


local function input_id(type, id)
  return {type = type, id = id}
end


local _event_inputs = {}
for _,i in pairs(input_type) do
  _event_inputs[i] = {}
end


local function _new_button(inputs, _player)
  local butt = {
    state = false,
    previous_state = false,
    value = 0,
    player = _player
  }
  
  for i,input in pairs(inputs) do
    local event_tab = (input.type ~= nil) and _event_inputs[input.type]
    if event_tab then
      event_tab[input.id] = event_tab[input.id] or {}
      add(event_tab[input.id], butt)
    else
      sugar.debug.w_log("Attempt to register input of inexistant type "..(input.type or "nil"))
      sugar.utility.del_at(inputs, i)
    end
  end
  
  butt.inputs = sugar.utility.copy_table(inputs)
  
  return butt
end

local function _delete_button(butt)
  local inputs = butt.inputs
  
  for i,input in pairs(inputs) do
    local event_tab = _event_inputs[input.type]
    sugar.utility.del(event_tab, butt)
  end

  butt.inputs = nil
end

local function register_btn(btn_id, player, inputs)
  local p = _players[player]
  if not p then
    sugar.debug.r_log("Attempt to register button for player "..player.." which doesn't exist.")
    return
  end
  
  local map = p.buttons
  
  if btn_id then
    if map[btn_id] then
      sugar.debug.w_log("Button '"..btn_id.."' already exists for player "..player..", overriding.")
      _delete_button(p.buttons[btn_id])
      p.buttons[btn_id] = nil
    end
  else
    btn_id = #map + 1
  end
  
  if inputs.type then
    inputs = {inputs}
  end
  
  p.buttons[btn_id] = _new_button(inputs, p)
  
  sugar.debug.log("Registered "..#inputs.." input for button "..btn_id.." on player "..player..".")
  
  return btn_id
end


--local function btn_get_inputs(btn_id, player)
--
--end


local function _get_button(id, player)
  local p
  if player then
    p = _players[player]
    if not p then
      sugar.debug.w_log("Player "..player.." doesn't exist.")
      return nil
    end
  else
    player = 0
    p = _players[0]
  end
  
  local butt = p.buttons[id]
  
  if not butt then
    sugar.debug.w_log("Button "..id.." for player "..player.." isn't registered.")
    return nil
  end
  
  return butt
end

local function btn(id, player)
  local butt = _get_button(id, player)
  
  return ((butt ~= nil) and butt.state)
end

local function btnp(id, player)
  local butt = _get_button(id, player)
  
  return ((butt ~= nil) and butt.state and not butt.previous_state)
end

local function btnr(id, player)
  local butt = _get_button(id, player)
  
  return ((butt ~= nil) and butt.previous_state and not butt.state)
end

local function btnv(id, player)
  local butt = _get_button(id, player)
  
  return ((butt == nil) and 0 or butt.value)
end


local function ctrlr_list()
  local list = {}
  
  for i,_ in pairs(_controllers) do
    add(list, i)
  end
  
  return list
end

local function ctrlr_count()
  local n = 0

  for _,_ in pairs(_controllers) do
    n = n + 1
  end
  
  return n
end

local function player_assign_ctrlr(player, controller)
  local p = _players[player]
  
  if not p then
    sugar.debug.r_log("Attempt to assign controller to inexistant player "..player..".")
    return
  end
  
  local ctrlr
  if controller then
    ctrlr = _controllers[controller]
    
    if not ctrlr then
      sugar.debug.w_log("Attempt to assign inexistant controller "..controller.." to player "..player..".")
    end
  end
  
  p.controller = ctrlr
end

local function ctrlr_has_default_bindings(controller)
  local ctrlr = _controllers[controller]
  
  if not ctrlr then
    sugar.debug.w_log("Attempt to check on bindings for inexistant controller "..controller..".")
    return false
  end
  
  return (ctrlr:getGamepadMapping(love.joystick.GamepadButton.a) ~= nil)
end

local function ctrlr_name(controller)
  local ctrlr = _controllers[controller]
  
  if not ctrlr then
    sugar.debug.w_log("Attempt to get the name of inexistant controller "..controller..".")
    return nil
  end
  
  return ctrlr:getName()
end



local events = require("sugarcoat/sugar_events")
local _D = require("sugarcoat/gfx_vault")

local function _button_press_state(type, key, state, controller)
  local butts = _event_inputs[type][key]
  if not butts then return end
  
  for _,butt in pairs(butts) do
    --if not controller or controller == butt.player.controller then
      butt.state = state
      butt.value = state and 1 or 0
    --end
  end
end

local function _button_value(type, key, value, controller)
  local butts = _event_inputs[type][key]
  if not butts then return end
  
  for _,butt in pairs(butts) do
    butt.state = (value ~= 0)
    butt.value = value
  end
end

local ev = {}
function ev.keypressed(key, scancode)
  _button_press_state("keyboard", key, true)
  _button_press_state("keyboard_scancode", scancode, true)
end

function ev.keyreleased(key, scancode)
  _button_press_state("keyboard", key, false)
  _button_press_state("keyboard_scancode", scancode, false)
end

function ev.mousemoved(x, y, dx, dy)
  _button_value("mouse_position", "x", (x - _D.screen_x) / _D.screen_sca_x)
  _button_value("mouse_position", "y", (y - _D.screen_y) / _D.screen_sca_y)
  _button_value("mouse_position", "dx", dx / _D.screen_sca_x)
  _button_value("mouse_position", "dy", dy / _D.screen_sca_y)
end

local _mouse_buttons = {"lb", "rb", "mb", "x1", "x2"}
function ev.mousepressed(x, y, b)
  if b < 6 then
    _button_press_state("mouse_button", _mouse_buttons[b], true)
  end
end

function ev.mousereleased(x, y, b)
  if b < 6 then
    _button_press_state("mouse_button", _mouse_buttons[b], false)
  end
end

local _scroll_id = 0
function ev.wheelmoved(x, y)
  _button_value("mouse_button", "scroll_x", x)
  _button_value("mouse_button", "scroll_y", y)
  _scroll_id = _scroll_id + 1
end

function ev.gamepadaxis(joystick, axis, value)
  local v = sugar.maths.sgn(value) * sugar.maths.mid((sugar.maths.abs(value) - 0.15) / 0.7, 0, 1)
  _button_value("controller_axis", axis, v, joystick)
end

function ev.gamepadpressed(joystick, button)
  _button_press_state("controller_button", button, true, joystick)
end

function ev.gamepadreleased(joystick, button)
  _button_press_state("controller_button", button, false, joystick)
end


function ev.joystickadded(joystick)
  sugar.utility.add(_controllers, joystick)
  sugar.debug.log("A new controller was detected!")
end

function ev.joystickremoved()
  sugar.utility.del(_controllers, joystick)
  sugar.debug.log("A controller was disconnected!")
end

local _oscroll_id = 0
local _ostate = {}
local function update_input()
  if _scroll_id == _oscroll_id then
    _button_value("mouse_button", "scroll_x", 0)
    _button_value("mouse_button", "scroll_y", 0)
  else
    _oscroll_id = _scroll_id
  end
  
  for i,p in pairs(_players) do
    local op = _ostate[i] or {}
    local np = {}
    for j,b in pairs(p.buttons) do
      b.previous_state = op[j]
      np[j] = b.state
    end
    _ostate[i] = np
  end
end

for k,e in pairs(ev) do
  love[k] = e
  events[k] = e
end


sugar.input = {
  init_input                 = init_input,
  update_input               = update_input,
  shutdown_input             = shutdown_input,
  
  exit_required              = exit_required,
  require_exit               = require_exit,
  
  new_player                 = new_player,
  
  input_type                 = input_type,
  
  input_id                   = input_id,
  register_btn               = register_btn,
  
  btn                        = btn,
  btnp                       = btnp,
  btnr                       = btnr,
  btnv                       = btnv,
  
  ctrlr_list                 = ctrlr_list,
  ctrlr_count                = ctrlr_count,
  player_assign_ctrlr        = player_assign_ctrlr,
  
  ctrlr_has_default_bindings = ctrlr_has_default_bindings,
  ctrlr_name                 = ctrlr_name
}

sugar.S = sugar.S or {}
for k,v in pairs(sugar.input) do
  sugar.S[k] = v
end

return sugar.input