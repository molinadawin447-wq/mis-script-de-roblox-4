-- Configuración de la GUI
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ButtonTemplate = Instance.new("TextButton")

-- Propiedades de la GUI principal
ScreenGui.Parent = game.Players.LocalPlayer.PlayerGui
ScreenGui.Name = "CustomGUI"

-- Marco principal (transparente)
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 1 -- Totalmente transparente
MainFrame.Size = UDim2.new(0, 500, 0, 250)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -125)

-- Plantilla de botón
ButtonTemplate.Parent = MainFrame
ButtonTemplate.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- Negro suave
ButtonTemplate.Text = "" -- Sin texto
ButtonTemplate.TextColor3 = Color3.fromRGB(255, 255, 255)
ButtonTemplate.BorderSizePixel = 0
ButtonTemplate.Font = Enum.Font.SourceSansBold
ButtonTemplate.TextSize = 0 -- Tamaño de texto 0 para asegurar que no se vea

-- Crear botones (5 filas x 2 columnas) - Vertical
local buttons = {}
local buttonSize = UDim2.new(0, 70, 0, 50) -- Tamaño pequeño
local spacing = 12
local startX = 20
local startY = 15

-- Cambiar a 5 filas y 2 columnas (vertical)
for row = 0, 4 do
    for col = 0, 1 do
        local btn = ButtonTemplate:Clone()
        btn.Parent = MainFrame
        
        -- Posición: columnas verticales
        local xPos = startX + (col * (buttonSize.X.Offset + spacing + 20)) -- Más espacio entre columnas
        local yPos = startY + (row * (buttonSize.Y.Offset + spacing))
        btn.Position = UDim2.new(0, xPos, 0, yPos)
        btn.Size = buttonSize
        
        -- Esquinas redondeadas
        btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        btn.BorderSizePixel = 0
        btn.Text = "" -- Asegurar que no tenga texto
        
        -- Evento click
        btn.MouseButton1Click:Connect(function()
            print("Botón " .. (row * 2 + col + 1) .. " presionado!")
            -- Aquí puedes agregar la funcionalidad que desees
        end)
        
        table.insert(buttons, btn)
    end
end

-- Aplicar esquinas redondeadas a todos los botones
for _, btn in pairs(buttons) do
    local corner = Instance.new("UICorner")
    corner.Parent = btn
    corner.CornerRadius = UDim.new(0, 10) -- Radio de 10 píxeles
end

print("GUI vertical creada correctamente! Botones sin texto y fondo transparente.")