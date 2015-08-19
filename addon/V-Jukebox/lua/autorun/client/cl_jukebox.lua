local Panel
local AudioPlayer

local PanelJukebox
local PanelSong
local PanelStart
local PanelStop
local PanelVolume
local PanelQueue

local isMenuOpen = false

local q = 0
local c = 0

local videoTitle = ""
local videoDuration = 0
local videoQ = {}

local queueList = "Queue:\n"

local videoIsUp = false
local canPlayerPlay = true
local canPlaySong = true
local currentTable = 0

local startTime = 0
local exitTime = 0
local cTitle = ""
local PanelConfirmation
local PanelConfirmationText

function initPanel()
	PanelConfirmation:SetVisible(false)
	isMenuOpen = true
	PanelJukebox = vgui.Create('DFrame')
	PanelJukebox:SetSize(ScrW() * 0.714, ScrH() * 0.67)
	PanelJukebox:SetPos(ScrW() * 0, ScrH() * 0)
	PanelJukebox:SetDeleteOnClose(true)
	PanelJukebox:Center()
	PanelJukebox:SetTitle('Jukebox')
	if videoTitle != "" then
		PanelJukebox:SetTitle("Jukebox".. ": Current Playing: ".. videoTitle)
	else
		PanelJukebox:SetTitle("Jukebox")
	end
	PanelJukebox:SetSizable(false)
	PanelJukebox:SetDeleteOnClose(false)
	PanelJukebox:MakePopup()
	PanelJukebox.Paint = function()
		draw.RoundedBox(8, 0, 0, (PanelJukebox:GetWide()), (PanelJukebox:GetTall()), Color(100, 100, 100, 175))
	end

	PanelSong = vgui.Create('DScrollPanel', PanelJukebox)
	PanelSong:SetSize(ScrW() * 0.27, ScrH() * 0.402)
	PanelSong:SetPos(ScrW() * 0.429, ScrH() * 0.067)
	PanelSong.Paint = function()
		draw.RoundedBox(8, 0, 0, (PanelSong:GetWide()), (PanelSong:GetTall()), Color(50, 50, 50, 175))
	end
	
	PanelQueue = vgui.Create('RichText', PanelJukebox)
	PanelQueue:SetSize(ScrW() * 0.397, ScrH() * 0.402)
	PanelQueue:SetPos(ScrW() * 0.016, ScrH() * 0.067)
	PanelQueue:InsertColorChange(255, 0, 0, 255)
	PanelQueue:SetText(queueList)
	PanelQueue.Paint = function()
		draw.RoundedBox(8, 0, 0, (PanelQueue:GetWide()), (PanelQueue:GetTall()), Color(50, 50, 50, 175))
	end

	PanelStop = vgui.Create('DButton', PanelJukebox)
	PanelStop:SetSize(ScrW() * 0.397, ScrH() * 0.067)
	PanelStop:SetPos(ScrW() * 0.016, ScrH() * 0.491)
	PanelStop:SetText('Stop')
	if LocalPlayer():IsUserGroup("admin") or LocalPlayer():IsUserGroup("superadmin") then
		PanelStop:SetVisible(true)
	else
		PanelStop:SetVisible(false)
	end
	PanelStop.DoClick = function()
		timer.Remove("songID".. c)
		queueList = string.Replace(queueList, (videoTitle.. " for ".. videoDuration.. " Seconds\n"), "")
		videoIsUp = false
		local Alpha = 255
		stopVideo()
		canPlaySong = true
		c = (c + 1)
		for k, v in pairs(player.GetAll()) do
			if IsValid(v) then
				if videoTitle != "" then
					v:PrintMessage(HUD_PRINTTALK, (videoTitle.. " stopped Playing!"))
				end
			end
		end
		videoTitle = ""
	end
	PanelStop.Paint = function()
		draw.RoundedBox(8, 0, 0, (PanelStop:GetWide()), (PanelStop:GetTall()), Color(50, 50, 50, 175))
	end

	PanelEnter = vgui.Create('DButton', PanelJukebox)
	PanelEnter:SetSize(ScrW() * 0.27, ScrH() * 0.156)
	PanelEnter:SetPos(ScrW() * 0.429, ScrH() * 0.491)
	PanelEnter:SetText('Queue Selected Song')
	PanelEnter.DoClick = function()
		local ply = (LocalPlayer())
		if canPlayerPlay then
			if ply:IsUserGroup("donator") or ply:IsUserGroup("coindonator") or ply:IsUserGroup("derpmember") or ply:IsUserGroup("moderator") or ply:IsUserGroup("admin") or ply:IsUserGroup("superadmin") then
				initPlay()
			else
				initPlay()
				canPlayerPlay = false
			end
		else
			LocalPlayer():PrintMessage(HUD_PRINTTALK, "You do not have any more Queue's left!")
		end
	end
	PanelEnter.Paint = function()
		draw.RoundedBox(8, 0, 0, (PanelEnter:GetWide()), (PanelEnter:GetTall()), Color(50, 50, 50, 175))
	end

	PanelVolume = vgui.Create('DNumSlider', PanelJukebox)
	PanelVolume:SetSize(ScrW() * 0.397, ScrH() * 0.08899999)
	PanelVolume:SetPos(ScrW() * 0.016, ScrH() * 0.558)
	PanelVolume:SetMinMax(0, 100)
	PanelVolume.OnMouseReleased = function() end
	PanelVolume.OnValueChanged = function() 
		jukeboxVolume = (PanelVolume:GetValue())
		RunConsoleCommand("val_jukebox_volume", jukeboxVolume)
	end
	PanelVolume:SetText('Volume') 
	PanelVolume:SetValue(tonumber(GetConVar("val_jukebox_volume"):GetString()))
	
	for i = 1, AudioPlaylistCount do
		local isPressed = false
		local SongToggle = vgui.Create('DButton')
		SongToggle:SetSize(425, 30)
		SongToggle:SetPos(5, (i * 35))
		SongToggle:SetText(AudioPlaylist[i])
		SongToggle.DoClick = function()
			currentTable = (SongToggle:GetText())
		end
		PanelSong:AddItem(SongToggle)
		SongToggle.Paint = function()
			draw.RoundedBox(8, 0, 0, (SongToggle:GetWide()), (SongToggle:GetTall()), Color(100, 100, 100, 175))
		end
		SongToggle:SetTextColor(Color(200, 200, 200, 255))
	end
