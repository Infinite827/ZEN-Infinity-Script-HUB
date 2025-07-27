-- ZEN Infinity Script HUB (sry if i took too long to fix it)

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")

-- Load Rayfield UI (Amethyst Theme)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "ZEN Infinity Script HUB",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "ZEN Infinity Script HUB",
   LoadingSubtitle = "By us.",
   ShowText = "ZEN Infinity Script HUB", -- for mobile users to unhide rayfield, change if you'd like
   Theme = "Amethyst", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Folder for ZEN Infinity Script HUB"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

-- HOME TAB
local Home_Tab = Window:CreateTab("Home")

   Home_Tab:CreateDivider()
local Button = Tab:CreateButton({
   Name = "Unload The ZEN Infinity Script HUB Interface",
   Callback = function()
--reset admin commands and kill player
Rayfield:Notify({
   Title = "See You Soon!",
   Content = "unloaded the script hub",
   Duration = 6.5,
   Image = 4483362458,
})
   Rayfield:Destroy()
   end,
})
Home_Tab:CreateDivider()

local displayName = localPlayer and localPlayer.DisplayName or "Player"

Home_Tab:CreateLabel("Hi, " .. displayName)
local Paragraph = Tab:CreateParagraph({Title = "paragraph", Content = "ZEN Infinity Script Hub is the ultimate tool for chaos, laughs, and creative trolling in Roblox. Packed with powerful scripts, funny scripts, and unpredictable effects, ZEN Infinity lets you bend the rules and mess with games in hilarious ways. From flying chairs to fake admin commands, it's all about having fun and confusing everyone around you. Easy to use, constantly updated, and loaded with trolling tools—ZEN Infinity is where the madness begins."})


Home_Tab:CreateDivider()

Home_Tab:CreateButton({
    Name = "My Youtube Channel",
    Callback = function()
        local url = "https://www.youtube.com/@Infinite_Original"
        StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = "Opening: " .. url,
            Color = Color3.new(1, 0.8, 0.2),
            Font = Enum.Font.SourceSansBold,
            FontSize = Enum.FontSize.Size24
        })
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "ZEN Infinity",
                Text = "Visit InfiniteMaster's YouTube!",
                Duration = 5
            })
        end)
    end
})

Home_Tab:CreateDivider()

Home_Tab:CreateParagraph({
    Title = "Commands",
    Content = [[
:kill [target] - Kills target
:sit [target] - Makes target sit
:fling [target] - Launch target up
:invisible [target] - Hides target
:uninvisible [target] - Shows target
:fly [target] - Makes player float (fake)
:unfly [target] - Reverses fly
:spin [target] - Spins target
:unspin [target] - Stops spinning
:cmds - Shows this list

Targets: me, all, others, PlayerName
]]
})

-- TROLLING TAB
local Trolling_Tab = Window:CreateTab("Trolling", 4483362458) -- Title, Image
local Divider = Trolling_Tab:CreateDivider()

PlayerTab:CreateButton({
    Name = "FE Sword",
    Callback = function()
        -- Paste working FE sword script here if you have one
        print("FE Sword script placeholder executed.")
    end
})

local PlayerTab = Window:CreateTab("Player")-- Title
local Divider = PlayerTab:CreateDivider()

-- WALKSPEED
local currentWalkSpeed = 16
PlayerTab:CreateSlider({
    Name = "WalkSpeed",
    Min = 16,
    Max = 250,
    Default = 16,
    Increment = 1,
    Flag = "WalkSpeed",
    Suffix = " speed",
    Callback = function(value)
        currentWalkSpeed = value
        local human = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")
        if human then human.WalkSpeed = value end
    end
})

localPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid").WalkSpeed = currentWalkSpeed
end)

-- COMMAND SYSTEM
local Commands = {}
local function getTargets(target)
    local targets = {}
    for _, p in pairs(Players:GetPlayers()) do
        if target == "all" or (target == "others" and p ~= localPlayer) or (target == "me" and p == localPlayer) or string.lower(p.DisplayName) == string.lower(target) or string.lower(p.Name) == string.lower(target) then
            table.insert(targets, p)
        end
    end
    return targets
end

