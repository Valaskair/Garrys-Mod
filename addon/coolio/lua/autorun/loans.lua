/* CONFIGURATIONS */
local MaxMoney = 10000
local MaxInterest = .05
local MaxTime = 15

AcceptedLoans = { /* { PlayerData, BankerPlayerData, Principal/Amount, InterestRate, Period, AccumulateInterest } */ }

BankerRequestedLoans = { /* { PlayerData, Principal/Amount, Interest, Period} */ }
RequestedLoans = { /* { PlayerData, BankerPlayerData, Principal/Amount, Interest, Period} */ }

PaidMoney = { /* { PlayerData, BankerPlayerData, Amount } */}
PaidLoans = { /* { PlayerData, BankerPlayerData, Amount } */}

local function xratio(number)
	return (ScrW() * (number / 1768))
end
local function yratio(number)
	return (ScrH() * (number / 992))
end

if CLIENT and gmod.GetGamemode().Name == "darkrp" then
	surface.CreateFont("LoanMenuTitle", {
		font = "Trebuchet MS",
		extended = false,
		size = ScreenScale(11),
		weight = 250,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false
	})
	surface.CreateFont("LoanMenuTab", {
		font = "Trebuchet MS",
		extended = false,
		size = ScreenScale(7),
		weight = 1000,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false
	})
	surface.CreateFont("LoanMenuName", {
		font = "Trebuchet MS",
		extended = false,
		size = ScreenScale(10),
		weight = 1000,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false
	})
	surface.CreateFont("LoanMenuItem", {
		font = "Trebuchet MS",
		extended = false,
		size = ScreenScale(8),
		weight = 250,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false
	})
	
	function drawBase(w, h)
		surface.SetDrawColor(Color(25, 25, 25))
		surface.DrawRect(0, 0, w, h)
		draw.DrawText("Loans", "LoanMenuTitle", xratio(11), 0, Color(255, 255, 255), TEXT_ALIGN_LEFT)
		surface.SetDrawColor(Color(75, 75, 75))
		surface.DrawRect(xratio(10), yratio(30), w - xratio(20), h - yratio(40))
	end
	
	function drawButton(condition, x, y, w, h, colourOn, colourOff)
		if condition then
			surface.SetDrawColor(colourOn)
		else
			surface.SetDrawColor(colourOff)
		end
		surface.DrawRect(x, y, w, h)
	end

	local isOpen = false;
	concommand.Add("loan_menu", function(ply)
		if not isOpen then
			isOpen = true
			gui.EnableScreenClicker(true)
			if ply:Team() == TEAM_BANKOWNER and IsValid(ply) and ply:IsPlayer() then
				local Menu = vgui.Create("DFrame")
				Menu:SetTitle("")
				Menu:SetSize(xratio(600), yratio(350))
				Menu:Center()
				Menu:ShowCloseButton(false)
				Menu.OnClose = function() 
					isOpen = false
					gui.EnableScreenClicker(false) 
				end
				Menu.Paint = function(self, w, h)
					drawBase(w, h)
				end
				Menu:MakePopup()
				
				local MenuExit = vgui.Create("Button", Menu)
				MenuExit:SetText("")
				MenuExit:SetSize(xratio(40), yratio(20))
				MenuExit:SetPos(xratio(550), yratio(5))
				MenuExit.DoClick = function()
					Menu:Close()
				end
				MenuExit.Paint = function(self, w, h)
					drawButton(MenuExit:IsHovered(), 0, 0, w, h, Color(255, 50, 50), Color(200, 50, 50))
				end
				
				local tab = 1
				
				local ReqLoans = vgui.Create("DScrollPanel", Menu)
				ReqLoans:SetSize(xratio(570), yratio(275))
				ReqLoans:SetPos(xratio(15), yratio(60))
				ReqLoans.Paint = function(self, w, h)
					surface.SetDrawColor(Color(150, 150, 150))
					surface.DrawRect(0, 0, w, h)
				end
				
				local AccLoans = vgui.Create("DScrollPanel", Menu)
				AccLoans:SetSize(xratio(570), yratio(275))
				AccLoans:SetPos(xratio(15), yratio(60))
				AccLoans.Paint = function(self, w, h)
					surface.SetDrawColor(Color(150, 150, 150))
					surface.DrawRect(0, 0, w, h)
				end
				AccLoans:SetVisible(false)
				
				local LoanPaid = vgui.Create("DScrollPanel", Menu)
				LoanPaid:SetSize(xratio(570), yratio(275))
				LoanPaid:SetPos(xratio(15), yratio(60))
				LoanPaid.Paint = function(self, w, h)
					surface.SetDrawColor(Color(150, 150, 150))
					surface.DrawRect(0, 0, w, h)
				end
				LoanPaid:SetVisible(false)
				
				local LoansReq = vgui.Create("DButton", Menu)
				LoansReq:SetSize(xratio(67.5), yratio(25))
				LoansReq:SetPos(xratio(15), yratio(35))
				LoansReq:SetText("")
				LoansReq.Paint = function(self, w, h) 
					if tab == 1 then
						surface.SetDrawColor(Color(150, 150, 150))
					else
						surface.SetDrawColor(Color(100, 100, 100))
					end
					surface.DrawRect(0, 0, w, h)
					draw.DrawText("Requests", "LoanMenuTab", xratio(3), yratio(3), Color(255, 255, 255), TEXT_ALIGN_LEFT)
				end
				LoansReq.DoClick = function()
					ReqLoans:SetVisible(true)
					AccLoans:SetVisible(false)
					LoanPaid:SetVisible(false)
					tab = 1
				end
				
				local LoansAcc = vgui.Create("DButton", Menu)
				LoansAcc:SetSize(xratio(68), yratio(25))
				LoansAcc:SetPos(xratio(85), yratio(35))
				LoansAcc:SetText("")
				LoansAcc.Paint = function(self, w, h) 
					if tab == 2 then
						surface.SetDrawColor(Color(150, 150, 150))
					else
						surface.SetDrawColor(Color(100, 100, 100))
					end
					surface.DrawRect(0, 0, w, h)
					draw.DrawText("Accepted", "LoanMenuTab", xratio(3), yratio(3), Color(255, 255, 255), TEXT_ALIGN_LEFT)
				end
				LoansAcc.DoClick = function()
					ReqLoans:SetVisible(false)
					AccLoans:SetVisible(true)
					LoanPaid:SetVisible(false)
					tab = 2
				end
				
				local LoansPaid = vgui.Create("DButton", Menu)
				LoansPaid:SetSize(xratio(68), yratio(25))
				LoansPaid:SetPos(xratio(155), yratio(35))
				LoansPaid:SetText("")
				LoansPaid.Paint = function(self, w, h)
					if tab == 3 then
						surface.SetDrawColor(Color(150, 150, 150))
					else
						surface.SetDrawColor(100, 100, 100)
					end
					surface.DrawRect(0, 0, w, h)
					draw.DrawText("Paid", "LoanMenuTab", xratio(3), yratio(3), Color(255, 255, 255), TEXT_ALIGN_LEFT)
				end
				LoansPaid.DoClick = function()
					ReqLoans:SetVisible(false)
					AccLoans:SetVisible(false)
					LoanPaid:SetVisible(true)
					tab = 3
				end
								
				for k, v in pairs(BankerRequestedLoans) do
					if v[1] == ply then return end
				
					local Loan = ReqLoans:Add("DPanel")
					Loan:SetSize(xratio(560), yratio(75))
					Loan.Paint = function(self, w, h)
						surface.SetDrawColor(Color(175, 175, 175))
						surface.DrawRect(0, 0, w, h)
						draw.DrawText(v[1]:Nick(), "LoanMenuName", xratio(5), yratio(3), Color(255, 255, 255), TEXT_ALIGN_LEFT)
						draw.DrawText("$"..v[2], "LoanMenuName", xratio(175), yratio(3), Color(255, 255, 255), TEXT_ALIGN_LEFT)
						draw.DrawText((v[3]/100).."%", "LoanMenuName", xratio(325), yratio(3), Color(255, 255, 255), TEXT_ALIGN_LEFT)
						draw.DrawText(v[4].. " Days", "LoanMenuName", xratio(425), yratio(3), Color(255, 255, 255), TEXT_ALIGN_LEFT)
					end
					Loan:DockMargin(xratio(5), yratio(5), xratio(5), 0)
					Loan:Dock(TOP)

					local Reoffer = vgui.Create("DButton", Loan)
					Reoffer:SetText("")
					Reoffer:SetSize(xratio(100), yratio(25))
					Reoffer:SetPos(xratio(5), yratio(37))
					Reoffer.Paint = function(self, w, h)
						drawButton(Reoffer:IsHovered(), xratio(0), 0, w, h, Color(225, 225, 225), Color(200, 200, 200))
						draw.DrawText("Re-Offer", "LoanMenuTab", xratio(5), yratio(5), Color(0, 0, 0), TEXT_ALIGN_LEFT)
					end
						
					local Amount = vgui.Create("DTextEntry", Loan)
					Amount:SetSize(xratio(75), yratio(25))
					Amount:SetPos(xratio(175), yratio(37))

					local Interest = vgui.Create("DTextEntry", Loan)
					Interest:SetSize(xratio(50), yratio(25))
					Interest:SetPos(xratio(325), yratio(37))
					
					local Period = vgui.Create("DTextEntry", Loan)
					Period:SetSize(xratio(75), yratio(25))
					Period:SetPos(xratio(425), yratio(37))
					
					Amount.OnEnter = function()
						Interest:RequestFocus()
					end
					Interest.OnEnter = function()
						Period:RequestFocus()
					end
					
					Reoffer.DoClick = function()
						local ReAmount = tonumber(Amount:GetValue()) or v[2]
						local ReInterest = tonumber(Interest:GetValue()) or v[3]
						local RePeriod = tonumber(Period:GetValue()) or v[4]
						
						
						if ReAmount <= MaxMoney and ReInterest <= MaxInterest and RePeriod <= MaxTime then							
							net.Start("EditTable")
							net.WriteInt(3, 4)
							net.WriteInt(0, 4)
							net.WriteTable({ v[1], ply, ReAmount, ReInterest, RePeriod })
							net.WriteBool(false)
							net.SendToServer()
							
							net.Start("EditTable")
							net.WriteInt(1, 4)
							net.WriteInt(k, 4)
							net.WriteTable({})
							net.WriteBool(true)
							net.SendToServer()
						
							Loan:Remove()
						end
					end
						
					local Accept = vgui.Create("DButton", Loan)
					Accept:SetText("")
					Accept:SetSize(xratio(33), yratio(33))
					Accept:SetPos(xratio(515), yratio(5))
					Accept.Paint = function(self, w, h)
						drawButton(Accept:IsHovered(), 0, 0, w, h ,Color(50, 255, 50), Color(50, 200, 50))
					end
					Accept.DoClick = function()
						Loan:Remove()
						
						net.Start("EditTable")
						net.WriteInt(3, 4)
						net.WriteInt(0, 4)
						net.WriteTable({ v[1], ply, v[2], v[3], v[4], 0 })
						net.WriteBool(false)
						net.SendToServer()
						
						net.Start("EditTable")
						net.WriteInt(1, 4)
						net.WriteInt(k, 4)
						net.WriteTable({})
						net.WriteBool(true)
						net.SendToServer()
						
						net.Start("StartLoan")
						net.WriteString(v[1]:SteamID())
						net.WriteTable({ v[1], ply, v[2], v[3], v[4], v[2] })
						net.SendToServer()
						
						v[1]:addMoney(v[2])
					end
						
					local Decline = vgui.Create("DButton", Loan)
					Decline:SetText("")
					Decline:SetSize(xratio(33), yratio(33))
					Decline:SetPos(xratio(515), yratio(40))
					Decline.Paint = function(self, w, h)
						drawButton(Decline:IsHovered(), 0, 0, w, h, Color(255, 50, 50), Color(200, 50, 50))
					end
					Decline.DoClick = function()
						net.Start("EditTable")
						net.WriteInt(1, 4)
						net.WriteInt(k, 4)
						net.WriteTable({})
						net.WriteBool(true)
						net.SendToServer()	
						
						Loan:Remove()
					end
				end
				
				for k, v in pairs(AcceptedLoans) do
					if ply == v[2] then
						local Loan = AccLoans:Add("DPanel")
						Loan:SetSize(xratio(560), yratio(75))
						Loan.Paint = function(self, w, h)
							surface.SetDrawColor(Color(175, 175, 175))
							surface.DrawRect(0, 0, w, h)
							draw.DrawText(v[1]:Nick(), "LoanMenuName", xratio(5), yratio(3), Color(255, 255, 255), TEXT_ALIGN_LEFT)
							draw.DrawText("$"..v[3], "LoanMenuName", xratio(175), yratio(3), Color(255, 255, 255), TEXT_ALIGN_LEFT)
							draw.DrawText((v[4]/100).."%", "LoanMenuName", xratio(325), yratio(3), Color(255, 255, 255), TEXT_ALIGN_LEFT)
							draw.DrawText(v[5].. " Days", "LoanMenuName", xratio(425), yratio(3), Color(255, 255, 255), TEXT_ALIGN_LEFT)
						end
						Loan:DockMargin(xratio(5), yratio(5), xratio(5), 0)
						Loan:Dock(TOP)

						local Collect = vgui.Create("DButton", Loan)
						Collect:SetText("")
						Collect:SetSize(xratio(100), yratio(25))
						Collect:SetPos(xratio(5), yratio(37))
						Collect.Paint = function(self, w, h)
							local IsMoneyAvailable
							for a, b in pairs(PaidMoney) do
								if b[1] == v[1] and b[2] == v[2] and b[3] > 0 then
									IsMoneyAvailable = true
								else
									IsMoneyAvailable = false
								end						
							end
							if Collect:IsHovered() and IsMoneyAvailable then
								surface.SetDrawColor(Color(225, 225, 225))
							else
								surface.SetDrawColor(Color(200, 200, 200))
							end
							surface.DrawRect(0, 0, w, h)
							draw.DrawText("Collect", "LoanMenuTab", xratio(5), yratio(5), Color(0, 0, 0), TEXT_ALIGN_LEFT)
						end
						Collect.DoClick = function()
							for a, b in pairs(PaidMoney) do
								if b[1] == v[1] and b[2] == v[2] and b[3] > 0 then									
									net.Start("EditTable")
									net.WriteTable(PaidMoney)
									net.WriteInt(0, 4)
									net.WriteTable({ ply, b[2], 0})
									net.WriteBool(false)
									net.SendToServer()
									
									net.Start("ReceiveMoney")
									net.WriteInt(b[3], 32)
									net.SendToServer()
								end
							end
						end
					end
				end
				
				for k, v in pairs(PaidLoans) do
					if v[2] == ply then
					local Loan = LoanPaid:Add("DPanel")
					Loan:SetSize(xratio(560), yratio(75))
					Loan.Paint = function(self, w, h)
						surface.SetDrawColor(Color(175, 175, 175))
						surface.DrawRect(0, 0, w, h)
						draw.DrawText(v[1]:Nick(), "LoanMenuName", xratio(5), yratio(3), Color(255, 255, 255), TEXT_ALIGN_LEFT)
						draw.DrawText("$"..v[3], "LoanMenuName", xratio(175), yratio(3), Color(255, 255, 255), TEXT_ALIGN_LEFT)
					end
					Loan:DockMargin(xratio(5), yratio(5), xratio(5), 0)
					Loan:Dock(TOP)
					end
				end
			else
				if IsValid(ply) and ply:IsPlayer() then
					local Menu = vgui.Create("DFrame")
					Menu:SetTitle("")
					Menu:SetSize(xratio(600), yratio(350))
					Menu:Center()
					Menu:ShowCloseButton(false)
					Menu.OnClose = function() 
						isOpen = false
						gui.EnableScreenClicker(false) 
					end
					Menu.Paint = function(self, w, h)
						drawBase(w, h)
					end
					Menu:MakePopup()
					
					local MenuExit = vgui.Create("Button", Menu)
					MenuExit:SetText("")
					MenuExit:SetSize(xratio(40), yratio(20))
					MenuExit:SetPos(xratio(550), yratio(5))
					MenuExit.DoClick = function()
						Menu:Close()
					end
					MenuExit.Paint = function(self, w, h)
						drawButton(MenuExit:IsHovered(), 0, 0, w, h, Color(255, 50, 50), Color(200, 50, 50))
					end
					
					local tab = 1
					
					local ReqLoans = vgui.Create("DScrollPanel", Menu)
					ReqLoans:SetSize(xratio(570), yratio(275))
					ReqLoans:SetPos(xratio(15), yratio(60))
					ReqLoans.Paint = function(self, w, h)
						surface.SetDrawColor(Color(150, 150, 150))
						surface.DrawRect(0, 0, w, h)
					end
					
					local AccLoans = vgui.Create("DScrollPanel", Menu)
					AccLoans:SetSize(xratio(570), yratio(275))
					AccLoans:SetPos(xratio(15), yratio(60))
					AccLoans.Paint = function(self, w, h)
						surface.SetDrawColor(Color(150, 150, 150))
						surface.DrawRect(0, 0, w, h)
					end
					AccLoans:SetVisible(false)
					
					local LoansReq = vgui.Create("DButton", Menu)
					LoansReq:SetSize(xratio(68), yratio(25))
					LoansReq:SetPos(xratio(15), yratio(35))
					LoansReq:SetText("")
					LoansReq.Paint = function(self, w, h) 
						if tab == 1 then
							surface.SetDrawColor(Color(150, 150, 150))
						else
							surface.SetDrawColor(Color(100, 100, 100))
						end
						surface.DrawRect(0, 0, w, h)
						draw.DrawText("Request", "LoanMenuTab", xratio(3), yratio(3), Color(255, 255, 255), TEXT_ALIGN_LEFT)
					end
					LoansReq.DoClick = function()
						ReqLoans:SetVisible(true)
						AccLoans:SetVisible(false)
						tab = 1
					end
					
					local LoansAcc = vgui.Create("DButton", Menu)
					LoansAcc:SetSize(xratio(68), yratio(25))
					LoansAcc:SetPos(xratio(85), yratio(35))
					LoansAcc:SetText("")
					LoansAcc.Paint = function(self, w, h) 
						if tab == 2 then
							surface.SetDrawColor(Color(150, 150, 150))
						else
							surface.SetDrawColor(Color(100, 100, 100))
						end
						surface.DrawRect(0, 0, w, h)
						draw.DrawText("Accepted", "LoanMenuTab", xratio(3), yratio(3), Color(255, 255, 255), TEXT_ALIGN_LEFT)
					end
					LoansAcc.DoClick = function()
						ReqLoans:SetVisible(false)
						AccLoans:SetVisible(true)
						tab = 2
					end
					
					local LoansRequest = ReqLoans:Add("DPanel")
					LoansRequest:SetSize(xratio(560), yratio(75))
					LoansRequest.Paint = function(self, w, h)
								surface.SetDrawColor(Color(175, 175, 175))
								surface.DrawRect(0, 0, w, h)
								draw.DrawText("$", "LoanMenuName", xratio(175), yratio(3), Color(255, 255, 255), TEXT_ALIGN_LEFT)
								draw.DrawText("%", "LoanMenuName", xratio(325), yratio(3), Color(255, 255, 255), TEXT_ALIGN_LEFT)
								draw.DrawText("Days", "LoanMenuName", xratio(425), yratio(3), Color(255, 255, 255), TEXT_ALIGN_LEFT)
					end
					LoansRequest:DockMargin(xratio(5), yratio(5), xratio(5), 0)
					LoansRequest:Dock(TOP)
					
					local Amount = vgui.Create("DTextEntry", LoansRequest)
					Amount:SetSize(xratio(75), yratio(25))
					Amount:SetPos(xratio(175), yratio(37))
					
					local Interest = vgui.Create("DTextEntry", LoansRequest)
					Interest:SetSize(xratio(50), yratio(25))
					Interest:SetPos(xratio(325), yratio(37))
					
					local Period = vgui.Create("DTextEntry", LoansRequest)
					Period:SetSize(xratio(75), yratio(25))
					Period:SetPos(xratio(425), yratio(37))
					
					Amount.OnEnter = function()
						Interest:RequestFocus()
						print("test")
					end
					Interest.OnEnter = function()
						Period:RequestFocus()
					end
					
					local LoansSend = vgui.Create("DButton", LoansRequest)
					LoansSend:SetSize(xratio(75), yratio(25))
					LoansSend:SetPos(xratio(10), yratio(40))
					LoansSend:SetText("")
					LoansSend.Paint = function(self, w, h)
						drawButton(LoansSend:IsHovered(), 0, 0, w, h, Color(225, 225, 225), Color(200, 200, 200))
						draw.DrawText("Request", "LoanMenuTab", xratio(3), yratio(3), Color(255, 255, 255), TEXT_ALIGN_LEFT)
					end
					LoansSend.DoClick = function()
						local x = tonumber(Amount:GetValue())
						local y = tonumber(Interest:GetValue())
						local z = tonumber(Period:GetValue())
						
						if x and y and z and x <= MaxMoney and y <= MaxInterest and z <= MaxTime then							
							net.Start("EditTable")
							net.WriteInt(1, 4)
							net.WriteInt(0, 4)
							net.WriteTable({ ply, x, y, z })
							net.WriteBool(false)
							net.SendToServer()
							
							print("Sending")
							
							Amount:SetValue("")
							Interest:SetValue("")
							Period:SetValue("")
						end
					end
					
					for k, v in pairs(RequestedLoans) do
						if v[1] == ply then
							local Loan = ReqLoans:Add("DPanel")
							Loan:SetSize(xratio(560), yratio(75))
							Loan.Paint = function(self, w, h)
								surface.SetDrawColor(Color(175, 175, 175))
								surface.DrawRect(0, 0, w, h)
								draw.DrawText(v[1]:Nick(), "LoanMenuName", xratio(5), yratio(3), Color(255, 255, 255), TEXT_ALIGN_LEFT)
								draw.DrawText("$"..v[3], "LoanMenuName", xratio(175), yratio(3), Color(255, 255, 255), TEXT_ALIGN_LEFT)
								draw.DrawText((v[4] / 100).."%", "LoanMenuName", xratio(325), yratio(3), Color(255, 255, 255), TEXT_ALIGN_LEFT)
								draw.DrawText(v[5].. " Days", "LoanMenuName", xratio(425), yratio(3), Color(255, 255, 255), TEXT_ALIGN_LEFT)
							end
							Loan:DockMargin(xratio(5), yratio(5), xratio(5), 0)
							Loan:Dock(TOP)
								
							local Accept = vgui.Create("DButton", Loan)
							Accept:SetText("")
							Accept:SetSize(xratio(33), yratio(33))
							Accept:SetPos(xratio(515), yratio(5))
							Accept.Paint = function(self, w, h)
								drawButton(Accept:IsHovered(), 0, 0, w, h ,Color(50, 255, 50), Color(50, 200, 50))
							end
							Accept.DoClick = function()
								net.Start("EditTable")
								net.WriteInt(3, 4)
								net.WriteInt(0, 4)
								net.WriteTable({ ply, v[2], v[3], v[4], v[5], 0 })
								net.WriteBool(false)
								net.SendToServer()
								
								net.Start("EditTable")
								net.WriteInt(2, 4)
								net.WriteInt(k, 4)
								net.WriteTable({})
								net.WriteBool(true)
								net.SendToServer()
								
								Loan:Remove()
								
								net.Start("StartLoan")
								net.WriteString(v[1]:SteamID())
								net.WriteTable({ v[1], v[2], v[3], v[4], v[5], v[3] })
								net.SendToServer()
							end
								
							local Decline = vgui.Create("DButton", Loan)
							Decline:SetText("")
							Decline:SetSize(xratio(33), yratio(33))
							Decline:SetPos(xratio(515), yratio(40))
							Decline.Paint = function(self, w, h)
								drawButton(Decline:IsHovered(), 0, 0, w, h, Color(255, 50, 50), Color(200, 50, 50))
							end
							Decline.DoClick = function()								
								net.Start("EditTable")
								net.WriteInt(1, 4)
								net.WriteInt(k, 4)
								net.WriteTable({})
								net.WriteBool(true)
								net.SendToServer()	
								
								Loan:Remove()
							end
						end
					end
						
					for k, v in pairs(AcceptedLoans) do
						if ply == v[1] then
							local Loan = AccLoans:Add("DPanel")
							Loan:SetSize(xratio(560), yratio(75))
							Loan.Paint = function(self, w, h)
								surface.SetDrawColor(Color(175, 175, 175))
								surface.DrawRect(0, 0, w, h)
								draw.DrawText(v[2]:Nick(), "LoanMenuName", xratio(5), yratio(3), Color(255, 255, 255), TEXT_ALIGN_LEFT)
								draw.DrawText("$"..(v[3] + v[6]), "LoanMenuName", xratio(175), yratio(3), Color(255, 255, 255), TEXT_ALIGN_LEFT)
								draw.DrawText("$"..(v[6]), "LoanMenuName", xratio(325), yratio(3), Color(255, 255, 255), TEXT_ALIGN_LEFT)
								draw.DrawText(v[5].. " Days", "LoanMenuName", xratio(425), yratio(3), Color(255, 255, 255), TEXT_ALIGN_LEFT)
							end
							Loan:DockMargin(xratio(5), yratio(5), xratio(5), 0)
							Loan:Dock(TOP)

							local Amount = vgui.Create("DTextEntry", Loan)
							Amount:SetSize(xratio(75), yratio(25))
							Amount:SetPos(xratio(175), yratio(37))
							
							local Pay = vgui.Create("DButton", Loan)
							Pay:SetText("")
							Pay:SetSize(xratio(100), yratio(25))
							Pay:SetPos(xratio(5), yratio(37))
							Pay.Paint = function(self, w, h)
								local z = Amount:GetValue() or 0
								if Pay:IsHovered() and ply:getDarkRPVar("money") > 0 and z then
									surface.SetDrawColor(Color(225, 225, 225))
										Pay:SetEnabled(true)
								else
									surface.SetDrawColor(Color(200, 200, 200))
									Pay:SetEnabled(false)
								end
								surface.DrawRect(0, 0, w, h)
								draw.DrawText("Pay", "LoanMenuTab", xratio(5), yratio(5), Color(0, 0, 0), TEXT_ALIGN_LEFT)
							end
							Pay.DoClick = function()							
								v[3] = (v[3] - Amount:GetValue())
								net.Start("PayLoan")
								net.WriteInt(v[3], 32)
								net.WriteTable(v)
								net.SendToServer()
							end
						end
					end
				end
			end			
		end
	end)
