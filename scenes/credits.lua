local Credits = {}

function Credits.init(state)
end

function Credits.close(state)
end

function Credits.update(dt, state)
  if input.pressed(input.BTN1) or input.pressed(input.BTN2) then
    sfx.play(Sfx.CONFIRM)
    Scene.switch_to(state, Scene.MAIN_MENU)
  end
end

function Credits.draw(state)
  gfx.clear(gfx.COLOR_PEACH)
  gfx.text("CREDITS", UI.padding, UI.padding, gfx.COLOR_BLACK)
  gfx.text("Game by YOUR NAME", UI.padding, UI.padding * 4, gfx.COLOR_BLACK)
  gfx.text("Made with USAGI ENGINE", UI.padding, UI.padding * 8, gfx.COLOR_BLACK)

  if math.floor(usagi.elapsed * 2) % 2 == 0 then
    gfx.text("Press " .. input.mapping_for(input.BTN1) .. " to return to Main Menu",
      UI.padding, usagi.GAME_H - 20, gfx.COLOR_BLACK)
  end
end

return Credits
