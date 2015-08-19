include('shared.lua')
include('gui/cl_hud.lua')
include('player/player_call.lua')

function Welcome()
	chat.AddText(Color(0, 200, 255), "Welcome! ", Color(255, 255, 255), "Please Enjoy Your Stay!")
end
usermessage.Hook("WelcomeMessage", Welcome)
