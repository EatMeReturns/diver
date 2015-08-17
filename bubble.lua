local graphics = require 'graphics'
local actor = require 'actor'
local quilt = require 'quilt'

bubble = class()

function bubble:init(bubbler, pos, dir, size)
	self.bubbler = bubbler
	self.pos = {x = pos.x, y = pos.y}
	self.dir = {x = dir.x + math.random() * 2 - 1, y = dir.y + math.random() * 2 - 1}
	self.size = size

	self.animation = actor:animate(self, 'bubbles')
	self.animation.frame = self.size

	self.threads = {
		update = function()
			while self.size > 0 do
				self:move(self.dir.x * self.animation.frame, self.dir.y * self.animation.frame)
				self.size = self.size - .0625 * 10
				self.animation.frame = math.ceil(self.size)

				if self.size <= 0 then
					self:die()
				end

				coroutine.yield(.0625)
			end
		end
	}

	quilt:add(self.threads.update)
end

function bubble:draw()
	local ox, oy = math.floor(self.animation.width / 2), math.floor(self.animation.height / 2)
	graphics:drawAnimation(self.animation, self.pos.x, self.pos.y, 0, 1, 1, ox, oy)
end

function bubble:move(x, y)
	self.pos.x = math.round(self.pos.x + x)
	self.pos.y = math.round(self.pos.y + y)
end

function bubble:die()
	quilt:remove(self.threads.update)
	self.bubbler:remove(self)
end