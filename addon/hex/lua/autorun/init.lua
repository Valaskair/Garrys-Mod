if SERVER then
	include('config.lua')
	AddCSLuaFile("config.lua")
	
	include('sv/sv_characters.lua')
	AddCSLuaFile("cl/cl_characters.lua")
	
	include('sv/sv_ranks.lua')
	AddCSLuaFile("cl/cl_ranks.lua")
	
	include('sv/sv_loadout.lua')
	AddCSLuaFile("cl/cl_loadout.lua")
elseif CLIENT then
	include("config.lua")
	
	include("cl/cl_characters.lua")
	
	include("cl/cl_ranks.lua")
	
	include("cl/cl_loadout.lua")
end
