-- This is an automatically generated class by FairyGUI. Please do not modify it.

local MainButton_Day = fgui.extension_class(fgui.GButton)
rawset(MainButton_Day, "__cname", "MainButton_Day")

MainButton_Day.URL = "ui://qp8dts8hbl3n1d"

function MainButton_Day:__create()
    return fgui.UIPackage:createObject("Hall", "MainButton_Day")
end

function MainButton_Day:ctor()
    self.Day_up = self:getChild("Day_up")
end

return MainButton_Day