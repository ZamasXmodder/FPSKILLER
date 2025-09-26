local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Crear el GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FPSKillerPanel"
screenGui.Parent = playerGui

-- Panel principal
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainPanel"
mainFrame.Size = UDim2.new(0, 200, 0, 80)
mainFrame.Position = UDim2.new(0, 10, 1, -90)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Esquinas redondeadas
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- Título
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 25)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "FPS Killer"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

-- Botón FPS Killer
local fpsButton = Instance.new("TextButton")
fpsButton.Name = "FPSKillerButton"
fpsButton.Size = UDim2.new(0.9, 0, 0, 35)
fpsButton.Position = UDim2.new(0.05, 0, 0, 40)
fpsButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
fpsButton.Text = "Activar FPS Killer"
fpsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
fpsButton.TextScaled = true
fpsButton.Font = Enum.Font.Gotham
fpsButton.Parent = mainFrame

-- Esquinas del botón
local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 4)
buttonCorner.Parent = fpsButton

-- Variables de control
local fpsKillerActive = false
local lagConnections = {}
local toolEquipConnections = {}

-- Función para crear lag intensivo
local function createLagForPlayer(targetPlayer)
    if targetPlayer == player then return end
    
    local connection = RunService.Heartbeat:Connect(function()
        if not fpsKillerActive then return end
        
        -- Crear múltiples partes invisibles que consuman recursos
        for i = 1, 50 do
            local part = Instance.new("Part")
            part.Name = "LagPart"
            part.Size = Vector3.new(0.1, 0.1, 0.1)
            part.Transparency = 1
            part.CanCollide = false
            part.Anchored = false
            part.Parent = workspace
            
            -- Aplicar física intensiva
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
            bodyVelocity.Velocity = Vector3.new(
                math.random(-100, 100),
                math.random(-100, 100),
                math.random(-100, 100)
            )
            bodyVelocity.Parent = part
            
            -- Eliminar después de un tiempo corto
            game:GetService("Debris"):AddItem(part, 0.1)
        end
    end)
    
    lagConnections[targetPlayer] = connection
end

-- Función para equipar/desequipar tools automáticamente
local function autoEquipTools()
    local backpack = player:FindFirstChild("Backpack")
    if not backpack then return end
    
    local tools = backpack:GetChildren()
    for _, tool in pairs(tools) do
        if tool:IsA("Tool") then
            -- Equipar y desequipar rápidamente
            spawn(function()
                while fpsKillerActive do
                    tool.Parent = player.Character
                    wait(0.1)
                    if tool.Parent == player.Character then
                        tool.Parent = backpack
                    end
                    wait(0.1)
                end
            end)
        end
    end
end

-- Función para activar/desactivar FPS Killer
local function toggleFPSKiller()
    fpsKillerActive = not fpsKillerActive
    
    if fpsKillerActive then
        fpsButton.Text = "Desactivar FPS Killer"
        fpsButton.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
        
        -- Iniciar lag para todos los jugadores excepto el local
        for _, targetPlayer in pairs(Players:GetPlayers()) do
            createLagForPlayer(targetPlayer)
        end
        
        -- Iniciar auto-equip de tools
        autoEquipTools()
        
        -- Manejar nuevos jugadores
        toolEquipConnections.playerAdded = Players.PlayerAdded:Connect(function(newPlayer)
            wait(1) -- Esperar a que el jugador cargue
            createLagForPlayer(newPlayer)
        end)
        
    else
        fpsButton.Text = "Activar FPS Killer"
        fpsButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
        
        -- Desconectar todas las conexiones de lag
        for _, connection in pairs(lagConnections) do
            if connection then
                connection:Disconnect()
            end
        end
        lagConnections = {}
        
        -- Desconectar conexiones de tools
        for _, connection in pairs(toolEquipConnections) do
            if connection then
                connection:Disconnect()
            end
        end
        toolEquipConnections = {}
        
        -- Limpiar partes de lag existentes
        for _, part in pairs(workspace:GetChildren()) do
            if part.Name == "LagPart" then
                part:Destroy()
            end
        end
    end
end

-- Conectar el botón
fpsButton.MouseButton1Click:Connect(toggleFPSKiller)

-- Efecto hover del botón
fpsButton.MouseEnter:Connect(function()
    local tween = TweenService:Create(fpsButton, TweenInfo.new(0.2), {
        Size = UDim2.new(0.95, 0, 0, 37)
    })
    tween:Play()
end)

fpsButton.MouseLeave:Connect(function()
    local tween = TweenService:Create(fpsButton, TweenInfo.new(0.2), {
        Size = UDim2.new(0.9, 0, 0, 35)
    })
    tween:Play()
end)

print("FPS Killer Panel cargado exitosamente")
