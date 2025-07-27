-- ZEN Infinity Script HUB


local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Amethyst Theme colors from Rayfield's default Amethyst theme
local AmethystTheme = {
    Accent = Color3.fromRGB(156, 39, 176),
    WindowBackground = Color3.fromRGB(30, 30, 30),
    TextColor = Color3.fromRGB(230, 230, 230),
    TextBoxBackground = Color3.fromRGB(45, 45, 45),
    OutlineColor = Color3.fromRGB(80, 0, 130),
    DropDownBackground = Color3.fromRGB(40, 0, 60)
}

-- Create Window
local Window = Rayfield:CreateWindow({
    Name = "ZEN Infinity Script HUB",
    LoadingTitle = "Loading ZEN Infinity Script HUB",
    LoadingSubtitle = "by InfiniteMaster",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "ZENInfinityHubConfigs",
        FileName = "ZENInfinityConfig"
    },
    Discord = {
        Enabled = false
    },
    KeySystem = false,
    Theme = AmethystTheme
})

-- Utility functions

-- Send chat message as local player
local function sendChatMessage(msg)
    local success, err = pcall(function()
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
    end)
    if not success then
        warn("Failed to send chat message:", err)
    end
end

-- Send system chat message (server-like)
local function sendSystemMessage(msg, color)
    -- Use StarterGui:SetCore for system chat message if possible
    local StarterGui = game:GetService("StarterGui")
    pcall(function()
        StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = msg,
            Color = color or Color3.fromRGB(156, 39, 176),
            Font = Enum.Font.SourceSansBold,
            FontSize = Enum.FontSize.Size24
        })
    end)
end

-- Print command usage to chat
local function printCommandUsage()
    local cmds = {
        ":sit [all/others/me]",
        ":fling [all/others/me]",
        ":invisible [all/others/me]",
        ":visible [all/others/me]",
        ":kill [all/others/me]",
        ":respawn [all/others/me]",
        ":heal [all/others/me]",
        ":ff [all/others/me]",
        ":unff [all/others/me]",
        ":cmds",
    }
    sendSystemMessage("Available commands:", AmethystTheme.Accent)
    for _, cmd in ipairs(cmds) do
        sendSystemMessage("  " .. cmd, Color3.fromRGB(200, 200, 200))
    end
end

-- Target player selection helper
local function getTargets(targetStr)
    local targets = {}

    if not targetStr or targetStr == "" then
        -- Default to me
        table.insert(targets, LocalPlayer)
    elseif targetStr == "all" then
        for _, p in pairs(Players:GetPlayers()) do
            table.insert(targets, p)
        end
    elseif targetStr == "others" then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                table.insert(targets, p)
            end
        end
    elseif targetStr == "me" then
        table.insert(targets, LocalPlayer)
    else
        -- Try to find by name or partial match
        for _, p in pairs(Players:GetPlayers()) do
            if string.lower(p.Name) == string.lower(targetStr) or string.find(string.lower(p.Name), string.lower(targetStr)) then
                table.insert(targets, p)
            end
        end
        if #targets == 0 then
            sendSystemMessage("No players found matching: " .. targetStr, Color3.new(1,0,0))
        end
    end
    return targets
end

-- Command implementations
local Commands = {}

-- :sit command
function Commands.sit(args)
    local targets = getTargets(args[1])
    for _, player in pairs(targets) do
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.Sit = true
            end
        end
    end
    sendSystemMessage("Server: Command Executed Successfully")
end

-- :fling command
function Commands.fling(args)
    local targets = getTargets(args[1])
    for _, player in pairs(targets) do
        local character = player.Character
        if character then
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if hrp then
                -- Add a BodyVelocity to fling player upwards
                local bv = Instance.new("BodyVelocity")
                bv.Velocity = Vector3.new(0, 100, 0)
                bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
                bv.Parent = hrp
                game.Debris:AddItem(bv, 0.5)
            end
        end
    end
    sendSystemMessage("Server: Command Executed Successfully")
end

-- :invisible command
function Commands.invisible(args)
    local targets = getTargets(args[1])
    for _, player in pairs(targets) do
        local character = player.Character
        if character then
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") or part:IsA("Decal") then
                    part.Transparency = 1
                elseif part:IsA("ParticleEmitter") or part:IsA("Light") then
                    part.Enabled = false
                end
            end
        end
    end
    sendSystemMessage("Server: Command Executed Successfully")
end

-- :visible command
function Commands.visible(args)
    local targets = getTargets(args[1])
    for _, player in pairs(targets) do
        local character = player.Character
        if character then
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") or part:IsA("Decal") then
                    part.Transparency = 0
                elseif part:IsA("ParticleEmitter") or part:IsA("Light") then
                    part.Enabled = true
                end
            end
        end
    end
    sendSystemMessage("Server: Command Executed Successfully")
end

-- :kill command
function Commands.kill(args)
    local targets = getTargets(args[1])
    for _, player in pairs(targets) do
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.Health = 0
            end
        end
    end
    sendSystemMessage("Server: Command Executed Successfully")
end

