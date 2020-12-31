-- This is an automatically generated class by FairyGUI. Please do not modify it.

local MainButton_Lanterns = fgui.extension_class(fgui.GButton)
rawset(MainButton_Lanterns, "__cname", "MainButton_Lanterns")

MainButton_Lanterns.URL = "ui://qp8dts8hbl3n2"

function MainButton_Lanterns:__create()
    return fgui.UIPackage:createObject("Hall", "MainButton_Lanterns")
end

function MainButton_Lanterns:ctor()
    self.Lanterns_up = self:getChild("Lanterns_up")
end

return MainButton_Lanterns