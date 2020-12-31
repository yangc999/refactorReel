
local Observee = import(".Observee")
local Producer = class("Producer")

function Producer:ctor(ob)
    self.ob = ob or Observee:getInstance()
end

function Producer:filter(handler)
    self.filterHandler = handler
    self:exec()
    return self
end

function Producer:intercept(handler)
    local oldFunc = handler
    return self
end

function Producer:exec()
    return self
end

function Producer:dispose()
    self.filterHandler = nil
    self.applyHandler = nil
    self.ob = nil
end

return Producer