function getVideoIDFromURL(url)
	if url:len() <= 0 then return end

	local _, v_end = url:find("v=", 1, true)
	if not v_end then return end

	local videoID = url:sub(v_end + 1, v_end + 11)
	if videoID and videoID:len() ~= 11 then return end

	return videoID
end

function getVideoTitleFromHTTPData(data)
	local videoTitle

	if data:len() <= 0 then
		print("Error retrieving video title")
		videoTitle = "<unknown_title>"
	else
		local _, title_tag1_end = data:find("<media:title type='plain'>", 1, true)
		local title_tag2_pos = data:find("</media:title>", title_tag1_end + 1, true)
		videoTitle = data:sub(title_tag1_end + 1, title_tag2_pos - 1 )
		videoTitle = (videoTitle ~= nil and videoTitle ~= "") and videoTitle or "<unknown_title>"
	end

	return videoTitle
end

function getVideoLengthFromHTTPData(data)
	if data:len() <= 0 then return end

	local _, durationStart = data:find("<yt:duration seconds='", 1, true)
	local dur_end = data:find("'/>", durationStart + 1, true)

	if not durationStart or not dur_end then return end

		local duration = tonumber(data:sub(durationStart + 1, dur_end - 1 ))

	return duration
end

function playVideo(url)
	//local videoID = getVideoIDFromURL(url)
		
	umsg.Start("val_jukebox_play")
		umsg.String(url)
	umsg.End()
end

function valPlayAudio(ply, cmd, args)
	local URL = (args[1])

	if IsValid(ply) then
		if URL != "" then
			playVideo(URL)
		else
			return
		end
	end
end
concommand.Add("val_playaudio", valPlayAudio) 

function stopVideo()
	umsg.Start("val_jukebox_stop")
	umsg.End()
end

concommand.Add("val_stopaudio", function()
	stopVideo()
end)

function chatCommand(ply, text, public)
	if text == "!vq" then
		ply:ConCommand("val_jukebox_queue")
		return (false)
	end
end
hook.Add('PlayerSay', "UpdateQueue", chatCommand)
