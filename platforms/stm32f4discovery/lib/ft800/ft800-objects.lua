shape = {}


-- last settings sent to ft800, so you don't need send (change color, change point size, start, end) commands for every shape draw request
local state = {
    primitive = nil, --can be poins, lines, line strip, rects, edge_strip, bitmaps
    color = nil, -- color of the foreground
    point_size = nil, -- size of the point (for circle, for example)
}



local function startPrimitive(primitive)
end


function shape.begin()
end

function shape.finish()
end

function shape.circle(color)
end



function makeText(str, x, y, color, font, letterspacing)
    draw(color_rgb1(color))
    for i = 1, string.len(str) do
        draw(vertex2ii(x + (i - 1) * letterspacing, y, font, string.byte(str, i)))
    end
end



