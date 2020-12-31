
local DriverProvider = import("...driver.DriverProvider")
local DriverCtrl = import("...driver.DriverCtrl")
local ReelView = import(".ReelView")
local ReelAnimView = import(".ReelAnimView")
local SlotsView = class("SlotsView", fgui.GComponent)

function SlotsView:ctor()
    self.eventBus = cc.load("event").new()
    self.eventBus:bind(self)
    self.ob = cc.load("mvvm").Observee.__new("slots")
    self.ob:active()
    -- self.ob:setDebug(true)

    self.dataSource = DriverProvider:getInstance()
    self.processor = DriverCtrl.new(self.ob, self.eventBus)

    --fsm
    self.featureStack = {}
    self.fsm = cc.load("fsm").FSM.create({
        initial = {state = "ready", event = "init", defer = true}, 
        events = {
            {name = "push", from = "ready", to = "spin"}, 
            {name = "pop", from = "", to = ""}, 
            {name = "check", from = "", to = ""}, 
        }, 
        callbacks = {
            on_init = function(fsm, event, from, to, msg)
                self:doInit()
            end, 
        }, 
    })

    --life cycle
    self:displayObject():onNodeEvent("enter", handler(self, SlotsView.addUI))
    self:displayObject():onNodeEvent("exit", handler(self, SlotsView.cleanUI))
    self:displayObject():onNodeEvent("cleanup", handler(self, SlotsView.dispose))

    --update
    self:displayObject():scheduleUpdate(handler(self, SlotsView.update))

    --event
    self.spineStartHandler = self.eventBus:addEventListener("spin_start", function(evt)
        self.processor.fsm.start()
    end)
    self.spinStopHandler = self.eventBus:addEventListener("spin_stop", function(evt)
        self.processor.fsm.stop()
    end)
    self.featureNewHandler = self.eventBus:addEventListener("feature_push", function(evt)
        
    end)
    self.featureDelHandler = self.eventBus:addEventListener("feature_pop", function(evt)
        
    end)
    self.featureChkHandler = self.eventBus:addEventListener("feature_check", function(evt)
        
    end)
end

function SlotsView:update(dt)
    self.processor:update(dt)
end

function SlotsView:addUI()
    --init
    self:doInit()
end

function SlotsView:cleanUI()

end

function SlotsView:doInit()
    --test init
    self.processor:initData()
    
    --layout
    self.reel = ReelView.new(self.ob)
    self.reel:setPosition(display.center.x, display.center.y)
    self.anim = ReelAnimView.new(self.ob)
    self.anim:setPosition(display.center.x, display.center.y)

    self:addChild(self.reel)
    self:addChild(self.anim)

    self.reel:initCell()
    self.anim:initCell()
end

function SlotsView:reqStart()
    self.anim:hideAnim()
    if self.dispatchEvent then
        self:dispatchEvent({name="btn_switch", type="disable"})
    end
    local featureFSM = self.featureStack[#self.featureStack]
    featureFSM:reqStart()
end

function SlotsView:reqStop()
    self.anim:hideAnim()
    if self.dispatchEvent then
        self:dispatchEvent({name="btn_switch", type="disable"})
    end
    local featureFSM = self.featureStack[#self.featureStack]
    featureFSM:reqStop()
end

function SlotsView:reqDone()
    local featureFSM = self.featureStack[#self.featureStack]
    featureFSM:reqStop()
end

function SlotsView:pushFeature()
    local feature = 
    table.insert(self.featureStack, feature)
end

function SlotsView:checkFeature()

end

function SlotsView:dispose()
    self.ob:dispose()
    self.ob = nil
    self.eventBus:unbind(self)
    self.eventBus = nil
    self.processor:dispose()
    self.processor = nil
    
    self.spinStartHandler = nil
    self.spinStopHandler = nil
    self.featureNewHandler = nil
    self.featureDelHandler = nil
    self.featureChkHandler = nil
end

return SlotsView