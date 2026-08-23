-- Crear el ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PanelAdmin"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Crear el Frame principal
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 230, 0, 380) -- Marco un poco más grande para los botones
MainFrame.Position = UDim2.new(0.75, 0, 0.05, 0) 
MainFrame.BackgroundTransparency = 1 
MainFrame.Parent = ScreenGui

-- Lista de nombres y funciones (con saltos de línea \n para simular el texto en 2 líneas)
local botonesData = {
	{"DROP\nBRAINROT", false, function() print("Has pulsado DROP BRAINROT") end},
	{"AUTO\nLEFT", false, function() print("Has pulsado AUTO LEFT") end},
	{"AUTO\nBAT", false, function() print("Has pulsado AUTO BAT") end},
	{"AUTO\nRIGHT", false, function() print("Has pulsado AUTO RIGHT") end},
	
	{"TP\nDOWN", false, function()
		local player = game.Players.LocalPlayer
		local char = player.Character or player.CharacterAdded:Wait()
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if hrp then
			hrp.CFrame = hrp.CFrame - Vector3.new(0, 10, 0) 
		end
	end},
	
	-- El botón CARRY SPEED es el único de color blanco (esBlanco = true)
	{"CARRY\nSPEED", true, function() print("Has pulsado CARRY SPEED") end},
	
	{"LAGGER\nMODE", false, function() print("Has pulsado LAGGER MODE") end},
	{"INSTA\nRESET", false, function()
		local player = game.Players.LocalPlayer
		task.wait(0.1)
		player:LoadCharacter()
	end},
	
	{"LAGGER\nCARRY", false, function() print("Has pulsado LAGGER CARRY") end},
	{"BAT\nTP", false, function() print("Has pulsado BAT TP") end}
}

-- Función para crear botones
local function crearBoton(nombre, esBlanco, funcion, x, y)
	local boton = Instance.new("TextButton")
	boton.Size = UDim2.new(0, 105, 0, 65) -- <--- Tamaño exacto de la imagen
	boton.Position = UDim2.new(0, x, 0, y)
	boton.Text = nombre
	boton.Font = Enum.Font.GothamBold
	boton.TextSize = 16
	boton.Parent = MainFrame
	
	-- Configuración de colores según si es el botón blanco o los morados
	if esBlanco then
		boton.TextColor3 = Color3.fromRGB(20, 20, 20) -- Texto negro
		boton.BackgroundColor3 = Color3.fromRGB(235, 235, 235) -- Fondo blanco
	else
		boton.TextColor3 = Color3.fromRGB(255, 255, 255) -- Texto blanco
		boton.BackgroundColor3 = Color3.fromRGB(25, 15, 40) -- Fondo morado oscuro
	end
	
	-- Esquinas redondeadas (como en la imagen)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0.15, 0) -- Radio moderado
	corner.Parent = boton
	
	boton.MouseButton1Click:Connect(funcion)
	
	return boton
end

-- Posicionar los botones en cuadrícula
local startX, startY = 0, 0
local gapX, gapY = 115, 75 -- Espacio horizontal y vertical

for i, data in ipairs(botonesData) do
	local nombre, esBlanco, funcion = data[1], data[2], data[3]
	local columna = (i - 1) % 2
	local fila = math.floor((i - 1) / 2)
	
	local x = startX + (columna * gapX)
	local y = startY + (fila * gapY)
	
	crearBoton(nombre, esBlanco, funcion, x, y)
end