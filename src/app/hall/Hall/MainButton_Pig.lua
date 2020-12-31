-- This is an automatically generated class by FairyGUI. Please do not modify it.

local MainButton_Pig = fgui.extension_class(fgui.GButton)
rawset(MainButton_Pig, "__cname", "MainButton_Pig")

MainButton_Pig.URL = "ui://qp8dts8hbl3nx"

function MainButton_Pig:__create()
    return fgui.UIPackage:createObject("Hall", "MainButton_Pig")
end

function MainButton_Pig:ctor()
    self.Pig_up = self:getChild("Pig_up")
end

return MainButton_Pig