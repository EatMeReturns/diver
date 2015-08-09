local input = require 'input'
local graphics = require 'graphics'
local quilt = require 'quilt'

local player = require 'player'

function love.load()
  input:load()
  quilt:load()
  player:load()
end

function love.update(dt)
  input:update()
  quilt:update(dt)
end

function love.draw()
end
