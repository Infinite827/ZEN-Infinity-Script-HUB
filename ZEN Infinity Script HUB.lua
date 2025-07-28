-- ZEN Infinity Script HUB - Infinite
-- Theme: Amethyst

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")

local DisplayName = LocalPlayer.DisplayName or LocalPlayer.Name

Rayfield:Notify({
    Title = "Hi, " .. DisplayName,
    Content = "Loading ZEN Infinity Script HUB...",
    Duration = 2.5,
    Image = 4483362458,
})

-- Helper functions --

local function sendChat(msg, color)
    StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = msg,
        Color = color or Color3.new(1, 1, 1),
        Font = Enum.Font.SourceSansBold,
        FontSize = Enum.FontSize.Size24
    })
end

local function getCharacterParts(player)
    local char = player.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        return humanoid, root, char
    end
    return nil, nil, nil
end

local function GetPlayersFromTarget(target)
    target = target:lower()
    local allPlayers = Players:GetPlayers()

    if target == "me" then
        return {LocalPlayer}
    elseif target == "all" then
        return allPlayers
    elseif target == "others" then
        local others = {}
        for _, p in ipairs(allPlayers) do
            if p ~= LocalPlayer then
                table.insert(others, p)
            end
        end
        return others
    else
        for _, p in ipairs(allPlayers) do
            if p.Name:lower() == target or p.DisplayName:lower() == target then
                return {p}
            end
        end

        local matchedPlayers = {}
        for _, p in ipairs(allPlayers) do
            if p.Name:lower():find(target, 1, true) or p.DisplayName:lower():find(target, 1, true) then
                table.insert(matchedPlayers, p)
            end
        end
        if #matchedPlayers > 0 then
            return matchedPlayers
        end
    end
    return {}
end

-- Command list for :cmds
local commandList = {
    ":fly [target]",
    ":unfly [target]",
    ":spin [target]",
    ":unspin [target]",
    ":jump [target]",
    ":kill [target]",
    ":invisible [target]",
    ":uninvisible [target]",
    ":sit [target]",
    ":unsit [target]",
    ":fling [target]",
    ":noclip",
    ":unnoclip",
    ":esp",
    ":unesp",
    ":speedburst",
    ":godmode [target]",
    ":ungodmode [target]",
    ":cmds",
    ":uncommands"
}

-- Command management
local activeCommands = {}
for _, cmd in ipairs(commandList) do
    local cmdName = cmd:match("^:(%w+)")
    if cmdName then
        activeCommands[cmdName] = true
    end
end

local function addCommand(cmd)
    activeCommands[cmd] = true
end

local function removeCommand(cmd)
    activeCommands[cmd] = nil
end

-- Noclip Implementation
local noclipEnabled = false
local noclipConnection

