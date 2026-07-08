local satellite = {}

satellite.SIZE = 4

function satellite.new(orbit)
    return {
        angle = math.random(0, 6),
        dead = false,
        orbit = orbit
    }
end

function satellite.update(dt, sat)
    sat.angle += 0.5 * dt
    if sat.angle > math.pi * 2 then
        sat.angle = 0
    end
end

function satellite.draw(sat)
    local cx = usagi.GAME_W / 2
    local cy = usagi.GAME_H / 2
    local radius = Orbits.distances[sat.orbit]
    local x = cx - (radius * math.cos(sat.angle))
    local y = cy - (radius * math.sin(sat.angle))
    --gfx.circ_fill(x, y, satellite.SIZE, gfx.COLOR_ORANGE)
    gfx.spr_ex(Spr.SAT, x, y, false, false, 0, 0, 1.0)
end

function satellite.get_pos(sat)
    local cx = usagi.GAME_W / 2
    local cy = usagi.GAME_H / 2
    local radius = Orbits.distances[sat.orbit]
    local x = cx - (radius * math.cos(sat.angle))
    local y = cy - (radius * math.sin(sat.angle))
    return x, y
end

return satellite
