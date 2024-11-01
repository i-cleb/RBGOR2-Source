local RoundTime = game.ReplicatedStorage.RoundTime
local HazardTime = game.ReplicatedStorage.HazardTime
local RoundMinuets = game.ReplicatedStorage.RoundMinuets
local RoundSeconds = game.ReplicatedStorage.RoundSeconds
local HazardMinuets = game.ReplicatedStorage.HazardMinuets
local HazardSeconds = game.ReplicatedStorage.HazardSeconds
local Pause = false

function respawnPlayers() -- Respawn players to the stage
	for index,player in pairs(game:GetService("Players"):GetPlayers()) do -- gets all the players
		player:LoadCharacter() -- forces the respawn
	end
end

function stageMusic() -- Plays the stage music
	local existingSound = workspace:FindFirstChildOfClass("Sound", "Music")
	if existingSound then
		existingSound:Stop()
		existingSound:Destroy()
	end -- Checks to see if there's currently a song playing and kills it if so

	local music = game.ServerStorage.Music.StageMusic:GetChildren()
	local musicCopy = music[math.random(1, #music)]:Clone()
	musicCopy.Parent = workspace
	local loadedMusic = workspace:FindFirstChildOfClass("Sound", "Music")

	loadedMusic:Play()
	loadedMusic.Looped = true
end

function lobbyMusic() -- Plays the lobby music
	local existingSound = workspace:FindFirstChildOfClass("Sound", "Music")
	if existingSound then
		existingSound:Stop()
		existingSound:Destroy()
	end -- Checks to see if there's currently a song playing and kills it if so

	local lmusic = game.ServerStorage.Music.LobbyMusic:GetChildren()
	local lmusicCopy = lmusic[math.random(1, #lmusic)]:Clone()
	lmusicCopy.Parent = workspace
	local loadedLMusic = workspace:FindFirstChildOfClass("Sound", "Music")

	loadedLMusic:Play()
end

function regenStructures() -- Removes the currently loaded map and spawns a new one
	workspace.StructuresL:ClearAllChildren()
	local maps = game.ServerStorage.Clones.Maps:GetChildren()
	local mapCopy = maps[math.random(1, #maps)]:Clone()
	mapCopy.Parent = workspace.Structures
	mapCopy:MakeJoints()

	respawnPlayers()
	stageMusic()



end

function spawnLobby() -- Removes the currently loaded map and spawns the lobby
	workspace.Structures:ClearAllChildren()
	local lobby = game.ServerStorage.Lobby:GetChildren()
	local lobbyCopy = lobby[math.random(1, #lobby)]:Clone()
	lobbyCopy.Parent = workspace.StructuresL
	lobbyCopy:MakeJoints()

	respawnPlayers()
	lobbyMusic()


end

function spawnHazard()
	local hazards = game.ServerStorage.Disasters:GetChildren()
	local hazardsCopy = hazards[math.random(1, #hazards)]:Clone()
	hazardsCopy.Parent = workspace.Hazards
	hazardsCopy:MakeJoints()
end

function roundTime()
	RoundTime.Value = 420

	for r = RoundTime.Value, 0, -1 do
		while Pause do
			wait(0.1)
		end
		RoundTime.Value = r
		RoundMinuets.Value = math.floor(RoundTime.Value / 60)
		RoundSeconds.Value = math.floor(RoundTime.Value % 60)
		wait(1)
	end
end

function hazardTime()
	HazardTime.Value = 150

	for h = HazardTime.Value, 0, -1 do
		HazardTime.Value = h
		HazardMinuets.Value = math.floor(HazardTime.Value / 60)
		HazardSeconds.Value = math.floor(HazardTime.Value % 60)
		wait(1)
	end
end

-------------------------------------------------------------------------------

regenStructures()
roundTime()
while true do
	if RoundTime.Value == 210 then
		Pause = true
		spawnHazard()
		hazardTime()
		if HazardTime.Value == 0 then
			workspace.Hazards:ClearAllChildren()
			Pause = false
		end
	end
	
	if RoundTime.Value == 0 then
		spawnLobby()
		wait(30)
		regenStructures()
		roundTime()
	end
end



