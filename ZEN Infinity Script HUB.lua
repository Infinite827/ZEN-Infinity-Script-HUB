
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

-- FE/Server Sided Chat Admin Commands (outside of Window config)
task.spawn(function()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local StarterGui = game:GetService("StarterGui")
    local LocalPlayer = Players.LocalPlayer

    -- Safe function to send system chat messages
    local function chatMessage(text, color)
        color = color or Color3.fromRGB(0, 255, 255)
        local success, err = pcall(function()
            StarterGui:SetCore("ChatMakeSystemMessage", {
                Text = text,
                Color = color,
                Font = Enum.Font.SourceSansBold,
                FontSize = Enum.FontSize.Size24
            })
        end)
        if not success then
            warn("Chat message failed: " .. tostring(err))
        end
    end

    -- Variables to track active states
    local activeSpinning = false
    local spinThread = nil
    local noclipConnection = nil
    local flyLoaded = false

    local commands = {
        ["kill"] = function()
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.Health = 0
                chatMessage("You have been killed.", Color3.fromRGB(255, 0, 0))
            else
                chatMessage("Humanoid not found!", Color3.fromRGB(255, 255, 0))
            end
        end,

        ["fly"] = function()
            if flyLoaded then
                chatMessage("Fly GUI already loaded!", Color3.fromRGB(255, 255, 0))
                return
            end
            local success, err = pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
            end)
            if success then
                flyLoaded = true
                chatMessage("Fly GUI loaded!", Color3.fromRGB(0, 255, 0))
            else
                chatMessage("Failed to load Fly GUI: " .. tostring(err), Color3.fromRGB(255, 0, 0))
            end
        end,

        ["unfly"] = function()
            if flyLoaded then
                local flyGui = LocalPlayer.PlayerGui:FindFirstChild("FlyGuiV3")
                if flyGui then
                    flyGui:Destroy()
                    chatMessage("Fly GUI unloaded.", Color3.fromRGB(0, 255, 0))
                else
                    chatMessage("Fly GUI not found!", Color3.fromRGB(255, 255, 0))
                end
                flyLoaded = false
            else
                chatMessage("Fly GUI is not active.", Color3.fromRGB(255, 255, 0))
            end
        end,

        ["spin"] = function()
            if activeSpinning then
                chatMessage("Already spinning!", Color3.fromRGB(255, 255, 0))
                return
            end
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                chatMessage("Spinning started.", Color3.fromRGB(0, 255, 0))
                activeSpinning = true
                spinThread = task.spawn(function()
                    while activeSpinning and hrp and hrp.Parent do
                        task.wait()
                        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(10), 0)
                    end
                end)
            else
                chatMessage("HumanoidRootPart not found!", Color3.fromRGB(255, 255, 0))
            end
        end,

        ["unspin"] = function()
            if activeSpinning then
                activeSpinning = false
                chatMessage("Spinning stopped.", Color3.fromRGB(0, 255, 0))
            else
                chatMessage("Not spinning right now.", Color3.fromRGB(255, 255, 0))
            end
        end,

        ["noclip"] = function()
            if noclipConnection then
                chatMessage("Noclip already enabled!", Color3.fromRGB(255, 255, 0))
                return
            end
            chatMessage("Noclip enabled.", Color3.fromRGB(0, 255, 0))
            noclipConnection = RunService.Stepped:Connect(function()
                if LocalPlayer.Character then
                    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end,

        ["unnoclip"] = function()
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
                chatMessage("Noclip disabled.", Color3.fromRGB(0, 255, 0))
            else
                chatMessage("Noclip is not enabled.", Color3.fromRGB(255, 255, 0))
            end
        end,

        ["cmds"] = function()
            local list = {}
            for name in pairs(commands) do
                table.insert(list, ":" .. name)
            end
            table.sort(list)
            chatMessage("Available Commands: " .. table.concat(list, ", "), Color3.fromRGB(255, 255, 0))
        end,
    }

    LocalPlayer.Chatted:Connect(function(msg)
        msg = msg:lower()
        if msg:sub(1, 1) == ":" then
            local cmd = msg:sub(2)
            if commands[cmd] then
                local success, err = pcall(commands[cmd])
                if success then
                    chatMessage("Server: Command Executed Successfully", Color3.fromRGB(0, 255, 0))
                else
                    chatMessage("Server: Command Failed To Execute\n" .. tostring(err), Color3.fromRGB(255, 0, 0))
                    warn("Command error: " .. tostring(err))
                end
            else
                chatMessage("Unknown command: " .. cmd, Color3.fromRGB(255, 0, 0))
            end
        end
    end)

    chatMessage("FE Chat Commands loaded! Use :cmds to see commands.", Color3.fromRGB(0, 255, 255))
end)

-- Home Tab
local Home_Tab = Window:CreateTab("Home", 4483362458)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local displayName = LocalPlayer and LocalPlayer.DisplayName or "Player"

-- Greeting Label
Home_Tab:CreateLabel("Hi, " .. displayName)
local Divider1 = Home_Tab:CreateDivider()

-- YouTube Channel Button
Home_Tab:CreateButton({
    Name = "My Youtube Channel",
    Callback = function()
        setclipboard("https://www.youtube.com/@Infinite_Original")
        Rayfield:Notify({
            Title = "YouTube",
            Content = "Link copied to clipboard!",
            Duration = 4
        })
    end
})

local Divider2 = Home_Tab:CreateDivider()

-- Commands List Label
local commandList = {}
for name in pairs(commands) do
    table.insert(commandList, ":" .. name)
end
table.sort(commandList)

Home_Tab:CreateParagraph({
    Title = "Commands List",
    Content = table.concat(commandList, "\n")
})

-- Unload Button
Home_Tab:CreateButton({
    Name = "Unload The ZEN Infinity Script HUB",
    Callback = function()
        Rayfield:Destroy()
    end
})

-- Game Scripts Tab
local Game_Scripts = Window:CreateTab("Game Scripts", 4483362458)
local Divider = Game_Scripts:CreateDivider()

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
local Divider = PlayerTab:CreateDivider()

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
local Divider = Additional_Scripts:CreateDivider()

-- Trolling Tab
local Trolling = Window:CreateTab("Trolling", 4483362458)
local Divider = Trolling:CreateDivider()

Trolling:CreateButton({
    Name = "FE Server-Sided Sword",
    Callback = function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/CMD-X/CMD-X/master/Tools/Sword.lua"))()
        end)
        if not success then
            warn("Failed to load FE Sword: " .. tostring(err))
            local StarterGui = game:GetService("StarterGui")
            StarterGui:SetCore("ChatMakeSystemMessage", {
                Text = "Server: Command Failed To Execute\n" .. tostring(err),
                Color = Color3.fromRGB(255, 0, 0),
                Font = Enum.Font.SourceSansBold,
                FontSize = Enum.FontSize.Size24
            })
        else
            -- Show confirmation message
            local StarterGui = game:GetService("StarterGui")
            local success2, err2 = pcall(function()
                StarterGui:SetCore("ChatMakeSystemMessage", {
                    Text = "FE Server-Sided Sword loaded!",
                    Color = Color3.fromRGB(0, 255, 255),
                    Font = Enum.Font.SourceSansBold,
                    FontSize = Enum.FontSize.Size24
                })
            end)
            if not success2 then
                warn("Failed to send confirmation chat message: " .. tostring(err2))
            end
        end
    end
})




