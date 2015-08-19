AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("gui/cl_hud.lua")
AddCSLuaFile("player/player_call.lua")
AddCSLuaFile("player/player_table.lua")

include('shared.lua')
include('player/player_call.lua')
include('player/player_table.lua')

function GM:PlayerInitialSpawn(ply)
	ply:SetGravity(1)
	ply:SetWalkSpeed(200)
	ply:SetRunSpeed(275)
	ply:SetModel("models/player/Combine_Super_Soldier.mdl")
	
	umsg.Start("WelcomeMessage", ply)
	umsg.End()
	
	OTS.Enable(ply)
	
	TeamAC = (team.NumPlayers(1))
	TeamBC = (team.NumPlayers(2))
	if TeamAC > TeamBC then
		ply:SetTeam(2)
	elseif TeamAC < TeamBC then
		ply:SetTeam(1)
	else
		local RandomTeam = math.random(1, 2)
		if RandomTeam == 1 then
			ply:SetTeam(1)
		elseif RandomTeam == 2 then
			ply:SetTeam(2)
		end
	end
end

function GM:PlayerSpawn(ply)
	ply:Give("weapon_ar2")
	ply:SetAmmo(90, "ar2")
	ply:SetAmmo(1, "ar2altfire")
	
	ply:Give("weapon_357")
	ply:SetAmmo(18, "pistol")
	
	ply:Give("weapon_claws")
	
	for i = 1, PlayerModelTableCount do
		local stringTable = (string.Explode(" ", PlayerModelTable[i]))

		if ((stringTable[3]) == "None") then
			if (ply:IsUserGroup(stringTable[1])) then
				ply:SetModel(stringTable[2])
			end
			
			if (ply:SteamID() == stringTable[1]) then
				ply:SetModel(stringTable[2])
			end
		else
			local stringStart = ((string.len(stringTable[1])) + (string.len(stringTable[2])) + 3)
			local stringEnd = (string.len(PlayerModelTable[i]))
			local stringGroups = (string.sub((PlayerModelTable[i]), stringStart, stringEnd))
			local stringTableGroups = (string.Explode(" ", stringGroups))
			if (ply:IsUserGroup(stringTable[1])) then
				ply:SetModel(stringTable[2])
				
				for i = 1, (table.Count(stringTableGroups)) do
					local indexNumber = (i - 1)
					local indexModelN = (tonumber(stringTableGroups[i]))
					ply:SetBodygroup(indexNumber, indexModelN)
				end
			end
			
			if (ply:SteamID() == stringTable[1]) then
				ply:SetModel(stringTable[2])
				
				for i = 1, (table.Count(stringTableGroups)) do
					print("Test")
					local indexNumber = (i - 1)
					local indexModelN = (tonumber(stringTableGroups[i]))
					ply:SetBodygroup(indexNumber, indexModelN)
				end
			end
		end
	end
end

function GM:PlayerShouldTakeDamage(ply, target)
	if ply:IsPlayer() then
		if ply:Team() == target:Team() then
			return false
		end
	end
	return true
end
