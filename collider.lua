local quilt = require 'quilt'

collider = class()

function collider:init(target, size, solid)
	self.target = target
	self.pos = {x = target.pos.x - size.w / 2, y = target.pos.y - size.h / 2}
	self.size = {w = size.w, h = size.h}
	self.solid = solid

	self.threads = {
		update = function()
			while true do
				self.pos = {x = self.target.pos.x - self.size.w / 2, y = self.target.pos.y - self.size.h / 2}
				coroutine.yield(.0625)
			end
		end
	}

	quilt:add(self.threads.update)
end

--HIERARCHY OF COLLIDING:
--player moves out of walls
--enemies move out of walls
--enemies move out of player
--projectiles are consumed upon colliding

--THUS:
--player checks nearby walls
--enemies check nearby walls
--enemies check the player
--projectiles check nearby targets

function collider:check(otherObj)
	other = otherObj.collide
	xa1 = self.pos.x
	xa2 = self.pos.x + self.size.w
	ya1 = self.pos.y
	ya2 = self.pos.y + self.size.h

	xb1 = other.pos.x
	xb2 = other.pos.x + other.size.w
	yb1 = other.pos.y
	yb2 = other.pos.y + other.size.h

	collision = {}
	collision.w = math.max(0, math.min(xa2, xb2) - math.max(xa1, xb1))
	collision.h = math.max(0, math.min(ya2, yb2) - math.max(ya1, yb1))
	if collision.w * collision.h > 0 then
		--we have a collision!
		if xa1 < xb1 then
			--left
			collision.w = -collision.w
		end

		if ya1 >= yb1 then
			--below
			collision.h = -collision.h
		end

		--move out of solid things.
		if other.solid then
			self.target:move(collision.w, collision.h)
		end

		return true
	end

	return false

	--if self.pos.x < other.pos.x + other.size.w and
	--	self.pos.x + self.size.w > other.pos.x and
	--	self.pos.y < other.pos.y + other.size.h and
	--	self.pos.y + self.size.h > other.pos.y then
	--	return true
	--else
	--	return false
	--end
end

function collider:die()
	quilt:remove(self.threads.update)
end

function collider:draw()
	love.graphics.setColor(255, 0, 0, 255)
	love.graphics.rectangle('line', self.pos.x, self.pos.y, self.size.w, self.size.h)
end

-- Max(0, Min(XA2, XB2) - Max(XA1, XB1)) * Max(0, Min(YA2, YB2) - Max(YA1, YB1))