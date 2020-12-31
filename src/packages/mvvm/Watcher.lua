
local Consumer = import(".Consumer")
local Producer = import(".Producer")
local Observee = import(".Observee")
local Watcher = class("Watcher")

function Watcher:ctor(ob)
    self.ob = ob or Observee:getInstance()
end

function Watcher:bind(...)
    local dc = Consumer.new(self.ob)
    for _, path in ipairs({...}) do
        dc:bind(path)
    end
    self.dc = dc
    return self.dc
end

function Watcher:unbind()
    if self.dc then
        self.dc:dispose()
        self.dc = nil
    end
end

function Watcher:reverseBind(path)
    local dp = Producer.new(self.ob)
    self.dp = dp
    return self.dp
end

function Watcher:reverseUnbind()
    if self.dp then
        self.dp:dispose()
        self.dp = nil
    end
end

function Watcher:dispose()
    self:unbind()
    self:reverseUnbind()
end

return Watcher