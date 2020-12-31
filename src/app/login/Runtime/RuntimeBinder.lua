-- This is an automatically generated class by FairyGUI. Please do not modify it.

local LaunchLoading = import(".LaunchLoading")
local Launch = import(".Launch")

local RuntimeBinder = class("RuntimeBinder")

function RuntimeBinder:BindAll()
    fgui.register_extension(LaunchLoading.URL, LaunchLoading)
    fgui.register_extension(Launch.URL, Launch)
end

return RuntimeBinder