end
concommand.Add("openJukebox", function()
	if isMenuOpen then
		PanelJukebox:Close()
		isMenuOpen = false
	else
		initPanel()
	end
end)

function initConfirmation()
	local PanelBG = vgui.Create("DPanel")
	PanelBG:SetSize(ScrW(), ScrH())
	PanelBG:Center()
	PanelBG:SetVisible(false)

	if (CurTime() < exitTime) then
		PanelConfirmation:SetSize((ScrW() * 0.15), (ScrH() * 0.05))
		PanelConfirmation:Center()
		PanelConfirmation:SetVisible(true)
		PanelConfirmation.Paint = function()
			draw.RoundedBox(8, 0, 0, (PanelConfirmation:GetWide()), (PanelConfirmation:GetTall()), Color(100, 100, 100, 175))
		end
		
		PanelConfirmationText:SetPos((ScrW() * 0.003125), (ScrH() * 0.016666))
		PanelConfirmationText:SetText("You added ".. cTitle.. " to the Queue!")
		PanelConfirmationText:SizeToContents()
		PanelConfirmationText:SetVisible(true)
		
		Derma_DrawBackgroundBlur(PanelBG, startTime)
	else
		PanelConfirmation:SetVisible(false)
		PanelConfirmationText:SetVisible(false)
	end
end
hook.Add("HUDPaint", "DrawConfirmation", initConfirmation)

function initPlay()
	if (table.Count(videoQ)) == 0 then
		videoIsUp = true
		local Alpha = 0
		stopVideo()
		local vidIndex = (string.Explode("|", currentTable))
		videoTitle = (vidIndex[1])
		local vidID = (vidIndex[2])
		local vidDur = (tonumber(vidIndex[3]))
		videoDuration = vidDur
		canPlaySong = false
		c = (c + 1)
		
		if vidID != "" then
			playVideo(vidID)
			q = (q + 1)
			videoQ[1] = (currentTable)
			timer.Create(("songID".. c), vidDur, 1, function()
				canPlaySong = true
				c = (c + 1)
				videoIsUp = false
				for k, v in pairs(player.GetAll()) do
					if IsValid(v) then
						if videoTitle != "" then
							v:PrintMessage(HUD_PRINTTALK, ("[Jukebox]: ".. vidIndex[1].. " is Over!"))
						end
					end
				end
				videoTitle = ""
			end)
		end
		for k, v in pairs(player.GetAll()) do
			if IsValid(v) then
				if videoTitle != "" then
					v:PrintMessage(HUD_PRINTTALK, ("[Jukebox]: ".. vidIndex[1].. " is now Playing!"))
				end
			end
		end
	else
		if q < 20 then
			q = (q + 1)
			videoQ[q] = (currentTable)
			local songTable = string.Explode("|", videoQ[q])
			LocalPlayer():PrintMessage(HUD_PRINTTALK, (songTable[1].. " has been added to the Queue!"))
			startTime = (CurTime() + 1)
			exitTime = (CurTime() + 7)
			cTitle = (songTable[1])
			PanelJukebox:Close()
			for k, v in pairs(player.GetAll()) do
				if IsValid(v) then
					v:PrintMessage(HUD_PRINTTALK, ("[Jukebox]: ".. (LocalPlayer():Nick()).. " has added ".. songTable[1].. " to the Queue!"))
				end
			end
			queueList = (queueList.. songTable[1].. " for ".. songTable[3].. " Seconds\n")
		else
			LocalPlayer():PrintMessage(HUD_PRINTTALK, "The Queue is full!")
		end
	end
