-- ==========================================
--  SCRIPT: FORCE HUB V2
--  Estilo: Panel superior + Botones en cuadrícula a la derecha
-- ==========================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Esperar al personaje
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- ==========================================
--  CREACIÓN DE LA GUI (Interfaz)
-- ==========================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ForceHubGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- ==========================================
--  1. PANEL SUPERIOR "FORCE HUB"
-- ==========================================

-- Marco del panel (Cuadrado ancho pero pequeño, tipo banner)
local TopPanel = Instance.new("Frame")
TopPanel.Name = "TopPanel"
TopPanel.Size = UDim2.new(0, 220, 0, 45) -- Ancho: 220, Alto: 45 (tipo banner)
TopPanel.Position = UDim2.new(0.5, -110, 0, 30) -- Centrado arriba
TopPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 15) -- Casi negro
TopPanel.BorderColor3 = Color3.fromRGB(255, 255, 255) -- Borde blanco
TopPanel.BorderSizePixel = 2
TopPanel.Parent = ScreenGui

-- Texto del panel
local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, 0, 1, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "FORCE HUB"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 18
TitleText.Parent = TopPanel

-- ==========================================
--  2. CREACIÓN DE BOTONES EN CUADRÍCULA
-- ==========================================

-- Función para crear botones cuadrados y alinearlos
local function CreateButton(name, text, col, row)
	local button = Instance.new("TextButton")
	button.Name = name
	
	-- Tamaño del botón (Ancho y Alto iguales)
	button.Size = UDim2.new(0, 85, 0, 70) 
	
	-- Posición en el lado derecho
	-- Columna 0 (izquierda) y Columna 1 (derecha)
	-- Fila 0, 1, 2, 3...
	local xOffset = (col == 0) and -200 or -105
	local yOffset = 90 + (row * 80) -- Espacio de 10px entre filas (70 alto + 10 espacio)
	
	button.Position = UDim2.new(1, xOffset, 0, yOffset)
	
	-- Estilo: Fondo oscuro, borde blanco
	button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	button.BorderColor3 = Color3.fromRGB(255, 255, 255)
	button.BorderSizePixel = 2 
	
	-- Texto
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Font = Enum.Font.GothamBold
	button.TextSize = 11
	button.Text = text
	button.TextWrapped = true
	button.AutoButtonColor = true
	
	button.Parent = ScreenGui
	return button
end

-- CREAR BOTONES (Columnas 0 y 1, Filas 0 a 3)
-- Columna Izquierda (0)
local RoboBtn = CreateButton("RoboBtn", "ROBO", 0, 0)
local SaltoBtn = CreateButton("SaltoBtn", "SALTO", 0, 1)
local VelocidadBtn = CreateButton("VelocidadBtn", "VELOCIDAD", 0, 2)
local ResetBtn = CreateButton("ResetBtn", "RESET", 0, 3)

-- Columna Derecha (1)
local TPBtn = CreateButton("TPBtn", "TP DOWN", 1, 0)
local VolarBtn = CreateButton("VolarBtn", "VOLAR", 1, 1)
local InstaBtn = CreateButton("InstaBtn", "INSTA\nRESET", 1, 2) -- Ejemplo extra
local CerrarBtn = CreateButton("CerrarBtn", "CERRAR", 1, 3)

-- ==========================================
--  FUNCIONALIDAD DE LA GUI (Abrir/Cerrar)
-- ==========================================

-- Abrir/Cerrar con la tecla "M"
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode.M then
		ScreenGui.Enabled = not ScreenGui.Enabled
	end
end)

-- ==========================================
--  ACCIONES DE LOS BOTONES
-- ==========================================

-- Botón Cerrar
CerrarBtn.MouseButton1Click:Connect(function()
	ScreenGui.Enabled = false
end)

-- Botón TP (Bajar)
TPBtn.MouseButton1Click:Connect(function()
	RootPart.CFrame = RootPart.CFrame + Vector3.new(0, -15, 0)
end)

-- Botón Salto Infinito (On/Off)
local saltoActivo = false
SaltoBtn.MouseButton1Click:Connect(function()
	saltoActivo = not saltoActivo
	if saltoActivo then
		Humanoid.JumpPower = 250
		Humanoid.UseJumpPower = true
		SaltoBtn.Text = "SALTO: ON"
		SaltoBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
	else
		Humanoid.JumpPower = 50
		SaltoBtn.Text = "SALTO"
		SaltoBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	end
end)

-- Botón Velocidad (On/Off)
local velocidadActiva = false
VelocidadBtn.MouseButton1Click:Connect(function()
	velocidadActiva = not velocidadActiva
	if velocidadActiva then
		Humanoid.WalkSpeed = 100
		VelocidadBtn.Text = "VELOCIDAD: ON"
		VelocidadBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
	else
		Humanoid.WalkSpeed = 16
		VelocidadBtn.Text = "VELOCIDAD"
		VelocidadBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	end
end)

-- Botón Volar (On/Off)
local volando = false
local volarLoop
VolarBtn.MouseButton1Click:Connect(function()
	volando = not volando
	if volando then
		VolarBtn.Text = "VOLAR: ON"
		VolarBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
		Humanoid.PlatformStand = true
		
		volarLoop = game:GetService("RunService").RenderStepped:Connect(function()
			if volando then
				local camera = workspace.CurrentCamera
				local moveDir = camera.CFrame.LookVector * (UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or 0)
				local upDown = UserInputService:IsKeyDown(Enum.KeyCode.Space) and 1 or 0
				RootPart.Velocity = Vector3.new(moveDir.X * 100, upDown * 100, moveDir.Z * 100)
			end
		end)
		
	else
		VolarBtn.Text = "VOLAR"
		VolarBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		Humanoid.PlatformStand = false
		RootPart.Velocity = Vector3.new(0, 0, 0)
		if volarLoop then volarLoop:Disconnect() end
	end
end)

-- Botón Reset (Reiniciar personaje)
ResetBtn.MouseButton1Click:Connect(function()
	if volando then
		Humanoid.PlatformStand = false
		RootPart.Velocity = Vector3.new(0, 0, 0)
		if volarLoop then volarLoop:Disconnect() end
		volando = false
	end
	if velocidadActiva then
		Humanoid.WalkSpeed = 16
		velocidadActiva = false
	end
	if saltoActivo then
		Humanoid.JumpPower = 50
		saltoActivo = false
	end
	Humanoid.Health = 0
end)

-- Botón Insta Reset (Reset instantáneo sin esperar)
InstaBtn.MouseButton1Click:Connect(function()
	Humanoid.Health = 0
end)

-- Botón Robo Automático (Teletransportarse a otro jugador)
RoboBtn.MouseButton1Click:Connect(function()
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character then
			local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
			if targetRoot then
				RootPart.CFrame = targetRoot.CFrame
				RoboBtn.Text = "ROBANDO..."
				task.wait(1)
				RoboBtn.Text = "ROBO"
				break
			end
		end
	end
end)