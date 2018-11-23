--[[
	Author: DarkE (STEAM_0:0:20178582)
	https://scriptfodder.com/scripts/view/2810
	(C) All rights reserved
]]

if not SERVER then return end

Redie = Redie or {}

util.AddNetworkString( "RedieHide" )

local PLAYER = FindMetaTable( "Player" )
local ENTITY = FindMetaTable( "Entity" )

Redie.oldSetPos = Redie.oldSetPos or ENTITY.SetPos
function ENTITY:SetPos( pos )
	if 
		not self:IsPlayer() or 
		not self:IsRedie() or
		(CurTime() - (self.redie_spawn_time or 0) > 1.5)
	then return Redie.oldSetPos( self, pos ) end
	return nil
end


function PLAYER:Redie( enable )
	local ply = self
	if enable then
		if Redie.gamemode == "dr_arizard" then
			if self:GetSpectate() then
				self:StopSpectate()
			end
			
			if self:ShouldStaySpectating() then
				self:SetShouldStaySpectating( false )
			end
		end
		
		ply:SetCustomCollisionCheck( true )
		ply:SetTeam( TEAM_REDIE )
		ply:Spawn()
		
		local spawns = ents.FindByClass( "info_player_counterterrorist" )
		ply:SetPos( table.Random( spawns ):GetPos() )
		ply.redie_spawn_time = CurTime()

		ply:SetNotSolid(true)
		ply:GodEnable()
		ply:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		ply:AllowFlashlight( false )
		ply:SetGravity(Redie.Config.redieGravity)
		

		timer.Simple(1,function()
			ply:SetRenderMode( RENDERMODE_TRANSALPHA )
			ply:SetColor( Color( 255, 255, 255, 0 ) )
			ply:StripWeapons()
			
		end)
	else
		ply:SetCustomCollisionCheck(false)
		
		ply:SetColor( Color( 255, 255, 255, 255 ) )
		
		ply:SetNotSolid(false)
		ply:GodDisable()
		ply:SetCollisionGroup(COLLISION_GROUP_PLAYER)
		ply:AllowFlashlight( true )
		--ply:SetGravity( 40357164 )
	end
	
	net.Start( "RedieHide" )
	net.WriteEntity(ply)
	net.WriteBool(enable)
	net.Broadcast()
end


hook.Add( "PlayerSay", "RedieChat", function( ply, text, teamonly )
	local text = string.lower(text)
	local args = string.Explode(" ", text)
	if not table.HasValue( Redie.Config.chatCommands, args[1] ) then print("no", #args) PrintTable(args) return end
	 
	if #Redie.Config.restrictGroups > 0 and not table.HasValue( Redie.Config.restrictGroups, ply:GetUserGroup() ) then
		ply:ChatPrint("This command is restricted to your group.")
		return ""
	end
	
	if not ply:IsRedie() and ply:Alive() then
		ply:ChatPrint("You must be dead to use "..(args[1])..".")
		return ""
	end
	local roundstate = ROUND_ACTIVE
	if Redie.gamemode == "dr_mrgash" then
		roundstate = GetRoundState()
	elseif  Redie.gamemode == "dr_arizard" then
		roundstate = ROUND:GetCurrent()
	end
	
	if roundstate ~= ROUND_ACTIVE and roundstate ~= ROUND_WAITING then
		ply:ChatPrint("The round must be active to use "..(args[1])..".")
		return ""
	end
	
	ply:Redie( true )

	return ""
end)

hook.Add( "OnRoundSet", "RedieClear", function ( round )
	if ( round == ROUND_ENDING ) then
		for _, ply in pairs( player.GetAll() ) do
			ply:Redie( false )
		end
	end
end )
hook.Add( "PlayerUse", "RedieUse", function( ply, ent )
	if ply:IsRedie() then return false end
end )
if not Redie.Config.redieSpray then
	hook.Add( "PlayerSpray", "RedieSpray", function( ply )
		if ply:IsRedie() then return true end
	end )
end
if Redie.Config.mouseTeleport then
	hook.Add( "KeyPress", "RedieKeyPress", function( ply, key )
		if ply:Team() ~= TEAM_REDIE then return end
		if key == IN_ATTACK then
			local plys = {}
			for k, v in pairs(player.GetAll()) do if not v:IsSpec() then plys[#plys+1]=v end end

			ply.redie_curply = ply.redie_curply or 0
			ply.redie_curply = (ply.redie_curply+1)%#plys

			ply:SetPos(plys[ply.redie_curply+1]:GetPos())
		elseif key == IN_ATTACK2 then
			local plys = {}
			for k, v in pairs(player.GetAll()) do if not v:IsSpec() then plys[#plys+1]=v end end

			ply.redie_curply = ply.redie_curply or 0
			ply.redie_curply = (ply.redie_curply-1)%#plys

			ply:SetPos(plys[ply.redie_curply+1]:GetPos())
		end
	end )
end