require 'conf'
local resource = require 'resource'

local actor = {}

function actor:animate(target, name)
  local self = {
    name = name,
    frame = 1
  }

  setmetatable(self, { __index = config.animations[name] })

  self.image = resource.image[self.name]
  self.quad = love.graphics.newQuad(0, 0, self.width, self.height, self.image:getDimensions())

  self.update = function()
    while true do
      self.frame = self.frame + 1

      if self.frame > self.length then
        self.frame = 1
      end

      self.quad:setViewport((self.frame - 1) * self.width, 0, self.width, self.height)

      coroutine.yield(self.delays and self.delays[self.frame] or (type(self.delay) == 'function' and self.delay() or self.delay))
    end
  end

  return self
end

return actor
