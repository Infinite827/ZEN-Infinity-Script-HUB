
-- ZEN Infinity Script HUB - Infinite
(Amethyst Theme)

-- Core Services
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local Workspace = game:GetService("Workspace")

local DisplayName = LocalPlayer.DisplayName or LocalPlayer.Name

Rayfield:Notify({
    Title = "Hi, " .. DisplayName,
    Content = "Loading ZEN Infinity Script HUB...",
    Duration = 2.5,
    Image = 4483362458,
})

-- Utility Functions
local function getCharacterParts(player)
    local char = player.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        return humanoid, root, char
    end
    return nil, nil, nil
end

function sendChat(msg, color)
    StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = msg,
        Color = color or Color3.new(1,1,1),
        Font = Enum.Font.SourceSansBold,
        FontSize = Enum.FontSize.Size24
    })
end

-- Noclip
local noclipEnabled = false
local function setNoclip(enabled)
    noclipEnabled = enabled
    if enabled then
        RunService.Stepped:Connect(function()
            if noclipEnabled and LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

-- Speed Burst
local speedBurstCooldown = false
local function speedBurst()
    if speedBurstCooldown then
        return
    end
    speedBurstCooldown = true
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        local originalSpeed = humanoid.WalkSpeed
        humanoid.WalkSpeed = originalSpeed * 3
        task.delay(3, function()
            if humanoid then
                humanoid.WalkSpeed = originalSpeed
            end
        end)
    end
    task.delay(10, function()
        speedBurstCooldown = false
    end)
end

-- ESP
local highlights = {}
local function createESP(player)
    local char = player.Character
    if not char then return end
    if highlights[player] then highlights[player]:Destroy() end

    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(0, 255, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineTransparency = 0
    highlight.FillTransparency = 0.5
    highlight.Name = "ZenESP"
    highlight.Adornee = char
    highlight.Parent = Workspace
    highlights[player] = highlight
end

local function removeESP(player)
    if highlights[player] then
        highlights[player]:Destroy()
        highlights[player] = nil
    end
end

local function toggleESP(state)
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            if state then
                createESP(plr)
            else
                removeESP(plr)
            end
        end
    end
end

-- UI Setup
local Window = Rayfield:CreateWindow({
    Name = "ZEN Infinity Script HUB",
    LoadingTitle = "ZEN Infinity",
    LoadingSubtitle = "By InfiniteMaster",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "ZENInfinity"
    },
    KeySystem = false,
    Theme = Rayfield.Themes.Amethyst
})

-- Home Tab
local Home = Window:CreateTab("Home", 4483362458)
Home:CreateLabel("Hi, " .. DisplayName)
Home:CreateButton({
    Name = "My YouTube Channel",
    Callback = function()
        setclipboard("https://www.youtube.com/@Infinite_Original")
    end
})

-- Player Tab
local Player = Window:CreateTab("Player")
Player:CreateToggle({Name = "Noclip", Callback = setNoclip})
Player:CreateButton({Name = "Speed Burst", Callback = speedBurst})

-- Utilities Tab
local Utilities = Window:CreateTab("Utilities")
Utilities:CreateToggle({
    Name = "ESP Toggle",
    Callback = toggleESP
})

-- Commands
LocalPlayer.Chatted:Connect(function(msg)
    local args = msg:split(" ")
    local command = args[1]:lower()

    if command == ":noclip" then
        setNoclip(true)
    elseif command == ":unnoclip" then
        setNoclip(false)
    elseif command == ":esp" then
        toggleESP(true)
    elseif command == ":unesp" then
        toggleESP(false)
    elseif command == ":speedburst" then
        speedBurst()
    end
end)

Rayfield:Notify({
    Title = "ZEN Infinity",
    Content = "All systems loaded!",
    Duration = 4
})




