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

function bullet.update(dt, b, state)
    b.x += b.xvel * dt * bullet.SPEED
    b.y += b.yvel * dt * bullet.SPEED
    b.lifetime += dt

    local pos = { x = b.x + SIZE / 2, y = b.y + SIZE / 2 }

    if util.point_in_rect(pos, { x = 0, y = 0, w = usagi.GAME_W, h = usagi.GAME_H }) then
        if b.owner == PLAYER then
            for _, e in ipairs(state.enemies) do
                if util.point_in_rect(pos, { x = e.x, y = e.y, w = SIZE, h = SIZE }) then
                    ParticleManager.explosion(pos.x, pos.y)
                    sfx.play(Sfx.EXPLOSION)
                    b.dead = true
                    e.dead = true
                end
            end
        else
            if util.point_in_circ(pos, { x = CENTER_X, y = CENTER_Y, r = 1 }) then
                ParticleManager.explosion(pos.x, pos.y)
                sfx.play(Sfx.EXPLOSION)
                b.dead = true
            else
                for _, s in ipairs(state.sats) do
                    if util.point_in_rect(pos, { x = s.x, y = s.y, w = SIZE, h = SIZE }) then
                        ParticleManager.explosion(b.x, b.y)
                        sfx.play(Sfx.EXPLOSION)
                        b.dead = true
                        s.dead = true
                    end
                end
            end
        end
    else
        if b.lifetime > 20 then
            b.dead = true
        end
    end
end

function bullet.draw(b)
    gfx.spr_ex(b.sprite, b.x, b.y, false, false, b.rotation, 0, 1.0)
end

return bullet
