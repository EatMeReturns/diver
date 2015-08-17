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

  return self
end

return actor
