local orbits = {}

orbits.distances = { 20, 40, 60, 80 }

function orbits.draw(sat)
    gfx.rect_fill(sat.x, sat.y, Satellite.SIZE, Satellite.SIZE, gfx.COLOR_ORANGE)
end

function orbits.closest(x, y)
    local cx = usagi.GAME_W / 2
    local cy = usagi.GAME_H / 2
    local padding = 5
    for i, radius in ipairs(orbits.distances) do
        local circle = { x = cx, y = cy, r = radius + padding }
        if util.point_in_circ({ x = x, y = y }, circle) then
            return i
        end
    end
    return #orbits.distances
end

return orbits
