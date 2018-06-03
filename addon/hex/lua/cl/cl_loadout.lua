local Base 				= VHexTheme[1]
local BaseAccent		= VHexTheme[2]
local Secondary			= VHexTheme[3]
local SecondaryAccent	= VHexTheme[4]
local Text				= VHexTheme[5]

hook.Add("PlayerBindPress", "vUpdateLoadout", function(ply, bind, pressed)
	if IsValid(ply) and ply:Alive() then
		if bind == "invnext" then

		elseif bind == "invprev" then
			
		end
	end
end)
	
local function drawCircle( x, y, radius, seg, col )
	local cir = {}

	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end

	local a = math.rad( 0 )
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

	surface.SetDrawColor(col)
	surface.DrawPoly(cir)
end

local function drawSlot(id)
	if id == "primary" then
	
	elseif id == "secondary" then
	
	elseif id == "special" then
	
	end
end

local function DrawLoadout()
	local ply = LocalPlayer()
	
	local originX = ScrW()
	local originY = ScrH() - 130
	
	drawCircle(originX, originY, 125, 100, Secondary)
	drawCircle(originX, originY, 123, 100, Base)
	
	drawSlot("primary")
	drawSlot("secondary")
	drawSlot("special")
end
/*
hook.Add("HUDPaint", "vDrawLoadout", DrawLoadout)

hook.Add("HUDShouldDraw", "HideDefHUD", function(name)
	if name == "CHudWeaponSelection" then
		return true
	end
end)
*/