local function setNoclip(enabled)
    noclipEnabled = enabled
    if enabled then
        Rayfield:Notify({Title = "Noclip", Content = "Enabled", Duration = 2})
        if noclipConnection then noclipConnection:Disconnect() end
        noclipConnection = RunService.Stepped:Connect(function()
            if noclipEnabled and LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetChildren()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        if LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
        Rayfield:Notify({Title = "Noclip", Content = "Disabled", Duration = 2})
    end
end

-- ESP Implementation
local espEnabled = false
local espHighlights = {}
local espNameTags = {}
local playerTagsVisible = true

local function createHighlightForPlayer(player)
    local char = player.Character
    if not char then return nil end

    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(0, 255, 0)
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color3.new(1,1,1)
    highlight.OutlineTransparency = 0
    highlight.Adornee = char
    highlight.Parent = Workspace

    return highlight
end

local function createNameTagForPlayer(player)
    local char = player.Character
    if not char then return nil end
    local head = char:FindFirstChild("Head")
    if not head then return nil end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ZENNameTag"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 100, 0, 30)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = head

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1,0,1,0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = player.Name
    textLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    textLabel.TextStrokeColor3 = Color3.new(1,1,1)
    textLabel.TextStrokeTransparency = 0
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextScaled = true
    textLabel.Parent = billboard

    return billboard
end

local function toggleESP(enabled)
    espEnabled = enabled
    if not espEnabled then
        for player, highlight in pairs(espHighlights) do
            if highlight and highlight.Parent then
                highlight:Destroy()
            end
        end
        espHighlights = {}

        for player, tag in pairs(espNameTags) do
            if tag and tag.Parent then
                tag:Destroy()
            end
        end
        espNameTags = {}
        Rayfield:Notify({Title = "ESP", Content = "Disabled", Duration = 2})
    else
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local char = player.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    if not espHighlights[player] then
                        espHighlights[player] = createHighlightForPlayer(player)
                    end
                    if playerTagsVisible and not espNameTags[player] then
                        espNameTags[player] = createNameTagForPlayer(player)
                    end
                end
            end
        end
        Rayfield:Notify({Title = "ESP", Content = "Enabled", Duration = 2})
    end
end

local function togglePlayerTags(show)
    playerTagsVisible = show
    if not espEnabled then return end
    if show then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                if not espNameTags[player] and player.Character and player.Character:FindFirstChild("Head") then
                    espNameTags[player] = createNameTagForPlayer(player)
                end
            end
        end
    else
        for player, tag in pairs(espNameTags) do
            if tag and tag.Parent then
                tag:Destroy()
            end
        end
        espNameTags = {}
    end
end

Players.PlayerAdded:Connect(function(player)
    if espEnabled then
        task.wait(1)
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            espHighlights[player] = createHighlightForPlayer(player)
            if playerTagsVisible then
                espNameTags[player] = createNameTagForPlayer(player)
            end
        end
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if espHighlights[player] then
        espHighlights[player]:Destroy()
        espHighlights[player] = nil
    end
    if espNameTags[player] then
        espNameTags[player]:Destroy()
        espNameTags[player] = nil
    end
end)

-- RGB Body Shader Implementation
local rgbShaderEnabled = false
local rgbShaderConnection

local function toggleRGBShader(enabled)
    rgbShaderEnabled = enabled
    local function updateColor()
        if not rgbShaderEnabled or not LocalPlayer.Character then
            if LocalPlayer.Character then
                for _, part in ipairs(LocalPlayer.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.Color = Color3.new(1,1,1)
                    end
                end
            end
            return
        end
        local color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
        if LocalPlayer.Character then
            for _, part in ipairs(LocalPlayer.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Color = color
                end
            end
        end
    end

    if enabled then
        if rgbShaderConnection then rgbShaderConnection:Disconnect() end
        rgbShaderConnection = RunService.Heartbeat:Connect(updateColor)
    else
        if rgbShaderConnection then
            rgbShaderConnection:Disconnect()
            rgbShaderConnection = nil
        end
        -- Reset colors to white
        updateColor()
    end
end

-- Speed Burst Implementation
local speedBurstActive = false
local speedBurstCooldown = false
local speedBurstDuration = 3 -- seconds
local speedBurstCooldownTime = 10 -- seconds

local function speedBurst()
    if speedBurstCooldown then
        Rayfield:Notify({Title = "Speed Burst", Content = "On cooldown!", Duration = 2})
        return
    end
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        Rayfield:Notify({Title = "Speed Burst", Content = "No humanoid found!", Duration = 2})
        return
    end

    speedBurstCooldown = true
    local originalSpeed = humanoid.WalkSpeed
    humanoid.WalkSpeed = originalSpeed * 3
    Rayfield:Notify({Title = "Speed Burst", Content = "Activated!", Duration = speedBurstDuration})

    task.delay(speedBurstDuration, function()
        if humanoid then
            humanoid.WalkSpeed = originalSpeed
        end
    end)

    task.delay(speedBurstCooldownTime, function()
        speedBurstCooldown = false
        Rayfield:Notify({Title = "Speed Burst", Content = "Cooldown ended!", Duration = 2})
    end)
end

-- Godmode tracking table
local godmodePlayers = {}

local function setGodmode(player, enabled)
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        if enabled then
            godmodePlayers[player] = true
            humanoid.HealthChanged:Connect(function()
                if godmodePlayers[player] and humanoid.Health < humanoid.MaxHealth then
                    humanoid.Health = humanoid.MaxHealth
                end
            end)
            humanoid.MaxHealth = math.huge
            humanoid.Health = humanoid.MaxHealth
            if player == LocalPlayer then
                Rayfield:Notify({Title = "Godmode", Content = "Enabled for you", Duration = 3})
            end
        else
            godmodePlayers[player] = nil
            humanoid.MaxHealth = 100
            humanoid.Health = humanoid.MaxHealth
            if player == LocalPlayer then
                Rayfield:Notify({Title = "Godmode", Content = "Disabled for you", Duration = 3})
            end
        end
    end
end

-- Command Execution Logic
local function executeCommand(command, args)
    local targetArg = args[1] or "me"
    local targets = GetPlayersFromTarget(targetArg)
    if #targets == 0 then
        sendChat("Server: No players found for target '" .. targetArg .. "'", Color3.new(1, 0, 0))
        return
    end

    for _, targetPlayer in ipairs(targets) do
        local humanoid, root, char = getCharacterParts(targetPlayer)
        if command == "fly" then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
        elseif command == "unfly" then
            if humanoid then
                humanoid.PlatformStand = false
            end
        elseif command == "spin" then
            if root and not root:FindFirstChild("_spin") then
                local spin = Instance.new("BodyAngularVelocity")
                spin.AngularVelocity = Vector3.new(0, 10, 0)
                spin.MaxTorque = Vector3.new(0, math.huge, 0)
                spin.Name = "_spin"
                spin.Parent = root
            end
        elseif command == "unspin" then
            if root and root:FindFirstChild("_spin") then
                root._spin:Destroy()
            end
        elseif command == "jump" then
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        elseif command == "kill" then
            if char then
                char:BreakJoints()
            end
        elseif command == "sit" then
            if humanoid then
                humanoid.Sit = true
            end
        elseif command == "unsit" then
            if humanoid then
                humanoid.Sit = false
            end
        elseif command == "invisible" then
            if char then
                for _, part in pairs(char:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.Transparency = 1
                    elseif part:IsA("Decal") then
                        part.Transparency = 1
                    elseif part:IsA("Accessory") then
                        for _, p in pairs(part:GetChildren()) do
                            if p:IsA("BasePart") then
                                p.Transparency = 1
                            end
                        end
                    end
                end
            end
        elseif command == "uninvisible" then
            if char then
                for _, part in pairs(char:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.Transparency = 0
                    elseif part:IsA("Decal") then
                        part.Transparency = 0
                    elseif part:IsA("Accessory") then
                        for _, p in pairs(part:GetChildren()) do
                            if p:IsA("BasePart") then
                                p.Transparency = 0
                            end
                        end
                    end
                end
            end
        elseif command == "fling" then
            if root then
                local flingBall = Instance.new("Part")
                flingBall.Size = Vector3.new(5,5,5)
                flingBall.Transparency = 1
                flingBall.Anchored = false
                flingBall.CanCollide = false
                flingBall.CFrame = root.CFrame
                flingBall.Parent = Workspace

                local bv = Instance.new("BodyVelocity")
                bv.Velocity = Vector3.new(0, 1000, 0)
                bv.MaxForce = Vector3.new(999999, 999999, 999999)
                bv.Parent = flingBall

                Debris:AddItem(flingBall, 3)
            end
        elseif command == "noclip" then
            setNoclip(true)
        elseif command == "unnoclip" then
            setNoclip(false)
        elseif command == "esp" then
            toggleESP(true)
        elseif command == "unesp" then
            toggleESP(false)
        elseif command == "speedburst" then
            speedBurst()
        elseif command == "godmode" then
            setGodmode(targetPlayer, true)
        elseif command == "ungodmode" then
            setGodmode(targetPlayer, false)
        else
            sendChat("Server: Unknown command '" .. command .. "'", Color3.new(1, 0, 0))
        end
    end
end

-- Chat Command Handling --

LocalPlayer.Chatted:Connect(function(msg)
    if not msg:match("^:") then return end
    local args = msg:sub(2):split(" ")
    local cmd = args[1]:lower()
    table.remove(args, 1)

    if not activeCommands[cmd] and cmd ~= "cmds" and cmd ~= "uncommands" then
        sendChat("Server: Command '" .. cmd .. "' is not active.", Color3.new(1, 0, 0))
        return
    end

    if cmd == "cmds" then
        local commandsString = table.concat(commandList, ", ")
        sendChat("Server: Commands: " .. commandsString, Color3.new(0, 1, 0))
        return
    elseif cmd == "uncommands" then
        if #args == 0 then
            sendChat("Server: Usage: :uncommands [command]", Color3.new(1, 0, 0))
            return
        end
        local toRemove = args[1]:lower()
        if activeCommands[toRemove] then
            removeCommand(toRemove)
            sendChat("Server: Command '" .. toRemove .. "' removed.", Color3.new(0, 1, 0))
        else
            sendChat("Server: Command '" .. toRemove .. "' not found.", Color3.new(1, 0, 0))
        end
        return
    end

    local success, err = pcall(function()
        executeCommand(cmd, args)
    end)

    if success then
        sendChat("Server: Command Executed Successfully", Color3.new(0, 1, 0))
    else
        sendChat("Server: Command Failed To Execute - " .. tostring(err), Color3.new(1, 0, 0))
    end
end)

-- UI Setup --

local Window = Rayfield:CreateWindow({
    Name = "ZEN Infinity Script HUB",
    LoadingTitle = "ZEN Infinity",
    LoadingSubtitle = "by InfiniteOriginal",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "ZENInfinityConfig"
    },
    Discord = {
        Enabled = false
    },
    KeySystem = false
})

-- HOME TAB --

local Home_Tab = Window:CreateTab("Home", 4483362458)
local Home_Paragraph = Home_Tab:CreateParagraph({
    Title = "Welcome to ZEN Infinity Script HUB",
    Content = [[
ZEN Infinity Script HUB is the ultimate tool for chaos, laughs, and creative trolling in Roblox.
Packed with powerful scripts, funny mods, and unpredictable effects, ZEN Infinity lets you bend the rules and mess with games in hilarious ways.
From flying chairs to fake admin commands, it's all about having fun and confusing everyone around you.
Easy to use, constantly updated, and loaded with trolling tools—ZEN Infinity is where the madness begins.

Type :cmds in chat to view commands.
    ]]
})

Home_Tab:CreateButton({
    Name = "My Youtube Channel",
    Callback = function()
        local url = "https://www.youtube.com/@Infinite_Original"
        -- Roblox does not allow direct open in client, but we can use SetClipboard and notify user
        setclipboard(url)
        Rayfield:Notify({
            Title = "Link Copied",
            Content = "YouTube Channel URL copied to clipboard!",
            Duration = 3
        })
    end
})

-- PLAYER TAB --

local Player_Tab = Window:CreateTab("Player")

local WalkSpeedSlider = Player_Tab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 500},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(value)
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = value
        end
    end,
})

local HealthSlider = Player_Tab:CreateSlider({
    Name = "Health",
    Range = {1, 1000000},
    Increment = 1,
    Suffix = "HP",
    CurrentValue = 100,
    Flag = "Health",
    Callback = function(value)
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.MaxHealth = value
            humanoid.Health = value
        end
    end,
})

local GodmodeToggle = Player_Tab:CreateToggle({
    Name = "Godmode",
    CurrentValue = false,
    Flag = "Godmode",
    Callback = function(value)
        setGodmode(LocalPlayer, value)
    end
})

-- GAME SCRIPTS TAB --

local GameScripts_Tab = Window:CreateTab("Game Scripts")

GameScripts_Tab:CreateButton({
    Name = "Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
    end
})

GameScripts_Tab:CreateButton({
    Name = "Dex Explorer",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/ExploitGuys/Dex/master/source'))()
    end
})

GameScripts_Tab:CreateButton({
    Name = "CMD-X",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/CMD-X/CMD-X/master/Source'))()
    end
})

-- ADDITIONAL SCRIPTS TAB --

local AdditionalScripts_Tab = Window:CreateTab("Additional Scripts")

AdditionalScripts_Tab:CreateButton({
    Name = "Jailbreak GUI",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/regularvynixu/Jailbreak/main/Jailbreak.lua"))()
    end
})

AdditionalScripts_Tab:CreateButton({
    Name = "Arsenal GUI",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ArsenalGui/Arsenal/main/Arsenal.lua"))()
    end
})

AdditionalScripts_Tab:CreateButton({
    Name = "Prison Life GUI",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/NigelNakz/PrisonLife/main/PrisonLife.lua"))()
    end
})

-- TROLLING TAB --

local Trolling_Tab = Window:CreateTab("Trolling")

Trolling_Tab:CreateButton({
    Name = "Solara Sword",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/solarasword", true))()
    end
})

Trolling_Tab:CreateButton({
    Name = "Jerk Off Tool",
    Callback = function()
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.RigType == Enum.HumanoidRigType.R15 then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Infinite827/R15_JerkOffTool/main/main.lua"))()
        else
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Infinite827/R6_JerkOffTool/main/main.lua"))()
        end
    end
})

-- CHAT TOOLS TAB --

local ChatTools_Tab = Window:CreateTab("Chat Tools")

ChatTools_Tab:CreateButton({
    Name = "Clear Chat",
    Callback = function()
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
        task.wait(0.1)
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
    end
})

-- VISUAL & FX TAB --

local VisualFX_Tab = Window:CreateTab("Visual & FX")

VisualFX_Tab:CreateToggle({
    Name = "RGB Body Shader",
    CurrentValue = false,
    Flag = "RGBShader",
    Callback = toggleRGBShader
})

VisualFX_Tab:CreateToggle({
    Name = "ESP",
    CurrentValue = false,
    Flag = "ESP",
    Callback = toggleESP
})

VisualFX_Tab:CreateButton({
    Name = "Speed Burst",
    Callback = speedBurst
})

-- UTILITIES TAB --

local Utilities_Tab = Window:CreateTab("Utilities")

Utilities_Tab:CreateToggle({
    Name = "Show Player Name Tags",
    CurrentValue = true,
    Flag = "PlayerNameTags",
    Callback = togglePlayerTags
})

-- SETTINGS TAB --

local Settings_Tab = Window:CreateTab("Settings")

Settings_Tab:CreateDropdown({
    Name = "Theme",
    Options = {"Default - Default
Amber Glow - AmberGlow
Amethyst - Amethyst
Bloom - Bloom
Dark Blue - DarkBlue
Green - Green
Light - Light
Ocean - Ocean
Serenity - Serenity"},
    CurrentOption = "Amethyst",
    Flag = "Theme",
    Callback = function(theme)
        loadstring(game:HttpGet('https://sirius.menu/rayfield'))() -- reload UI, you can enhance to reapply all your scripts on theme change
    end
})

-- Final notification
Rayfield:Notify({
    Title = "ZEN Infinity Script HUB",
    Content = "Loaded successfully! Type :cmds in chat to see commands.",
    Duration = 4,
})

