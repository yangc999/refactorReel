
local HallScene = class("HallScene", cc.Scene)

function HallScene:ctor()
    self:onNodeEvent("enter", handler(self, HallScene.addUI))
    self:onNodeEvent("exit", handler(self, HallScene.cleanUI))
    self:onNodeEvent("cleanup", handler(self, HallScene.dispose))
end

function HallScene:addUI()
    fgui.UIPackage:addPackage("Hall")
    cc.FileUtils:getInstance():addSearchPath("src/app/hall")
    import("Hall.HallBinder"):BindAll()
    self.view = import("Hall.Hall").new()
    fgui.GRoot:getInstance():addChild(self.view)

    --for demo
    -- self.view.topBar.button_Buy:addEventListener(fgui.UIEventType.Click, function(sender)
        
    -- end)
    self.view.centre.button_Wild:addEventListener(fgui.UIEventType.Click, function(sender)
        local scene = g_app:getService("scene")
        scene.fsm.checkSucc()
    end)
    self.view.topBar.button_Seting:addEventListener(fgui.UIEventType.Click, function(sender)
        local scene = g_app:getService("scene")
        scene.fsm.logoutSucc()
    end)
end

function HallScene:cleanUI()

end

function HallScene:dispose()

end

function HallScene:update()

end

return HallScene