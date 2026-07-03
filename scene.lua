local Scene = {}

Scene.MAIN_MENU = "main_menu"
Scene.GAMEPLAY = "gameplay"
Scene.PLAYGROUND = "playground"
Scene.CREDITS = "credits"

local scenes = {
  [Scene.MAIN_MENU] = require("scenes.main_menu"),
  [Scene.GAMEPLAY] = require("scenes.gameplay"),
  [Scene.PLAYGROUND] = require("scenes.playground"),
  [Scene.CREDITS] = require("scenes.credits"),
}

function Scene.switch_to(state, key)
  state.pending_scene = key
end

local function scene_for(key)
  local scene = scenes[key]
  if scene == nil then
    error("unkown scene: " .. key)
  end
  return scene
end

function Scene.update(dt, state)
  if state.pending_scene then
    if state.current_scene then
      scene_for(state.current_scene).close(state)
    end
    state.current_scene = state.pending_scene
    scene_for(state.current_scene).init(state)
    state.pending_scene = nil
  end

  scene_for(state.current_scene).update(dt, state)
end

function Scene.draw(state)
  scene_for(state.current_scene).draw(state)
end

return Scene
