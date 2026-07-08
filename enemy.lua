local enemy = {}

function enemy.new(x,y)
    return {
        x = x,
        y = y,
        xvel = 10,
        yvel = 0,
        dead = false,
    }
end

function enemy.update(dt, enemy)
    enemy.x += enemy.xvel * dt
end

function enemy.draw(enemy)
    gfx.spr_ex(Spr.UFO, enemy.x, enemy.y, false, false, 0, 0, 1.0)
end

return enemy
