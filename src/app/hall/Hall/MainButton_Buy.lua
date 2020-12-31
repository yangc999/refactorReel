-- This is an automatically generated class by FairyGUI. Please do not modify it.

local MainButton_Buy = fgui.extension_class(fgui.GButton)
rawset(MainButton_Buy, "__cname", "MainButton_Buy")

MainButton_Buy.URL = "ui://qp8dts8hbl3nr"

function MainButton_Buy:__create()
    return fgui.UIPackage:createObject("Hall", "MainButton_Buy")
end

function MainButton_Buy:ctor()
    self.Buy_up = self:getChild("Buy_up")
end

return MainButton_Buy