UI = require("ui")
Spr = require("spr")
Sfx = require("sfx")
Util = require("util")
Scene = require("scene")
ParticleManager = require("particle_manager")
Metadata = usagi.read_json("metadata.json")
Satellite = require("satellite")
Orbits = require("orbits")

function _config()
    -- @type Usagi.Config
    return {
        name = "Usagi Moon",
        game_id = "com.usagiengine.CHANGEME",
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
    if not State.paused then
        Scene.draw(State)
    end
end
