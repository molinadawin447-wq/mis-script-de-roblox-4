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
PanelFrame.Size = UDim2.new(0, 450, 0, 220)
PanelFrame.Position = UDim2.new(0.5, -225, 0.5, -110)
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
LineFrame.Size = UDim2.new(0, 400, 0, 2)
LineFrame.Position = UDim2.new(0.5, -200, 0, 55)
LineFrame.BackgroundTransparency = 0
LineFrame.BorderSizePixel = 0

-- ===== LÍNEA VERTICAL (separador izquierda/derecha) =====
local VerticalLine = Instance.new("Frame")
VerticalLine.Parent = PanelFrame
VerticalLine.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
VerticalLine.Size = UDim2.new(0, 2, 0, 110)
VerticalLine.Position = UDim2.new(0.5, -30, 0, 75)
VerticalLine.BackgroundTransparency = 0
VerticalLine.BorderSizePixel = 0

-- ===== APARTADO "SPEED" (lado izquierdo) =====
local SpeedLabel = Instance.new("TextButton")
SpeedLabel.Parent = PanelFrame
SpeedLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SpeedLabel.Size = UDim2.new(0, 80, 0, 35)
SpeedLabel.Position = UDim2.new(0.5, -190, 0, 80)
SpeedLabel.Text = "Speed"
SpeedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SpeedLabel.TextSize = 16
SpeedLabel.Font = Enum.Font.SourceSansBold
SpeedLabel.BorderSizePixel = 2
SpeedLabel.BorderColor3 = Color3.fromRGB(160, 160, 160)

local speedCorner = Instance.new("UICorner")
speedCorner.Parent = SpeedLabel
speedCorner.CornerRadius = UDim.new(0, 5)

-- ===== APARTADO "COMBAT" (lado izquierdo, debajo de Speed) =====
local CombatLabel = Instance.new("TextButton")
CombatLabel.Parent = PanelFrame
CombatLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
CombatLabel.Size = UDim2.new(0, 80, 0, 35)
CombatLabel.Position = UDim2.new(0.5, -190, 0, 130)
CombatLabel.Text = "Combat"
CombatLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
CombatLabel.TextSize = 16
CombatLabel.Font = Enum.Font.SourceSansBold
CombatLabel.BorderSizePixel = 2
CombatLabel.BorderColor3 = Color3.fromRGB(160, 160, 160)

local combatCorner = Instance.new("UICorner")
combatCorner.Parent = CombatLabel
combatCorner.CornerRadius = UDim.new(0, 5)

-- ===== PANEL DE SPEED (lado derecho) =====
local SpeedPanel = Instance.new("Frame")
SpeedPanel.Parent = PanelFrame
SpeedPanel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
SpeedPanel.Size = UDim2.new(0, 180, 0, 80)
SpeedPanel.Position = UDim2.new(0.5, 40, 0, 75)
SpeedPanel.Visible = false
SpeedPanel.BorderSizePixel = 2
SpeedPanel.BorderColor3 = Color3.fromRGB(200, 200, 200)

local speedPanelCorner = Instance.new("UICorner")
speedPanelCorner.Parent = SpeedPanel
speedPanelCorner.CornerRadius = UDim.new(0, 5)

-- Título "Speed" dentro del panel
local SpeedTitle = Instance.new("TextLabel")
SpeedTitle.Parent = SpeedPanel
SpeedTitle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SpeedTitle.BackgroundTransparency = 1
SpeedTitle.Size = UDim2.new(0, 80, 0, 25)
SpeedTitle.Position = UDim2.new(0.5, -40, 0, 5)
SpeedTitle.Text = "Speed"
SpeedTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
SpeedTitle.TextSize = 14
SpeedTitle.Font = Enum.Font.SourceSansBold
SpeedTitle.TextXAlignment = Enum.TextXAlignment.Center

-- Slider para modificar velocidad (1-60)
local SpeedSlider = Instance.new("TextButton")
SpeedSlider.Parent = SpeedPanel
SpeedSlider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SpeedSlider.Size = UDim2.new(0, 150, 0, 25)
SpeedSlider.Position = UDim2.new(0.5, -75, 0, 35)
SpeedSlider.Text = "1"
SpeedSlider.TextColor3 = Color3.fromRGB(200, 200, 200)
SpeedSlider.TextSize = 14
SpeedSlider.Font = Enum.Font.SourceSansBold
SpeedSlider.BorderSizePixel = 2
SpeedSlider.BorderColor3 = Color3.fromRGB(200, 200, 200)

