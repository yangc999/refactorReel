
local IService = import(".IService")
local EventService = class("EventService", IService)
EventService.__new = EventService.new
EventService.new = nil

function EventService:getInstance()
    if not self.inst then
        self.inst = EventService.__new()
    end
    return self.inst
end

function EventService:ctor()
    self.event = cc.load("event").new()
end

function EventService:getBus()
    return self.event
end

function EventService:start()
    self.event:bind(self)
end

function EventService:stop()
    self.event:unbind(self)
end

return EventService