local function makeEffect(player, type)
    local char = player.Character
    if not char then return end
    local effect
    if type == "sparkles" then
        effect = Instance.new("Sparkles", char:FindFirstChild("HumanoidRootPart") or char)
    elseif type == "fire" then
        effect = Instance.new("Fire", char:FindFirstChild("HumanoidRootPart") or char)
    elseif type == "freeze" then
        for _, part in ipairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.Anchored = true
            end
        end
        task.delay(2, function()
            for _, part in ipairs(char:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Anchored = false
                end
            end
        end)
    end
    if effect then game:GetService("Debris"):AddItem(effect, 2) end
end

-- CORE COMMANDS
Commands["kill"] = function(target)
    for _, player in pairs(getTargets(target)) do
        local h = player.Character and player.Character:FindFirstChild("Humanoid")
        if h then h.Health = 0 end
    end
end

Commands["sit"] = function(target)
    for _, player in pairs(getTargets(target)) do
        local h = player.Character and player.Character:FindFirstChild("Humanoid")
        if h then h.Sit = true end
    end
end

Commands["fling"] = function(target)
    for _, player in pairs(getTargets(target)) do
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local bv = Instance.new("BodyVelocity", hrp)
            bv.Velocity = Vector3.new(0, 300, 0)
            bv.MaxForce = Vector3.new(99999, 99999, 99999)
            game.Debris:AddItem(bv, 0.5)
        end
    end
end

Commands["invisible"] = function(target)
    for _, player in pairs(getTargets(target)) do
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                part.Transparency = 1
            elseif part:IsA("ParticleEmitter") then
                part.Enabled = false
            end
        end
    end
end

Commands["uninvisible"] = function(target)
    for _, player in pairs(getTargets(target)) do
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                part.Transparency = 0
            elseif part:IsA("ParticleEmitter") then
                part.Enabled = true
            end
        end
    end
end

Commands["fly"] = function(target)
    for _, player in pairs(getTargets(target)) do
        makeEffect(player, "sparkles")
        local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if root then
            local bv = Instance.new("BodyVelocity", root)
            bv.Velocity = Vector3.new(0, 50, 0)
            bv.MaxForce = Vector3.new(10000, 10000, 10000)
            bv.Name = "FlyForce"
            game.Debris:AddItem(bv, 5)
        end
    end
end

Commands["unfly"] = function(target)
    for _, player in pairs(getTargets(target)) do
        local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if root then
            for _, child in pairs(root:GetChildren()) do
                if child.Name == "FlyForce" then child:Destroy() end
            end
        end
    end
end

Commands["spin"] = function(target)
    for _, player in pairs(getTargets(target)) do
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local bg = Instance.new("BodyAngularVelocity", hrp)
            bg.AngularVelocity = Vector3.new(0, 10, 0)
            bg.MaxTorque = Vector3.new(0, 400000, 0)
            bg.Name = "SpinGyro"
            game.Debris:AddItem(bg, 5)
        end
    end
end

Commands["unspin"] = function(target)
    for _, player in pairs(getTargets(target)) do
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            for _, child in pairs(hrp:GetChildren()) do
                if child.Name == "SpinGyro" then child:Destroy() end
            end
        end
    end
end

Commands["cmds"] = function()
    Commands["printcmds"] = function()
        StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = ":kill :sit :fling :invisible :uninvisible :fly :unfly :spin :unspin :cmds",
            Color = Color3.new(1, 1, 0),
            Font = Enum.Font.SourceSansBold,
            FontSize = Enum.FontSize.Size24
        })
    end
    Commands["printcmds"]()
end

-- CHAT LISTENER
localPlayer.Chatted:Connect(function(msg)
    if msg:sub(1,1) == ":" then
        local args = {}
        for word in string.gmatch(msg, "%S+") do table.insert(args, word) end
        local cmd = args[1]:sub(2):lower()
        local target = args[2] or "me"

        local func = Commands[cmd]
        if func then
            local success, err = pcall(function() func(target) end)
            StarterGui:SetCore("ChatMakeSystemMessage", {
                Text = success and "Server: Command Executed Successfully" or ("Server: Command Failed To Execute - " .. err),
                Color = success and Color3.new(0, 1, 0) or Color3.new(1, 0, 0),
                Font = Enum.Font.SourceSansBold,
                FontSize = Enum.FontSize.Size24
            })
        end
    end
end)

print("ZEN Infinity HUB Loaded.")
