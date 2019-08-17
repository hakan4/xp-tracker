Printer = {}

function Printer:FormatCommand(command, description)
    return string.format('|cffffcc00[|cff666666%s|cffffcc00]  |cffffffff%s', command, description)
end

function Printer:Loaded()
    local messages = {
        'XpTracker Addon Loaded',
        '|cffffcc00/xpt help |cffffffff - for additional commands'
    }
    for _, message in ipairs(messages) do 
        self:Print(message)
    end
end

function Printer:Help()
    local messages = {
        '|cffC41F3BCOMMANDS', 
        '|cffffcc00/xpt |cffffcc00[|cff666666COMMAND|cffffcc00]',
        self:FormatCommand('RESET', 'resets the Session XP tracking'),
        self:FormatCommand('HELP', 'shows the help'),
        self:FormatCommand('LOCK', 'locks the frame in position'),
        self:FormatCommand('UNLOCK', 'unlocks the frame')
    }
    for _, message in ipairs(messages) do 
        self:Print(message)
    end
end

function Printer:Print(message)
	if(DEFAULT_CHAT_FRAME) then
		DEFAULT_CHAT_FRAME:AddMessage('[XpTracker] '..message)
	end
end