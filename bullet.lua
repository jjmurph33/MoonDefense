local bullet = {}

bullet.SPEED = 100

function bullet.new(x, y, xvel, yvel, rotation, sprite, owner)
    return {
        x = x,
        y = y,
        xvel = xvel,
        yvel = yvel,
        rotation = rotation,
        sprite = sprite,
        dead = false,
        lifetime = 0,
        owner = owner,
    }
end

function bullet.update(dt, b)
    b.x += b.xvel * dt * bullet.SPEED
    b.y += b.yvel * dt * bullet.SPEED
    b.lifetime += dt

    if b.x == 0 and b.y == 0 then
        ParticleManager.explosion(b.x, b.y)
        sfx.play(Sfx.EXPLOSION)
        b.dead = true
    end

    if not util.point_in_rect({ x = b.x, y = b.y }, { x = 0, y = 0, w = usagi.GAME_W, h = usagi.GAME_H }) then
        if b.lifetime > 20 then
            b.dead = true
        end
    end
end

function bullet.draw(b)
    gfx.spr_ex(b.sprite, b.x, b.y, false, false, b.rotation, 0, 1.0)
end

return bullet
