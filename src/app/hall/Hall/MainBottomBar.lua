-- This is an automatically generated class by FairyGUI. Please do not modify it.

local MainBottomBar = fgui.extension_class(fgui.GComponent)
rawset(MainBottomBar, "__cname", "MainBottomBar")

MainBottomBar.URL = "ui://qp8dts8hbl3n1m"

function MainBottomBar:__create()
    return fgui.UIPackage:createObject("Hall", "MainBottomBar")
end

function MainBottomBar:ctor()
    self.Inbox0 = self:getChild("Inbox0")
    self.Inbox1 = self:getChild("Inbox1")
    self.Inbox2 = self:getChild("Inbox2")
    self.Inbox3 = self:getChild("Inbox3")
    self.Inbox4 = self:getChild("Inbox4")
    self.Inbox4_2 = self:getChild("Inbox4")
    self.button_Gift = self:getChild("button_Gift")
    self.button_Task = self:getChild("button_Task")
    self.button_Day = self:getChild("button_Day")
    self.button_Box = self:getChild("button_Box")
    self.button_Mail = self:getChild("button_Mail")
    self.button_Rotary = self:getChild("button_Rotary")
end

return MainBottomBar