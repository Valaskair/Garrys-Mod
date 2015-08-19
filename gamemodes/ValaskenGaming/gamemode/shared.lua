GM.Name		= "Valasken Gaming"
GM.Author	= "Valaskair"
GM.Email	= "valaskair.vp@gmail.com"
GM.Website	= "N/A"

OTS = {}

function GM:Initialize()
	self.BaseClass.Initialize(self)
end

team.SetUp(1, "Team", Color(255, 0, 0))

util.PrecacheModel("models/player/Combine_Super_Soldier.mdl")
util.PrecacheModel("models/player/vortigaunt.mdl")
util.PrecacheModel("models/player/hobo387/didact.mdl")
util.PrecacheModel("models/haloemile/pm-emile.mdl")
util.PrecacheModel("models/player/cubanmerc_male.mdl")

OTS = {}

if CLIENT then
	otsBob = 1
	otsBobScale = 0.5
	otsBack = 50
	otsRight = 35
	otsUp = 0
	otsSmooth = 1
	otsSmoothScale = 0.2

	function OTS.CalcView(player, pos, angles, fov)
		local smooth = otsSmooth
		local smoothscale = otsSmoothScale
		if player:GetNetworkedInt("thirdperson") == 1 then
			angles = player:GetAimVector():Angle()

			local targetpos = Vector(0, 0, 60)
			if player:KeyDown(IN_DUCK) then
				if player:GetVelocity():Length() > 0 then
					targetpos.z = 50
				else
					targetpos.z = 40
				end
			end

			player:SetAngles(angles)
			local targetfov = fov
			if player:GetVelocity():DotProduct(player:GetForward()) > 10 then
				if player:KeyDown(IN_SPEED) then
					targetpos = targetpos + player:GetForward() * -10
					if otsBob != 0 and player:OnGround() then
						angles.pitch = angles.pitch + otsBobScale * math.sin(CurTime() * 10)
						angles.roll = angles.roll + otsBobScale * math.cos(CurTime() * 10)
						targetfov = targetfov + 3
					end
				else
					targetpos = targetpos + player:GetForward() * -5
				end
			end 

			pos = player:GetVar("overtheshoulder_pos") or targetpos
			if smooth != 0 then
				pos.x = math.Approach(pos.x, targetpos.x, math.abs(targetpos.x - pos.x) * smoothscale)
				pos.y = math.Approach(pos.y, targetpos.y, math.abs(targetpos.y - pos.y) * smoothscale)
				pos.z = math.Approach(pos.z, targetpos.z, math.abs(targetpos.z - pos.z) * smoothscale)
			else
				pos = targetpos
			end
			player:SetVar("overtheshoulder_pos", pos)

			local offset = Vector(5, 5, 5)
			if player:GetVar("overtheshoulder_zoom") != 1 then
				offset.x = otsBack
				offset.y = otsRight
				offset.z = otsUp
			end
			local t = {}
			t.start = player:GetPos() + pos
			t.endpos = t.start + angles:Forward() * -offset.x
			t.endpos = t.endpos + angles:Right() * offset.y
			t.endpos = t.endpos + angles:Up() * offset.z
			t.filter = player
				local tr = util.TraceLine(t)
				pos = tr.HitPos
				if tr.Fraction < 1.0 then
					pos = pos + tr.HitNormal * 5
				end
			player:SetVar("overtheshoulder_viewpos", pos)

			fov = player:GetVar("overtheshoulder_fov") or targetfov
			if smooth != 0 then
				fov = math.Approach(fov, targetfov, math.abs(targetfov - fov) * smoothscale)
			else
				fov = targetfov
			end
			player:SetVar("overtheshoulder_fov", fov)
	
			return GAMEMODE:CalcView(player, pos, angles, fov)
		end
	end
	hook.Add("CalcView", "OTS.CalcView", OTS.CalcView)

	function OTS.HUDPaint()
		local player = LocalPlayer()
		if player:GetNetworkedInt("thirdperson") == 0 then
			return
		end
	
		local t = {}
		t.start = player:GetShootPos()
		t.endpos = t.start + player:GetAimVector() * 9000
		t.filter = player
		local tr = util.TraceLine(t)
		local pos = tr.HitPos:ToScreen()
		local fraction = math.min((tr.HitPos - t.start):Length(), 1024) / 1024
		local size = 10 + 20 * (1.0 - fraction)
		local offset = size * 0.5
		local offset2 = offset - (size * 0.1)

		t = {}
		t.start = player:GetVar("overtheshoulder_viewpos") or player:GetPos()
		t.endpos = tr.HitPos + tr.HitNormal * 5
		t.filter = player
		local tr = util.TraceLine(t)
		if tr.Fraction != 1.0 then
			surface.SetDrawColor(255, 48, 0, 255)
		else
			surface.SetDrawColor(255, 208, 64, 255)
		end
		surface.DrawLine(pos.x - offset, pos.y, pos.x - offset2, pos.y)
		surface.DrawLine(pos.x + offset, pos.y, pos.x + offset2, pos.y)
		surface.DrawLine(pos.x, pos.y - offset, pos.x, pos.y - offset2)
		surface.DrawLine(pos.x, pos.y + offset, pos.x, pos.y + offset2)
		surface.DrawLine(pos.x - 1, pos.y, pos.x + 1, pos.y)
		surface.DrawLine(pos.x, pos.y - 1, pos.x, pos.y + 1)
	end
	hook.Add("HUDPaint", "OTS.HUDPaint", OTS.HUDPaint)

	function OTS.HUDShouldDraw(name)
		if name == "CHudCrosshair" and LocalPlayer():GetNetworkedInt("thirdperson") == 1 then
			return false
		end
	end
	hook.Add("HUDShouldDraw", "OTS.HUDShouldDraw", OTS.HUDShouldDraw)

	function OTS.Zoom(player, command, arguments)
		if player:GetVar("overtheshoulder_zoom") == 1 then
			player:SetVar("overtheshoulder_zoom", 0)
		else
			player:SetVar("overtheshoulder_zoom", 1)
		end
	end
	concommand.Add("ots_zoom", OTS.Zoom)
