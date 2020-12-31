-- This is an automatically generated class by FairyGUI. Please do not modify it.

local MainButton_Seting = fgui.extension_class(fgui.GButton)
rawset(MainButton_Seting, "__cname", "MainButton_Seting")

MainButton_Seting.URL = "ui://qp8dts8hbl3nz"

function MainButton_Seting:__create()
    return fgui.UIPackage:createObject("Hall", "MainButton_Seting")
end

function MainButton_Seting:ctor()
    self.Seting_up = self:getChild("Seting_up")
end

return MainButton_Seting