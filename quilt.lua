local quilt = {}

function quilt:load()
  self.threads = {}
  self.delays = {}
end

function quilt:add(thread)
  self.threads[thread] = coroutine.create(thread)
  self.delays[thread] = 0
  return thread
end

function quilt:remove(thread)
  self.threads[thread] = nil
  return thread
end

function quilt:reset(thread)
  self.delays[thread] = 0
  return thread
end

function quilt:update(dt)
  for thread, cr in pairs(self.threads) do
    if self.delays[thread] <= dt then
      local _, delay = coroutine.resume(cr)
      self.delays[thread] = delay or 0

      if coroutine.status(cr) == 'dead' then
        self:remove(thread)
      end
    else
      self.delays[thread] = self.delays[thread] - dt
    end
  end
end

return quilt
