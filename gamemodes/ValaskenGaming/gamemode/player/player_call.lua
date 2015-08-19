callTime = 0

if CLIENT then
	ply = (LocalPlayer())
	
	function updatePlayerCall()
		if IsValid(ply) then
			if (ply:KeyPressed(IN_RELOAD)) then
				callTime = (CurTime() + 5)
				ply:PrintMessage(HUD_PRINTTALK, "Calling")
			end
			if (ply:KeyReleased(IN_RELOAD)) then
				callTime = 0
				ply:PrintMessage(HUD_PRINTTALK, "Call Ended")
			end
			if (CurTime()) == callTime then
				ply:PrintMessage(HUD_PRINTTALK, "Called")
				callTime = 0
			end
		end
	end
	hook.Add("Think", "UpdatePlayerCall", updatePlayerCall)
elseif SERVER then

end
