
local App = class("App")
App.__new = App.new
App.new = nil
App.serviceList = {
    {name="cache", path="app.core.service.CacheService"}, 
    {name="event", path="app.core.service.EventService"}, 
    {name="sound", path="app.core.service.SoundService"}, 
    {name="scene", path="app.core.service.SceneService"}, 
    {name="locale", path="app.core.service.LocaleService"}, 
    {name="http", path="app.core.service.HttpService"}, 
}

function App:getInstance()
    if not self.inst then
        self.inst = App.__new()
    end
    return self.inst
end

function App:ctor()
    self.services = {}
    self:initService()
end

function App:initService()
    for _, v in ipairs(self.serviceList) do
        local module = import(v.path)
        self.services[v.name] = module
    end
end

function App:getService(key)
    return self.services[key]:getInstance()
end

function App:startup()
    for _, cfg in pairs(self.serviceList) do
        self:getService(cfg.name):start()
    end
end

return App