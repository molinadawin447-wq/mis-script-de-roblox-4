-- Configuración de la GUI
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ButtonTemplate = Instance.new("TextButton")

-- Propiedades de la GUI principal
ScreenGui.Parent = game.Players.LocalPlayer.PlayerGui
ScreenGui.Name = "CustomGUI"

-- Marco principal (transparente) - Posicionado a la derecha y ajustado
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 1 -- Totalmente transparente
MainFrame.Size = UDim2.new(0, 250, 0, 380) -- Marco más ancho para texto completo
MainFrame.Position = UDim2.new(1, -210, 0.4, -190) -- Ajustado para el nuevo tamaño

-- Plantilla de botón
ButtonTemplate.Parent = MainFrame
ButtonTemplate.BackgroundColor3 = Color3.fromRGB(25, 25, 25) -- Negro suave
ButtonTemplate.TextColor3 = Color3.fromRGB(255, 255, 255)
ButtonTemplate.BorderSizePixel = 0
ButtonTemplate.Font = Enum.Font.SourceSansBold
ButtonTemplate.TextSize = 11 -- Tamaño de texto pequeño para que quepa

-- Crear botones (5 filas x 2 columnas) con los textos especificados
local buttonsData = {
    "DROP BRAINROT", "AUTO LEFT",
    "AUTO BAT", "AUTO RIGHT",
    "TP DOWN", "CARRY SPEED",
    "LAGGER MODE", "INSTA RESET",
    "LAGGER CARRY", "BAT TP"
}

local buttons = {}
local buttonSize = UDim2.new(0, 95, 0, 50) -- Botón más ancho para texto completo
local spacing = 12
local startX = 10
local startY = 15

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
        btn.BorderSizePixel = 0
        
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

-- Aplicar esquinas redondeadas a todos los botones
for _, btn in pairs(buttons) do
    local corner = Instance.new("UICorner")
    corner.Parent = btn
    corner.CornerRadius = UDim.new(0, 10)
end

print("GUI con textos personalizados creada correctamente!")