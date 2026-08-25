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
mainFrame.Size = UDim2.new(0, 170, 0, 210)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundTransparency = 1
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.Parent = screenGui

-- Función para crear botones circulares
local function createCircleButton(text, position, size)
    local button = Instance.new("Frame")
    button.Size = UDim2.new(0, size or 45, 0, size or 45)
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
    textLabel.Size = UDim2.new(1, -10, 1, -10)
    textLabel.Position = UDim2.new(0, 5, 0, 5)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextScaled = true
    textLabel.TextWrapped = true
    textLabel.TextSize = 12
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

-- Crear botón TP DOWN (arriba izquierda)
local tpButton = createCircleButton("TP\nDOWN", Vector2.new(10, 10), 45)

-- Crear botón CARRY SPEED (arriba derecha)
local carryButton = createCircleButton("CARRY\nSPEED", Vector2.new(115, 10), 45)

-- Crear botón LAGGER MODE (abajo izquierda)
local laggerButton = createCircleButton("LAGGER\nMODE", Vector2.new(10, 65), 45)

-- Crear botón LAGGER CARRY (debajo de LAGGER MODE)
local laggerCarryButton = createCircleButton("LAGGER\nCARRY", Vector2.new(10, 120), 45)

-- Crear botón INSTA RESET (abajo derecha)
local instaButton = createCircleButton("INSTA\nRESET", Vector2.new(115, 65), 45)

-- Crear botón BAT TP (debajo de INSTA RESET)
local batTPButton = createCircleButton("BAT\nTP", Vector2.new(115, 120), 45)

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