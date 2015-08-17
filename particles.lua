local particles = {}

function particles:load()
	self.emitters = {}
	self.idCounter = 1
end

function particles:add(emitter)
	table.insert(self.emitters, emitter)
	emitter.id = self.idCounter
	self.idCounter = self.idCounter + 1
end

function particles:remove(emitter)
	for i = 1, table.getn(self.emitters) do
		if self.emitters[i].id == emitter.id then table.remove(self.emitters, i) end
	end
end

function particles:draw()
	for _, emitter in pairs(self.emitters) do
		emitter:draw()
	end
end

return particles