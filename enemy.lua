local resource = require 'resource'
local graphics = require 'graphics'
local quilt = require 'quilt'
local actor = require 'actor'
require 'collider'

enemy = class()

function enemy:init(pos, enemyType)
	self.pos = {x = pos.x, y = pos.y}
	self.dir = {x = 0, y = 0}
	self.health = config[enemyType].health
	self.damage = config[enemyType].damage
	self.enemyType = enemyType

	self.flip = false

	self.animation = actor:animate(self, enemyType)

	self.collide = collider(self, {w = config[enemyType].collision.w, h = config[enemyType].collision.h}, false)

	self.threads = {
		collision = function()
			while true do
				--check walls
				--check player
				local hit = self.collide:check(player)
				if hit then player:hurt(self.damage) end
				coroutine.yield(.0625)
			end
		end,
		--swim
		--attack
		animate = function()
			self.animation.timer = 0
			while true do
				if self.animation.timer <= 0 then
					self.animation.timer = .25
					self.animation.frame = self.animation.frame + 1

					if self.animation.frame > self.animation.length then
						self.animation.frame = 1
					end
				end

				self.animation.timer = self.animation.timer - .0625
				coroutine.yield(.0625)
			end
		end,

		update = function()
			while true do
				self.animation.image = (self.dir.x == 0 and self.dir.y == 0) and self.animation.image or ((self.dir.x ~= 0 and self.dir.y ~= 0) and resource.image[self.enemyType .. '45'] or resource.image[self.enemyType])
				self.flip = self.dir.x == 0 and self.flip or self.dir.x < 0
				self.rotation = (self.dir.x == 0 and self.dir.y == 0) and self.rotation or math.atan2(self.dir.y, self.dir.x)

	            coroutine.yield(.0625)
			end
		end
	}

	quilt:add(self.threads.collision)
	--quilt:add(self.threads.swim)
	--quilt:add(self.threads.attack)
	quilt:add(self.threads.animate)
	quilt:add(self.threads.update)
end

function enemy:hurt(amount)
	self.health = self.health - amount
	if self.health <= 0 then
		self:die()
	end
end

function enemy:die()
	--animate death? or just explode in to bubbles?
	enemies:remove(self)
end

function enemy:draw()
	self.collide:draw()
	local sx, sy = self.flip and -1 or 1, 1
	local r = sx == -1 and self.rotation - math.pi or self.rotation
	if self.animation.image == resource.image[self.enemyType .. '45'] then
		r = (self.dir.y < 0) and math.pi / 2 * -sx or 0
	end
	local ox, oy = self.animation.width / 2, self.animation.height / 2
	graphics:drawAnimation(self.animation, self.pos.x, self.pos.y, r, sx, sy, ox, oy)
end

function enemy:move(x, y)
	if type(x) == 'table' then
		y = x.y
		x = x.x
	end

	self.pos.x = self.pos.x + x
	self.pos.y = self.pos.y + y
end