AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )
RunConsoleCommand( "sv_noclipspeed", "1" )
A=1
print("DarknessRP: Version 1.0.1")
--[[ Net Library ]]--
util.AddNetworkString( 'HurtDark' )
net.Receive('HurtDark', function(len, ply)
	A = A+1
	if A==10 then
		if ply:Health()<0 and ply:Alive() then
			ply:Kill()
		else
			ply:SetHealth((ply:Health()-1))
		end
		A=1
	end
end )

function GM:PlayerCanHearPlayersVoice()
	return true, true
end

function GM:PlayerSpawn( ply )
    self.BaseClass:PlayerSpawn( ply )
	
	// Moved from death.
	if team.NumPlayers(2) == 0 then
		print("The Darkness has won.")
		for k,v in pairs(player.GetAll()) do
			v:ChatPrint( "The Darkness has won." )
			for k,v in pairs(player.GetAll()) do
				if v:Team() == 3 or v:Team() == 4 then
					v:StripWeapons()
					v:Give( "weapon_fists" )
					v:SetRunSpeed( 240 )
					v:SetWalkSpeed( 120 )
					v:SetMaxHealth( 50 )
					v:SetHealth(50)
					v:SetGravity( 1 )
					v:SetTeam( 2 )
					
					if v:IsAdmin() then
					v:Give( "gmod_tool" )
					v:Give( "gmod_camera" )
					v:Give( "weapon_physgun" )
					end
				end
				if v:Team() == 1 then
					v:SetHealth(100)
					v:Give( "weapon_fists" )
				end
			end
			ModelSetting(v)
		end
	end
	ply:StripWeapons()
	if ply:Team() != 4 then
		ply:Give( "weapon_fists" )
	end
	if ply:Team() == 1 then
		ply:SetRunSpeed( 530 )
		ply:SetWalkSpeed( 300 )
		ply:SetGravity( 0.25 )
		ply:SetMaxHealth( 100 )
		ply:SetHealth(100)
	elseif ply:Team() == 2 then
		ply:SetRunSpeed( 240 )
		ply:SetWalkSpeed( 120 )
		ply:SetMaxHealth( 100 )
		ply:SetHealth(50)
		ply:SetGravity( 1 )
	elseif ply:Team() == 3 then
		ply:SetRunSpeed( 250 )
		ply:SetWalkSpeed( 150 )
		ply:SetGravity( 0.75 )
		ply:SetMaxHealth( 25 )
		ply:SetHealth(25)
		ply:PrintMessage( HUD_PRINTTALK, "You are a minion for the darkness. Do what he says..." )
	else
		--Blank for a reason... probably...--
	end
	if ply:IsAdmin() then
		ply:Give( "gmod_tool" )
		ply:Give( "gmod_camera" )
		ply:Give( "weapon_physgun" )
	end
	ply:PrintMessage( HUD_PRINTTALK, "You are ".. team.GetName( ply:Team() ) )
	ModelSetting(ply)
end

function GM:PlayerInitialSpawn( ply )
	SetATeam( ply )
	ply:PrintMessage( HUD_PRINTTALK, "You are ".. team.GetName( ply:Team() ) )
	ply:PrintMessage( HUD_PRINTTALK, "You can type /help and any time to see a list of the commands. Please press F4 and set an RP name." )
	ModelSetting( ply )
end

