Experience = {}

local xpPerlevel = {}
xpPerlevel[0] = { level = 2, xp = 400 }
xpPerlevel[1] = { level = 3, xp = 900 }
xpPerlevel[2] = { level = 4, xp = 1400 }
xpPerlevel[3] = { level = 5, xp = 2100 }
xpPerlevel[4] = { level = 6, xp = 2800 }
xpPerlevel[5] = { level = 7, xp = 3600 }
xpPerlevel[6] = { level = 8, xp = 4500 }
xpPerlevel[7] = { level = 9, xp = 5400 }
xpPerlevel[8] = { level = 10, xp = 6500 }
xpPerlevel[9] = { level = 11, xp = 7600 }
xpPerlevel[10] = { level = 12, xp = 8800 }
xpPerlevel[11] = { level = 13, xp = 10100 }
xpPerlevel[12] = { level = 14, xp = 11400 }
xpPerlevel[13] = { level = 15, xp = 12900 }
xpPerlevel[14] = { level = 16, xp = 14400 }
xpPerlevel[15] = { level = 17, xp = 16000 }
xpPerlevel[16] = { level = 18, xp = 17700 }
xpPerlevel[17] = { level = 19, xp = 19400 }
xpPerlevel[18] = { level = 20, xp = 21300 }
xpPerlevel[19] = { level = 21, xp = 23200 }
xpPerlevel[20] = { level = 22, xp = 25200 }
xpPerlevel[21] = { level = 23, xp = 27300 }
xpPerlevel[22] = { level = 24, xp = 29400 }
xpPerlevel[23] = { level = 25, xp = 31700 }
xpPerlevel[24] = { level = 26, xp = 34000 }
xpPerlevel[25] = { level = 27, xp = 36400 }
xpPerlevel[26] = { level = 28, xp = 38900 }
xpPerlevel[27] = { level = 29, xp = 41400 }
xpPerlevel[28] = { level = 30, xp = 44300 }
xpPerlevel[29] = { level = 31, xp = 47400 }
xpPerlevel[30] = { level = 32, xp = 50800 }
xpPerlevel[31] = { level = 33, xp = 54500 }
xpPerlevel[32] = { level = 34, xp = 58600 }
xpPerlevel[33] = { level = 35, xp = 62800 }
xpPerlevel[34] = { level = 36, xp = 67100 }
xpPerlevel[35] = { level = 37, xp = 71600 }
xpPerlevel[36] = { level = 38, xp = 76100 }
xpPerlevel[37] = { level = 39, xp = 80800 }
xpPerlevel[38] = { level = 40, xp = 85700 }
xpPerlevel[39] = { level = 41, xp = 90700 }
xpPerlevel[40] = { level = 42, xp = 95800 }
xpPerlevel[41] = { level = 43, xp = 101000 }
xpPerlevel[42] = { level = 44, xp = 106300 }
xpPerlevel[43] = { level = 45, xp = 111800 }
xpPerlevel[44] = { level = 46, xp = 117500 }
xpPerlevel[45] = { level = 47, xp = 123200 }
xpPerlevel[46] = { level = 48, xp = 129100 }
xpPerlevel[47] = { level = 49, xp = 135100 }
xpPerlevel[48] = { level = 50, xp = 141200 }
xpPerlevel[49] = { level = 51, xp = 147500 }
xpPerlevel[50] = { level = 52, xp = 153900 }
xpPerlevel[51] = { level = 53, xp = 160400 }
xpPerlevel[52] = { level = 54, xp = 167100 }
xpPerlevel[53] = { level = 55, xp = 173900 }
xpPerlevel[54] = { level = 56, xp = 180800 }
xpPerlevel[55] = { level = 57, xp = 187900 }
xpPerlevel[56] = { level = 58, xp = 195000 }
xpPerlevel[57] = { level = 59, xp = 202300 }
xpPerlevel[58] = { level = 60, xp = 209800 }

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

function Experience:GetCurrentLevel()
    return UnitLevel('player')
end

function Experience:GetXPForLevel(level)
    if(level < 1 or level > 60) then return -1 end
    return xpPerlevel[level - 2].xp
end

function Experience:GetXPNeededTolevel(level)
    local currentLevel = self:GetCurrentLevel()
    if(level <= currentLevel or level > 60) then return -1 end
    local accumulatedXP = self:GetXPForLevel(currentLevel + 1) - self:GetCurrentXP();
    for i = currentLevel + 2, level do
        accumulatedXP = accumulatedXP + self:GetXPForLevel(i)
    end
    return accumulatedXP
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