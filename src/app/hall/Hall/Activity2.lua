-- This is an automatically generated class by FairyGUI. Please do not modify it.

local Activity2 = fgui.extension_class(fgui.GComponent)
rawset(Activity2, "__cname", "Activity2")

Activity2.URL = "ui://qp8dts8hbl3n1x"

function Activity2:__create()
    return fgui.UIPackage:createObject("Hall", "Activity2")
end

function Activity2:ctor()
    self.group = self:getChild("group")
    self.showAni = self:getTransition("showAni")
    self.hideAni = self:getTransition("hideAni")
end

return Activity2