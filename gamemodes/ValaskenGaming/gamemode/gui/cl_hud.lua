pWeaponName = ""

function hideDefaultHUD(name)
	for k, v in pairs({"CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo", "CHudDeathNotice"})do
		if name == v then return false end
	end
end
hook.Add("HUDShouldDraw", "HideDefaultHUD", hideDefaultHUD)

function draw.Circle(x, y, radius, segments)
	local circle = {}

	table.insert(circle, {x = x, y = y, u = 0.5, v = 0.5})
	for i = 0, segments do
		local a = math.rad(( i / segments) * -360)
		table.insert(circle, {x = x + math.sin(a) * radius, y = y + math.cos(a) * radius, u = math.sin(a) / 2 + 0.5, v = math.cos(a) / 2 + 0.5 })
	end

	local a = math.rad(0)
	table.insert(circle, {x = x + math.sin(a) * radius, y = y + math.cos(a) * radius, u = math.sin(a) / 2 + 0.5, v = math.cos(a) / 2 + 0.5 })

	surface.DrawPoly(circle)
end

function GM:HUDPaint()
	self.BaseClass:HUDPaint()
	
	local weaponLib = {}
	local weaponIndexI = ""

	local ply = (LocalPlayer())
	local pName = (LocalPlayer():Nick())
	local pMHealth = (LocalPlayer():GetMaxHealth())
	local pHealth = (LocalPlayer():Health())
	local pArmor = (LocalPlayer():Armor())
	local pClip = 0
	local pAmmo = 0
	
	//if ((ply:Alive()) and (ply:GetActiveWeapon()) != nil and (ply:GetActiveWeapon():GetPrintName())) then	
		//pWeaponName = (ply:GetActiveWeapon():GetPrintName())
		//pClip = (ply:GetActiveWeapon():Clip1())
		//pAmmo = (ply:GetAmmoCount(ply:GetActiveWeapon():GetPrimaryAmmoType()))
	//else
		pWeaponName = "None"
		pClip = 0
		pAmmo = 0
	//end
	
	local x = (ScrW()) local y = (ScrH()) 
	local originX = (x) local originY = (y)
	local infoOriginX = (originX - (x * 0.2)) local infoOriginY = (originY - (y * 0.3))

	local HealthBarWidth = ((x * 0.09375) * (pHealth / pMHealth))
	if HealthBarWidth > (x * 0.09375) then
		HealthBarWidth = (x * 0.09375)
	end
	local ArmorBarWidth = ((x * 0.09375) * (pArmor / 100))
	if ArmorBarWidth > (x * 0.09375) then
		ArmorBarWidth = (x * 0.09375)
	end
	local AmmoBarWith = 0
	
	surface.CreateFont("VG-Name", {
		font = "Roboto",
		size = ScreenScale(13), 
		weight = 400, 
		antialias = true, 
		italic = false
	})
	surface.CreateFont("VG-Info", {
		font = "Trebuchet24",
		size = ScreenScale(10),
		weight = 200,
		antialias = true,
		italic = false
	})
	surface.CreateFont("VG-Info-Point", {
		font = "Trebuchet24",
		size = ScreenScale(8),
		weight = 200,
		antialias = true,
		italic = false
	})

	surface.SetDrawColor(Color(50, 50, 200, 255))
	draw.Circle((originX), (originY), (x * 0.205), 50)
	surface.SetDrawColor(Color(50, 50, 150, 255))
	draw.Circle((originX), (originY), (x * 0.2), 50)
	
	surface.SetDrawColor(Color(255, 255, 255, 225))
	
	draw.DrawText(pName, "VG-Name", (infoOriginX + (x * 0.125)), (infoOriginY + (y * 0.0555)), Color(255, 255, 255), TEXT_ALIGN_CENTER)
	
	draw.DrawText("Health: ", "VG-Info", (infoOriginX + (x * 0.06)), (infoOriginY + (y * 0.1125)), Color(255, 255, 255), TEXT_ALIGN_CENTER)
	surface.SetDrawColor(Color(255, 0, 0, 255))
	surface.DrawOutlinedRect((infoOriginX + (x * 0.093125)), (infoOriginY + (y * 0.1205)), (x * 0.095), (y * 0.0244))
	surface.SetDrawColor(Color(255, 25, 25, 125))
	surface.DrawRect((infoOriginX + (x * 0.09375)), (infoOriginY + (y * 0.1216)), HealthBarWidth, (y * 0.0222))
	draw.DrawText(pHealth, "VG-Info-Point", (infoOriginX + (x * 0.140625)), (infoOriginY + (y * 0.12)), Color(255, 255, 255), TEXT_ALIGN_CENTER)
	
	draw.DrawText("Armor: ", "VG-Info", (infoOriginX + (x * 0.061875)), (infoOriginY + (y * 0.1425)), Color(255, 255, 255), TEXT_ALIGN_CENTER)
	surface.SetDrawColor(Color(0, 0, 255, 255))
	surface.DrawOutlinedRect((infoOriginX + (x * 0.093125)), (infoOriginY + (y * 0.147)), (x * 0.095), (y * 0.0244))
	surface.SetDrawColor(Color(25, 25, 255, 125))
	surface.DrawRect((infoOriginX + (x * 0.09375)), (infoOriginY + (y * 0.1483)), ArmorBarWidth, (y * 0.0222))
	draw.DrawText(pArmor, "VG-Info-Point", (infoOriginX + (x * 0.140625)), (infoOriginY + (y * 0.145)), Color(255, 255, 255), TEXT_ALIGN_CENTER)
	
	draw.DrawText("Weapon: ", "Trebuchet24", (infoOriginX + (x * 0.0625)), (infoOriginY + (y * 0.19375)), Color(255, 255, 255), TEXT_ALIGN_CENTER)
	draw.DrawText("Clip: ", "Trebuchet24", (infoOriginX + (x * 0.075)), (infoOriginY + (y * 0.2222)), Color(255, 255, 255), TEXT_ALIGN_CENTER)
	draw.DrawText("Ammo: ", "Trebuchet24", (infoOriginX + (x * 0.0675)), (infoOriginY + (y * 0.25)), Color(255, 255, 255), TEXT_ALIGN_CENTER)

	draw.DrawText(pWeaponName, "VG-Info-Point", (infoOriginX + (x * 0.140625)), (infoOriginY + (y * 0.1975)), Color(255, 255, 255), TEXT_ALIGN_CENTER)
	draw.DrawText(pClip, "VG-Info-Point", (infoOriginX + (x * 0.140625)), (infoOriginY + (y * 0.225)), Color(255, 255, 255), TEXT_ALIGN_CENTER)
	draw.DrawText(pAmmo, "VG-Info-Point", (infoOriginX + (x * 0.140625)), (infoOriginY + (y * 0.2525)), Color(255, 255, 255), TEXT_ALIGN_CENTER)
end