else 
	function OTS.Command(player, command, arguments)
		if not arguments[1] then
			if player:GetNetworkedInt("thirdperson") == 1 then
				OTS.Disable(player)
			else
				OTS.Enable(player)
			end
		elseif arguments[1] == "1" then
			OTS.Enable(player)
		elseif arguments[1] == "0" then
			OTS.Disable(player)
		end
	end
	concommand.Add("viewots", OTS.Command)

	function OTS.Disable(player)
		if player:GetNetworkedInt("thirdperson") == 0 then
			return
		end
		local entity = player:GetViewEntity()
		player:SetNetworkedInt("thirdperson", 0)
		player:SetViewEntity(player)
		entity:Remove()
	end

	function OTS.Enable(player)
		if player:GetNetworkedInt("thirdperson") == 1 then
			return
		end
		local entity = ents.Create("prop_dynamic")
		entity:SetModel("models/error.mdl")
		entity:SetColor(Color(0, 0, 0, 0))
		entity:Spawn()
		entity:SetAngles(player:GetAngles())
		entity:SetMoveType(MOVETYPE_NONE)
		entity:SetParent(player)
		entity:SetPos(player:GetPos() + Vector(0, 0, 60))
		entity:SetRenderMode(RENDERMODE_TRANSALPHA)
		entity:SetSolid(SOLID_NONE)
		player:SetViewEntity(entity)
		player:SetNetworkedInt("thirdperson", 1)
	end
end

function OTS.UpdateAnimation(player)
	if player:KeyDown(IN_SPEED) then
		player:SetPlaybackRate(1.5)
	end
end
hook.Add("UpdateAnimation", "OTS.UpdateAnimation", OTS.UpdateAnimation)

local YawIncrement = 20
local PitchIncrement = 10

function callCanister()
	if (SERVER) then 
        local aBaseAngle = (Angle(32.340084, 327.699982, 0.000000))
        local aBasePos = (Vector(997.743042, 2054.346680, 46.754284))
        local bScanning = true
        local iPitch = 10
        local iYaw = -180
        local iLoopLimit = 0
        local iProcessedTotal = 0
        local tValidHits = {} 

        while (bScanning == true && iLoopLimit < 500) do
            iYaw = iYaw + YawIncrement
            iProcessedTotal = iProcessedTotal + 1        
            if (iYaw >= 180) then
                iYaw = -180
                iPitch = iPitch - PitchIncrement
            end
            
            local tLoop = util.QuickTrace(aBasePos, (aBaseAngle + Angle(iPitch, iYaw, 0)):Forward() * 40000)
            if (tLoop.HitSky || bSecondary) then 
                table.insert(tValidHits, tLoop) 
            end
                
            if (iPitch <= -80) then
                bScanning = false
            end
            iLoopLimit = iLoopLimit + 1
        end
        
        local iHits = table.Count(tValidHits)
        if (iHits > 0) then
            local iRand = math.random(1, iHits) 
            local tRand = tValidHits[iRand]        
            
            local ent = ents.Create("env_headcrabcanister")
            ent:SetPos(aBasePos)
            ent:SetAngles( (tRand.HitPos-tRand.StartPos):Angle())
            ent:SetKeyValue("HeadcrabType", math.random(0,2))
            ent:SetKeyValue("HeadcrabCount", math.random(10,25))
            ent:SetKeyValue("FlightSpeed", 8000)
            ent:SetKeyValue("FlightTime", math.random(2,5))
            ent:SetKeyValue("Damage", math.random(50,90))
            ent:SetKeyValue("DamageRadius", math.random(300,512))
            ent:SetKeyValue("SmokeLifetime", math.random(5,10))
            ent:SetKeyValue("StartingHeight",  1000)
            local iSpawnFlags = 8192
            if (bSecondary) then iSpawnFlags = iSpawnFlags + 4096 end
            ent:SetKeyValue("spawnflags", iSpawnFlags)
            
            ent:Spawn()
            
            ent:Input("FireCanister", ply, ply)

            undo.Create("CrabLaunch")
                undo.AddEntity(ent)
                undo.SetPlayer(ply)
                undo.AddFunction(function(undo)
                    for k, v in pairs(ents.FindByClass("npc_headcrab*"))do 
                        if (v:GetOwner() == ent) then v:Remove() end
                    end
                end)
            undo.Finish()
        end
        tLoop = nil
        tValidHits = nil
	end
end
concommand.Add("callCanister", callCanister)
