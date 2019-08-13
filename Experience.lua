Experience = {}

function Experience:GetCurrentXP()
    return UnitXP('player')
end

function Experience:GetCurrentXPMax()
    return UnitXPMax('player')
end

function Experience:GetXPToLevel()
    return self:GetCurrentMaxXP() - self:GetCurrentXP()
end

function Experience:GetRestedXP()
    return GetXPExhaustion()
end

function Experience:GetData()
    local currentXP = Experience:GetCurrentXP()
	local currentXPMax = Experience:GetCurrentXPMax()
    local xpTolevel = currentXPMax - currentXP
    local restedXP = Experience:GetRestedXP()
    if(not restedXP) then restedXP = 0 end
    local percentage = math.ceil(((xpTolevel / currentXPMax) * 10000) / 100)
    return currentXP, currentXPMax, xpTolevel, restedXP, percentage
end