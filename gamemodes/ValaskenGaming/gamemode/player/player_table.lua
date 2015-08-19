local function returnTeamPlayers(teamID)
	for k, v in pairs(player.GetAll()) do
		if v:Team() == teamID then
			return v
		end
	end
end

PlayerModelTable = {}
PlayerModelTable[1] = "superadmin models/player/hobo387/didact.mdl None"
PlayerModelTable[2] = "STEAM_0:0:111814311 models/haloemile/pm-emile.mdl None"
PlayerModelTable[3] = "STEAM_0:1:47057013 models/player/cubanmerc_male.mdl 1 0 2 3 2" 
PlayerModelTableCount = (table.Count(PlayerModelTable))

TeamA = {}
TeamA["Name"] = "Team A"
TeamA["Players"] = returnTeamPlayers(1)

TeamB = {}
TeamB["Name"] = "Team B"
TeamB["Players"] = returnTeamPlayers(2)

PlayerTeam = {}
PlayerTeam[1] = TeamA
PlayerTeam[2] = TeamB
