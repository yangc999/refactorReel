-- This is an automatically generated class by FairyGUI. Please do not modify it.

local MainButton_Gift = fgui.extension_class(fgui.GButton)
rawset(MainButton_Gift, "__cname", "MainButton_Gift")

MainButton_Gift.URL = "ui://qp8dts8hbl3n19"

function MainButton_Gift:__create()
    return fgui.UIPackage:createObject("Hall", "MainButton_Gift")
end

function MainButton_Gift:ctor()
    self.Gift_up = self:getChild("Gift_up")
end

return MainButton_Gift