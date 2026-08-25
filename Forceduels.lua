-- Configuración de la GUI
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ButtonTemplate = Instance.new("TextButton")

-- Propiedades de la GUI principal
ScreenGui.Parent = game.Players.LocalPlayer.PlayerGui
ScreenGui.Name = "CustomGUI"

-- Marco principal (fondo negro)
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.Size = UDim2.new(0, 550, 0, 250)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -125)
MainFrame.BackgroundTransparency = 0

-- Plantilla de botón
ButtonTemplate.Parent = MainFrame
ButtonTemplate.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Gris oscuro
ButtonTemplate.TextColor3 = Color3.fromRGB(255, 255, 255)
ButtonTemplate.BorderSizePixel = 0
ButtonTemplate.Font = Enum.Font.SourceSansBold
ButtonTemplate.TextSize = 14

-- Crear botones (2 filas x 5 columnas)
local buttons = {}
local buttonSize = UDim2.new(0, 80, 0, 50) -- Tamaño pequeño
local spacing = 10
local startX = 15
local startY = 20

for row = 0, 1 do
    for col = 0, 4 do
        local btn = ButtonTemplate:Clone()
        btn.Parent = MainFrame
        
        -- Posición
        local xPos = startX + (col * (buttonSize.X.Offset + spacing))
        local yPos = startY + (row * (buttonSize.Y.Offset + spacing))
        btn.Position = UDim2.new(0, xPos, 0, yPos)
        btn.Size = buttonSize
        
        -- Esquinas redondeadas
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        btn.BorderSizePixel = 0
        
        -- Texto del botón
        btn.Text = "Btn " .. (row * 5 + col + 1)
        
        -- Evento click
        btn.MouseButton1Click:Connect(function()
            print("Botón " .. btn.Text .. " presionado!")
            -- Aquí puedes agregar la funcionalidad que desees
        end)
        
        table.insert(buttons, btn)
    end
end

-- Hacer que los botones tengan esquinas redondeadas
for _, btn in pairs(buttons) do
    local corner = Instance.new("UICorner")
    corner.Parent = btn
    corner.CornerRadius = UDim.new(0, 8) -- Radio de 8 píxeles
end

-- Hacer que el marco también tenga esquinas redondeadas (opcional)
local mainCorner = Instance.new("UICorner")
mainCorner.Parent = MainFrame
mainCorner.CornerRadius = UDim.new(0, 5)

print("GUI creada correctamente!")