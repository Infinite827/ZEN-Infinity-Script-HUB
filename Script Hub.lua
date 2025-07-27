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

-- Helper function to send system chat messages
local StarterGui = game:GetService("StarterGui")
local function chatMessage(text)
    pcall(function()
        StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = text,
            Color = Color3.fromRGB(0, 255, 255),
            Font = Enum.Font.SourceSansBold,
            FontSize = Enum.FontSize.Size24
        })
    end)
end

-- FE/Server Sided Chat Admin Commands
task.spawn(function()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer

    -- Prevent multiple fly GUIs by checking if one exists
    local function loadFlyGui()
        if LocalPlayer.PlayerGui:FindFirstChild("FlyGuiV3") then
            chatMessage("Fly GUI already loaded!")
            return
        end
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
        end)
        if not success then
            chatMessage("Failed to load Fly GUI: " .. tostring(err))
        else
            chatMessage("Fly GUI loaded!")
        end
    end

    local commands = {
        ["kill"] = function()
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.Health = 0
                chatMessage("You have been killed.")
            else
                chatMessage("Humanoid not found!")
            end
        end,

        ["fly"] = function()
            loadFlyGui()
        end,

        ["spin"] = function()
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                chatMessage("Spinning started.")
                task.spawn(function()
                    while hrp and hrp.Parent do
                        task.wait()
                        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(10), 0)
                    end
                end)
            else
                chatMessage("HumanoidRootPart not found!")
            end
        end,

        ["noclip"] = function()
            chatMessage("Noclip enabled.")
            RunService.Stepped:Connect(function()
                if LocalPlayer.Character then
                    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end,

        ["cmds"] = function()
            local list = {}
            for name in pairs(commands) do
                table.insert(list, ":" .. name)
            end
            table.sort(list)
            local msg = "Available Commands: " .. table.concat(list, ", ")
            chatMessage(msg)
        end,
    }

    LocalPlayer.Chatted:Connect(function(msg)
        msg = msg:lower()
        if msg:sub(1, 1) == ":" then
            local cmd = msg:sub(2)
            if commands[cmd] then
                local success, err = pcall(commands[cmd])
                if not success then
                    chatMessage("Error running command: " .. tostring(err))
                end
            else
                chatMessage("Unknown command: " .. cmd)
            end
        end
    end)

    chatMessage("FE Chat Commands loaded! Use :cmds to see commands.")
end)

-- Home Tab
local Home_Tab = Window:CreateTab("Home", 4483362458)
Home_Tab:CreateDivider()

Home_Tab:CreateButton({
    Name = "Unload The ZEN Infinity Script HUB",
    Callback = function()
        Rayfield:Destroy()
    end
})

-- Game Scripts Tab
local Game_Scripts = Window:CreateTab("Game Scripts", 4483362458)
Game_Scripts:CreateDivider()

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
PlayerTab:CreateDivider()

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

-- Additional Scripts Tab
local Additional_Scripts = Window:CreateTab("Additional Scripts", 4483362458)
Additional_Scripts:CreateDivider()

-- Trolling Tab
local Trolling = Window:CreateTab("Trolling", 4483362458)
Trolling:CreateDivider()

Trolling:CreateButton({
    Name = "FE Server-Sided Sword",
    Callback = function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/CMD-X/CMD-X/master/Tools/Sword.lua"))()
        end)
        if success then
            chatMessage("FE Server-Sided Sword loaded successfully!")
        else
            chatMessage("Failed to load FE Sword: " .. tostring(err))
        end
    end
})




