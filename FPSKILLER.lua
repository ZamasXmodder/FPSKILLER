-- FPS Killer GUI Panel para Roblox
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables para el control del lag
local fpsKillerActive = false
local lagConnection

-- Crear el GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FPSKillerGui"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- Frame principal del panel
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainPanel"
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Position = UDim2.new(1, -160, 0.5, -75) -- Lado derecho, centrado verticalmente
mainFrame.Size = UDim2.new(0, 150, 0, 100)

-- Esquinas redondeadas
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- Borde del panel
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(60, 60, 65)
stroke.Thickness = 1
stroke.Parent = mainFrame

-- Título del panel
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Parent = mainFrame
title.BackgroundTransparency = 1
title.Position = UDim2.new(0, 0, 0, 5)
title.Size = UDim2.new(1, 0, 0, 25)
title.Font = Enum.Font.GothamBold
title.Text = "LAG PANEL"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 12
title.TextStrokeTransparency = 0.5

-- Botón FPS KILLER
local fpsKillerButton = Instance.new("TextButton")
fpsKillerButton.Name = "FPSKillerButton"
fpsKillerButton.Parent = mainFrame
fpsKillerButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
fpsKillerButton.BorderSizePixel = 0
fpsKillerButton.Position = UDim2.new(0, 10, 0, 35)
fpsKillerButton.Size = UDim2.new(1, -20, 0, 35)
fpsKillerButton.Font = Enum.Font.GothamBold
fpsKillerButton.Text = "FPS KILLER"
fpsKillerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
fpsKillerButton.TextSize = 11
fpsKillerButton.TextStrokeTransparency = 0.5

-- Esquinas redondeadas del botón
local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 6)
buttonCorner.Parent = fpsKillerButton

-- Indicador de estado
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Parent = mainFrame
statusLabel.BackgroundTransparency = 1
statusLabel.Position = UDim2.new(0, 0, 0, 75)
statusLabel.Size = UDim2.new(1, 0, 0, 20)
statusLabel.Font = Enum.Font.Gotham
statusLabel.Text = "INACTIVO"
statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
statusLabel.TextSize = 9
statusLabel.TextStrokeTransparency = 0.5

