-- This is an automatically generated class by FairyGUI. Please do not modify it.

local MainButton_Activity = fgui.extension_class(fgui.GButton)
rawset(MainButton_Activity, "__cname", "MainButton_Activity")

MainButton_Activity.URL = "ui://qp8dts8hbl3n8"

function MainButton_Activity:__create()
    return fgui.UIPackage:createObject("Hall", "MainButton_Activity")
end

function MainButton_Activity:ctor()
    self.Activity_up = self:getChild("Activity_up")
end

return MainButton_Activity