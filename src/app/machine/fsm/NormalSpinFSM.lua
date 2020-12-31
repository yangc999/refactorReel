
local NormalSpinFSM = class("NormalSpinFSM")

function NormalSpinFSM:ctor(evt, ob)
    self.evt = evt
    self.ob = ob

    self.fsm = cc.load("fsm").FSM.create({
        initial = {state = "ready", event = "init", defer = true}, 
        events = {
            {name = "start",  from = "ready", to = "spin"}, 
            {name = "result", from = "spin", to = "await_stop"}, 
            {name = "balance", from = "await_stop", to = "await_balance"}, 
            {name = "draw", from = "await_balance", to = "continue"}, 
            {name = "win", from = "await_balance", to = "await_win"}, 
            {name = "finish", from = "await_win", to = "continue"}, 
            {name = "done", from = "continue", to = "ready"}, 
        }, 
        callbacks = {
            --event
            on_init = function(fsm, event, from, to, msg)
                self:doInit()
            end, 
            on_start = function(fsm, event, from, to, msg)
                self:doStart()
            end, 
            on_result = function(fsm, event, from, to, msg)
                self:doResult(msg)
            end, 
            on_balance = function(fsm, event, from, to, msg)
                self:doBalance()
            end, 
            on_draw = function(fsm, event, from, to, msg)
                self:doDraw()
            end, 
            on_win = function(fsm, event, from, to, msg)
                self:doWin()
            end, 
            on_finish = function(fsm, event, from, to, msg)
                self:doFinish()
            end, 
            on_done = function(fsm, event, from, to, msg)
                self:doDone()
            end, 
            --state
            on_await_balance = function(fsm, event, from, to, msg)
                if self.data.wChips == 0 then
                    fsm.draw()
                else
                    fsm.win()
                end
            end, 
            on_continue = function(fsm, event, from, to, msg)
                self.evt:dispatchEvent({name="feature_check"})
            end,
        }, 
    })

    --event
    self.spinHandler = self.evt:addEventListener("spin_end", function(evt)
        self.fsm.balance()
    end)
    self.winHandler = self.evt:addEventListener("win_end", function(evt)
        self.fsm.finish()
    end)
end

function NormalSpinFSM:reqStart()
    self.fsm.start()
end

function NormalSpinFSM:reqStop()
    self.fsm.interrupt()
end

function NormalSpinFSM:reqDone()
    self.fsm.done()
end

function NormalSpinFSM:doInit()

end

function NormalSpinFSM:doStart()
    self.evt:dispatchEvent({name="spin_start"})
    --request
    local Promise = cc.load("promise").Promise
    local http = g_app:getService("http")
    http:post("http://192.168.1.191:48113/slotsTest/v1/spin", cjson.encode({userId=1})):andThen(function(resp)
        local data = cjson.decode()
        if data and data.retCode == 0 then
            return Promise.resolve(data.returnData)
        else
            return Promise.reject("invalid return")
        end
    end):andThen(function(data)
        self.fsm.result(data)
    end):catch(function(err)
        print("error:", er)
    end)
end

function NormalSpinFSM:doResult(data)
    self.data = data
    self.evt:dispatchEvent({name="spin_stop"})
    --data
    if data.feature then
        self.evt:dispatchEvent({name="", data=data.feature})
    end
end

function NormalSpinFSM:doBalance()

end

function NormalSpinFSM:doDraw()

end

function NormalSpinFSM:doWin()
    --play win stuff
    
end

function NormalSpinFSM:doFinish()
    --clean win stuff

end

function NormalSpinFSM:doDone()
    --sku

end

function NormalSpinFSM:dispose()
    self.spinHandler = nil
    self.winHandler = nil
end

return NormalSpinFSM