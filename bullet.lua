local bullet = {}

bullet.SPEED = 100
bullet.DAMAGE = 5

function bullet.new(x, y, xvel, yvel, rotation, sprite, owner)
    local damage = bullet.DAMAGE
    if sprite == Spr.MISSILE_BLUE or sprite == Spr.MISSILE_RED then
        damage *= 2
    end
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
        damage = damage,
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
                    Enemy.hit(e,b.damage)
                end
            end
        else
            if util.point_in_circ(pos, { x = CENTER_X, y = CENTER_Y, r = 1 }) then
                -- hit the moon
                if state.sat_counts[Spr.SAT_SHIELD] == 0 then
                    sfx.play(Sfx.EXPLOSION)
                    state.health -= b.damage
                else
                    -- moon is shielded
                    sfx.play(Sfx.SHIELD_HIT)
                end
                ParticleManager.explosion(pos.x, pos.y,1)
                b.dead = true
            else
                for _, s in ipairs(state.sats) do
                    if util.point_in_rect(pos, { x = s.x, y = s.y, w = SIZE, h = SIZE }) then
                        Satellite.hit(s,b.damage)
                    end
                end
            end
        end
    else
       b.dead = true
    end

    if not b.dead then
        if b.sprite == Spr.MISSILE_BLUE or b.sprite == Spr.MISSILE_RED then
            bullet.update_missle(b,state)
        end
    end
end

function bullet.update_missle(b,state)
    local closest_distance = 50000
    local closest_index = 0
    for i, e in ipairs(state.enemies) do
        if not e.dead then
            local distance = util.vec_dist_sq({ x = b.x, y = b.y }, { x = e.x, y = e.y })
            if distance < closest_distance then
                closest_index = i
                closest_distance = distance
            end
        end
    end
    if closest_index > 0 then
        local enemy = state.enemies[closest_index]
        local dx = enemy.x - b.x
        local dy = enemy.y - b.y
        local v = util.vec_normalize { x = dx, y = dy }
        b.rotation = math.atan(v.y, v.x)
    end
end

function bullet.draw(b)
    gfx.spr_ex(b.sprite, b.x, b.y, false, false, b.rotation, 0, 1.0)
end

return bullet
