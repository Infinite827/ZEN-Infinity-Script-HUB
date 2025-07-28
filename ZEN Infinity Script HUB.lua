-- ZEN Infinity Script HUB - Infinite
-- Theme: Amethyst

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "ZEN Infinity Script HUB",
   Icon = 0,
   LoadingTitle = "ZEN Infinity Script HUB",
   LoadingSubtitle = "By us.",
   ShowText = "ZEN Infinity Script HUB",
   Theme = "Amethyst",
   ToggleUIKeybind = ";",

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

-- Home Tab
local Home_Tab = Window:CreateTab("Home", 4483362458)
Home_Tab:CreateDivider()

local Player = game.Players.LocalPlayer

Home_Tab:CreateLabel("Hi, " .. Player.DisplayName)

local Paragraph = Tab:CreateParagraph({Title = "", Content = "ZEN Infinity Script Hub is the ultimate tool for chaos, laughs, and creative trolling in Roblox. Packed with powerful scripts, funny mods, and unpredictable effects, ZEN Infinity lets you bend the rules and mess with games in hilarious ways. From flying chairs to fake admin commands, it's all about having fun and confusing everyone around you. Easy to use, constantly updated, and loaded with trolling tools—ZEN Infinity is where the madness begins."})

Home_Tab:CreateDivider()

Home_Tab:CreateButton({
   Name = "My Youtube Channel",
   Callback = function()
       setclipboard("https://www.youtube.com/@Infinite_Original")
       Rayfield:Notify({
           Title = "Link Copied",
           Content = "Now paste it into your browser.",
           Duration = 5
       })
   end
})

Home_Tab:CreateDivider()

Home_Tab:CreateParagraph({Title = "Command List", Content = ":cmds
:fling [target]
:fly [target]
:invisible [target]
:jump [target]
:kill [target]
:sit [target]
:spin [target]
:unfly [target]
:uninvisible [target]
:unsit [target]
:unspin [target]"})

-- Command System
local commandList = {
    ":cmds",
    ":fling",
    ":fly",
    ":invisible",
    ":jump",
    ":kill",
    ":sit",
    ":spin",
    ":unfly",
    ":uninvisible",
    ":unsit",
    ":unspin"
}

local function getTargets(arg)
   local players = game:GetService("Players")
   local plr = players.LocalPlayer
   local targets = {}

   if arg == "me" then
      table.insert(targets, plr)
   elseif arg == "all" then
      for _, p in pairs(players:GetPlayers()) do
         table.insert(targets, p)
      end
   elseif arg == "others" then
      for _, p in pairs(players:GetPlayers()) do
         if p ~= plr then
            table.insert(targets, p)
         end
      end
   else
      local t = players:FindFirstChild(arg)
      if t then table.insert(targets, t) end
   end
   return targets
end

game.Players.LocalPlayer.Chatted:Connect(function(msg)
   local args = msg:split(" ")
   local cmd = args[1]:lower()
   local targetArg = args[2]

   if cmd == ":cmds" then
      for _, c in pairs(commandList) do
         game.StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = c;
            Color = Color3.fromRGB(0, 255, 127);
         })
      end
      return
   end

   local success, err = pcall(function()
      local targets = getTargets(targetArg)
      for _, target in pairs(targets) do
         if cmd == ":kill" then
            target.Character:BreakJoints()
         elseif cmd == ":jump" then
            target.Character:FindFirstChildOfClass("Humanoid").Jump = true
         elseif cmd == ":sit" then
            target.Character:FindFirstChildOfClass("Humanoid").Sit = true
         elseif cmd == ":unsit" then
            target.Character:FindFirstChildOfClass("Humanoid").Sit = false
         elseif cmd == ":fly" then
            local hrp = target.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
               local bv = Instance.new("BodyVelocity", hrp)
               bv.Velocity = Vector3.new(0, 100, 0)
               bv.Name = "FlyEffect"
               bv.MaxForce = Vector3.new(100000, 100000, 100000)
            end
         elseif cmd == ":unfly" then
            local hrp = target.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
               local old = hrp:FindFirstChild("FlyEffect")
               if old then old:Destroy() end
            end
         elseif cmd == ":fling" then
            local hrp = target.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
               local bv = Instance.new("BodyVelocity", hrp)
               bv.Velocity = Vector3.new(1000, 1000, 1000)
               bv.MaxForce = Vector3.new(999999, 999999, 999999)
               game.Debris:AddItem(bv, 0.5)
            end
         elseif cmd == ":spin" then
            local hrp = target.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
               local spin = Instance.new("BodyAngularVelocity", hrp)
               spin.AngularVelocity = Vector3.new(0, 10, 0)
               spin.MaxTorque = Vector3.new(0, math.huge, 0)
               spin.Name = "SpinEffect"
            end
         elseif cmd == ":unspin" then
            local hrp = target.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
               local old = hrp:FindFirstChild("SpinEffect")
               if old then old:Destroy() end
            end
         elseif cmd == ":invisible" then
            for _, part in ipairs(target.Character:GetDescendants()) do
               if part:IsA("BasePart") then
                  part.Transparency = 1
                  if part:FindFirstChild("face") then part.face:Destroy() end
               end
            end
         elseif cmd == ":uninvisible" then
            for _, part in ipairs(target.Character:GetDescendants()) do
               if part:IsA("BasePart") then
                  part.Transparency = 0
               end
            end
         end
      end
   end)

   if success then
      game.StarterGui:SetCore("ChatMakeSystemMessage", {
         Text = "Server: Command Executed Successfully",
         Color = Color3.fromRGB(0, 255, 0);
      })
   else
      game.StarterGui:SetCore("ChatMakeSystemMessage", {
         Text = "Server: Command Failed To Execute - " .. err,
         Color = Color3.fromRGB(255, 0, 0);
      })
   end
end)

