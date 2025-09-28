-- Script para crear GUI de Desync en Roblox
-- Coloca este script en StarterPlayerScripts o ejecuta en el cliente

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Crear el ScreenGui principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DesyncGUI"
screenGui.Parent = playerGui

-- Frame principal del panel
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainPanel"
mainFrame.Size = UDim2.new(0, 200, 0, 80)
mainFrame.Position = UDim2.new(0, 50, 0, 50)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Esquinas redondeadas
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- Borde/sombra
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(60, 60, 70)
stroke.Thickness = 1
stroke.Parent = mainFrame

-- Título del panel
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 25)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🔄 Desync Panel"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

-- Botón de Desync
local desyncButton = Instance.new("TextButton")
desyncButton.Name = "DesyncButton"
desyncButton.Size = UDim2.new(0.8, 0, 0, 35)
desyncButton.Position = UDim2.new(0.1, 0, 0.4, 0)
desyncButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
desyncButton.BorderSizePixel = 0
desyncButton.Text = "DESINCRONIZAR"
desyncButton.TextColor3 = Color3.fromRGB(255, 255, 255)
desyncButton.TextScaled = true
desyncButton.Font = Enum.Font.GothamBold
desyncButton.Parent = mainFrame

-- Esquinas del botón
local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 6)
buttonCorner.Parent = desyncButton

-- Variables para el sistema de desync
local isDesynced = false
local desyncConnection = nil
local originalCFrame = nil

-- Función de desync
local function toggleDesync()
    local character = player.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    if not isDesynced then
        -- Activar desync
        isDesynced = true
        originalCFrame = humanoidRootPart.CFrame
        
        -- Desconectar el network ownership
        if humanoidRootPart.AssemblyLinearVelocity then
            humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        end
        
        -- Crear loop de desync
        desyncConnection = RunService.Heartbeat:Connect(function()
            if humanoidRootPart.Parent then
                -- Mantener el personaje en una posición fija para otros jugadores
                humanoidRootPart.CFrame = originalCFrame
                humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                humanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            end
        end)
        
        desyncButton.Text = "SINCRONIZAR"
        desyncButton.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
        
        -- Efecto visual
        local tween = TweenService:Create(mainFrame, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(45, 25, 25)
        })
        tween:Play()
        
    else
        -- Desactivar desync
        isDesynced = false
        
        if desyncConnection then
            desyncConnection:Disconnect()
            desyncConnection = nil
        end
        
        desyncButton.Text = "DESINCRONIZAR"
        desyncButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
        
        -- Restaurar color original
        local tween = TweenService:Create(mainFrame, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        })
        tween:Play()
    end
end

-- Conectar el botón
desyncButton.MouseButton1Click:Connect(toggleDesync)

-- Efectos hover del botón
desyncButton.MouseEnter:Connect(function()
    local tween = TweenService:Create(desyncButton, TweenInfo.new(0.1), {
        Size = UDim2.new(0.82, 0, 0, 37)
    })
    tween:Play()
end)

desyncButton.MouseLeave:Connect(function()
    local tween = TweenService:Create(desyncButton, TweenInfo.new(0.1), {
        Size = UDim2.new(0.8, 0, 0, 35)
    })
    tween:Play()
end)

-- Sistema de arrastre
local dragging = false
local dragStart = nil
local startPos = nil

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, 
                                      startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Limpiar al reaparecer
player.CharacterRemoving:Connect(function()
    if desyncConnection then
        desyncConnection:Disconnect()
        desyncConnection = nil
    end
    isDesynced = false
    desyncButton.Text = "DESINCRONIZAR"
    desyncButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
end)

print("✅ GUI de Desync cargado correctamente")
