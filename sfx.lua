local Sfx = {}

Sfx.CONFIRM = "confirm"
Sfx.CANCEL = "cancel"
Sfx.EXPLOSION = "explosion"
Sfx.BUILD = "build"

function Sfx.play_rand_pitch(name, vol)
    vol = vol or 1.0
    sfx.play_ex(name, vol, 0.8 + math.random(0, 20) / 100, 0)
end

return Sfx
