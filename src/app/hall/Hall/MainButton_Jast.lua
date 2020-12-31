-- This is an automatically generated class by FairyGUI. Please do not modify it.

local MainButton_Jast = fgui.extension_class(fgui.GButton)
rawset(MainButton_Jast, "__cname", "MainButton_Jast")

MainButton_Jast.URL = "ui://qp8dts8hbl3nt"

function MainButton_Jast:__create()
    return fgui.UIPackage:createObject("Hall", "MainButton_Jast")
end

function MainButton_Jast:ctor()
    self.Jast_up = self:getChild("Jast_up")
end

return MainButton_Jast