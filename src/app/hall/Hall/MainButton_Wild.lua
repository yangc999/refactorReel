-- This is an automatically generated class by FairyGUI. Please do not modify it.

local MainButton_Wild = fgui.extension_class(fgui.GButton)
rawset(MainButton_Wild, "__cname", "MainButton_Wild")

MainButton_Wild.URL = "ui://qp8dts8hbl3n4"

function MainButton_Wild:__create()
    return fgui.UIPackage:createObject("Hall", "MainButton_Wild")
end

function MainButton_Wild:ctor()
    self.Wild_up = self:getChild("Wild_up")
end

return MainButton_Wild