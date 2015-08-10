local wall = {}
wall.__index = wall

wall.size = { width = 8, height = 8 }

function wall.new(x, y)
  return setmetatable({
    pos = { x = x, y = y }
  }, wall)
end

function wall:draw()
  local g = love.graphics
  g.setColor(0, 0, 255)
  g.rectangle('fill', self.pos.x, self.pos.y, self.size.width, self.size.height)
end

return wall
