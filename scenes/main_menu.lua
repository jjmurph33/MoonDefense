local MainMenu = {}

local MOON_X = 200
local MOON_Y = 200

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
    state.sats = {}
    table.insert(state.sats, Satellite.new(Spr.SAT_TURRET))
end

function MainMenu.close(state)
    state.current_option = nil
    state.sats = {}
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

    local sat = state.sats[1]
   	sat.angle += 0.5 * dt
	if sat.angle > math.pi * 2 then
		sat.angle = 0
	end
	local radius = Orbits.distances[sat.orbit]
	sat.x = MOON_X - (radius * math.cos(sat.angle)) - SIZE / 2
	sat.y = MOON_Y - (radius * math.sin(sat.angle)) - SIZE / 2
	sat.rotation += 1 * dt
    if sat.rotation > math.pi * 2 then
    	sat.rotation = 0
    end
end

function MainMenu.draw(state)
    gfx.clear(gfx.COLOR_BLACK)
    gfx.text("Moon Defense", UI.padding, UI.padding, gfx.COLOR_DARK_GREEN)

    gfx.text("Confirm: " .. input.mapping_for(input.BTN1) .. "", UI.padding, usagi.GAME_H - UI.padding * 3,
        gfx.COLOR_DARK_GREEN)

    for i, opt in ipairs(options) do
        local y = 60 + i * 16
        if i == state.current_option then
            gfx.circ_fill(UI.padding * 2 + 4 + math.cos(usagi.elapsed * 8), y + 7, 3, gfx.COLOR_LIGHT_GRAY)
        end
        gfx.text(opt, UI.padding * 4, y, gfx.COLOR_DARK_GREEN)
    end

    local ver = Metadata.version
    local ver_w, ver_h = usagi.measure_text(ver)
    gfx.text(ver, usagi.GAME_W - ver_w - UI.padding,
        usagi.GAME_H - ver_h - UI.padding, gfx.COLOR_DARK_GREEN)

    local x = MOON_X - SIZE * 2
    local y = MOON_Y - SIZE * 2
    local scale = 4
    gfx.sspr_ex(0, 48, 32, 32, x, y,SIZE*scale,SIZE*scale,false, false, 0, 0, 1)

    local sat = state.sats[1]
    Satellite.draw(sat)
end

return MainMenu
