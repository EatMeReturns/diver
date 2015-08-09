require 'conf'

local actor = {}

function actor:animate(target, name)
  local animation = {
    name = name,
    frame = 1,
    image = nil,
    update = nil
  }

  setmetatable(animation, { __index = config.animations[name] })

  animation.update = function()
    while true do
      animation.frame = animation.frame + 1

      if animation.frame > animation.length then
        animation.frame = 1
      end

      animation.image = animation.name .. animation.frame

      coroutine.yield(animation.delays and animation.delays[animation.frame] or animation.delay)
     end
  end

  return animation
end

return actor
