-- This is an automatically generated class by FairyGUI. Please do not modify it.

local MainButton_Ruby = fgui.extension_class(fgui.GButton)
rawset(MainButton_Ruby, "__cname", "MainButton_Ruby")

MainButton_Ruby.URL = "ui://qp8dts8hbl3n9"

function MainButton_Ruby:__create()
    return fgui.UIPackage:createObject("Hall", "MainButton_Ruby")
end

function MainButton_Ruby:ctor()
    self.Ruby_up = self:getChild("Ruby_up")
end

return MainButton_Ruby