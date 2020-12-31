-- This is an automatically generated class by FairyGUI. Please do not modify it.

local Activity1Group = fgui.extension_class(fgui.GComponent)
rawset(Activity1Group, "__cname", "Activity1Group")

Activity1Group.URL = "ui://qp8dts8hbl3n1y"

function Activity1Group:__create()
    return fgui.UIPackage:createObject("Hall", "Activity1Group")
end

function Activity1Group:ctor()
    self.button_Close = self:getChild("button_Close")
end

return Activity1Group