-- ===== GUARDADO PERSISTENTE (Atributos del jugador) =====
local player = game.Players.LocalPlayer

-- Leer valores guardados o usar valores por defecto
local savedSpeed = player:GetAttribute("SpeedValue") or 30
local savedCarry = player:GetAttribute("CarrySpeedValue") or 30
local savedLagger = player:GetAttribute("LaggerModeValue") or 10.1

-- ===== Configuración de la GUI =====
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local MainFrameLeft = Instance.new("Frame")
local ButtonTemplate = Instance.new("TextButton")

ScreenGui.Parent = player.PlayerGui
ScreenGui.Name = "CustomGUI"

-- ===== MARCO DERECHO (botones principales) =====
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 1
MainFrame.Size = UDim2.new(0, 330, 0, 340) -- Ancho para 4 columnas
MainFrame.Position = UDim2.new(1, -330, 0, 0)

-- ===== MARCO IZQUIERDO (botón movible) =====
MainFrameLeft.Parent = ScreenGui
MainFrameLeft.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrameLeft.BackgroundTransparency = 1
MainFrameLeft.Size = UDim2.new(0, 120, 0, 60)
MainFrameLeft.Position = UDim2.new(0, 20, 0.35, -30)

-- Plantilla de botón para los botones de la derecha
local RightButtonTemplate = Instance.new("TextButton")
RightButtonTemplate.Parent = MainFrame
RightButtonTemplate.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
RightButtonTemplate.TextColor3 = Color3.fromRGB(200, 200, 200)
RightButtonTemplate.BorderSizePixel = 3
RightButtonTemplate.BorderColor3 = Color3.fromRGB(255, 255, 255)
RightButtonTemplate.Font = Enum.Font.SourceSansBold
RightButtonTemplate.TextSize = 14
RightButtonTemplate.TextScaled = true -- Escala el texto para que quepa
RightButtonTemplate.TextWrapped = true
RightButtonTemplate.TextXAlignment = Enum.TextXAlignment.Center
RightButtonTemplate.TextYAlignment = Enum.TextYAlignment.Center

-- Plantilla para el botón izquierdo
ButtonTemplate.Parent = MainFrameLeft
ButtonTemplate.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
ButtonTemplate.TextColor3 = Color3.fromRGB(200, 200, 200)
ButtonTemplate.BorderSizePixel = 2
ButtonTemplate.BorderColor3 = Color3.fromRGB(160, 160, 160)
ButtonTemplate.Font = Enum.Font.SourceSansBold
ButtonTemplate.TextSize = 12
ButtonTemplate.TextWrapped = false

-- ===== NUEVA DISTRIBUCIÓN: 2, 4, 4 =====
local rowData = {
    { -- Fila 1: 2 botones (más a la izquierda)
        {"LAGGER", "CARRY"},
        {"BAT", "TP"}
    },
    { -- Fila 2: 4 botones
        {"DROP", "BRAINROT"},
        {"AUTO", "LEFT"},
        {"AUTO", "BAT"},
        {"AUTO", "RIGHT"}
    },
    { -- Fila 3: 4 botones
        {"TP", "DOWN"},
        {"CARRY", "SPEED"},
        {"LAGGER", "MODE"},
        {"INSTA", "RESET"}
    }
}

local buttons = {}
local buttonSize = UDim2.new(0, 75, 0, 60) -- Un poco más ancho y menos alto para texto grande
local spacingX = 4
local spacingY = 6
local startX = 2  -- Mover a la izquierda
local startY = 5

-- Crear botones en el marco derecho
for rowIndex, row in ipairs(rowData) do
    for colIndex, data in ipairs(row) do
        local btn = RightButtonTemplate:Clone()
        btn.Parent = MainFrame
        
        local xPos = startX + ((colIndex - 1) * (buttonSize.X.Offset + spacingX))
        local yPos = startY + ((rowIndex - 1) * (buttonSize.Y.Offset + spacingY))
        btn.Position = UDim2.new(0, xPos, 0, yPos)
        btn.Size = buttonSize
        
        btn.Text = data[1] .. "\n" .. data[2]
        
        -- Esquinas redondeadas
        local corner = Instance.new("UICorner")
        corner.Parent = btn
        corner.CornerRadius = UDim.new(0, 12)
        
        btn.MouseEnter:Connect(function()
            btn.BorderColor3 = Color3.fromRGB(255, 255, 255)
            btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        end)
        
        btn.MouseLeave:Connect(function()
            btn.BorderColor3 = Color3.fromRGB(255, 255, 255)
            btn.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
        end)
        
        btn.MouseButton1Click:Connect(function()
            print("Botón " .. data[1] .. " " .. data[2] .. " presionado!")
        end)
        
        table.insert(buttons, btn)
    end
