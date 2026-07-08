local enemy = {}

enemy.SPEED = 50

function enemy.new()
    local angle = math.random(0, 6)
    local v = util.vec_from_angle(angle)
    local distance = 500
    local dx = v.x * distance
    local dy = v.y * distance
    return {
        x = CENTER_X - dx - HALF_SIZE,
        y = CENTER_Y - dy - HALF_SIZE,
        xvel = v.x,
        yvel = v.y,
        rotation = math.atan(v.y, v.x),
        dead = false,
        lifetime = 0,
        sprite = math.random(Spr.SHIP1, Spr.SHIP3)
    }
end

function enemy.update(dt, e)
    e.x += e.xvel * dt * enemy.SPEED
    e.y += e.yvel * dt * enemy.SPEED
    e.lifetime += dt

    if not util.point_in_rect({ x = e.x, y = e.y }, { x = 0, y = 0, w = usagi.GAME_W, h = usagi.GAME_H }) then
        if e.lifetime > 20 then
            e.dead = true
        end
    end
end

function enemy.draw(e)
    gfx.spr_ex(e.sprite, e.x, e.y, false, false, e.rotation, 0, 1.0)
end

return enemy
