local en = true

local function toX(x)
	return (ScrW() * (x / 1768))
end

local function toY(y)
	return (ScrH() * (y / 992))
end

if CLIENT then
	local iconArmour = "oasis/armour"
	local iconBase = "oasis/base"
	local iconHealth = "oasis/health"
	local iconHunger = "oasis/hunger"
	local iconJob = "oasis/job"
	local iconModule = "oasis/module"
	local iconMoney = "oasis/money"
	local iconTime = "oasis/time"
	
	local white = Color(255, 255, 255)

	local function hideDefaultHUD(name)
		for k, v in pairs({ "CHudHealth", "CHudBattery" }) do
			if name == v then 
				return !en 
			end
		end
	end
	hook.Add("HUDShouldDraw", "HideDefHUD", hideDefaultHUD)

	local function drawIcon(x, y, w, h, texture)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetTexture(surface.GetTextureID(texture))
		surface.DrawTexturedRect(x, y, w, h)
	end
	
	local initFont = false
	function drawHUD()
		if !initFont then
			surface.CreateFont("HUDText", {
				font = "Arial",
				extended = false,
				size = ScreenScale(9),
				weight = 500,
				blursize = 0,
				scanlines = 0,
				antialias = true,
				underline = false,
				italic = false,
				strikeout = false,
				symbol = false,
				rotary = false,
				shadow = false,
				additive = false,
				outline = false
			})
			initFont = true
		end
		
		time = os.date( "%H:%M:%S" , os.time())
		
		ply = LocalPlayer()
		playerJob = ply:getDarkRPVar("job")
		playerHealth = (ply:Health() / ply:GetMaxHealth()) * 100
		playerArmour = ply:Armor()
		playerHunger = ply:getDarkRPVar("Energy")
		money = DarkRP.formatMoney(ply:getDarkRPVar("money"))
		salary = DarkRP.formatMoney(ply:getDarkRPVar("salary"))
		playerWallet = money.." + "..salary.."/hr"
		
		surface.SetFont("HUDText")
		
		drawIcon(0, 0, ScrW(), toY(32), iconBase)
		
		local HealthX = surface.GetTextSize(playerJob) + toX(45)
		drawIcon(0, 0, HealthX, toY(32), iconModule)
		drawIcon(toX(6), toY(3), toX(24), toY(24), iconJob)
		draw.DrawText(playerJob, "HUDText", toX(35), toY(3), team.GetColor(ply:Team()), TEXT_ALIGN_LEFT)
		
		local ArmourX = HealthX + surface.GetTextSize("100%") + toX(45)
		drawIcon(HealthX - toX(2), 0 , HealthX + toX(5), toY(32), iconModule)
		drawIcon(HealthX + toX(6), toY(3), toX(24), toY(24), iconHealth)
		draw.DrawText(playerHealth.."%", "HUDText", HealthX + toX(35), toY(3), white, TEXT_ALIGN_LEFT)
		
		local HungerX = ArmourX + surface.GetTextSize("100%") + toX(43)
		drawIcon(ArmourX - toX(2), 0, ArmourX - HealthX, toY(32), iconModule)
		drawIcon(ArmourX + toX(6), toY(3), toX(24), toY(24), iconArmour)
		draw.DrawText(playerArmour.."%", "HUDText", ArmourX + toX(35), toY(3), white, TEXT_ALIGN_LEFT)
		
		local WalletX = HungerX + surface.GetTextSize("100%") + toX(43)
		drawIcon(HungerX - toX(2), 0, HungerX - ArmourX, toY(32), iconModule)
		drawIcon(HungerX + toX(6), toY(3), toX(24), toY(24), iconHunger)
		draw.DrawText(playerHunger.."%", "HUDText", HungerX + toX(35), toY(3), white, TEXT_ALIGN_LEFT)
	
		local TimeX = WalletX + surface.GetTextSize(playerWallet) + toX(45)
		drawIcon(WalletX - toX(2), 0, WalletX - HungerX + (surface.GetTextSize(playerWallet)), toY(32), iconModule)
		drawIcon(WalletX + toX(6), toY(3), toX(24), toY(24), iconMoney)
		draw.DrawText(playerWallet, "HUDText", WalletX + toX(35), toY(3), white, TEXT_ALIGN_LEFT)
		
		drawIcon(TimeX - toX(2), 0, TimeX - WalletX - toX(45), toY(32), iconModule)
		drawIcon(TimeX + toX(6), toY(3), toX(24), toY(24), iconTime)
		draw.DrawText(time, "HUDText", TimeX + toX(35), toY(3), white, TEXT_ALIGN_LEFT)
	end
	if gmod.GetGamemode().Name == "DarkRP" and en then
		hook.Add("HUDPaint", "DrawHUD", drawHUD)
	end
end
