local RecentPromo = {}
local RecentConfetti = {}

surface.CreateFont("V.Hex.Ranks.Menu.Title", {
	font = "Arial",
	extended = false,
	size = ScreenScale(12),
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
	outline = false,
})
	
surface.CreateFont("V.Hex.Ranks.Menu.Name", {
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
	outline = false,
})

local function inRange(tar, ply)
	local indexTable = VHexRankRestrictions[tonumber(ply:GetNWInt("V.Hex.Rank.Key"))]
	
	for k, v in pairs(indexTable) do
		local playerRank = tonumber(ply:GetNWInt("V.Hex.Rank"))
		local targetRank = tonumber(tar:GetNWInt("V.Hex.Rank"))
		
		if v[1] <= playerRank and playerRank <= v[2] then
			if v[3] <= targetRank and targetRank <= v[4] then
				return true
			end
		end
	end
end
	
local function drawCircle(x, y, radius, segments, col)
	local circle = {}

	table.insert(circle, {x = x, y = y, u = 0.5, v = 0.5})
	for i = 0, segments do
		local a = math.rad(( i / segments) * -360)
		table.insert(circle, {x = x + math.sin(a) * radius, y = y + math.cos(a) * radius, u = math.sin(a) / 2 + 0.5, v = math.cos(a) / 2 + 0.5 })
	end

	local a = math.rad(0)
	table.insert(circle, {x = x + math.sin(a) * radius, y = y + math.cos(a) * radius, u = math.sin(a) / 2 + 0.5, v = math.cos(a) / 2 + 0.5 })

	draw.NoTexture()
	surface.SetDrawColor(col)
	surface.DrawPoly(circle)
end

local function Event()
	for k, v in pairs(RecentPromo) do
		if IsValid(v[1]) then
			cam.Start3D2D(v[1]:GetPos() + Vector(0, 0, 35 * math.cos(CurTime() * 5) + 35), Angle(0, 0, 0), 1)
				//drawCircle(0, 0, 20, 150, v[2])
				
				surface.SetDrawColor(255, 0, 0, 255)
				surface.SetTexture(surface.GetTextureID("v/hex/event"))
				surface.DrawTexturedRect(-20, -20, 40, 40)
			cam.End3D2D()
		end
	end
end
hook.Add("PostDrawOpaqueRenderables", "PostDrawOpaqueRenderables", Event)

local function AddEvent(ply)
	/*local index = table.insert(RecentPromo, { ply, VHexRankColour[tonumber(ply:GetNWInt("V.Hex.Rank.Key"))] })
	timer.Simple(VHexRankTime, function()
		table.remove(RecentPromo, index)
	end)*/
	
	for i = 0, 10 do
		local effectDataR = EffectData()
		effectDataR:SetOrigin(ply:GetPos())
		effectDataR:SetStart(Vector(255, 0, 0))
		util.Effect("balloon_pop", effectDataR)
			
		local effectDataG = EffectData()
		effectDataG:SetOrigin(ply:GetPos())
		effectDataG:SetStart(Vector(0, 255, 0))
		util.Effect("balloon_pop", effectDataG)
			
		local effectDataB = EffectData()
		effectDataB:SetOrigin(ply:GetPos())
		effectDataB:SetStart(Vector(0, 0, 255))
		util.Effect("balloon_pop", effectDataB)
			
		local effectDataP = EffectData()
		effectDataP:SetOrigin(ply:GetPos())
		effectDataP:SetStart(Vector(255, 0, 255))
		util.Effect("balloon_pop", effectDataP)
	end
end

local canMenu = VHexRankAllowed

local function toX(x)
	return (ScrW() * (x / 1768))
end

local function toY(y)
	return (ScrH() * (y / 992))
end

local function drawBase(w, h, col1, col2)
	surface.SetDrawColor(col2)
	surface.DrawRect(0, 0, w, h)
			
	surface.SetDrawColor(col1)
	surface.DrawRect(toX(2), toY(2), (w - toX(4)), (h - toY(4)))
end

