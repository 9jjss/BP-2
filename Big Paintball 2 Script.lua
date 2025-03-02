-- No, I am not the original creator, I saw the code had some errors and I wanted to fix it, so I did.

  local Keybind = "F"
local SessionID = string.gsub(tostring(math.random()):sub(3), "%d", function(c)
    return string.char(96 + math.random(1, 26))
end)
print('✅ | Running BigPaintball2.lua made by Astro with keybind ' .. Keybind .. '! [SessionID ' .. SessionID .. ']')

local Enabled = false
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- Fehlerprotokollierung und Schutz
local function safeExecute(func)
    local success, errorMessage = pcall(func)
    if not success then
        warn('⛔ | Error occurred: ' .. errorMessage .. ' [SessionID ' .. SessionID .. ']')
    end
end

-- Gegner und Spieler an festen Positionen teleportieren
local function teleportEntities(cframe, team)
    local spawnPosition = cframe * CFrame.new(0, 0, -15)

  for _, entity in ipairs(Workspace.__THINGS.__ENTITIES:GetChildren()) do
        if entity:FindFirstChild("HumanoidRootPart") then
            local humanoidRootPart = entity.HumanoidRootPart
            humanoidRootPart.CanCollide = false
            humanoidRootPart.Anchored = true
            humanoidRootPart.CFrame = spawnPosition
        elseif entity:FindFirstChild("Hitbox") then
            local directory = entity:GetAttribute("Directory")
            if not (directory == "White" and entity:GetAttribute("OwnerUID") == LocalPlayer.UserId) and 
               (not team or directory ~= team.Name) then
                entity.Hitbox.CanCollide = false
                entity.Hitbox.Anchored = true
                entity.Hitbox.CFrame = spawnPosition * CFrame.new(math.random(-5, 5), 0, math.random(-5, 5))
            end
        end
    end

  for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if not team or team.Name ~= player.Team.Name then
                if not player.Character:FindFirstChild("ForceField") then
                    local humanoidRootPart = player.Character.HumanoidRootPart
                    humanoidRootPart.CanCollide = false
                    humanoidRootPart.Anchored = true
                    humanoidRootPart.CFrame = spawnPosition * CFrame.new(math.random(-5, 5), 0, math.random(-5, 5))
                end
            end
        end
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if input.KeyCode == Enum.KeyCode[Keybind] and not gameProcessedEvent then
        Enabled = not Enabled
        if Enabled then
            print('✅ | Enabled BigPaintball2.lua [SessionID ' .. SessionID .. ']')
        else
            print('❌ | Disabled BigPaintball2.lua [SessionID ' .. SessionID .. ']')
        end
    end
end)

while wait(0.1) do
    safeExecute(function()
        if not Enabled or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            return
        end

  local cframe = LocalPlayer.Character.HumanoidRootPart.CFrame
        local team = LocalPlayer.Team
        teleportEntities(cframe, team)
    end)
end