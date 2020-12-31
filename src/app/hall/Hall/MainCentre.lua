-- This is an automatically generated class by FairyGUI. Please do not modify it.

local MainCentre = fgui.extension_class(fgui.GComponent)
rawset(MainCentre, "__cname", "MainCentre")

MainCentre.URL = "ui://qp8dts8hbl3nd"

function MainCentre:__create()
    return fgui.UIPackage:createObject("Hall", "MainCentre")
end

function MainCentre:ctor()
    self.button_Lanterns = self:getChild("button_Lanterns")
    self.button_Wild = self:getChild("button_Wild")
    self.button_Hot = self:getChild("button_Hot")
    self.button_Activity = self:getChild("button_Activity")
    self.button_Ruby = self:getChild("button_Ruby")
    self.button_Show = self:getChild("button_Show")
end

return MainCentre