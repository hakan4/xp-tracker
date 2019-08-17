Session = {}
Session.__index = Session

function Session:Create()
    local session = {}
    setmetatable(session, Session)
    session.lastKillXP = 0
    session.XP = 0
    session.XPGain = 0
    session.initialXP = Experience:GetCurrentXP()
    session.startTime = time()
    session.accumulatedXP = 0
    session.lastXP = session.initialXP
    return session
end

function Session:PlayerUpdateXP()
    local currentXP = Experience:GetCurrentXP()
    self.XPGain = currentXP - self.lastXP
	self.lastXP = currentXP
	if self.XPGain < 0 then self.XPGain = 0 end
	self.XP = currentXP - self.initialXP + self.accumulatedXP
end

function Session:PlayerLevelUp()
    self.accumulatedXP = self.accumulatedXP + Experience:GetCurrentXPMax() - self.initialXP
	self.initialXP = 0
end

function Session:UpdatelastKillXP(lastKillXP)
    self.lastKillXP = lastKillXP
end

function Session:GetData()
    local totalXP = Experience:GetCurrentXPMax()
	local currentXP = Experience:GetCurrentXP()
	local toLevelXP = totalXP - currentXP
    local sessionTime = time() - self.startTime
    local xpPerHour = Calculator:XPPerHour(self.XP, sessionTime)
    local timeToLevel =  Calculator:TimeToDestination(toLevelXP, self.XP, sessionTime)
    local xpPercentageOfLevelPerHour = Calculator:PercentageOfTotal(xpPerHour, totalXP)
    local timeToLevel60 =  Calculator:TimeToDestination(Experience:GetXPNeededTolevel(60), self.XP, sessionTime)
    
    return xpPerHour, timeToLevel, xpPercentageOfLevelPerHour, timeToLevel60
end
