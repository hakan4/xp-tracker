XpTracker_SavedVariables = { }

local events = {}
local session, level, updateTimer


-- UI SCRIPTS --

function XpTracker_OnLoad()
	for k, v in pairs(events) do
		XpTracker_Frame:RegisterEvent(k);
	end
	XpTracker_Frame_TitleText:SetText('|cffFF7D0ASTATS')
	SLASH_XpTracker1 = "/xptracker"
	SLASH_XpTracker2 = "/xpt"
	SlashCmdList["XpTracker"] = XpTracker_SlashCmd

	print("Loaded XpTracker Addon")
end

function XpTracker_OnEvent(self, event, ...)
	events[event](self, event, ...)
end

function XpTracker_OnUpdate(self, elapsed)
	level:UpdateTime(elapsed)
end

function XpTracker_SlashCmd(msg)
	if(msg == 'reset') then
		XpTracker_OnReset()
	end
end

function XpTracker_OnReset(self, ...)
	session = Session:Create()
	XpTracker_UpdateUI()
end


-- EVENT HANDLERS --
function events:PLAYER_ENTERING_WORLD(event, ...)
	updateTimer = C_Timer.NewTicker(2, XpTracker_UpdateUI)
	
	session = Session:Create()
	level = Level:Create()

	RequestTimePlayed()
	XpTracker_GetExperienceData()
	XpTracker_UpdateUI()
end

function events:CHAT_MSG_COMBAT_XP_GAIN(event, arg1)
	local lastKillXP = string.sub(arg1, string.find(arg1, "%d+"))
	session:UpdatelastKillXP(tonumber(lastKillXP))
end

function events:PLAYER_LEAVING_WORLD(event, ...)
	updateTimer:Cancel()
	updateTimer = nil
end

function events:VARIABLES_LOADED(event, ...)
	
end

function events:PLAYER_XP_UPDATE(event, ...)
	session:PlayerUpdateXP()
	XpTracker_GetExperienceData()
end

function events:PLAYER_LEVEL_UP(event, ...)
	level:PlayerLevelUp()
	session:PlayerLevelUp()
end

function events:TIME_PLAYED_MSG(event, totalTime, levelTime)
	level:SetInitialTime(totalTime, levelTime)
end


-- RENDERING --

function XpTracker_UpdateUI()
	XpTracker_GetSessionExpPerHour()
	XpTracker_GetLevelExpPerHour()
end

function XpTracker_GetSessionExpPerHour()
	local xpPerHour, timeToLevel, xpPercentageOfLevelPerHour, timeToLevel60 = session:GetData()
	local xpPercentageOfLevelPerHourText = string.format('|cffFFF569( %s%% )', xpPercentageOfLevelPerHour)
	local xpPerHourText = string.format('|cff888888Session XP: |cffffffff%s |cff888888 / h %s\n', xpPerHour, xpPercentageOfLevelPerHourText)
	local timeToLevel = string.format('|cff888888Time to level: |cffffffff%s\n', Utils:GetEstTimeText(timeToLevel))
	local timeToLevel60 = string.format('|cff888888Time to level 60: |cffffffff%s\n', Utils:GetEstTimeText(timeToLevel60))

	XpTracker_Frame_ExpSession:SetText(xpPerHourText .. timeToLevel..timeToLevel60)
end

function XpTracker_GetLevelExpPerHour()
	local xpPerHour, timeToLevel, xpPercentageOfLevelPerHour, timeToLevel60 = level:GetData()
	local xpPercentageOfLevelPerHourText = string.format('|cffFFF569( %s%% )', xpPercentageOfLevelPerHour)
	local xpPerHourText = string.format('|cff888888Level XP: |cffffffff%s |cff888888 / h %s\n', xpPerHour, xpPercentageOfLevelPerHourText)
	local timeToLevel = string.format('|cff888888Time to level: |cffffffff%s\n', Utils:GetEstTimeText(timeToLevel))
	local timeToLevel60 = string.format('|cff888888Time to level 60: |cffffffff%s\n', Utils:GetEstTimeText(timeToLevel60))

	XpTracker_Frame_ExpLevel:SetText(xpPerHourText .. timeToLevel..timeToLevel60)
end

function XpTracker_GetExperienceData()
	local currentXP, currentXPMax, XPToLevel, restedXP, percentage = Experience:GetData()
	local restedXPText = string.format('|cffFFF569( %s rested)', restedXP)
	local currentXPText = string.format('|cff888888Current XP: |cffffffff%s %s\n', currentXP, restedXPText)
	local percentageText = string.format('|cffFFF569( %s%% )', percentage)
	local toLevelText = string.format('|cff888888XP to level: |cffffffff%s %s\n', XPToLevel, percentageText)
	
	local lastKillXP = session.lastKillXP;
	local estimatedKillsToLevel = 'N/A'
	if(lastKillXP > 0) then
		estimatedKillsToLevel = math.ceil(XPToLevel / lastKillXP)
	end
	local lastExpGainedText = string.format('|cffFFF569( %s per kill)', lastKillXP)
	local estimatedKillsToLevelText = string.format('|cff888888Kills to level: |cffffffff~%s %s\n', estimatedKillsToLevel, lastExpGainedText)

	XpTracker_Frame_ExpText:SetText(currentXPText .. toLevelText .. estimatedKillsToLevelText)
end
