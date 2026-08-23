-- Crear el ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PanelAdmin"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Crear el Frame principal
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 300)
MainFrame.Position = UDim2.new(0.75, 0, 0.05, 0) -- <--- Subido a 0.05 (más arriba)
MainFrame.BackgroundTransparency = 1 
MainFrame.Parent = ScreenGui

-- Lista de nombres y funciones
local botonesData = {
	{"DROP BRAINROT", function() print("Has pulsado DROP BRAINROT") end},
	{"AUTO LEFT", function() print("Has pulsado AUTO LEFT") end},
	{"AUTO BAT", function() print("Has pulsado AUTO BAT") end},
	{"AUTO RIGHT", function() print("Has pulsado AUTO RIGHT") end},
	
	{"TP DOWN", function()
		local player = game.Players.LocalPlayer
		local char = player.Character or player.CharacterAdded:Wait()
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if hrp then
			hrp.CFrame = hrp.CFrame - Vector3.new(0, 10, 0) 
		end
	end},
	
	{"INSTA RESET", function()
		local player = game.Players.LocalPlayer
		player:LoadCharacter() 
	end},
	
	{"CARRY SPEED", function() print("Has pulsado CARRY SPEED") end},
	{"LAGGER MODE", function() print("Has pulsado LAGGER MODE") end},
	{"LAGGER CARRY", function() print("Has pulsado LAGGER CARRY") end},
	{"BAT TP", function() print("Has pulsado BAT TP") end}
}

-- Función para crear botones cuadrados
local function crearBoton(nombre, funcion, x, y)
	local boton = Instance.new("TextButton")
	boton.Size = UDim2.new(0, 80, 0, 40) -- Tamaño cuadrado
	boton.Position = UDim2.new(0, x, 0, y)
	boton.Text = nombre
	boton.TextColor3 = Color3.fromRGB(255, 255, 255)
	boton.Font = Enum.Font.GothamBold
	boton.TextSize = 12
	boton.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
	boton.Parent = MainFrame
	
	-- Esquinas en ángulo recto (cuadrados perfectos)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 0) 
	corner.Parent = boton
	
	boton.MouseButton1Click:Connect(funcion)
	
	return boton
end

-- Posicionar los botones
local startX, startY = 0, 0
local gapX, gapY = 90, 45

for i, data in ipairs(botonesData) do
	local nombre, funcion = data[1], data[2]
	local columna = (i - 1) % 2
	local fila = math.floor((i - 1) / 2)
	
	local x = startX + (columna * gapX)
	local y = startY + (fila * gapY)
	
	crearBoton(nombre, funcion, x, y)
end