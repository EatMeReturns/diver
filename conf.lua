function love.conf(t)
  t.window.width = 160
  t.window.height = 144
end

-- Global configuration
config = {}

-- The input mapping. Maps virtual controls to keys that trigger the control.
config.input = {
  up = { 'up', 'w' },
  down = { 'down', 's' },
  left = { 'left', 'a' },
  right = { 'right', 'd' },
  a = { 'z' },
  b = { 'x' }
}

-- List of animations. Each animation needs a length in frames and either a
-- global delay or a 'delays' table that specifies the delay for each frame.
-- Images should be named `images/<name><frame>.png`.
config.animations = {
  player = {
    length = 3,
    delay = .25
  }
}

config.player = {
  swimSpeed = 4,
  sinkRate = 1
}
