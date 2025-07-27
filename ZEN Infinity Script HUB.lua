-- ZEN Infinity Script HUB - Infinite
-- Theme: Amethyst

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
        sendChat("Server: Command Failed To Execute\n" .. tostring(err), Color3.new(1, 0, 0))
    end
end)

-- UI Setup --

local Window = Rayfield:CreateWindow({
    Name = "ZEN Infinity Script HUB",
    Icon = 4483362458,
    LoadingTitle = "ZEN Infinity Script HUB",
    LoadingSubtitle = "By InfiniteMaster",
    Theme = "Amethyst",
    ToggleUIKeybind = "K",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "ZEN Infinity Config"
    }
})

-- Home Tab --
local Home_Tab = Window:CreateTab("Home", 4483362458)
Home_Tab:CreateLabel("Hi, " .. DisplayName)
Home_Tab:CreateParagraph({
    Title = "Welcome",
    Content = "ZEN Infinity Script Hub is the ultimate tool for chaos, laughs, and creative trolling in Roblox. Packed with powerful scripts, funny mods, and unpredictable effects, ZEN Infinity lets you bend the rules and mess with games in hilarious ways. From flying chairs to fake admin commands, it's all about having fun and confusing everyone around you. Easy to use, constantly updated, and loaded with trolling tools—ZEN Infinity is where the madness begins."
})

Home_Tab:CreateButton({
    Name = "My Youtube Channel",
    Callback = function()
        setclipboard("https://www.youtube.com/@Infinite_Original")
        Rayfield:Notify({Title = "YouTube Channel", Content = "Link copied to clipboard!", Duration = 3})
    end
})

Home_Tab:CreateParagraph({
    Title = "Commands",
    Content = table.concat(commandList, ", "),
})

-- Player Tab --
local Player_Tab = Window:CreateTab("Player", 4483362458)

Player_Tab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Callback = function(value)
        setNoclip(value)
    end
})

Player_Tab:CreateSlider({
    Name = "WalkSpeed",
    Min = 8,
    Max = 500,
    Increment = 1,
    Suffix = " walkspeed",
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(value)
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = value
        end
    end
})

Player_Tab:CreateSlider({
    Name = "JumpPower",
    Min = 30,
    Max = 300,
    Increment = 1,
    Suffix = " jump power",
    CurrentValue = 50,
    Flag = "JumpPower",
    Callback = function(value)
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.JumpPower = value
        end
    end
})

Player_Tab:CreateSlider({
    Name = "Health",
    Min = 0,
    Max = 500,
    Increment = 1,
    Suffix = " HP",
    CurrentValue = 100,
    Flag = "Health",
    Callback = function(value)
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.MaxHealth = value
            humanoid.Health = value
        end
    end
})

Player_Tab:CreateButton({
    Name = "Speed Burst",
    Callback = function()
        speedBurst()
    end
})

-- Visual & FX Tab --
local VisualFX_Tab = Window:CreateTab("Visual & FX", 4483362458)

VisualFX_Tab:CreateToggle({
    Name = "RGB Body Shader",
    CurrentValue = false,
    Callback = function(value)
        toggleRGBShader(value)
    end
})

VisualFX_Tab:CreateToggle({
    Name = "Galaxy Aura",
    CurrentValue = false,
    Callback = function(value)
        -- Placeholder: Implement Galaxy Aura effect
        if value then
            Rayfield:Notify({Title="Visual & FX", Content="Galaxy Aura Enabled (not implemented)", Duration=2})
        else
            Rayfield:Notify({Title="Visual & FX", Content="Galaxy Aura Disabled", Duration=2})
        end
    end
})

VisualFX_Tab:CreateToggle({
    Name = "Glitchify Character",
    CurrentValue = false,
    Callback = function(value)
        -- Placeholder: Implement glitch effect
        if value then
            Rayfield:Notify({Title="Visual & FX", Content="Glitchify Enabled (not implemented)", Duration=2})
        else
            Rayfield:Notify({Title="Visual & FX", Content="Glitchify Disabled", Duration=2})
        end
    end
})