function GM:PlayerDeath( ply, inf, att )
ply:StripWeapons()
	if ply:Team() == 1 then
		// If you are darkness and you are killed
		ply:SetTeam( 4 )
		if att:IsPlayer() then
			att:StripWeapons()
			att:SetTeam( 1 )
			att:PrintMessage( HUD_PRINTTALK, "When the Darkness leaves one body, it consumes another." )
			att:SetRunSpeed( 530 )
			ModelSetting( att )
			att:SetHealth(100)
			att:SetWalkSpeed( 300 )
			att:Flashlight(false)
			att:SetGravity( 0.25 )
			att:Give( "weapon_fists" )
			att:PrintMessage( HUD_PRINTTALK, "You are ".. team.GetName( ply:Team() ) )
			if att:IsAdmin() then
				att:Give( "gmod_tool" )
				att:Give( "gmod_camera" )
				att:Give( "weapon_physgun" )
			end
		else
			local rnd = math.random(1, team.NumPlayers(2))
			local oth = team.GetPlayers(2)[rnd]
			oth:StripWeapons()
			oth:SetTeam( 1 )
			oth:PrintMessage( HUD_PRINTTALK, "When the Darkness leaves one body, it consumes another." )
			oth:SetRunSpeed( 530 )
			ModelSetting( oth )
			oth:SetWalkSpeed( 300 )
			oth:Flashlight(false)
			oth:SetGravity( 0.25 )
			oth:Give( "weapon_fists" )
			oth:PrintMessage( HUD_PRINTTALK, "You are ".. team.GetName( ply:Team() ) )        
			if oth:IsAdmin() then
				oth:Give( "gmod_tool" )
				oth:Give( "gmod_camera" )
				oth:Give( "weapon_physgun" )
			end
		end
	else
		// If you are a citizen and you are killed
		ply:SetTeam( 4 )
		if att:Team() == 1 then
			for k,v in pairs(player.GetAll()) do
				v:ChatPrint( "Another victim falls to the darkness." )
				print("Another victim falls to the darkness.")
				v:ChatPrint("There are: "..team.NumPlayers(2).." Citizens left.")
				print("There are:"..team.NumPlayers(2).." Citizens left.")
			end
			// Citizen killed by Darkness
			ply:PrintMessage( HUD_PRINTTALK, "You were killed by the Darkness.")
		else
			// Citizen killed by Team
			att:PrintMessage( HUD_PRINTTALK, "Try not to kill your friends." )
			for k,v in pairs(player.GetAll()) do
				v:ChatPrint( "Another victim falls to the darkness." )
				print("Another victim falls to the darkness.")
				v:ChatPrint("There are: "..team.NumPlayers(2).." Citizens left.")
				print("There are:"..team.NumPlayers(2).." Citizens left.")
			end
		end
	end
end

function GM:PlayerSpawnObject( ply )
	if ply:IsAdmin() == true then
		return true
	else
		return false
	end
end

function GM:PlayerCanPickupWeapon( ply, wep )
	if wep:GetClass() == "weapon_fists" or wep:GetClass() == "weapon_pistol" or wep:GetClass() == "weapon_crowbar" or wep:GetClass() == "weapon_shotgun" or wep:GetClass() == "weapon_smg1" or wep:GetClass() == "weapon_physgun" or wep:GetClass() == "gmod_camera" or wep:GetClass() == "gmod_tool" then
		if ply:Team() == 2 then
			return true
		else
			if ply:IsAdmin() then
				return true
			else
				if wep:GetClass() == "weapon_fists" or wep:GetClass() == "gmod_camera" or wep:GetClass() == "gmod_tool" or wep:GetClass() == "weapon_physgun" then
				return true
				else
				return false
				end
			end
		end
	else
		if ply:IsAdmin() then
			return true
		else
			return false
		end
	end
end


function GM:PlayerNoClip( ply, on )
	if ply:Team() == 1 or ply:IsAdmin() then
		return true
	else
		on = 0
		return false
	end
end

function GM:PlayerUse( ply, entity )
	if ply:Team() == 1 then
		if entity:GetClass() == "func_button" then
			return false
		end
		return true
	end
	return true
end

function GM:PlayerSwitchFlashlight(  ply, on )
	if ply:Team() == 1 then
		if ply:FlashlightIsOn() then
			return true
		else
			return false
		end
	end
	return true
end

function GM:PlayerConnect( name, address )
	for k,v in pairs(player.GetAll()) do
		v:ChatPrint( name.." has awoken." )
	end
	print(name.." ("..address..") has awoken.")
