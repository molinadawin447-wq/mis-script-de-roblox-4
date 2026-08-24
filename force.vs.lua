--[[
    Script Local: Fenix Hub UI
    Hecho por: Tu Nombre
    Descripción: Interfaz organizada como en la imagen, con botones y funcionalidades básicas.
]]

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Configuración de la interfaz
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FenixHubGUI"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

-- Frame principal (con estilo oscuro y bordes redondeados)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 450) -- Tamaño compacto
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- Esquinas redondeadas (usando UICorner)
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = MainFrame

-- Título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
Title.Text = "FENIX HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Borde inferior del título
local TitleLine = Instance.new("Frame")
TitleLine.Size = UDim2.new(1, 0, 0, 2)
TitleLine.Position = UDim2.new(0, 0, 0, 30)
TitleLine.BackgroundColor3 = Color3.fromRGB(80, 80, 120)
TitleLine.BorderSizePixel = 0
TitleLine.Parent = MainFrame

-- Función para crear botones
local function createButton(parent, text, position, size, color, callback)
    local button = Instance.new("TextButton")
    button.Size = size or UDim2.new(0, 60, 0, 30)
    button.Position = position
    button.BackgroundColor3 = color or Color3.fromRGB(60, 60, 90)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.Font = Enum.Font.GothamMedium
    button.BorderSizePixel = 0
    button.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button
    
    button.MouseButton1Click:Connect(callback or function() end)
    return button
end

-- Función para crear etiquetas
local function createLabel(parent, text, position, size, color)
    local label = Instance.new("TextLabel")
    label.Size = size or UDim2.new(0, 60, 0, 20)
    label.Position = position
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color or Color3.fromRGB(200, 200, 200)
    label.TextScaled = true
    label.Font = Enum.Font.GothamMedium
    label.Parent = parent
    return label
end

-- ================== ORGANIZACIÓN DE BOTONES ==================

-- Fila 1 (Y = 40): DESBLOQUEAR, BRAIN, DROP
createButton(MainFrame, "DESBLOQUEAR", UDim2.new(0.05, 0, 0, 40), UDim2.new(0, 85, 0, 30), Color3.fromRGB(70, 40, 120))
createButton(MainFrame, "BRAIN", UDim2.new(0.38, 0, 0, 40), UDim2.new(0, 60, 0, 30), Color3.fromRGB(40, 70, 120))
createButton(MainFrame, "DROP", UDim2.new(0.68, 0, 0, 40), UDim2.new(0, 60, 0, 30), Color3.fromRGB(120, 40, 40))

-- Fila 2 (Y = 80): AUTO LEFT, AUTO, AUTO
createButton(MainFrame, "AUTO LEFT", UDim2.new(0.02, 0, 0, 80), UDim2.new(0, 90, 0, 30), Color3.fromRGB(40, 90, 40))
createButton(MainFrame, "AUTO", UDim2.new(0.35, 0, 0, 80), UDim2.new(0, 60, 0, 30), Color3.fromRGB(40, 90, 40))
createButton(MainFrame, "AUTO", UDim2.new(0.65, 0, 0, 80), UDim2.new(0, 60, 0, 30), Color3.fromRGB(40, 90, 40))

-- Control deslizante: Menu Scale
local ScaleLabel = createLabel(MainFrame, "Menu Scale", UDim2.new(0.05, 0, 0, 120), UDim2.new(0, 80, 0, 20))
local ScaleValue = createLabel(MainFrame, "0.8", UDim2.new(0.75, 0, 0, 120), UDim2.new(0, 30, 0, 20), Color3.fromRGB(255, 200, 50))

-- Fila 3 (Y = 150): BAT, RIGHT, Reset Mobile Positions
createButton(MainFrame, "BAT", UDim2.new(0.05, 0, 0, 150), UDim2.new(0, 60, 0, 30), Color3.fromRGB(120, 80, 20))
createButton(MainFrame, "RIGHT", UDim2.new(0.35, 0, 0, 150), UDim2.new(0, 60, 0, 30), Color3.fromRGB(20, 80, 120))
createButton(MainFrame, "Reset Mobile", UDim2.new(0.65, 0, 0, 145), UDim2.new(0, 90, 0, 30), Color3.fromRGB(80, 20, 80))

-- Fila 4 (Y = 190): TP, CARRY, DOWN
createButton(MainFrame, "TP", UDim2.new(0.05, 0, 0, 190), UDim2.new(0, 60, 0, 30), Color3.fromRGB(20, 100, 20))
createButton(MainFrame, "CARRY", UDim2.new(0.35, 0, 0, 190), UDim2.new(0, 70, 0, 30), Color3.fromRGB(100, 20, 100))
createButton(MainFrame, "DOWN", UDim2.new(0.68, 0, 0, 190), UDim2.new(0, 60, 0, 30), Color3.fromRGB(20, 60, 100))

