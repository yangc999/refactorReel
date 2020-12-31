
local DriverProvider = import(".DriverProvider")
local DriverBearing = import(".DriverBearing")
local DriverCtrl = class("DriverCtrl")

function DriverCtrl:ctor(ob, outerEvt)
    self.ob = ob
    self.outerEvt = outerEvt
    self.innerEvt = cc.load("event").new()
    self.innerEvt:bind(self)
    self.slotsData = self.ob:add({}, "slots_data")
    self.layoutData = self.ob:add({}, "layout_data")
    self.bearingList = {}

    self.fsm = cc.load("fsm").FSM.create({
        initial = "ready", 
        events = {
            {name = "start",  from = "ready", to = "spin"}, 
            {name = "stop", from = "spin", to = "wait"}, 
            {name = "interrupt", from = "wait", to = "freeze"}, 
            {name = "wait_count", from = "wait", to = "wait"}, 
            {name = "freeze_count", from = "freeze", to = "freeze"}, 
            {name = "wait_done", from = "wait", to = "ready"}, 
            {name = "freeze_done", from = "freeze", to = "ready"}, 
        }, 
        callbacks = {
            --event
            on_start = function(fsm, event, from, to, msg)
                for _, v in ipairs(self.bearingList) do
                    v.fsm.start()
                end
            end, 
            on_stop = function(fsm, event, from, to, msg)
                for _, v in ipairs(self.bearingList) do
                   v:resetCount() 
                end
                self.bearingList[1]:tryStop()
            end, 
            on_interrupt = function(fsm, event, from, to, msg)
                for _, v in ipairs(self.bearingList) do
                    v:tryStop()
                end
            end, 
            on_wait_count = function(fsm, event, from, to, msg)
                self.doneCount = self.doneCount + 1
                --if first stop
                if self.doneCount == 1 then
                    self.outerEvt:dispatchEvent({name="btn_switch", type="stop"})
                --if all stop
                elseif self.doneCount == #self.bearingList then
                    self.fsm.wait_done()
                end
            end, 
            on_freeze_count = function(fsm, event, from, to, msg)
                self.doneCount = self.doneCount + 1
                --if first stop
                if self.doneCount == 1 then
                    self.outerEvt:dispatchEvent({name="btn_switch", type="stop"})
                --if all stop
                elseif self.doneCount == #self.bearingList then
                    self.fsm.freeze_done()
                end
            end, 
            on_wait_done = function(fsm, event, from, to, msg)
                self.outerEvt:dispatchEvent({name="spin_end"})
            end, 
            on_freeze_done = function(fsm, event, from, to, msg)
                self.outerEvt:dispatchEvent({name="spin_end"})
            end, 
            --state
            on_ready = function(fsm, event, from, to, msg)
                self.doneCount = 0
            end, 
        }, 
    })
    self.nextHandler = self.innerEvt:addEventListener("bearing_next", function(evt)
        if self.fsm.current == "wait" then
            local next = evt.idx + 1
            if self.bearingList[next] then
                self.bearingList[next]:tryStop()
            end
        elseif self.fsm.current == "freeze" then
            -- print("do nothing")
        else
            print("fsm error")
        end
    end)
    self.countHandler = self.innerEvt:addEventListener("bearing_freeze", function(evt)
        if self.fsm.current == "wait" then
            self.fsm.wait_count()
        elseif self.fsm.current == "freeze" then
            self.fsm.freeze_count()
        else
            print("fsm error")
        end
    end)

end

function DriverCtrl:initData()
    self:initSlots()
    self:initLayout()
end

function DriverCtrl:initSlots()
    local dataSource = DriverProvider:getInstance()
    local slotsData = dataSource.sdata
    for i=1, slotsData.col do
        local bearing = DriverBearing.new(self.slotsData, self.innerEvt)
        local cfg = self:filterBearingCfg(slotsData, i)
        bearing:initData(cfg)
        table.insert(self.bearingList, bearing)
    end
end

function DriverCtrl:initLayout()
    local dataSource = DriverProvider:getInstance()
    self.layoutData = self.ob:add(dataSource:reelClippingCfg(), "layout_data")
end

function DriverCtrl:update(dt)
    for _, v in ipairs(self.bearingList) do
        v:update(dt)
    end
end

function DriverCtrl:filterBearingCfg(prototype, index)
    local tbl = {}
    tbl.index = index
    tbl.viewType = prototype.viewType
    tbl.row = prototype.row
    tbl.lineWidth = prototype.lineWidth
    tbl.cellMaxNum = prototype.cellMaxNum
    tbl.cellWidth = prototype.cellWidth
    tbl.cellHeight = prototype.cellHeight
    tbl.show = prototype.rcList[index]
    tbl.wish = prototype.rcListWish[index]
    return tbl
end

function DriverCtrl:filterCfg(prototype, index)
    local tbl = {}
    tbl.index = index
    tbl.viewType = prototype.viewType
    tbl.row = prototype.row
    tbl.lineWidth = prototype.lineWidth
    tbl.cellMaxNum = prototype.cellMaxNum
    tbl.cellWidth = prototype.cellWidth
    tbl.cellHeight = prototype.cellHeight
    tbl.show = prototype.rcList[index]
    tbl.wish = prototype.rcListWish[index]
    return tbl
end

function DriverCtrl:dispose()
    self.innerEvt:unbind(self)
    self.innerEvt = nil
    self.cache = nil
    for _, v in ipairs(self.bearingList) do
        v:dispose()
    end
    self.bearingList = nil
    self.countHandler = nil
    self.nextHandler = nil
end

return DriverCtrl