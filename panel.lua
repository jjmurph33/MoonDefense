local panel = {}

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

    return {
        x = x,
        y = y,
        w = WINDOW_WIDTH - 1 - x,
        h = WINDOW_HEIGHT - y,
        buttons = buttons,
    }
end

function panel.update(dt, e, state)

end

function panel.draw(p)
    gfx.rect_fill(p.x, p.y, p.w, p.h, gfx.COLOR_BLACK)
    gfx.rect(p.x, p.y, p.w, p.h, gfx.COLOR_DARK_GREEN)

    local icon_x = 5
    local icon_y = 8
    local text_x = 45
    local text_y = 5
    local text_y2 = 22

    for _, b in ipairs(p.buttons) do
        local count = State.sat_counts[b.sprite]
       local max = max_sats(b.sprite)

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
    end
end

function panel.clicked(mx, my, state)
    for _, b in ipairs(state.panel.buttons) do
        if util.point_in_rect({ x = mx, y = my }, { x = b.x, y = b.y, w = b.w, h = b.h }) then
            if state.sat_counts[b.sprite] < max_sats(b.sprite) then
                table.insert(state.sats, Satellite.new(b.sprite))
                state.sat_counts[b.sprite] += 1
                sfx.play(Sfx.BUILD)
            end
        end
    end
end

return panel
