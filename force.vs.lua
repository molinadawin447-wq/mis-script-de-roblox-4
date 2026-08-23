-- ==========================================
--  SCRIPT: FORCE HUB
--  Menú completo con TP, Robo, Salto, Velocidad, Volar y Reset
--  Estilo: Botones a la derecha, cuadrados, con bordes blancos y separados
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

-- 1. Crear la pantalla principal (Invisible, solo para agrupar los botones)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ForceHubGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- ==========================================
--  FUNCIÓN PARA CREAR BOTONES ESTILO "CUADRO"
-- ==========================================
local function CreateButton(name, text, yPos)
	local button = Instance.new("TextButton")
	button.Name = name
	
	-- Tamaño cuadrado (Ancho y Alto iguales)
	button.Size = UDim2.new(0, 80, 0, 80) 
	
	-- Posición: En el lado derecho (1 = 100% de la pantalla), con un margen de -110 para que no se pegue al borde
	button.Position = UDim2.new(1, -110, 0, yPos)
	
	-- Fondo del botón (Negro/Gris oscuro)
	button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	
	-- Borde blanco
	button.BorderColor3 = Color3.fromRGB(255, 255, 255)
	button.BorderSizePixel = 2 -- Grosor del borde
	
	-- Texto del botón
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Font = Enum.Font.GothamBold
	button.TextSize = 12
	button.Text = text
	button.TextWrapped = true -- Para que el texto no se salga del cuadrado
	button.AutoButtonColor = true
	
	button.Parent = ScreenGui
	return button
end

-- Crear botones (Aumenté la separación a 100 para que tengan espacio entre ellos)
local RoboBtn = CreateButton("RoboBtn", "ROBO", 100)
local TPBtn = CreateButton("TPBtn", "TP DOWN", 200)
local SaltoBtn = CreateButton("SaltoBtn", "SALTO", 300)
local VelocidadBtn = CreateButton("VelocidadBtn", "VELOCIDAD", 400)
local VolarBtn = CreateButton("VolarBtn", "VOLAR", 500)
local ResetBtn = CreateButton("ResetBtn", "RESET", 600)
local CerrarBtn = CreateButton("CerrarBtn", "CERRAR", 700)

-- ==========================================
--  FUNCIONALIDAD DE LA GUI (Abrir/Cerrar)
-- ==========================================

-- Abrir/Cerrar con la tecla "M"
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode.M then
		-- Como los botones están sueltos, los ocultamos todos juntos usando el ScreenGui
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
		SaltoBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0) -- Verde
	else
		Humanoid.JumpPower = 50
		SaltoBtn.Text = "SALTO"
		SaltoBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25) -- Gris oscuro
	end
end)

-- Botón Velocidad (On/Off)
local velocidadActiva = false
VelocidadBtn.MouseButton1Click:Connect(function()
	velocidadActiva = not velocidadActiva
	if velocidadActiva then
		Humanoid.WalkSpeed = 100
		VelocidadBtn.Text = "VELOCIDAD: ON"
		VelocidadBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0) -- Verde
	else
		Humanoid.WalkSpeed = 16
		VelocidadBtn.Text = "VELOCIDAD"
		VelocidadBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25) -- Gris oscuro
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
		
		-- Loop para mantener el vuelo mientras mueves la cámara
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
		VolarBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
		Humanoid.PlatformStand = false
		RootPart.Velocity = Vector3.new(0, 0, 0)
		if volarLoop then volarLoop:Disconnect() end
	end
end)

-- Botón Reset (Reiniciar personaje)
ResetBtn.MouseButton1Click:Connect(function()
	-- Apagamos las funciones por si acaso
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

	-- Forzamos el reinicio del personaje
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