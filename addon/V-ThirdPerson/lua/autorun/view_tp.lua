if (SERVER) then
	function ThirdPersonPlayerSay( Player, Text, Public )
		if Player:IsValid() then
			if ( string.lower( Text ) == "!thirdperson" ) then
				Player:ConCommand("view_fp 1")
				return false
			elseif (string.lower( Text ) == "!firstperson") then
				Player:ConCommand("view_fp 0")
				return false
			end
		end
	end
	hook.Add( "PlayerSay", "UpdateThirdPersonTP", ThirdPersonPlayerSay )
end

viewTP = CreateConVar( "view_fp", "0", { FCVAR_ARCHIVE })

if (CLIENT ) then
	local CameraOffset = {
		UD = 0,
		RL = 0,
		FB = -70
	}
	
	function ThirdPersonDrawPlayer()
		return viewTP:GetBool() and not ( LocalPlayer():InVehicle() ) or LocalPlayer():IsPlayingTaunt()
	end
	hook.Add( "ShouldDrawLocalPlayer", "UpdatePlayerDrawTP", ThirdPersonDrawPlayer )

	function ThirdPersonCalcView( Player, Origin, Ang, Fov )
		if ( viewTP:GetBool() and not ( Player:InVehicle() ) ) then
			local TraceData = { }

			TraceData.start = Player:EyePos()
			TraceData.endpos = Player:EyePos() + ( Player:GetUp() * CameraOffset.UD ) + ( Player:GetRight() * CameraOffset.RL ) + ( Player:GetForward() * CameraOffset.FB )
			TraceData.filter = Player
			TraceData.mask = MASK_SOLID_BRUSHONLY

			local Trace = util.TraceLine( TraceData )

			local View = { }
			View.origin = Trace.HitPos + Player:GetForward() * 8
			View.angles = Player:GetAngles()
			View.fov = Fov

			return View
		end
	end
	hook.Add( "CalcView", "UpdatePlayerViewTP", ThirdPersonCalcView )
end
