controller = class()

function controller:init(drawable, threadable)
	self.objects = {}
	self.idCounter = 1

	self.drawable = drawable or false
	self.threadable = threadable or false --necessary? I think not.
end

function controller:add(obj)
	table.insert(self.objects, obj)
	obj.id = self.idCounter
	self.idCounter = self.idCounter + 1
end

function controller:remove(obj)
	for i = 1, table.getn(self.objects) do
		if self.objects[i].id == obj.id then table.remove(self.objects, i) end
	end
end

function controller:draw()
	if self.drawable then
		for _, obj in pairs(self.objects) do
			obj:draw()
		end
	end
end