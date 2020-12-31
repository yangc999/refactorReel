-- This is an automatically generated class by FairyGUI. Please do not modify it.

local MainButton_Gold = fgui.extension_class(fgui.GButton)
rawset(MainButton_Gold, "__cname", "MainButton_Gold")

MainButton_Gold.URL = "ui://qp8dts8hbl3n14"

function MainButton_Gold:__create()
    return fgui.UIPackage:createObject("Hall", "MainButton_Gold")
end

function MainButton_Gold:ctor()
    self.Gold_down = self:getChild("Gold_down")
    self.Gold_up = self:getChild("Gold_up")
end

return MainButton_Gold