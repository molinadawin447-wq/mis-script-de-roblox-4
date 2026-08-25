-- Configuración de la GUI
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local MainFrameLeft = Instance.new("Frame") -- Nuevo marco para la izquierda
local ButtonTemplate = Instance.new("TextButton")

-- Propiedades de la GUI principal
ScreenGui.Parent = game.Players.LocalPlayer.PlayerGui
ScreenGui.Name = "CustomGUI"

-- ===== MARCO DERECHO (botones principales) =====
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 1
MainFrame.Size = UDim2.new(0, 220, 0, 330)
MainFrame.Position = UDim2.new(1, -220, 0.35, -165) -- Más a la derecha (-220)

-- ===== MARCO IZQUIERDO (botón adicional) =====
MainFrameLeft.Parent = ScreenGui
MainFrameLeft.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrameLeft.BackgroundTransparency = 1
MainFrameLeft.Size = UDim2.new(0, 100, 0, 60) -- Tamaño para un solo botón
MainFrameLeft.Position = UDim2.new(0, 20, 0.35, -30) -- Lado izquierdo

-- Plantilla de botón
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

-- Crear botones en el marco derecho (5 filas x 2 columnas)
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

-- ===== BOTÓN IZQUIERDO (adicional) =====
local leftButton = ButtonTemplate:Clone()
leftButton.Parent = MainFrameLeft
leftButton.Size = UDim2.new(0, 85, 0, 40)
leftButton.Position = UDim2.new(0.5, -42.5, 0.5, -20) -- Centrado en el marco
leftButton.Text = "EXTRA"
leftButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
leftButton.BorderSizePixel = 2
leftButton.BorderColor3 = Color3.fromRGB(160, 160, 160)
leftButton.TextColor3 = Color3.fromRGB(200, 200, 200)

local cornerLeft = Instance.new("UICorner")
cornerLeft.Parent = leftButton
cornerLeft.CornerRadius = UDim.new(0, 8)

leftButton.MouseEnter:Connect(function()
    leftButton.BorderColor3 = Color3.fromRGB(200, 200, 200)
    leftButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
end)

leftButton.MouseLeave:Connect(function()
    leftButton.BorderColor3 = Color3.fromRGB(160, 160, 160)
    leftButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
end)

leftButton.MouseButton1Click:Connect(function()
    print("Botón EXTRA presionado!")
end)

print("GUI con botones a la derecha y botón extra a la izquierda creada!")