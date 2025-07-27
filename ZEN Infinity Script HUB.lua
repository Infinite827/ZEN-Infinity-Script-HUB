-- ZEN Infinity HUB - Fully Fixed and Cleaned
-- Uses Rayfield UI

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "ZEN Infinity HUB",
    LoadingTitle = "ZEN Infinity HUB",
    LoadingSubtitle = "by Infinite_Original",
    ConfigurationSaving = {
        Enabled = false,
        FolderName = nil,
        FileName = "ZENInfinityHubConfig"
    },
    Discord = {
        Enabled = false,
        Invite = "",
        RememberJoins = false
    },
    KeySystem = false,
    Theme = Rayfield.Themes.Amethyst
})

-- Home Tab
local Home_Tab = Window:CreateTab("Home", 4483362458)
local Player = game.Players.LocalPlayer
Home_Tab:CreateLabel("Hi, " .. Player.DisplayName)
Home_Tab:CreateDivider()

Home_Tab:CreateButton({
    Name = "My Youtube Channel",
    Callback = function()
        setclipboard("https://www.youtube.com/@Infinite_Original")
        Rayfield:Notify({Title = "Youtube", Content = "Link copied to clipboard!", Duration = 4})
    end
})

Home_Tab:CreateDivider()

local commandList = {
    ":fly [target]", ":unfly [target]",
    ":spin [target]", ":unspin [target]",
    ":jump [target]", ":kill [target]",
    ":sit [target]", ":cmds"
}

Home_Tab:CreateParagraph({
    Title = "Commands List",
    Content = table.concat(commandList, "\n")
})

-- Trolling Tab
local Trolling_Tab = Window:CreateTab("Trolling", 4483362458)
Trolling_Tab:CreateButton({
    Name = "FE Server Sword",
    Callback = function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/1f0yt/community/main/fe_sword.lua"))()
        end)
        if success then
            game.StarterGui:SetCore("ChatMakeSystemMessage", {
                Text = "Server: Command Executed Successfully",
                Color = Color3.fromRGB(0, 255, 0)
            })
        else
            game.StarterGui:SetCore("ChatMakeSystemMessage", {
                Text = "Server: Command Failed To Execute\n" .. tostring(err),
                Color = Color3.fromRGB(255, 0, 0)
            })
        end
    end
})

-- Helpers
local function getTargets(arg)
    local lp = Player
    if arg == "me" then
        return {lp}
    elseif arg == "all" then
        return game.Players:GetPlayers()
    elseif arg == "others" then
        local others = {}
        for _, p in ipairs(game.Players:GetPlayers()) do
            if p ~= lp then
                table.insert(others, p)
            end
        end
        return others
    else
        for _, p in ipairs(game.Players:GetPlayers()) do
            if p.Name:lower():sub(1, #arg) == arg:lower() or p.DisplayName:lower():sub(1, #arg) == arg:lower() then
                return {p}
            end
        end
    end
    return {}
end

-- Chat Commands
local function sendChat(msg, color)
    game.StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = msg,
        Color = color or Color3.fromRGB(255, 255, 255)
    })
end

Player.Chatted:Connect(function(msg)
    local args = msg:split(" ")
    local command = args[1]:lower()
    local targetArg = args[2] or "me"
    local success, err = pcall(function()
        local targets = getTargets(targetArg)
        if #targets == 0 then error("No valid targets") end

        if command == ":fly" then
            loadstring(game:HttpGet("https://pastebin.com/raw/c4h1xm4B"))()
        elseif command == ":unfly" then
            for _, t in ipairs(targets) do
                t.Character.Humanoid.PlatformStand = false
            end
        elseif command == ":spin" then
            for _, t in ipairs(targets) do
                local root = t.Character and t.Character:FindFirstChild("HumanoidRootPart")
                if root and not root:FindFirstChild("_spin") then
                    local spin = Instance.new("BodyAngularVelocity", root)
                    spin.AngularVelocity = Vector3.new(0, 10, 0)
                    spin.MaxTorque = Vector3.new(0, math.huge, 0)
                    spin.Name = "_spin"
                end
            end
        elseif command == ":unspin" then
            for _, t in ipairs(targets) do
                local root = t.Character and t.Character:FindFirstChild("HumanoidRootPart")
                if root and root:FindFirstChild("_spin") then
                    root._spin:Destroy()
                end
            end
        elseif command == ":jump" then
            for _, t in ipairs(targets) do
                t.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
            end
        elseif command == ":sit" then
            for _, t in ipairs(targets) do
                t.Character:FindFirstChildOfClass("Humanoid").Sit = true
            end
        elseif command == ":kill" then
            for _, t in ipairs(targets) do
                t.Character:BreakJoints()
            end
        elseif command == ":cmds" then
            for _, cmd in ipairs(commandList) do
                sendChat(cmd)
            end
            return
        else
            error("Unknown command")
        end
    end)

    if success then
        sendChat("Server: Command Executed Successfully", Color3.fromRGB(0, 255, 0))
    else
        sendChat("Server: Command Failed To Execute\n" .. tostring(err), Color3.fromRGB(255, 0, 0))
    end
end)

Rayfield:Notify({Title = "ZEN Infinity HUB", Content = "Loaded successfully!", Duration = 5})