-- :respawn command
function Commands.respawn(args)
    local targets = getTargets(args[1])
    for _, player in pairs(targets) do
        if player == LocalPlayer then
            player:LoadCharacter()
        else
            -- Remote event to force respawn for other players would be needed, so just skip for others
        end
    end
    sendSystemMessage("Server: Command Executed Successfully (Local Player Only)")
end

-- :heal command
function Commands.heal(args)
    local targets = getTargets(args[1])
    for _, player in pairs(targets) do
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.Health = humanoid.MaxHealth
            end
        end
    end
    sendSystemMessage("Server: Command Executed Successfully")
end

-- :ff command (force field)
function Commands.ff(args)
    local targets = getTargets(args[1])
    for _, player in pairs(targets) do
        local character = player.Character
        if character then
            if not character:FindFirstChildOfClass("ForceField") then
                local ff = Instance.new("ForceField")
                ff.Parent = character
            end
        end
    end
    sendSystemMessage("Server: Command Executed Successfully")
end

-- :unff command (remove force field)
function Commands.unff(args)
    local targets = getTargets(args[1])
    for _, player in pairs(targets) do
        local character = player.Character
        if character then
            local ff = character:FindFirstChildOfClass("ForceField")
            if ff then
                ff:Destroy()
            end
        end
    end
    sendSystemMessage("Server: Command Executed Successfully")
end

-- :cmds command (list commands)
function Commands.cmds(args)
    printCommandUsage()
end

-- Chat command handler
local function onChatted(msg)
    if string.sub(msg,1,1) == ":" then
        local args = {}
        for word in string.gmatch(msg, "%S+") do
            table.insert(args, word)
        end
        local cmd = string.sub(args[1], 2):lower() -- command name without ':'
        table.remove(args, 1)
        if Commands[cmd] then
            local success, err = pcall(function()
                Commands[cmd](args)
            end)
            if not success then
                sendSystemMessage("Server: Command Failed To Execute", Color3.fromRGB(255, 50, 50))
                warn("Command error:", err)
            end
        else
            sendSystemMessage("Unknown command: " .. cmd, Color3.fromRGB(255, 50, 50))
        end
    end
end

-- Connect chat event
LocalPlayer.Chatted:Connect(onChatted)

-- UI Construction

-- Home Tab
local HomeTab = Window:CreateTab("Home")

-- Greeting label
local greetingLabel = HomeTab:CreateLabel("Hi, " .. LocalPlayer.DisplayName .. "!")
-- Two line gap
HomeTab:CreateLabel(" ")
HomeTab:CreateLabel(" ")

-- Commands list label below greeting
local commandsListLabel = HomeTab:CreateLabel("Available commands (type in chat with ':' prefix):")
local cmdsText = [[
:sit [all/others/me]
:fling [all/others/me]
:invisible [all/others/me]
:visible [all/others/me]
:kill [all/others/me]
:respawn [all/others/me]
:heal [all/others/me]
:ff [all/others/me]
:unff [all/others/me]
:cmds
]]
HomeTab:CreateParagraph("Commands", cmdsText)

-- Button to open your YouTube channel
HomeTab:CreateButton({
    Name = "My Youtube Channel",
    Description = "Open InfiniteMaster's YouTube Channel",
    Callback = function()
        local success, err = pcall(function()
            -- Open URL in default browser
            -- Roblox does not allow direct URL opening, but using SetClipboard + Notify as workaround
            setclipboard("https://www.youtube.com/@Infinite_Original")
            sendSystemMessage("YouTube channel link copied to clipboard!", AmethystTheme.Accent)
        end)
        if not success then
            sendSystemMessage("Failed to copy YouTube link to clipboard.", Color3.new(1,0,0))
        end
    end
})

-- Player Tab
local PlayerTab = Window:CreateTab("Player", 4483362458)
local Divider = PlayerTab:CreateDivider()

local Slider = PlayerTab:CreateSlider({
    Name = "WalkSpeed",
    Min = 16,
    Max = 250,
    Default = 16,
    Increment = 1,
    Suffix = " speed",
    Flag = "WalkSpeed",
    Callback = function(value)
        local character = Players.LocalPlayer.Character
        local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = value
        end
    end,
})

 local Slider = PlayerTab:CreateSlider({
    Name = "Jump Height",
    Range = {0, 100000},
    Increment = 1,
    Suffix = "Height",
    CurrentValue = 0,
    Flag = "Slider2", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
     game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
    end,
 })

-- Addidional Scripts Tab
local Addidional_Scripts = Window:CreateTab("Addidional Scripts")
local Divider = Addidional_Scripts:CreateDivider()

-- Trolling Tab
local TrollingTab = Window:CreateTab("Trolling")
local Divider = TrollingTab:CreateDivider()

TrollingTab:CreateButton({
    Name = "Super Ring Parts By V6 lukas",
    Callback = function()
        local character = LocalPlayer.Character
        if not character then
            sendSystemMessage("Character not loaded.", Color3.new(1,0,0))
            return
        end
        sendSystemMessage("Super Ring Parts By V6 lukas", AmethystTheme.Accent)
    end
})

-- You can add more tabs/buttons below as needed

-- Finalize and notify user
sendSystemMessage("ZEN Infinity Script HUB loaded successfully! Type :cmds for commands list.", AmethystTheme.Accent)


