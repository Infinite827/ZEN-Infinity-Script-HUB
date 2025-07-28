-- ZEN Infinity Script HUB - Infinite
-- Theme: Amethyst (default, can change in Settings)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")
local Debris = game:GetService("Debris")

--------------------------------------------------------------------------------
-- UTILITIES
--------------------------------------------------------------------------------

local function sendChat(msg, color)
    StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = msg,
        Color = color or Color3.new(1,1,1),
        Font = Enum.Font.SourceSansBold,
        FontSize = Enum.FontSize.Size24
    })
end

local commandList = {
    ":fly [target]", ":unfly [target]", ":spin [target]", ":unspin [target]",
    ":jump [target]", ":kill [target]", ":sit [target]", ":unsit [target]",
    ":invisible [target]", ":uninvisible [target]", ":fling [target]", ":cmds"
}

local function GetPlayersFromTarget(arg)
    local target = arg and arg:lower() or "me"
    local allPlayers = Players:GetPlayers()
    if target == "me" then return {LocalPlayer}
    elseif target == "all" then return allPlayers
    elseif target == "others" then
        local t = {}
        for _, p in ipairs(allPlayers) do
            if p ~= LocalPlayer then table.insert(t, p) end
        end
        return t
    else
        for _, p in ipairs(allPlayers) do
            if p.Name:lower() == target or p.DisplayName:lower() == target then
                return {p}
            end
        end
    end
    return {}
end

local function executeCommand(cmd, args)
    local targets = GetPlayersFromTarget(args[1])
    if #targets == 0 then
        sendChat("Server: No players found for '"..(args[1] or "").."'", Color3.new(1,0,0))
        return
    end
    for _, tp in ipairs(targets) do
        local ch = tp.Character
        local hum = ch and ch:FindFirstChildOfClass("Humanoid")
        local root = ch and ch:FindFirstChild("HumanoidRootPart")
        -- COMMANDS
        if cmd == "fly" then
            loadstring(game:HttpGet("https://pastebin.com/raw/c4h1xm4B"))()
        elseif cmd == "unfly" then
            if hum then hum.PlatformStand = false end
        elseif cmd == "spin" then
            if root and not root._spin then
                local spin = Instance.new("BodyAngularVelocity", root)
                spin.AngularVelocity = Vector3.new(0,10,0)
                spin.MaxTorque = Vector3.new(0, math.huge, 0)
                spin.Name = "_spin"
            end
        elseif cmd == "unspin" then
            if root and root._spin then root._spin:Destroy() end
        elseif cmd == "jump" then
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        elseif cmd == "kill" then
            ch:BreakJoints()
        elseif cmd == "sit" then
            if hum then hum.Sit = true end
        elseif cmd == "unsit" then
            if hum then hum.Sit = false end
        elseif cmd == "invisible" then
            for _, part in ipairs(ch:GetDescendants()) do
                if part:IsA("BasePart") then part.Transparency = 1 end
            end
        elseif cmd == "uninvisible" then
            for _, part in ipairs(ch:GetDescendants()) do
                if part:IsA("BasePart") then part.Transparency = 0 end
            end
        elseif cmd == "fling" then
            if root then
                local bv = Instance.new("BodyVelocity")
                bv.Velocity = Vector3.new(0,1000,0)
                bv.MaxForce = Vector3.new(1e5,1e5,1e5)
                bv.Parent = root
                Debris:AddItem(bv, 0.1)
            end
        else
            sendChat("Unknown command: "..cmd, Color3.new(1,0,0))
        end
    end
end

--------------------------------------------------------------------------------
-- CHAT HANDLER
--------------------------------------------------------------------------------

LocalPlayer.Chatted:Connect(function(msg)
    if not msg:match("^:") then return end
    local parts = msg:sub(2):split(" ")
    local cmd = parts[1]:lower()
    table.remove(parts, 1)
    local ok, err = pcall(function()
        if cmd == "cmds" then
            for _, line in ipairs(commandList) do
                sendChat(line, Color3.new(1,1,0))
            end
        else
            executeCommand(cmd, parts)
        end
    end)
    if ok then
        sendChat("Server: Command Executed Successfully", Color3.new(0,1,0))
    else
        sendChat("Server: Command Failed To Execute\n"..tostring(err), Color3.new(1,0,0))
    end
end)

--------------------------------------------------------------------------------
-- UI TABS
--------------------------------------------------------------------------------

-- Home Tab
local Home = Window:CreateTab("Home", 4483362458)
Home:CreateDivider()
Home:CreateLabel("Hi, " .. (LocalPlayer.DisplayName or "Player"))
Home:CreateParagraph({Title = "", Content = "\n"})
Home:CreateButton({
    Name = "My Youtube Channel",
    Callback = function()
        setclipboard("https://www.youtube.com/@Infinite_Original")
        Rayfield:Notify({Title="Youtube", Content="Link copied!", Duration=4})
    end
})
Home:CreateDivider()
Home:CreateParagraph({Title="Commands List", Content=table.concat(commandList, "\n")})

