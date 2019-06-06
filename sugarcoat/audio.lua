sugar = sugar or {}

require("sugarcoat/debug")
require("sugarcoat/utility")

local _sfx_map
local _music_map
local _sfx_volume
local _music_volume

local _music_playing = { mus = nil, volume = 1 }

local function init_audio(sfx_vol, music_vol)
  _sfx_map = {}
  _music_map = {}

  sfx_volume(sfx_vol or 1)
  music_volume(music_vol or 1)
  
  sugar.debug.log("Audio system initialized.");
end

local function shutdown_audio()
  _sfx_map = {}
  _music_map = {}

  sugar.debug.log("Audio system shut down.");
end


local function load_sfx(file, id, volume)
  local chnk = love.audio.newSource(file, "static")
  
  if id then
    if _sfx_map[id] then
      _sfx_map[id] = nil
    end
  else
    id = #_sfx_map + 1
  end
  
  local volume = sugar.maths.mid(volume or 1, 0, 1)
  
  chnk:setVolume(volume * _sfx_volume)
  
  _sfx_map[id] = {chnk = chnk, volume = volume}
  
  return id
end

local function load_music(file, id, volume)
  local mus = love.audio.newSource(file, "static")
  
  if id then
    if _music_map[id] then
      _music_map[id] = nil
    end
  else
    id = #_music_map + 1
  end
  
  local volume = sugar.maths.mid(volume or 1, 0, 1)
  
  mus:setVolume(volume * _sfx_volume)
  
  _music_map[id] = {mus = mus, volume = volume}
  
  return id
end


local function sfx_volume(v)
  if not v then return _sfx_volume end

  _sfx_volume = sugar.maths.mid(v, 0, 1)
  
  for _,s in pairs(_sfx_map) do
    s.chnk:setVolume( s.volume * _sfx_volume )
  end
end

local function music_volume(v)
  if not v then return _music_volume end
  
  _music_volume = sugar.maths.mid(v, 0, 1)

  local current = _music_playing
  if current.mus then
    current.mus:setVolume( current.volume * _music_volume )
  end
end


local function unload_sfx(id)
  if not _sfx_map[id] then
    sugar.debug.w_log("Tried to unload inexistant sfx.")
  end
  
  _sfx_map[id] = nil
end

local function unload_music(id)
  if not _music_map[id] then
    sugar.debug.w_log("Tried to unload inexistant sfx.")
  end
  
  _music_map[id] = nil
end


local function sfx(id, distance, stereo_angle, pitch)
  local s = _sfx_map[id]
  
  if not s then
    sugar.debug.w_log("Attempt to play inexistant sfx "..id..".")
    return
  end
  
  distance = distance or 0
  stereo_angle = stereo_angle or 0
  pitch = pitch or 1
  
  s.chnk:setPosition(distance * sugar.maths.cos(stereo_angle + 0.25), 0, 1)
  s.chnk:setPitch(pitch)
  
  if s.chnk:isPlaying() then
    s.chnk:seek(0)
  else
    s.chnk:play()
  end
end

local function music(id, loop)
  local s = _music_map[id]
  
  if not s then
    sugar.debug.w_log("Attempt to play inexistant music "..id..".")
    return
  end
  
  if _music_playing.mus then
    _music_playing.mus:stop()
  end
  
  s.mus:setVolume(s.volume * _music_volume)
  s.mus:setLooping(loop)

  love.audio.play(s.mus)
  _music_playing = s
end



sugar.audio = {
  init_audio     = init_audio,
  shutdown_audio = shutdown_audio,
  
  load_sfx       = load_sfx,
  load_music     = load_music,
  
  sfx_volume     = sfx_volume,
  music_volume   = music_volume,
  
  unload_sfx     = unload_sfx,
  unload_music   = unload_music,
  
  sfx            = sfx,
  music          = music,
}

sugar.S = sugar.S or {}
for k,v in pairs(sugar.audio) do
  sugar.S[k] = v
end

return sugar.audio