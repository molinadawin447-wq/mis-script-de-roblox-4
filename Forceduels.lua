-- Configuración de la GUI
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ButtonTemplate = Instance.new("TextButton")

-- Propiedades de la GUI principal
ScreenGui.Parent = game.Players.LocalPlayer.PlayerGui
ScreenGui.Name = "CustomGUI"

-- Marco principal (transparente) - Movido más arriba y a la derecha
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 1 -- Totalmente transparente
MainFrame.Size = UDim2.new(0, 220, 0, 330) -- Tamaño del marco
MainFrame.Position = UDim2.new(1, -240, 0.35, -165) -- Más arriba (0.35) y más a la derecha (-240)

-- Plantilla de botón
ButtonTemplate.Parent = MainFrame
ButtonTemplate.BackgroundColor3 = Color3.fromRGB(25, 25, 25) -- Negro
ButtonTemplate.TextColor3 = Color3.fromRGB(200, 200, 200) -- Gris claro para el texto
ButtonTemplate.BorderSizePixel = 2 -- Borde visible
ButtonTemplate.BorderColor3 = Color3.fromRGB(160, 160, 160) -- Borde gris
ButtonTemplate.Font = Enum.Font.SourceSansBold
ButtonTemplate.TextSize = 10
ButtonTemplate.TextWrapped = true
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
local buttonSize = UDim2.new(0, 85, 0, 40) -- Botones pequeños
local spacing = 10
local startX = 10
local startY = 10

-- 5 filas y 2 columnas
for row = 0, 4 do
    for col = 0, 1 do
        local btn = ButtonTemplate:Clone()
        btn.Parent = MainFrame
        
        -- Posición dentro del marco
        local xPos = startX + (col * (buttonSize.X.Offset + spacing + 5))
        local yPos = startY + (row * (buttonSize.Y.Offset + spacing))
        btn.Position = UDim2.new(0, xPos, 0, yPos)
        btn.Size = buttonSize
        
        -- Texto del botón
        local index = row * 2 + col + 1
        btn.Text = buttonsData[index] or "BTN " .. index
        
        -- Estilo del botón (borde gris)
        btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        btn.BorderSizePixel = 2
        btn.BorderColor3 = Color3.fromRGB(160, 160, 160) -- Borde gris
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        
        -- Esquinas redondeadas
        local corner = Instance.new("UICorner")
        corner.Parent = btn
        corner.CornerRadius = UDim.new(0, 8)
        
        -- Efecto hover
        btn.MouseEnter:Connect(function()
            btn.BorderColor3 = Color3.fromRGB(200, 200, 200) -- Borde más claro
            btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        end)
        
        btn.MouseLeave:Connect(function()
            btn.BorderColor3 = Color3.fromRGB(160, 160, 160) -- Vuelve al gris original
            btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        end)
        
        -- Evento click
        btn.MouseButton1Click:Connect(function()
            print("Botón " .. btn.Text .. " presionado!")
        end)
        
        table.insert(buttons, btn)
    end
end

print("GUI movida más arriba y a la derecha con bordes grises!")