VisualFX_Tab:CreateToggle({
    Name = "Head Flames",
    CurrentValue = false,
    Callback = function(value)
        -- Placeholder: Implement head flames effect
        if value then
            Rayfield:Notify({Title="Visual & FX", Content="Head Flames Enabled (not implemented)", Duration=2})
        else
            Rayfield:Notify({Title="Visual & FX", Content="Head Flames Disabled", Duration=2})
        end
    end
})

VisualFX_Tab:CreateToggle({
    Name = "Particle Trails",
    CurrentValue = false,
    Callback = function(value)
        -- Placeholder: Implement particle trails
        if value then
            Rayfield:Notify({Title="Visual & FX", Content="Particle Trails Enabled (not implemented)", Duration=2})
        else
            Rayfield:Notify({Title="Visual & FX", Content="Particle Trails Disabled", Duration=2})
        end
    end
})

-- Chat Tools Tab --
local ChatTools_Tab = Window:CreateTab("Chat Tools", 4483362458)

ChatTools_Tab:CreateButton({
    Name = "Annoy Bot (Spam Target)",
    Callback = function()
        Rayfield:Notify({Title="Chat Tools", Content="Annoy Bot not implemented", Duration=2})
    end
})

ChatTools_Tab:CreateButton({
    Name = "Spam Emoji Rain",
    Callback = function()
        Rayfield:Notify({Title="Chat Tools", Content="Spam Emoji Rain not implemented", Duration=2})
    end
})

ChatTools_Tab:CreateButton({
    Name = "Chat Translator",
    Callback = function()
        Rayfield:Notify({Title="Chat Tools", Content="Chat Translator not implemented", Duration=2})
    end
})

ChatTools_Tab:CreateButton({
    Name = "Name Spoofer",
    Callback = function()
        Rayfield:Notify({Title="Chat Tools", Content="Name Spoofer not implemented", Duration=2})
    end
})

-- Utilities Tab --
local Utilities_Tab = Window:CreateTab("Utilities", 4483362458)

Utilities_Tab:CreateToggle({
    Name = "ESP",
    CurrentValue = false,
    Callback = function(value)
        toggleESP(value)
    end
})

Utilities_Tab:CreateToggle({
    Name = "Player Name Tags",
    CurrentValue = true,
    Callback = function(value)
        togglePlayerTags(value)
    end
})

Utilities_Tab:CreateButton({
    Name = "Copy Game ID",
    Callback = function()
        setclipboard(tostring(game.PlaceId))
        Rayfield:Notify({Title = "Game ID", Content = "Copied to clipboard!", Duration = 3})
    end
})

Utilities_Tab:CreateToggle({
    Name = "Invisible Mode",
    CurrentValue = false,
    Callback = function(value)
        local humanoid, root, char = getCharacterParts(LocalPlayer)
        if not char then return end
        if value then
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
        else
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
    end
})

Utilities_Tab:CreateToggle({
    Name = "Lag Switch (Fake)",
    CurrentValue = false,
    Callback = function(value)
        if value then
            Rayfield:Notify({Title="Utilities", Content="Lag Switch Enabled (fake only)", Duration=2})
        else
            Rayfield:Notify({Title="Utilities", Content="Lag Switch Disabled", Duration=2})
        end
    end
})

Utilities_Tab:CreateToggle({
    Name = "Auto Rejoin",
    CurrentValue = false,
    Flag = "AutoRejoin",
})

-- Game Scripts Tab --
local Game_Scripts = Window:CreateTab("Game Scripts", 4483362458)
Game_Scripts:CreateDivider()

Game_Scripts:CreateButton({
    Name = "Natural Disaster Survival",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/hyperionhax/c00lgui/refs/heads/main/CoolGui.lua"))()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/M-E-N-A-C-E/Menace-Hub/refs/heads/main/Free%20Sus%20Missile", true))()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/synnyyy/synergy/additional/betterbypasser", true))()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Natural-Disaster-Survival-Katers-NDS-Hub-19533"))()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-InfYeiod-reupload-27320"))()
    end,
})

