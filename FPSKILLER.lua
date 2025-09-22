-- Panel GUI FPS KILLER INTELIGENTE - Lag para otros, smooth para ti
-- Coloca este script en StarterPlayerScripts o ejecuta como LocalScript

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local backpack = player:WaitForChild("Backpack")

-- Variables para el FPS Killer INTELIGENTE
local isKillerActive = false
local killerConnections = {}
local lagIntensity = 1

-- Crear el GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FPSKillerSmartPanel"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Frame principal
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 220)
mainFrame.Position = UDim2.new(0.75, -150, 0.5, -110)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Esquinas redondeadas
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- Borde
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(100, 200, 255)
stroke.Thickness = 2
stroke.Parent = mainFrame

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
titleLabel.Size = UDim2.new(1, 0, 0, 35)
titleLabel.Position = UDim2.new(0, 0, 0, 5)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🧠 FPS KILLER SMART"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

-- Botón FPS KILLER principal
local fpsKillerButton = Instance.new("TextButton")
fpsKillerButton.Name = "FPSKillerButton"
fpsKillerButton.Size = UDim2.new(0.85, 0, 0, 45)
fpsKillerButton.Position = UDim2.new(0.075, 0, 0.22, 0)
fpsKillerButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
fpsKillerButton.BorderSizePixel = 0
fpsKillerButton.Text = "🔥 INICIAR SMART LAG"
fpsKillerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
fpsKillerButton.TextScaled = true
fpsKillerButton.Font = Enum.Font.GothamBold
fpsKillerButton.Parent = mainFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = fpsKillerButton

-- Label de intensidad
local intensityLabel = Instance.new("TextLabel")
intensityLabel.Name = "IntensityLabel"
intensityLabel.Size = UDim2.new(0.4, 0, 0, 25)
intensityLabel.Position = UDim2.new(0.075, 0, 0.45, 0)
intensityLabel.BackgroundTransparency = 1
intensityLabel.Text = "Intensidad: 1x"
intensityLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
intensityLabel.TextScaled = true
intensityLabel.Font = Enum.Font.Gotham
intensityLabel.Parent = mainFrame

-- Slider de intensidad
local intensitySlider = Instance.new("Frame")
intensitySlider.Name = "IntensitySlider"
intensitySlider.Size = UDim2.new(0.5, 0, 0, 20)
intensitySlider.Position = UDim2.new(0.475, 0, 0.47, 0)
intensitySlider.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
intensitySlider.BorderSizePixel = 0
intensitySlider.Parent = mainFrame

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(0, 10)
sliderCorner.Parent = intensitySlider

local sliderButton = Instance.new("TextButton")
sliderButton.Name = "SliderButton"
sliderButton.Size = UDim2.new(0.2, 0, 1, 0)
sliderButton.Position = UDim2.new(0, 0, 0, 0)
sliderButton.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
sliderButton.BorderSizePixel = 0
sliderButton.Text = ""
sliderButton.Parent = intensitySlider

local sliderButtonCorner = Instance.new("UICorner")
sliderButtonCorner.CornerRadius = UDim.new(1, 0)
sliderButtonCorner.Parent = sliderButton

-- Botón de modo seguro
local safeButton = Instance.new("TextButton")
safeButton.Name = "SafeButton"
safeButton.Size = UDim2.new(0.4, 0, 0, 30)
safeButton.Position = UDim2.new(0.075, 0, 0.62, 0)
safeButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
safeButton.BorderSizePixel = 0
safeButton.Text = "🛡️ MODO SEGURO"
safeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
safeButton.TextScaled = true
safeButton.Font = Enum.Font.Gotham
safeButton.Parent = mainFrame

local safeCorner = Instance.new("UICorner")
safeCorner.CornerRadius = UDim.new(0, 6)
safeCorner.Parent = safeButton

-- Botón de parada de emergencia
local emergencyButton = Instance.new("TextButton")
emergencyButton.Name = "EmergencyButton"
emergencyButton.Size = UDim2.new(0.4, 0, 0, 30)
emergencyButton.Position = UDim2.new(0.525, 0, 0.62, 0)
emergencyButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
emergencyButton.BorderSizePixel = 0
emergencyButton.Text = "⛔ PARADA"
emergencyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
emergencyButton.TextScaled = true
emergencyButton.Font = Enum.Font.Gotham
emergencyButton.Parent = mainFrame

local emergencyCorner = Instance.new("UICorner")
emergencyCorner.CornerRadius = UDim.new(0, 6)
emergencyCorner.Parent = emergencyButton

