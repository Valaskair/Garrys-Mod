function spawnPort(model, pos, ang)
	local port = (ents.Create("val_port"))
	if (!IsValid(port)) then return end
	port:SetPos(pos)
	port:SetAngles(ang)
	
	port:Spawn()
	port:SetModel(model)
end

function spawnFuse(model, pos, ang, ind)
	local fuse = (ents.Create("val_fuse"))
	if (!IsValid(fuse)) then return end
	fuse:SetDTInt(0, ind)
	fuse:SetPos(pos)
	fuse:SetAngles(ang)
	
	fuse:Spawn()
	fuse:SetModel(model)
end

/* ALL ABOVE ARE ABSTRACT METHODS/FUNCTIONS */

function SpawnPorts()
	local model = (Models[5])
	local pos	= (Port["Position"])
	local ang	= (Port["Angles"])
	
	spawnPort(model, pos, ang)
end

function SpawnFuses()
	for i = 1, (#Fuse) do
		local fuseTable = (Fuse[i])
		local fuseMod 	= (Models[i])
		local fusePos	= (fuseTable["Position"])
		local fuseAng	= (fuseTable["Angles"])
		
		spawnFuse(fuseMod, fusePos, fuseAng, i)
	end
end

/* ABOVE ARE THE FUNCTIONS THAT UTILIZE THE ABSTRACT FUNCTIONS AND TABLES TO SPAWN THE ENTITIES*/

timer.Simple(5, function()
	SpawnPorts()
	SpawnFuses()
	
	print("Ports/Fuses Initialized!")
end)

/* ABOVE WE ACTUALLY CALL THE FUNCTIONS */

function spawnAllF()
	SpawnFuses()
end

hook.Add("Think", "UpdateBoostedBonus", function()
	for k, v in pairs(player.GetAll()) do
		local jobTable = (v:getJobTable())
		local defaultSalary = (jobTable["salary"])
		local bonusSalary = (defaultSalary * salaryMultiplier)
		
		if table.HasValue(boostedTeam, v:SteamID()) then
			v:setDarkRPVar("salary", bonusSalary)
		else
			v:setDarkRPVar("salary", defaultSalary)
		end
	end
end)
