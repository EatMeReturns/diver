local resource = {}

resource.image = setmetatable({}, {
  __index = function(_, name)
    local image = love.graphics.newImage('images/' .. name .. '.png')
    image:setFilter('nearest', 'nearest')
    resource.image[name] = image
    return image
  end
})

resource.font = setmetatable({}, {
  __call = function(name, size)
    if not resource.font[name] or not resource.font[name][size] then
      resource.font[name] = resource.font[name] or {}
      resource.font[name][size] = love.graphics.newFont('fonts/' .. name .. '.ttf', size)
    end

    return resource.font[name][size]
  end
})

return resource
