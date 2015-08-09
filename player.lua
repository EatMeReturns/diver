local resource = require 'resource'
local graphics = require 'graphics'
local input = require 'input'
local quilt = require 'quilt'
local actor = require 'actor'

local player = {}

function player:load()

  print(config.player.sinkRate)

  -- Position
  self.pos = { x = 0, y = 0 }

  -- Map directional inputs to a vectorish thing
  self.dir = { x = 0, y = 0 }

  -- Swim using thrust. Thrust has a fixed direction that is set when you kick
  -- and a magnitude that decays over its duration. If the magnitude is zero
  -- then you stop moving and begin to sink?
  self.thrust = {
    dir = { x = 0, y = 0 },
    mag = 0
  }

  self.animation = actor:animate(self, 'player')

  self.threads = {

    -- Swims in our current direction for a while, slowing down over time.
    -- After the swimming is complete, start up the sink thread.
    swim = function()
      self.thrust.active = true
      self.thrust.dir.x = self.dir.x
      self.thrust.dir.y = self.dir.y

      quilt:remove(self.threads.sink)

      for i = config.player.swimSpeed, 1, -1 do
        self.pos.x = self.pos.x + self.thrust.dir.x
        self.pos.y = self.pos.y + self.thrust.dir.y
        print('swimming...')

        if i > 1 then
          coroutine.yield(1 / i / 4)
        end
      end

      self.thrust.active = false

      quilt:add(self.threads.sink)
    end,

    -- Sinks forever until something stops it
    sink = function()

      -- Wait for a little bit.
      coroutine.yield(config.player.sinkRate / 2)

      while true do
        self.pos.y = self.pos.y + 1
        print('sinking...')
        coroutine.yield(config.player.sinkRate)
      end
    end,

    -- Handles updating and looping of the animation
    animate = self.animation.update,

    -- Responds to input
    update = function()
      while true do
        self.dir.x = input.left.pressed and -1 or (input.right.pressed and 1 or 0)
        self.dir.y = input.up.pressed and -1 or (input.down.pressed and 1 or 0)

        if input.a.justPressed and not self.thrust.active then
          quilt:add(self.threads.swim)
        end

        if input.b.justPressed then
          -- man the harpoon, boys
        end

        coroutine.yield()
      end
    end
  }

  quilt:add(self.threads.update)
  quilt:add(self.threads.sink)
  quilt:add(self.threads.animate)
end

function player:draw()
  graphics:drawAnimation(self.animation, self.pos.x, self.pos.y)
end

return player
