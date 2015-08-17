local resource = require 'resource'
local graphics = require 'graphics'
local input = require 'input'
local quilt = require 'quilt'
local actor = require 'actor'
require 'spear'
require 'bubbler'

local player = {}

function player:load(particles)
  self.particles = particles

  -- Position
  self.pos = { x = 80, y = 72 }

  -- Map directional inputs to a vectorish thing
  self.dir = { x = 0, y = 0 }

  -- For persistent rendering independent of keystate
  self.flip = false
  self.rotation = 0

  -- Swimming has a fixed direction that is set when you kick and a magnitude
  -- that decays over its duration. If the magnitude is zero then you stop
  -- moving and begin to sink.
  self.swim = {
    dir = { x = 0, y = 0 },
    mag = 0
  }

  self.speargun = {
    timer = 0
  }

  self.animation = actor:animate(self, 'player')

  self.threads = {

    -- Swims in our current direction for a while, slowing down over time.
    -- After the swimming is complete, start up the sink thread.
    fire = function()
        print('firing...')
        projectiles:add(spear({x = self.pos.x, y = self.pos.y}, {x = self.dir.x, y = self.dir.y}))
        self.speargun.timer = 0.75

        while self.speargun.timer > 0 do
          self.speargun.timer = self.speargun.timer - .0625

          if self.speargun.timer < 0 then
            self.speargun.timer = 0
          else
            coroutine.yield(.0625)
          end
        end
    end,

    swim = function()
      self.swim.mag = config.player.swimSpeed
      self.swim.dir.x = self.dir.x
      self.swim.dir.y = self.dir.y

      --quilt:reset(self.threads.animate)
      self.animation.timer = .0625
      if self.animation.frame % 2 ~= 0 then self.animation.frame = self.animation.frame + 1 end
      quilt:remove(self.threads.sink)

      --spawn a bubbler
      particles:add(bubbler(self, {x = self.dir.x * -1, y = self.dir.y * -1}, 1, .1, {x = self.dir.x * -10, y = self.dir.y * -10}))

      while self.swim.mag > 0 do
        self:move(self.swim.dir.x * math.ceil(self.swim.mag / 5), self.swim.dir.y * math.ceil(self.swim.mag / 5))

        self.swim.delay = 1 / self.swim.mag * 16
        self.swim.mag = self.swim.mag - self.swim.delay

        if self.swim.mag > 1 then
          coroutine.yield(.0625)
        else
          self.swim.mag = 0
        end
      end

      quilt:add(self.threads.sink)
    end,

    -- Sinks forever until something stops it
    sink = function()

      quilt:reset(self.threads.animate)

      -- Wait for a little bit.
      coroutine.yield(config.player.sinkRate / 2)

      while true do
        self:move(0, 1)
        particles:add(bubbler(self, {x = 0, y = -1}, .5, 1, {x = -12, y = 0}))
        coroutine.yield(config.player.sinkRate)
      end
    end,

    -- Handles updating and looping of the animation
    animate = function()
      self.animation.timer = 0
      while true do
        if self.animation.timer <= 0 then
          self.animation.timer = .75
          self.animation.frame = self.animation.frame + 1

          if self.animation.frame > self.animation.length then
            self.animation.frame = 1
          end
        end

        self.animation.timer = self.animation.timer - .0625
        coroutine.yield(.0625)
        --coroutine.yield(self.swim.mag == 0 and .75 or .25)
      end
    end,

    -- Responds to input
    update = function()
      while true do
        self.dir.x = input.left.pressed and -1 or (input.right.pressed and 1 or 0)
        self.dir.y = input.up.pressed and -1 or (input.down.pressed and 1 or 0)

        self.animation.image = (self.dir.x == 0 and self.dir.y == 0) and self.animation.image or ((self.dir.x ~= 0 and self.dir.y ~= 0) and resource.image.player45 or resource.image.player)
        self.flip = self.dir.x == 0 and self.flip or self.dir.x < 0
        self.rotation = (self.dir.x == 0 and self.dir.y == 0) and self.rotation or math.atan2(self.dir.y, self.dir.x)

        if input.a.pressed and self.swim.mag == 0 and (self.dir.x ~= 0 or self.dir.y ~= 0) then
          quilt:add(self.threads.swim)
        end

        if input.b.pressed and self.speargun.timer == 0 and (self.dir.x ~= 0 or self.dir.y ~= 0) then
          quilt:add(self.threads.fire)
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
  local sx, sy = self.flip and -1 or 1, 1
  local r = sx == -1 and self.rotation - math.pi or self.rotation
  if self.animation.image == resource.image.player45 then
    r = (self.dir.y < 0) and math.pi / 2 * -sx or 0
  end
  local ox, oy = self.animation.width / 2, self.animation.height / 2
  graphics:drawAnimation(self.animation, self.pos.x, self.pos.y, r, sx, sy, ox, oy)
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
