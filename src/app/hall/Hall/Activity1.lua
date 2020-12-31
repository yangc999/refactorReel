-- This is an automatically generated class by FairyGUI. Please do not modify it.

local Activity1 = fgui.extension_class(fgui.GComponent)
rawset(Activity1, "__cname", "Activity1")

Activity1.URL = "ui://qp8dts8hbl3n1s"

function Activity1:__create()
    return fgui.UIPackage:createObject("Hall", "Activity1")
end

function Activity1:ctor()
    self.group = self:getChild("group")
    self.showAni = self:getTransition("showAni")
    self.hideAni = self:getTransition("hideAni")
end

return Activity1