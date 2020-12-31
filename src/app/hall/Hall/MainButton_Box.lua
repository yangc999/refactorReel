-- This is an automatically generated class by FairyGUI. Please do not modify it.

local MainButton_Box = fgui.extension_class(fgui.GButton)
rawset(MainButton_Box, "__cname", "MainButton_Box")

MainButton_Box.URL = "ui://qp8dts8hbl3n1h"

function MainButton_Box:__create()
    return fgui.UIPackage:createObject("Hall", "MainButton_Box")
end

function MainButton_Box:ctor()
    self.Box_up = self:getChild("Box_up")
end

return MainButton_Box