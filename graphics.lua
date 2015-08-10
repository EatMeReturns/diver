local g = love.graphics
local resource = require 'resource'

local graphics = {}
graphics.scale = 4

function graphics:load()
  self:refreshWindow()
end

function graphics:drawImage(name, x, y, ...)
  local image = resource.image[name]
  g.setColor(255, 255, 255)
  g.draw(image, x, y)
end

function graphics:drawAnimation(animation, ...)
  animation.quad:setViewport((animation.frame - 1) * animation.width, 0, animation.width, animation.height)
  g.setColor(255, 255, 255)
  g.draw(animation.image, animation.quad, ...)
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

function graphics:push(x, y)
  g.push()
  g.scale(self.scale)
  g.translate(-x, -y)
end

function graphics:pop()
  g.pop()
end

return graphics
