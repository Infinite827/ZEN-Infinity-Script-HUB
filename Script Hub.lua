
-- Load Rayfield UI Library
local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
end)

if not success then
    warn("Failed to load Rayfield.")
    return
end

-- Create the main window
local Window = Rayfield:CreateWindow({
    Name = "ZEN Infinity HUB",
    LoadingTitle = "ZEN Infinity HUB",
    LoadingSubtitle = "by us",
    ShowText = "ZEN Infinity Script HUB",
    Theme = "Amethyst",
    ToggleUIKeybind = Enum.KeyCode.Semicolon,

    ConfigurationSaving = {
        Enabled = true,
        FolderName = "ZENHub",
        FileName = "ZEN_Config"
    },

    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },

    KeySystem = false,
    KeySettings = {
        Title = "Key System",
        Subtitle = "Enter Key",
        Note = "No key required.",
        FileName = "ZENKey",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"Hello"}
    }
})

-- Home Tab
local Home_Tab = Window:CreateTab("Home", 4483362458)

Home_Tab:CreateButton({
    Name = "Unload The ZEN Infinity Script HUB",
    Callback = function()
        Rayfield:Destroy()
    end
})

-- Game Scripts Tab
local Game_Scripts = Window:CreateTab("Game Scripts", 4483362458)

Game_Scripts:CreateButton({
    Name = "Natural Disaster Survival Scripts",
    Callback = function()
        pcall(function()
            loadstring(game:HttpGet("https://rawscripts.net/raw/Free-CLIENTSIDED-Balloon-Giver!_175"))()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/hyperionhax/c00lgui/refs/heads/main/CoolGui.lua"))()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/M-E-N-A-C-E/Menace-Hub/refs/heads/main/Free%20Sus%20Missile"))()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
            loadstring(game:HttpGet("https://rawscripts.net/raw/Natural-Disaster-Survival-Katers-NDS-Hub-19533"))()
            loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-InfYeiod-reupload-27320"))()
            loadstring(game:HttpGet("https://github.com/Synergy-Networks/products/raw/main/BetterBypasser/loader.lua"))()
        end)
    end
})

Game_Scripts:CreateButton({
    Name = "Roleplaying Script",
    Callback = function()
        local function safeLoad(url)
            local success, result = pcall(function()
                loadstring(game:HttpGet(url))()
            end)
            if not success then
                warn("Failed to load: " .. url .. "\nError: " .. result)
            end
        end

        safeLoad("https://raw.githubusercontent.com/hyperionhax/c00lgui/main/CoolGui.lua")
        safeLoad("https://raw.githubusercontent.com/M-E-N-A-C-E/Menace-Hub/main/Free%20Sus%20Missile")
        safeLoad("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt")
        safeLoad("https://rawscripts.net/raw/Universal-Script-InfYeiod-reupload-27320")
        safeLoad("https://raw.githubusercontent.com/Synergy-Networks/products/main/BetterBypasser/loader.lua")
    end
})

-- Player Tab
local PlayerTab = Window:CreateTab("Player", 4483362458)

PlayerTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 10000},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 16,
    Flag = "WalkSpeedSlider",
    Callback = function(Value)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChildWhichIsA("Humanoid") then
            char.Humanoid.WalkSpeed = Value
        end
    end,
})

PlayerTab:CreateSlider({
    Name = "Jump Power",
    Range = {50, 1000},
    Increment = 1,
    Suffix = "Power",
    CurrentValue = 50,
    Flag = "JumpPowerSlider",
    Callback = function(Value)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChildWhichIsA("Humanoid") then
            char.Humanoid.JumpPower = Value
        end
    end,
})

--Additional Scripts Tab
local Additional_Scripts = Window:CreateTab("Additional Scripts", 4483362458)

Additional_Scripts:CreateButton({
	Name = "Enable Chat Admin Commands (FE)",
	Callback = function()
		local Players = game:GetService("Players")
		local LocalPlayer = Players.LocalPlayer
		local StarterGui = game:GetService("StarterGui")

		if _G.ChatAdminConnected then
			Rayfield:Notify({
				Title = "Already Enabled",
				Content = "Chat commands are already active.",
				Duration = 4,
			})
			return
		end
		_G.ChatAdminConnected = true

		Rayfield:Notify({
			Title = "Chat Admin Enabled",
			Content = "Type /fly, /sword, /kill, /tools in chat.",
			Duration = 6.5,
			Image = 4483362458
		})

		LocalPlayer.Chatted:Connect(function(msg)
			local command = msg:lower()

			if command == "/fly" then
				local success, err = pcall(function()
					loadstring(game:HttpGet("https://raw.githubusercontent.com/IceMael7/FE-Fly/main/FEFly.lua"))()
				end)
				if not success then
					warn("Fly script error:", err)
				end

			elseif command == "/sword" then
				local success, err = pcall(function()
					loadstring(game:HttpGet("https://raw.githubusercontent.com/CMD-X/CMD-X/master/Tools/Sword.lua"))()
				end)
				if not success then
					warn("Sword script error:", err)
				end

			elseif command == "/kill" then
				if LocalPlayer.Character then
					LocalPlayer.Character:BreakJoints()
				end

			elseif command == "/tools" then
				for _, tool in ipairs(game:GetService("StarterPack"):GetChildren()) do
					tool:Clone().Parent = LocalPlayer.Backpack
				end

			else
				StarterGui:SetCore("ChatMakeSystemMessage", {
					Text = "❌ Unknown command: " .. msg,
					Color = Color3.fromRGB(255, 50, 50),
					Font = Enum.Font.SourceSansBold,
					TextSize = 18
				})
			end
		end)
	end
})


--Trolling Tab
local Trolling = Window:CreateTab("Trolling", 4483362458)

Trolling:CreateButton({
    Name = "FE Server-Sided Sword",
    Callback = function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/CMD-X/CMD-X/master/Tools/Sword.lua"))()
        end)
        if not success then
            warn("Failed to load FE Sword: " .. tostring(err))
        end
    end
})


