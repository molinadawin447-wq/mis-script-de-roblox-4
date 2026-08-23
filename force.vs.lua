-- ==========================================
--  SCRIPT: FORCE HUB
--  Menú completo con TP, Robo, Salto, Velocidad, Volar y Reset
--  Pegar en: StarterGui -> LocalScript (Nombre: Force Hub)
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

-- 1. Crear la pantalla principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ForceHubGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- 2. Crear el marco principal (Fondo)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 260, 0, 510) -- Aumenté la altura para el botón extra
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -255)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

-- 3. Crear el título "Force Hub"
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Title.Text = "Force Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = MainFrame

-- 4. Función para crear los botones
local function CreateButton(name, text, yPos)
	local button = Instance.new("TextButton")
	button.Name = name
	button.Size = UDim2.new(1, -20, 0, 40)
	button.Position = UDim2.new(0, 10, 0, yPos)
	button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Font = Enum.Font.Gotham
	button.TextSize = 14
	button.Text = text
	button.AutoButtonColor = true
	button.Parent = MainFrame
	return button
end

-- Crear botones
local RoboBtn = CreateButton("RoboBtn", "ROBO AUTOMATICO", 60)
local TPBtn = CreateButton("TPBtn", "TP DOWN", 110)
local SaltoBtn = CreateButton("SaltoBtn", "SALTO INFINITO: OFF", 160)
local VelocidadBtn = CreateButton("VelocidadBtn", "VELOCIDAD: OFF", 210)
local VolarBtn = CreateButton("VolarBtn", "VOLAR: OFF", 260)
local ResetBtn = CreateButton("ResetBtn", "RESET", 310) -- Nuevo botón
local CerrarBtn = CreateButton("CerrarBtn", "CERRAR MENU", 360)

-- ==========================================
--  FUNCIONALIDAD DE LA GUI
-- ==========================================

-- 1. Arrastrar la ventana (Título)
local dragging, dragInput, startPos, startPos2

Title.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		startPos = input.Position
		startPos2 = MainFrame.Position
		
		input.Changed:Connect(function()
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				dragInput = input
			end
		end)
	end
end)

Title.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		if dragging then
			local delta = input.Position - startPos
			TweenService:Create(MainFrame, TweenInfo.new(0.1), {
				Position = UDim2.new(startPos2.X.Scale, startPos2.X.Offset + delta.X, startPos2.Y.Scale, startPos2.Y.Offset + delta.Y)
			}):Play()
		end
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

-- 2. Abrir/Cerrar con la tecla "M"
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode.M then
		MainFrame.Visible = not MainFrame.Visible
	end
end)

-- ==========================================
--  ACCIONES DE LOS BOTONES
-- ==========================================

-- Botón Cerrar
CerrarBtn.MouseButton1Click:Connect(function()
	MainFrame.Visible = false
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
		SaltoBtn.Text = "SALTO INFINITO: ON"
		SaltoBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
	else
		Humanoid.JumpPower = 50
		SaltoBtn.Text = "SALTO INFINITO: OFF"
		SaltoBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
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
		VelocidadBtn.Text = "VELOCIDAD: OFF"
		VelocidadBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
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
		VolarBtn.Text = "VOLAR: OFF"
		VolarBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
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
				RoboBtn.Text = "ROBANDO A: " .. player.Name
				task.wait(1)
				RoboBtn.Text = "ROBO AUTOMATICO"
				break
			end
		end
	end
end)