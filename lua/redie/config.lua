--[[
	Author: DarkE (STEAM_0:0:20178582)
	https://scriptfodder.com/scripts/view/2810
	(C) All rights reserved
]]

local Config = {
	-- Wether to use the slightly modified deathrun scoreboard. If this set to false, redies won't be visible in original deathrun scoreboard.
	-- Only works if you use Mr. Gash deathrun, otherwise its disabled regardless if its true of false.
	scoreboard = false,
	-- Commands used to activate redie
	chatCommands = {"!redie", "!ghost"},
	-- Color of redies, only seen by spectators and redies. Redies is invisible to live people regardless of this setting.
	redieColor = Color( 255, 255, 255, 100 ), -- Red, Green, Blue, Alpha
	-- Gravity multiplier of a redie
	redieGravity = 0.8,
	-- Should redies be allowed to spray.
	redieSpray = true,
	-- Should redies be allowed to noclip.
	redieNoclip = true,
	-- Enabling this will allow redies to teleport to live players just by right/left clicking with mouse
	mouseTeleport = false,
	-- Which groups should be allowed to use redie, leave it empty to allow everyone.
	restrictGroups = {},
	-- Team number of redies, change it if you know what you're doing.
	redieTeam = 5,
	-- This is experimental, uses RenderMode instead of Color(Alpha channel) to hide redies
	useRenderMode = false,
}
return Config