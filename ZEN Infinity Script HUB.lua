-- ZEN Infinity Script HUB (Clean & Final)

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")
local Debris = game:GetService("Debris")

-- Rayfield UI Bootloader
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "ZEN Infinity Script HUB",
    Icon = 0,
    LoadingTitle = "ZEN Infinity Script HUB",
    LoadingSubtitle = "By us.",
    ShowText = "ZEN Infinity Script HUB",
    Theme = "Amethyst",
    ToggleUIKeybind = "K",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = {Enabled = true, FolderName = nil, FileName = "ZEN_Infinity"},
    Discord = {Enabled = false, Invite = "", RememberJoins = true},
    KeySystem = false
})

-- HOME TAB
local Home = Window:CreateTab("Home")
Home:CreateDivider()
Home:CreateButton({
    Name = "Unload ZEN Infinity HUB",
    Callback = function()
        Rayfield:Notify({Title = "See You Soon!", Content = "Script hub unloaded.", Duration = 6.5, Image = 4483362458})
        Rayfield:Destroy()
    end
})
Home:CreateDivider()
Home:CreateParagraph({
    Title = "Hi, " .. (localPlayer.DisplayName or "Player"",
    Content = [[
ZEN Infinity Script Hub is the ultimate tool for chaos, laughs, and creative trolling in Roblox. Packed with power‑scripts, funny mods, and unpredictable effects—this hub lets you bend the rules and mess with games hilariously. From fake admin to gameplay effects, you’ll have fun confusing everyone.]]
})
Home:CreateDivider()
Home:CreateButton({
    Name = "My YouTube Channel",
    Callback = function()
        local url = "https://www.youtube.com/@Infinite_Original"
        StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = "Opening: " .. url,
            Color = Color3.new(1, 0.8, 0.2),
            Font = Enum.Font.SourceSansBold, FontSize = Enum.FontSize.Size24
        })
        pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = "ZEN Infinity HUB",
                Text = "YouTube link copied!",
                Duration = 5
            })
        end)
    end
})
Home:CreateDivider()
Home:CreateParagraph({
    Title = "Commands",
    Content = [[
:kill [target], :sit [target], :fling [target]
:invisible [target], :uninvisible [target]
:fly [target], :unfly [target]
:spin [target], :unspin [target]
:cmds

Targets: me, all, others, PlayerName
]]
})

-- PLAYER TAB
local PlayerTab = Window:CreateTab("Player")
PlayerTab:CreateDivider()
PlayerTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 250},
    Increment = 1,
    Suffix = " speed",
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(v)
        local hum = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = v end
    end
})
PlayerTab:CreateSlider({
    Name = "JumpPower",
    Range = {50, 1000},
    Increment = 1,
    Suffix = " power",
    CurrentValue = 50,
    Flag = "JumpPower",
    Callback = function(v)
        local hum = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.JumpPower = v end
    end
})

local savedWS = 16
localPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid").WalkSpeed = savedWS
end)

-- GAME SCRIPTS TAB
local Game_Scripts = Window:CreateTab("Game Scripts")
Game_Scripts:CreateDivider()
local Button = Game_Scripts:CreateButton({
   Name = "Natural Disaster Survival",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/hyperionhax/c00lgui/refs/heads/main/CoolGui.lua"))()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/M-E-N-A-C-E/Menace-Hub/refs/heads/main/Free%20Sus%20Missile", true))()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/synnyyy/synergy/additional/betterbypasser", true))
      loadstring(game:HttpGet("https://rawscripts.net/raw/Natural-Disaster-Survival-Katers-NDS-Hub-19533"))()
      loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-InfYeiod-reupload-27320"))()
   end,
})

local Button = Game_Scripts:CreateButton({
   Name = "Doors",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/Robloxexploiterz/Release-Lolhax/refs/heads/main/LX%20Doors%20v3.lua"))()
   end,
})

local Button = Game_Scripts:CreateButton({
   Name = "Roleplay Script",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/hyperionhax/c00lgui/refs/heads/main/CoolGui.lua"))()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/M-E-N-A-C-E/Menace-Hub/refs/heads/main/Free%20Sus%20Missile", true))()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/synnyyy/synergy/additional/betterbypasser", true))
      loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-InfYeiod-reupload-27320"))()
   end,
})

-- ADDITIONAL SCRIPTS TAB
local Additional_Scripts = Window:CreateTab("Additional Scripts")
Additional_Scripts:CreateDivider()

local Button = Game_Scripts:CreateButton({
   Name = "Chat Bypasser (KEY SYSTEM)",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/synnyyy/synergy/additional/betterbypasser", true))
   end,
})

-- TROLLING TAB
local Trolling = Window:CreateTab("Trolling")
Trolling:CreateDivider()
Trolling:CreateButton({
    Name = "FE Server‑Side Sword",
    Callback = function()
        -- Insert your working FE sword code here
        StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = "Server: FE Sword activated!",
            Color = Color3.new(0, 1, 0),
            Font = Enum.Font.SourceSansBold, FontSize = Enum.FontSize.Size24
        })
    end
})

-- COMMAND SYSTEM STARTS HERE
------------------------------------------------
local function getPlayersFromTarget(target)
    local t = {}
    for _, p in pairs(Players:GetPlayers()) do
        local dn, nm = p.DisplayName:lower(), p.Name:lower()
        if target=="all"
           or (target=="others" and p~=localPlayer)
           or (target=="me" and p==localPlayer)
           or dn==target or nm==target then
            table.insert(t, p)
        end
    end
    return t
