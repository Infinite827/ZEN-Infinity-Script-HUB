
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

-- FE/Server Sided Admin Commands
task.spawn(function()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local StarterGui = game:GetService("StarterGui")
    local LocalPlayer = Players.LocalPlayer

    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.CharacterAdded:Wait()
        repeat task.wait() until LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    end

    local function getHumanoid()
        return LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    end

    local function chatMessage(text)
        StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = text,
            Color = Color3.fromRGB(0, 255, 255),
            Font = Enum.Font.SourceSansBold,
            FontSize = Enum.FontSize.Size24
        })
    end

    local commands = {
        ["kill"] = function()
            local h = getHumanoid()
            if h then h.Health = 0 end
        end,

        ["fly"] = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
        end,

        ["spin"] = function()
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                task.spawn(function()
                    while hrp and hrp.Parent do
                        task.wait()
                        hrp.CFrame *= CFrame.Angles(0, math.rad(10), 0)
                    end
                end)
            end
        end,

        ["noclip"] = function()
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
            chatMessage("Available Commands:")
            chatMessage(table.concat(list, ", "))
        end,
    }

    LocalPlayer.Chatted:Connect(function(msg)
        msg = msg:lower()
        if msg:sub(1, 1) == ":" then
            local cmd = msg:sub(2)
            if commands[cmd] then
                pcall(commands[cmd])
            end
        end
    end)
end),

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

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ChatService = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
local UserInputService = game:GetService("UserInputService")
local humanoid = nil

-- Updates your humanoid if it changes
local function updateHumanoid()
    if LocalPlayer.Character then
        humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    end
end

LocalPlayer.CharacterAdded:Connect(updateHumanoid)
updateHumanoid()

-- Command functions
local commands = {
    ["kill"] = function()
        if humanoid then
            humanoid.Health = 0
        end
    end,

    ["fly"] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
    end,

    ["noclip"] = function()
        local noclip = true
        game:GetService('RunService').Stepped:Connect(function()
            if noclip and LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide == true then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end,

    ["spin"] = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            while true do
                task.wait()
                hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(10), 0)
            end
        end
    end
}

-- Chat listener
LocalPlayer.Chatted:Connect(function(msg)
    if msg:sub(1,1) == "/" then
        local cmd = msg:sub(2):lower()
        if commands[cmd] then
            commands[cmd]()
        else
            warn("Unknown command:", cmd)
        end
    end
end)


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


