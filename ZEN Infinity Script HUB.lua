-- ZEN Infinity Script HUB
-- Theme: Amethyst

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer
local DisplayName = LocalPlayer.DisplayName

Rayfield:Notify({
   Title = "Hi, " .. DisplayName,
   Content = "Loaded the interface",
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

-- Commands list for :cmds
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

-- Send chat system message safely
local function sendChat(msg, color)
    StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = msg,
        Color = color or Color3.new(1, 1, 1),
        Font = Enum.Font.SourceSansBold,
        FontSize = Enum.FontSize.Size24
    })
end

-- Helper: Get players from target string
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
        -- Exact match first
        for _, p in ipairs(allPlayers) do
            if p.Name:lower() == target or p.DisplayName:lower() == target then
                return {p}
            end
        end
        -- Partial match
        for _, p in ipairs(allPlayers) do
            if p.Name:lower():find(target, 1, true) or p.DisplayName:lower():find(target, 1, true) then
                return {p}
            end
        end
    end
    return {}
end

-- Execute commands logic
local function executeCommand(command, args)
    local targets = GetPlayersFromTarget(args[1] or "me")
    if #targets == 0 then
        sendChat("Server: No players found for target '" .. (args[1] or "") .. "'", Color3.new(1, 0, 0))
        return
    end

    for _, targetPlayer in ipairs(targets) do
        local char = targetPlayer.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")

        if command == "fly" then
            -- Example simple fly (you might want to replace this with your actual fly code)
            if humanoid then
                humanoid.PlatformStand = true
                -- Fly implementation goes here
            end
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
                for _, part in ipairs(char:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.Transparency = 1
                    end
                end
            end
        elseif command == "uninvisible" then
            if char then
                for _, part in ipairs(char:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.Transparency = 0
                    end
                end
            end
        elseif command == "fling" then
            if root then
                local bv = Instance.new("BodyVelocity")
                bv.Velocity = Vector3.new(0, 1000, 0)
                bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
                bv.Parent = root
                game:GetService("Debris"):AddItem(bv, 0.1)
            end
        else
            sendChat("Unknown command: " .. command, Color3.new(1, 0, 0))
        end
    end
end

-- Listen to chat commands
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
