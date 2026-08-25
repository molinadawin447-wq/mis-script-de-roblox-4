-- Configuración de la GUI
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local MainFrameLeft = Instance.new("Frame")
local ButtonTemplate = Instance.new("TextButton")

-- Propiedades de la GUI principal
ScreenGui.Parent = game.Players.LocalPlayer.PlayerGui
ScreenGui.Name = "CustomGUI"

-- ===== MARCO DERECHO (botones principales) =====
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 1
MainFrame.Size = UDim2.new(0, 220, 0, 330)
MainFrame.Position = UDim2.new(1, -220, 0.35, -165)

-- ===== MARCO IZQUIERDO (botón movible) =====
MainFrameLeft.Parent = ScreenGui
MainFrameLeft.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrameLeft.BackgroundTransparency = 1
MainFrameLeft.Size = UDim2.new(0, 120, 0, 60)
MainFrameLeft.Position = UDim2.new(0, 20, 0.35, -30)

-- Plantilla de botón (para los botones de la derecha)
ButtonTemplate.Parent = MainFrame
ButtonTemplate.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ButtonTemplate.TextColor3 = Color3.fromRGB(200, 200, 200)
ButtonTemplate.BorderSizePixel = 2
ButtonTemplate.BorderColor3 = Color3.fromRGB(160, 160, 160)
ButtonTemplate.Font = Enum.Font.SourceSansBold
ButtonTemplate.TextSize = 10
ButtonTemplate.TextWrapped = true
ButtonTemplate.TextScaled = false

-- ===== DATOS DE LOS BOTONES (DERECHA) =====
local buttonsData = {
    "DROP BRAINROT", "AUTO LEFT",
    "AUTO BAT", "AUTO RIGHT",
    "TP DOWN", "CARRY SPEED",
    "LAGGER MODE", "INSTA RESET",
    "LAGGER CARRY", "BAT TP"
}

local buttons = {}
local buttonSize = UDim2.new(0, 85, 0, 40)
local spacing = 10
local startX = 10
local startY = 10

-- Crear botones en el marco derecho
for row = 0, 4 do
    for col = 0, 1 do
        local btn = ButtonTemplate:Clone()
        btn.Parent = MainFrame
        
        local xPos = startX + (col * (buttonSize.X.Offset + spacing + 5))
        local yPos = startY + (row * (buttonSize.Y.Offset + spacing))
        btn.Position = UDim2.new(0, xPos, 0, yPos)
        btn.Size = buttonSize
        
        local index = row * 2 + col + 1
        btn.Text = buttonsData[index] or "BTN " .. index
        
        btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        btn.BorderSizePixel = 2
        btn.BorderColor3 = Color3.fromRGB(160, 160, 160)
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        
        local corner = Instance.new("UICorner")
        corner.Parent = btn
        corner.CornerRadius = UDim.new(0, 8)
        
        btn.MouseEnter:Connect(function()
            btn.BorderColor3 = Color3.fromRGB(200, 200, 200)
            btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        end)
        
        btn.MouseLeave:Connect(function()
            btn.BorderColor3 = Color3.fromRGB(160, 160, 160)
            btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        end)
        
        btn.MouseButton1Click:Connect(function()
            print("Botón " .. btn.Text .. " presionado!")
        end)
        
        table.insert(buttons, btn)
    end
end

-- ===== PANEL EMERGENTE (Force.vs) =====
local PanelFrame = Instance.new("Frame")
PanelFrame.Parent = ScreenGui
PanelFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
PanelFrame.BackgroundTransparency = 0
PanelFrame.Size = UDim2.new(0, 300, 0, 180) -- Panel más pequeño
PanelFrame.Position = UDim2.new(0.5, -150, 0.5, -90)
PanelFrame.Visible = false
PanelFrame.BorderSizePixel = 2
PanelFrame.BorderColor3 = Color3.fromRGB(200, 200, 200)

local panelCorner = Instance.new("UICorner")
panelCorner.Parent = PanelFrame
panelCorner.CornerRadius = UDim.new(0, 10)

-- ===== TÍTULO DEL PANEL "Force.vs" =====
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = PanelFrame
TitleLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Size = UDim2.new(0, 200, 0, 40)
TitleLabel.Position = UDim2.new(0.5, -100, 0, 10)
TitleLabel.Text = "Force.vs"
TitleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
TitleLabel.TextSize = 28
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextScaled = false

-- ===== LÍNEA DEBAJO DEL TÍTULO =====
local LineFrame = Instance.new("Frame")
LineFrame.Parent = PanelFrame
LineFrame.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
LineFrame.Size = UDim2.new(0, 250, 0, 2)
LineFrame.Position = UDim2.new(0.5, -125, 0, 55)
LineFrame.BackgroundTransparency = 0
LineFrame.BorderSizePixel = 0

-- ===== APARTADO "SPEED" (más pequeño) =====
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Parent = PanelFrame
SpeedLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Size = UDim2.new(0, 100, 0, 25)
SpeedLabel.Position = UDim2.new(0.5, -50, 0, 75) -- Centrado
SpeedLabel.Text = "Speed"
SpeedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SpeedLabel.TextSize = 16 -- Más pequeño
SpeedLabel.Font = Enum.Font.SourceSansBold
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Center

