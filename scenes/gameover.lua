local Gameover = {}

function Gameover.init(state)
end

function Gameover.close(state)
end

function Gameover.update(dt, state)
    if input.pressed(input.BTN1) or input.pressed(input.BTN2) or input.mouse_pressed(input.MOUSE_LEFT) then
        sfx.play(Sfx.CONFIRM)
        Scene.switch_to(state, Scene.MAIN_MENU)
    end
end

function Gameover.draw(state)
  gfx.clear(gfx.COLOR_BLACK)

  -- background
  gfx.rect_fill(0,0,usagi.GAME_W,usagi.GAME_H,gfx.COLOR_DARK_BLUE,0.05)

  gfx.text("Game Over", CENTER_X+UI.padding*2, CENTER_Y- UI.padding*2, gfx.COLOR_DARK_GREEN)
  gfx.text(string.format("Final Score: %d",state.score), CENTER_X, CENTER_Y, gfx.COLOR_DARK_GREEN)

  if math.floor(usagi.elapsed * 2) % 2 == 0 then
    gfx.text("Press " .. input.mapping_for(input.BTN1) .. " to return to Main Menu",
      UI.padding, usagi.GAME_H - 20, gfx.COLOR_DARK_GREEN)
  end
end

return Gameover
