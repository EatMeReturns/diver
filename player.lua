local input = require 'input'
local quilt = require 'quilt'

local player = {}

function player:load()
  local function update()
    while true do
      print(input.a.pressed)
      coroutine.yield()
    end
  end

  quilt:add(update)
end

function player:draw()

end

return player
