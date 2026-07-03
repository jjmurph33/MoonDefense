local Gameplay = {}

function Gameplay.init(state)
    state.sats = {}
    state.particles = {}
end

function Gameplay.close(state)
    state.particles = {}
end

function Gameplay.update(dt, state)
    ParticleManager.update(dt)

    if input.mouse_pressed(input.MOUSE_LEFT) then
        local mx, my = input.mouse()
        local any_hit = false
        for _, sat in ipairs(state.sats) do
            local x, y = Satellite.get_pos(sat)
            if util.point_in_circ({ x = mx, y = my }, { x = x, y = y, r = Satellite.SIZE }) then
                ParticleManager.explosion(x, y)
                sfx.play(Sfx.EXPLOSION)
                sat.dead = true
                any_hit = true
            end
        end
        if not any_hit then
            local orbit = Orbits.closest(mx, my)
            if orbit == 1 then
                -- clicked on moon
            else
                local new_sat = Satellite.new(orbit)
                sfx.play(Sfx.CANCEL)
                table.insert(state.sats, new_sat)
            end
        end
    end

    if input.pressed(input.BTN1) then
        for _, sat in ipairs(state.sats) do
            local x, y = Satellite.get_pos(sat)
            ParticleManager.explosion(x, y)
            sfx.play(Sfx.EXPLOSION)
            sat.dead = true
        end
    end

    if input.pressed(input.BTN2) then
        sfx.play(Sfx.CANCEL)
        Scene.switch_to(state, Scene.MAIN_MENU)
    end

    if usagi.IS_DEV then
        if input.key_pressed(input.KEY_MINUS) then
            Gameplay.init(state)
        end
        if input.key_pressed(input.KEY_0) then
            state.show_debug = not state.show_debug
        end
    end

    for i = #state.sats, 1, -1 do
        local sat = state.sats[i]
        if sat.dead then
            table.remove(state.sats, i)
        end
    end

    for _, sat in ipairs(state.sats) do
        Satellite.update(dt, sat)
    end
end

function Gameplay.draw(state)
    local mx, my = input.mouse()
    local cx = usagi.GAME_W / 2
    local cy = usagi.GAME_H / 2

    local closest_orbit = Orbits.closest(mx, my)

    gfx.circ_fill(cx, cy, Orbits.distances[1], gfx.COLOR_DARK_GRAY)

    ParticleManager.draw()

    for i, radius in ipairs(Orbits.distances) do
        local color = gfx.COLOR_BLUE
        if i == closest_orbit then
            color = gfx.COLOR_GREEN
        end
        gfx.circ(cx, cy, radius, color)
    end

    for _, sat in ipairs(state.sats) do
        Satellite.draw(sat)
    end

    if usagi.IS_DEV and state.show_debug then
        gfx.text("sats: " .. #State.sats, UI.padding, usagi.GAME_H - 18, gfx.COLOR_WHITE)
    end
end

return Gameplay
