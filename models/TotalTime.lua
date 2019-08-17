TotalTime = {}
TotalTime.__index = TotalTime

function TotalTime:Create()
    local totalTime = {}
    setmetatable(totalTime, TotalTime)
    return totalTime
end

function TotalTime:UpdateTime(elapsed)
    if(self.time) then
        self.time = self.time + elapsed
    end
end

function TotalTime:SetInitialTime(time)
    self.time = time
end

function TotalTime:GetData()
    if(not self.time) then return 'N/A', -1, 'N/A' end
    local totalXPForLevel = Experience:GetCurrentXPMax()
    local currentXPForLevel = Experience:GetCurrentXP()
    local currentXP = Experience:GetCurrentTotalXP()
    
    local toLevelXP = totalXPForLevel - currentXPForLevel

    local xpPerHour = Calculator:XPPerHour(currentXP, self.time)
    local timeToLevel =  Calculator:TimeToDestination(toLevelXP, currentXP, self.time)
    local xpPercentageOfLevelPerHour = Calculator:PercentageOfTotal(xpPerHour, totalXPForLevel)
    local timeToLevel60 =  Calculator:TimeToDestination(Experience:GetXPNeededTolevel(60), currentXP, self.time)

    return xpPerHour, timeToLevel, xpPercentageOfLevelPerHour, timeToLevel60
end
