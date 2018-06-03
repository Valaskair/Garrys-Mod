local meta = FindMetaTable("Player")

function meta:vCreateCharacterSlate()
	local indexDir		= string.lower("v/"..string.Replace(self:SteamID(), ":", "_"))
	local indexTable	= { "Create", "Create", "Create" }
	local indexString	= table.concat(indexTable, "\n")
	
	file.CreateDir(indexDir)
	file.Write(indexDir.."/characters.txt", indexString)
end
function meta:vGetCharacters()
	local indexDir		= string.lower("v/"..string.Replace(self:SteamID(), ":", "_")).."/characters.txt"
	local indexString	= file.Read(indexDir, "DATA")
	local indexTable	= string.Explode("\n", indexString)
	
	return indexTable
end

function meta:vSetCharacter(key)
	local indexTable		= self:vGetCharacters()
	local indexCharacter	= string.Explode("‼", indexTable[tonumber(key)])
	
	local indexName	= indexCharacter[1]
	local indexRank	= indexCharacter[2]
	
	self:SetNWInt("V.Hex.Rank.Key", tonumber(key))
	self:SetNWInt("V.Hex.Rank", tonumber(indexRank))
	self:SetNWInt("V.Hex.Rank.Trainer", tonumber(indexCharacter[3]))
	self:SetNWString("V.Hex.Name", indexName)
	
	self:SetModel(VHexRank[tonumber(key)][tonumber(indexRank)][3])
	self:Spawn()
end

function meta:vCreateCharacter(key, name)
	local indexDir			= string.lower("v/"..string.Replace(self:SteamID(), ":", "_")).."/characters.txt"
	local indexStringA		= file.Read(indexDir, "DATA")
	local indexTableA		= string.Explode("\n", indexStringA)
	local indexStringB		= table.concat({ name, tostring(1), tostring(0) }, "‼")
	table.remove(indexTableA, key)
	table.insert(indexTableA, key, indexStringB)
	local indexCharacter	= table.concat(indexTableA, "\n")
	
	//file.Delete(indexDir)
	file.Write(indexDir, indexCharacter)
	file.Append("v/names.txt", name.."\n")
	
	self:vSetCharacter(key)
end

util.AddNetworkString("V.Hex.Characters.Request")
util.AddNetworkString("V.Hex.Characters.ToClient")

net.Receive("V.Hex.Characters.Request", function(len, ply)
	local indexDirA 	= string.lower("v/"..string.Replace(ply:SteamID(), ":", "_")).."/characters.txt"
	local indexStringA	= file.Read(indexDirA, "DATA")
	local indexTableA	= string.Explode("\n", indexStringA)
	
	local indexDirB		= string.lower("v/clone.txt")
	local indexStringB	= file.Read(indexDirB, "DATA")
	local indexTableB	= string.Explode("\n", indexStringB)
	
	local indexDirC		= string.lower("v/names.txt")
	local indexStringC	= file.Read(indexDirC, "DATA")
	local indexTableC	= string.Explode("\n", indexStringC)
	
	net.Start("V.Hex.Characters.ToClient")
		net.WriteTable(indexTableA)
		net.WriteTable(indexTableB)
		net.WriteTable(indexTableC)
	net.Send(ply)
end)

util.AddNetworkString("V.Hex.Characters.Create")
util.AddNetworkString("V.Hex.Characters.Load")

net.Receive("V.Hex.Characters.Create", function(len, ply)
	local indexName = net.ReadString()
	local indexKey	= net.ReadInt(32)
	
	ply:vCreateCharacter(indexKey, indexName)
end)

net.Receive("V.Hex.Characters.Load", function(len, ply)
	local indexKey = net.ReadInt(32)
	ply:vSetCharacter(indexKey)
	ply:SetNWBool("V.Hex.Loaded", true)
end)

util.AddNetworkString("V.Hex.Clone.Add")

net.Receive("V.Hex.Clone.Add", function(len, ply)
	local indexDir = "v/clone.txt"
	local indexString = net.ReadString().."\n"
	
	file.Append(indexDir, indexString)
end)

hook.Add('Initialize', "V.Hex.Character.Init", function()
	file.CreateDir("v/")
	
	if not file.Exists("v/clone.txt", "DATA") then
		file.Write("v/clone.txt", "")
	end
	
	if not file.Exists("v/names.txt", "DATA") then
		file.Write("v/names.txt", "")
	end
end)

hook.Add('PlayerInitialSpawn', "V.Hex.Character.Player.Spawn", function(ply)
	local indexDir = string.lower("v/"..string.Replace(ply:SteamID(), ":", "_")).."/characters.txt"
	
	if not file.Exists(indexDir, "DATA") then
		ply:vCreateCharacterSlate()
	end
	
	ply:ConCommand("V.Hex.Character.Menu")
end)

hook.Add('PlayerSay', "V.Hex.Character.Command", function(ply, text, teamChat)
	if text == VHexChatCommands["character.menu"] then
		ply:ConCommand("V.Hex.Character.Menu")
	
		return false
	end
end)

hook.Add('Think', "V.Hex.Character.Update.Name", function()
	for k, v in pairs(player.GetAll()) do
		local indexRankKey	= v:GetNWInt("V.Hex.Rank.Key", 0)
		local indexRank		= v:GetNWInt("V.Hex.Rank", 0)
		local indexTrainer	= v:GetNWInt("V.Hex.Rank.Trainer", 0)
	
		if not table.HasValue({1, 2, 3}, indexRankKey) then
			v:SetNWBool("V.Hex.Loaded", false)
		end
	
		if v:GetNWBool("V.Hex.Loaded", false) then
			local nameFull = VHexRank[tonumber(indexRankKey)][tonumber(indexRank)][4]
			local nameTagA
			local nameTagB
			
			if nameFull then
				nameTagA = VHexRank[tonumber(indexRankKey)][tonumber(indexRank)][1]
			else
				nameTagA = VHexRank[tonumber(indexRankKey)][tonumber(indexRank)][2]
			end
			
			if tonumber(indexRankKey) == 1 then
				if tonumber(indexTrainer) == 1 then
					nameTagB = VHexTrainer[tonumber(indexTrainer)][2].." "
				elseif tonumber(indexTrainer) == 2 then
					nameTagB = VHexTrainer[tonumber(indexTrainer)][2].." "
				end
			else
				nameTagB = ""
			end
			
			local indexName = nameTagB..nameTagA.." "..v:GetNWString("V.Hex.Name")
			v:SetNWString("V.Hex.Name.Display", indexName)
			
			if v:getDarkRPVar("rpname") != indexName then
				v:setDarkRPVar("rpname", indexName)
			end
		end
	end
end)
