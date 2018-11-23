--[[
	Author: DarkE (STEAM_0:0:20178582)
	https://scriptfodder.com/scripts/view/2810
	(C) All rights reserved
]]

Redie = Redie or { VERSION = "1.2.0" }
Redie.Config = include("redie/config.lua")

GhostMode = Redie -- Adds compatibility with Arizard's Deathrun

local function init()
	Redie.gamemode = "unknown"
	if string.lower( engine.ActiveGamemode() ) == "deathrun" then
		if GAMEMODE.Author == "Arizard" then
			Redie.gamemode = "dr_arizard"
		elseif GAMEMODE.Author == "Mr. Gash" then
			Redie.gamemode = "dr_mrgash"
		end
	end
	
	if Redie.gamemode == "unknown" then
		ErrorNoHalt( "[Redie] Gamemode is not supported by this addon. Use it at your own risk!" )
	else
		MsgN( "[Redie] Gamemode detected: "..Redie.gamemode )
	end
	
	-- Setup teams
	TEAM_REDIE = Redie.Config.redieTeam
	TEAM_GHOST = TEAM_REDIE
	
	if not team.Valid( TEAM_REDIE ) then
		team.SetUp( TEAM_REDIE, "Redie", Color(100,100,100), false )
	end

	-- Setup tag methods for players
	local PLAYER = FindMetaTable( "Player" )
	local ENTITY = FindMetaTable( "Entity" )
	
	function PLAYER:IsRedie()
		return self:Team() == TEAM_REDIE and self:Alive()
	end
	function PLAYER:IsGhostMode()
		return self:IsRedie()
	end
	Redie.oldIsSpec = Redie.oldIsSpec or PLAYER.IsSpec
	function PLAYER:IsSpec()
		return self:IsRedie() or ( Redie.oldIsSpec and Redie.oldIsSpec(self) ) or not self:Alive()
	end
	
	if Redie.gamemode == "dr_arizard" and CLIENT then -- Ugly hack to hide names
		Redie.oldEyePos = Redie.oldEyePos or ENTITY.EyePos
		function ENTITY:EyePos()
			if not self:IsPlayer() then return Redie.oldEyePos(self) end
			
			return (self:IsRedie() and Vector(0,0,9999999999)) or Redie.oldEyePos(self)
		end
	end
	
	-- Load scripts
	if SERVER then
		AddCSLuaFile("autorun/redie.lua")
		AddCSLuaFile("redie/cl_init.lua")
		AddCSLuaFile("redie/config.lua")
		AddCSLuaFile("redie/teleport.lua")
		if Redie.Config.scoreboard and Redie.gamemode == "dr_mrgash" then
			AddCSLuaFile("redie/cl_scoreboard.lua")
		end
		
		include("redie/sv_init.lua")
	elseif CLIENT then
		include("redie/cl_init.lua")
		if Redie.Config.scoreboard and Redie.gamemode == "dr_mrgash" then
			include("redie/cl_scoreboard.lua")
		end
	end

	include("redie/teleport.lua")


	-- Hooks
	hook.Add( "PlayerFootstep", "Redie", function( ply, pos, foot, sound, volume, filter )
		if ply:IsRedie() then return true end
	end)
	hook.Add( "PlayerNoClip", "Redie", function( ply, desiredState)
		if ply:IsRedie() and Redie.Config.redieNoclip then return true end
	end, HOOK_HIGH )
	hook.Add( "ShouldCollide", "Redie", function( ent1, ent2 )
		if ent1:IsPlayer() and ent2:IsPlayer() and ( ent1:IsRedie() or ent2:IsRedie() ) then return false end
	end)
end

hook.Add( "Initialize", "Redie", init )