-- Fila 5 (Y = 230): SPEED, CHARTER, Animation Pack
createButton(MainFrame, "SPEED", UDim2.new(0.05, 0, 0, 230), UDim2.new(0, 65, 0, 30), Color3.fromRGB(100, 60, 20))
createButton(MainFrame, "CHARTER", UDim2.new(0.38, 0, 0, 230), UDim2.new(0, 70, 0, 30), Color3.fromRGB(20, 60, 100))
createButton(MainFrame, "Animation Pack", UDim2.new(0.68, 0, 0, 225), UDim2.new(0, 80, 0, 30), Color3.fromRGB(60, 20, 80))

-- Fila 6 (Y = 270): LAGGE, INSTA, R
createButton(MainFrame, "LAGGE", UDim2.new(0.05, 0, 0, 270), UDim2.new(0, 70, 0, 30), Color3.fromRGB(80, 80, 20))
createButton(MainFrame, "INSTA", UDim2.new(0.38, 0, 0, 270), UDim2.new(0, 60, 0, 30), Color3.fromRGB(20, 80, 80))
createButton(MainFrame, "R", UDim2.new(0.68, 0, 0, 270), UDim2.new(0, 40, 0, 30), Color3.fromRGB(120, 20, 20))

-- Fila 7 (Y = 310): RESET, Apply Animation Pack
createButton(MainFrame, "RESET", UDim2.new(0.05, 0, 0, 310), UDim2.new(0, 70, 0, 30), Color3.fromRGB(120, 30, 30))
createButton(MainFrame, "Apply Animation Pack", UDim2.new(0.38, 0, 0, 310), UDim2.new(0, 130, 0, 30), Color3.fromRGB(30, 80, 30))

-- Fila 8 (Y = 350): LAGGE, BAT, Headless
createButton(MainFrame, "LAGGE", UDim2.new(0.02, 0, 0, 350), UDim2.new(0, 70, 0, 30), Color3.fromRGB(80, 80, 20))
createButton(MainFrame, "BAT", UDim2.new(0.32, 0, 0, 350), UDim2.new(0, 60, 0, 30), Color3.fromRGB(120, 80, 20))
createButton(MainFrame, "Headless", UDim2.new(0.58, 0, 0, 350), UDim2.new(0, 80, 0, 30), Color3.fromRGB(60, 40, 100))

-- Fila 9 (Y = 390): R, TP, Korblox
createButton(MainFrame, "R", UDim2.new(0.05, 0, 0, 390), UDim2.new(0, 40, 0, 30), Color3.fromRGB(120, 20, 20))
createButton(MainFrame, "TP", UDim2.new(0.32, 0, 0, 390), UDim2.new(0, 60, 0, 30), Color3.fromRGB(20, 100, 20))
createButton(MainFrame, "Korblox", UDim2.new(0.58, 0, 0, 390), UDim2.new(0, 80, 0, 30), Color3.fromRGB(100, 60, 20))

-- Botones inferiores: IPANELS, Save Config, SAVE
createButton(MainFrame, "IPANELS", UDim2.new(0.05, 0, 0, 420), UDim2.new(0, 70, 0, 25), Color3.fromRGB(40, 40, 100))
createButton(MainFrame, "Save Config", UDim2.new(0.38, 0, 0, 420), UDim2.new(0, 80, 0, 25), Color3.fromRGB(40, 80, 40))
createButton(MainFrame, "SAVE", UDim2.new(0.72, 0, 0, 420), UDim2.new(0, 60, 0, 25), Color3.fromRGB(80, 40, 20))

-- ================== FUNCIONALIDADES BÁSICAS ==================

-- Ejemplo de función para los botones (puedes personalizar)
local function onButtonClick(buttonName)
    print("Botón presionado: " .. buttonName)
    -- Aquí puedes agregar la lógica para cada botón
end

-- Conectar todos los botones (recorre todos los TextButton)
for _, button in ipairs(MainFrame:GetDescendants()) do
    if button:IsA("TextButton") then
        local name = button.Text
        button.MouseButton1Click:Connect(function()
            onButtonClick(name)
        end)
    end
end

-- ================== DRAG PARA MOVER LA GUI ==================

local dragging = false
local dragInput, dragStart, startPos

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ================== CIERRE DE LA GUI (OPCIONAL) ==================
-- Puedes agregar un botón de cierre si lo deseas