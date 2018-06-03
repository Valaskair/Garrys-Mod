local ChatCommands = {
	["ranks.menu"] 		= "!ranks", // Command to open up Ranks UI, only AllowedAlter can utilize this
	["ranks.promote"]	= "!promote",
	["ranks.demote"]	= "!demote",
	["ranks.train"]		= "!train",
	
	["character.menu"]	= "!characters",
	
	["config"]			= "!config" // Command to open up config UI, only AllowedEdit can utilize this
}

local AllowedEdit = { "owner" }

local RestrictedNames = {}	// Restricted Names (Non-case-sensitive)

local AllowedNavy = { "superadmin", "owner" }	// Usergroups allowed to create Navy character
local AllowedJedi = { "superadmin", "owner" }	// Usergroups allowed to create Jedi character

/* ["Weapon Class Name"] = { "Slot", "Weapon Display Name", <Weapon Cost>, <Required Group>, "Required Position" }
/
	Groups =;	1 = Clone,
				2 = Navy,
				3 = Jedi.
				
	If no required group leave at 0, if no required position leave at "" (This is for battallions later)
*/

local LoadoutWeapons = {
	["weapon_crossbow"] = { "Primary", "Crossbow", 1000, 1, "none" },
	["weapon_medkit"] = { "Special", "Medkit", 1000, 1, "medic" },
}

/* ["Ammo Class Name"] = { "Ammo Display name", <Amount>, <Cost> } */
local LoadoutAmmo = {
	["XBowBolt"] = { "Crossbow Bolts", 10, 50 },
}

/*	Tables are for Clones, Navy, Jedi in that order
	the numbers are { x, y, a, b }
	x = minimum allowed rank
	y = maximum allowed rank
	a = minimum rank can promote/demote
	b = maximum rank can promote/demote
	
	see the commented numbers for each rank
 */
local RankPowers = {
	{
		{ 14, 20, 2, 12 },
		{ 21, 21, 2, 19 },
		{ 24, 24, 2, 22 },
		{ 25, 25, 2, 25 },
		{ 27, 27, 2, 25 },
	},
	
	{
		{ 12, 12, 1, 10 },
		{ 16, 16, 1, 14 },
		{ 20, 20, 1, 18 },
		{ 22, 22, 1, 20 },
	},
	
	{
		{ 5, 5, 1, 2 },
		{ 6, 6, 1, 3 },
		{ 7, 7, 1, 6 }
	}
}

/* Ranks: { "Display Name", "Display Tag", "Player Model", true/false (Show display name over tag) } */

local ArmyRanks = {
	// 1
	{ "Clone Recruit", "CR", "models/player/combine_super_soldier.mdl", false },
	// 2
	{ "Clone Trooper", "CT", "models/player/combine_super_soldier.mdl", false },
	// 3
	{ "Private", "PVT", "models/player/combine_super_soldier.mdl", false },
	// 4
	{ "Private First Class", "PFC", "models/player/combine_super_soldier.mdl", false },
	// 5
	{ "Lance Corporal", "LCPL", "models/player/combine_super_soldier.mdl", false },
	// 6
	{ "Corporal", "CPL", "models/player/combine_super_soldier.mdl", false },
	// 7
	{ "Sergeant", "SGT", "models/player/combine_super_soldier.mdl", false },
	// 8
	{ "Staff Sergeant", "SSGT", "models/player/combine_super_soldier.mdl", false },
	// 9
	{ "Sergeant First Class", "SFC", "models/player/combine_super_soldier.mdl", false },
	// 10
	{ "Master Sergeant", "MSG", "models/player/combine_super_soldier.mdl", false },
	// 11
	{ "First Sergeant", "1SG", "models/player/combine_super_soldier.mdl", false },
	// 12
	{ "Sergeant Major", "SGM", "models/player/combine_super_soldier.mdl", false },
	// 13
	{ "Warrant Officer", "WO", "models/player/combine_super_soldier.mdl", false },
	// 14
	{ "2nd Lieutenant", "(ndLT", "models/player/combine_super_soldier.mdl", false },
	// 15
	{ "Lieutenant", "LT", "models/player/combine_super_soldier.mdl", false },
	// 16
	{ "Captain", "CPT", "models/player/combine_super_soldier.mdl", false },
	// 17
	{ "Major", "MAJ", "models/player/combine_super_soldier.mdl", false },
	// 18
	{ "Lieutenant Colonel", "LTC", "models/player/combine_super_soldier.mdl", false },
	// 19
	{ "Colonel", "COL", "models/player/combine_super_soldier.mdl", false },
	// 20
	{ "Executive Officer", "XO", "models/player/combine_super_soldier.mdl", false },
	// 21
	{ "Battalion Commander", "CMB", "models/player/combine_super_soldier.mdl", false },
	// 22
	{ "Regimental Commander", "RCM", "models/player/combine_super_soldier.mdl", false },
	// 23
	{ "Senior Commander", "SCMD", "models/player/combine_super_soldier.mdl", false },
	// 24
	{ "Marshall Commander", "MCMD", "models/player/combine_super_soldier.mdl", false },
	// 25
	{ "General", "", "models/player/combine_super_soldier.mdl", true },
	// 26
	{ "Brigadier General", "", "models/player/combine_super_soldier.mdl", true },
	// 27
	{ "General of the Republic Army", "", "models/player/combine_super_soldier.mdl", true }
}

