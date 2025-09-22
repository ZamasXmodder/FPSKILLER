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

-- Función para crear lag REAL del servidor (afecta a TODOS)
local function startFPSKiller()
    local backpack = player:WaitForChild("Backpack")
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    
    lagConnection = RunService.Heartbeat:Connect(function()
        -- MÉTODO 1: SPAM DE NETWORK EVENTS (equipar/desequipar MASIVO)
        spawn(function()
            for cycle = 1, 5 do
                for _, tool in ipairs(backpack:GetChildren()) do
                    if tool:IsA("Tool") then
                        -- Super spam que satura la red
                        for spam = 1, 200 do
                            humanoid:EquipTool(tool)
                            humanoid:UnequipTools()
                            -- Sin delays para saturar completamente
                        end
                    end
                end
            end
        end)
        
        -- MÉTODO 2: CREAR OBJETOS EN EL WORKSPACE QUE TODOS VEAN
        spawn(function()
            for i = 1, 150 do
                local part = Instance.new("Part")
                part.Name = "ServerLag_" .. tick() .. "_" .. i
                part.Parent = workspace
                part.Anchored = false
                part.CanCollide = true -- Importante: colisiones activas
                part.Size = Vector3.new(
                    math.random(5, 20),
                    math.random(5, 20), 
                    math.random(5, 20)
                )
                part.Position = Vector3.new(
                    math.random(-500, 500),
                    math.random(100, 300),
                    math.random(-500, 500)
                )
                part.BrickColor = BrickColor.Random()
                part.Material = Enum.Material.Neon
                
                -- Físicas que el servidor debe calcular
                local bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.Parent = part
                bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bodyVelocity.Velocity = Vector3.new(
                    math.random(-100, 100),
                    math.random(-100, 100),
                    math.random(-100, 100)
                )
                
                -- Rotación para más cálculos
                local bodyAngularVelocity = Instance.new("BodyAngularVelocity")
                bodyAngularVelocity.Parent = part
                bodyAngularVelocity.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                bodyAngularVelocity.AngularVelocity = Vector3.new(
                    math.random(-50, 50),
                    math.random(-50, 50),
                    math.random(-50, 50)
                )
                
                -- Limpiar después para evitar crash completo
                game:GetService("Debris"):AddItem(part, 2)
            end
        end)
        
        -- MÉTODO 3: MANIPULAR TU PERSONAJE DE FORMA QUE CAUSE LAG DE RED
        spawn(function()
            if character:FindFirstChild("HumanoidRootPart") then
                local rootPart = character.HumanoidRootPart
                
                -- Movimientos bruscos que se replican
                for movement = 1, 50 do
                    rootPart.Velocity = Vector3.new(
                        math.random(-200, 200),
                        math.random(-50, 50),
                        math.random(-200, 200)
                    )
                    
                    -- Teletransporte spam (genera muchos eventos)
                    rootPart.CFrame = rootPart.CFrame + Vector3.new(
                        math.random(-10, 10),
                        0,
                        math.random(-10, 10)
                    )
                    
                    -- Cambios en humanoid que se replican
                    humanoid.WalkSpeed = math.random(0, 100)
                    humanoid.JumpPower = math.random(0, 200)
                end
            end
        end)
        
        -- MÉTODO 4: SPAM EXTREMO DE TOOLS (el más efectivo)
        spawn(function()
            local tools = {}
            -- Crear lista de tools
            for _, tool in ipairs(backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    table.insert(tools, tool)
                end
            end
            
            -- Si tienes tools, hacer spam masivo
            if #tools > 0 then
                for megaSpam = 1, 10 do
                    for _, tool in ipairs(tools) do
                        for ultraSpam = 1, 100 do
                            humanoid:EquipTool(tool)
                            if tool:FindFirstChild("Handle") then
                                tool:Activate()
                                tool:Deactivate()
                            end
                            humanoid:UnequipTools()
                        end
                    end
                end
            end
        end)
        
        -- MÉTODO 5: CREAR MÚLTIPLES MODELOS COMPLEJOS
        spawn(function()
            for model = 1, 20 do
                local newModel = Instance.new("Model")
                newModel.Name = "LagModel_" .. model
                newModel.Parent = workspace
                
                -- Crear múltiples partes en cada modelo
                for part = 1, 10 do
                    local modelPart = Instance.new("Part")
                    modelPart.Parent = newModel
                    modelPart.Size = Vector3.new(math.random(1,5), math.random(1,5), math.random(1,5))
                    modelPart.Position = character.HumanoidRootPart.Position + Vector3.new(
                        math.random(-100, 100),
                        math.random(10, 50),
                        math.random(-100, 100)
                    )
                    modelPart.BrickColor = BrickColor.Random()
                    modelPart.CanCollide = true
                    
                    -- Welds complejos que causan cálculos
                    if part > 1 then
                        local weld = Instance.new("WeldConstraint")
                        weld.Parent = modelPart
                        weld.Part0 = modelPart
                        weld.Part1 = newModel:GetChildren()[part-1]
                    end
                end
                
                game:GetService("Debris"):AddItem(newModel, 3)
            end
        end)
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
