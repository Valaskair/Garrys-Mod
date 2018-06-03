surface.CreateFont("V.Hex.Character.Menu.Name", {
	font = "Arial",
	extended = false,
	size = ScreenScale(10),
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
surface.CreateFont("V.Hex.Character.Menu.Attr", {
	font = "Arial",
	extended = false,
	size = ScreenScale(7),
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

local function RequestInformation()
	net.Start("V.Hex.Characters.Request")
	net.SendToServer()
end

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

concommand.Add("V.Hex.Character.Menu", function(ply)
	RequestInformation()

	net.Receive("V.Hex.Characters.ToClient", function(len, pl)
		local indexCharacters	= net.ReadTable()
		local indexClones		= net.ReadTable()
		local indexNames		= net.ReadTable()
	
		local Frame = vgui.Create("DFrame")
		Frame:SetSize(toX(600), toY(500))
		Frame:SetTitle("")
		Frame:Center()
		Frame:MakePopup()
		Frame:SetDraggable(false)
		Frame.Paint = function(self, w, h)
			drawBase(w, h, VHexTheme[1], VHexTheme[3])
		end
		Frame:ShowCloseButton(false)
		
		local Characters = vgui.Create("DPanel", Frame)
		Characters:DockMargin(0, toY(-24), toX(392), 0)
		Characters:Dock(FILL)
		Characters.Paint = function(self, w, h) end
		
		local CharacterModel = vgui.Create("DAdjustableModelPanel", Frame)
		CharacterModel:DockMargin(toX(200), toY(-24), 0, 0)
		CharacterModel:Dock(FILL)
		function CharacterModel:LayoutEntity(ent)
			return
		end
		CharacterModel:SetVisible(false)
		
		local indexDesignation = tostring(math.random(0, 9))..tostring(math.random(0, 9))..tostring(math.random(0, 9))..tostring(math.random(0, 9))
		for k, v in pairs(indexClones) do
			if v == indexDesignation then
				indexDesignation = tostring(math.random(0, 9))..tostring(math.random(0, 9))..tostring(math.random(0, 9))..tostring(math.random(0, 9))
			end
			
			if not table.HasValue(indexClones, indexDesignation) then
				break
			end
		end		
				
		local indexCharacter
		for k, v in pairs(indexCharacters) do
			if v == "Create" then
				local Character = vgui.Create("DPanel", Characters)
				Character:SetPos(toX(4), (k * toY(164) - toY(160)))
				Character:SetSize(toX(192), toY(152))	
				
				local CharacterName = vgui.Create("DTextEntry", Character)	
			
				local CharacterSelect = vgui.Create("DButton", Character)
				CharacterSelect:SetPos(0, 0)
				CharacterSelect:SetSize(toX(192), toY(45))
				CharacterSelect:SetText("")
				CharacterSelect.Paint = function(self, w, h)
					if CharacterSelect:IsHovered() then
						if indexCharacter == k then
							drawBase(w, h, VHexTheme[2], VHexTheme[3])
						else
							drawBase(w, h, VHexTheme[1], VHexTheme[3])
						end
					else
						if indexCharacter == k then
							drawBase(w, h, VHexTheme[2], VHexTheme[3])
						else
							drawBase(w, h, VHexTheme[1], VHexTheme[4])
						end	
					end
					if k == 1 then
						draw.DrawText("Create (Clone)", "V.Hex.Character.Menu.Name", toX(96), toY(8), VHexTheme[5], TEXT_ALIGN_CENTER)
					elseif k == 2 then
						draw.DrawText("Create (Navy)", "V.Hex.Character.Menu.Name", toX(96), toY(8), VHexTheme[5], TEXT_ALIGN_CENTER)
					else
						draw.DrawText("Create (Jedi)", "V.Hex.Character.Menu.Name", toX(96), toY(8), VHexTheme[5], TEXT_ALIGN_CENTER)
					end
				end				
				CharacterSelect.DoClick = function()
					if k == 1 then
						indexCharacter = k
					elseif k == 2 and table.HasValue(VHexCharacterAllowedNavy, ply:GetNWString("usergroup")) then
						indexCharacter = k
					elseif k == 3 and table.HasValue(VHexCharacterAllowedJedi, ply:GetNWString("usergroup")) then
						indexCharacter = k
					else
						ply:ChatPrint("Insufficient Permissions!")
					end
					
					CharacterModel:SetVisible(true)
					CharacterModel:SetModel(VHexRank[k][1][3])
					CharacterModel:SetLookAt(Vector(0, 0, 0))
				end
				
				Character.Paint = function(self, w, h)
					if CharacterSelect:IsHovered() then
						if indexCharacter == k then
							drawBase(w, h, VHexTheme[1], VHexTheme[3])
						else
							drawBase(w, h, VHexTheme[1], VHexTheme[3])
						end
					else
						if indexCharacter == k then
							drawBase(w, h, VHexTheme[1], VHexTheme[3])
						else
							drawBase(w, h, VHexTheme[1], VHexTheme[4])
						end
					end
					
					if indexCharacter == k then
						CharacterName:SetEditable(true)
					else
						CharacterName:SetEditable(false)
					end
 				end
				
				local CharacterCreate = vgui.Create("DButton", Character)
				CharacterCreate:SetSize(toX(192), toY(66))
				CharacterCreate:SetPos(0, toY(86))
				CharacterCreate:SetText("")
				CharacterCreate.Paint = function(self, w, h)
					if CharacterSelect:IsHovered() then
						if indexCharacter == k then
							if CharacterCreate:IsHovered() then
								drawBase(w, h, VHexTheme[2], VHexTheme[3])
							else
								drawBase(w, h, VHexTheme[1], VHexTheme[3])
							end
						else
							drawBase(w, h, VHexTheme[1], VHexTheme[3])
						end
					else
						if indexCharacter == k then
							if CharacterCreate:IsHovered() then
								drawBase(w, h, VHexTheme[2], VHexTheme[3])
							else
								drawBase(w, h, VHexTheme[1], VHexTheme[3])
							end
						else
							drawBase(w, h, VHexTheme[1], VHexTheme[4])
						end	
					end
					draw.DrawText("Create", "V.Hex.Character.Menu.Name", toX(96), toY(18), VHexTheme[5], TEXT_ALIGN_CENTER)
				end
				
				if k == 1 then
					local CharacterDesignation = vgui.Create("DPanel", Character)
					CharacterDesignation:SetSize(toX(56), toY(45))
					CharacterDesignation:SetPos(0, toY(43))
					CharacterDesignation.Paint = function(self, w, h)
						draw.DrawText(indexDesignation, "V.Hex.Character.Menu.Name", toX(56), toY(12), VHexTheme[5], TEXT_ALIGN_RIGHT)
					end
					
					CharacterName:SetSize(toX(134), toY(45))
					CharacterName:SetPos(toX(58), toY(43))
					CharacterName.Paint = function(self, w, h)
						if CharacterSelect:IsHovered() then
							if indexCharacter == k then
								if CharacterName:IsEditing() then
									drawBase(w, h, VHexTheme[2], VHexTheme[3])
								else
									drawBase(w, h, VHexTheme[1], VHexTheme[3])
								end
							else
								if CharacterName:IsEditing() then
									drawBase(w, h, VHexTheme[2], VHexTheme[3])
								else
									drawBase(w, h, VHexTheme[1], VHexTheme[3])
								end
							end
						else
							if indexCharacter == k then
								if CharacterName:IsEditing() then
									drawBase(w, h, VHexTheme[2], VHexTheme[3])
								else
									drawBase(w, h, VHexTheme[1], VHexTheme[3])
								end
							else
								if CharacterName:IsEditing() then
									drawBase(w, h, VHexTheme[2], VHexTheme[4])
								else
									drawBase(w, h, VHexTheme[1], VHexTheme[4])
								end
							end		
						end
						draw.DrawText(CharacterName:GetValue(), "V.Hex.Character.Menu.Name", toX(4), toY(12), VHexTheme[5], TEXT_ALIGN_LEFT)
					end
					
					CharacterCreate.DoClick = function()
						if not table.HasValue(VHexCharacterRestricted, string.lower(CharacterName:GetValue())) and CharacterName:GetValue() != "" then
							if not table.HasValue(indexNames, string.lower(indexDesignation.."-"..CharacterName:GetValue())) then
								net.Start("V.Hex.Characters.Create")
									local indexName = indexDesignation.."-"..CharacterName:GetValue()
									local indexKey	= 1
									
									net.WriteString(indexName)
									net.WriteInt(indexKey, toY(32))
								net.SendToServer()
								
								net.Start("V.Hex.Clone.Add")
									net.WriteString(indexDesignation)
								net.SendToServer()
								
								Frame:Close()
							end
						end
					end
				else
					CharacterName:SetSize(toX(192), toY(45))
					CharacterName:SetPos(0, toY(43))
					CharacterName.Paint = function(self, w, h)
						if CharacterSelect:IsHovered() then
							if indexCharacter == k then
								if CharacterName:IsEditing() then
									drawBase(w, h, VHexTheme[2], VHexTheme[3])
								else
									drawBase(w, h, VHexTheme[1], VHexTheme[3])
								end
							else
								if CharacterName:IsEditing() then
									drawBase(w, h, VHexTheme[2], VHexTheme[3])
								else
									drawBase(w, h, VHexTheme[1], VHexTheme[3])
								end
							end
						else
							if indexCharacter == k then
								if CharacterName:IsEditing() then
									drawBase(w, h, VHexTheme[2], VHexTheme[3])
								else
									drawBase(w, h, VHexTheme[1], VHexTheme[3])
								end
							else
								if CharacterName:IsEditing() then
									drawBase(w, h, VHexTheme[2], VHexTheme[4])
								else
									drawBase(w, h, VHexTheme[1], VHexTheme[4])
								end
							end		
						end
						draw.DrawText(CharacterName:GetValue(), "V.Hex.Character.Menu.Name", toX(4), toY(12), VHexTheme[5], TEXT_ALIGN_LEFT)
					end
					
					CharacterCreate.DoClick = function()
						if not table.HasValue(VHexCharacterRestricted, string.lower(CharacterName:GetValue())) and CharacterName:GetValue() != "" then
							if not table.HasValue(indexNames, string.lower(CharacterName:GetValue())) then
								net.Start("V.Hex.Characters.Create")
									local indexName = CharacterName:GetValue()
									local indexKey	= k
									
									net.WriteString(indexName)
									net.WriteInt(indexKey, 32)
								net.SendToServer()
								
								Frame:Close()
							end
						end
					end
				end
			else
				local characterTable = string.Explode("‼", v)
				
				local Character = vgui.Create("DButton", Characters)
				Character:SetPos(toX(4), (k * toY(164) - toY(160)))
				Character:SetSize(toX(192), toY(152))
				Character:SetText("")
				Character.Paint = function(self, w, h)
					if Character:IsHovered() then
						if indexCharacter == k then
							drawBase(w, h, VHexTheme[2], VHexTheme[3])
						else
							drawBase(w, h, VHexTheme[1], VHexTheme[3])
						end
					else
						if indexCharacter == k then
							drawBase(w, h, VHexTheme[2], VHexTheme[4])
						else
							drawBase(w, h, VHexTheme[1], VHexTheme[4])
						end	
					end
					draw.DrawText(characterTable[1], "V.Hex.Character.Menu.Name", toX(96), toY(4), VHexTheme[5], TEXT_ALIGN_CENTER)
					draw.DrawText(VHexRank[k][tonumber(characterTable[2])][1], "V.Hex.Character.Menu.Attr", toX(96), toY(30), VHexTheme[5], TEXT_ALIGN_CENTER)
					if tonumber(characterTable[3]) > 0 and k == 1 then
						draw.DrawText(VHexTrainer[tonumber(characterTable[3])][1],  "V.Hex.Character.Menu.Attr", toX(96), toY(52), VHexTheme[5], TEXT_ALIGN_CENTER)
					end
				end
				
				Character.DoClick = function()
					indexCharacter = k
					
					CharacterModel:SetVisible(true)
					CharacterModel:SetModel(VHexRank[k][tonumber(characterTable[2])][3])
				end
				
				local Load = vgui.Create("DButton", Character)
				Load:SetSize(toX(192), toY(45))
				Load:SetPos(0, toY(107))
				Load:SetText("")
				Load.Paint = function(self, w, h)
					if Character:IsHovered() then
						if Load:IsHovered() then
							drawBase(w, h, VHexTheme[2], VHexTheme[3])
						else
							drawBase(w, h, VHexTheme[1], VHexTheme[3])
						end
					else				
						if Load:IsHovered() then
							drawBase(w, h, VHexTheme[2], VHexTheme[3])
						else
							if indexCharacter == k then
								drawBase(w, h, VHexTheme[1], VHexTheme[3])
							else
								drawBase(w, h, VHexTheme[1], VHexTheme[4])
							end	
						end
					end
					draw.DrawText("Load", "V.Hex.Character.Menu.Name", toX(96), toY(8), VHexTheme[5], TEXT_ALIGN_CENTER)
				end
				Load.DoClick = function()
					if tonumber(ply:GetNWInt("V.Hex.Rank.Key")) != k then
						net.Start("V.Hex.Characters.Load")
							net.WriteInt(k, 32)
						net.SendToServer()
					end
				
					Frame:Close()
				end
			end
		end
	end)
end)
