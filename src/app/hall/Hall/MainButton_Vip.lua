-- This is an automatically generated class by FairyGUI. Please do not modify it.

local MainButton_Vip = fgui.extension_class(fgui.GButton)
rawset(MainButton_Vip, "__cname", "MainButton_Vip")

MainButton_Vip.URL = "ui://qp8dts8hbl3nv"

function MainButton_Vip:__create()
    return fgui.UIPackage:createObject("Hall", "MainButton_Vip")
end

function MainButton_Vip:ctor()
    self.Vip_up = self:getChild("Vip_up")
end

return MainButton_Vip