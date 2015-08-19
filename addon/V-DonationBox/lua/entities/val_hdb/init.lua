AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
 
include('shared.lua')
 
function ENT:Initialize()
	self:SetModel("models/props/CS_militia/footlocker01_open.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
 
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	
	self:SetUseType(SIMPLE_USE)
	self:SetTrigger(true)
	
	self:SetOwner(self.Owner)
end

function ENT:SetupDataTables()
	self:DTVar("Int", 0, "StoredMoney")
	self:DTVar("String", "Null", "OwnerName")
end

function ENT:Use(activator, caller)
	print(self:GetDTInt(0))
	if (activator) == (self:GetCreator()) then
		activator:addMoney(self:GetDTInt(0))
		if (self:GetDTInt(0)) != 0 then
			DarkRP.notify(activator, 0, 4, DarkRP.getPhrase("found_money", DarkRP.formatMoney(self:GetDTInt(0))))
		end
		self:SetDTInt(0, 0)
	end
    return
end

function ENT:StartTouch(entity)
	if entity:GetClass() == "spawned_money" then
		self:SetDTInt(0, ((self:GetDTInt(0)) + entity:Getamount()))
		entity:Remove()
	end
	
 	if (entity:IsValid() and entity:IsPlayer()) then
 		if self:GetCreator() == nil then
			self:SetCreator(entity)
		end
	end
end
 
function ENT:Think()
	if (self:GetCreator() != nil) then
		self:SetDTString(0, (self:GetCreator():Nick()))
	end
end
