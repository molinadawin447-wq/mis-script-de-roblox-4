-- Crear el ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PanelAdmin"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

---------------------------------------------------------
-- PARTE 1: EL BOTÓN "FORCE HUB" (ARRASTRABLE)
---------------------------------------------------------
local BotonForce = Instance.new("TextButton")
BotonForce.Name = "BotonForce"
BotonForce.Size = UDim2.new(0, 260, 0, 50) -- Tamaño similar al de la imagen
BotonForce.Position = UDim2.new(0.5, -130, 0.1, 0) -- Centrado horizontal, un poco abajo
BotonForce.Text = "FORCE HUB"
BotonForce.Font = Enum.Font.GothamBold -- Letra gruesa
BotonForce.TextSize = 22
BotonForce.TextColor3 = Color3.fromRGB(255, 255, 255) -- Texto blanco
BotonForce.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Fondo negro
BotonForce.Parent = ScreenGui

-- Redondear las esquinas del botón Force
local esquinasForce = Instance.new("UICorner")
esquinasForce.CornerRadius = UDim.new(0.15, 0) -- Bordes redondeados
esquinasForce.Parent = BotonForce

-- Añadir un pequeño contorno blanco para que resalte (opcional, como en la imagen)
local contorno = Instance.new("UIStroke")
contorno.Color = Color3.fromRGB(255, 255, 255)
contorno.Thickness = 1
contorno.Parent = BotonForce

-- Lógica para ARRASTRAR con el dedo
local dragging = false
local dragInput, mousePos, framePos

BotonForce.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		mousePos = input.Position
		framePos = BotonForce.Position
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

BotonForce.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - mousePos
		BotonForce.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
	end
end)

-- Función al hacer clic en el botón Force Hub
BotonForce.MouseButton1Click:Connect(function()
	print("Has pulsado FORCE HUB")
	-- Aquí puedes poner código para abrir/cerrar el menú, por ejemplo:
	-- MainFrame.Visible = not MainFrame.Visible
end)


---------------------------------------------------------
-- PARTE 2: LOS BOTONES DE LA CUADRÍCULA (TU MENÚ ANTERIOR)
---------------------------------------------------------
-- Crear el Frame principal
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 230, 0, 380)
MainFrame.Position = UDim2.new(0.75, 0, 0.2, 0) -- Lo bajé un poco para que no choque con el botón Force
MainFrame.BackgroundTransparency = 1 
MainFrame.Parent = ScreenGui

-- Lista de nombres y funciones
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
	boton.Size = UDim2.new(0, 105, 0, 65)
	boton.Position = UDim2.new(0, x, 0, y)
	boton.Text = nombre
	boton.Font = Enum.Font.GothamBold
	boton.TextSize = 16
	boton.Parent = MainFrame
	
	if esBlanco then
		boton.TextColor3 = Color3.fromRGB(20, 20, 20)
		boton.BackgroundColor3 = Color3.fromRGB(235, 235, 235)
	else
		boton.TextColor3 = Color3.fromRGB(255, 255, 255)
		boton.BackgroundColor3 = Color3.fromRGB(25, 15, 40)
	end
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0.15, 0)
	corner.Parent = boton
	
	boton.MouseButton1Click:Connect(funcion)
	
	return boton
end

-- Posicionar los botones
local startX, startY = 0, 0
local gapX, gapY = 115, 75 

for i, data in ipairs(botonesData) do
	local nombre, esBlanco, funcion = data[1], data[2], data[3]
	local columna = (i - 1) % 2
	local fila = math.floor((i - 1) / 2)
	
	local x = startX + (columna * gapX)
	local y = startY + (fila * gapY)
	
	crearBoton(nombre, esBlanco, funcion, x, y)
end