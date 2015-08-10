local ocean = require 'ocean'
local wall = require 'wall'

return function()
  ocean:add(wall.new(0, 0))
end

