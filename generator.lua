local ocean = require 'ocean'
local r = love.math.random
local rn = love.math.randomNormal
local function maybe(...) local a = {...} return a[r(1, #a)] end

local function set(x, y, v)
  v = v or 1
  ocean.walls[x] = ocean.walls[x] or {}
  ocean.walls[x][y] = v
end

local function fill(x, y, n, v)
  for x = x, x + n - 1 do
    for y = y, y + n - 1 do
      set(x, y, v)
    end
  end
end

local function move(x, y, theta, sigma, n)
  theta = theta + rn(sigma)
  x = math.floor((x + math.cos(theta) * n) / 8 + .5) * 8
  y = math.floor((y + math.sin(theta) * n) / 8 + .5) * 8
  return x, y
end

return function()
  for _ = 1, 100 do
    local res = 2 ^ maybe(4, 5, 6)
    x, y = 80, 72
    local theta = -7 * math.pi / 4 - math.pi / 12 + r() * math.pi / 6
    for i = 1, 1000 / res do
      fill(x, y, res, math.floor(r() + .08))
      x, y = move(x, y, theta, r() * math.pi / 2 * maybe(1, -1), res)
    end
  end
end

