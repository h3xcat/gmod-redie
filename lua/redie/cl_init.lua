--[[
	Author: DarkE (STEAM_0:0:20178582)
	https://scriptfodder.com/scripts/view/2810
	(C) All rights reserved
]]

net.Receive( "RedieHide", function( len )
	local ply = net.ReadEntity()
	local enable = net.ReadBool()
	
	if not IsValid(ply) or ply == LocalPlayer() then return end
	
	if enable then
		ply:SetCustomCollisionCheck( true )
		ply:SetColor( Color( 255, 255, 255, 0 ) )
	else
		ply:SetCustomCollisionCheck( false )
		ply:SetColor( Color( 255, 255, 255, 255 ) )
	end
end )

timer.Create("RedieTimer", 1, 0, function()
	for _, ply in pairs( player.GetAll() ) do
		if not LocalPlayer():IsSpec() then -- If alive
			if Redie.Config.useRenderMode then
				ply:SetRenderMode( ply:IsRedie() and RENDERMODE_NONE or RENDERMODE_TRANSALPHA )
			else
				ply:SetColor( ply:IsRedie() and Color( 255, 255, 255, 0 ) or Color( 255, 255, 255, 255 ) )
			end
		else -- If Dead
			if Redie.Config.useRenderMode then
				ply:SetRenderMode( RENDERMODE_TRANSALPHA )
				
				if ply:IsRedie() then
					ply:SetColor( Redie.Config.redieColor )
				end
			else
				ply:SetColor( ply:IsRedie() and Redie.Config.redieColor or Color( 255, 255, 255, 255 ) )
			end
		end
	end
end)