end

function GM:PlayerDisconnected( ply )
	for k,v in pairs(player.GetAll()) do
		v:ChatPrint( ply:GetName().." has abandoned you all!" )
	end
	print(ply:GetName().." has abandoned you all!")
	if ply:Team() == 1 then
		if team.NumPlayers(2)>0 then
			local randply = math.random(1, team.NumPlayers( 2 ))
			local plyd = team.GetPlayers(2)[randply]
			plyd:StripWeapons()
			plyd:Give( "weapon_fists" )
			plyd:SetRunSpeed( 530 )
			plyd:SetWalkSpeed( 300 )
			plyd:SetMaxHealth( 100 )
			plyd:SetHealth(100)
			plyd:PrintMessage( HUD_PRINTTALK, "You are now The Darkness." )
			plyd:SetTeam(1)
			ModelSetting(ply)
		end
	end
end

/*function GM:PlayerShouldTakeDamage(ply,vic)
	if ply:Team() ~= vic:Team() then
		if ply:Team() ~= 2 then
			if ply:Team() == 1 then
				if vic:Team() == 3 then
					return false
				else
					return true
				end
			return true
			end
		else
			return true
		end
	else
	return false
	end
end*/
-----------------My Functions----------------------
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

function ModelSetting( ply )
	local rnd = math.random(1,15)
	if ply:Team() == 1 then
		ply:SetModel( "models/player/grim.mdl" )
		return
	end
	if ply:Team() == 2 or ply:Team() == 3 then
		ply:SetModel( skins[rnd] )
		return
	end
	if ply:Team() == 4 then
		
		ply:SetModel("models/player/zombie_classic.mdl")
	end
	return
end

function SetATeam( ply )
	ply:StripWeapons()
		if team.NumPlayers( 1 ) ~= 1 or ply:Team() == 1 then
				ply:SetTeam( 1 )
				ply:Give( "weapon_fists" )
				ply:SetRunSpeed( 530 )
				ply:SetWalkSpeed( 300 )
				ModelSetting(ply)
				ply:SetGravity( 0.25 )
				ply:SetMaxHealth( 100 )
				ply:SetHealth(100)
				
			else
				ply:SetTeam( 2 )
				ply:Give( "weapon_fists" )
				ply:SetRunSpeed( 240 )
				ply:SetWalkSpeed( 120 )
				ModelSetting(ply)
				ply:SetGravity( 1 )
				ply:SetMaxHealth( 50 )
				ply:SetHealth(50)
				
		end
	if ply:IsAdmin() then
		ply:Give( "gmod_tool" )
		ply:Give( "gmod_camera" )
		ply:Give( "weapon_physgun" )
	end
end