end

-- ===== VARIABLES DE ESTADO =====
local selectedMode = "Main"
local autoRoboState = false

-- ===== PANEL EMERGENTE (Force.vs) =====
local PanelFrame = Instance.new("Frame")
PanelFrame.Parent = ScreenGui
PanelFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
PanelFrame.BackgroundTransparency = 0
PanelFrame.Size = UDim2.new(0, 450, 0, 280)
PanelFrame.Position = UDim2.new(0.5, -225, 0.5, -140)
PanelFrame.Visible = false
PanelFrame.BorderSizePixel = 2
PanelFrame.BorderColor3 = Color3.fromRGB(200, 200, 200)

local panelCorner = Instance.new("UICorner")
panelCorner.Parent = PanelFrame
panelCorner.CornerRadius = UDim.new(0, 10)

-- ===== TÍTULO =====
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

-- ===== LÍNEA HORIZONTAL =====
local LineFrame = Instance.new("Frame")
LineFrame.Parent = PanelFrame
LineFrame.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
LineFrame.Size = UDim2.new(0, 400, 0, 2)
LineFrame.Position = UDim2.new(0.5, -200, 0, 55)
LineFrame.BackgroundTransparency = 0
LineFrame.BorderSizePixel = 0

-- ===== BOTONES SPEED Y STEAL =====
local MainButton = Instance.new("TextButton")
MainButton.Parent = PanelFrame
MainButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainButton.Size = UDim2.new(0, 80, 0, 35)
MainButton.Position = UDim2.new(0.5, -190, 0, 75)
MainButton.Text = "Speed"
MainButton.TextColor3 = Color3.fromRGB(200, 200, 200)
MainButton.TextSize = 16
MainButton.Font = Enum.Font.SourceSansBold
MainButton.BorderSizePixel = 2
MainButton.BorderColor3 = Color3.fromRGB(160, 160, 160)

local mainCorner = Instance.new("UICorner")
mainCorner.Parent = MainButton
mainCorner.CornerRadius = UDim.new(0, 5)

local StealButton = Instance.new("TextButton")
StealButton.Parent = PanelFrame
StealButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
StealButton.Size = UDim2.new(0, 80, 0, 35)
StealButton.Position = UDim2.new(0.5, -190, 0, 125)
StealButton.Text = "Steal"
StealButton.TextColor3 = Color3.fromRGB(200, 200, 200)
StealButton.TextSize = 16
StealButton.Font = Enum.Font.SourceSansBold
StealButton.BorderSizePixel = 2
StealButton.BorderColor3 = Color3.fromRGB(160, 160, 160)

local stealCorner = Instance.new("UICorner")
stealCorner.Parent = StealButton
stealCorner.CornerRadius = UDim.new(0, 5)

-- ===== CONTENEDOR DERECHO =====
local RightContainer = Instance.new("Frame")
RightContainer.Parent = PanelFrame
RightContainer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
RightContainer.BackgroundTransparency = 1
RightContainer.Size = UDim2.new(0, 200, 0, 150)
RightContainer.Position = UDim2.new(0.5, -60, 0, 70)

-- ===== CONTENIDO DE SPEED =====
local MainContent = Instance.new("Frame")
MainContent.Parent = RightContainer
MainContent.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainContent.BackgroundTransparency = 1
MainContent.Size = UDim2.new(0, 200, 0, 150)
MainContent.Position = UDim2.new(0, 0, 0, 0)

-- 1. Normal Speed
local SpeedContainer = Instance.new("Frame")
SpeedContainer.Parent = MainContent
SpeedContainer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SpeedContainer.BackgroundTransparency = 1
SpeedContainer.Size = UDim2.new(0, 200, 0, 35)
SpeedContainer.Position = UDim2.new(0, 0, 0, 0)

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Parent = SpeedContainer
SpeedLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Size = UDim2.new(0, 110, 0, 35)
SpeedLabel.Position = UDim2.new(0, 0, 0, 0)
SpeedLabel.Text = "Normal Speed"
SpeedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SpeedLabel.TextSize = 16
SpeedLabel.Font = Enum.Font.SourceSansBold
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left

