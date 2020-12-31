-- This is an automatically generated class by FairyGUI. Please do not modify it.

local LaunchLoading = fgui.extension_class(fgui.GProgressBar)
rawset(LaunchLoading, "__cname", "LaunchLoading")

LaunchLoading.URL = "ui://1n4czledhf2n3"

function LaunchLoading:__create()
    return fgui.UIPackage:createObject("Runtime", "LaunchLoading")
end

function LaunchLoading:ctor()
    self.bg = self:getChild("bg")
end

return LaunchLoading