Game_Scripts:CreateButton({
    Name = "Doors",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Robloxexploiterz/Release-Lolhax/refs/heads/main/LX%20Doors%20v3.lua"))()
    end,
})

Game_Scripts:CreateButton({
    Name = "Roleplay Script",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/hyperionhax/c00lgui/refs/heads/main/CoolGui.lua"))()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/M-E-N-A-C-E/Menace-Hub/refs/heads/main/Free%20Sus%20Missile", true))()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/synnyyy/synergy/additional/betterbypasser", true))()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-InfYeiod-reupload-27320"))()
    end,
})

-- Additional Scripts Tab --
local Additional_Scripts = Window:CreateTab("Additional Scripts", 4483362458)
Additional_Scripts:CreateDivider()

Additional_Scripts:CreateButton({
    Name = "Chat Bypasser (KEY SYSTEM - set language Ka3ak Tini)",
    Callback = function()
        loadstring(game:HttpGet("https://github.com/Synergy-Networks/products/raw/main/BetterBypasser/loader.lua"))()
    end,
})

Additional_Scripts:CreateButton({
    Name = "C00lkidd Gui V3",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/hyperionhax/c00lgui/refs/heads/main/CoolGui.lua"))()
    end,
})

Additional_Scripts:CreateButton({
    Name = "Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-InfYeiod-reupload-27320"))()
    end,
})

Additional_Scripts:CreateButton({
    Name = "Menace Hub (my friend's hub)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/M-E-N-A-C-E/Menace-Hub/refs/heads/main/Free%20Sus%20Missile", true))()
    end,
})

Additional_Scripts:CreateButton({
    Name = "Fly Gui V3",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
    end,
})

-- Trolling Tab --
local Trolling_Tab = Window:CreateTab("Trolling", 4483362458)
Trolling_Tab:CreateDivider()

Trolling_Tab:CreateButton({
    Name = "Jerk Off Tool (Universal)",
    Callback = function()
        local character = LocalPlayer.Character
        if not character then return end
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            if humanoid.RigType == Enum.HumanoidRigType.R15 then
                loadstring(game:HttpGet("https://pastefy.app/YZoglOyJ/raw"))()
            else
                loadstring(game:HttpGet("https://pastefy.app/wa3v2Vgm/raw"))()
            end
        end
    end,
})

-- Settings Tab --
local Settings_Tab = Window:CreateTab("Zen Settings", 4483362458)

Settings_Tab:CreateDropdown({
    Name = "Theme Selector",
    Options = {"Amethyst", "Dark", "Neon"},
    CurrentOption = "Amethyst",
    Flag = "ThemeSelector",
    Callback = function(option)
        Rayfield:Notify({Title="Settings", Content="Theme changed to "..option..". Restart UI to apply.", Duration=3})
    end
})

Settings_Tab:CreateKeybind({
    Name = "Toggle UI Keybind",
    CurrentKeybind = "K",
    HoldToInteract = false,
    Flag = "ToggleKeybind",
    Callback = function(key)
        Rayfield:Notify({Title="Settings", Content="Toggle UI keybind changed to "..key, Duration=3})
    end
})

Settings_Tab:CreateToggle({
    Name = "Safe Mode (Disable troll features temporarily)",
    CurrentValue = false,
    Flag = "SafeMode",
})

Settings_Tab:CreateButton({
    Name = "Check for Updates",
    Callback = function()
        Rayfield:Notify({Title="Settings", Content="Update checker not implemented", Duration=3})
    end
})

Settings_Tab:CreateParagraph({
    Title = "Credits",
    Content = "Script by InfiniteMaster\nDiscord: (your discord)\nYouTube: https://www.youtube.com/@Infinite_Original"
})

-- Final notify
Rayfield:Notify({
    Title = "ZEN Infinity Script HUB",
    Content = "Loaded successfully! Use :cmds for command list.",
    Duration = 5,
})

-- Auto Rejoin Feature
if Rayfield.Flags.AutoRejoin then
    LocalPlayer.OnTeleport:Connect(function()
        local TeleportService = game:GetService("TeleportService")
        TeleportService:Teleport(game.PlaceId)
    end)
end




