
local FiveDragonFSM = class("FiveDragonFSM")

function FiveDragonFSM:ctor(evt, ob)
    self.evt = evt
    self.ob = ob

    self.fsm = cc.load("fsm").FSM.create({
        initial = {state = "ready", event = "init", defer = true}, 
        events = {
            {name = "start", from = "ready", to = "spin"}, 
            {name = "stop", from = "spin", to = "await_resp"}, 
            {name = "result", from = "await_resp", to = "await_stop"}, 
            {name = "balance", from = "await_stop", to = "await_calc"}, 
            {name = "done", from = "await_calc", to = "ready"}, 
        }, 
        callbacks = {
            on_init = function(fsm, event, from, to, msg)
                self:doInit()
            end, 
            on_start = function(fsm, event, from, to, msg)
                self:doStart()
            end, 
            on_stop = function(fsm, event, from, to, msg)
                self:doStop()
            end, 
            on_result = function(fsm, event, from, to, msg)
                self:doResult()
            end, 
            on_balance = function(fsm, event, from, to, msg)
                self:doBalance()
            end, 
            on_done = function(fsm, event, from, to, msg)
                self:doDone()
            end, 
        }, 
    })
end

function FiveDragonFSM:reqStart()

end

function FiveDragonFSM:reqStop()

end

return FiveDragonFSM