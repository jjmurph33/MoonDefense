UI = require("ui")
Spr = require("spr")
Sfx = require("sfx")
Util = require("util")
Scene = require("scene")
ParticleManager = require("particle_manager")
Metadata = usagi.read_json("metadata.json")
Satellite = require("satellite")
Orbits = require("orbits")
Enemy = require("enemy")
Bullet = require("bullet")



WINDOW_WIDTH = 640
WINDOW_HEIGHT = 360
CENTER_X = WINDOW_WIDTH / 2
CENTER_Y = WINDOW_HEIGHT / 2
SIZE = 16
HALF_SIZE = SIZE / 2
PLAYER = 0
ENEMY = 1

function _config()
    -- @type Usagi.Config
    return {
        name = "Moon Defense",
        game_id = "com.usagiengine.CHANGEME",
        game_width = WINDOW_WIDTH,
        game_height = WINDOW_HEIGHT,
    }
end

function _init()
    print("init: v" .. Metadata.version)
    State = {
        show_debug = false,
        paused = false,
        particles = {}
    }

    Scene.switch_to(State, Scene.GAMEPLAY)
end

function _update(dt)
    if usagi.IS_DEV then
        if input.key_pressed(input.KEY_SPACE) then
            State.paused = not State.paused
        end
    end
    if not State.paused then
        Scene.update(dt, State)
    end

    if usagi.IS_DEV then
        if input.key_pressed(input.KEY_2) then
            Scene.switch_to(State, Scene.PLAYGROUND)
        end
    end
end

function _draw(_dt)
    gfx.clear(gfx.COLOR_BLACK)
    --if not State.paused then
    Scene.draw(State)
    --end
end
