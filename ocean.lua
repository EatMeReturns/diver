local ocean = {}

local function getCell(thing)
  return math.floor(thing.pos.x / 128) .. '.' .. math.floor(thing.pos.y / 128)
end

function ocean:load()
  self.hash = {}
  self.walls = {}
end

function ocean:draw(x1, y1, x2, y2)
  local g = love.graphics
  g.setColor(0, 0, 255)

  for x = x1, x2 do
    for y = y1, y2 do
      if self.walls[x] and self.walls[x][y] == 0 then
        g.point(x, y)
      end
    end
  end

  for cell, things in pairs(self.hash) do
    for thing in pairs(things) do
      thing:draw()
    end
  end
end

function ocean:add(thing)
  local cell = getCell(thing)
  thing._cell = cell
  self.hash[cell] = self.hash[cell] or {}
  self.hash[cell][thing] = thing
end

function ocean:remove(thing)
  self.hash[thing._cell][thing] = nil
end

function ocean:refresh(thing)
  if getCell(thing) == thing._cell then return end
  self:remove(thing)
  self:add(thing)
end

return ocean
