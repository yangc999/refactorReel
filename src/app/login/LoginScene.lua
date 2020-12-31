
local LoginScene = class("LoginScene", cc.Scene)

function LoginScene:ctor()
    self:onNodeEvent("enter", handler(self, LoginScene.addUI))
    self:onNodeEvent("exit", handler(self, LoginScene.cleanUI))
    self:onNodeEvent("cleanup", handler(self, LoginScene.dispose))

    --test update
    self:scheduleUpdate(handler(self, LoginScene.update))

    --binding
    local cache = g_app:getService("cache")
    self.vo = cache.ob:add({}, "load")
    self.vo.pb = 0
end

function LoginScene:addUI()
    fgui.UIPackage:addPackage("Runtime")
    cc.FileUtils:getInstance():addSearchPath("src/app/login")
    import("Runtime.RuntimeBinder"):BindAll()
    self.view = import("Runtime.Launch").new()
    fgui.GRoot:getInstance():addChild(self.view)

    --binding
    self.pbVm = cc.load("mvvm").Watcher.new()
    self.pbVm:bind("load.pb"):apply(function(pb)
        self.view.loading:setValue(tonumber(pb))
    end):exec()
    self.txVm = cc.load("mvvm").Watcher.new()
    self.txVm:bind("load.pb"):filter(function(pb)
        local num = math.min(100, math.max(0, pb))
        return string.format("%d%%", math.floor(num))
    end):apply(function(text)
        self.view.progressText:setText(text)
    end):exec()
end

function LoginScene:cleanUI()
    self.pbVm:dispose()
    self.txVm:dispose()
    self.pbVm = nil
    self.txVm = nil
end

function LoginScene:dispose()
    local cache = g_app:getService("cache")
    cache.ob:remove("load")
end

function LoginScene:update(dt)
    self.vo.pb = self.vo.pb + dt*120
    if self.vo.pb > 100 then
        --test update
        self:unscheduleUpdate()
        local scene = g_app:getService("scene")
        scene.fsm.loginSucc()
    end
end

return LoginScene
