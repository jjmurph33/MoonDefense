local MainMenu = {}

local OPTION = {
    PLAY = "Play",
    CREDITS = "Credits",
    QUIT = "Quit",
}
local options = {
    OPTION.PLAY,
    OPTION.CREDITS,
}
if usagi.PLATFORM ~= "web" then
    table.insert(options, OPTION.QUIT)
end

function MainMenu.init(state)
    state.current_option = 1
end

function MainMenu.close(state)
    state.current_option = nil
end

function MainMenu.update(dt, state)
    if input.pressed(input.UP) then
        state.current_option -= 1
        if state.current_option < 1 then
            state.current_option = #options
        end
    end
    if input.pressed(input.DOWN) then
        state.current_option += 1
        if state.current_option > #options then
            state.current_option = 1
        end
    end

    if input.pressed(input.BTN1) then
        sfx.play(Sfx.CONFIRM)
        local opt = options[state.current_option]
        if opt == OPTION.PLAY then
            Scene.switch_to(state, Scene.GAMEPLAY)
        elseif opt == OPTION.CREDITS then
            Scene.switch_to(state, Scene.CREDITS)
        elseif opt == OPTION.QUIT then
            usagi.quit()
        else
            error("Unrecognized main menu option: " .. opt)
        end
    end
end

function MainMenu.draw(state)
    gfx.clear(gfx.COLOR_WHITE)
    gfx.text("YOUR GAME", UI.padding, UI.padding, gfx.COLOR_BLACK)

    gfx.text("Confirm: " .. input.mapping_for(input.BTN1) .. "", UI.padding, usagi.GAME_H - UI.padding * 3,
        gfx.COLOR_BLACK)

    for i, opt in ipairs(options) do
        local y = 60 + i * 16
        if i == state.current_option then
            gfx.circ_fill(UI.padding * 2 + 4 + math.cos(usagi.elapsed * 8), y + 7, 3, gfx.COLOR_BLACK)
        end
        gfx.text(opt, UI.padding * 4, y, gfx.COLOR_BLACK)
    end

    local ver = Metadata.version
    local ver_w, ver_h = usagi.measure_text(ver)
    gfx.text(ver, usagi.GAME_W - ver_w - UI.padding,
        usagi.GAME_H - ver_h - UI.padding, gfx.COLOR_BLACK)
end

return MainMenu
