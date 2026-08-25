-- Configuración de la GUI
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ButtonTemplate = Instance.new("TextButton")

-- Propiedades de la GUI principal
ScreenGui.Parent = game.Players.LocalPlayer.PlayerGui
ScreenGui.Name = "CustomGUI"

-- Marco principal (transparente) - Posicionado a la derecha
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 1 -- Totalmente transparente
MainFrame.Size = UDim2.new(0, 200, 0, 350) -- Marco más alto para los botones
MainFrame.Position = UDim2.new(1, -220, 0.5, -175) -- Anclado a la derecha

-- Plantilla de botón
ButtonTemplate.Parent = MainFrame
ButtonTemplate.BackgroundColor3 = Color3.fromRGB(25, 25, 25) -- Negro suave
ButtonTemplate.Text = "" -- Sin texto
ButtonTemplate.TextColor3 = Color3.fromRGB(255, 255, 255)
ButtonTemplate.BorderSizePixel = 0
ButtonTemplate.Font = Enum.Font.SourceSansBold
ButtonTemplate.TextSize = 0

-- Crear botones (5 filas x 2 columnas) - Vertical a la derecha
local buttons = {}
local buttonSize = UDim2.new(0, 75, 0, 50) -- Tamaño de botón
local spacing = 12
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
        
        -- Estilo del botón
        btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        btn.BorderSizePixel = 0
        btn.Text = ""
        
        -- Efecto hover (opcional)
        btn.MouseEnter:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45) -- Más claro al pasar el mouse
        end)
        
        btn.MouseLeave:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25) -- Vuelve al color original
        end)
        
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

print("GUI vertical a la derecha creada correctamente!")