local SpeedInput = Instance.new("TextBox")
SpeedInput.Parent = SpeedContainer
SpeedInput.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
SpeedInput.Size = UDim2.new(0, 80, 0, 30)
SpeedInput.Position = UDim2.new(0, 115, 0, 2)
SpeedInput.Text = tostring(savedSpeed)
SpeedInput.TextColor3 = Color3.fromRGB(200, 200, 200)
SpeedInput.TextSize = 16
SpeedInput.Font = Enum.Font.SourceSansBold
SpeedInput.BorderSizePixel = 2
SpeedInput.BorderColor3 = Color3.fromRGB(200, 200, 200)
SpeedInput.PlaceholderText = "1-60"
SpeedInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
SpeedInput.ClearTextOnFocus = false

local inputCorner = Instance.new("UICorner")
inputCorner.Parent = SpeedInput
inputCorner.CornerRadius = UDim.new(0, 5)

SpeedInput.FocusLost:Connect(function()
    local value = tonumber(SpeedInput.Text)
    if value then
        if value < 1 then value = 1
        elseif value > 60 then value = 60 end
        SpeedInput.Text = tostring(value)
        player:SetAttribute("SpeedValue", value)
        print("Normal Speed ajustado a: " .. value)
    else
        SpeedInput.Text = tostring(savedSpeed)
    end
end)

-- 2. Carry Speed
local CarryContainer = Instance.new("Frame")
CarryContainer.Parent = MainContent
CarryContainer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
CarryContainer.BackgroundTransparency = 1
CarryContainer.Size = UDim2.new(0, 200, 0, 35)
CarryContainer.Position = UDim2.new(0, 0, 0, 45)

local CarryLabel = Instance.new("TextLabel")
CarryLabel.Parent = CarryContainer
CarryLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
CarryLabel.BackgroundTransparency = 1
CarryLabel.Size = UDim2.new(0, 100, 0, 35)
CarryLabel.Position = UDim2.new(0, 0, 0, 0)
CarryLabel.Text = "Carry Speed"
CarryLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
CarryLabel.TextSize = 16
CarryLabel.Font = Enum.Font.SourceSansBold
CarryLabel.TextXAlignment = Enum.TextXAlignment.Left

local CarryInput = Instance.new("TextBox")
CarryInput.Parent = CarryContainer
CarryInput.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
CarryInput.Size = UDim2.new(0, 80, 0, 30)
CarryInput.Position = UDim2.new(0, 110, 0, 2)
CarryInput.Text = tostring(savedCarry)
CarryInput.TextColor3 = Color3.fromRGB(200, 200, 200)
CarryInput.TextSize = 16
CarryInput.Font = Enum.Font.SourceSansBold
CarryInput.BorderSizePixel = 2
CarryInput.BorderColor3 = Color3.fromRGB(200, 200, 200)
CarryInput.PlaceholderText = "1-60"
CarryInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
CarryInput.ClearTextOnFocus = false

local carryInputCorner = Instance.new("UICorner")
carryInputCorner.Parent = CarryInput
carryInputCorner.CornerRadius = UDim.new(0, 5)

CarryInput.FocusLost:Connect(function()
    local value = tonumber(CarryInput.Text)
    if value then
        if value < 1 then value = 1
        elseif value > 60 then value = 60 end
        CarryInput.Text = tostring(value)
        player:SetAttribute("CarrySpeedValue", value)
        print("Carry Speed ajustado a: " .. value)
    else
        CarryInput.Text = tostring(savedCarry)
    end
end)

-- 3. Lagger Mode
local LaggerContainer = Instance.new("Frame")
LaggerContainer.Parent = MainContent
LaggerContainer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
LaggerContainer.BackgroundTransparency = 1
LaggerContainer.Size = UDim2.new(0, 200, 0, 35)
LaggerContainer.Position = UDim2.new(0, 0, 0, 90)

