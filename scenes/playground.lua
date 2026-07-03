-- Scene to experiment in
local Playground = {}

function Playground.init(state)
  state.particles = {}
end

function Playground.close(state)
  state.particles = nil
end

function Playground.update(dt, state)
  ParticleManager.update(dt)

  if input.mouse_pressed(input.MOUSE_LEFT) then
    local mx, my = input.mouse()
    ParticleManager.spawn(
      mx, my, {
        num = 12,
        colors = { gfx.COLOR_YELLOW, gfx.COLOR_RED, gfx.COLOR_ORANGE, gfx.COLOR_PEACH },
        speed_range = { 60, 90 },
        angle_range = { 0, 360 },
        lifetime_range = { 0.2, 0.8 },
        radius_range = { 6, 12 },
      })
  end
end

function Playground.draw(state)
  gfx.clear(gfx.COLOR_WHITE)
  gfx.text("playground", 10, 10, gfx.COLOR_BLACK)
  ParticleManager.draw()
end

return Playground
