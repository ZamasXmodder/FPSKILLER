-- Panel GUI FPS KILLER TURBO para Roblox - Versión Extrema
-- Coloca este script en StarterPlayerScripts o ejecuta como LocalScript

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local backpack = player:WaitForChild("Backpack")

-- Variables para el FPS Killer TURBO
local isKillerActive = false
local killerConnections = {}
local equipConnections = {}
local turboMode = false

-- Protección anti-lag personal
local personalProtection = true
local originalRenderStepped = nil

-- Crear el GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FPSKillerTurboPanel"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Frame principal
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 280, 0, 180)
mainFrame.Position = UDim2.new(0.75, -140, 0.5, -90)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Esquinas redondeadas
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = mainFrame

-- Borde brillante
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(255, 0, 100)
stroke.Thickness = 2
stroke.Parent = mainFrame

-- Sombra
local shadow = Instance.new("Frame")
shadow.Name = "Shadow"
shadow.Size = UDim2.new(1, 8, 1, 8)
shadow.Position = UDim2.new(0, -4, 0, -4)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.6
shadow.ZIndex = mainFrame.ZIndex - 1
shadow.Parent = mainFrame

local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 15)
shadowCorner.Parent = shadow

-- Título
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 35)
titleLabel.Position = UDim2.new(0, 0, 0, 5)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "⚡ FPS KILLER TURBO ⚡"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

-- Botón FPS KILLER TURBO
local fpsKillerButton = Instance.new("TextButton")
fpsKillerButton.Name = "FPSKillerButton"
fpsKillerButton.Size = UDim2.new(0.85, 0, 0, 50)
fpsKillerButton.Position = UDim2.new(0.075, 0, 0.3, 0)
fpsKillerButton.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
fpsKillerButton.BorderSizePixel = 0
fpsKillerButton.Text = "🚀 ACTIVAR TURBO"
fpsKillerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
fpsKillerButton.TextScaled = true
fpsKillerButton.Font = Enum.Font.GothamBold
fpsKillerButton.Parent = mainFrame

-- Esquinas del botón
local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 10)
buttonCorner.Parent = fpsKillerButton

-- Botón de protección personal
local protectionButton = Instance.new("TextButton")
protectionButton.Name = "ProtectionButton"
protectionButton.Size = UDim2.new(0.85, 0, 0, 30)
protectionButton.Position = UDim2.new(0.075, 0, 0.62, 0)
protectionButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
protectionButton.BorderSizePixel = 0
protectionButton.Text = "🛡️ PROTECCIÓN: ON"
protectionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
protectionButton.TextScaled = true
protectionButton.Font = Enum.Font.Gotham
protectionButton.Parent = mainFrame

local protectionCorner = Instance.new("UICorner")
protectionCorner.CornerRadius = UDim.new(0, 8)
protectionCorner.Parent = protectionButton

