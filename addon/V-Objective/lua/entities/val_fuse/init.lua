AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
 
include('shared.lua')

local index = 1

function ENT:SetupDataTables()
	self:DTVar("Int", 0, "ModelIndex")
end
 
function ENT:Initialize()
	if (self:GetDTInt(0) != 0) then
		index = (self:GetDTInt(0))
	else
		index = 1
	end

	self:SetModel(Models[index])
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
 
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	
	self:SetTrigger(true)
end

function ENT:StartTouch(entity)
	if (entity:GetClass() == "val_port") then
		for k, v in pairs(ents.GetAll()) do
			if (v:GetClass() == "val_fuse") then
				local effectData = EffectData()
				effectData:SetOrigin(v:GetPos())
				util.Effect("cball_explode", effectData)
				
				if soundUsed != "" then
					sound.Play(soundUsed, (entity:GetPos()), 75, 100, 1)
				end
			
				v:Remove()
			end
		end
		self:Remove()
		
		entity:SetDTInt(0, 1)
	end
end
