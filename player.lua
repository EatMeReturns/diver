local resource = require 'resource'
local graphics = require 'graphics'
local input = require 'input'
local quilt = require 'quilt'
local actor = require 'actor'

local player = {}

function player:load()

  -- Position
  self.pos = { x = 0, y = 0 }

  -- Map directional inputs to a vectorish thing
  self.dir = { x = 0, y = 0 }

  -- Swimming has a fixed direction that is set when you kick and a magnitude
  -- that decays over its duration. If the magnitude is zero then you stop
  -- moving and begin to sink.
  self.swim = {
    dir = { x = 0, y = 0 },
    mag = 0
  }

  self.animation = actor:animate(self, 'player')

  self.threads = {

    -- Swims in our current direction for a while, slowing down over time.
    -- After the swimming is complete, start up the sink thread.
    swim = function()
      self.swim.mag = config.player.swimSpeed
      self.swim.dir.x = self.dir.x
      self.swim.dir.y = self.dir.y

      quilt:reset(self.threads.animate)
      quilt:remove(self.threads.sink)

      while self.swim.mag > 0 do
        print('swimming...')
        self:move(self.swim.dir)

        if self.swim.mag > 1 then
          coroutine.yield(1 / self.swim.mag / 4)
        end

        self.swim.mag = self.swim.mag - 1
      end

      quilt:add(self.threads.sink)
    end,

    -- Sinks forever until something stops it
    sink = function()

      quilt:reset(self.threads.animate)

      -- Wait for a little bit.
      coroutine.yield(config.player.sinkRate / 2)

      while true do
        print('sinking...')
        self:move(0, 1)
        coroutine.yield(config.player.sinkRate)
      end
    end,

    -- Handles updating and looping of the animation
    animate = function()
      while true do
        self.animation.frame = self.animation.frame + 1

        if self.animation.frame > self.animation.length then
          self.animation.frame = 1
        end

        coroutine.yield(self.swim.mag == 0 and .75 or .12)
      end
    end,

    -- Responds to input
    update = function()
      while true do
        self.dir.x = input.left.pressed and -1 or (input.right.pressed and 1 or 0)
        self.dir.y = input.up.pressed and -1 or (input.down.pressed and 1 or 0)

        if input.a.justPressed and self.swim.mag == 0 then
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

function player:move(x, y)
  if type(x) == 'table' then
    y = x.y
    x = x.x
  end

  self.pos.x = self.pos.x + x
  self.pos.y = self.pos.y + y
end

return player
