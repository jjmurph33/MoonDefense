local Gameover = {}

function Gameover.init(state)
end

function Gameover.close(state)
end

function Gameover.update(dt, state)
  if input.pressed(input.BTN1) or input.pressed(input.BTN2) then
    sfx.play(Sfx.CONFIRM)
    Scene.switch_to(state, Scene.MAIN_MENU)
  end
end

function Gameover.draw(state)
  gfx.clear(gfx.COLOR_BLACK)
  gfx.text("Game Over", UI.padding, UI.padding, gfx.COLOR_DARK_GREEN)
  local score = state.score
  gfx.text(string.format("Final Score: %d",score), UI.padding, UI.padding * 4, gfx.COLOR_DARK_GREEN)

  if math.floor(usagi.elapsed * 2) % 2 == 0 then
    gfx.text("Press " .. input.mapping_for(input.BTN1) .. " to return to Main Menu",
      UI.padding, usagi.GAME_H - 20, gfx.COLOR_DARK_GREEN)
  end
end

return Gameover
