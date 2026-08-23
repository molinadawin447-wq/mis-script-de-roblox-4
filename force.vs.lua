local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local botones = {
    "BAT", "AUTO", "AIMBOT", "RIGHT", "CMico", 
    "LAGGER", "M", "OFF", "MID", "HIGH", 
    "BAT V2", "DOWN", "TP", "CARRY", "SPD", 
    "LAGGER", "RESET", "LAGGER 2"
}

local yOffset = 0
local espacioEntreBotones = 8 -- Espacio en píxeles

for i, nombre in ipairs(botones) do
    local boton = Instance.new("TextButton")
    boton.Size = UDim2.new(0, 120, 0, 40)
    boton.Position = UDim2.new(1, -140, 0, yOffset)
    boton.Text = nombre
    boton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    boton.TextColor3 = Color3.fromRGB(255, 255, 255)
    boton.BorderSizePixel = 1
    boton.BorderColor3 = Color3.fromRGB(255, 255, 255)
    boton.Parent = screenGui
    
    yOffset = yOffset + 40 + espacioEntreBotones
end