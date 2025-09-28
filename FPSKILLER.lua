-- GUI SCRIPT PARA TELEPORT AUTOMÁTICO
-- Script para unirse automáticamente al servidor específico

-- Información del servidor objetivo
local TARGET_PLACE_ID = 109983668079237
local TARGET_JOB_ID = "a0ff3820-5141-4cd9-ae1a-f6097a0e2199"
local SERVER_NAME = "Steal a Braincrot - Server Privado"

-- Servicios necesarios
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

-- Crear GUI
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TitleLabel = Instance.new("TextLabel")
local ServerInfoLabel = Instance.new("TextLabel")
local JoinButton = Instance.new("TextButton")
local StatusLabel = Instance.new("TextLabel")
local CloseButton = Instance.new("TextButton")

-- Configurar ScreenGui
ScreenGui.Name = "ServerJoinGUI"
ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Frame principal con gradiente
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Active = true
MainFrame.Draggable = true

-- Esquinas redondeadas para el frame principal
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = MainFrame

-- Gradiente de fondo
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 45, 65)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 35))
}
gradient.Rotation = 45
gradient.Parent = MainFrame

-- Sombra del frame
local shadow = Instance.new("Frame")
shadow.Name = "Shadow"
shadow.Parent = ScreenGui
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.7
shadow.BorderSizePixel = 0
shadow.Position = UDim2.new(0.5, -198, 0.5, -148)
shadow.Size = UDim2.new(0, 404, 0, 304)
shadow.ZIndex = MainFrame.ZIndex - 1

local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 12)
shadowCorner.Parent = shadow

-- Título
TitleLabel.Name = "TitleLabel"
TitleLabel.Parent = MainFrame
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 0, 0, 10)
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "🎮 SERVER JOIN"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 22
TitleLabel.TextStrokeTransparency = 0.8
TitleLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

-- Información del servidor
ServerInfoLabel.Name = "ServerInfoLabel"
ServerInfoLabel.Parent = MainFrame
ServerInfoLabel.BackgroundTransparency = 1
ServerInfoLabel.Position = UDim2.new(0, 20, 0, 60)
ServerInfoLabel.Size = UDim2.new(1, -40, 0, 80)
ServerInfoLabel.Font = Enum.Font.Gotham
ServerInfoLabel.Text = "🍃 " .. SERVER_NAME .. "\n\n📍 Place ID: " .. TARGET_PLACE_ID .. "\n🔗 Server: Privado"
ServerInfoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
ServerInfoLabel.TextSize = 14
ServerInfoLabel.TextXAlignment = Enum.TextXAlignment.Left
ServerInfoLabel.TextYAlignment = Enum.TextYAlignment.Top
ServerInfoLabel.TextWrapped = true

-- Botón de Join (Principal)
JoinButton.Name = "JoinButton"
JoinButton.Parent = MainFrame
JoinButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
JoinButton.BorderSizePixel = 0
JoinButton.Position = UDim2.new(0.5, -80, 0, 160)
JoinButton.Size = UDim2.new(0, 160, 0, 45)
JoinButton.Font = Enum.Font.GothamBold
JoinButton.Text = "🚀 JOIN SERVER"
JoinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
JoinButton.TextSize = 16
JoinButton.TextStrokeTransparency = 0.8

-- Esquinas redondeadas para el botón
local joinCorner = Instance.new("UICorner")
joinCorner.CornerRadius = UDim.new(0, 8)
joinCorner.Parent = JoinButton

-- Gradiente del botón
local joinGradient = Instance.new("UIGradient")
joinGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 180, 60)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 120, 40))
}
joinGradient.Rotation = 90
joinGradient.Parent = JoinButton

-- Label de status
StatusLabel.Name = "StatusLabel"
StatusLabel.Parent = MainFrame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 20, 0, 220)
StatusLabel.Size = UDim2.new(1, -40, 0, 30)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Text = "⚡ Presiona JOIN para conectar al servidor"
StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusLabel.TextSize = 12
StatusLabel.TextWrapped = true

-- Botón Cerrar
CloseButton.Name = "CloseButton"
CloseButton.Parent = MainFrame
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(1, -35, 0, 10)
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 50)
closeCorner.Parent = CloseButton

-- Funciones de los botones
CloseButton.MouseButton1Click:Connect(function()
    -- Animación de cierre
    local closeTween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size = UDim2.new(0, 0, 0, 0)})
    closeTween:Play()
    closeTween.Completed:Connect(function()
        ScreenGui:Destroy()
    end)
end)

-- Función principal de teleport
local function joinServer()
    StatusLabel.Text = "🔄 Conectando al servidor..."
    StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
    
    JoinButton.Text = "⏳ CONECTANDO..."
    JoinButton.BackgroundColor3 = Color3.fromRGB(150, 150, 50)
    
    -- Intentar teleport
    pcall(function()
        print("🚀 Intentando conectar al servidor...")
        print("Place ID:", TARGET_PLACE_ID)
        print("Job ID:", TARGET_JOB_ID)
        
        -- Método 1: TeleportToPlaceInstance (más directo)
        TeleportService:TeleportToPlaceInstance(TARGET_PLACE_ID, TARGET_JOB_ID, Players.LocalPlayer)
    end)
    
    -- Si el método principal falla, intentar método alternativo
    wait(2)
    
    if Players.LocalPlayer.Parent then
        StatusLabel.Text = "⚠️ Probando método alternativo..."
        
        pcall(function()
            -- Método 2: Teleport normal
            TeleportService:Teleport(TARGET_PLACE_ID, Players.LocalPlayer)
        end)
        
        wait(2)
        
        if Players.LocalPlayer.Parent then
            StatusLabel.Text = "❌ Error: No se pudo conectar automáticamente"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            JoinButton.Text = "🚀 REINTENTAR"
            JoinButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
            
            print("❌ Teleport falló - El servidor podría estar offline o el Job ID cambió")
        end
    end
end

-- Conectar función al botón
JoinButton.MouseButton1Click:Connect(joinServer)

-- Efectos de hover para el botón
JoinButton.MouseEnter:Connect(function()
    local hoverTween = TweenService:Create(JoinButton, TweenInfo.new(0.2), {Size = UDim2.new(0, 170, 0, 48)})
    hoverTween:Play()
end)

JoinButton.MouseLeave:Connect(function()
    local leaveTween = TweenService:Create(JoinButton, TweenInfo.new(0.2), {Size = UDim2.new(0, 160, 0, 45)})
    leaveTween:Play()
end)

-- Animación de entrada
MainFrame.Size = UDim2.new(0, 0, 0, 0)
local openTween = TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Size = UDim2.new(0, 400, 0, 300)})
openTween:Play()

-- Mensajes en consola
print("====================================")
print("🎮 SERVER JOIN SCRIPT CARGADO")
print("====================================")
print("📍 Target Place ID:", TARGET_PLACE_ID)
print("🔗 Target Job ID:", TARGET_JOB_ID)
print("🎯 Server:", SERVER_NAME)
print("====================================")
print("✅ GUI creado exitosamente!")
print("💡 Presiona el botón JOIN para conectar")
print("====================================")
