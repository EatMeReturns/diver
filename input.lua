require 'conf'

local input = {}

function input:load()
  self.state = {}
  for control in pairs(config.input) do
    self.state[control] = {
      pressed = false,
      justPressed = false,
      justReleased = false
    }
  end

  setmetatable(self, { __index = self.state })
end

function input:update()
  for control, keys in pairs(config.input) do
    local pressed = love.keyboard.isDown(unpack(keys))
    self[control].justPressed = pressed and not self[control].pressed
    self[control].justReleased = not pressed and self[control].pressed
    self[control].pressed = pressed
  end
end

return input
