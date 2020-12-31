
local DemoScene = class("DemoScene", cc.Scene)

function DemoScene:ctor()
    self:onNodeEvent("enter", handler(self, DemoScene.addUI))
    self:onNodeEvent("exit", handler(self, DemoScene.cleanUI))
    self:onNodeEvent("cleanup", handler(self, DemoScene.dispose))
end

function DemoScene:addUI()
    fgui.UIPackage:addPackage("Machine")
    fgui.UIPackage:addPackage("Icon")

    cc.FileUtils:getInstance():addSearchPath("src/app/demo")
    import("Machine.MachineBinder"):BindAll()
    self.view = import("Machine.Machine").new()
    fgui.GRoot:getInstance():addChild(self.view)

    --slots
    self.slots = import("app.machine.view.spin.SlotsView").new()
    self.slots:setSize(display.width, display.height)
    fgui.GRoot:getInstance():addChild(self.slots)

    --spin click
    self.btnType = "enable"
    self.view.button_Spin:addEventListener(fgui.UIEventType.Click, function(sender)
        if self.btnType == "enable" then
            --stop
            self.slots:reqStart()
        elseif self.btnType == "disable" then

        elseif self.btnType == "stop" then
            --spin
            self.slots:reqStop()
        end
    end)
    --spin auto
    self.view.button_Spin:addEventListener(fgui.UIEventType.TouchBegin, function(sender)

    end)
    self.view.button_Spin:addEventListener(fgui.UIEventType.TouchEnd, function(sender)

    end)

    --switch spinBtn status
    self.spinHandler = self.slots:addEventListener("btn_switch", function(evt)
        self.btnType = evt.type
        if self.btnType == "enable" then
            self.view.button_Spin:setGrayed(false)
        elseif self.btnType == "disable" then
            self.view.button_Spin:setGrayed(true)
        elseif self.btnType == "stop" then
            self.view.button_Spin:setGrayed(false)
        end
    end)

    --for demo quit
    self.view.button_Main:addEventListener(fgui.UIEventType.Click, function(sender)
        local scene = g_app:getService("scene")
        scene.fsm.quitSucc()
    end)

    --switch quitBtn status
    self.quitHandler = self.slots:addEventListener("", function(evt)

    end)

    --switch scene status
    self.sceneHandler = self.slots:addEventListener("scene_switch", function(evt)

    end)
end

function DemoScene:cleanUI()
    
end

function DemoScene:dispose()
    self.slots = nil
    self.spinHandler = nil
    self.quitHandler = nil
    self.sceneHandler = nil
end

return DemoScene