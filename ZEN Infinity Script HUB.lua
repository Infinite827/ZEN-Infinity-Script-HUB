-- ZEN Infinity Script HUB
-- Updated and Cleaned Version
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
Home_Tab:CreateLabel("Hi, " .. DisplayName)
Home_Tab:CreateParagraph({Title = "", Content = "\n\n"})
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

-- ===== PLAYER TAB =====
local Player_Tab = Window:CreateTab("Player", 4483362458)
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

-- ===== TROLLING TAB =====
local Trolling_Tab = Window:CreateTab("Trolling", 4483362458)
Trolling_Tab:CreateButton({
    Name = "FE Server Sword",
    Callback = function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
        end)
        if success then
            game.StarterGui:SetCore("ChatMakeSystemMessage", {
                Text = "Server: Command Executed Successfully",
                Color = Color3.new(0, 1, 0)
            })
        else
            game.StarterGui:SetCore("ChatMakeSystemMessage", {
                Text = "Server: Command Failed To Execute\n" .. tostring(err),
                Color = Color3.new(1, 0, 0)
            })
        end
    end
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





