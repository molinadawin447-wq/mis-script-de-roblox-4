-- ==========================================
--  SCRIPT: FORCE HUB V7
--  force.vs arrastrable + Configuración Speed/Combat + Botón Carry Speed
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
--  CREACIÓN DE LA GUI
-- ==========================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ForceHubGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- ==========================================
--  BOTONES EN COLUMNA DERECHA
-- ==========================================

local function CreateButton(name, text, row)
	local button = Instance.new("TextButton")
	button.Name = name
	button.Size = UDim2.new(0, 100, 0, 70)
	
	local xOffset = -120
	local yOffset = 10 + (row * 80)
	
	button.Position = UDim2.new(1, xOffset, 0, yOffset)
	button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	button.BorderColor3 = Color3.fromRGB(255, 255, 255)
	button.BorderSizePixel = 2
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Font = Enum.Font.GothamBold
	button.TextSize = 13
	button.Text = text
	button.TextWrapped = true
	button.AutoButtonColor = true
	button.Parent = ScreenGui
	return button
end

-- Columna derecha
local DropBtn = CreateButton("DropBtn", "DROP", 0)
local SaltoBtn = CreateButton("SaltoBtn", "SALTO", 1)
local TPBtn = CreateButton("TPBtn", "TP DOWN", 2)
local VolarBtn = CreateButton("VolarBtn", "VOLAR", 3)
local CarrySpeedBtn = CreateButton("CarrySpeedBtn", "CARRY SPEED", 4) -- Nuevo botón exterior
local ResetBtn = CreateButton("ResetBtn", "RESET", 5)
local CerrarBtn = CreateButton("CerrarBtn", "CERRAR", 6)

-- ==========================================
--  BOTÓN "FORCE.VS" (ARRASTRABLE)
-- ==========================================

local ForceVsBtn = Instance.new("TextButton")
ForceVsBtn.Name = "ForceVsBtn"
ForceVsBtn.Size = UDim2.new(0, 110, 0, 45)
ForceVsBtn.Position = UDim2.new(0, 15, 0, 65)
ForceVsBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ForceVsBtn.BorderColor3 = Color3.fromRGB(255, 255, 255)
ForceVsBtn.BorderSizePixel = 2
ForceVsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ForceVsBtn.Font = Enum.Font.GothamBold
ForceVsBtn.TextSize = 16
ForceVsBtn.Text = "force.vs"
ForceVsBtn.Parent = ScreenGui

-- Función para arrastrar
local dragging, dragInput, startPos, startPos2
ForceVsBtn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		startPos = input.Position
		startPos2 = ForceVsBtn.Position
		input.Changed:Connect(function()
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				dragInput = input
			end
		end)
	end
end)

