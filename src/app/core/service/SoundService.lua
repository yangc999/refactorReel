
local IService = import(".IService")
local SoundService = class("SoundService", IService)
SoundService.__new = SoundService.new
SoundService.new = nil

function SoundService:getInstance()
    if not self.inst then
        self.inst = SoundService.__new()
    end
    return self.inst
end

function SoundService:ctor()
    self.handlers = {}
end

function SoundService:start()
    fgui.UIConfig.onMusicCallback = function(path)
        
    end
end

function SoundService:stop()
    fgui.UIConfig.onMusicCallback = nil
end

return SoundService