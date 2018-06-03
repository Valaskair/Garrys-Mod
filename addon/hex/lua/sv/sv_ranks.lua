local meta 			= FindMetaTable("Player")

local chatCommands	= VHexChatCommands

function meta:vSetRank(rank, train)
	local indexDir 			= "v/"..string.lower(string.Replace(self:SteamID(), ":", "_")).."/characters.txt"
	local indexStringA		= file.Read(indexDir, "DATA")
	local indexTableA		= string.Explode("\n", indexStringA)
	local indexKey			= tonumber(self:GetNWInt("V.Hex.Rank.Key"))
	local indexTableB		= string.Explode("‼", indexTableA[indexKey])
	table.remove(indexTableB, 2)
	table.insert(indexTableB, 2, rank)
	table.remove(indexTableB, 3)
	table.insert(indexTableB, 3, train)
	table.remove(indexTableA, indexKey)
	table.insert(indexTableA, indexKey, table.concat(indexTableB, "‼"))
	local indexStringB		= table.concat(indexTableA, "\n")
	
	//file.Delete(indexDir)
	file.Write(indexDir, indexStringB)
end

hook.Add('PlayerSay', "V.Hex.Ranks.Commands", function(ply, text, teamChat)
	if text == chatCommands["ranks.menu"] then
		ply:ConCommand("V.Hex.Ranks.Menu")
	
		return false
	elseif text == chatCommands["ranks.promote"] then
		ply:ConCommand("V.Hex.Ranks.Promote")
	
		return false
	elseif	text == chatCommands["ranks.demote"] then
		ply:ConCommand("V.Hex.Ranks.Demote")
	
		return false
	elseif text == chatCommands["ranks.train"] then
		ply:ConCommand("V.Hex.Ranks.Train")
		
		return false
	end
end)

util.AddNetworkString("V.Hex.Rank.Update")
net.Receive("V.Hex.Rank.Update", function(len, ply)
	local indexPlayer 	= net.ReadEntity()
	local indexRank		= net.ReadInt(32)
	local indexTrain	= net.ReadInt(32)
	
	if indexPlayer:IsPlayer() then
		indexPlayer:vSetRank(indexRank, indexTrain)
		indexPlayer:SetNWInt("V.Hex.Rank", indexRank)
		indexPlayer:SetNWInt("V.Hex.Rank.Trainer", indexTrain)
	end
end)
