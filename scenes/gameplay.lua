local Gameplay = {}

function Gameplay.init(state)
	state.particles = {}
	state.sats = {}
	state.enemies = {}
	state.bullets = {}
	state.score = 0
	state.lifetime = 0
	state.health = 10
	state.spawn_timer = 0
	state.panel = Panel.new()
	state.sat_counts = {}
	state.sat_counts[Spr.SAT_SHIELD]=0
	state.sat_counts[Spr.SAT_TURRET]=0
	state.sat_counts[Spr.SAT_MISSLE]=0
end

function Gameplay.close(state)
	state.particles = {}
end

function Gameplay.update(dt, state)
    state.lifetime += dt

	ParticleManager.update(dt)

	if input.mouse_pressed(input.MOUSE_LEFT) then
		local mx, my = input.mouse()
		Panel.clicked(mx, my, state)
	end

	if input.pressed(input.BTN1) then
	end

	if input.pressed(input.BTN2) then
		sfx.play(Sfx.CANCEL)
		Scene.switch_to(state, Scene.MAIN_MENU)
	end

	if usagi.IS_DEV then
		if input.key_pressed(input.KEY_MINUS) then
			Gameplay.init(state)
		end
		if input.key_pressed(input.KEY_0) then
			state.show_debug = not state.show_debug
		end
	end

	-- Satellites
	for i = #state.sats, 1, -1 do
		local sat = state.sats[i]
		if sat.dead then
			table.remove(state.sats, i)
			state.sat_counts[sat.sprite] -= 1
		end
	end
	for _, sat in ipairs(state.sats) do
		Satellite.update(dt, sat, state)
	end

	-- Bullets
	for i = #state.bullets, 1, -1 do
		local b = state.bullets[i]
		if b.dead then
			table.remove(state.bullets, i)
		end
	end
	for _, b in ipairs(state.bullets) do
		Bullet.update(dt, b, state)
	end

	-- Enemies
	for i = #state.enemies, 1, -1 do
		local e = state.enemies[i]
		if e.dead then
			table.remove(state.enemies, i)
		end
	end
	local living_enemies = 0
	for _, e in ipairs(state.enemies) do
		Enemy.update(dt, e, state)
		if not e.dead then
			living_enemies += 1
		end
	end

	if state.lifetime - state.spawn_timer > 1 then
	    state.spawn_timer = state.lifetime
        table.insert(state.enemies, Enemy.new())
	end

	if state.health <= 0 then
	    print("game over")
		effect.flash(0.5, gfx.COLOR_RED)
		effect.screen_shake(0.5, 2)
		Scene.switch_to(state, Scene.GAMEOVER)
	end
end

function Gameplay.draw(state)
	-- for i, radius in ipairs(Orbits.distances) do
	-- 	gfx.circ(CENTER_X, CENTER_Y, radius, gfx.COLOR_BLUE)
	-- end

	-- draw the moon
	gfx.sspr(0, 48, 32, 32, CENTER_X - SIZE, CENTER_Y - SIZE)

	if state.sat_counts[Spr.SAT_SHIELD] > 0 then
		-- draw shield around the moon
		gfx.sspr_ex(32, 48, 32, 32, CENTER_X - SIZE, CENTER_Y - SIZE, SIZE * 2, SIZE * 2, false, false, 0, 0, 0.5)
	end

	-- draw moon's health bar
	local x = CENTER_X - SIZE + 2
	local w = SIZE*2 - 5
	local h = 2
	local y = CENTER_Y - SIZE - 1 - h
	local color = gfx.COLOR_WHITE
	gfx.rect_fill(x,y,w,h,color)
	if state.health == 100 then
		color = gfx.COLOR_GREEN
	else
	    color = gfx.COLOR_RED
		local ratio = 100 / state.health
		w /= ratio
	end
	gfx.rect_fill(x,y,w,h,color)

	-- draw the satellites
	for _, sat in ipairs(state.sats) do
		Satellite.draw(sat)
	end

	-- draw the enemy ships
	for _, e in ipairs(state.enemies) do
		Enemy.draw(e)
	end

	-- draw the bullets and missiles
	for _, b in ipairs(state.bullets) do
		Bullet.draw(b)
	end

	ParticleManager.draw()

	Panel.draw(state.panel)

	-- if usagi.IS_DEV and state.show_debug then
	-- 	gfx.text("sats: " .. #State.sats, UI.padding, usagi.GAME_H - 18, gfx.COLOR_WHITE)
	-- end
end

return Gameplay
