local enemy = {}

enemy.SPEED = 50
enemy.FIRE_RATE = 3 -- seconds between shots
enemy.RANGE = 200

function enemy.new()
    local angle = math.random(0, 6)
    local v = util.vec_from_angle(angle)
    local distance = 300
    local dx = v.x * distance
    local dy = v.y * distance
    return {
        x = CENTER_X - dx - SIZE / 2,
        y = CENTER_Y - dy - SIZE / 2,
        xvel = v.x,
        yvel = v.y,
        rotation = math.atan(v.y, v.x),
        dead = false,
        lifetime = 0,
        sprite = math.random(Spr.SHIP1, Spr.SHIP3),
        fire_timer = 0,
    }
end

function enemy.update(dt, e, state)
    e.x += e.xvel * dt * enemy.SPEED
    e.y += e.yvel * dt * enemy.SPEED
    e.lifetime += dt

    local dx = CENTER_X - e.x
    local dy = CENTER_Y - e.y
    local v = util.vec_normalize { x = dx, y = dy }
    local distance_to_center = util.vec_dist({ x = e.x, y = e.y }, { x = CENTER_X, y = CENTER_Y })
    local angle_to_center = math.atan(v.y, v.x)
    local spread = 1
    if distance_to_center < enemy.RANGE then
        if angle_to_center - spread <= e.rotation and angle_to_center + spread >= e.rotation then
            if e.fire_timer > 0 then
                e.fire_timer -= dt
            else
                local bullet = Bullet.new(e.x, e.y, e.xvel, e.yvel, e.rotation, Spr.BULLET_RED, ENEMY)
                table.insert(state.bullets, bullet)
                e.fire_timer = enemy.FIRE_RATE
            end
        end
    end

    if distance_to_center > 500 then
        e.dead = true
    end
end

function enemy.draw(e)
    gfx.spr_ex(e.sprite, e.x, e.y, false, false, e.rotation, 0, 1.0)
end

return enemy