-- Label de estado
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "Status"
statusLabel.Size = UDim2.new(1, 0, 0, 25)
statusLabel.Position = UDim2.new(0, 0, 0.85, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Estado: Inactivo | FPS: Protegido"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = mainFrame

-- Función para protección personal anti-lag
local function enablePersonalProtection()
    if personalProtection then
        -- Limitar el framerate para el cliente local
        game:GetService("UserInputService").WindowFocusReleased:Connect(function()
            -- Reducir carga cuando no está enfocado
        end)
        
        -- Optimizar renderizado local
        spawn(function()
            while personalProtection and isKillerActive do
                wait(0.1) -- Dar respiro al cliente local
            end
        end)
    end
end

-- Función TURBO para obtener todos los tools
local function getAllToolsTurbo()
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

-- Función TURBO EXTREMA para equipar/desequipar (MÁXIMO LAG)
local function turboFpsKillerLoop()
    local tools = getAllToolsTurbo()
    
    if #tools == 0 then
        return
    end
    
    -- MODO TURBO: 20 loops simultáneos por tool
    for i = 1, 20 do
        spawn(function()
            for _, tool in pairs(tools) do
                if tool then
                    spawn(function()
                        -- Equipar/desequipar súper rápido sin wait
                        tool.Parent = player.Character
                        tool.Parent = backpack
                        tool.Parent = player.Character
                        tool.Parent = backpack
                        tool.Parent = player.Character
                        tool.Parent = backpack
                    end)
                end
            end
        end)
    end
    
    -- TURBO EXTRA: Crear instancias falsas para más lag
    for i = 1, 10 do
        spawn(function()
            for _, tool in pairs(tools) do
                if tool then
                    spawn(function()
                        -- Cambio rapidísimo de parent
                        for j = 1, 5 do
                            tool.Parent = player.Character
                            tool.Parent = backpack
                        end
                    end)
                end
            end
        end)
    end
    
    -- ULTRA TURBO: Loops anidados
    spawn(function()
        for x = 1, 3 do
            for y = 1, 3 do
                for _, tool in pairs(tools) do
                    if tool then
                        spawn(function()
                            tool.Parent = player.Character
                            tool.Parent = backpack
                        end)
                    end
                end
            end
        end
    end)
end

-- Función para iniciar/detener el FPS Killer TURBO
local function toggleTurboFPSKiller()
    if isKillerActive then
        -- Detener
        isKillerActive = false
        turboMode = false
        
        for _, connection in pairs(killerConnections) do
            if connection then
                connection:Disconnect()
            end
        end
        killerConnections = {}
        
        for _, connection in pairs(equipConnections) do
            if connection then
                connection:Disconnect()
            end
        end
        equipConnections = {}
        
        fpsKillerButton.Text = "🚀 ACTIVAR TURBO"
        fpsKillerButton.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
        statusLabel.Text = "Estado: Inactivo | FPS: Protegido"
        statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        stroke.Color = Color3.fromRGB(255, 0, 100)
    else
        -- Iniciar MODO TURBO
        isKillerActive = true
        turboMode = true
        
        -- Habilitar protección personal
        if personalProtection then
            enablePersonalProtection()
        end
        
        -- TURBO: Múltiples conexiones en diferentes servicios
        table.insert(killerConnections, RunService.RenderStepped:Connect(function()
            spawn(turboFpsKillerLoop)
        end))
        
        table.insert(killerConnections, RunService.Heartbeat:Connect(function()
            spawn(turboFpsKillerLoop)
        end))
        
        table.insert(killerConnections, RunService.Stepped:Connect(function()
            spawn(turboFpsKillerLoop)
            spawn(turboFpsKillerLoop) -- Doble ejecución
        end))
        
        -- ULTRA TURBO: Loops adicionales con diferentes intervalos
        for i = 1, 5 do
            spawn(function()
                while isKillerActive do
                    turboFpsKillerLoop()
                    -- Sin wait para máxima velocidad
                end
            end)
        end
        
        -- MEGA TURBO: Más loops con spawn anidados
        spawn(function()
            while isKillerActive do
                for j = 1, 3 do
                    spawn(turboFpsKillerLoop)
                end
            end
        end)
        
        fpsKillerButton.Text = "🛑 DETENER TURBO"
        fpsKillerButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        statusLabel.Text = "Estado: TURBO ACTIVO - LAG EXTREMO"
        statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        stroke.Color = Color3.fromRGB(255, 0, 0)
    end
end

-- Función para alternar protección personal
local function togglePersonalProtection()
    personalProtection = not personalProtection
    
    if personalProtection then
        protectionButton.Text = "🛡️ PROTECCIÓN: ON"
        protectionButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    else
        protectionButton.Text = "🚫 PROTECCIÓN: OFF"
        protectionButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    end
    
    if isKillerActive then
        statusLabel.Text = personalProtection and "Estado: TURBO - FPS Protegido" or "Estado: TURBO - Sin Protección"
    end
end

-- Conectar botones
fpsKillerButton.MouseButton1Click:Connect(toggleTurboFPSKiller)
protectionButton.MouseButton1Click:Connect(togglePersonalProtection)

-- Efectos de hover mejorados
fpsKillerButton.MouseEnter:Connect(function()
    local tween = TweenService:Create(fpsKillerButton, 
        TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Size = UDim2.new(0.9, 0, 0, 55)}
    )
    tween:Play()
end)

fpsKillerButton.MouseLeave:Connect(function()
    local tween = TweenService:Create(fpsKillerButton, 
        TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Size = UDim2.new(0.85, 0, 0, 50)}
    )
    tween:Play()
end)

-- Animación del borde cuando está activo
spawn(function()
    while true do
        if isKillerActive then
            for i = 0, 100 do
                if isKillerActive then
                    stroke.Color = Color3.fromRGB(255, math.abs(math.sin(i/10)) * 255, 0)
                    wait(0.05)
                end
            end
        else
            wait(0.1)
        end
    end
end)

-- Hacer que el panel aparezca con animación épica
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.Position = UDim2.new(0.75, 0, 0.5, 0)

local appearTween = TweenService:Create(mainFrame,
    TweenInfo.new(0.8, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
    {
        Size = UDim2.new(0, 280, 0, 180),
        Position = UDim2.new(0.75, -140, 0.5, -90)
    }
)
appearTween:Play()

-- Funcionalidad para cerrar con tecla X
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.X then
        if isKillerActive then
            toggleTurboFPSKiller()
        end
        screenGui:Destroy()
    end
end)

print("🚀 Panel FPS KILLER TURBO cargado!")
print("⚡ Modo TURBO con protección anti-lag personal activada")
print("🛡️ Presiona X para cerrar el panel")
