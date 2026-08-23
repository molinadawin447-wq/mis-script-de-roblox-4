local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Definir los botones en el orden exacto de la imagen (fila por fila)
local botones = {
    -- Fila 1
    {"DROP", "BR", "AUTO", "Y/out", "Radius:61"},
    -- Fila 2
    {"LEFT", "CLEANHUB", "73%", "TP"},
    -- Fila 3
    {"AGGER", "BAT", "BAT", "AUTO"},
    -- Fila 4
    {"AIMBOT", "RIGHT", "CMico", "LAGGER"},
    -- Fila 5
    {"M", "OFF", "Carama y Madundung", "MID"},
    -- Fila 6
    {"HIGH", "BAT", "V2", "DOWN"},
    -- Fila 7
    {"TP", "CARRY", "SPD", "LAGGER"},
    -- Fila 8
    {"RESET", "LAGGER", "2", ""},
    -- Fila 9 (parte inferior)
    {"@roblox_user_4188918803 won the duel!", "$2.70a", "Aumento de amigos:+10%"}
}

local tamanioBoton = UDim2.new(0, 100, 0, 35)
local espacioX = 10
local espacioY = 10
local inicioX = 0.5 -- Centrado horizontalmente
local inicioY = 0.05

for filaIndex, fila in ipairs(botones) do
    for colIndex, nombre in ipairs(fila) do
        if nombre ~= "" then
            local boton = Instance.new("TextButton")
            
            -- Calcular posición
            local posX = (colIndex - 1) * (tamanioBoton.X.Offset + espacioX)
            local posY = (filaIndex - 1) * (tamanioBoton.Y.Offset + espacioY)
            
            boton.Size = tamanioBoton
            boton.Position = UDim2.new(0, posX + 50, 0, posY + 50)
            boton.Text = nombre
            boton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            boton.TextColor3 = Color3.fromRGB(255, 255, 255)
            boton.BorderSizePixel = 1
            boton.BorderColor3 = Color3.fromRGB(100, 100, 100)
            boton.Font = Enum.Font.SourceSansBold
            boton.TextSize = 14
            
            -- Colores especiales según la imagen
            if nombre == "DROP" or nombre == "BR" or nombre == "AIMBOT" then
                boton.BackgroundColor3 = Color3.fromRGB(180, 30, 30) -- Rojo
            elseif nombre == "CLEANHUB" then
                boton.BackgroundColor3 = Color3.fromRGB(30, 80, 180) -- Azul
            elseif nombre == "TP" then
                boton.BackgroundColor3 = Color3.fromRGB(30, 150, 30) -- Verde
            elseif nombre == "AGGER" then
                boton.BackgroundColor3 = Color3.fromRGB(200, 120, 20) -- Naranja
            elseif nombre == "$2.70a" then
                boton.BackgroundColor3 = Color3.fromRGB(200, 180, 20) -- Dorado
            elseif nombre == "Aumento de amigos:+10%" then
                boton.BackgroundColor3 = Color3.fromRGB(40, 100, 40) -- Verde oscuro
            end
            
            boton.Parent = screenGui
            
            -- Click event (opcional)
            boton.MouseButton1Click:Connect(function()
                print("Botón presionado: " .. nombre)
            end)
        end
    end
end