local sliderCorner = Instance.new("UICorner")
sliderCorner.Parent = SpeedSlider
sliderCorner.CornerRadius = UDim.new(0, 5)

-- Variable para el valor de velocidad
local speedValue = 1

-- Función para actualizar el slider
SpeedSlider.MouseButton1Click:Connect(function()
    speedValue = speedValue + 1
    if speedValue > 60 then
        speedValue = 1
    end
    SpeedSlider.Text = tostring(speedValue)
    print("Velocidad ajustada a: " .. speedValue)
end)

-- Efecto hover del slider
SpeedSlider.MouseEnter:Connect(function()
    SpeedSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
end)

SpeedSlider.MouseLeave:Connect(function()
    SpeedSlider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
end)

-- ===== PANEL DE COMBAT (lado derecho) =====
local CombatPanel = Instance.new("Frame")
CombatPanel.Parent = PanelFrame
CombatPanel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
CombatPanel.Size = UDim2.new(0, 180, 0, 80)
CombatPanel.Position = UDim2.new(0.5, 40, 0, 75)
CombatPanel.Visible = false
CombatPanel.BorderSizePixel = 2
CombatPanel.BorderColor3 = Color3.fromRGB(200, 200, 200)

local combatPanelCorner = Instance.new("UICorner")
combatPanelCorner.Parent = CombatPanel
combatPanelCorner.CornerRadius = UDim.new(0, 5)

-- Título "Combat" dentro del panel
local CombatTitle = Instance.new("TextLabel")
CombatTitle.Parent = CombatPanel
CombatTitle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
CombatTitle.BackgroundTransparency = 1
CombatTitle.Size = UDim2.new(0, 80, 0, 25)
CombatTitle.Position = UDim2.new(0.5, -40, 0, 5)
CombatTitle.Text = "Combat"
CombatTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
CombatTitle.TextSize = 14
CombatTitle.Font = Enum.Font.SourceSansBold
CombatTitle.TextXAlignment = Enum.TextXAlignment.Center

-- Texto informativo de Combat (sin valor)
local CombatInfo = Instance.new("TextLabel")
CombatInfo.Parent = CombatPanel
CombatInfo.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
CombatInfo.BackgroundTransparency = 1
CombatInfo.Size = UDim2.new(0, 160, 0, 25)
CombatInfo.Position = UDim2.new(0.5, -80, 0, 40)
CombatInfo.Text = "Modo Combat"
CombatInfo.TextColor3 = Color3.fromRGB(200, 200, 200)
CombatInfo.TextSize = 14
CombatInfo.Font = Enum.Font.SourceSans
CombatInfo.TextXAlignment = Enum.TextXAlignment.Center

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
    SpeedPanel.Visible = false
    CombatPanel.Visible = false
end)

-- ===== FUNCIONES PARA ABRIR/CERRAR PANELES =====
local function toggleSpeedPanel()
    if SpeedPanel.Visible then
        SpeedPanel.Visible = false
    else
        SpeedPanel.Visible = true
        CombatPanel.Visible = false
    end
end

local function toggleCombatPanel()
    if CombatPanel.Visible then
        CombatPanel.Visible = false
    else
        CombatPanel.Visible = true
        SpeedPanel.Visible = false
    end
end

-- Eventos de los botones Speed y Combat
SpeedLabel.MouseButton1Click:Connect(function()
    toggleSpeedPanel()
end)

CombatLabel.MouseButton1Click:Connect(function()
    toggleCombatPanel()
end)

-- Efectos hover para Speed y Combat
SpeedLabel.MouseEnter:Connect(function()
    SpeedLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    SpeedLabel.BorderColor3 = Color3.fromRGB(200, 200, 200)
end)

SpeedLabel.MouseLeave:Connect(function()
    SpeedLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    SpeedLabel.BorderColor3 = Color3.fromRGB(160, 160, 160)
end)

CombatLabel.MouseEnter:Connect(function()
    CombatLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    CombatLabel.BorderColor3 = Color3.fromRGB(200, 200, 200)
end)

CombatLabel.MouseLeave:Connect(function()
    CombatLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    CombatLabel.BorderColor3 = Color3.fromRGB(160, 160, 160)
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

-- ABRIR PANEL PRINCIPAL AL TOCAR EL BOTÓN IZQUIERDO
leftButton.MouseButton1Click:Connect(function()
    PanelFrame.Visible = true
    SpeedPanel.Visible = false
    CombatPanel.Visible = false
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

print("GUI con Speed y Combat en izquierda y slider de velocidad creada correctamente!")