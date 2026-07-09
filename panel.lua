local panel = {}

panel.TIMER_MAX = 5

local function max_sats(sprite)
    if sprite == Spr.SAT_SHIELD then
        return 1
    elseif sprite == Spr.SAT_TURRET then
        return 4
    elseif sprite == Spr.SAT_MISSLE then
        return 4
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
    table.insert(buttons, { x = bx, y = by, w = bw, h = bh, sprite = Spr.SAT_MISSLE })

    local timers = {}
    timers[Spr.SAT_SHIELD]=0
    timers[Spr.SAT_TURRET]=0
    timers[Spr.SAT_MISSLE]=0

    return {
        x = x,
        y = y,
        w = WINDOW_WIDTH - 1 - x,
        h = WINDOW_HEIGHT - y,
        buttons = buttons,
        timers = timers,
    }
end

function panel.update(dt, p, state)
    update_timer(dt, p, state,Spr.SAT_SHIELD)
    update_timer(dt, p, state,Spr.SAT_TURRET)
    update_timer(dt, p, state,Spr.SAT_MISSLE)
end

function panel.draw(p,state)
    gfx.rect_fill(p.x, p.y, p.w, p.h, gfx.COLOR_BLACK)
    gfx.rect(p.x, p.y, p.w, p.h, gfx.COLOR_DARK_GREEN)

    local icon_x = 5
    local icon_y = 8
    local text_x = 45
    local text_y = 5
    local text_y2 = 22

    for _, b in ipairs(p.buttons) do
        local count = state.sat_counts[b.sprite]
        local max = max_sats(b.sprite)

        local timer = p.timers[b.sprite]
        --local timer = 0
        local max_time = panel.TIMER_MAX

        gfx.rect(b.x, b.y, b.w, b.h, gfx.COLOR_DARK_GREEN)
        if b.sprite == Spr.SAT_SHIELD then
            gfx.sspr_ex(32, 0, 16, 16, b.x + icon_x, b.y + icon_y, SIZE * 2, SIZE * 2, false, false, 0, 0, 1.0)
            gfx.text("Shield", b.x + text_x, b.y + text_y, gfx.COLOR_DARK_GREEN)
        elseif b.sprite == Spr.SAT_TURRET then
            gfx.sspr_ex(16, 0, 16, 16, b.x + icon_x, b.y + icon_y, SIZE * 2, SIZE * 2, false, false, 0, 0, 1.0)
            gfx.text("Turret", b.x + text_x, b.y + text_y, gfx.COLOR_DARK_GREEN)
        elseif b.sprite == Spr.SAT_MISSLE then
            gfx.sspr_ex(48, 0, 16, 16, b.x + icon_x, b.y + icon_y, SIZE * 2, SIZE * 2, false, false, 0, 0, 1.0)
            gfx.text("Missle Launcher", b.x + text_x, b.y + text_y, gfx.COLOR_DARK_GREEN)
        end
        gfx.text(string.format("%d/%d",count,max), b.x + text_x, b.y + text_y2, gfx.COLOR_DARK_GREEN)

        local x = b.x+1
       	local w = b.w-1
       	local h = b.h-1
       	local y = b.y+1
        if timer > 0 then
            local ratio = panel.TIMER_MAX / timer
            w /= ratio
       	    gfx.rect_fill(x,y,w,h,gfx.COLOR_LIGHT_GRAY,0.25)
        elseif count >= max then
            gfx.rect_fill(x,y,w,h,gfx.COLOR_LIGHT_GRAY,0.25)
        end
    end

    text_y = p.y + p.h - 20
    gfx.text(string.format("Score: %d",State.score), p.x+icon_x, p.y+text_y, gfx.COLOR_DARK_GREEN)
end

function panel.clicked(mx, my, state)
    for _, b in ipairs(state.panel.buttons) do
        if util.point_in_rect({ x = mx, y = my }, { x = b.x, y = b.y, w = b.w, h = b.h }) then
            if state.sat_counts[b.sprite] < max_sats(b.sprite) then
                if state.panel.timers[b.sprite] <= 0 then
                    table.insert(state.sats, Satellite.new(b.sprite))
                    state.sat_counts[b.sprite] += 1
                    sfx.play(Sfx.BUILD)
                    --state.panel.timers[b.sprite] = panel.TIMER_MAX * state.sat_counts[b.sprite]
                    state.panel.timers[b.sprite] = panel.TIMER_MAX
                end
            end
        end
    end
end

return panel
