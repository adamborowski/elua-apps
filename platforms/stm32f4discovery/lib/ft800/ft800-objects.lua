shape = {}


-- last settings sent to ft800, so you don't need send (change color, change point size, start, end) commands for every shape draw request
local state = {
    primitive = nil, --can be poins, lines, line strip, rects, edge_strip, bitmaps
    color = nil, -- color of the foreground
    point_size = nil, -- size of the point (for circle, for example)
}


--[[
    @param x 1/16 px
    @param y 1/16 px
 ]]
function shape.circle(x, y, radius, color, alpha)
    setPrimitive(PRIM.POINTS)
    setAlpha(alpha)
    setColor_rgb1(color)
    setPointSize(radius)
    drawVertex2f(x, y)
end

function shape.rectangle(x, y, w, h, color)
end



function drawText(str, x, y, color, alpha, font, letterspacing)
    setAlpha(alpha)
    setColor_rgb1(color)
    setPrimitive(PRIM.BITMAP)
    for i = 1, string.len(str) do
        drawVertex2ii(x + (i - 1) * letterspacing, y, font, string.byte(str, i))
    end
end



