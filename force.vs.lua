-- ==========================================
--  SCRIPT: FORCE HUB V5
--  Botones en columna derecha + Panel de configuración
-- ==========================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
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
--  BOTONES EN COLUMNA (ESQUINA DERECHA ARRIBA -> ABAJO)
-- ==========================================

local function CreateButton(name, text, row)
	local button = Instance.new("TextButton")
	button.Name = name
	button.Size = UDim2.new(0, 85, 0, 70)
	
	-- Posición: Pegado a la derecha (1) y muy arriba (Y empieza en 10)
	local xOffset = -105
	local yOffset = 10 + (row * 80) -- Primer botón en Y=10, siguiente en 90, etc.
	
	button.Position = UDim2.new(1, xOffset, 0, yOffset)
	
	button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	button.BorderColor3 = Color3.fromRGB(255, 255, 255)
	button.BorderSizePixel = 2 
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Font = Enum.Font.GothamBold
	button.TextSize = 11
	button.Text = text
	button.TextWrapped = true
	button.AutoButtonColor = true
	button.Parent = ScreenGui
	return button
end

-- Crear botones en columna (Fila 0, 1, 2...)
local DropBtn = CreateButton("DropBtn", "DROP", 0)
local SaltoBtn = CreateButton("SaltoBtn", "SALTO", 1)
local TPBtn = CreateButton("TPBtn", "TP DOWN", 2)
local VolarBtn = CreateButton("VolarBtn", "VOLAR", 3)
local ForceVsBtn = CreateButton("ForceVsBtn", "force.vs", 4) -- Abre el panel
local ResetBtn = CreateButton("ResetBtn", "RESET", 5)
local CerrarBtn = CreateButton("CerrarBtn", "CERRAR", 6)

-- ==========================================
--  PANEL DE CONFIGURACIÓN (SPEED Y CARRY SPEED)
-- ==========================================

local ConfigPanel = Instance.new("Frame")
ConfigPanel.Name = "ConfigPanel"
ConfigPanel.Size = UDim2.new(0, 200, 0, 170)
ConfigPanel.Position = UDim2.new(1, -320, 0, 160) -- Al lado izquierdo de los botones
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

-- Función para crear los apartados de configuración
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
	TextBox.Text = "16"
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

-- Crear fila Speed (Y = 40)
local _, SpeedBox, SpeedPlus, SpeedMinus = CreateConfigRow(40, "Speed")

-- Crear fila Carry Speed (Y = 75)
local _, CarrySpeedBox, CarryPlus, CarryMinus = CreateConfigRow(75, "Carry Speed")

-- Botón para cerrar el panel
local CloseConfigBtn = Instance.new("TextButton")
CloseConfigBtn.Size = UDim2.new(0, 80, 0, 20)
CloseConfigBtn.Position = UDim2.new(0.5, -40, 0, 115)
CloseConfigBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
CloseConfigBtn.Text = "CERRAR"
CloseConfigBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseConfigBtn.Font = Enum.Font.GothamBold
CloseConfigBtn.TextSize = 10
CloseConfigBtn.Parent = ConfigPanel

-- ==========================================
--  FUNCIONALIDAD DE CONFIGURACIÓN
-- ==========================================

-- Función para validar velocidad (1-60)
local function ClampAndSet(textBox)
	local num = tonumber(textBox.Text)
	if num then
		num = math.clamp(num, 1, 60)
		textBox.Text = tostring(num)
		return num
	end
	return 16
end

-- Lógica para Speed
SpeedBox.FocusLost:Connect(function()
	Humanoid.WalkSpeed = ClampAndSet(SpeedBox)
end)

SpeedPlus.MouseButton1Click:Connect(function()
	local current = tonumber(SpeedBox.Text) or 16
	SpeedBox.Text = tostring(math.clamp(current + 1, 1, 60))
	Humanoid.WalkSpeed = tonumber(SpeedBox.Text)
end)

SpeedMinus.MouseButton1Click:Connect(function()
	local current = tonumber(SpeedBox.Text) or 16
	SpeedBox.Text = tostring(math.clamp(current - 1, 1, 60))
	Humanoid.WalkSpeed = tonumber(SpeedBox.Text)
end)

-- Lógica para Carry Speed
CarrySpeedBox.FocusLost:Connect(function()
	ClampAndSet(CarrySpeedBox)
end)

CarryPlus.MouseButton1Click:Connect(function()
	local current = tonumber(CarrySpeedBox.Text) or 16
	CarrySpeedBox.Text = tostring(math.clamp(current + 1, 1, 60))
end)

CarryMinus.MouseButton1Click:Connect(function()
	local current = tonumber(CarrySpeedBox.Text) or 16
	CarrySpeedBox.Text = tostring(math.clamp(current - 1, 1, 60))
end)

-- Cerrar panel de configuración
CloseConfigBtn.MouseButton1Click:Connect(function()
	ConfigPanel.Visible = false
end)

-- Botón "force.vs" abre/cierra el panel
ForceVsBtn.MouseButton1Click:Connect(function()
	ConfigPanel.Visible = not ConfigPanel.Visible
end)

-- ==========================================
--  FUNCIONALIDAD GENERAL
-- ==========================================

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode.M then
		ScreenGui.Enabled = not ScreenGui.Enabled
		ConfigPanel.Visible = false
	end
end)

CerrarBtn.MouseButton1Click:Connect(function()
	ScreenGui.Enabled = false
	ConfigPanel.Visible = false
end)

TPBtn.MouseButton1Click:Connect(function()
	RootPart.CFrame = RootPart.CFrame + Vector3.new(0, -15, 0)
end)

-- Botón DROP: Salta y suelta lo que tenga agarrado
DropBtn.MouseButton1Click:Connect(function()
	Humanoid.Jump = true
	for _, tool in pairs(Character:GetChildren()) do
		if tool:IsA("Tool") then
			tool.Parent = workspace
		end
	end
	RootPart.AssemblyLinearVelocity = Vector3.new(RootPart.AssemblyLinearVelocity.X, 50, RootPart.AssemblyLinearVelocity.Z)
end)

-- Salto
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

-- Volar
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

-- Reset
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