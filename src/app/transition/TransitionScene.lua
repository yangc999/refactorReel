
local TransitionScene = class("TransitionScene", cc.Scene)

function TransitionScene:ctor()
    self:onNodeEvent("enter", handler(self, TransitionScene.addUI))
    self:onNodeEvent("exit", handler(self, TransitionScene.cleanUI))
    self:onNodeEvent("cleanup", handler(self, TransitionScene.dispose))

    --test update
    self:scheduleUpdate(handler(self, TransitionScene.update))

    --binding
    local cache = g_app:getService("cache")
    self.vo = cache.ob:add({}, "trans")
    self.vo.pb = 0
end

function TransitionScene:addUI()
    fgui.UIPackage:addPackage("Load")
    cc.FileUtils:getInstance():addSearchPath("src/app/transition")
    import("Load.LoadBinder"):BindAll()
    self.view = import("Load.Load").new()
    fgui.GRoot:getInstance():addChild(self.view)

    --binding
    self.pbVm = cc.load("mvvm").Watcher.new()
    self.pbVm:bind("trans.pb"):apply(function(pb)
        self.view.loading:setValue(tonumber(pb))
    end):exec()
    self.txVm = cc.load("mvvm").Watcher.new()
    self.txVm:bind("trans.pb"):filter(function(pb)
        local num = math.min(100, math.max(0, pb))
        return string.format("%d%%", math.floor(num))
    end):apply(function(text)
        self.view.progress:setText(text)
    end):exec()
end

function TransitionScene:cleanUI()
    self.pbVm:dispose()
    self.txVm:dispose()
    self.pbVm = nil
    self.txVm = nil
end

function TransitionScene:dispose()
    local cache = g_app:getService("cache")
    cache.ob:remove("trans")
end

function TransitionScene:update(dt)
    self.vo.pb = self.vo.pb + dt*120
    if self.vo.pb > 100 then
        --test update
        self:unscheduleUpdate()
        local scene = g_app:getService("scene")
        scene.fsm.loadSucc()
    end  
end

return TransitionScene