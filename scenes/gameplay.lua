local Gameplay = {}

function Gameplay.init(state)
    state.particles = {}
    state.sats = {}
    state.enemies = {}
    state.bullets = {}
    state.panel = Panel.new()
end

function Gameplay.close(state)
    state.particles = {}
end

function Gameplay.update(dt, state)
    ParticleManager.update(dt)

    if input.mouse_pressed(input.MOUSE_LEFT) then
        local mx, my = input.mouse()
        -- local any_hit = false
        -- if not any_hit then
        --     local orbit = Orbits.closest(mx, my)
        --     if orbit == 1 then
        --         -- clicked on moon
        --     else
        --         local new_sat = Satellite.new(orbit)
        --         sfx.play(Sfx.CANCEL)
        --         table.insert(state.sats, new_sat)
        --     end
        -- end
        Panel.clicked(mx, my, state)
    end

    if input.pressed(input.BTN1) then

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

    -- Satellites
    for i = #state.sats, 1, -1 do
        local sat = state.sats[i]
        if sat.dead then
            table.remove(state.sats, i)
        end
    end
    for _, sat in ipairs(state.sats) do
        Satellite.update(dt, sat, state)
    end

    -- Bullets
    for i = #state.bullets, 1, -1 do
        local b = state.bullets[i]
        if b.dead then
            table.remove(state.bullets, i)
        end
    end
    for _, b in ipairs(state.bullets) do
        Bullet.update(dt, b, state)
    end

    -- Enemies
    for i = #state.enemies, 1, -1 do
        local e = state.enemies[i]
        if e.dead then
            table.remove(state.enemies, i)
        end
    end
    local living_enemies = 0
    for _, e in ipairs(state.enemies) do
        Enemy.update(dt, e, state)
        if not e.dead then
            living_enemies += 1
        end
    end
    if living_enemies < 1 then
        local new_enemy = Enemy.new()
        table.insert(state.enemies, new_enemy)
    end
end

function Gameplay.draw(state)
    local mx, my = input.mouse()
    local closest_orbit = Orbits.closest(mx, my)

    gfx.sspr(0, 48, 32, 32, CENTER_X - SIZE, CENTER_Y - SIZE)

    ParticleManager.draw()

    for i, radius in ipairs(Orbits.distances) do
        gfx.circ(CENTER_X, CENTER_Y, radius, gfx.COLOR_BLUE)
    end

    for _, sat in ipairs(state.sats) do
        Satellite.draw(sat)
    end

    for _, b in ipairs(state.bullets) do
        Bullet.draw(b)
    end

    for _, e in ipairs(state.enemies) do
        Enemy.draw(e)
    end

    Panel.draw(state.panel)

    if usagi.IS_DEV and state.show_debug then
        gfx.text("sats: " .. #State.sats, UI.padding, usagi.GAME_H - 18, gfx.COLOR_WHITE)
    end
end

return Gameplay
