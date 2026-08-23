-- Crear la GUI principal
local player = -- Crear la GUI principal
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Si ya existe una GUI con este nombre, la elimina para evitar duplicados
if playerGui:FindFirstChild("FenixHubGUI") then
    playerGui.FenixHubGUI:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FenixHubGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Marco principal (Frame)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 450) -- Tamaño aproximado
mainFrame.Position = UDim2.new(1, -220, 0.5, -225) -- Posición en el lado derecho
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35) -- Gris oscuro
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true -- Permite arrastrar el menú
mainFrame.Parent = screenGui

-- Título del Hub
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
title.Text = "FENIX HUB"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = mainFrame

-- Función para crear botones automáticamente
local function createButton(name, yPos, parent)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 180, 0, 40)
    button.Position = UDim2.new(0, 10, 0, yPos)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Text = name
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    
    -- Efecto al pasar el mouse
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end)
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end)
    
    button.Parent = parent
    return button
end

-- Crear los botones basados en la imagen (ajustando la posición Y)
local names = {
    "PROP BRAINROT", "AUTO LEFT", 
    "AUTO BAT", "AUTO RIGHT",
    "TP DOWN", "CARRY SPEED",
    "LAGGER MODE", "INSTA RESET",
    "LAGGER CARRY", "BAT TP"
}

local yOffset = 60
for i, name in ipairs(names) do
    local btn = createButton(name, yOffset, mainFrame)
    
    -- Conectar la función del botón (ejemplo genérico)
    btn.MouseButton1Click:Connect(function()
        print("Botón presionado: " .. name)
        -- Aquí iría la lógica real de tu script (ej: cambiar estado, teletransportar, etc.)
        -- Ejemplo:
        if name == "AUTO LEFT" then
            btn.Text = "AUTO LEFT: ON"
            wait(1)
            btn.Text = "AUTO LEFT: OFF"
        end
    end)
    
    yOffset = yOffset + 45 -- Separación entre botones
end

-- Botón de cierre (opcional, para ocultar el menú)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 20, 0, 20)
closeBtn.Position = UDim2.new(1, -25, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 12
closeBtn.Parent = mainFrame

closeBtn.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
end)
local playerGui = player:WaitForChild("PlayerGui")

-- Si ya existe una GUI con este nombre, la elimina para evitar duplicados
if playerGui:FindFirstChild("FenixHubGUI") then
    playerGui.FenixHubGUI:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FenixHubGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Marco principal (Frame)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 450) -- Tamaño aproximado
mainFrame.Position = UDim2.new(1, -220, 0.5, -225) -- Posición en el lado derecho
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35) -- Gris oscuro
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true -- Permite arrastrar el menú
mainFrame.Parent = screenGui

-- Título del Hub
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
title.Text = "FENIX HUB"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = mainFrame

-- Función para crear botones automáticamente
local function createButton(name, yPos, parent)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 180, 0, 40)
    button.Position = UDim2.new(0, 10, 0, yPos)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Text = name
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    
    -- Efecto al pasar el mouse
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end)
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end)
    
    button.Parent = parent
    return button
end

-- Crear los botones basados en la imagen (ajustando la posición Y)
local names = {
    "PROP BRAINROT", "AUTO LEFT", 
    "AUTO BAT", "AUTO RIGHT",
    "TP DOWN", "CARRY SPEED",
    "LAGGER MODE", "INSTA RESET",
    "LAGGER CARRY", "BAT TP"
}

local yOffset = 60
for i, name in ipairs(names) do
    local btn = createButton(name, yOffset, mainFrame)
    
    -- Conectar la función del botón (ejemplo genérico)
    btn.MouseButton1Click:Connect(function()
        print("Botón presionado: " .. name)
        -- Aquí iría la lógica real de tu script (ej: cambiar estado, teletransportar, etc.)
        -- Ejemplo:
        if name == "AUTO LEFT" then
            btn.Text = "AUTO LEFT: ON"
            wait(1)
            btn.Text = "AUTO LEFT: OFF"
        end
    end)
    
    yOffset = yOffset + 45 -- Separación entre botones
end

-- Botón de cierre (opcional, para ocultar el menú)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 20, 0, 20)
closeBtn.Position = UDim2.new(1, -25, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 12
closeBtn.Parent = mainFrame

closeBtn.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
end)