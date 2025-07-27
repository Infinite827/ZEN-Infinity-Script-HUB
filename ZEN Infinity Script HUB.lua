-- ZEN Infinity Script HUB
-- Theme: Amethyst

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
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "Folder for ZEN Infinity Script HUB"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = false,
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"Hello"}
   }
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local DisplayName = LocalPlayer.DisplayName

-- ===== HOME TAB =====
local Home_Tab = Window:CreateTab("Home", 4483362458)
Home_Tab:CreateButton({
   Name = "Unload The ZEN Infinity Script HUB Interface",
   Callback = function()
      Rayfield:Notify({
         Title = "See You Soon!",
         Content = "unloading the interface",
         Duration = 1.5,
         Image = 4483362458,
      })

      wait(1.5)
      Rayfield:Destroy()
   end,
})
Home_Tab:CreateDivider()
Home_Tab:CreateLabel("Hi, " .. DisplayName)
Home_Tab:CreateParagraph({Title = "", Content = "ZEN Infinity Script Hub is the ultimate tool for chaos, laughs, and creative trolling in Roblox. Packed with powerful scripts, funny mods, and unpredictable effects, ZEN Infinity lets you bend the rules and mess with games in hilarious ways. From flying chairs to fake admin commands, it's all about having fun and confusing everyone around you. Easy to use, constantly updated, and loaded with trolling tools—ZEN Infinity is where the madness begins."})

Home_Tab:CreateDivider()

Home_Tab:CreateButton({
    Name = "My Youtube Channel",
    Callback = function()
        setclipboard("https://www.youtube.com/@Infinite_Original")
        Rayfield:Notify({
            Title = "Youtube",
            Content = "Link copied to clipboard!",
            Duration = 4
        })
    end
})

Home_Tab:CreateDivider()

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
    ":cmds"
}

Home_Tab:CreateParagraph({
    Title = "Commands List",
    Content = table.concat(commandList, "\n")
})

print("Commands List")

-- ===== PLAYER TAB =====
local Player_Tab = Window:CreateTab("Player", 4483362458)
Player_Tab:CreateDivider()
Player_Tab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 250},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Callback = function(Value)
      LocalPlayer.Character.Humanoid.WalkSpeed = Value
   end,
})

Player_Tab:CreateSlider({
   Name = "JumpPower",
   Range = {50, 250},
   Increment = 1,
   Suffix = "Power",
   CurrentValue = 50,
   Callback = function(Value)
      LocalPlayer.Character.Humanoid.JumpPower = Value
   end,
})

-- ===== GAME SCRIPTS TAB =====
local Game_Scripts = Window:CreateTab("Game Scripts")
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

-- ===== ADDITIONAL SCRIPTS TAB =====
local Additional_Scripts = Window:CreateTab("Additional Scripts")
Additional_Scripts:CreateDivider()

Additional_Scripts:CreateButton({
   Name = "Chat Bypasser (KEY SYSTEM(also set language to Ka3ak Tini))",
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
   Name = "Infinite Yeild",
   Callback = function()
      loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-InfYeiod-reupload-27320"))()
   end,
})

Additional_Scripts:CreateButton({
   Name = "Menace Hub (my friends hub)",
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

-- ===== TROLLING TAB =====
local Trolling_Tab = Window:CreateTab("Trolling", 4483362458)
Trolling_Tab:CreateDivider()

Trolling_Tab:CreateButton({
   Name = "Jerk Off Tool (Universal)",
   Callback = function()
local humanoid = character:FindFirstChild("Humanoid") -- Assuming 'character' is the player's character model
if humanoid then
  if humanoid.RigType == Enum.HumanoidRigType.R15 then
    -- The avatar is R15
    loadstring(game:HttpGet("https://pastefy.app/YZoglOyJ/raw"))()
  else
    -- The avatar is R6
    loadstring(game:HttpGet("https://pastefy.app/wa3v2Vgm/raw"))()
  end
end,
})

local function sendChat(msg, color)
    game.StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = msg,
        Color = color or Color3.new(1, 1, 1)
    })
end

LocalPlayer.Chatted:Connect(function(msg)
    if not msg:match("^:") then return end
    local split = msg:sub(2):split(" ")
    local command = split[1]

    if command == "cmds" then
        for _, c in ipairs(Command List) do
            sendChat(c, Color3.new(255, 255, 255))
        end
    end
end)

-- ===== CHAT COMMAND HANDLER =====
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
            if p ~= LocalPlayer then table.insert(others, p) end
        end
        return others
    else
        for _, p in ipairs(allPlayers) do
            if p.Name:lower() == target or p.DisplayName:lower() == target then
                return {p}
            end
        end
    end
    return {}
end

local function sendChat(msg, color)
    game.StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = msg,
        Color = color or Color3.new(1, 1, 1)
    })
end

local function executeCommand(command, args)
    for _, targetPlayer in ipairs(GetPlayersFromTarget(args[1] or "me")) do
        local char = targetPlayer.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")

        if command == "fly" then
            loadstring(game:HttpGet("https://pastebin.com/raw/c4h1xm4B"))()
        elseif command == "unfly" then
            humanoid.PlatformStand = false
        elseif command == "spin" then
            if root and not root:FindFirstChild("_spin") then
                local spin = Instance.new("BodyAngularVelocity", root)
                spin.AngularVelocity = Vector3.new(0, 10, 0)
                spin.MaxTorque = Vector3.new(0, math.huge, 0)
                spin.Name = "_spin"
            end
        elseif command == "unspin" then
            if root and root:FindFirstChild("_spin") then
                root._spin:Destroy()
            end
        elseif command == "jump" then
            humanoid:ChangeState("Jumping")
        elseif command == "kill" then
            char:BreakJoints()
        elseif command == "sit" then
            humanoid.Sit = true
        elseif command == "unsit" then
            humanoid.Sit = false
        elseif command == "invisible" then
            for _, part in ipairs(char:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Transparency = 1
                end
            end
        elseif command == "uninvisible" then
            for _, part in ipairs(char:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Transparency = 0
                end
            end
        elseif command == "fling" then
            if root then
                local bv = Instance.new("BodyVelocity")
                bv.Velocity = Vector3.new(0, 1000, 0)
                bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
                bv.Parent = root
                game.Debris:AddItem(bv, 0.1)
            end
        end
    end
end

LocalPlayer.Chatted:Connect(function(msg)
    if not msg:match("^:") then return end
    local split = msg:sub(2):split(" ")
    local command = split[1]
    table.remove(split, 1)

    local success, err = pcall(function()
        if command == "cmds" then
            for _, c in ipairs(commandList) do
                sendChat(c, Color3.new(1, 1, 0))
            end
        else
            executeCommand(command, split)
        end
    end)

    if success then
        sendChat("Server: Command Executed Successfully", Color3.new(0, 1, 0))
    else
        sendChat("Server: Command Failed To Execute\n" .. tostring(err), Color3.new(1, 0, 0))
    end
end)

-- ===== FINAL NOTIFY =====
Rayfield:Notify({
    Title = "ZEN Infinity HUB",
    Content = "Loaded successfully!",
    Duration = 5
})
