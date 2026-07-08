local panel = {}

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

    for _, b in ipairs(p.buttons) do
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
    end
end

function panel.clicked(mx, my, state)
    for _, b in ipairs(state.panel.buttons) do
        if util.point_in_rect({ x = mx, y = my }, { x = b.x, y = b.y, w = b.w, h = b.h }) then
            local orbit = 0
            if b.sprite == Spr.SAT_SHIELD then
                orbit = 1
            elseif b.sprite == Spr.SAT_TURRET then
                orbit = 2
            elseif b.sprite == Spr.SAT_MISSLE then
                orbit = 3
            end
            local new_sat = Satellite.new(orbit, b.sprite)
            sfx.play(Sfx.BUILD)
            table.insert(state.sats, new_sat)
        end
    end
end

return panel
