-- Script GUI Desync Mejorado - Sin bloquear movimiento
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Crear el ScreenGui principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DesyncGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Frame principal del panel
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainPanel"
mainFrame.Size = UDim2.new(0, 200, 0, 80)
mainFrame.Position = UDim2.new(0, 50, 0, 50)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
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

-- Variables para el desync
local isDesynced = false
local desyncPart = nil

-- Función principal de desync
local function toggleDesync()
    local character = player.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    if not isDesynced then
        -- ACTIVAR DESYNC
        isDesynced = true
        
        -- Crear parte invisible para desync
        desyncPart = Instance.new("Part")
        desyncPart.Name = "DesyncPart_" .. player.Name
        desyncPart.Size = humanoidRootPart.Size
        desyncPart.Material = Enum.Material.ForceField
        desyncPart.CanCollide = false
        desyncPart.Anchored = true
        desyncPart.CFrame = humanoidRootPart.CFrame
        desyncPart.Parent = workspace
        
        -- Hacer invisible para ti pero visible para otros
        desyncPart.Transparency = 1
        
        -- Clonar apariencia
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") and part ~= humanoidRootPart then
                local clonePart = part:Clone()
                clonePart.Parent = desyncPart
                clonePart.Anchored = true
                clonePart.CanCollide = false
                
                -- Mantener posición relativa
                local weld = Instance.new("WeldConstraint")
                weld.Part0 = desyncPart
                weld.Part1 = clonePart
                weld.Parent = desyncPart
            end
        end
        
        -- Hacer tu personaje invisible para otros
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.Transparency = 0.5 -- Semi-transparente para ti
            end
        end
        
        -- Cambiar UI
        desyncButton.Text = "SINCRONIZAR"
        desyncButton.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
        
        -- Efecto visual
        local tween = TweenService:Create(mainFrame, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(25, 45, 25)
        })
        tween:Play()
        
        print("✅ Desync activado - Otros jugadores te verán en la posición original")
        
    else
        -- DESACTIVAR DESYNC
        isDesynced = false
        
        -- Eliminar parte de desync
        if desyncPart then
            desyncPart:Destroy()
            desyncPart = nil
        end
        
        -- Restaurar visibilidad
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.Transparency = 0 -- Completamente visible
            end
        end
        
        -- Restaurar UI
        desyncButton.Text = "DESINCRONIZAR"
        desyncButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
        
        -- Restaurar color
        local tween = TweenService:Create(mainFrame, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        })
        tween:Play()
        
        print("❌ Desync desactivado")
    end
end

-- Conectar botón
desyncButton.MouseButton1Click:Connect(toggleDesync)

-- Efectos hover
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

-- Limpiar al morir/reaparecer
player.CharacterRemoving:Connect(function()
    if desyncPart then
        desyncPart:Destroy()
        desyncPart = nil
    end
    isDesynced = false
    desyncButton.Text = "DESINCRONIZAR"
    desyncButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    
    local tween = TweenService:Create(mainFrame, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    })
    tween:Play()
end)

print("✅ GUI Desync V2 cargado - Ahora puedes moverte libremente!")