function ChatCommands( ply, text, public )
	if (string.sub( text, 1, 7) == "/minion") then
		if ply:Team() == 1 then
			for k,v in pairs(player.GetAll()) do
				if (string.sub( text, 9, string.len(text)) == v:GetName()) then
					AName = v
				end
			end
			if AName:Team() == 4 then
				if AName:IsValid() then
					AName:SetWalkSpeed( 150 )
					AName:SetGravity( 0.75 )
					AName:SetHealth(25)
					AName:Give( "weapon_fists" )
					AName:SetTeam(3)
					ModelSetting( AName )
					if AName:IsAdmin() then
						AName:Give( "gmod_tool" )
						AName:Give( "gmod_camera" )
						AName:Give( "weapon_physgun" )
					end
					AName:PrintMessage( HUD_PRINTTALK, "You are a minion for the darkness. Do what he says..." )
					ply:SendHint(AName:GetName().." is now a minion.", 5)
				else
					ply:PrintMessage( HUD_PRINTTALK, "Can not find target." )
				end
			end
		end
	end
	if (string.sub( text, 1, 5) == "/swap") then
	ply:StripWeapons()
		if ply:Team() == 1 then
			ply:SetTeam( 2 )
				ply:Give( "weapon_fists" )
				ply:SetRunSpeed( 240 )
				ply:SetWalkSpeed( 120 )
				ModelSetting(ply)
				ply:SetMaxHealth( 50 )
				ply:SetHealth(50)
				ply:SetGravity( 1 )
				ply:PrintMessage( HUD_PRINTTALK, "You are now a Citizen." )
		elseif ply:Team() == 2 then
			if team.NumPlayers( 1 ) == 1 then
				ply:PrintMessage( HUD_PRINTTALK, "Team cannot be swapped at this time." )
			else
				ply:SetTeam( 1 )
				ply:Give( "weapon_fists" )
				ply:SetRunSpeed( 530 )
				ply:SetMaxHealth( 100 )
				ModelSetting(ply)
				ply:Flashlight(false)
				ply:SetHealth(100)
				ply:SetWalkSpeed( 300 )
				ply:SetGravity( 0.25 )
				ply:PrintMessage( HUD_PRINTTALK, "You are now The Darkness." )
			end
		else
			ply:PrintMessage( HUD_PRINTTALK, "Team cannot be swapped at this time." )
		
		end
		if ply:IsAdmin() then
		ply:Give( "gmod_tool" )
		ply:Give( "gmod_camera" )
		ply:Give( "weapon_physgun" )
		end
		return false
	end
	
	if (string.sub( text, 1, 6) == "/aswap") then
		if ply:IsAdmin() then
			if ply:Team() == 1 then
				if team.NumPlayers( 2 ) ~= 0 then
				
				else
					ply:PrintMessage( HUD_PRINTTALK, "Use /swap." )
					return
				end
				
				local randply = math.random(1, team.NumPlayers( 2 ))
				local oth = team.GetPlayers(2)[randply]
				
				ply:StripWeapons()
				
				ply:StripWeapons()
				oth:StripWeapons()
				
				ply:Give("weapon_fists")
				oth:Give("weapon_fists")
				
				oth:SetWalkSpeed( 300 )
				oth:SetRunSpeed( 530 )
				
				ply:SetRunSpeed( 240 )
				ply:SetWalkSpeed( 120 )
				
				oth:SetGravity( 0.25 )
				ply:SetGravity( 1 )
				
				local rnd = math.random(1,15)
				oth:SetModel( "models/player/grim.mdl" )
				ply:SetModel( skins[rnd] )
				
				oth:Flashlight(false)
				
				
				oth:PrintMessage( HUD_PRINTTALK, "You are now The Darkness." )
				ply:PrintMessage( HUD_PRINTTALK, "You are now a Citizen." )
				if ply:IsAdmin() then
					ply:Give( "gmod_tool" )
					ply:Give( "gmod_camera" )
					ply:Give( "weapon_physgun" )
				end
				if oth:IsAdmin() then
					oth:Give( "gmod_tool" )
					oth:Give( "gmod_camera" )
					oth:Give( "weapon_physgun" )
				end
				ply:SetTeam( 2 )
				oth:SetTeam( 1 )
			else
				if team.NumPlayers( 1 ) ~= 0 then
				
				else
					ply:PrintMessage( HUD_PRINTTALK, "Use /swap." )
					return
				end
				
				local oth = team.GetPlayers(1)[1]
				
				oth:StripWeapons()
				ply:StripWeapons()
				
				oth:Give("weapon_fists")
				ply:Give("weapon_fists")
				
				ply:SetWalkSpeed( 300 )
				ply:SetRunSpeed( 530 )
				
				oth:SetRunSpeed( 240 )
				oth:SetWalkSpeed( 120 )
				
				ply:SetGravity( 0.25 )
				oth:SetGravity( 1 )
				
				local rnd = math.random(1,15)
				ply:SetModel( "models/player/grim.mdl" )
				oth:SetModel( skins[rnd] )
				
				ply:Flashlight(false)
				
				
				ply:PrintMessage( HUD_PRINTTALK, "You are now The Darkness." )
				oth:PrintMessage( HUD_PRINTTALK, "You are now a Citizen." )
				
				if ply:IsAdmin() then
					ply:Give( "gmod_tool" )
					ply:Give( "gmod_camera" )
					ply:Give( "weapon_physgun" )
				end
				if oth:IsAdmin() then
					oth:Give( "gmod_tool" )
					oth:Give( "gmod_camera" )
					oth:Give( "weapon_physgun" )
				end
				oth:SetTeam( 2 )
				ply:SetTeam( 1 )
			end
			return false
		end
		return false
	end
	
	if (string.sub( text, 1, 5) == "/drop") then
		if ply:GetActiveWeapon():GetClass() == "weapon_fists" then
		ply:PrintMessage( HUD_PRINTTALK, "Why are you trying to drop your hands? They are attached to your rists." )
		else
		ply:DropWeapon(ply:GetActiveWeapon())
		end
		return false
	end
	
	if (string.sub( text, 1, 9) == "/darkness") then
		ply:PrintMessage( HUD_PRINTTALK, team.GetPlayers(1)[1]:Name().." is cursed with the absence of light in his soul..." )
		return false
	end
	
	if (string.sub( text, 1, 9) == "/restart") then
		return false
	end
	
	if (string.sub( text, 1, 5) == "/help") then
		ply:PrintMessage( HUD_PRINTTALK, "/darkness - Displays who the darkness is." )
		ply:PrintMessage( HUD_PRINTTALK, "/drop - Drops currently held weapon." )
		ply:PrintMessage( HUD_PRINTTALK, "/help - Shows this help text." )
		ply:PrintMessage( HUD_PRINTTALK, "/me - Used when doing an action." )
		ply:PrintMessage( HUD_PRINTTALK, "/ooc or // - Used when talking out of character." )
		ply:PrintMessage( HUD_PRINTTALK, "/swap - Swaps team if you are Darkness or Citizen." )
		if ply:IsAdmin() then
			ply:PrintMessage( HUD_PRINTTALK, "/aswap - If there is already darkness, will swap anyway, forcing the darkness to change." )
		end
		return false
	end