-- Label de estado
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "Status"
statusLabel.Size = UDim2.new(1, 0, 0, 25)
statusLabel.Position = UDim2.new(0, 0, 0.8, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Estado: Inactivo - Tu FPS: Protegido"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = mainFrame

-- FPS Counter para ti
local fpsLabel = Instance.new("TextLabel")
fpsLabel.Name = "FPSLabel"
fpsLabel.Size = UDim2.new(1, 0, 0, 20)
fpsLabel.Position = UDim2.new(0, 0, 0.9, 0)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Text = "Tu FPS: 60"
fpsLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
fpsLabel.TextScaled = true
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.Parent = mainFrame

-- Función para obtener tools de forma inteligente
local function getToolsSmarter()
    local tools = {}
    for _, tool in pairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            table.insert(tools, tool)
        end
    end
    
    if player.Character then
        for _, tool in pairs(player.Character:GetChildren()) do
            if tool:IsA("Tool") then
                table.insert(tools, tool)
            end
        end
    end
    
    return tools
end

-- Función SMART de lag (controlado para no afectarte)
local function smartLagLoop()
    local tools = getToolsSmarter()
    if #tools == 0 then return end
    
    -- Lag controlado basado en intensidad
    local loops = math.min(lagIntensity * 2, 10) -- Máximo 10 loops
    
    for i = 1, loops do
        spawn(function()
            for _, tool in pairs(tools) do
                if tool and isKillerActive then
                    spawn(function()
                        -- Equipar/desequipar con control
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

-- FPS Counter personal
local frameCount = 0
local lastTime = tick()
spawn(function()
    RunService.Heartbeat:Connect(function()
        frameCount = frameCount + 1
        local currentTime = tick()
        if currentTime - lastTime >= 1 then
            local fps = math.floor(frameCount / (currentTime - lastTime))
            fpsLabel.Text = "Tu FPS: " .. fps
            fpsLabel.TextColor3 = fps > 45 and Color3.fromRGB(0, 255, 0) or 
                                  fps > 25 and Color3.fromRGB(255, 255, 0) or 
                                  Color3.fromRGB(255, 0, 0)
            frameCount = 0
            lastTime = currentTime
        end
    end)
end)

-- Función para el slider
local dragging = false
sliderButton.MouseButton1Down:Connect(function()
    dragging = true
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mouse = Players.LocalPlayer:GetMouse()
        local sliderPos = intensitySlider.AbsolutePosition
        local sliderSize = intensitySlider.AbsoluteSize
        
        local relativeX = mouse.X - sliderPos.X
        local percentage = math.clamp(relativeX / sliderSize.X, 0, 1)
        
        sliderButton.Position = UDim2.new(percentage * 0.8, 0, 0, 0)
        lagIntensity = math.floor(percentage * 5) + 1 -- 1 a 6
        intensityLabel.Text = "Intensidad: " .. lagIntensity .. "x"
    end
end)

-- Función principal SMART
local function toggleSmartLag()
    if isKillerActive then
        -- Detener todo
        isKillerActive = false
        
        for _, connection in pairs(killerConnections) do
            if connection then connection:Disconnect() end
        end
        killerConnections = {}
        
        fpsKillerButton.Text = "🔥 INICIAR SMART LAG"
        fpsKillerButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
        statusLabel.Text = "Estado: Inactivo - Tu FPS: Protegido"
        stroke.Color = Color3.fromRGB(100, 200, 255)
    else
        -- Iniciar modo SMART
        isKillerActive = true
        
        -- Solo una conexión controlada
        table.insert(killerConnections, RunService.Heartbeat:Connect(function()
            if isKillerActive then
                spawn(smartLagLoop)
                wait(0.1) -- Pequeño delay para no saturarte
            end
        end))
        
        -- Loop adicional controlado
        spawn(function()
            while isKillerActive do
                smartLagLoop()
                wait(0.05 * (6 - lagIntensity)) -- Menos wait = más intensidad
            end
        end)
        
        fpsKillerButton.Text = "🛑 DETENER LAG"
        fpsKillerButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        statusLabel.Text = "Estado: SMART LAG ACTIVO - Intensidad " .. lagIntensity .. "x"
        stroke.Color = Color3.fromRGB(255, 100, 100)
    end
end

-- Modo seguro (intensidad 1)
safeButton.MouseButton1Click:Connect(function()
    lagIntensity = 1
    sliderButton.Position = UDim2.new(0, 0, 0, 0)
    intensityLabel.Text = "Intensidad: 1x"
    if isKillerActive then
        statusLabel.Text = "Estado: MODO SEGURO ACTIVO"
    end
end)

-- Parada de emergencia
emergencyButton.MouseButton1Click:Connect(function()
    if isKillerActive then
        toggleSmartLag()
    end
    -- Mini delay para que puedas hacer clic
    wait(0.5)
end)

-- Conectar botón principal
fpsKillerButton.MouseButton1Click:Connect(toggleSmartLag)

-- Animación de aparición
mainFrame.Size = UDim2.new(0, 0, 0, 0)
local appearTween = TweenService:Create(mainFrame,
    TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    {Size = UDim2.new(0, 300, 0, 220)}
)
appearTween:Play()

-- Cerrar con X
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.X then
        if isKillerActive then toggleSmartLag() end
        screenGui:Destroy()
    end
end)

print("🧠 FPS KILLER SMART cargado!")
print("🛡️ Versión inteligente que protege TU rendimiento")
print("⚡ Usa el slider para controlar la intensidad")
