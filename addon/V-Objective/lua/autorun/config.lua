Port = {}
Fuse = {}

TimeInterval = 5 -- [[ The time between Fuse spawns and Port uses = IN SECONDS ]] --
salaryMultiplier = 2 -- [[ How much to multiply the default salary by || Default = x2 ]] --

local PositionPort 	= Vector(-157, 497, -12223)
local AnglesPort	= Angle(0, 0, 0)

local FuseA = {}
local PositionFuseA	= Vector(-610.190552, -700.490723, -12151.431641)
local AnglesFuseA	= Angle(0, 0, 0)

local FuseB = {}
local PositionFuseB	= Vector(-610.190552, -700.490723, -12151.431641)
local AnglesFuseB	= Angle(0, 0, 0)

local FuseC = {}
local PositionFuseC	= Vector(-610.190552, -700.490723, -12151.431641)
local AnglesFuseC	= Angle(0, 0, 0)

soundUsed = "weapons/ar2/ar2_reload_push.wav" // Sound to play when Fuse collides with Port if you don't want to play a sound make sure string is empty | EX: ""

Models = {}
Models[1] = "models/props_borealis/bluebarrel001.mdl"
Models[2] = "models/props_borealis/bluebarrel001.mdl"	-- [[ Models 1 2 3 are the fuses ]] --
Models[3] = "models/props_borealis/bluebarrel001.mdl"

Models[5] = "models/props_interiors/VendingMachineSoda01a.mdl"	-- [[ Model 5 is the port ]] --

VTeam = {}

VTeam[1] = { "STEAM_0:1:47057013" }
VTeam[2] = { "STEAM_0:1:84230100" }

-- [[ ALL ABOVE IS CONFIGURATION || ALL BELOW IS UTILIZING THE GIVEN DATA ]] --

boostedTeam = {}

if IsValid(PositionPort) and IsValid(AnglesPort) then
	Port["Position"]	= (PositionPort)
	Port["Angles"]		= (AnglesPort)
else
	Port["Position"]	= Vector(0, 0, 0)
	Port["Angles"]		= Angle(0, 0, 0)
end

local indexedVector = Vector(0, 0, 0)
local indexedAngle	= Angle(0, 0, 0)

local indexVectors = {}
indexVectors[1] = (PositionFuseA)
indexVectors[2] = (PositionFuseB)
indexVectors[3] = (PositionFuseC)

local indexAngles = {}
indexAngles[1] = (AnglesFuseA)
indexAngles[2] = (AnglesFuseB)
indexAngles[3] = (AnglesFuseC)


FuseA["Position"] 	= (indexVectors[1])
FuseA["Angles"]		= (indexAngles[1])

FuseB["Position"] 	= (indexVectors[2])
FuseB["Angles"]		= (indexAngles[2])

FuseC["Position"] 	= (indexVectors[3])
FuseC["Angles"]		= (indexAngles[3])

local indexFuse = {}
indexFuse[1] = (FuseA)
indexFuse[2] = (FuseB)
indexFuse[3] = (FuseC)

for i = 1, (#indexFuse) do
	Fuse[i] = (indexFuse[i])
end

Port["Position"] = PositionPort
Port["Angles"]	 = AnglesPort