local LaggerLabel = Instance.new("TextLabel")
LaggerLabel.Parent = LaggerContainer
LaggerLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
LaggerLabel.BackgroundTransparency = 1
LaggerLabel.Size = UDim2.new(0, 110, 0, 35)
LaggerLabel.Position = UDim2.new(0, 0, 0, 0)
LaggerLabel.Text = "Lagger Mode"
LaggerLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
LaggerLabel.TextSize = 16
LaggerLabel.Font = Enum.Font.SourceSansBold
LaggerLabel.TextXAlignment = Enum.TextXAlignment.Left

local LaggerInput = Instance.new("TextBox")
LaggerInput.Parent = LaggerContainer
LaggerInput.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
LaggerInput.Size = UDim2.new(0, 80, 0, 30)
LaggerInput.Position = UDim2.new(0, 115, 0, 2)
LaggerInput.Text = tostring(savedLagger)
LaggerInput.TextColor3 = Color3.fromRGB(200, 200, 200)
LaggerInput.TextSize = 16
LaggerInput.Font = Enum.Font.SourceSansBold
LaggerInput.BorderSizePixel = 2
LaggerInput.BorderColor3 = Color3.fromRGB(200, 200, 200)
LaggerInput.PlaceholderText = "1-20"
LaggerInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
LaggerInput.ClearTextOnFocus = false

local laggerInputCorner = Instance.new("UICorner")
laggerInputCorner.Parent = LaggerInput
laggerInputCorner.CornerRadius = UDim.new(0, 5)

LaggerInput.FocusLost:Connect(function()
    local value = tonumber(LaggerInput.Text)
    if value then
        if value < 1 then value = 1
        elseif value > 20 then value = 20 end
        LaggerInput.Text = tostring(value)
        player:SetAttribute("LaggerModeValue", value)
        print("Lagger Mode ajustado a: " .. value)
    else
        LaggerInput.Text = tostring(savedLagger)
    end
end)

-- ===== CONTENIDO DE STEAL =====
local StealContent = Instance.new("Frame")
StealContent.Parent = RightContainer
StealContent.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
StealContent.BackgroundTransparency = 1
StealContent.Size = UDim2.new(0, 200, 0, 60)
StealContent.Position = UDim2.new(0, 0, 0, 0)
StealContent.Visible = false

local RoboLabel = Instance.new("TextLabel")
RoboLabel.Parent = StealContent
RoboLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
RoboLabel.BackgroundTransparency = 1
RoboLabel.Size = UDim2.new(0, 140, 0, 35)
RoboLabel.Position = UDim2.new(0, 0, 0, 0)
RoboLabel.Text = "Robo Automático"
RoboLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
RoboLabel.TextSize = 16
RoboLabel.Font = Enum.Font.SourceSansBold
RoboLabel.TextXAlignment = Enum.TextXAlignment.Left

local ToggleButton = Instance.new("TextButton")
ToggleButton.Parent = StealContent
ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleButton.Size = UDim2.new(0, 60, 0, 30)
ToggleButton.Position = UDim2.new(0, 150, 0, 2)
ToggleButton.Text = "Off"
ToggleButton.TextColor3 = Color3.fromRGB(255, 100, 100)
ToggleButton.TextSize = 14
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.BorderSizePixel = 2
ToggleButton.BorderColor3 = Color3.fromRGB(200, 200, 200)

local toggleCorner = Instance.new("UICorner")
toggleCorner.Parent = ToggleButton
toggleCorner.CornerRadius = UDim.new(0, 5)

local function updateToggle()
    if autoRoboState then
        ToggleButton.Text = "On"
        ToggleButton.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        ToggleButton.Text = "Off"
        ToggleButton.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end

ToggleButton.MouseButton1Click:Connect(function()
    autoRoboState = not autoRoboState
    updateToggle()
    print("Robo Automático: " .. (autoRoboState and "ON" or "OFF"))
end)

ToggleButton.MouseEnter:Connect(function()
    ToggleButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
end)

ToggleButton.MouseLeave:Connect(function()
    ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
end)

-- ===== FUNCIONES DE VISIBILIDAD =====
local function updateContent()
    if selectedMode == "Main" then
        MainContent.Visible = true
        StealContent.Visible = false
        MainButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        MainButton.BorderColor3 = Color3.fromRGB(200, 200, 200)
        StealButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        StealButton.BorderColor3 = Color3.fromRGB(160, 160, 160)
    else
        MainContent.Visible = false
        StealContent.Visible = true
        StealButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        StealButton.BorderColor3 = Color3.fromRGB(200, 200, 200)
        MainButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        MainButton.BorderColor3 = Color3.fromRGB(160, 160, 160)
    end
