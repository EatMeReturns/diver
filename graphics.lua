local g = love.graphics
local resource = require 'resource'

local graphics = {}
graphics.scale = 1

function graphics:load()
  self:refreshWindow()
end

function graphics:drawImage(name, x, y)
  local image = resource.image[name]
  g.draw(image, x, y)
end

function graphics:drawAnimation(animation, x, y)
  g.draw(animation.image, animation.quad, x, y)
end

function graphics:upscale()
  self.scale = math.min(self.scale + 1, 4)
  self:refreshWindow()
end

function graphics:downscale()
  self.scale = math.max(self.scale - 1, 1)
  self:refreshWindow()
end

function graphics:refreshWindow()
  love.window.setMode(160 * self.scale, 144 * self.scale)
end

function graphics:push()
  g.push()
  g.scale(self.scale)
end

function graphics:pop()
  g.pop()
end

return graphics
