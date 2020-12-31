-- This is an automatically generated class by FairyGUI. Please do not modify it.

local MainButton_Ticket = fgui.extension_class(fgui.GButton)
rawset(MainButton_Ticket, "__cname", "MainButton_Ticket")

MainButton_Ticket.URL = "ui://qp8dts8hbl3n11"

function MainButton_Ticket:__create()
    return fgui.UIPackage:createObject("Hall", "MainButton_Ticket")
end

function MainButton_Ticket:ctor()
    self.Ticket_up = self:getChild("Ticket_up")
end

return MainButton_Ticket