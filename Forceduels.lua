-- Configuración de la GUI
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ButtonTemplate = Instance.new("TextButton")

-- Propiedades de la GUI principal
ScreenGui.Parent = game.Players.LocalPlayer.PlayerGui
ScreenGui.Name = "CustomGUI"

-- Marco principal (transparente) - Tamaño reducido para botones más pequeños
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 1 -- Totalmente transparente
MainFrame.Size = UDim2.new(0, 220, 0, 330) -- Marco más pequeño
MainFrame.Position = UDim2.new(1, -230, 0.5, -165) -- Centrado verticalmente

-- Plantilla de botón
ButtonTemplate.Parent = MainFrame
ButtonTemplate.BackgroundColor3 = Color3.fromRGB(25, 25, 25) -- Negro
ButtonTemplate.TextColor3 = Color3.fromRGB(200, 200, 200) -- Gris claro para el texto
ButtonTemplate.BorderSizePixel = 2 -- Borde visible
ButtonTemplate.BorderColor3 = Color3.fromRGB(180, 180, 180) -- Borde gris claro
ButtonTemplate.Font = Enum.Font.SourceSansBold
ButtonTemplate.TextSize = 10 -- Texto más pequeño
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
local buttonSize = UDim2.new(0, 85, 0, 40) -- Botones más pequeños y cuadrados
local spacing = 10 -- Espacio reducido
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
        
        -- Estilo del botón
        btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        btn.BorderSizePixel = 2
        btn.BorderColor3 = Color3.fromRGB(180, 180, 180) -- Borde gris claro
        btn.TextColor3 = Color3.fromRGB(200, 200, 200) -- Texto gris claro
        
        -- Esquinas redondeadas
        local corner = Instance.new("UICorner")
        corner.Parent = btn
        corner.CornerRadius = UDim.new(0, 8) -- Puntas redondeadas
        
        -- Efecto hover (borde más brillante)
        btn.MouseEnter:Connect(function()
            btn.BorderColor3 = Color3.fromRGB(220, 220, 220) -- Borde más claro
            btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        end)
        
        btn.MouseLeave:Connect(function()
            btn.BorderColor3 = Color3.fromRGB(180, 180, 180) -- Vuelve al borde original
            btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        end)
        
        -- Evento click
        btn.MouseButton1Click:Connect(function()
            print("Botón " .. btn.Text .. " presionado!")
        end)
        
        table.insert(buttons, btn)
    end
end

-- Aplicar esquinas redondeadas a todos los botones (ya aplicado en cada botón)
print("GUI con botones pequeños, cuadrados y bordes grises creada correctamente!")