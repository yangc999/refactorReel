-- This is an automatically generated class by FairyGUI. Please do not modify it.

local MainButton_Rotary = fgui.extension_class(fgui.GButton)
rawset(MainButton_Rotary, "__cname", "MainButton_Rotary")

MainButton_Rotary.URL = "ui://qp8dts8hbl3n1l"

function MainButton_Rotary:__create()
    return fgui.UIPackage:createObject("Hall", "MainButton_Rotary")
end

function MainButton_Rotary:ctor()
    self.Rotary_up = self:getChild("Rotary_up")
end

return MainButton_Rotary