elseif SERVER and gmod.GetGamemode().Name == "darkrp" then
	file.CreateDir("v/loans/paid/")

	function editTable(currentTable, index, newTable, remove, key)
		if remove then
			table.Remove(currentTable, index)
		else
			table.insert(currentTable, newTable)
		end
	end
	
	function SaveLoanData()
		for k, v in pairs(AcceptedLoans) do
			local indexTable = v
			local indexString = string.Implode("\n", indexTable)
			local indexDir = "v/loans/"..string.Replace(v[1]:SteamID(), ":", "_")..".txt"
			
			file.Write(indexDir, indexString)
		end
	end
	
	function LoadLoanData()
		local indexDir = "v/loans/"
		local NetData = file.Find("*", indexDir)
		
		for k, v in pairs(NetData) do
			local indexString = file.Read(indexDir..v)
			local indexTable = string.Explode("\n", indexString) 
			local total = indexTable[3]
			local interest = indexTable[4]
			local period = indexTable[5]
			local debt = indexTable[6]
			table.insert(AcceptedLoans, indexTable)
			timer.Create(indexTable[1]:SteamID(), 86400, indexTable[5], function()
				period = period--
				debt = total * interest
				indexTable = { indexTable[1], indexTable[2], indexTable[3], indexTable[4], indexTable[5], debt }
				UpdateLoanData(indexTable)
			end)
		end
	end
	
	function UpdateLoanData(table)
		local indexDir = "v/loans/"
		local NetData = file.Find("*", indexDir)
		
		for k, v in pairs(NetData) do
			local indexString = file.Read(indexDir..v)
			local indexTable = string.Explode("\n", indexString)
			
			if indexTable[1] == table[1] then
				file.Write(indexDir..v, string.Implode("\n", table))
			end
		end
	end
	
	function RemoveLoanData(ply)
		local indexDir = "v/loans/"
		local NetData = file.Find("*", indexDir)
		
		for k, v in pairs(NetData) do
			local indexString = file.Read(indexDir..v)
			local indexTable = string.Explode("\n", indexString)
			
			if indexTable[1] == ply then
				file.Delete(indexString)
				for a, b in pairs(AcceptedLoans) do
					if b[1] == ply then
						table.Remove(AcceptedLoans, a)
					end
				end
			end
		end
	end
	
	function SavePayData()		
		for k, v in pairs(PaidLoans) do
			indexString = string.Implode("\n", v)
			indexDir = "v/loans/paid/"..string.Replace(v[1]:SteamID(), ":", "_")..".txt"
			file.Write(indexDir, indexString)
		end
		
	end
	
	function LoadPayData()
		local indexDir = "v/loans/paid/"
		local NetData = file.Find("*", indexDir)
		
		for k, v in pairs(NetData) do
			local indexString = file.Read(indexDir..v)
			local indexTable = string.Explode("\n", indexString)
			
			table.insert(PaidLoans, indexTable)
		end
	end
	
	util.AddNetworkString("EditTable")
	util.AddNetworkString("StartLoan")
	util.AddNetworkString("PayLoan")
	util.AddNetworkString("ReceiveMoney")
	hook.Add('Think', "UpdateLoans", function()
		net.Receive("ReceiveMoney", function(len, ply)
			local money = net.ReadInt(32)
			ply:AddMoney(money)
		end)
	
		net.Receive("EditTable", function(len, ply)	
			local cur = net.ReadInt(4)
			local index = net.ReadInt(4)
			local newTable = net.ReadTable()
			local remove = net.ReadBool()
			
			ply:PrintMessage(HUD_PRINTTALK, "You sent stuff")
			
			if cur == 1 then
				ply:PrintMessage(HUD_PRINTTALK, "Your stuff sent")
				editTable(BankerRequestedLoans, index, newTable, remove)
			elseif cur == 2 then
				editTable(RequestedLoans, index, newTable, remove)
			elseif cur == 3 then
				editTable(AcceptedLoans, index, newTable, remove)
			elseif cur == 4 then
				editTable(PaidMoney, index, newTable, remove)
			end
		end)
	
		net.Receive("StartLoan", function(len, ply)
			local timerID = net.ReadString()
			local timerTable = net.ReadTable()
			local total = timerTable[3]
			local interest = timerTable[4]
			local period = timerTable[5]
			local debt
			
			timer.Create(timerID, 86400, timerTable[5], function() 
				period = period--
				debt = total * interest
				indexTable[6] = debt
				UpdateLoanData(indexTable)
			end)
		end)
		
		net.Receive("PayLoan", function(len, ply)
			local amount = net.ReadInt(32)
			local v = net.ReadTable()
			if amount == v[3] + v[6] then
				v[1]:AddMoney(-amount)
				table.insert(PaidLoans, { v[1], v[2], amount})
				RemoveLoanData(v[1])
			elseif amount > v[3] + v[6] then
				local back = amount - (v[3] + v[6])
				v[1]:AddMoney(back)
				table.insert(PaidLoans, { v[1], v[2], amount})
				RemoveLoanData(v[1])
			elseif amount > 0 then
				local newInterest = v[6] - (amount * (v[4] / 100))
				local newPrincipal = v[3] - (amount * ((100 - v[4]) / 100))
				v[3] = newPrincipal
				v[6] = newInterest
				UpdateLoanData(v)
				
				local accountExist = 0
				for a, b in pairs(PaidMoney) do
					if table.HasValue(b, v[1]) then
						accountExist = 1
						b[3] = b[3] + amount
						table.insert(PaidMoney, a, { v[1], v[2], b[3]})
					end
				end
				if accountExist == 0 then
					table.insert(PaidMoney, {v[1], v[2], amount})
				end
			end
		end)
	end)
	
	hook.Add('Shutdown', "ClearLoanTablesOnShutdown", function()
		SaveLoanData()
		SavePayData()
	end)
	
	hook.Add('Initialize', "ClearLoanTablesOnRestart", function()
		LoadLoanData()
		LoadPayData()
	end)
	
	hook.Add('PlayerDisconnected', "RemovePlayerLoanRequestOnDC", function(ply)
		for k, v in pairs(BankerRequestedLoans) do
			if v[1] == ply then
				table.Remove(k)
			end
		end
		
		for k, v in pairs(RequestedLoans) do
			if v[1] == ply then
				table.Remove(k)
			end
		end
	end)
end
