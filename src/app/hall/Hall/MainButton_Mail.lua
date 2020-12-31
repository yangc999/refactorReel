-- This is an automatically generated class by FairyGUI. Please do not modify it.

local MainButton_Mail = fgui.extension_class(fgui.GButton)
rawset(MainButton_Mail, "__cname", "MainButton_Mail")

MainButton_Mail.URL = "ui://qp8dts8hbl3n1j"

function MainButton_Mail:__create()
    return fgui.UIPackage:createObject("Hall", "MainButton_Mail")
end

function MainButton_Mail:ctor()
    self.Mail_up = self:getChild("Mail_up")
end

return MainButton_Mail