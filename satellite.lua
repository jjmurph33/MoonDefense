local satellite = {}

satellite.FIRE_RATE = 2 -- seconds between shots
satellite.MAX_HEALTH = 10

function satellite.new(sprite)
	local orbit = 0
	if sprite == Spr.SAT_SHIELD then
		orbit = 1
	elseif sprite == Spr.SAT_TURRET then
		orbit = 2
	elseif sprite == Spr.SAT_MISSLE then
		orbit = 3
	end
	return {
		x = 0,
		y = 0,
		rotation = 0,
		dead = false,
		sprite = sprite,
		orbit = orbit,
		angle = math.random(0, 6),
		fire_timer = 0,
		health = 10
	}
end

function satellite.update(dt, sat, state)
	sat.angle += 0.5 * dt
	if sat.angle > math.pi * 2 then
		sat.angle = 0
	end

	local radius = Orbits.distances[sat.orbit]
	sat.x = CENTER_X - (radius * math.cos(sat.angle)) - SIZE / 2
	sat.y = CENTER_Y - (radius * math.sin(sat.angle)) - SIZE / 2

	if sat.sprite == Spr.SAT_TURRET then
		Satellite.update_turret(dt, sat, state)
	elseif sat.sprite == Spr.SAT_MISSLE then
		Satellite.update_missle(dt, sat, state)
	end
end

function satellite.update_turret(dt, sat, state)
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
		local v = util.vec_normalize({ x = dx, y = dy })
		sat.rotation = math.atan(v.y, v.x)

		-- extra rotation for the turret sprite
		sat.rotation += math.pi / 2

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

function satellite.update_missle(dt, sat, state)
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
		local v = util.vec_normalize({ x = dx, y = dy })
		sat.rotation = math.atan(v.y, v.x)

		if sat.fire_timer > 0 then
			sat.fire_timer -= dt
		else
			local bullet = Bullet.new(sat.x, sat.y, v.x, v.y, sat.rotation, Spr.MISSILE_BLUE, PLAYER)
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
	gfx.spr_ex(sat.sprite, sat.x, sat.y, false, false, sat.rotation, 0, 1.0)

	local x = sat.x+1
	local w = SIZE-1
	local h = 2
	local y = sat.y-1-h
	local color = gfx.COLOR_WHITE
	gfx.rect_fill(x,y,w,h,color)
	if sat.health == satellite.MAX_HEALTH then
		color = gfx.COLOR_GREEN
	else
	    color = gfx.COLOR_RED
		local ratio = satellite.MAX_HEALTH / sat.health
		w /= ratio
	end
	gfx.rect_fill(x,y,w,h,color)

	if sat.sprite == Spr.SAT_SHIELD then
		x = sat.x + SIZE / 2
		y = sat.y + SIZE / 2
		local dx = CENTER_X - x
		local dy = CENTER_Y - y
		local v = util.vec_normalize({ x = dx, y = dy })
		local rotation = math.atan(v.y, v.x)
		x -= SIZE / 2 - (SIZE * v.x)
		y -= SIZE / 2 - (SIZE * v.y)
		gfx.spr_ex(Spr.BEAM_SHIELD, x, y, false, false, rotation, 0, 0.75)
	end
end

function satellite.hit(s,damage)
    s.health -= damage
    if s.health <= 0 then
        ParticleManager.explosion(s.x, s.y,5)
        sfx.play(Sfx.DESTROY)
        s.dead = true
    else
        ParticleManager.explosion(s.x, s.y,1)
        sfx.play(Sfx.EXPLOSION)
    end
end

return satellite