concommand.Add("V.Hex.Ranks.Menu", function(ply)
	if table.HasValue(canMenu, ply:GetNWString("usergroup")) then
		local Frame = vgui.Create("DFrame")
		Frame:SetSize(toX(480), toY(320))
		Frame:SetTitle("")
		Frame:Center()
		Frame:MakePopup()
		Frame:ShowCloseButton(false)
		Frame.Paint = function(self, w, h)
			drawBase(w, h, VHexTheme[1], VHexTheme[3])
			draw.DrawText("Ranks - Edit", "V.Hex.Ranks.Menu.Title", toX(12), toY(6), VHexTheme[5], TEXT_ALIGN_LEFT)
		end
		
		local Exit = vgui.Create("DButton", Frame)
		Exit:SetSize(toX(65), toY(25))
		Exit:SetPos(toX(403), toY(8))
		Exit:SetText("")
		Exit.DoClick = function()
			Frame:Close()
		end
		Exit.Paint = function(self, w, h)
			if Exit:IsHovered() then
				surface.SetDrawColor(255, 0, 0)
			else
				surface.SetDrawColor(150, 0, 0)
			end
			surface.DrawRect(0, 0, w, h)
		end
		
		local ListPlayers = vgui.Create("DScrollPanel", Frame)
		ListPlayers:DockMargin(toX(6), toY(10), toX(6), toY(6))
		ListPlayers:Dock(FILL)
		
		local ListPlayersBar = ListPlayers:GetVBar()
		ListPlayersBar.Paint = function(self, w, h)
			drawBase(w, h, VHexTheme[2], VHexTheme[2])
		end
		ListPlayersBar.btnUp.Paint = function(self, w, h)
			if ListPlayersBar.btnUp:IsHovered() then
				if ListPlayersBar.btnUp:IsDown() then
					drawBase(w, h, VHexTheme[2], VHexTheme[3])
				else
					drawBase(w, h, VHexTheme[1], VHexTheme[3])
				end
			else
				if ListPlayersBar.btnUp:IsDown() then
					drawBase(w, h, VHexTheme[2], VHexTheme[4])
				else
					drawBase(w, h, VHexTheme[1], VHexTheme[4])
				end
			end
		end
		ListPlayersBar.btnDown.Paint = function(self, w, h)
			if ListPlayersBar.btnDown:IsHovered() then
				if ListPlayersBar.btnDown:IsDown() then
					drawBase(w, h, VHexTheme[2], VHexTheme[3])
				else
					drawBase(w, h, VHexTheme[1], VHexTheme[3])
				end
			else
				if ListPlayersBar.btnDown:IsDown() then
					drawBase(w, h, VHexTheme[2], VHexTheme[4])
				else
					drawBase(w, h, VHexTheme[1], VHexTheme[4])
				end
			end
		end
		ListPlayersBar.btnGrip.Paint = function(self, w, h)
			if ListPlayersBar.btnGrip:IsHovered() then
				drawBase(w, h, VHexTheme[1], VHexTheme[3])
			else
				drawBase(w, h, VHexTheme[1], VHexTheme[4])
			end
		end
		
		for k, v in pairs(player.GetAll()) do
			local PlayerInfo = ListPlayers:Add("DPanel")
			PlayerInfo:SetSize(toX(468), toY(40))
			PlayerInfo:DockMargin(toX(2), toY(4), toX(8), toY(4))
			PlayerInfo:Dock(TOP)
			PlayerInfo.Paint = function(self, w, h)
				drawBase(w, h, VHexTheme[1], VHexTheme[3])
			end
			
			local PlayerName = vgui.Create("DPanel", PlayerInfo)
			PlayerName:DockMargin(toX(8), toY(4), toX(38), toY(4))
			PlayerName:Dock(FILL)
			PlayerName.Paint = function(self, w, h)
				draw.DrawText(v:GetNWString("V.Hex.Name.Display"), "V.Hex.Ranks.Menu.Name", toX(4), toY(4), VHexTheme[5], TEXT_ALIGN_LEFT)
			end
			
			local PlayerRank = vgui.Create("DTextEntry", PlayerInfo)
			
			local PlayerTrain = vgui.Create("DTextEntry", PlayerInfo)
			PlayerTrain:DockMargin(toX(360), toY(8), toX(55), toY(8))
			PlayerTrain:Dock(FILL)
			PlayerTrain:SetValue(v:GetNWInt("V.Hex.Rank.Trainer"))
			PlayerTrain:SetNumeric(true)
			PlayerTrain.Paint = function(self, w, h)
				if PlayerTrain:IsEditing() then
					drawBase(w, h, VHexTheme[2], VHexTheme[4])
				else
					drawBase(w, h, VHexTheme[1], VHexTheme[4])
				end
				
				draw.DrawText(PlayerTrain:GetValue(), "V.Hex.Ranks.Menu.Name", toX(15), toY(1), VHexTheme[5], TEXT_ALIGN_CENTER)
			end
			PlayerTrain.OnEnter = function()
				net.Start("V.Hex.Rank.Update")
					net.WriteEntity(v)
					net.WriteInt(tonumber(PlayerRank:GetValue()), 32)
					net.WriteInt(tonumber(PlayerTrain:GetValue()), 32)
				net.SendToServer()
			end
			
			
			PlayerRank:DockMargin(toX(400), toY(8), toX(8), toY(8))
			PlayerRank:Dock(FILL)
			PlayerRank:SetValue(v:GetNWInt("V.Hex.Rank"))
			PlayerRank:SetNumeric(true)
			PlayerRank.Paint = function(self, w, h)
				if PlayerRank:IsEditing() then
					drawBase(w, h, VHexTheme[2], VHexTheme[4])
				else
					drawBase(w, h, VHexTheme[1], VHexTheme[4])
				end
				
				draw.DrawText(PlayerRank:GetValue(), "V.Hex.Ranks.Menu.Name", toX(15), toY(1), VHexTheme[5], TEXT_ALIGN_CENTER)
			end
			PlayerRank.OnEnter = function()
				net.Start("V.Hex.Rank.Update")
					net.WriteEntity(v)
					net.WriteInt(tonumber(PlayerRank:GetValue()), 32)
					net.WriteInt(tonumber(PlayerTrain:GetValue()), 32)
				net.SendToServer()
			end
		end
	else
		ply:ChatPrint("Insufficient Permissions!")
	end
end)

