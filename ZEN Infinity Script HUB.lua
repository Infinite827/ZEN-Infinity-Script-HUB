-- ZEN Infinity HUB - Full Script
-- Built with Rayfield UI | by Infinite_Original

-- Load Rayfield UI
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
})

--// Variables
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local PlayerName = lp.DisplayName

local function sendChat(msg, color)
    game.StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = msg,
        Color = color or Color3.new(1, 1, 1),
        Font = Enum.Font.SourceSans,
        FontSize = Enum.FontSize.Size24
    })
end

-- Command list
local commandList = {
    ":fly", ":unfly",
    ":spin", ":unspin",
    ":jump",
    ":kill",
    ":cmds"
}

--// Home Tab
local Home_Tab = Window:CreateTab("Home", 4483362458)
Home_Tab:CreateLabel("Hi, " .. PlayerName)
Home_Tab:CreateDivider()

-- Youtube Button
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

-- Command List Display
Home_Tab:CreateParagraph({
    Title = "Commands List",
    Content = table.concat(commandList, "\n")
})

--// Trolling Tab
local Trolling_Tab = Window:CreateTab("Trolling", 4483362458)
Trolling_Tab:CreateButton({
    Name = "FE Server Sword",
    Callback = function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
        end)
        if success then
            sendChat("Server: Command Executed Successfully", Color3.new(0, 1, 0))
        else
            sendChat("Server: Command Failed To Execute\n" .. tostring(err), Color3.new(1, 0, 0))
        end
    end
})

--// FE Chat Commands
local function onChatted(msg)
    local cmd = msg:lower()
    local success, err = pcall(function()
        if cmd == ":fly" then
            loadstring(game:HttpGet("https://pastebin.com/raw/c4h1xm4B"))()

        elseif cmd == ":unfly" then
            lp.Character.Humanoid.PlatformStand = false

        elseif cmd == ":spin" then
            local root = lp.Character:FindFirstChild("HumanoidRootPart")
            if root and not root:FindFirstChild("_spin") then
                local spin = Instance.new("BodyAngularVelocity", root)
                spin.AngularVelocity = Vector3.new(0, 10, 0)
                spin.MaxTorque = Vector3.new(0, math.huge, 0)
                spin.Name = "_spin"
            end

        elseif cmd == ":unspin" then
            local root = lp.Character:FindFirstChild("HumanoidRootPart")
            if root and root:FindFirstChild("_spin") then
                root._spin:Destroy()
            end

        elseif cmd == ":jump" then
            lp.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")

        elseif cmd == ":kill" then
            lp.Character:BreakJoints()

        elseif cmd == ":cmds" then
            for _, v in ipairs(commandList) do
                sendChat(v, Color3.new(0.7, 0.9, 1))
            end

        else
            error("Unknown command")
        end
    end)

    if success then
        sendChat("Server: Command Executed Successfully", Color3.new(0, 1, 0))
    else
        sendChat("Server: Command Failed To Execute\n" .. tostring(err), Color3.new(1, 0, 0))
    end
end

lp.Chatted:Connect(onChatted)

-- Final confirmation
Rayfield:Notify({
    Title = "ZEN Infinity HUB",
    Content = "Loaded successfully!",
    Duration = 5
})