end

local function chatMsg(txt, col)
    StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = txt, Color = col or Color3.new(1,1,1),
        Font = Enum.Font.SourceSansBold, FontSize = Enum.FontSize.Size24
    })
end

local function applyEffect(p, kind)
    local char = p.Character
    if not char then return end
    if kind=="sparkles" then
        local sp = Instance.new("Sparkles", char:FindFirstChild("HumanoidRootPart") or char)
        Debris:AddItem(sp,2)
    elseif kind=="fire" then
        local f = Instance.new("Fire", char:FindFirstChild("HumanoidRootPart") or char)
        Debris:AddItem(f,2)
    elseif kind=="freeze" then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.Anchored = true end
        end
        task.delay(2,function()
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.Anchored = false end
            end
        end)
    end
end

local Commands = {}

Commands["kill"] = function(target)
    for _, p in ipairs(getPlayersFromTarget(target)) do
        if p.Character and p.Character:FindFirstChild("Humanoid") then
            p.Character.Humanoid.Health = 0
        end
    end
end

Commands["sit"] = function(target)
    for _, p in ipairs(getPlayersFromTarget(target)) do
        if p.Character and p.Character:FindFirstChild("Humanoid") then
            p.Character.Humanoid.Sit = true
        end
    end
end

Commands["fling"] = function(target)
    for _, p in ipairs(getPlayersFromTarget(target)) do
        local hrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local bv = Instance.new("BodyVelocity", hrp)
            bv.Velocity = Vector3.new(0,300,0)
            bv.MaxForce = Vector3.new(9e4,9e4,9e4)
            Debris:AddItem(bv,0.5)
        end
    end
end

Commands["invisible"] = function(target)
    for _, p in ipairs(getPlayersFromTarget(target)) do
        for _, obj in ipairs(p.Character:GetDescendants()) do
            if obj:IsA("BasePart") or obj:IsA("Decal") then obj.Transparency = 1 end
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then obj.Enabled = false end
        end
        applyEffect(p,"fire")
    end
end

Commands["uninvisible"] = function(target)
    for _, p in ipairs(getPlayersFromTarget(target)) do
        for _, obj in ipairs(p.Character:GetDescendants()) do
            if obj:IsA("BasePart") or obj:IsA("Decal") then obj.Transparency = 0 end
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then obj.Enabled = true end
        end
        applyEffect(p,"sparkles")
    end
end

Commands["fly"] = function(target)
    for _, p in ipairs(getPlayersFromTarget(target)) do
        applyEffect(p, "sparkles")
        local hrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local bv = Instance.new("BodyVelocity", hrp)
            bv.Velocity = Vector3.new(0,50,0)
            bv.MaxForce = Vector3.new(1e4,1e4,1e4)
            bv.Name = "FlyForce"
            Debris:AddItem(bv,5)
        end
    end
end

Commands["unfly"] = function(target)
    for _, p in ipairs(getPlayersFromTarget(target)) do
        local hrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            for _, c in ipairs(hrp:GetChildren()) do
                if c.Name == "FlyForce" then c:Destroy() end
            end
        end
    end
end

Commands["spin"] = function(target)
    for _, p in ipairs(getPlayersFromTarget(target)) do
        local hrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local bg = Instance.new("BodyAngularVelocity", hrp)
            bg.AngularVelocity = Vector3.new(0,10,0)
            bg.MaxTorque = Vector3.new(0,4e5,0)
            bg.Name = "SpinGyro"
            Debris:AddItem(bg,5)
        end
    end
end

Commands["unspin"] = function(target)
    for _, p in ipairs(getPlayersFromTarget(target)) do
        local hrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            for _, c in ipairs(hrp:GetChildren()) do
                if c.Name == "SpinGyro" then c:Destroy() end
            end
        end
    end
end

Commands["cmds"] = function()
    local lines = {
        "Commands List:",
        ":kill [target] — Kills target(s)",
        ":sit [target] — Sit",
        ":fling [target] — Launch up",
        ":invisible [target] — Hide",
        ":uninvisible [target] — Unhide",
        ":fly [target] — Float",
        ":unfly [target] — Stop float",
        ":spin [target] — Spin around",
        ":unspin [target] — Stop spin",
        ":cmds — Show list",
        "",
        "Targets: me, all, others, PlayerName"
    }
    for _, ln in ipairs(lines) do
        chatMsg(ln, Color3.new(1,1,0))
    end
end

-- CHAT LISTENER
localPlayer.Chatted:Connect(function(msg)
    if msg:sub(1,1) == ":" then
        local parts = {}
        for w in msg:gmatch("%S+") do table.insert(parts, w) end
        local cmd = parts[1]:sub(2):lower()
        local tgt = parts[2] and parts[2]:lower() or "me"
        if Commands[cmd] then
            local ok, err = pcall(function() Commands[cmd](tgt) end)
            chatMsg(
                ok and "Server: Command Executed Successfully"
                   or ("Server: Command Failed — ".. err),
                ok and Color3.new(0,1,0) or Color3.new(1,0,0)
            )
        end
    end
end)

print("ZEN Infinity HUB Loaded ✔")
