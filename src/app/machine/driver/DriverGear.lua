
local DriveGear = {}

function DriveGear.new()
    return {
        tag = 0, 
        width = 0, 
        height = 0, 
        max_link = 1, 
        posx = 0, 
        posy = 0, 
        zorder = 0, 
        row = 0, 
        col = 0, 
        element = 0, 
        anim = "", 
        show = false, 
        ready = false, 
    }
end

return DriveGear