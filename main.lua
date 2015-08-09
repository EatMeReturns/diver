local input = require 'input'
local graphics = require 'graphics'
local quilt = require 'quilt'

local player = require 'player'

function love.load()
  input:load()
  quilt:load()
  player:load()
  graphics:load()
end

function love.update(dt)
  input:update()
  quilt:update(dt)
  config:update()
end

function love.draw()
  graphics:push()
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
