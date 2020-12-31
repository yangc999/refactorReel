-- This is an automatically generated class by FairyGUI. Please do not modify it.

local Activity1Button_Close = fgui.extension_class(fgui.GButton)
rawset(Activity1Button_Close, "__cname", "Activity1Button_Close")

Activity1Button_Close.URL = "ui://qp8dts8hbl3n1r"

function Activity1Button_Close:__create()
    return fgui.UIPackage:createObject("Hall", "Activity1Button_Close")
end

function Activity1Button_Close:ctor()
    self.close_down = self:getChild("close_down")
    self.close_up = self:getChild("close_up")
end

return Activity1Button_Close