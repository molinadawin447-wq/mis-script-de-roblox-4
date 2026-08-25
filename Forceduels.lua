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

-- ===== PANEL EMERGENTE (Force.vs) - SIN CUADROS DE TEXTO =====
local PanelFrame = Instance.new("Frame")
PanelFrame.Parent = ScreenGui
PanelFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
PanelFrame.BackgroundTransparency = 0
PanelFrame.Size = UDim2.new(0, 400, 0, 200) -- Panel más pequeño
PanelFrame.Position = UDim2.new(0.5, -200, 0.5, -100)
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
LineFrame.Size = UDim2.new(0, 300, 0, 2)
LineFrame.Position = UDim2.new(0.5, -150, 0, 55)
LineFrame.BackgroundTransparency = 0
LineFrame.BorderSizePixel = 0

-- ===== APARTADO "SPEED" =====
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Parent = PanelFrame
SpeedLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Size = UDim2.new(0, 100, 0, 30)
SpeedLabel.Position = UDim2.new(0.5, -180, 0, 75)
SpeedLabel.Text = "Speed"
SpeedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SpeedLabel.TextSize = 20
SpeedLabel.Font = Enum.Font.SourceSansBold
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left

-- ===== LÍNEA VERTICAL (separador) =====
local VerticalLine = Instance.new("Frame")
VerticalLine.Parent = PanelFrame
VerticalLine.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
VerticalLine.Size = UDim2.new(0, 2, 0, 60)
VerticalLine.Position = UDim2.new(0.5, -40, 0, 75)
VerticalLine.BackgroundTransparency = 0
VerticalLine.BorderSizePixel = 0

-- ===== APARTADO "VELOCITY" (lado derecho de la línea vertical) =====
local VelocityLabel = Instance.new("TextLabel")
VelocityLabel.Parent = PanelFrame
VelocityLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
VelocityLabel.BackgroundTransparency = 1
VelocityLabel.Size = UDim2.new(0, 100, 0, 30)
VelocityLabel.Position = UDim2.new(0.5, 20, 0, 75)
VelocityLabel.Text = "Velocity"
VelocityLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
VelocityLabel.TextSize = 20
VelocityLabel.Font = Enum.Font.SourceSansBold
VelocityLabel.TextXAlignment = Enum.TextXAlignment.Left

-- ===== VALORES DE SPEED Y VELOCITY (solo texto) =====
local SpeedValue = Instance.new("TextLabel")
SpeedValue.Parent = PanelFrame
SpeedValue.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SpeedValue.BackgroundTransparency = 1
SpeedValue.Size = UDim2.new(0, 80, 0, 30)
SpeedValue.Position = UDim2.new(0.5, -170, 0, 110)
SpeedValue.Text = "50"
SpeedValue.TextColor3 = Color3.fromRGB(200, 200, 200)
SpeedValue.TextSize = 18
SpeedValue.Font = Enum.Font.SourceSansBold
SpeedValue.TextXAlignment = Enum.TextXAlignment.Left

local VelocityValue = Instance.new("TextLabel")
VelocityValue.Parent = PanelFrame
VelocityValue.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
VelocityValue.BackgroundTransparency = 1
VelocityValue.Size = UDim2.new(0, 80, 0, 30)
VelocityValue.Position = UDim2.new(0.5, 30, 0, 110)
VelocityValue.Text = "100"
VelocityValue.TextColor3 = Color3.fromRGB(200, 200, 200)
VelocityValue.TextSize = 18
VelocityValue.Font = Enum.Font.SourceSansBold
VelocityValue.TextXAlignment = Enum.TextXAlignment.Left

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

print("GUI con panel Force.vs sin cuadros de texto y sin botón confirmar creada correctamente!")