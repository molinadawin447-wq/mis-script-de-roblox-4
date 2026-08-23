local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Crear ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FenixStyleUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Crear el marco principal (usamos ImageLabel para poner la imagen de fondo)
local mainFrame = Instance.new("ImageLabel")
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- Color de respaldo
mainFrame.BorderSizePixel = 0
mainFrame.ScaleType = Enum.ScaleType.Slice -- (Opcional) Para que la imagen no se deforme
mainFrame.SliceCenter = Rect.new(100, 100, 100, 100) -- (Opcional) Para bordes redondeados
mainFrame.Parent = screenGui

-- AQUÍ ES DONDE PONES EL ID DE LA IMAGEN
-- Reemplaza "rbxassetid://TU_ID_AQUI" con el ID de la imagen que quieras usar
-- (Si usas una imagen subida a Roblox, se ve así: rbxassetid://1234567890)
mainFrame.Image = "rbxassetid://TU_ID_AQUI" 

-- Crear un marco oscuro semitransparente encima para que el texto se lea bien
local overlay = Instance.new("Frame")
overlay.Size = UDim2.new(1, 0, 1, 0)
overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
overlay.BackgroundTransparency = 0.4 -- 0.4 significa 40% transparente
overlay.BorderSizePixel = 0
overlay.Parent = mainFrame

-- Crear el título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.Text = "FENIX HUB"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

-- Función para crear botones (para que puedas ponerle varios sin repetir código)
local function createButton(text, yPos)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0.9, 0, 0, 40)
	button.Position = UDim2.new(0.05, 0, 0, yPos)
	button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	button.Text = text
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Font = Enum.Font.Gotham
	button.Parent = mainFrame
	
	button.MouseButton1Click:Connect(function()
		print(text .. " fue presionado")
		-- Tu lógica personalizada aquí (solo en tu propio juego)
	end)
	
	return button
end

-- Crear botones
createButton("Reset Mobile Positions", 60)
createButton("Animation Pack", 110)
createButton("Headless", 160)
createButton("Korblox", 210)
createButton("Save Config", 260)