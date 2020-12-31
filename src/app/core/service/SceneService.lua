
local IService = import(".IService")
local SceneService = class("SceneService", IService)
SceneService.__new = SceneService.new
SceneService.new = nil

function SceneService:getInstance()
    if not self.inst then
        self.inst = SceneService.__new()
    end
    return self.inst
end

function SceneService:ctor()
    self.fsm = cc.load("fsm").FSM.create({
        initial = {state = "login", event = "init", defer = true}, 
        events = {
            {name = "loginSucc",  from = "login", to = "hall"}, 
            {name = "checkSucc", from = "hall", to = "trans"}, 
            {name = "loadSucc",  from = "trans", to = "game"}, 
            {name = "quitSucc",  from = "game", to = "hall"}, 
            {name = "logoutSucc", from = "hall", to = "login"}, 
        }, 
        callbacks = {
            on_login = function(fsm, event, from, to, msg)  
                local login = import("app.login.LoginScene")
                self:replace(login)
            end, 
            on_hall = function(fsm, event, from, to, msg)
                local hall = import("app.hall.HallScene")
                self:replace(hall)
            end, 
            on_trans = function(fsm, event, from, to, msg)
                local trans = import("app.transition.TransitionScene")
                self:replace(trans)
            end, 
            on_game = function(fsm, event, from, to, msg)
                local game = import("app.demo.DemoScene")
                self:replace(game)
            end, 
        }, 
    })
end

function SceneService:start()
    self.fsm.init()
end

function SceneService:stop()

end

function SceneService:replace(sceneCls)
    local scene = sceneCls.new()
    self.UIRoot = fgui.GRoot:create(scene)
    self.UIRoot:retain()
    --GRoot will be autoreleased next frame
    display.runScene(scene)
end

return SceneService