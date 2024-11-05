local TimerGUI = script.Parent
local Timer = TimerGUI.Timer

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TimeLeft = ReplicatedStorage.HazardTime
local Minuets = ReplicatedStorage.HazardMinuets
local Seconds = ReplicatedStorage.HazardSeconds

Seconds.Changed:Connect(function()
	Timer.Text = (string.format("%02d:%02d", Minuets.Value, Seconds.Value))

	if TimeLeft.Value == 0 then
		TimerGUI.Enabled = false
	end
end)
