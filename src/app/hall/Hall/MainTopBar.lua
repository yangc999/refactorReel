-- This is an automatically generated class by FairyGUI. Please do not modify it.

local MainTopBar = fgui.extension_class(fgui.GComponent)
rawset(MainTopBar, "__cname", "MainTopBar")

MainTopBar.URL = "ui://qp8dts8hbl3n16"

function MainTopBar:__create()
    return fgui.UIPackage:createObject("Hall", "MainTopBar")
end

function MainTopBar:ctor()
    self.buyCtrl = self:getController("buyCtrl")
    self.goldText = self:getChild("goldText")
    self.starText = self:getChild("starText")
    self.ticked = self:getChild("ticked")
    self.button_Buy = self:getChild("button_Buy")
    self.button_Jast = self:getChild("button_Jast")
    self.button_Vip = self:getChild("button_Vip")
    self.button_Pig = self:getChild("button_Pig")
    self.button_Seting = self:getChild("button_Seting")
    self.button_Ticket = self:getChild("button_Ticket")
    self.button_Gold = self:getChild("button_Gold")
end

return MainTopBar