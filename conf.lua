function love.conf(t)
  t.window = nil
  t.console = true
end

-- Global configuration
config = {}

-- The config automatically refreshes when this file is saved.
config.update = function()
  local mtime = love.filesystem.getLastModified('config.lua')
  if not config.lastModified or mtime > config.lastModified then
    package.loaded.conf = nil
    require 'conf'
    config.lastModified = mtime
  end
end

-- The input mapping. Maps virtual controls to keys that trigger the control.
config.input = {
  up = { 'up', 'w' },
  down = { 'down', 's' },
  left = { 'left', 'a' },
  right = { 'right', 'd' },
  a = { 'z' },
  b = { 'x' }
}

-- List of animations. Each animation needs to specify the width and height of
-- each frame, as well as the number of frames (length). The spritesheet should
-- have the same name as the key.
config.animations = {
  player = {
    width = 30,
    height = 24,
    length = 4
  },

  bubbles = {
    width = 8,
    height = 8,
    length = 3
  },

  spear = {
    width = 12,
    height = 12,
    length = 9
  }
}

config.player = {
  swimSpeed = 16, --burst
  sinkRate = .5,
  health = 100
}

config.shark = {
  swimSpeed = 8, --constant
  swimAnimationDelay = .25,
  health = 45
}

config.jellyfish = {
  swimSpeed = 4, --burst
  swimAnimationDelay = {.25, .25, .25},
  health = 15
}

config.squid = {
  swimSpeed = 16, --burst
  sinkAnimationDelay = .75,
  swimAnimationDelay = .12,
  health = 75
}

config.smallFish = {
  swimSpeed = 10, --constant
  swimAnimationDelay = .25,
  health = 5
}

config.spear = {
  swimSpeed = 8,
  damage = 10,
  framePositions = {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}}
}