local FleetRanks = { 
	// 1
	{ "Seaman Recruit", "SEA REC", "models/player/combine_super_soldier.mdl", false }, 
	// 2
	{ "Seaman", "SEA", "models/player/combine_super_soldier.mdl", false },
	// 3
	{ "Senior Seaman", "SEA SEN", "models/player/combine_super_soldier.mdl", false },
	// 4
	{ "Petty Officer 3rd Class", "PO3", "models/player/combine_super_soldier.mdl", false },
	// 5
	{ "Petty Officer 2nd Class", "PO2", "models/player/combine_super_soldier.mdl", false },
	// 6
	{ "Petty Officer 1st Class", "PO1", "models/player/combine_super_soldier.mdl", false },
	// 7
	{ "Chief Petty Officer", "CPO", "models/player/combine_super_soldier.mdl", false },
	// 8
	{ "Senior Chief Petty Officer", "SCPO", "models/player/combine_super_soldier.mdl", false },
	// 9
	{ "Master Chief Petty Officer", "MCPO", "models/player/combine_super_soldier.mdl", false },
	// 10
	{ "Warrant Officer", "WO", "models/player/combine_super_soldier.mdl", false },
	// 11
	{ "Officer Cadet", "OC", "models/player/combine_super_soldier.mdl", false },
	// 12
	{ "Ensign", "ENS", "models/player/combine_super_soldier.mdl", false },
	// 13
	{ "Lieutenant Junior Grade", "LTJG", "models/player/combine_super_soldier.mdl", false },
	// 14
	{ "Lieutenant", "LT", "models/player/combine_super_soldier.mdl", false },
	// 15
	{ "Lieutenant Commander", "LTCMD", "models/player/combine_super_soldier.mdl", false },
	// 16
	{ "Commander", "CMD", "models/player/combine_super_soldier.mdl", false },
	// 17
	{ "Captain", "CPT", "models/player/combine_super_soldier.mdl", false },
	// 18
	{ "Rear Admiral Lower Half", "RDML", "models/player/combine_super_soldier.mdl", false },
	// 19
	{ "Rear Admiral Upper Half", "RDM", "models/player/combine_super_soldier.mdl", false },
	// 20
	{ "Vice Admiral", "", "models/player/combine_super_soldier.mdl", true },
	// 21
	{ "Admiral", "", "models/player/combine_super_soldier.mdl", true },
	// 22
	{ "Grand Admiral", "", "models/player/combine_super_soldier.mdl", true }
}

local JediRanks = { 
	// 1
	{ "Youngling", "", "models/player/combine_super_soldier.mdl", true },
	// 2
	{ "Padawan", "", "models/player/combine_super_soldier.mdl", true },
	// 3
	{ "Knight", "", "models/player/combine_super_soldier.mdl", true },
	// 4
	{ "Master", "", "models/player/combine_super_soldier.mdl", true },
	// 5
	{ "Council Member", "", "models/player/combine_super_soldier.mdl", true },
	// 6
	{ "Master of the Order", "", "models/player/combine_super_soldier.mdl", true },
	// 7
	{ "Grand Master", "", "models/player/combine_super_soldier.mdl", true }
}

local Colour = {
	Color(43, 220, 255), 	// Army
	Color(212, 136, 219),	// Navy
	Color(76, 212, 63)		// Jedi
}

local TimePromo = 5		// Duration of event (seconds)

local AllowedAlter = { "owner" }	// Usergroups with access to ranks (setting)

local ColourBase			= Color(0, 0, 0)		// Base		All UI
local ColourAccent 			= Color(255, 0, 0)		// Accent	All UI
local ColourText			= Color(255, 255, 255)	// Text		All UI
local ColourAccentSecondary	= Color(150, 0, 0)		// Secondary Accent All UI
local ColourBaseSecondary	= Color(50, 50, 50)		// Secondary Accent All UI

/* !!! CONFIGURATION ENDS HERE !!! */
/* !!!    DO NOT EDIT BELOW    !!! */

VHexCharacterRestricted		= RestrictedNames
VHexCharacterAllowedNavy	= AllowedNavy
VHexCharacterAllowedJedi	= AllowedJedi
VHexRank 					= { ArmyRanks, FleetRanks, JediRanks }
VHexRankColour				= Colour
VHexRankTime				= TimePromo
VHexRankAllowed				= AllowedAlter
VHexTheme					= { ColourBase, ColourBaseSecondary, ColourAccent, ColourAccentSecondary, ColourText }
VHexConfig					= AllowedEdit
VHexChatCommands			= ChatCommands
VHexTrainer					= { { "Training Officer", "TO" }, { "Senior Training Officer", "STO" } }
VHexRankRestrictions		= RankPowers

