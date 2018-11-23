--[[
	Author: DarkE (STEAM_0:0:20178582)
	https://scriptfodder.com/scripts/view/2810
	(C) All rights reserved
]]

Redie.Teleports = Redie.Teleports or {}

hook.Add( "OnEntityCreated", "Redie_Teleport", function( ent )
	if ent:GetClass() == "trigger_teleport" then
		timer.Simple( 0.5, function()
			ent:SetNotSolid( false )
			ent:SetCustomCollisionCheck( true )
		end)
	end
end)

hook.Add( "EntityKeyValue", "Redie_Teleport", function( ent, key, value )
	if ent:GetClass() == "trigger_teleport" then
		Redie.Teleports[ent] = Redie.Teleports[ent] or { dests = {} }
		if key == "target" then
			timer.Simple(0.5,function()
				Redie.Teleports[ent]["dests"] = ents.FindByName(value)
			end)
		end
		if string.lower(key) == "startdisabled" then
			Redie.Teleports[ent]["enabled"] = tonumber(value) == 0
		end
	end
end)


hook.Add( "ShouldCollide", "Redie_Teleport", function( ent1, ent2 )
	local teleport, player
	local ret = nil
	
	if ent1:GetClass() == "trigger_teleport" then 
		teleport = ent1
		player = ent2
		ret = false
	elseif ent2:GetClass() == "trigger_teleport" then 
		teleport = ent2
		player = ent1
		ret = false
	else return end
	
	if CLIENT then return ret end
	if not player:IsPlayer() or not player:IsRedie() then return ret end
	
	if Redie.Teleports[teleport] and Redie.Teleports[teleport]["enabled"] and #(Redie.Teleports[teleport]["dests"]) > 0 then
		local target = table.Random(Redie.Teleports[teleport]["dests"])
		if not IsValid(target) then return ret end
		
		player:SetPos(target:GetPos())
	end
	
	return ret
end)