end

function autoPlay()
	if videoQ[c] != nil then
		if canPlaySong then
			local songTable = (string.Explode("|", (videoQ[c])))
			queueList = string.Replace(queueList, (songTable[1].. " for ".. songTable[3].. " Seconds\n"), "")
			videoIsUp = true
			local Alpha = 0
			stopVideo()
			local vidTitle = (songTable[1])
			local vidID = (songTable[2])
			local vidDur = (tonumber(songTable[3]))
			
			if vidID != "" then
				playVideo(vidID)
				videoTitle = vidTitle
				timer.Create(("songID".. c), vidDur, 1, function()
					canPlaySong = true
					c = (c + 1)
					videoIsUp = false
					for k, v in pairs(player.GetAll()) do
						if IsValid(v) then
							if videoTitle != "" then
								v:PrintMessage(HUD_PRINTTALK, (videoTitle.. " is Over!"))
							end
						end
					end
					videoTitle = ""
				end)
			end
			for k, v in pairs(player.GetAll()) do
				if IsValid(v) then
					if videoTitle != "" then
						v:PrintMessage(HUD_PRINTTALK, (songTable[1].. " is now Playing!"))
					end
				end
			end
			canPlaySong = false
		end
	end
	
	if (CurTime() > exitTime) then
		if PanelConfirmation != nil then
			PanelConfirmation:SetVisible(false)
		end
	end
end
hook.Add("Tick", "UpdateSong", autoPlay)

concommand.Add("val_jukebox_queue", function()
	ply = LocalPlayer()
	
	if IsValid(ply) then
		ply:PrintMessage(HUD_PRINTTALK, ("Current Queue\n"))
		for i = 1, (table.Count(videoQ)) do
			if i > c then
				local songList = (string.Explode("|", (videoQ[i])))
				ply:PrintMessage(HUD_PRINTTALK, (songList[1].. "\n"))
			end
		end
	end
end)

function initPlayer()
	PanelConfirmation = vgui.Create("DPanel")
	PanelConfirmationText = vgui.Create("DLabel", PanelConfirmation)
	PanelConfirmation:SetVisible(false)

	Panel = vgui.Create("DFrame")
	Panel:SetSize((ScrW()), (ScrH()))
	Panel:Center()
	Panel:SetVisible(false)
		
	AudioPlayer = vgui.Create("HTML", Panel)
	AudioPlayer:Dock(FILL)
	AudioPlayer:SetVisible(false)
end
timer.Create("InitVAudio", 1, 2, initPlayer)

local cvarQuality = CreateConVar("val_jukebox_quality", "480p", FCVAR_ARCHIVE, "Video Quality")
local cvarVolume = CreateConVar("val_jukebox_volume", "50", FCVAR_ARCHIVE, "Audio/Video Volume")

function playVideo(videoID)
	local videoURL = ("http://ryno-saurus.github.com/ulx_youtubemusicplayer/host.html?v=" .. videoID .. "&quality=" .. cvarQuality:GetString() .. "&volume=" .. cvarVolume:GetString())
	AudioPlayer:OpenURL(videoURL)
end

function playVideoHook(um)
	local videoID = um:ReadString()
	local videoURL = ("http://ryno-saurus.github.com/ulx_youtubemusicplayer/host.html?v=" .. videoID .. "&quality=" .. cvarQuality:GetString() .. "&volume=" .. cvarVolume:GetString())

	AudioPlayer:SetHTML("")
	AudioPlayer:OpenURL(videoURL)
end
usermessage.Hook("val_jukebox_play", playVideoHook)

function stopVideo()
	AudioPlayer:OpenURL("http//www.google.com")
end

function stopVideoHook()
	AudioPlayer:OpenURL("http//www.google.com")
end
usermessage.Hook("val_jukebox_stop", stopVideoHook)

if IsValid(LocalPlayer()) then
	LocalPlayer():PrintMessage(HUD_PRINTTALK, "Audio Player Initialized!")
end

local Alpha = 0
hook.Add("Tick", "JBBC", function()
	if videoIsUp == true then
		if Alpha < 255 then
			Alpha = (Alpha + 1)
		end
	else
		if Alpha >= 0 then
			Alpha = (Alpha - 1)
		end
	end
end)

function ShowAudioInfo()
	local x = (ScrW() - (ScrW() * 0.15625))
	local y = (ScrH() * 0.0277)

	surface.SetFont("DermaLarge")
	surface.SetTextColor(255, 255, 255, Alpha)
	surface.SetTextPos(x, y)
	surface.DrawText("Currently Playing: ")
	surface.SetTextPos(x, y + 50)
	surface.DrawText(videoTitle)
end
hook.Add("HUDPaint", "VAudioInformation", ShowAudioInfo)
