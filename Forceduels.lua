-- Script para menú de botones circulares (Drop Brainrot Style)
local UserInputService = game:GetService("UserInputService")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BrainrotUI"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Variables para mover el menú
local dragging = false
local dragStart = nil
local startPos = nil

-- Marco principal (transparente y movible)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 180, 0, 280)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundTransparency = 1
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.Parent = screenGui

-- Función para crear botones circulares
local function createCircleButton(text, position, size)
    local button = Instance.new("Frame")
    button.Size = UDim2.new(0, size or 55, 0, size or 55)
    button.Position = UDim2.new(0, position.X, 0, position.Y)
    button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    button.BackgroundTransparency = 0
    button.BorderSizePixel = 2
    button.BorderColor3 = Color3.fromRGB(255, 255, 255)
    button.Parent = mainFrame
    
    -- Hacer el frame circular
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = button
    
    -- Botón clickeable
    local clickButton = Instance.new("ImageButton")
    clickButton.Size = UDim2.new(1, 0, 1, 0)
    clickButton.Position = UDim2.new(0, 0, 0, 0)
    clickButton.BackgroundTransparency = 1
    clickButton.ImageTransparency = 1
    clickButton.Parent = button
    
    -- Label del texto dentro del botón
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -8, 1, -8)
    textLabel.Position = UDim2.new(0, 4, 0, 4)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextScaled = true
    textLabel.TextWrapped = true
    textLabel.TextSize = 10
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.ClipsDescendants = false
    textLabel.Parent = button
    
    -- Efecto hover
    clickButton.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    end)
    clickButton.MouseLeave:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    end)
    
    return button
end

-- Crear botones organizados en 2 columnas
-- Columna izquierda
local dropButton = createCircleButton("DROP\nBRAINROT", Vector2.new(15, 15), 55)
local autoLeftButton = createCircleButton("AUTO\nLEFT", Vector2.new(15, 75), 55)
local autoBatButton = createCircleButton("AUTO\nBAT", Vector2.new(15, 135), 55)
local autoRightButton = createCircleButton("AUTO\nRIGHT", Vector2.new(15, 195), 55)

-- Columna derecha
local tpDownButton = createCircleButton("TP\nDOWN", Vector2.new(75, 15), 55)
local carrySpeedButton = createCircleButton("CARRY\nSPEED", Vector2.new(75, 75), 55)
local laggerModeButton = createCircleButton("LAGGER\nMODE", Vector2.new(75, 135), 55)
local instaResetButton = createCircleButton("INSTA\nRESET", Vector2.new(75, 195), 55)

-- Nueva fila abajo
local laggerCarryButton = createCircleButton("LAGGER\nCARRY", Vector2.new(15, 255), 55)
local batTpButton = createCircleButton("BAT\nTP", Vector2.new(75, 255), 55)

-- Hacer que el menú sea movible
mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

mainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)