-- Panel GUI FPS KILLER para Roblox
-- Coloca este script en StarterPlayerScripts o ejecuta como LocalScript

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local backpack = player:WaitForChild("Backpack")

-- Variables para el FPS Killer
local isKillerActive = false
local killerConnection = nil
local equipConnections = {}

-- Crear el GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FPSKillerPanel"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Frame principal
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 250, 0, 150)
mainFrame.Position = UDim2.new(0.75, -125, 0.5, -75) -- Centrado en la parte derecha
mainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Esquinas redondeadas
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- Sombra
local shadow = Instance.new("Frame")
shadow.Name = "Shadow"
shadow.Size = UDim2.new(1, 6, 1, 6)
shadow.Position = UDim2.new(0, -3, 0, -3)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.7
shadow.ZIndex = mainFrame.ZIndex - 1
shadow.Parent = mainFrame

local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 12)
shadowCorner.Parent = shadow

-- Título
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "⚡ PANEL DE CONTROL"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

-- Botón FPS KILLER
local fpsKillerButton = Instance.new("TextButton")
fpsKillerButton.Name = "FPSKillerButton"
fpsKillerButton.Size = UDim2.new(0.8, 0, 0, 50)
fpsKillerButton.Position = UDim2.new(0.1, 0, 0.4, 0)
fpsKillerButton.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
fpsKillerButton.BorderSizePixel = 0
fpsKillerButton.Text = "🔥 FPS KILLER"
fpsKillerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
fpsKillerButton.TextScaled = true
fpsKillerButton.Font = Enum.Font.GothamBold
fpsKillerButton.Parent = mainFrame

-- Esquinas del botón
local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = fpsKillerButton

-- Label de estado
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "Status"
statusLabel.Size = UDim2.new(1, 0, 0, 25)
statusLabel.Position = UDim2.new(0, 0, 0.75, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Estado: Inactivo"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = mainFrame

-- Función para obtener todos los tools
local function getAllTools()
    local tools = {}
    
    -- Tools en el backpack
    for _, tool in pairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            table.insert(tools, tool)
        end
    end
    
    -- Tool equipado actualmente
    if player.Character then
        for _, tool in pairs(player.Character:GetChildren()) do
            if tool:IsA("Tool") then
                table.insert(tools, tool)
            end
        end
    end
    
    return tools
end

-- Función para equipar/desequipar tools rápidamente (causa lag)
local function fpsKillerLoop()
    local tools = getAllTools()
    
    if #tools == 0 then
        return
    end
    
    -- Equipar todos los tools muy rápido
    for i = 1, #tools do
        spawn(function()
            local tool = tools[i]
            if tool and tool.Parent == backpack then
                tool.Parent = player.Character
                wait(0.01) -- Muy poco tiempo para causar lag
                if tool and tool.Parent == player.Character then
                    tool.Parent = backpack
                end
            end
        end)
    end
    
    -- Crear múltiples loops simultáneos para más lag
    for i = 1, 5 do
        spawn(function()
            for _, tool in pairs(tools) do
                if tool then
                    spawn(function()
                        tool.Parent = player.Character
                        tool.Parent = backpack
                        tool.Parent = player.Character
                        tool.Parent = backpack
                    end)
                end
            end
        end)
    end
end

-- Función para iniciar/detener el FPS Killer
local function toggleFPSKiller()
    if isKillerActive then
        -- Detener
        isKillerActive = false
        if killerConnection then
            killerConnection:Disconnect()
            killerConnection = nil
        end
        
        -- Limpiar conexiones
        for _, connection in pairs(equipConnections) do
            connection:Disconnect()
        end
        equipConnections = {}
        
        fpsKillerButton.Text = "🔥 FPS KILLER"
        fpsKillerButton.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
        statusLabel.Text = "Estado: Inactivo"
        statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    else
        -- Iniciar
        isKillerActive = true
        
        -- Ejecutar el loop en RenderStepped para máximo lag
        killerConnection = RunService.RenderStepped:Connect(function()
            fpsKillerLoop()
        end)
        
        -- También ejecutar en Heartbeat
        table.insert(equipConnections, RunService.Heartbeat:Connect(function()
            fpsKillerLoop()
        end))
        
        -- Y en Stepped para triple efecto
        table.insert(equipConnections, RunService.Stepped:Connect(function()
            spawn(fpsKillerLoop)
        end))
        
        fpsKillerButton.Text = "🛑 DETENER"
        fpsKillerButton.BackgroundColor3 = Color3.fromRGB(40, 167, 69)
        statusLabel.Text = "Estado: ACTIVO - Causando Lag"
        statusLabel.TextColor3 = Color3.fromRGB(255, 69, 58)
    end
end

-- Conectar el botón
fpsKillerButton.MouseButton1Click:Connect(toggleFPSKiller)

-- Efectos de hover en el botón
fpsKillerButton.MouseEnter:Connect(function()
    local tween = TweenService:Create(fpsKillerButton, 
        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Size = UDim2.new(0.85, 0, 0, 55)}
    )
    tween:Play()
end)

fpsKillerButton.MouseLeave:Connect(function()
    local tween = TweenService:Create(fpsKillerButton, 
        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Size = UDim2.new(0.8, 0, 0, 50)}
    )
    tween:Play()
end)

-- Hacer que el panel aparezca con animación
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.Position = UDim2.new(0.75, 0, 0.5, 0)

local appearTween = TweenService:Create(mainFrame,
    TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    {
        Size = UDim2.new(0, 250, 0, 150),
        Position = UDim2.new(0.75, -125, 0.5, -75)
    }
)
appearTween:Play()

-- Funcionalidad para cerrar con tecla X (opcional)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.X then
        if isKillerActive then
            toggleFPSKiller()
        end
        screenGui:Destroy()
    end
end)

print("Panel FPS KILLER cargado. Presiona X para cerrar el panel.")
