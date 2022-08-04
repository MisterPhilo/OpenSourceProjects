--[[



                                         /$$ /$$ /$$          
                                        | $$| $$|__/          
  /$$$$$$   /$$$$$$  /$$$$$$$$ /$$   /$$| $$| $$ /$$ /$$   /$$
 /$$__  $$ /$$__  $$|____ /$$/| $$  | $$| $$| $$| $$|  $$ /$$/
| $$  \ $$| $$  \__/   /$$$$/ | $$  | $$| $$| $$| $$ \  $$$$/ 
| $$  | $$| $$        /$$__/  | $$  | $$| $$| $$| $$  >$$  $$ 
|  $$$$$$/| $$       /$$$$$$$$|  $$$$$$/| $$| $$| $$ /$$/\  $$
 \______/ |__/      |________/ \______/ |__/|__/|__/|__/  \__/



    module:Play(string)                     -- In quotations place the text you wish to see in the title

    module:Init({
        TweenLengthOther = number,          -- Time it takes for the beginning bars to fade in
        TweenLengthText = number,           -- Time the text takes to fade and the fade-out time
        GUI = Instance,                     -- For Custom GUIS
        TextFont = Enum.Font.Name,          -- The font you want it to be
        SongId = "rbxassetid://soundid"     -- Change the sound
        Volume = number,                    -- Change the volume
    })

]]

local module = {}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local localPlayer = Players.LocalPlayer
local PlayerGui = localPlayer.PlayerGui


function module:Play(Text)
	local function text(num)
		TweenService:Create(module.TextLabel, TweenInfo.new(module.TweenLengthText, Enum.EasingStyle.Sine,Enum.EasingDirection.Out), {TextTransparency = num}):Play()
	end

	local function other(time, num)
		for _, guiObject in pairs(module.MainFrame:GetDescendants()) do
			if guiObject:GetAttribute("enabled") == true then
				if time == "opening" then
					if guiObject:IsA("Frame") then
						TweenService:Create(guiObject,TweenInfo.new(module.TweenLengthOther, Enum.EasingStyle.Sine,Enum.EasingDirection.Out), {Size = guiObject:GetAttribute("sizeOpen"), BackgroundTransparency = num}):Play()
					end
					if guiObject:IsA("ImageLabel") then
						TweenService:Create(guiObject,TweenInfo.new(module.TweenLengthOther, Enum.EasingStyle.Sine,Enum.EasingDirection.Out), {Size = guiObject:GetAttribute("sizeOpen"), ImageTransparency = num}):Play()
					end
				end

				if time == "closing" then
					if guiObject:IsA("Frame") then
						TweenService:Create(guiObject,TweenInfo.new(module.TweenLengthText, Enum.EasingStyle.Sine,Enum.EasingDirection.Out), {Size = guiObject:GetAttribute("sizeClose"), BackgroundTransparency = num}):Play()
					end
					if guiObject:IsA("ImageLabel") then
						TweenService:Create(guiObject,TweenInfo.new(module.TweenLengthText, Enum.EasingStyle.Sine,Enum.EasingDirection.Out), {Size = guiObject:GetAttribute("sizeClose"), ImageTransparency = num}):Play()
					end
				end
			end
		end
	end

	module.TextLabel.Text = Text
	module.MainSound:Play()
	other("opening", 0)

	task.wait(module.TweenLengthOther)
	text(0)
	task.wait(module.TweenLengthText + 1)
	text(1)

	other("closing", 1)

end


function module:Init(Settings)
	module.TweenLengthOther = Settings.TweenLengthOther or 10
	module.TweenLengthText = Settings.TweenLengthText or 4
	module.MainGui = Settings.GUI or script:WaitForChild("Template")
	module.TextFont = Settings.TextFont or Enum.Font.Bodoni

	if not module.MainGui:IsDescendantOf(PlayerGui) then
		module.MainGui = module.MainGui:Clone()
		module.MainGui.Parent = PlayerGui
		module.MainGui.Name = "LocationTitle"
	end

	module.MainFrame = module.MainGui:WaitForChild("MainFrame")
	module.TextLabel = module.MainFrame:WaitForChild("LocationLabel")

	module.MainSound = Instance.new("Sound")
	module.MainSound.Parent = module.MainGui
	module.MainSound.SoundId = Settings.SongId or "rbxassetid://1846898632"
	module.MainSound.Volume = Settings.Volume or 0.5
end

return module