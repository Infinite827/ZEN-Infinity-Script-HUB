-- ZEN Infinity Script HUB
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

-- Helper Functions --

-- Get the humanoid and root part safely
local function getCharacterParts(player)
    local char = player.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        return humanoid, root, char
    end
    return nil, nil, nil
end

-- Noclip Implementation
local noclipEnabled = false
local function setNoclip(enabled)
    noclipEnabled = enabled
    if noclipEnabled then
        Rayfield:Notify({Title = "Noclip", Content = "Enabled", Duration = 2})
        -- Start noclip loop
        RunService.Stepped:Connect(function()
            if noclipEnabled and LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetChildren()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        -- Re-enable collisions
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
local espBoxes = {}
local function createESPBox(player)
    local box = Drawing.new("Square")
    box.Color = Color3.new(1, 0, 0)
    box.Thickness = 2
    box.Filled = false
    box.Transparency = 1
    return box
end

local espEnabled = false
local function toggleESP(enabled)
    espEnabled = enabled
    if not espEnabled then
        -- Remove all ESP boxes
        for _, box in pairs(espBoxes) do
            box:Remove()
        end
        espBoxes = {}
        Rayfield:Notify({Title = "ESP", Content = "Disabled", Duration = 2})
    else
        -- Create ESP boxes for all players except local
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                if not espBoxes[player] then
                    espBoxes[player] = createESPBox(player)
                end
            end
        end
        Rayfield:Notify({Title = "ESP", Content = "Enabled", Duration = 2})
    end
end

-- Update ESP boxes every frame
RunService.RenderStepped:Connect(function()
    if not espEnabled then return end
    local camera = Workspace.CurrentCamera
    for player, box in pairs(espBoxes) do
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local root = char.HumanoidRootPart
            local pos, onScreen = camera:WorldToViewportPoint(root.Position)
            if onScreen then
                local size = Vector3.new(4, 6, 1) -- Approximate size
                local topLeft = camera:WorldToViewportPoint(root.Position + Vector3.new(-size.X/2, size.Y/2, 0))
                local bottomRight = camera:WorldToViewportPoint(root.Position + Vector3.new(size.X/2, -size.Y/2, 0))
                box.Position = Vector2.new(topLeft.X, topLeft.Y)
                box.Size = Vector2.new(bottomRight.X - topLeft.X, bottomRight.Y - topLeft.Y)
                box.Visible = true
            else
                box.Visible = false
            end
        else
            if box then
                box.Visible = false
            end
        end
    end
end)

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
    Content = "Welcome to ZEN Infinity Script HUB! Use tabs to explore features."
})

Home_Tab:CreateButton({
    Name = "My Youtube Channel",
    Callback = function()
        setclipboard("https://www.youtube.com/@Infinite_Original")
        Rayfield:Notify({Title = "YouTube Channel", Content = "Link copied to clipboard!", Duration = 3})
    end
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

Player_Tab:CreateButton({
    Name = "Speed Burst",
    Callback = function()
        speedBurst()
    end
})

-- Visual & FX Tab --
local VisualFX_Tab = Window:CreateTab("Visual & FX", 4483362458)
-- Placeholder for other toggles

-- Chat Tools Tab --
local ChatTools_Tab = Window:CreateTab("Chat Tools", 4483362458)
-- Placeholder for chat tools buttons

-- Utilities Tab --
local Utilities_Tab = Window:CreateTab("Utilities", 4483362458)

Utilities_Tab:CreateToggle({
    Name = "ESP",
    CurrentValue = false,
    Callback = function(value)
        toggleESP(value)
    end
})

Utilities_Tab:CreateButton({
    Name = "Copy Game ID",
    Callback = function()
        setclipboard(tostring(game.PlaceId))
        Rayfield:Notify({Title = "Game ID", Content = "Copied to clipboard!", Duration = 3})
    end
})

-- Trolling Tab --
local Trolling_Tab = Window:CreateTab("Trolling", 4483362458)
-- Placeholder for trolling features

-- Chat Command Handler (basic) --

LocalPlayer.Chatted:Connect(function(msg)
    if not msg:match("^:") then return end
    local args = msg:sub(2):split(" ")
    local cmd = args[1]:lower()
    table.remove(args, 1)

    local success, err = pcall(function()
        if cmd == "fly" then
            -- Fly code placeholder
            Rayfield:Notify({Title="Command", Content="Fly command not implemented yet", Duration=3})
        elseif cmd == "noclip" then
            setNoclip(true)
        elseif cmd == "unnoclip" then
            setNoclip(false)
        elseif cmd == "esp" then
            toggleESP(true)
        elseif cmd == "unesp" then
            toggleESP(false)
        elseif cmd == "speedburst" then
            speedBurst()
        else
            Rayfield:Notify({Title="Unknown Command", Content="'"..cmd.."' is not recognized.", Duration=3})
        end
    end)

    if success then
        sendChat("Server: Command Executed Successfully", Color3.new(0, 1, 0))
    else
        sendChat("Server: Command Failed To Execute\n".. tostring(err), Color3.new(1, 0, 0))
    end
end)

-- Utility function to send chat messages
function sendChat(msg, color)
    StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = msg,
        Color = color or Color3.new(1,1,1),
        Font = Enum.Font.SourceSansBold,
        FontSize = Enum.FontSize.Size24
    })
end

Rayfield:Notify({
    Title = "ZEN Infinity Script HUB",
    Content = "Loaded successfully!",
    Duration = 4
})
