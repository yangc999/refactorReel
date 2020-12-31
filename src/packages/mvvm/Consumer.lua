
local Observee = import(".Observee")
local Consumer = class("Consumer")

function Consumer:ctor(ob)
    self.ob = ob or Observee:getInstance()
    self.paths = {}
    self.handlers = {}
    self.values = {}
end

function Consumer:setDebug(flag)
    self.debug = flag
end

function Consumer:bind(path)
    table.insert(self.paths, path)
    return self
end

function Consumer:onValueInit()
    local ob = self.ob
    for _, path in ipairs(self.paths) do
        self.values[path] = ob:get(path)
    end
    local ret, retTab = nil, {}
    for idx, path in ipairs(self.paths) do
        retTab[idx] = self.values[path]
    end
    if self.debug then
        dump(retTab, "valueMap init")
    end
    if self.filterHandler then
        ret = table.pack(self.filterHandler(table.unpack(retTab)))
    else
        ret = retTab
    end
    if self.applyHandler then
        self.applyHandler(table.unpack(ret))
    end    
end

function Consumer:onValueChanged(path, value, oldValue)
    if self.debug then
        print("path:", path)
        dump(self.paths, "watch paths")
        dump(value, "newValue")
        dump(oldValue, "oldValue")
    end
    if not table.indexof(self.paths, path) then
        print("path error:", path)
        return
    end
    self.values[path] = value
    local ret, retTab = nil, {}
    for idx, path in ipairs(self.paths) do
        retTab[idx] = self.values[path]
    end
    if self.debug then
        dump(retTab, "valueMap after changed")
    end
    if self.filterHandler then
        ret = table.pack(self.filterHandler(table.unpack(retTab)))
    else
        ret = retTab
    end
    if self.applyHandler then
        self.applyHandler(table.unpack(ret))
    end
end

function Consumer:filter(handler)
    self.filterHandler = handler
    return self
end

function Consumer:apply(handler)
    self.applyHandler = handler
    return self
end

function Consumer:eventCallback(evt)
    local ob = self.ob
    local msg = string.lower(evt.name)
    local head, tail = string.find(msg, string.format("%s.", ob.tag))
    if head == 1 and tail == 1+#ob.tag then
        local path = string.sub(msg, tail+1)
        self:onValueChanged(path, evt.new, evt.old)
    end
end

function Consumer:exec()
    local ob = self.ob
    for _, path in ipairs(self.paths) do
        local _, handler = ob:addEventListener(string.format("%s.%s", ob.tag, path), handler(self, Consumer.eventCallback))
        self.handlers[path] = handler
    end
    self:onValueInit()
    return self
end

function Consumer:dispose()
    local ob = self.ob
    self.filterHandler = nil
    self.applyHandler = nil
    for _, handler in pairs(self.handlers) do
        ob:removeEventListener(handler)
    end
    self.paths = nil
    self.handlers = nil
    self.values = nil
    self.ob = nil
end

return Consumer