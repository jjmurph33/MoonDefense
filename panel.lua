local panel = {}

panel.TIMER_MAX = 5

local function max_sats(sprite)
    if sprite == Spr.SAT_SHIELD then
        return 1
    elseif sprite == Spr.SAT_TURRET then
        return 4
    elseif sprite == Spr.SAT_MISSILE then
        return 6
    else
        return 0
    end
end

local function update_timer(dt,p,state,sprite)
    if state.sat_counts[sprite] < max_sats(sprite) then
        if p.timers[sprite] > 0 then
            p.timers[sprite] -= dt
        end
    end
end

function panel.new()
    local x = WIDTH + 1
    local y = 1

    local buttons = {}
    local bx = x + 10
    local by = y + 10
    local bw = WINDOW_WIDTH - 10 - bx
    local bh = SIZE * 3
    local gap = 10
    table.insert(buttons, { x = bx, y = by, w = bw, h = bh, sprite = Spr.SAT_SHIELD })
    by += bh + gap
    table.insert(buttons, { x = bx, y = by, w = bw, h = bh, sprite = Spr.SAT_TURRET })
    by += bh + gap
    table.insert(buttons, { x = bx, y = by, w = bw, h = bh, sprite = Spr.SAT_MISSILE })

    local timers = {}
    timers[Spr.SAT_SHIELD]=0
    timers[Spr.SAT_TURRET]=0
    timers[Spr.SAT_MISSILE]=0

    return {
        x = x,
        y = y,
        w = WINDOW_WIDTH - 1 - x,
        h = WINDOW_HEIGHT - y,
        buttons = buttons,
        timers = timers,
        selected = Spr.SAT_SHIELD
    }
end

function panel.update(dt, p, state)
    update_timer(dt, p, state,Spr.SAT_SHIELD)
    update_timer(dt, p, state,Spr.SAT_TURRET)
    update_timer(dt, p, state,Spr.SAT_MISSILE)
end

function panel.draw(p,state)
    gfx.rect_fill(p.x, p.y, p.w, p.h, gfx.COLOR_BLACK)
    gfx.rect(p.x, p.y, p.w, p.h, gfx.COLOR_DARK_GREEN)

    local icon_x = 5
    local icon_y = 8
    local text_x = 40
    local text_y = 5
    local text_y2 = 22

    for _, b in ipairs(p.buttons) do
        local count = state.sat_counts[b.sprite]
        local max = max_sats(b.sprite)

        local timer = p.timers[b.sprite]
        --local max_time = panel.TIMER_MAX

        local color = gfx.COLOR_DARK_GREEN
        if b.sprite == p.selected then
            color = gfx.COLOR_YELLOW
        end
        gfx.rect(b.x, b.y, b.w, b.h,color )
        if b.sprite == Spr.SAT_SHIELD then
            gfx.sspr_ex(16,0,16,16, b.x + icon_x, b.y + icon_y, SIZE * 2, SIZE * 2, false, false, math.pi/2, 0, 1.0)
            gfx.text("Shield", b.x + text_x, b.y + text_y, gfx.COLOR_DARK_GREEN)
        elseif b.sprite == Spr.SAT_TURRET then
            gfx.sspr_ex(32,0,16,16, b.x + icon_x, b.y + icon_y, SIZE * 2, SIZE * 2, false, false, 0, 0, 1.0)
            gfx.text("Turret", b.x + text_x, b.y + text_y, gfx.COLOR_DARK_GREEN)
        elseif b.sprite == Spr.SAT_MISSILE then
            gfx.sspr_ex(48,0,16,16, b.x + icon_x, b.y + icon_y, SIZE * 2, SIZE * 2, false, false, 0, 0, 1.0)
            gfx.text("Missile Launcher", b.x + text_x, b.y + text_y, gfx.COLOR_DARK_GREEN)
        end
        gfx.text_ex(string.format("%d/%d",count,max), b.x + text_x, b.y + text_y2, 2,0, gfx.COLOR_DARK_GREEN,1)

        local x = b.x+1
       	local w = b.w-1
       	local h = b.h-1
       	local y = b.y+1

        if count >= max then
            gfx.rect_fill(x,y,w,h,gfx.COLOR_LIGHT_GRAY,0.50)
        elseif timer > 0 then
            local ratio = panel.TIMER_MAX / timer
            w /= ratio
            gfx.rect_fill(x,y,w,h,gfx.COLOR_LIGHT_GRAY,0.33)
        end
    end

    text_y = p.y + p.h - 20
    gfx.text(string.format("Score: %d",State.score), p.x+icon_x, p.y+text_y, gfx.COLOR_DARK_GREEN)
end

function panel.clicked(mx, my, state)
    for _, b in ipairs(state.panel.buttons) do
        if util.point_in_rect({ x = mx, y = my }, { x = b.x, y = b.y, w = b.w, h = b.h }) then
            state.panel.selected = b.sprite
            panel.select(state)
        end
    end
end

function panel.next(state)
    local p = state.panel
    p.selected += 1
    if p.selected > Spr.SAT_MISSILE then
        p.selected = Spr.SAT_SHIELD
    end
end

function panel.prev(state)
    local p = state.panel
    p.selected -= 1
    if p.selected < Spr.SAT_SHIELD then
        p.selected = Spr.SAT_MISSILE
    end
end

function panel.select(state)
    local p = state.panel
    local s = p.selected
    if state.sat_counts[s] < max_sats(s) then
        if state.panel.timers[s] <= 0 then
            table.insert(state.sats, Satellite.new(s))
            state.sat_counts[s] += 1
            sfx.play(Sfx.BUILD)
            --state.panel.timers[b.sprite] = panel.TIMER_MAX * state.sat_counts[b.sprite]
            state.panel.timers[s] = panel.TIMER_MAX
        end
    end
end

return panel
