local ocean = {}

local function getCell(thing)
  return math.floor(thing.pos.x / 100) .. '.' .. math.floor(thing.pos.y / 100)
end

function ocean:load()
  self.hash = {}
end

function ocean:draw()
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