-- Get current WalkSpeed and JumpPower safely
local function getCurrentHumanoid()
    if LocalPlayer.Character then
        return LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    end
    return nil
end

-- ===== PLAYER TAB =====
local Player_Tab = Window:CreateTab("Player", 4483362458)
Player_Tab:CreateDivider()

local humanoid = getCurrentHumanoid()
local currentWalkSpeed = humanoid and humanoid.WalkSpeed or 16
local currentJumpPower = humanoid and humanoid.JumpPower or 50

Player_Tab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 250},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = currentWalkSpeed,
   Callback = function(Value)
      local h = getCurrentHumanoid()
      if h then
         h.WalkSpeed = Value
      end
   end,
})

Player_Tab:CreateSlider({
   Name = "JumpPower",
   Range = {50, 250},
   Increment = 1,
   Suffix = "Power",
   CurrentValue = currentJumpPower,
   Callback = function(Value)
      local h = getCurrentHumanoid()
      if h then
         h.JumpPower = Value
      end
   end,
})

local Slider = Player_Tab:CreateSlider({
   Name = "Health",
   Range = {1, 1000000},
   Increment = 1,
   Suffix = "HP",
   CurrentValue = 100,
   Flag = "HealthSlider",
   Callback = function(Value)
       local character = game.Players.LocalPlayer.Character
       if character and character:FindFirstChild("Humanoid") then
           character.Humanoid.MaxHealth = Value
           character.Humanoid.Health = Value
       end
   end,
})

local Toggle = Player_Tab:CreateToggle({
   Name = "Godmode",
   CurrentValue = false,
   Flag = "GodmodeToggle",
   Callback = function(Value)
       local character = game.Players.LocalPlayer.Character
       if character and character:FindFirstChild("Humanoid") then
           if Value then
               character.Humanoid.MaxHealth = math.huge
               character.Humanoid.Health = math.huge
           else
               character.Humanoid.MaxHealth = 100
               character.Humanoid.Health = 100
           end
       end
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

-- Trolling tab
local Trolling_Tab = Window:CreateTab("Trolling", 4483362458)
local Divider = Trolling_Tab:CreateDivider()

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


