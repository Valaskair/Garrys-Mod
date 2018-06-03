local en = true

local Colour = { Color(35, 35, 35), Color(168, 168, 168), Color(10, 10, 6) }
local white = Color(255, 255, 255)

local function toX(x)
	return ScrW() * (x / 1920)
end

local function toY(y)
	return ScrH() * (y / 1080)
end
if CLIENT then
	local function hideDefaultWeaponSelection(name)
		for k, v in pairs({ "CHudWeaponSelection" }) do
			if name == v then 
				return !en			
			end
		end
	end
	hook.Add("HUDShouldDraw", "HideDefaultWeaponSelection", hideDefaultWeaponSelection)
	
	local canDisplay, change
	
	local weaponsCur = {}
	
	local slots = { {}, {}, {}, {}, {}, {} }
	
	local weaponsOrganized = {}
	
	local cur = 2
	
	local initFont  = false
	local function drawWeaponSelection()
		if not initFont then
			surface.CreateFont("HUDWeaponText", {
				font = "Arial",
				extended = false,
				size = ScreenScale(8),
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
	
		local ply = LocalPlayer()

		if ply:Alive() then			
			if weaponsOrganized then
				if change then
					for k, v in pairs(slots) do
						local xOffset = (ScrW() / 2 ) + (k * toX(195)) - toX(780)
						
						surface.SetDrawColor(Colour[1])
						surface.DrawRect(xOffset, toY(50), toX(170), toY(30))
						draw.DrawText(k, "HUDWeaponText", xOffset + toX(85), toY(52), white, TEXT_ALIGN_CENTER)
						
						for x, y in pairs(v) do
							if not table.HasValue(weaponsOrganized, y) then
								table.insert(weaponsOrganized, y)
							end
						
							local yOffset = x * toY(35) + toY(50)
								
							for a, b in pairs(weaponsOrganized) do
								if b == y then
									if cur == a then
										surface.SetDrawColor(Colour[2])
									else
										surface.SetDrawColor(Colour[3])
									end
								end
							end
							surface.DrawRect(xOffset, yOffset, toX(170), toY(30))
							
							local name = y:GetPrintName()
							surface.SetFont("HUDWeaponText")
							if surface.GetTextSize(name) <= toX(163) then
								draw.DrawText(y:GetPrintName(), "HUDWeaponText", xOffset + toX(85), yOffset + toY(2), white, TEXT_ALIGN_CENTER)
							else
								for a, b in pairs(string.Explode("", name)) do
									local newName = string.Left(name, #string.Explode("", name) - a).."..."
									if surface.GetTextSize(newName) <= toX(163) then
										draw.DrawText(newName, "HUDWeaponText", xOffset + toX(85), yOffset + toY(2), white, TEXT_ALIGN_CENTER)
										break
									end
								end
							end
						end
					end
				end
			end
		else
			cur = 2
			table.Empty(weaponsCur)
			table.Empty(slots)
			table.Empty(weaponsOrganized)
			slots = { {}, {}, {}, {}, {}, {} }
		end
	end
	if en then
		hook.Add("HUDPaint", "DrawWeaponSelection", drawWeaponSelection)
	
		hook.Add("PlayerBindPress", "UpdateWeapon", function(ply, bind, pressed)
			if ply:Alive() then
				if bind == "invnext" or bind == "invprev" then				
					if pressed then
						change = true
						timer.Create("TickWeaponSelection", 1.25, 1, function() 
							change = false
						end)
					end
				end
				
				if bind == "invnext" then
					if cur < #weaponsOrganized then
						cur = cur + 1
					elseif cur == #weaponsOrganized then
						cur = 1
					end
				elseif bind == "invprev" then
					if cur > 1 then
						cur = cur - 1
					elseif cur == 1 then
						cur = #weaponsOrganized
					end
				end
			end
		end)
		
		hook.Add("Think", "UpdatePlayerWeapon", function()
			if LocalPlayer():Alive() then
				weaponsCur = LocalPlayer():GetWeapons()
		
				for k, v in pairs(weaponsCur) do
					for i = 0, 6, 1 do
						if v:GetSlot() == i then
							if not table.HasValue(slots[i + 1], v) then
								table.insert(slots[i + 1], v)
							end
						end
					end
				end
			end
		
			if LocalPlayer():Alive() and weaponsOrganized then
				for k, v in pairs(weaponsOrganized) do
					if cur == k then
						net.Start("WeaponSelection")
						net.WriteString(v:GetClass())
						net.SendToServer()
					end
				end
			end
		end)
	end
elseif SERVER then
	util.AddNetworkString("WeaponSelection")
	
	net.Receive("WeaponSelection", function(len, ply)
		local weapon = net.ReadString()
		ply:SelectWeapon(weapon)
	end)
end