-- ===== APARTADO "COMBAT" (debajo de Speed) =====
local CombatLabel = Instance.new("TextLabel")
CombatLabel.Parent = PanelFrame
CombatLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
CombatLabel.BackgroundTransparency = 1
CombatLabel.Size = UDim2.new(0, 100, 0, 25)
CombatLabel.Position = UDim2.new(0.5, -50, 0, 105) -- Debajo de Speed
CombatLabel.Text = "Combat"
CombatLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
CombatLabel.TextSize = 16
CombatLabel.Font = Enum.Font.SourceSansBold
CombatLabel.TextXAlignment = Enum.TextXAlignment.Center

-- ===== BOTÓN DE CERRAR (X) =====
local CloseButton = Instance.new("TextButton")
CloseButton.Parent = PanelFrame
CloseButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -40, 0, 10)
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(200, 200, 200)
CloseButton.TextSize = 18
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.BorderSizePixel = 2
CloseButton.BorderColor3 = Color3.fromRGB(200, 200, 200)
CloseButton.BackgroundTransparency = 0

local closeCorner = Instance.new("UICorner")
closeCorner.Parent = CloseButton
closeCorner.CornerRadius = UDim.new(0, 5)

CloseButton.MouseEnter:Connect(function()
    CloseButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

CloseButton.MouseLeave:Connect(function()
    CloseButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    CloseButton.TextColor3 = Color3.fromRGB(200, 200, 200)
end)

CloseButton.MouseButton1Click:Connect(function()
    PanelFrame.Visible = false
end)

-- ===== BOTÓN IZQUIERDO "Force.vs" =====
local leftButton = ButtonTemplate:Clone()
leftButton.Parent = MainFrameLeft
leftButton.Size = UDim2.new(0, 110, 0, 45)
leftButton.Position = UDim2.new(0.5, -55, 0.5, -22.5)
leftButton.Text = "Force.vs"
leftButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
leftButton.BorderSizePixel = 2
leftButton.BorderColor3 = Color3.fromRGB(160, 160, 160)
leftButton.TextColor3 = Color3.fromRGB(200, 200, 200)
leftButton.TextSize = 12

local cornerLeft = Instance.new("UICorner")
cornerLeft.Parent = leftButton
cornerLeft.CornerRadius = UDim.new(0, 8)

leftButton.MouseEnter:Connect(function()
    leftButton.BorderColor3 = Color3.fromRGB(200, 200, 200)
    leftButton.TextColor3 = Color3.fromRGB(230, 230, 230)
    leftButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
end)

leftButton.MouseLeave:Connect(function()
    leftButton.BorderColor3 = Color3.fromRGB(160, 160, 160)
    leftButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    leftButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
end)

-- ABRIR PANEL AL TOCAR EL BOTÓN IZQUIERDO
leftButton.MouseButton1Click:Connect(function()
    PanelFrame.Visible = true
end)

-- ===== SISTEMA DE ARRASTRE PARA EL BOTÓN IZQUIERDO =====
local dragging = false
local dragStartPos = Vector2.new(0, 0)
local frameStartPos = Vector2.new(0, 0)

local function updateDrag(input)
    if dragging then
        local delta = input.Position - dragStartPos
        local newX = frameStartPos.X + delta.X
        local newY = frameStartPos.Y + delta.Y
        
        local screenSize = game:GetService("UserInputService"):GetMouseLocation()
        local frameSize = MainFrameLeft.Size
        newX = math.max(0, math.min(newX, screenSize.X - frameSize.X.Offset))
        newY = math.max(0, math.min(newY, screenSize.Y - frameSize.Y.Offset))
        
        MainFrameLeft.Position = UDim2.new(0, newX, 0, newY)
    end
end

leftButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStartPos = input.Position
        frameStartPos = Vector2.new(MainFrameLeft.Position.X.Offset, MainFrameLeft.Position.Y.Offset)
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

leftButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        updateDrag(input)
    end
end)

leftButton.MouseButton1Down:Connect(function()
    dragging = true
    local mouse = game:GetService("UserInputService"):GetMouseLocation()
    dragStartPos = Vector2.new(mouse.X, mouse.Y)
    frameStartPos = Vector2.new(MainFrameLeft.Position.X.Offset, MainFrameLeft.Position.Y.Offset)
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local mouse = game:GetService("UserInputService"):GetMouseLocation()
        local delta = Vector2.new(mouse.X, mouse.Y) - dragStartPos
        local newX = frameStartPos.X + delta.X
        local newY = frameStartPos.Y + delta.Y
        
        local screenSize = game:GetService("UserInputService"):GetMouseLocation()
        local frameSize = MainFrameLeft.Size
        newX = math.max(0, math.min(newX, screenSize.X - frameSize.X.Offset))
        newY = math.max(0, math.min(newY, screenSize.Y - frameSize.Y.Offset))
        
        MainFrameLeft.Position = UDim2.new(0, newX, 0, newY)
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

print("GUI con panel Force.vs con Speed pequeño y Combat debajo creada correctamente!")