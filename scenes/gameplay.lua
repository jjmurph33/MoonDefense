local Gameplay = {}

function Gameplay.init(state)
    state.particles = {}
    state.sats = {}
    state.enemies = {}
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
            if util.point_in_circ({ x = mx, y = my }, { x = x, y = y, r = HALF_SIZE }) then
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
        Satellite.update(dt, sat, state)
    end


    for i = #state.enemies, 1, -1 do
        local e = state.enemies[i]
        if e.dead then
            table.remove(state.enemies, i)
        end
    end

    local living_enemies = 0
    for _, e in ipairs(state.enemies) do
        Enemy.update(dt, e)
        if not e.dead then
            living_enemies += 1
        end
    end
    if living_enemies < 5 then
        local new_enemy = Enemy.new()
        table.insert(state.enemies, new_enemy)
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

    for _, e in ipairs(state.enemies) do
        Enemy.draw(e)
    end

    if usagi.IS_DEV and state.show_debug then
        gfx.text("sats: " .. #State.sats, UI.padding, usagi.GAME_H - 18, gfx.COLOR_WHITE)
    end
end

return Gameplay