end

MainButton.MouseButton1Click:Connect(function()
    selectedMode = "Main"
    updateContent()
end)

StealButton.MouseButton1Click:Connect(function()
    selectedMode = "Steal"
    updateContent()
end)

MainButton.MouseEnter:Connect(function()
    if selectedMode ~= "Main" then
        MainButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    end
end)

MainButton.MouseLeave:Connect(function()
    if selectedMode ~= "Main" then
        MainButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    end
end)

StealButton.MouseEnter:Connect(function()
    if selectedMode ~= "Steal" then
        StealButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    end
end)

StealButton.MouseLeave:Connect(function()
    if selectedMode ~= "Steal" then
        StealButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    end
end)

-- ===== BOTÓN CERRAR =====
local CloseButton = Instance.new("TextButton")
CloseButton.Parent = PanelFrame
CloseButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
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
    CloseButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

CloseButton.MouseLeave:Connect(function()
    CloseButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    CloseButton.TextColor3 = Color3.fromRGB(200, 200, 200)
end)

CloseButton.MouseButton1Click:Connect(function()
    PanelFrame.Visible = false
end)

-- ===== BOTÓN IZQUIERDO "Force.vs" (movible) =====
local leftButton = ButtonTemplate:Clone()
leftButton.Parent = MainFrameLeft
leftButton.Size = UDim2.new(0, 110, 0, 45)
leftButton.Position = UDim2.new(0.5, -55, 0.5, -22.5)
leftButton.Text = "Force.vs"
leftButton.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
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
    leftButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
end)

leftButton.MouseLeave:Connect(function()
    leftButton.BorderColor3 = Color3.fromRGB(160, 160, 160)
    leftButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    leftButton.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
end)

leftButton.MouseButton1Click:Connect(function()
    PanelFrame.Visible = true
    updateContent()
    updateToggle()
end)

-- ===== SISTEMA DE ARRASTRE =====
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

-- ============================================================
-- ===== INDICADOR DE VELOCIDAD SOBRE EL PERSONAJE (SIN FONDO) =====
-- ============================================================

local function createSpeedIndicator()
    local character = player.Character
    if not character then
        character = player.CharacterAdded:Wait()
    end
    
    local head = character:WaitForChild("Head")
    
    local billboard = Instance.new("BillboardGui")
    billboard.Parent = head
    billboard.Size = UDim2.new(0, 80, 0, 30)
    billboard.Adornee = head
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 100
    billboard.Enabled = true
    
    -- Solo el texto, sin fondo
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Parent = billboard
    speedLabel.Size = UDim2.new(1, 0, 1, 0)
    speedLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    speedLabel.BackgroundTransparency = 1
    speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedLabel.TextSize = 20
    speedLabel.Font = Enum.Font.SourceSansBold
    speedLabel.Text = "0.0"
    speedLabel.TextScaled = true
    speedLabel.TextWrapped = true
    speedLabel.TextXAlignment = Enum.TextXAlignment.Center
    speedLabel.TextYAlignment = Enum.TextYAlignment.Center
    
    local humanoid = character:WaitForChild("Humanoid")
    local isMoving = false
    
    humanoid.Running:Connect(function(speed)
        if speed > 0.1 then
            isMoving = true
            local speedValue = player:GetAttribute("SpeedValue") or 30
            speedLabel.Text = string.format("%.1f", speedValue)
        else
            isMoving = false
            speedLabel.Text = "0.0"
        end
    end)
    
    player:GetAttributeChangedSignal("SpeedValue"):Connect(function()
        if isMoving then
            local speedValue = player:GetAttribute("SpeedValue") or 30
            speedLabel.Text = string.format("%.1f", speedValue)
        end
    end)
end

if player.Character then
    createSpeedIndicator()
else
    player.CharacterAdded:Connect(createSpeedIndicator)
end

-- ===== INICIALIZACIÓN =====
updateContent()
updateToggle()
print("GUI actualizada: fila1 (2 botones) y fila2 (4 botones) movidas a la izquierda, letras más grandes y ajustadas.")