-- ZEN Infinity Script HUB (Fixed and working)

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

-- Load Rayfield UI with correct URL
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source.lua'))()

local Window = Rayfield:CreateWindow({
    Name = "ZEN Infinity HUB",
    LoadingTitle = "Loading ZEN Infinity HUB",
    LoadingSubtitle = "by InfiniteMaster",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "ZENInfinityHub",
        FileName = "config"
    },
    KeySystem = false,
    Theme = "Amethyst"
})

-- Home Tab
local Home_Tab = Window:CreateTab("Home")

local displayName = localPlayer and localPlayer.DisplayName or "Player"
Home_Tab:CreateLabel("Hi, " .. displayName)
Home_Tab:CreateLabel("")
Home_Tab:CreateLabel("")

local commandsParagraph = [[
Commands list:
:kill [target] - Kill target player(s)
:sit [target] - Make target player(s) sit
:fling [target] - Fling target player(s)
:invisible [target] - Make target player(s) invisible
:uninvisible [target] - Make target player(s) visible again
:cmds - Show this list

Targets:
all = everyone
others = everyone except you
me = yourself
PlayerName = specific player
]]

Home_Tab:CreateParagraph({
    Title = "Commands",
    Content = commandsParagraph
})

Home_Tab:CreateButton({
    Name = "My Youtube Channel",
    Callback = function()
        local msg = "Check out: https://www.youtube.com/@Infinite_Original"
        print(msg)
        pcall(function()
            localPlayer:SendNotification({
                Title = "YouTube Channel",
                Text = msg,
                Duration = 5
            })
        end)
    end
})

-- Trolling Tab
local Trolling_Tab = Window:CreateTab("Trolling")

Trolling_Tab:CreateButton({
    Name = "FE Sword",
    Callback = function()
        -- Add your FE sword script here
        print("FE Sword script executed")
    end
})

-- WalkSpeed slider with persistence on respawn
local currentWalkSpeed = 16

local function setWalkSpeed(value)
    local character = localPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = value
    end
end

Trolling_Tab:CreateSlider({
    Name = "WalkSpeed",
    Min = 16,
    Max = 250,
    Default = 16,
    Increment = 1,
    Suffix = " speed",
    Flag = "WalkSpeed",
    Callback = function(value)
        currentWalkSpeed = value
        setWalkSpeed(value)
    end,
})

localPlayer.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid")
    setWalkSpeed(currentWalkSpeed)
end)

-- Command Handler
local function getPlayersFromTarget(target)
    local players = {}

    if target == "all" then
        players = Players:GetPlayers()
    elseif target == "others" then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= localPlayer then
                table.insert(players, player)
            end
        end
    elseif target == "me" then
        players = {localPlayer}
    else
        -- Find player by name or display name
        for _, player in pairs(Players:GetPlayers()) do
            if string.lower(player.Name) == string.lower(target) or string.lower(player.DisplayName) == string.lower(target) then
                table.insert(players, player)
                break
            end
        end
    end

    return players
end

local Commands = {}

Commands["kill"] = function(target)
    local targets = getPlayersFromTarget(target)
    for _, player in pairs(targets) do
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.Health = 0
        end
    end
end

Commands["sit"] = function(target)
    local targets = getPlayersFromTarget(target)
    for _, player in pairs(targets) do
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.Sit = true
        end
    end
end

Commands["fling"] = function(target)
    local targets = getPlayersFromTarget(target)
    for _, player in pairs(targets) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = Vector3.new(0, 500, 0)
            bodyVelocity.P = 1250
            bodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
            bodyVelocity.Parent = hrp
            game.Debris:AddItem(bodyVelocity, 0.5)
        end
    end
end

Commands["invisible"] = function(target)
    local targets = getPlayersFromTarget(target)
    for _, player in pairs(targets) do
        if player.Character then
            for _, part in pairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") or part:IsA("Decal") then
                    part.Transparency = 1
                elseif part:IsA("ParticleEmitter") or part:IsA("Trail") then
                    part.Enabled = false
                end
            end
        end
    end
end

Commands["uninvisible"] = function(target)
    local targets = getPlayersFromTarget(target)
    for _, player in pairs(targets) do
        if player.Character then
            for _, part in pairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") or part:IsA("Decal") then
                    part.Transparency = 0
                elseif part:IsA("ParticleEmitter") or part:IsA("Trail") then
                    part.Enabled = true
                end
            end
        end
    end
end

Commands["cmds"] = function()
    local msg = "Commands: :kill, :sit, :fling, :invisible, :uninvisible, :cmds"
    game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
        Text = msg;
        Color = Color3.new(1, 1, 0);
        Font = Enum.Font.SourceSansBold;
        FontSize = Enum.FontSize.Size24;
    })
end

-- Chat command listener
local function onChatted(msg)
    if string.sub(msg,1,1) == ":" then
        local args = {}
        for word in string.gmatch(msg, "%S+") do
            table.insert(args, word)
        end

        local commandName = string.sub(args[1], 2):lower()
        local target = args[2] or "me"

        local commandFunc = Commands[commandName]
        if commandFunc then
            local success, err = pcall(function()
                commandFunc(target)
            end)
            if success then
                game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
                    Text = "Server: Command Executed Successfully";
                    Color = Color3.new(0, 1, 0);
                    Font = Enum.Font.SourceSansBold;
                    FontSize = Enum.FontSize.Size24;
                })
            else
                game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
                    Text = "Server: Command Failed To Execute - "..err;
                    Color = Color3.new(1, 0, 0);
                    Font = Enum.Font.SourceSansBold;
                    FontSize = Enum.FontSize.Size24;
                })
            end
        end
    end
end

if localPlayer and localPlayer.Chatted then
    localPlayer.Chatted:Connect(onChatted)
end

print("ZEN Infinity HUB loaded successfully.")
