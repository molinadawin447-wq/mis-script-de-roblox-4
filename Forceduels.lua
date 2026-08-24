-- Script para el menú de botones (Drop Brainrot Style)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BrainrotUI"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Función para crear botones
local function createButton(text, position, size)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, size or 130, 0, 30)
    button.Position = UDim2.new(0, position.X, 0, position.Y)
    button.Text = text
    button.TextScaled = true
    button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.BorderSizePixel = 1
    button.BorderColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.SourceSansBold
    button.Parent = screenGui
    
    -- Efecto hover
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end)
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    end)
    
    return button
end

-- Posiciones de los botones (basado en la imagen)
local buttons = {
    {text = "DROP BRAINROT", pos = Vector2.new(10, 10)},
    {text = "AUTO LEFT", pos = Vector2.new(10, 50)},
    {text = "AUTO BAT", pos = Vector2.new(10, 90)},
    {text = "AUTO RIGHT", pos = Vector2.new(10, 130)},
    {text = "TP DOWN", pos = Vector2.new(160, 10)},
    {text = "CARRY SPEED", pos = Vector2.new(160, 50)},
    {text = "LAGGER MODE", pos = Vector2.new(160, 90)},
    {text = "INSTA RESET", pos = Vector2.new(160, 130)},
    {text = "LAGGER CARRY", pos = Vector2.new(310, 10)},
    {text = "BAT TP", pos = Vector2.new(310, 50)}
}

-- Crear todos los botones
for _, btnData in ipairs(buttons) do
    createButton(btnData.text, btnData.pos, 120)
end

-- Crear un fondo semitransparente opcional
local background = Instance.new("Frame")
background.Size = UDim2.new(0, 440, 0, 180)
background.Position = UDim2.new(0, 0, 0, 0)
background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
background.BackgroundTransparency = 0.5
background.BorderSizePixel = 0
background.Parent = screenGui

-- Mover los botones al fondo (para que estén encima)
for _, child in ipairs(screenGui:GetChildren()) do
    if child:IsA("TextButton") then
        child.Parent = background
    end
end