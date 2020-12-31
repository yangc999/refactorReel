-- This is an automatically generated class by FairyGUI. Please do not modify it.

local Activity2Group = fgui.extension_class(fgui.GComponent)
rawset(Activity2Group, "__cname", "Activity2Group")

Activity2Group.URL = "ui://qp8dts8hbl3n1z"

function Activity2Group:__create()
    return fgui.UIPackage:createObject("Hall", "Activity2Group")
end

function Activity2Group:ctor()
    self.button_Close = self:getChild("button_Close")
end

return Activity2Group