ForceVsBtn.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		if dragging then
			local delta = input.Position - startPos
			TweenService:Create(ForceVsBtn, TweenInfo.new(0.05), {
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

-- Al hacer clic (si no está arrastrando) abre el panel
ForceVsBtn.MouseButton1Click:Connect(function()
	if not dragging then
		ConfigPanel.Visible = not ConfigPanel.Visible
	end
end)

-- ==========================================
--  PANEL DE CONFIGURACIÓN (SPEED Y COMBAT)
-- ==========================================

-- Panel principal
local ConfigPanel = Instance.new("Frame")
ConfigPanel.Name = "ConfigPanel"
ConfigPanel.Size = UDim2.new(0, 220, 0, 230)
ConfigPanel.Position = UDim2.new(0, 160, 0, 100)
ConfigPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ConfigPanel.BorderColor3 = Color3.fromRGB(255, 255, 255)
ConfigPanel.BorderSizePixel = 2
ConfigPanel.Visible = false
ConfigPanel.Parent = ScreenGui

local ConfigTitle = Instance.new("TextLabel")
ConfigTitle.Size = UDim2.new(1, 0, 0, 30)
ConfigTitle.BackgroundTransparency = 1
ConfigTitle.Text = "CONFIGURACIÓN"
ConfigTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
ConfigTitle.Font = Enum.Font.GothamBold
ConfigTitle.TextSize = 14
ConfigTitle.Parent = ConfigPanel

-- Función genérica para crear apartados con cajas y botones +/-
local function CreateConfigRow(yPos, labelText)
	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(0, 80, 0, 25)
	Label.Position = UDim2.new(0, 10, 0, yPos)
	Label.BackgroundTransparency = 1
	Label.Text = labelText
	Label.TextColor3 = Color3.fromRGB(255, 255, 255)
	Label.Font = Enum.Font.Gotham
	Label.TextSize = 13
	Label.Parent = ConfigPanel

	local TextBox = Instance.new("TextBox")
	TextBox.Size = UDim2.new(0, 45, 0, 25)
	TextBox.Position = UDim2.new(0, 100, 0, yPos)
	TextBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextBox.Font = Enum.Font.GothamBold
	TextBox.TextSize = 14
	TextBox.Text = "30"
	TextBox.Parent = ConfigPanel

	local PlusBtn = Instance.new("TextButton")
	PlusBtn.Size = UDim2.new(0, 20, 0, 25)
	PlusBtn.Position = UDim2.new(0, 150, 0, yPos)
	PlusBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
	PlusBtn.Text = "+"
	PlusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	PlusBtn.Font = Enum.Font.GothamBold
	PlusBtn.Parent = ConfigPanel

	local MinusBtn = Instance.new("TextButton")
	MinusBtn.Size = UDim2.new(0, 20, 0, 25)
	MinusBtn.Position = UDim2.new(0, 175, 0, yPos)
	MinusBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
	MinusBtn.Text = "-"
	MinusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	MinusBtn.Font = Enum.Font.GothamBold
	MinusBtn.Parent = ConfigPanel

	return Label, TextBox, PlusBtn, MinusBtn
end

-- Apartado SPEED (Y = 40) y CARRY SPEED (Y = 75)
local _, SpeedBox, SpeedPlus, SpeedMinus = CreateConfigRow(40, "Speed")
local _, CarrySpeedBox, CarryPlus, CarryMinus = CreateConfigRow(75, "Carry Speed")

-- ==========================================
--  APARTADO "COMBAT" Y SUB-APARTADOS
-- ==========================================

-- Título del apartado Combat
local CombatLabel = Instance.new("TextLabel")
CombatLabel.Size = UDim2.new(1, 0, 0, 20)
CombatLabel.Position = UDim2.new(0, 0, 0, 110)
CombatLabel.BackgroundTransparency = 1
CombatLabel.Text = "COMBAT"
CombatLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
CombatLabel.Font = Enum.Font.GothamBold
CombatLabel.TextSize = 14
CombatLabel.Parent = ConfigPanel

-- Sub-apartados dentro de Combat
local _, CombatSpeedBox, CombatSpeedPlus, CombatSpeedMinus = CreateConfigRow(135, "Speed")
local _, CombatCarryBox, CombatCarryPlus, CombatCarryMinus = CreateConfigRow(170, "Carry Speed")

-- Botón para cerrar el panel
local CloseConfigBtn = Instance.new("TextButton")
CloseConfigBtn.Size = UDim2.new(0, 80, 0, 20)
CloseConfigBtn.Position = UDim2.new(0.5, -40, 0, 205)
CloseConfigBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
CloseConfigBtn.Text = "CERRAR"
CloseConfigBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseConfigBtn.Font = Enum.Font.GothamBold
CloseConfigBtn.TextSize = 10
CloseConfigBtn.Parent = ConfigPanel

-- ==========================================
--  FUNCIONALIDAD DE CONFIGURACIÓN
-- ==========================================

local function ClampAndSet(textBox)
	local num = tonumber(textBox.Text)
	if num then
		num = math.clamp(num, 1, 60)
		textBox.Text = tostring(num)
		return num
	end
	return 30
end

-- Speed principal (30 = normal)
SpeedBox.FocusLost:Connect(function()
	local val = ClampAndSet(SpeedBox)
	-- Ajusta la velocidad directamente
	Humanoid.WalkSpeed = val
end)

SpeedPlus.MouseButton1Click:Connect(function()
	local current = tonumber(SpeedBox.Text) or 30
	SpeedBox.Text = tostring(math.clamp(current + 1, 1, 60))
	Humanoid.WalkSpeed = tonumber(SpeedBox.Text)
end)

SpeedMinus.MouseButton1Click:Connect(function()
	local current = tonumber(SpeedBox.Text) or 30
	SpeedBox.Text = tostring(math.clamp(current - 1, 1, 60))
	Humanoid.WalkSpeed = tonumber(SpeedBox.Text)
end)

-- Carry Speed principal
CarrySpeedBox.FocusLost:Connect(function()
	ClampAndSet(CarrySpeedBox)
end)

CarryPlus.MouseButton1Click:Connect(function()
	local current = tonumber(CarrySpeedBox.Text) or 30
	CarrySpeedBox.Text = tostring(math.clamp(current + 1, 1, 60))
end)

CarryMinus.MouseButton1Click:Connect(function()
	local current = tonumber(CarrySpeedBox.Text) or 30
	CarrySpeedBox.Text = tostring(math.clamp(current - 1, 1, 60))
end)

-- Combat Speed (sub-apartado)
CombatSpeedBox.FocusLost:Connect(function()
	ClampAndSet(CombatSpeedBox)
end)

CombatSpeedPlus.MouseButton1Click:Connect(function()
	local current = tonumber(CombatSpeedBox.Text) or 30
	CombatSpeedBox.Text = tostring(math.clamp(current + 1, 1, 60))
end)

CombatSpeedMinus.MouseButton1Click:Connect(function()
	local current = tonumber(CombatSpeedBox.Text) or 30
	CombatSpeedBox.Text = tostring(math.clamp(current - 1, 1, 60))
end)

-- Combat Carry Speed (sub-apartado)
CombatCarryBox.FocusLost:Connect(function()
	ClampAndSet(CombatCarryBox)
end)

CombatCarryPlus.MouseButton1Click:Connect(function()
	local current = tonumber(CombatCarryBox.Text) or 30
	CombatCarryBox.Text = tostring(math.clamp(current + 1, 1, 60))
end)

CombatCarryMinus.MouseButton1Click:Connect(function()
	local current = tonumber(CombatCarryBox.Text) or 30
	CombatCarryBox.Text = tostring(math.clamp(current - 1, 1, 60))
end)

-- Botón CERRAR del panel
CloseConfigBtn.MouseButton1Click:Connect(function()
	ConfigPanel.Visible = false
end)

-- ==========================================
--  ACCIONES DE LOS BOTONES EXTERNOS
-- ==========================================

-- Botón CARRY SPEED: Usa el valor del apartado "Carry Speed" principal
CarrySpeedBtn.MouseButton1Click:Connect(function()
	local carrySpeed = tonumber(CarrySpeedBox.Text) or 30
	Humanoid.WalkSpeed = carrySpeed
	CarrySpeedBtn.Text = "CARRY SPEED: ON"
	CarrySpeedBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
	
	task.wait(2) -- Se mantiene activo 2 segundos o hasta que se vuelva a pulsar
	CarrySpeedBtn.Text = "CARRY SPEED"
	CarrySpeedBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
end)

-- Otros botones
CerrarBtn.MouseButton1Click:Connect(function()
	ScreenGui.Enabled = false
	ConfigPanel.Visible = false
end)

TPBtn.MouseButton1Click:Connect(function()
	RootPart.CFrame = RootPart.CFrame + Vector3.new(0, -15, 0)
end)

DropBtn.MouseButton1Click:Connect(function()
	Humanoid.Jump = true
	for _, tool in pairs(Character:GetChildren()) do
		if tool:IsA("Tool") then
			tool.Parent = workspace
		end
	end
	RootPart.AssemblyLinearVelocity = Vector3.new(RootPart.AssemblyLinearVelocity.X, 50, RootPart.AssemblyLinearVelocity.Z)
end)

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

ResetBtn.MouseButton1Click:Connect(function()
	if volando then
		Humanoid.PlatformStand = false
		RootPart.Velocity = Vector3.new(0, 0, 0)
		if volarLoop then volarLoop:Disconnect() end
		volando = false
	end
	if saltoActivo then
		Humanoid.JumpPower = 50
		saltoActivo = false
	end
	Humanoid.Health = 0
end)

-- Variables para toggles
local saltoActivo = false
local volando = false
local volarLoop

-- Tecla para abrir/cerrar todo
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode.M then
		ScreenGui.Enabled = not ScreenGui.Enabled
		ConfigPanel.Visible = false
	end
end)