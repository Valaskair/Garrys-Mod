AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
 
include('shared.lua')
 
function ENT:Initialize()
	self:SetModel(Models[5])
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
 
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	
	self:SetUseType(SIMPLE_USE)
	
	self:SetDTInt(0, 0)
end

function ENT:SetupDataTables()
	self:DTVar("Int", 0, "CanUse")
end

function ENT:Use(activator, caller)
	if (self:GetDTInt(0) == 1) then
		caller:PrintMessage(HUD_PRINTTALK, "Objective Complete!")
		
		for i = 1, (#VTeam) do
			if table.HasValue(VTeam[i], caller:SteamID()) then
				boostedTeam = VTeam[i]
			else
				table.insert(boostedTeam, (caller:SteamID()))
			end
		end
		
		self:SetDTInt(0, 0)
		
		timer.Simple(TimeInterval, function()	
			spawnAllF()
			for i = 1, (table.Count(boostedTeam)) do
				table.remove(boostedTeam, i)
			end
			table.RemoveByValue(boostedTeam, caller:SteamID())
		end)
	end
end
