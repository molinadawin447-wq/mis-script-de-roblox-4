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
mainFrame.Size = UDim2.new(0, 180, 0, 200)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundTransparency = 1
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.Parent = screenGui

-- Función para crear botones circulares
local function createCircleButton(text, position, size)
    local button = Instance.new("ImageButton")
    button.Size = UDim2.new(0, size or 60, 0, size or 60)
    button.Position = UDim2.new(0, position.X, 0, position.Y)
    button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    button.BackgroundTransparency = 0.3
    button.BorderSizePixel = 2
    button.BorderColor3 = Color3.fromRGB(255, 255, 255)
    button.Image = "rbxassetid://14560911477" -- Imagen circular
    button.ImageColor3 = Color3.fromRGB(30, 30, 30)
    button.ImageTransparency = 0.3
    button.Parent = mainFrame
    
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
    button.MouseEnter:Connect(function()
        button.ImageTransparency = 0
        button.BackgroundTransparency = 0
    end)
    button.MouseLeave:Connect(function()
        button.ImageTransparency = 0.3
        button.BackgroundTransparency = 0.3
    end)
    
    return button
end

-- Crear botón TP DOWN (arriba izquierda)
local tpButton = createCircleButton("TP\nDOWN", Vector2.new(20, 20), 70)

-- Crear botón CARRY SPEED (arriba derecha)
local carryButton = createCircleButton("CARRY\nSPEED", Vector2.new(95, 20), 70)

-- Crear botón LAGGER MODE (abajo izquierda)
local laggerButton = createCircleButton("LAGGER\nMODE", Vector2.new(20, 95), 70)

-- Crear botón INSTA RESET (abajo derecha)
local instaButton = createCircleButton("INSTA\nRESET", Vector2.new(95, 95), 70)

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