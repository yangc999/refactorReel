-- This is an automatically generated class by FairyGUI. Please do not modify it.

local Activity2Button_Close = fgui.extension_class(fgui.GButton)
rawset(Activity2Button_Close, "__cname", "Activity2Button_Close")

Activity2Button_Close.URL = "ui://qp8dts8hbl3n1w"

function Activity2Button_Close:__create()
    return fgui.UIPackage:createObject("Hall", "Activity2Button_Close")
end

function Activity2Button_Close:ctor()
    self.close_up = self:getChild("close_up")
    self.close_down = self:getChild("close_down")
end

return Activity2Button_Close