concommand.Add("V.Hex.Ranks.Promote", function(ply)
	local targetPlayer = ply:GetEyeTrace().Entity
	
	if targetPlayer:IsPlayer() then
		if targetPlayer:GetNWBool("V.Hex.Loaded") and tonumber(targetPlayer:GetNWInt("V.Hex.Rank.Key")) == tonumber(ply:GetNWInt("V.Hex.Rank.Key")) then
			if inRange(targetPlayer, ply) then
				local newRank = tonumber(targetPlayer:GetNWInt("V.Hex.Rank")) + 1
				AddEvent(targetPlayer)
				ply:ChatPrint("You have been promoted!")
			
				net.Start("V.Hex.Rank.Update")
					net.WriteEntity(targetPlayer)
					net.WriteInt(newRank, 32)
					net.WriteInt(tonumber(targetPlayer:GetNWInt("V.Hex.Rank.Trainer")), 32)
				net.SendToServer()
				
			else
				ply:ChatPrint("Insufficient permissions!")
			end
		else
			ply:ChatPrint("Either:\n1.The player has not loaded a character.\n2.Their character is in a different branch.")
		end
	else
		ply:ChatPrint("You have to select a player!")
	end
end)

concommand.Add("V.Hex.Ranks.Demote", function(ply)
	local targetPlayer = ply:GetEyeTrace().Entity
	
	if targetPlayer:IsPlayer() then
		if targetPlayer:GetNWBool("V.Hex.Loaded") and tonumber(targetPlayer:GetNWInt("V.Hex.Rank.Key")) == tonumber(ply:GetNWInt("V.Hex.Rank.Key")) then
			if inRange(targetPlayer, ply) then
				local newRank = tonumber(targetPlayer:GetNWInt("V.Hex.Rank")) - 1
				ply:ChatPrint("You have been demoted.")
				
				net.Start("V.Hex.Rank.Update")
					net.WriteEntity(targetPlayer)
					net.WriteInt(newRank, 32)
					net.WriteInt(tonumber(targetPlayer:GetNWInt("V.Hex.Rank.Trainer")), 32)
				net.SendToServer()
			else
				ply:ChatPrint("Insufficient permissions!")
			end
		else
			ply:ChatPrint("Either:\n1.The player has not loaded a character.\n2.Their character is in a different branch.")
		end
	else
		ply:ChatPrint("You have to select a player!")
	end
end)

concommand.Add("V.Hex.Ranks.Train", function(ply)
	local targetPlayer = ply:GetEyeTrace().Entity
	
	if targetPlayer:IsPlayer() then
		if targetPlayer:GetNWBool("V.Hex.Loaded") and tonumber(targetPlayer:GetNWInt("V.Hex.Rank.Key")) == tonumber(ply:GetNWInt("V.Hex.Rank.Key")) and tonumber(ply:GetNWInt("V.Hex.Rank.Key")) == 1 then
			local targetRank 	= tonumber(targetPlayer:GetNWInt("V.Hex.Rank"))
			local targetTrain	= tonumber(targetPlayer:GetNWInt("V.Hex.Rank.Trainer"))
			
			local plyTrain		= tonumber(ply:GetNWInt("V.Hex.Rank.Trainer"))
			
			if targetRank == 1 and plyTrain > 0 then
				AddEvent(targetPlayer)
				net.Start("V.Hex.Rank.Update")
					net.WriteEntity(targetPlayer)
					net.WriteInt(2, 32)
					net.WriteInt(0, 32)
				net.SendToServer()
				targetPlayer:ChatPrint("You have been trained!")
			elseif targetRank != 1 and targetTrain == 0 and plyTrain == 2 then
				AddEvent(targetPlayer)
				net.Start("V.Hex.Rank.Update")
					net.WriteEntity(targetPlayer)
					net.WriteInt(targetRank, 32)
					net.WriteInt(1, 32)
				net.SendToServer()
				targetPlayer:ChatPrint("You have been trained!")
			else
				ply:ChatPrint("You can't train them!")
			end
		else
			ply:ChatPrint("Either:\n1.The player has not loaded a character.\n2.Their character is in a different branch.")
		end
	else
		ply:ChatPrint("You have to select a player!")
	end
end)
