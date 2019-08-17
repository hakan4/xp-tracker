Level = {}
Level.__index = Level

function Level:Create()
    local level = {}
    setmetatable(level, Level)
    return level
end

function Level:UpdateTime(elapsed)
    if(self.totalTime) then
        self.totalTime = self.totalTime + elapsed
        self.levelTime = self.levelTime + elapsed
    end
end

function Level:SetInitialTime(totalTime, levelTime)
    self.totalTime = totalTime
    self.levelTime = levelTime
end

function Level:PlayerLevelUp()
    self.levelTime = 0;
end

function Level:GetData()
    if(not self.levelTime) then return 'N/A', -1, 'N/A' end
    local totalXP = Experience:GetCurrentXPMax()
	local currentXP = Experience:GetCurrentXP()
	local toLevelXP = totalXP - currentXP
	local xpPerHour = math.floor(currentXP / self.levelTime * 3600 + 0.5);
	local timeToLevel = (currentXP == 0) and -1 or toLevelXP / currentXP * self.levelTime;
    local xpPercentageOfLevelPerHour = math.ceil((xpPerHour / totalXP) * 10000) / 100
    local timeToLevel60 = Experience:GetXPNeededTolevel(60) / currentXP * self.levelTime

    return xpPerHour, timeToLevel, xpPercentageOfLevelPerHour, timeToLevel60
end
