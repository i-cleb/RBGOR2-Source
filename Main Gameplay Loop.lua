local Round1Time = game.ReplicatedStorage.Round1Time
local Round2Time = game.ReplicatedStorage.Round2Time
local HazardTime = game.ReplicatedStorage.HazardTime
local Round1Minuets = game.ReplicatedStorage.Round1Minuets
local Round2Minuets = game.ReplicatedStorage.Round2Minuets
local Round1Seconds = game.ReplicatedStorage.Round1Seconds
local Round2Seconds = game.ReplicatedStorage.Round2Seconds
local HazardMinuets = game.ReplicatedStorage.HazardMinuets
local HazardSeconds = game.ReplicatedStorage.HazardSeconds
local Pause = false
local spwnGear = true
local gears = {383608755, 928796097, 97161241, 972187699, 928914739, 503957396, 522587921, 563287969, 1145081326, 1208300505, 34398938, 186867645, 10758456, 243007180, 212296936, 48596305, 72713855, 118281463, 107458483, 11999247, 11377306, 11563251, 115377964, 225921000, 90718505, 1180418251, 66426498, 566780253, 95951330, 846792499, 11999279, 972189904, 1046323916, 391005275, 928806888, 169602103, 130112971, 1492225511, 208659586, 1060280135, 2535102910, 71037101, 261439002, 330296114, 87361662, 155661985, 2605966484, 2226815033, 1215506016, 172248941, 928805891, 395205954, 83021250, 174752245, 168143042, 208659734, 206798405, 330295904}

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
	spwnGear = true

	respawnPlayers()
	stageMusic()



end

function spawnLobby() -- Removes the currently loaded map and spawns the lobby
	workspace.Structures:ClearAllChildren()
	local lobby = game.ServerStorage.Lobby:GetChildren()
	local lobbyCopy = lobby[math.random(1, #lobby)]:Clone()
	lobbyCopy.Parent = workspace.StructuresL
	lobbyCopy:MakeJoints()
	spwnGear = false

	respawnPlayers()
	lobbyMusic()


end

function spawnHazard()
	local hazards = game.ServerStorage.Disasters:GetChildren()
	local hazardsCopy = hazards[math.random(1, #hazards)]:Clone()
	hazardsCopy.Parent = workspace.Hazards
	hazardsCopy:MakeJoints()
end

function roundTime1()
	Round1Time.Value = 210

	for r = Round1Time.Value, 0, -1 do
		Round1Time.Value = r
		Round1Minuets.Value = math.floor(Round1Time.Value / 60)
		Round1Seconds.Value = math.floor(Round1Time.Value % 60)
		wait(1)
	end
end

function roundTime2()
	Round2Time.Value = 210

	for r = Round2Time.Value, 0, -1 do
		Round2Time.Value = r
		Round2Minuets.Value = math.floor(Round2Time.Value / 60)
		Round2Seconds.Value = math.floor(Round2Time.Value % 60)
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

function plrGear()
	if spwnGear == true then
		game.Players.PlayerAdded:connect(function(ply)
		ply.CharacterAdded:Connect(function()
			local taken = {}
			local function getGear()
				local id = math.random(1,#gears)
				while taken[id] do
					id = math.random(1,#gears)
				end
				taken[id] = true
				local model = game:GetService("InsertService"):LoadAsset(gears[id])
				return model
			end
			for i = 1,6 do
				local model = getGear()
				for _,v in pairs(model:GetChildren()) do
					if v:IsA("Tool") or v:IsA("HopperBin") then
						v.Parent = ply.Backpack
					end
				end
			end
		end)
	end) 
	end
end

-------------------------------------------------------------------------------
plrGear()
regenStructures()
roundTime1()
while true do
	if Round1Time.Value == 0 then
		spawnHazard()
		hazardTime()
		if HazardTime.Value == 0 then
			workspace.Hazards:ClearAllChildren()
			roundTime2()
		end
	end
	
	if Round2Time.Value == 0 then
		spwnGear = false
		spawnLobby()
		wait(30)
		regenStructures()
		roundTime1()
		spwnGear = true
	end
end



