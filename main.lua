require 'class'
require 'util'
require 'controller'
require 'enemy'
local input = require 'input'
local resource = require 'resource'
local graphics = require 'graphics'
local quilt = require 'quilt'

local ocean = require 'ocean'
player = require 'player'
particles = nil
projectiles = nil
paused = false

function love.load()
  input:load()
  quilt:load()
  particles = controller(true)
  projectiles = controller(true)
  enemies = controller(true)
  player:load(particles)
  ocean:load()
  graphics:load()

  enemies:add(enemy({x = 120, y = 72}, 'shark'))

  require 'generator' ()
end

function love.update(dt)
  if not paused then
    input:update()
    quilt:update(dt)
    config:update()
  end
end

function love.draw()
  if not paused then
    love.graphics.setBackgroundColor(136, 178, 107, 255)
    graphics:push(player.pos.x - 80, player.pos.y - 72)
    ocean:draw(player.pos.x - 80, player.pos.y - 72, player.pos.x + 80, player.pos.y + 72)
    particles:draw()
    projectiles:draw()
    enemies:draw()
    player:draw()
    player.collide:draw()
    graphics:pop()
  else
    graphics:push(player.pos.x - 80, player.pos.y - 72)
    graphics:drawImage('pauseScreen', 0, 0)
    graphics:pop()
  end
end

function love.keypressed(key)
  if key == '=' then
    graphics:upscale()
  elseif key == '-' then
    graphics:downscale()
  elseif key == ' ' then
    paused = not paused
  end
end
