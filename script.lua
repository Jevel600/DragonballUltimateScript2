-- Dragon Blox Ultimate Script with Auto Farm, Auto Rebirth, Auto Transform, and Auto Teleport to Vills Planet

-- Ensure the game is fully loaded
repeat wait() until game:IsLoaded()

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Player
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Remotes
local remotes = ReplicatedStorage:WaitForChild("Remotes")
local attackRemote = remotes:WaitForChild("AttackRemote")
local rebirthRemote = remotes:WaitForChild("RebirthRemote")
local transformRemote = remotes:WaitForChild("TransformRemote")
local teleportRemote = remotes:WaitForChild("TeleportRemote")

-- UI Library (Assuming a simple UI library is used)
local UILibrary = loadstring(game:HttpGet("https://pastebin.com/raw/your_ui_library"))()
local window = UILibrary.CreateWindow("Dragon Blox Ultimate")

-- Flags
local autoFarm = false
local autoRebirth = false
local autoTransform = false
local autoTeleport = false

-- Functions
local function findNearestEnemy()
    local nearestEnemy = nil
    local shortestDistance = math.huge

    for _, npc in pairs(workspace.NPCs:GetChildren()) do
        if npc:FindFirstChild("HumanoidRootPart") then
            local distance = (humanoidRootPart.Position - npc.HumanoidRootPart.Position).magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                nearestEnemy = npc
            end
        end
    end

    return nearestEnemy
end

local function attackEnemy(enemy)
    if enemy and enemy:FindFirstChild("HumanoidRootPart") then
        humanoidRootPart.CFrame = CFrame.new(enemy.HumanoidRootPart.Position + Vector3.new(0, 0, 5), enemy.HumanoidRootPart.Position)
        attackRemote:FireServer()
    end
end

local function handleAutoFarm()
    while autoFarm do
        local enemy = findNearestEnemy()
        if enemy then
            attackEnemy(enemy)
        end
        wait(0.1)
    end
end

local function handleAutoRebirth()
    while autoRebirth do
        if player.leaderstats.Level.Value >= 100 then -- Assuming level 100 is the rebirth threshold
            rebirthRemote:FireServer()
        end
        wait(1)
    end
end

local function handleAutoTransform()
    while autoTransform do
        if not player.Character:FindFirstChild("Transformed") then
            transformRemote:FireServer()
        end
        wait(5)
    end
end

local function handleAutoTeleport()
    if autoTeleport then
        teleportRemote:FireServer("Vills Planet")
        autoTeleport = false -- Reset toggle after teleporting
    end
end

-- UI Elements
window:Toggle("Auto Farm", function(value)
    autoFarm = value
    if autoFarm then
        handleAutoFarm()
    end
end)

window:Toggle("Auto Rebirth", function(value)
    autoRebirth = value
    if autoRebirth then
        handleAutoRebirth()
    end
end)

window:Toggle("Auto Transform", function(value)
    autoTransform = value
    if autoTransform then
        handleAutoTransform()
    end
end)

window:Toggle("Auto Teleport to Vills Planet", function(value)
    autoTeleport = value
    if autoTeleport then
        handleAutoTeleport()
    end
end)

-- Notifications
game.StarterGui:SetCore("SendNotification", {
    Title = "Script Loaded",
    Text = "Dragon Blox Ultimate script loaded successfully!",
    Duration = 5
})
