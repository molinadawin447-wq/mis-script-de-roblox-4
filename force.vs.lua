-- Script Local - Fenix Hub

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local guiService = game:GetService("GuiService")

-- Crear la interfaz principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FenixHubGUI"
screenGui.Parent = player.PlayerGui

-- Frame principal
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 350, 0, 500)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(0, 170, 255)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Título
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 35)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
title.BackgroundTransparency = 0.3
title.Text = "FENIX HUB"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

-- Contenedor para los botones (Scrollable)
local buttonContainer = Instance.new("ScrollingFrame")
buttonContainer.Name = "ButtonContainer"
buttonContainer.Size = UDim2.new(1, -10, 1, -45)
buttonContainer.Position = UDim2.new(0, 5, 0, 40)
buttonContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
buttonContainer.BackgroundTransparency = 0.5
buttonContainer.BorderSizePixel = 0
buttonContainer.Parent = mainFrame

local gridLayout = Instance.new("UIGridLayout")
gridLayout.CellSize = UDim2.new(0, 100, 0, 35)
gridLayout.CellPadding = UDim2.new(0, 5, 0, 5)
gridLayout.StartCorner = Enum.StartCorner.TopLeft
gridLayout.Parent = buttonContainer

-- Lista de nombres de botones
local buttonNames = {
    "THROBBERBROAD", "LEAGUE-CENTER", "DESBLOQUEAR", "DROP", "AUTO", "BRAINROT",
    "LEFT", "STEAL", "MAIN", "AUTO", "AUTO", "ROBO AUTOMATICO",
    "BAT", "RIGHT", "STEAL", "VISUALS", "MOTION", "STEAL BAR SIZE",
    "300", "DOWN", "TP", "CARRY", "SPEED", "KEYS",
    "SALTO INFINITO", "LAGGER", "INSTA", "SETTINGS", "MODE", "RESET",
    "MIRROR TP DOWN", "LAGGER", "BAT", "AUTO IZQUIERDA", "CARRY", "TP",
    "DERECHA AUTOMATICA", "AUTO TP DOWN"
}

-- Función para crear botones
local function createButton(name)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(0, 100, 0, 35)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    button.BorderSizePixel = 1
    button.BorderColor3 = Color3.fromRGB(0, 170, 255)
    button.Text = name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 12
    button.Font = Enum.Font.GothamBold
    button.Parent = buttonContainer
    
    -- Efecto hover
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
    end)
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    end)
    
    -- Función al hacer clic
    button.MouseButton1Click:Connect(function()
        print("Botón presionado: " .. name)
        -- Aquí puedes agregar la funcionalidad para cada botón
        if name == "SALTO INFINITO" then
            -- Ejemplo: Activar salto infinito
            print("Activando salto infinito")
        elseif name == "RESET" then
            -- Ejemplo: Resetear algo
            print("Reseteando...")
        elseif name == "SETTINGS" then
            print("Abriendo configuración")
        end
    end)
end

-- Crear todos los botones
for _, name in ipairs(buttonNames) do
    createButton(name)
end

-- Botón de cerrar (esquina superior derecha)
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -30, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 16
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = mainFrame

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Tecla para abrir/cerrar (por ejemplo, F5)
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F5 then
        if screenGui.Parent then
            screenGui:Destroy()
        else
            screenGui.Parent = player.PlayerGui
        end
    end
end)

print("Fenix Hub cargado correctamente")