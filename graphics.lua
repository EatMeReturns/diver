local g = love.graphics
local resource = require 'resource'

local graphics = {}

function graphics:draw(name, x, y)
  local image = resource.image[name]
  g.draw(image, x, y)
end

return graphics
