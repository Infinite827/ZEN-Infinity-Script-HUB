-- Define the commands table at top scope so UI code can use it
local commands = {}

-- FE/Server Sided Chat Admin Commands (in a coroutine)
task.spawn(function()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local StarterGui = game:GetService("StarterGui")
    local LocalPlayer = Players.LocalPlayer

    -- Safe function to send system chat messages
    local function chatMessage(text, color)
        color = color or Color3.fromRGB(0, 255, 255)
        local success, err = pcall(function()
            StarterGui:SetCore("ChatMakeSystemMessage", {
                Text = text,
                Color = color,
                Font = Enum.Font.SourceSansBold,
                FontSize = Enum.FontSize.Size24
            })
        end)
        if not success then
            warn("Chat message failed: " .. tostring(err))
        end
    end

    -- Variables to track active states
    local activeSpinning = false
    local spinThread = nil
    local noclipConnection = nil
    local flyLoaded = false

    -- Fill the commands table here (this updates the top-level `commands`)
    commands = {
        ["kill"] = function()
            -- same implementation as before...
        end,
        ["fly"] = function()
            -- ...
        end,
        -- all other commands here...
        ["cmds"] = function()
            local list = {}
            for name in pairs(commands) do
                table.insert(list, ":" .. name)
            end
            table.sort(list)
            chatMessage("Available Commands: " .. table.concat(list, ", "), Color3.fromRGB(255, 255, 0))
        end,
    }

    LocalPlayer.Chatted:Connect(function(msg)
        msg = msg:lower()
        if msg:sub(1, 1) == ":" then
            local cmd = msg:sub(2)
            if commands[cmd] then
                local success, err = pcall(commands[cmd])
                if success then
                    chatMessage("Server: Command Executed Successfully", Color3.fromRGB(0, 255, 0))
                else
                    chatMessage("Server: Command Failed To Execute\n" .. tostring(err), Color3.fromRGB(255, 0, 0))
                    warn("Command error: " .. tostring(err))
                end
            else
                chatMessage("Unknown command: " .. cmd, Color3.fromRGB(255, 0, 0))
            end
        end
    end)

    chatMessage("FE Chat Commands loaded! Use :cmds to see commands.", Color3.fromRGB(0, 255, 255))
end)

-- Now that commands is defined, create UI that uses commands:
local Home_Tab = Window:CreateTab("Home", 4483362458)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local displayName = LocalPlayer and LocalPlayer.DisplayName or "Player"

-- Greeting Label
Home_Tab:CreateLabel("Hi, " .. displayName)
Home_Tab:CreateDivider()

-- YouTube Channel Button
Home_Tab:CreateButton({
    Name = "My Youtube Channel",
    Callback = function()
        setclipboard("https://www.youtube.com/@Infinite_Original")
        Rayfield:Notify({
            Title = "YouTube",
            Content = "Link copied to clipboard!",
            Duration = 4
        })
    end
})

Home_Tab:CreateDivider()

-- Commands List Paragraph
local commandList = {}
for name in pairs(commands) do
    table.insert(commandList, ":" .. name)
end
table.sort(commandList)

Home_Tab:CreateParagraph({
    Title = "Commands List",
    Content = table.concat(commandList, "\n")
})

-- ... rest of your tabs and buttons as before
