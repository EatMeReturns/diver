local graphics = require 'graphics'
local quilt = require 'quilt'
require 'bubble'

bubbler = class()

function bubbler:init(target, dir, str, rate, offset)
	--target: table with pos = {x, y} from which to pull the generator's position.
	--dir: angle at which bubbles are produced. {1, 0} or {0, -1} or etc.
	--str: initial size and velocity of bubbles.
	--rate: how often bubbles are spawned.
	self.target = target
	self.pos = {x = self.target.pos.x, y = self.target.pos.y}
	if offset then
		self.offset = {x = offset.x, y = offset.y}
		self.pos.x = self.pos.x + self.offset.x
		self.pos.y = self.pos.y + self.offset.y
	else
		self.offset = {x = 0, y = 0}
	end
	self.dir = {x = dir.x, y = dir.y}
	self.strength = str
	self.rate = rate
	self.bubbles = {}
	self.idCounter = 1

	self.threads = {

		-- spawns a bubble
		spawn = function()
			while true do
				self:add(bubble(self, self.pos, self.dir, math.ceil(self.strength / 0.34)))
				coroutine.yield(self.rate)
			end
		end,

		-- follows the target
		update = function()
			while self.strength > 0 do
				self.pos = {x = self.target.pos.x + self.offset.x, y = self.target.pos.y + self.offset.y}
				self.strength = self.strength - .0625 * 2

				if self.strength <= 0 then
					self:die()
				end

				coroutine.yield(.0625)
			end
		end
	}

	quilt:add(self.threads.update)
	quilt:add(self.threads.spawn)
end

function bubbler:add(bub)
	table.insert(self.bubbles, bub)
	bub.id = self.idCounter
	self.idCounter = self.idCounter + 1
end

function bubbler:remove(bub)
	for i = 1, table.getn(self.bubbles) do
		if self.bubbles[i].id == bub.id then table.remove(self.bubbles, i) end
	end
end

function bubbler:draw()
	for _, bub in pairs(self.bubbles) do
		bub:draw()
	end
end

function bubbler:die()
	quilt:remove(self.threads.update)
	quilt:remove(self.threads.spawn)
	particles:remove(self)
end