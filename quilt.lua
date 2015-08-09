local quilt = {}

function quilt:load()
  self.threads = {}
  self.delays = {}
end

function quilt:add(thread)
  thread = coroutine.wrap(thread)
  self.threads[thread] = thread
  self.delays[thread] = 0
end

function quilt:remove(thread)
  self.threads[thread] = nil
end

function quilt:update(dt)
  for thread in pairs(self.threads) do
    if self.delays[thread] <= dt then
      self.delays[thread] = thread() or 0
    else
      self.delays[thread] = self.delays[thread] - dt
    end
  end
end

return quilt