-- Función para crear lag MASIVO en el servidor (afecta a todos)
local function startFPSKiller()
    local backpack = player:WaitForChild("Backpack")
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    
    -- Crear múltiples conexiones para máximo lag
    lagConnection = RunService.Heartbeat:Connect(function()
        -- MÉTODO 1: SPAM EXTREMO DE TOOLS (necesitas muchos tools/accesorios)
        for cycle = 1, 3 do
            for _, tool in ipairs(backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    -- Super spam de equipar/desequipar
                    for rapid = 1, 100 do
                        humanoid:EquipTool(tool)
                        humanoid:UnequipTools() 
                        if tool:FindFirstChild("Handle") then
                            tool:Activate() -- Spam activate
                        end
                    end
                end
            end
        end
        
        -- MÉTODO 2: CREAR LAG CON ACCESORIOS DEL PERSONAJE
        for _, accessory in ipairs(character:GetChildren()) do
            if accessory:IsA("Accessory") and accessory:FindFirstChild("Handle") then
                local handle = accessory.Handle
                -- Spam de cambios en los accesorios
                for spam = 1, 50 do
                    handle.Transparency = math.random()
                    handle.Reflectance = math.random()
                    handle.Size = handle.Size * 0.99
                    handle.Size = handle.Size * 1.01
                    handle.CFrame = handle.CFrame * CFrame.Angles(0.1, 0.1, 0.1)
                end
            end
        end
        
        -- MÉTODO 3: CREAR PARTES CON EFECTOS EXTREMOS
        spawn(function()
            for i = 1, 200 do
                local part = Instance.new("Part")
                part.Parent = workspace
                part.Name = "LagPart"..i
                part.Position = character.HumanoidRootPart.Position + Vector3.new(math.random(-100,100), math.random(0,50), math.random(-100,100))
                part.Size = Vector3.new(math.random(1,10), math.random(1,10), math.random(1,10))
                part.Material = Enum.Material.ForceField
                part.BrickColor = BrickColor.Random()
                part.TopSurface = Enum.SurfaceType.Smooth
                part.CanCollide = false
                
                -- Añadir múltiples efectos físicos
                local bodyVelocity = Instance.new("BodyVelocity", part)
                bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bodyVelocity.Velocity = Vector3.new(math.random(-200,200), math.random(-200,200), math.random(-200,200))
                
                local bodyAngularVelocity = Instance.new("BodyAngularVelocity", part)
                bodyAngularVelocity.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                bodyAngularVelocity.AngularVelocity = Vector3.new(math.random(-50,50), math.random(-50,50), math.random(-50,50))
                
                -- Partículas para más lag visual
                local smoke = Instance.new("Smoke", part)
                smoke.Size = 10
                smoke.Opacity = 1
                
                local fire = Instance.new("Fire", part)
                fire.Size = 10
                fire.Heat = 10
                
                -- Sonidos spam
                local sound = Instance.new("Sound", part)
                sound.SoundId = "rbxasset://sounds/electronicpingshort.wav"
                sound.Volume = 0.1
                sound.Looped = true
                sound:Play()
                
                -- Destruir después de causar lag
                game:GetService("Debris"):AddItem(part, 0.5)
            end
        end)
        
        -- MÉTODO 4: MANIPULAR PERSONAJE DE FORMA EXTREMA
        spawn(function()
            for extreme = 1, 100 do
                if character and character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = character.HumanoidRootPart
                    -- Cambios extremos que se replican
                    rootPart.CFrame = rootPart.CFrame * CFrame.new(math.random(-1,1), 0, math.random(-1,1))
                    humanoid.JumpPower = math.random(0, 500)
                    humanoid.WalkSpeed = math.random(0, 500)
                    humanoid.MaxHealth = math.random(100, 1000)
                    humanoid.Health = humanoid.MaxHealth
                    
                    -- Spam de animaciones
                    humanoid.Sit = not humanoid.Sit
                    humanoid.PlatformStand = not humanoid.PlatformStand
                end
            end
        end)
        
        -- MÉTODO 5: SPAM DE REMOTE EVENTS (si hay tools con scripts)
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                spawn(function()
                    for remote = 1, 50 do
                        humanoid:EquipTool(tool)
                        if tool:FindFirstChild("Handle") then
                            tool:Activate()
                            tool:Deactivate()
                        end
                        humanoid:UnequipTools()
                    end
                end)
            end
        end
    end)
end

-- Función para detener el FPS Killer
local function stopFPSKiller()
    if lagConnection then
        lagConnection:Disconnect()
        lagConnection = nil
    end
end

-- Animaciones del botón
local function animateButton(scale)
    local tween = TweenService:Create(
        fpsKillerButton,
        TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Size = UDim2.new(1, -20 * scale, 0, 35 * scale)}
    )
    tween:Play()
end

-- Eventos del botón
fpsKillerButton.MouseEnter:Connect(function()
    animateButton(1.05)
end)

fpsKillerButton.MouseLeave:Connect(function()
    animateButton(1)
end)

-- Funcionalidad del botón FPS KILLER
fpsKillerButton.MouseButton1Click:Connect(function()
    fpsKillerActive = not fpsKillerActive
    
    if fpsKillerActive then
        fpsKillerButton.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
        fpsKillerButton.Text = "STOP KILLER"
        statusLabel.Text = "ACTIVO - LAGGING!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        startFPSKiller()
    else
        fpsKillerButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
        fpsKillerButton.Text = "FPS KILLER"
        statusLabel.Text = "INACTIVO"
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        stopFPSKiller()
    end
    
    -- Efecto de click
    animateButton(0.95)
    wait(0.1)
    animateButton(1)
end)

-- Hacer el panel arrastrable
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
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

mainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Limpiar al resetear el personaje
player.CharacterRemoving:Connect(function()
    stopFPSKiller()
    fpsKillerActive = false
    fpsKillerButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    fpsKillerButton.Text = "FPS KILLER"
    statusLabel.Text = "INACTIVO"
    statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
end)

print("FPS Killer GUI cargado exitosamente!")
