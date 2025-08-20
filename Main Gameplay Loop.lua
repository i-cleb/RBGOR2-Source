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
local Gear = game.ServerStorage.Gears:GetChildren()

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
	spwnGear = true
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
	spwnGear = false
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

function roundTime1()
	Round1Time.Value = 15

	for r = Round1Time.Value, 0, -1 do
		Round1Time.Value = r
		Round1Minuets.Value = math.floor(Round1Time.Value / 60)
		Round1Seconds.Value = math.floor(Round1Time.Value % 60)
		wait(1)
	end
end

function roundTime2()
	Round2Time.Value = 15

	for r = Round2Time.Value, 0, -1 do
		Round2Time.Value = r
		Round2Minuets.Value = math.floor(Round2Time.Value / 60)
		Round2Seconds.Value = math.floor(Round2Time.Value % 60)
		wait(1)
	end
end


function hazardTime()
	HazardTime.Value = 5

	for h = HazardTime.Value, 0, -1 do
		HazardTime.Value = h
		HazardMinuets.Value = math.floor(HazardTime.Value / 60)
		HazardSeconds.Value = math.floor(HazardTime.Value % 60)
		wait(1)
	end
end


game.Players.PlayerAdded:Connect(function(ply)
	ply.CharacterAdded:Connect(function()
		if spwnGear == true then
			local used = {}
			local function getGear()
				local GearCopy = math.random(1, #Gear)
				while used[GearCopy] do
					GearCopy = math.random(1, #Gear)
				end
				used[GearCopy] = true
				local items = Gear[GearCopy]
				return items
			end
			
			for i = 1,6 do
				local item = getGear()
				local itemCopy = item:Clone()
				itemCopy.Parent = ply.Backpack
			end
		end
	end)
end)

	
-------------------------------------------------------------------------------

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
		spawnLobby()
		wait(30)
		regenStructures()
		roundTime1()
		
	end
end





