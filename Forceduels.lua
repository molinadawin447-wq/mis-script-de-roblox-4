-- Configuración de la GUI
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ButtonTemplate = Instance.new("TextButton")

-- Propiedades de la GUI principal
ScreenGui.Parent = game.Players.LocalPlayer.PlayerGui
ScreenGui.Name = "CustomGUI"

-- Marco principal (transparente) - Ajustado para verse completo en pantalla
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 1 -- Totalmente transparente
MainFrame.Size = UDim2.new(0, 280, 0, 400) -- Marco más grande
MainFrame.Position = UDim2.new(1, -290, 0.5, -200) -- Centrado verticalmente con margen

-- Plantilla de botón
ButtonTemplate.Parent = MainFrame
ButtonTemplate.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ButtonTemplate.TextColor3 = Color3.fromRGB(255, 255, 255)
ButtonTemplate.BorderSizePixel = 0
ButtonTemplate.Font = Enum.Font.SourceSansBold
ButtonTemplate.TextSize = 11
ButtonTemplate.TextWrapped = true -- Envuelve el texto si es muy largo
ButtonTemplate.TextScaled = false

-- Datos de los botones
local buttonsData = {
    "DROP BRAINROT", "AUTO LEFT",
    "AUTO BAT", "AUTO RIGHT",
    "TP DOWN", "CARRY SPEED",
    "LAGGER MODE", "INSTA RESET",
    "LAGGER CARRY", "BAT TP"
}

local buttons = {}
local buttonSize = UDim2.new(0, 110, 0, 55) -- Botones más grandes
local spacing = 15
local startX = 15
local startY = 15

-- 5 filas y 2 columnas
for row = 0, 4 do
    for col = 0, 1 do
        local btn = ButtonTemplate:Clone()
        btn.Parent = MainFrame
        
        -- Posición dentro del marco
        local xPos = startX + (col * (buttonSize.X.Offset + spacing))
        local yPos = startY + (row * (buttonSize.Y.Offset + spacing))
        btn.Position = UDim2.new(0, xPos, 0, yPos)
        btn.Size = buttonSize
        
        -- Texto del botón
        local index = row * 2 + col + 1
        btn.Text = buttonsData[index] or "BTN " .. index
        
        -- Estilo del botón
        btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        btn.BorderSizePixel = 0
        
        -- Esquinas redondeadas
        local corner = Instance.new("UICorner")
        corner.Parent = btn
        corner.CornerRadius = UDim.new(0, 10)
        
        -- Efecto hover
        btn.MouseEnter:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        end)
        
        btn.MouseLeave:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        end)
        
        -- Evento click
        btn.MouseButton1Click:Connect(function()
            print("Botón " .. btn.Text .. " presionado!")
            -- Aquí puedes agregar la funcionalidad que desees
        end)
        
        table.insert(buttons, btn)
    end
end

-- Asegurar que el marco se vea completo en pantalla
MainFrame.ClipsDescendants = false

print("GUI completa visible en pantalla!")