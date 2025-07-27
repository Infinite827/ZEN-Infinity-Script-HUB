-- ZEN Infinity Script HUB
-- Theme: Amethyst

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer

-- Wait for DisplayName to be ready
local DisplayName = LocalPlayer.DisplayName or LocalPlayer.Name

Rayfield:Notify({
   Title = "Hi, " .. DisplayName,
   Content = "Loading the interface",
   Duration = 2.5,
   Image = 4483362458,
})

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
})

-- UI Tabs

-- HOME TAB
local Home_Tab = Window:CreateTab("Home", 4483362458)
Home_Tab:CreateButton({
   Name = "Unload The ZEN Infinity Script HUB Interface",
   Callback = function()
      Rayfield:Notify({
         Title = "See you soon!, " .. DisplayName,
         Content = "Unloading the interface",
         Duration = 1.5,
         Image = 4483362458,
      })
      wait(1.5)
      Rayfield:Destroy()
   end,
})

Home_Tab:CreateDivider()

Home_Tab:CreateLabel("Hi, " .. DisplayName)
Home_Tab:CreateParagraph({
    Title = "",
    Content = "ZEN Infinity Script Hub is the ultimate tool for chaos, laughs, and creative trolling in Roblox. Packed with powerful scripts, funny mods, and unpredictable effects, ZEN Infinity lets you bend the rules and mess with games in hilarious ways. From flying chairs to fake admin commands, it's all about having fun and confusing everyone around you. Easy to use, constantly updated, and loaded with trolling tools—ZEN Infinity is where the madness begins."
})

Home_Tab:CreateDivider()

Home_Tab:CreateButton({
    Name = "My Youtube Channel",
    Callback = function()
        setclipboard("https://www.youtube.com/@Infinite_Original")
        Rayfield:Notify({
            Title = "Youtube Channel",
            Content = "Link copied to clipboard!",
            Duration = 4
        })
    end
})

Home_Tab:CreateDivider()

-- PLAYER TAB
local Player_Tab = Window:CreateTab("Player", 4483362458)
Player_Tab:CreateDivider()

-- Get current humanoid safely
local function getCurrentHumanoid()
    if LocalPlayer.Character then
        return LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    end
    return nil
end

local humanoid = getCurrentHumanoid()
local currentWalkSpeed = humanoid and humanoid.WalkSpeed or 16
local currentJumpPower = humanoid and humanoid.JumpPower or 50
local currentHealth = humanoid and humanoid.Health or 100

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

Player_Tab:CreateSlider({
   Name = "Health",
   Range = {1, 1000000},
   Increment = 1,
   Suffix = "HP",
   CurrentValue = currentHealth,
   Callback = function(Value)
      local h = getCurrentHumanoid()
      if h then
         h.MaxHealth = Value
         h.Health = Value
      end
   end,
})

-- GAME SCRIPTS TAB
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

-- ADDITIONAL SCRIPTS TAB
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

-- TROLLING TAB
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

-- FINAL NOTIFY
Rayfield:Notify({
    Title = "ZEN Infinity Script HUB",
    Content = "Loaded successfully!",
    Duration = 5
})

