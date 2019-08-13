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
	local xpPerHour = math.floor(self.XP / sessionTime * 3600 + 0.5)
	local timeToLevel = (self.XP == 0) and -1 or toLevelXP / self.XP * sessionTime
    local xpPercentageOfLevelPerHour = math.ceil((xpPerHour / totalXP) * 10000) / 100

    return xpPerHour, timeToLevel, xpPercentageOfLevelPerHour
end
