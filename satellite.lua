local satellite = {}

satellite.FIRE_RATE = 2 -- seconds between shots

function satellite.new(orbit)
    return {
        x = 0,
        y = 0,
        rotation = 0,
        dead = false,
        orbit = orbit,
        angle = math.random(0, 6),
        fire_timer = 0,
    }
end

function satellite.update(dt, sat, state)
    sat.angle += 0.5 * dt
    if sat.angle > math.pi * 2 then
        sat.angle = 0
    end

    local radius = Orbits.distances[sat.orbit]
    sat.x = CENTER_X - (radius * math.cos(sat.angle)) - HALF_SIZE
    sat.y = CENTER_Y - (radius * math.sin(sat.angle)) - HALF_SIZE

    local closest_distance = 50000
    local closest_index = 0
    for i, e in ipairs(state.enemies) do
        if not e.dead then
            local distance = util.vec_dist_sq({ x = sat.x, y = sat.y }, { x = e.x, y = e.y })
            if distance < closest_distance then
                closest_index = i
                closest_distance = distance
            end
        end
    end

    if closest_index > 0 then
        local enemy = state.enemies[closest_index]
        local dx = enemy.x - sat.x
        local dy = enemy.y - sat.y
        local v = util.vec_normalize { x = dx, y = dy }
        sat.rotation = math.atan(v.y, v.x) + math.pi / 2

        if sat.fire_timer > 0 then
            sat.fire_timer -= dt
        else
            local bullet = Bullet.new(sat.x, sat.y, v.x, v.y, sat.rotation, Spr.BULLET_BLUE, PLAYER)
            table.insert(state.bullets, bullet)
            sat.fire_timer = satellite.FIRE_RATE
        end
    else
        sat.rotation += 0.5 * dt
    end
    if sat.rotation > math.pi * 2 then
        sat.rotation = 0
    end
end

function satellite.draw(sat)
    gfx.spr_ex(Spr.SAT1, sat.x, sat.y, false, false, sat.rotation, 0, 1.0)
end

return satellite
