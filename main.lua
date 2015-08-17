require 'class'
require 'util'
require 'controller'
local input = require 'input'
local graphics = require 'graphics'
local quilt = require 'quilt'

local ocean = require 'ocean'
local player = require 'player'
particles = nil
projectiles = nil

function love.load()
  input:load()
  quilt:load()
  particles = controller(true)
  projectiles = controller(true)
  player:load(particles)
  ocean:load()
  graphics:load()

  require 'generator' ()
end

function love.update(dt)
  input:update()
  quilt:update(dt)
  config:update()
end

function love.draw()
  graphics:push(player.pos.x - 80, player.pos.y - 72)
  ocean:draw(player.pos.x - 80, player.pos.y - 72, player.pos.x + 80, player.pos.y + 72)
  particles:draw()
  projectiles:draw()
  player:draw()
  graphics:pop()
end

function love.keypressed(key)
  if key == '=' then
    graphics:upscale()
  elseif key == '-' then
    graphics:downscale()
  end
end