end


---------------Hooks and Timers-----------------
------------------------------------------------
------------------------------------------------
------------------------------------------------



hook.Add("PlayerSay", "ChatCommands", ChatCommands )

hook.Add( 'ShowSpare2', "F4Menu", function(ply)
	umsg.Start( "OpenA", ply )
	umsg.End()
end )
hook.Add( "PlayerSpawnVehicle", "NoVehicles", function(ply)
	if !ply:IsAdmin() then
	ply:PrintMessage( HUD_PRINTTALK, "You do not have permission to do this." )
	end
   return ply:IsAdmin()
end )
hook.Add( "PlayerSpawnObject", "NoObjects", function( ply )
   if !ply:IsAdmin() then
	ply:PrintMessage( HUD_PRINTTALK, "You do not have permission to do this." )
	end
   return ply:IsAdmin()
end )
hook.Add( "PlayerSpawnNPC", "NoNPC", function(ply)
	if !ply:IsAdmin() then
	ply:PrintMessage( HUD_PRINTTALK, "You do not have permission to do this." )
	end
   return ply:IsAdmin()
end )
hook.Add("PlayerSpawnSWEP", "AdminOnlySWEPs", function( ply, class, wep )
	if !ply:IsAdmin() then
	ply:PrintMessage( HUD_PRINTTALK, "You do not have permission to do this." )
	end
	return ply:IsAdmin()
end)
hook.Add( "PlayerSpawnSENT", "NoSENT", function(ply)
	if !ply:IsAdmin() then
	ply:PrintMessage( HUD_PRINTTALK, "You do not have permission to do this." )
	end
   return ply:IsAdmin()
end )