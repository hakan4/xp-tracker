Utils = {}

function Utils:GetTimeParts(s)
	local days = 0
	local hours = 0
	local minutes = 0
	local seconds = 0
	if not s or (s < 0) then
		seconds = 'N/A'
	else
		days = floor(s/24/60/60); s = mod(s, 24*60*60);
		hours = floor(s/60/60); s = mod(s, 60*60);
		minutes = floor(s/60); s = mod(s, 60);
		seconds = s;
	end

	return days, hours, minutes, seconds
end

function Utils:GetEstTimeText(s)
	if(not s or s == -1 or s == math.huge) then return 'N/A' end
	local timeText = "";
	local days, hours, minutes, seconds = Utils:GetTimeParts(s)
	local fracdays = days + (hours/24);
	local frachours = hours + (minutes/60);
	if seconds == 'N/A' then
		timeText = 'N/A';
	else
		if (days ~= 0) then
			timeText = timeText..format("%4.1f".. 'days' .." ", fracdays);
		elseif (days ~= 0 or hours ~= 0) then
			timeText = timeText..format("%4.1f".. 'h' .." ", frachours);
		elseif (days ~= 0 or hours ~= 0 or minutes ~= 0) then
			timeText = timeText..format("%d".. 'min' .." ", minutes);
		else
			timeText = timeText..format("%d"..'sec', seconds);
		end
	end
	return timeText;
end