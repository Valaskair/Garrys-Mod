local meta = FindMetaTable("Player")

function meta:vCreateInventorySlate()
	local indexDir = "v/"..string.lower(string.Replace(self:SteamID(), ":", "_")).."/inventory.txt"
	
	if not file.Exists(indexDir, "DATA") then
		file.Write(indexDir, "none\nnone\nnone\n")
	end
end

function meta:vGetInventory()
	local indexDir 		= "v/"..string.lower(string.Replace(self:SteamID(), ":", "_")).."/inventory.txt"
	local indexString	= file.Read(indexDir, "DATA")
	local indexTableA	= string.Explode("\n", indexString)
	local indexTableB	= string.Explode("‼", indexTableA[4])
	
	return indexTableB
end

function meta:vAddInventory(item)
	local indexDir 		= "v/"..string.lower(string.Replace(self:SteamID(), ":", "_")).."/inventory.txt"
	local indexStringA	= file.Read(indexDir, "DATA")
	local indexTableA	= string.Explode("\n", indexStringA)
	local indexTableB	= string.Explode("‼", indexTableA[4])
	table.insert(indexTableB, item)
	local indexStringB	= table.concat(indexTableB, "‼")
	table.remove(indexTableA, 4)
	table.insert(indexTableA, 4, indexStringB)
	local indexStringC	= table.cocnat(indexTableA, "\n")
	
	file.Write(indexDir, indexStringC)
end

function meta:vUpdateLoadout()
	local indexDir 		= "v/"..string.lower(string.Replace(self:SteamID(), ":", "_")).."/inventory.txt"
	local indexString	= file.Read(indexDir, "DATA")
	local indexTable	= string.Explode("\n", indexString)
	
	self:SetNWString("V.Hex.Loadout.Primary", indexTable[1])
	self:SetNWString("V.Hex.Loadout.Secondary", indexTable[2])
	self:SetNWString("V.Hex.Loadout.Special", indexTable[3])
end

function meta:vGetLoadout()
	local indexPrimary = self:GetNWString("V.Hex.Loadout.Primary", "none")
	local indexSecondary = self:GetNWString("V.Hex.Loadout.Secondary", "none")
	local indexSpecial = self:GetNWString("V.Hex.Loadout.Special", "none")
	
	return { indexPrimary, indexSecondary, indexSecondary }
end

function meta:vSetLoadout(loadout)
	self:SetNWString("V.Hex.Loadout.Primary", loadout[1])
	self:SetNWString("V.Hex.Loadout.Secondary", loadout[2])
	self:SetNWString("V.Hex.Loadout.Special", loadout[3])
	
	local indexDir 		= "v/"..string.lower(string.Replace(self:SteamID(), ":", "_")).."/inventory.txt"
	local indexStringA	= file.Read(indexDir, "DATA")
	local indexTable	= string.Explode("\n", indexStringA)
	
	for k, v in pairs(loadout) do
		table.remove(indexTable, k)
		table.insert(indexTable, k, v)
	end
	
	local indexStringB	= table.concat(indexTable, "\n")
	file.Write(indexDir, indexStringB)
end

hook.Add('PlayerInitialSpawn', "V.Hex.Loadout.Init.Player", function(ply)
	ply:vCreateInventorySlate()
end)

hook.Add('PlayerSpawn', "V.Hex.Loadout.Update.Player", function(ply)
	ply:vUpdateLoadout()
	local indexTable = ply:vGetLoadout()
	
	for k, v in pairs(indexTable) do
		ply:Give(v)
	end
end)

hook.Add('Think', "V.Hex.Loadout.Update", function()
	for k, v in pairs(player.GetAll()) do
		if v:Alive() then
			for a, b in pairs(v:GetWeapons()) do
				local indexClass = b:GetClass()
				local indexTable = v:vGetLoadout()
				if not table.HasValue(indexTable, indexClass) then
					v:StripWeapon(indexClass)
				end
			end
		end
	end
end)
