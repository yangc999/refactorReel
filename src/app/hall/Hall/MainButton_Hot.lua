-- This is an automatically generated class by FairyGUI. Please do not modify it.

local MainButton_Hot = fgui.extension_class(fgui.GButton)
rawset(MainButton_Hot, "__cname", "MainButton_Hot")

MainButton_Hot.URL = "ui://qp8dts8hbl3n6"

function MainButton_Hot:__create()
    return fgui.UIPackage:createObject("Hall", "MainButton_Hot")
end

function MainButton_Hot:ctor()
    self.Hot_up = self:getChild("Hot_up")
end

return MainButton_Hot