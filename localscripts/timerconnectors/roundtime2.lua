local TimerGUI = script.Parent
local Timer = TimerGUI.Timer

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TimeLeft = ReplicatedStorage.Round2Time
local Minuets = ReplicatedStorage.Round2Minuets
local Seconds = ReplicatedStorage.Round2Seconds

Seconds.Changed:Connect(function()
	Timer.Text = (string.format("%02d:%02d", Minuets.Value, Seconds.Value))

	if TimeLeft.Value == 0 then
		TimerGUI.Enabled = false
	end
end)
