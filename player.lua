local input = require 'input'
local quilt = require 'quilt'
local actor = require 'actor'

local player = {}

function player:load()
  local function update()
    while true do
      print(input.a.pressed)
      coroutine.yield()
    end
  end

  quilt:add(update)

  self.animation = actor:animate(self, 'player')
  quilt:add(self.animation.update)
end

function player:draw()

end

return player
