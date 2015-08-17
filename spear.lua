local graphics = require 'graphics'
local quilt = require 'quilt'
local actor = require 'actor'

spear = class()

function spear:init(pos, dir)
	self.pos = {x = pos.x, y = pos.y}
	self.dir = {x = dir.x, y = dir.y}

	local o = {x = -0.5 * self.dir.x + 0.5, y = -0.5 * self.dir.y + 0.5}

	self.ox = math.round(config.animations.spear.width * o.x)
	self.oy = math.round(config.animations.spear.height * o.y)
	o.x, o.y = o.y, o.x

	self.animation = actor:animate(self, 'spear')
	self.animation.frame = config.spear.framePositions[3 - o.x * 2][3 - o.y * 2]

	self.threads = {
		update = function()
			while true do
				self:move(self.dir.x * config.spear.swimSpeed, self.dir.y * config.spear.swimSpeed)
				particles:add(bubbler(self, {x = self.dir.x * -1, y = self.dir.y * -1}, .5, .1, {x = self.dir.x * -5, y = self.dir.y * -5}))

				if false then--if offscreen then
					self:die()
				end

				coroutine.yield(.0625)
			end
		end
	}

	quilt:add(self.threads.update)
end

function spear:draw()
	graphics:drawAnimation(self.animation, self.pos.x, self.pos.y, 0, 1, 1, self.ox, self.oy)
end

function spear:move(x, y)
	self.pos.x = math.round(self.pos.x + x)
	self.pos.y = math.round(self.pos.y + y)
end

function spear:die()
	quilt:remove(self.threads.update)
	projectiles:remove(self)
end

--x offsets: -1 = 1, 0 = .5, 1 = 0 p = (-0.5t + .5)w
--w, .5w, 0
--w, .5w, 0
--w, .5w, 0

--y offsets: 
--0, 0, 0
--.5h, .5h, .5h
--h, h, h

--if direction is [-1, -1] then I want frame [1][1]
--if direction is [-1, 0] then I want frame [2][1]