Calculator = {}

function Calculator:XPPerHour(unitXP, unitTime)
    return math.floor(unitXP / unitTime * 3600 + 0.5)
end

function Calculator:TimeToDestination(destinationXP, unitXP, unitTime)
    if(unitXP < 0) then return -1 end
    return destinationXP / unitXP * unitTime
end

function Calculator:PercentageOfTotal(unitXP, totalXP)
    return math.ceil((unitXP / totalXP) * 10000) / 100
end
