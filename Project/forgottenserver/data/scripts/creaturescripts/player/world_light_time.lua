local event = CreatureEvent("WorldTimeAndLight")

function event.onLogin(player)
	local currentTime = os.time()
	local time = os.date("*t", currentTime)
	local worldTime = (time.sec + (time.min * 60)) / 2.5
	--player:sendWorldTime(worldTime)

	--local worldLightColor, worldLightLevel = Game.getWorldLight()
	--player:sendWorldLight(worldLightColor, worldLightLevel)
	return true
end

event:register()