-- Player Tab
local PlayerTab = Window:CreateTab("Player", 4483362458)
PlayerTab:CreateDivider()
-- WalkSpeed
PlayerTab:CreateSlider({
    Name="WalkSpeed", Range={16,250}, Increment=1, Suffix="Speed",
    CurrentValue=LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed or 16,
    Callback=function(v)
        local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = v end
    end
})
-- JumpPower
PlayerTab:CreateSlider({
    Name="JumpPower", Range={50,250}, Increment=1, Suffix="Power",
    CurrentValue=LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower or 50,
    Callback=function(v)
        local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then h.JumpPower = v end
    end
})
-- Health Slider
PlayerTab:CreateSlider({
    Name="Health", Range={1,1000000}, Increment=1, Suffix="HP",
    CurrentValue=100,
    Flag="HealthSlider",
    Callback=function(v)
        local char = LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            local h = char:FindFirstChildOfClass("Humanoid")
            h.MaxHealth = v
            h.Health = v
        end
    end
})
-- Godmode Toggle
PlayerTab:CreateToggle({
    Name="Godmode",
    CurrentValue=false,
    Flag="GodmodeToggle",
    Callback=function(val)
        local char = LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            local h = char:FindFirstChildOfClass("Humanoid")
            if val then
                h.MaxHealth = math.huge
                h.Health = math.huge
            else
                h.MaxHealth = 100
                h.Health = 100
            end
        end
    end
})

-- Game Scripts Tab
local GS = Window:CreateTab("Game Scripts", 4483362458)
GS:CreateDivider()
GS:CreateButton({Name="Natural Disaster Survival", Callback=function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/hyperionhax/c00lgui/refs/heads/main/CoolGui.lua"))()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/M-E-N-A-C-E/Menace-Hub/refs/heads/main/Free%20Sus%20Missile", true))()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/synnyyy/synergy/additional/betterbypasser", true))()
      loadstring(game:HttpGet("https://rawscripts.net/raw/Natural-Disaster-Survival-Katers-NDS-Hub-19533"))()
      loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-InfYeiod-reupload-27320"))()
end})
GS:CreateButton({Name="Doors", Callback=function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Robloxexploiterz/Release-Lolhax/refs/heads/main/LX%20Doors%20v3.lua"))()
end})
GS:CreateButton({Name="Roleplay Script", Callback=function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/hyperionhax/c00lgui/refs/heads/main/CoolGui.lua"))()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/M-E-N-A-C-E/Menace-Hub/refs/heads/main/Free%20Sus%20Missile", true))()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/synnyyy/synergy/additional/betterbypasser", true))()
      loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-InfYeiod-reupload-27320"))()
end})

-- Additional Scripts Tab
local AS = Window:CreateTab("Additional Scripts", 4483362458)
AS:CreateDivider()
AS:CreateButton({Name="Chat Bypasser", Callback=function() end})
AS:CreateButton({Name="CoolGui V3", Callback=function() end})
AS:CreateButton({Name="Infinite Yield", Callback=function() end})
AS:CreateButton({Name="Menace Hub", Callback=function() end})
AS:CreateButton({Name="Fly GUI V3", Callback=function() end})

-- Trolling Tab
local TR = Window:CreateTab("Trolling", 4483362458)
TR:CreateDivider()
TR:CreateButton({Name="Jerk Off Tool (Universal)", Callback=function()
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            if hum.RigType == Enum.HumanoidRigType.R15 then
                loadstring(game:HttpGet("https://pastefy.app/YZoglOyJ/raw"))()
            else
                loadstring(game:HttpGet("https://pastefy.app/wa3v2Vgm/raw"))()
            end
        end
    end
end})

-- Settings Tab
local ST = Window:CreateTab("Settings", 4483362458)
ST:CreateDivider()
ST:CreateLabel("Enter theme (case-sensitive):")
ST:CreateTextBox({
    Name="Theme selection", Placeholder="Amethyst", Flag="ThemeInput",
    Callback=function(text)
        local theme = text
        local themes = {
            Default="Default", AmberGlow="AmberGlow", Amethyst="Amethyst",
            Bloom="Bloom", DarkBlue="DarkBlue", Green="Green",
            Light="Light", Ocean="Ocean", Serenity="Serenity"
        }
        if themes[theme] then
            Rayfield:Destroy()
            Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
            Window = Rayfield:CreateWindow({
                Name="ZEN Infinity Script HUB", Theme=theme, ToggleUIKeybind=";",
                -- keep other settings as before
                DisableBuildWarnings=false, DisableRayfieldPrompts=false,
                ConfigurationSaving={Enabled=true}, KeySystem=false
            })
            Rayfield:Notify({Title="Theme set to "..theme, Content="Reloaded UI!", Duration=3})
        else
            Rayfield:Notify({Title="Invalid theme", Content="Refer to list below", Duration=3})
        end
    end
})
ST:CreateParagraph({
    Title="Available themes:",
    Content="Default, AmberGlow, Amethyst, Bloom, DarkBlue, Green, Light, Ocean, Serenity"
})

--------------------------------------------------------------------------------
-- FINAL NOTICE
--------------------------------------------------------------------------------

Rayfield:Notify({Title="ZEN Infinity Script HUB", Content="Loaded successfully!", Duration=5})






