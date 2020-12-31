-- This is an automatically generated class by FairyGUI. Please do not modify it.

local MainButton_Show = fgui.extension_class(fgui.GButton)
rawset(MainButton_Show, "__cname", "MainButton_Show")

MainButton_Show.URL = "ui://qp8dts8hbl3nc"

function MainButton_Show:__create()
    return fgui.UIPackage:createObject("Hall", "MainButton_Show")
end

function MainButton_Show:ctor()
    self.Show_up = self:getChild("Show_up")
end

return MainButton_Show