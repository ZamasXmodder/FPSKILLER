-- Script para obtener información del servidor actual
-- Ejecuta esto en tu servidor y copia la información que aparezca

-- Crear GUI para mostrar la información
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TitleLabel = Instance.new("TextLabel")
local InfoFrame = Instance.new("ScrollingFrame")
local CloseButton = Instance.new("TextButton")
local CopyButton = Instance.new("TextButton")

-- Configurar ScreenGui
ScreenGui.Name = "ServerInfoGUI"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Frame principal
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
MainFrame.Size = UDim2.new(0, 500, 0, 400)
MainFrame.Active = true
MainFrame.Draggable = true

-- Esquinas redondeadas
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = MainFrame

-- Título
TitleLabel.Name = "TitleLabel"
TitleLabel.Parent = MainFrame
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.Size = UDim2.new(1, 0, 0, 50)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "SERVER INFO"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 20

-- Frame de información
InfoFrame.Name = "InfoFrame"
InfoFrame.Parent = MainFrame
InfoFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
InfoFrame.BorderSizePixel = 0
InfoFrame.Position = UDim2.new(0, 10, 0, 60)
InfoFrame.Size = UDim2.new(1, -20, 1, -120)
InfoFrame.ScrollBarThickness = 5

local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 5)
infoCorner.Parent = InfoFrame

-- Botón Cerrar
CloseButton.Name = "CloseButton"
CloseButton.Parent = MainFrame
CloseButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(1, -80, 1, -40)
CloseButton.Size = UDim2.new(0, 70, 0, 30)
CloseButton.Font = Enum.Font.Gotham
CloseButton.Text = "Cerrar"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 5)
closeCorner.Parent = CloseButton

-- Botón Copiar
CopyButton.Name = "CopyButton"
CopyButton.Parent = MainFrame
CopyButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
CopyButton.BorderSizePixel = 0
CopyButton.Position = UDim2.new(0, 10, 1, -40)
CopyButton.Size = UDim2.new(0, 100, 0, 30)
CopyButton.Font = Enum.Font.Gotham
CopyButton.Text = "Copiar Info"
CopyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyButton.TextSize = 14

local copyCorner = Instance.new("UICorner")
copyCorner.CornerRadius = UDim.new(0, 5)
copyCorner.Parent = CopyButton

-- Función para recopilar información del servidor
local function getServerInfo()
    local info = ""
    
    info = info .. "=== INFORMACIÓN DEL SERVIDOR ===\n\n"
    
    -- Place ID (lo más importante)
    info = info .. "Place ID: " .. tostring(game.PlaceId) .. "\n"
    
    -- Job ID del servidor actual
    info = info .. "Job ID: " .. tostring(game.JobId) .. "\n"
    
    -- Private Server ID (si es VIP server)
    if game.PrivateServerId ~= "" then
        info = info .. "Private Server ID: " .. tostring(game.PrivateServerId) .. "\n"
    else
        info = info .. "Private Server ID: No es servidor privado\n"
    end
    
    -- VIP Server ID
    if game.VIPServerId ~= "" then
        info = info .. "VIP Server ID: " .. tostring(game.VIPServerId) .. "\n"
    else
        info = info .. "VIP Server ID: No es VIP server\n"
    end
    
    -- Nombre del juego
    info = info .. "Game Name: " .. tostring(game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name) .. "\n"
    
    -- Información adicional
    info = info .. "\n=== INFORMACIÓN ADICIONAL ===\n"
    info = info .. "Server Region: " .. tostring(game.LocalizationService.RobloxLocaleId) .. "\n"
    info = info .. "Players Online: " .. tostring(#game.Players:GetPlayers()) .. "\n"
    info = info .. "Max Players: " .. tostring(game.Players.MaxPlayers) .. "\n"
    info = info .. "Creation Time: " .. tostring(workspace.DistributedGameTime) .. " segundos\n"
    
    info = info .. "\n=== PARA EL SCRIPT DE TELEPORT ===\n"
    info = info .. "placeId = " .. tostring(game.PlaceId) .. "\n"
    info = info .. 'jobId = "' .. tostring(game.JobId) .. '"\n'
    if game.PrivateServerId ~= "" then
        info = info .. 'privateServerId = "' .. tostring(game.PrivateServerId) .. '"\n'
    end
    
    return info
end

-- Crear label para mostrar la información
local InfoLabel = Instance.new("TextLabel")
InfoLabel.Name = "InfoLabel"
InfoLabel.Parent = InfoFrame
InfoLabel.BackgroundTransparency = 1
InfoLabel.Position = UDim2.new(0, 10, 0, 10)
InfoLabel.Size = UDim2.new(1, -20, 1, -20)
InfoLabel.Font = Enum.Font.Code
InfoLabel.Text = getServerInfo()
InfoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
InfoLabel.TextSize = 12
InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
InfoLabel.TextYAlignment = Enum.TextYAlignment.Top
InfoLabel.TextWrapped = true

-- Ajustar el tamaño del contenido para el scroll
local textService = game:GetService("TextService")
local textSize = textService:GetTextSize(InfoLabel.Text, InfoLabel.TextSize, InfoLabel.Font, Vector2.new(InfoLabel.AbsoluteSize.X, math.huge))
InfoLabel.Size = UDim2.new(1, -20, 0, textSize.Y + 20)
InfoFrame.CanvasSize = UDim2.new(0, 0, 0, textSize.Y + 40)

-- Variable global para copiar
_G.ServerInfoText = getServerInfo()

-- También mostrar en consola
print("====================================")
print("SERVER INFO SCRIPT")
print("====================================")
print(getServerInfo())
print("====================================")
print("INFO GUARDADA EN _G.ServerInfoText")
print("====================================")

-- Funciones de los botones
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

CopyButton.MouseButton1Click:Connect(function()
    -- Notificación de que se copió
    local notification = Instance.new("TextLabel")
    notification.Parent = ScreenGui
    notification.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    notification.BorderSizePixel = 0
    notification.Position = UDim2.new(0.5, -100, 0, 20)
    notification.Size = UDim2.new(0, 200, 0, 40)
    notification.Font = Enum.Font.Gotham
    notification.Text = "¡Información copiada!"
    notification.TextColor3 = Color3.fromRGB(255, 255, 255)
    notification.TextSize = 14
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 5)
    notifCorner.Parent = notification
    
    -- Hacer que desaparezca
    game:GetService("TweenService"):Create(notification, TweenInfo.new(2), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
    game:GetService("Debris"):AddItem(notification, 2)
    
    -- La info ya está en _G.ServerInfoText y en la consola
    print("INFO COPIADA - Revisa _G.ServerInfoText o la consola")
end)

-- Mensaje final
print("\n¡SCRIPT EJECUTADO EXITOSAMENTE!")
print("- Revisa la ventana que apareció")
print("- Toda la info también está en la consola")
print("- Usa _G.ServerInfoText para acceder a la info")
