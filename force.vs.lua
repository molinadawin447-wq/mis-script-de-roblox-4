-- ==========================================
--  SCRIPT: FORCE HUB ESTILO FENIX (V8)
--  Panel grande estilo imagen + force.vs arrastrable
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
--  GUI PRINCIPAL
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ForceHubGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- ==========================================
--  1. BOTÓN "FORCE.VS" (ARRANQUE Y ARRASTRABLE)
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

-- Función para arrastrar force.vs
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

-- ==========================================
--  2. PANEL PRINCIPAL ESTILO "FENIX HUB"
-- ==========================================

local MainPanel = Instance.new("Frame")
MainPanel.Name = "MainPanel"
MainPanel.Size = UDim2.new(0, 350, 0, 450)
MainPanel.Position = UDim2.new(0.5, -175, 0.5, -225)
MainPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainPanel.BorderColor3 = Color3.fromRGB(255, 255, 255)
MainPanel.BorderSizePixel = 3
MainPanel.Visible = false -- Aparece al tocar force.vs
MainPanel.Parent = ScreenGui

-- Botón de cerrar (X) en la esquina superior derecha del panel grande
local CloseMainX = Instance.new("TextButton")
CloseMainX.Size = UDim2.new(0, 30, 0, 30)
CloseMainX.Position = UDim2.new(1, -35, 0, 5)
CloseMainX.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
CloseMainX.Text = "X"
CloseMainX.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseMainX.Font = Enum.Font.GothamBold
CloseMainX.TextSize = 15
CloseMainX.Parent = MainPanel

-- Texto Grande "FORCE HUB" 
local BigTitle = Instance.new("TextLabel")
BigTitle.Size = UDim2.new(0, 200, 0, 50)
BigTitle.Position = UDim2.new(0, 15, 0, 15)
BigTitle.BackgroundTransparency = 1
BigTitle.Text = "FORCE HUB"
BigTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
BigTitle.Font = Enum.Font.GothamBlack
BigTitle.TextSize = 25
BigTitle.TextXAlignment = Enum.TextXAlignment.Left
BigTitle.Parent = MainPanel

-- Texto pequeño "FORCE HUB" debajo del grande
local SmallTitle = Instance.new("TextLabel")
SmallTitle.Size = UDim2.new(0, 200, 0, 20)
SmallTitle.Position = UDim2.new(0, 15, 0, 60)
SmallTitle.BackgroundTransparency = 1
SmallTitle.Text = "FORCE HUB"
SmallTitle.TextColor3 = Color3.fromRGB(150, 150, 150)
SmallTitle.Font = Enum.Font.Gotham
SmallTitle.TextSize = 12
SmallTitle.TextXAlignment = Enum.TextXAlignment.Left
SmallTitle.Parent = MainPanel

-- ==========================================
--  3. MENÚ LATERAL (PESTAÑAS)
-- ==========================================

local function CreateTab(name, yPos)
	local tab = Instance.new("TextButton")
	tab.Size = UDim2.new(0, 90, 0, 45)
	tab.Position = UDim2.new(0, 10, 0, yPos)
	tab.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	tab.Text = name
	tab.TextColor3 = Color3.fromRGB(255, 255, 255)
	tab.Font = Enum.Font.GothamBold
	tab.TextSize = 12
	tab.Parent = MainPanel
	return tab
end

local MainTab = CreateTab("MAIN", 90)
local StealTab = CreateTab("STEAL", 145)
local VisualsTab = CreateTab("VISUALS", 200)
local KeysTab = CreateTab("KEYS", 255)
local SettingsTab = CreateTab("SETTINGS", 310)

-- ==========================================
--  4. CONTENEDOR DE BOTONES (LADO DERECHO)
-- ==========================================

local function CreateToggleRow(name, yPos)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(0, 220, 0, 45)
	row.Position = UDim2.new(0, 110, 0, yPos)
	row.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	row.BorderSizePixel = 0
	row.Parent = MainPanel

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -60, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = name
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.Font = Enum.Font.GothamBold
	label.TextSize = 12
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = row

	local toggle = Instance.new("TextButton")
	toggle.Size = UDim2.new(0, 45, 0, 25)
	toggle.Position = UDim2.new(1, -50, 0.5, -12.5)
	toggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80) -- Gris oscuro (apagado)
	toggle.Text = ""
	toggle.Parent = row

	return row, label, toggle
end

-- Crear filas de ejemplo (estilo imagen)
local _, DropLabel, DropToggle = CreateToggleRow("DROP", 90)
local _, SaltoLabel, SaltoToggle = CreateToggleRow("SALTO INFINITO", 145)
local _, TPLabel, TPToggle = CreateToggleRow("TP DOWN", 200)
local _, CarryLabel, CarryToggle = CreateToggleRow("CARRY SPEED", 255)
local _, VolarLabel, VolarToggle = CreateToggleRow("VOLAR", 310)

-- ==========================================
--  5. PANEL DE CONFIGURACIÓN PEQUEÑO
-- ==========================================

local ConfigPanel = Instance.new("Frame")
ConfigPanel.Name = "ConfigPanel"
ConfigPanel.Size = UDim2.new(0, 200, 0, 230)
ConfigPanel.Position = UDim2.new(0.5, 100, 0, -50) -- Aparece al lado del panel grande
ConfigPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ConfigPanel.BorderColor3 = Color3.fromRGB(255, 255, 255)
ConfigPanel.BorderSizePixel = 2
ConfigPanel.Visible = false
ConfigPanel.Parent = MainPanel -- Se mueve junto al panel grande

-- Botón de cerrar (X) del panel de configuración
local CloseConfigX = Instance.new("TextButton")
CloseConfigX.Size = UDim2.new(0, 25, 0, 25)
CloseConfigX.Position = UDim2.new(1, -30, 0, 5)
CloseConfigX.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
CloseConfigX.Text = "X"
CloseConfigX.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseConfigX.Font = Enum.Font.GothamBold
CloseConfigX.TextSize = 12
CloseConfigX.Parent = ConfigPanel

local ConfigTitle = Instance.new("TextLabel")
ConfigTitle.Size = UDim2.new(1, 0, 0, 30)
ConfigTitle.Position = UDim2.new(0, 0, 0, 5)
ConfigTitle.BackgroundTransparency = 1
ConfigTitle.Text = "CONFIGURACIÓN"
ConfigTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
ConfigTitle.Font = Enum.Font.GothamBold
ConfigTitle.TextSize = 12
ConfigTitle.Parent = ConfigPanel

local function CreateConfigRow(yPos, labelText)
	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(0, 80, 0, 25)
	Label.Position = UDim2.new(0, 10, 0, yPos)
	Label.BackgroundTransparency = 1
	Label.Text = labelText
	Label.TextColor3 = Color3.fromRGB(255, 255, 255)
	Label.Font = Enum.Font.Gotham
	Label.TextSize = 12
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

-- Crear filas de configuración
local _, SpeedBox, SpeedPlus, SpeedMinus = CreateConfigRow(40, "Speed")
local _, CarrySpeedBox, CarryPlus, CarryMinus = CreateConfigRow(80, "Carry Speed")

-- ==========================================
--  6. FUNCIONALIDAD DE APERTURA Y CIERRE
-- ==========================================

-- Al tocar force.vs (si no está arrastrando), abre/cierra el panel grande
ForceVsBtn.MouseButton1Click:Connect(function()
	if not dragging then
		MainPanel.Visible = not MainPanel.Visible
		if not MainPanel.Visible then ConfigPanel.Visible = false end
	end
end)

-- Cerrar panel grande con la X
CloseMainX.MouseButton1Click:Connect(function()
	MainPanel.Visible = false
	ConfigPanel.Visible = false
end)

-- Cerrar panel de configuración con su X
CloseConfigX.MouseButton1Click:Connect(function()
	ConfigPanel.Visible = false
end)

-- Abrir/cerrar panel de configuración (con la pestaña SETTINGS o cualquier botón que quieras)
SettingsTab.MouseButton1Click:Connect(function()
	ConfigPanel.Visible = not ConfigPanel.Visible
end)

-- ==========================================
--  7. FUNCIONALIDAD DE LOS TOGGLES Y BOTONES
-- ==========================================

-- Funciones de Toggle (Encender/Apagar los botones del panel estilo imagen)
local function ToggleSwitch(toggle, callback)
	toggle.MouseButton1Click:Connect(function()
		if toggle.BackgroundColor3 == Color3.fromRGB(80, 80, 80) then
			toggle.BackgroundColor3 = Color3.fromRGB(0, 170, 0) -- Verde (encendido)
			callback(true)
		else
			toggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80) -- Gris (apagado)
			callback(false)
		end
	end)
end

-- Drop
ToggleSwitch(DropToggle, function(state)
	if state then
		Humanoid.Jump = true
		for _, tool in pairs(Character:GetChildren()) do
			if tool:IsA("Tool") then tool.Parent = workspace end
		end
		RootPart.AssemblyLinearVelocity = Vector3.new(RootPart.AssemblyLinearVelocity.X, 50, RootPart.AssemblyLinearVelocity.Z)
	end
end)

-- Salto infinito
local saltoActivo = false
ToggleSwitch(SaltoToggle, function(state)
	saltoActivo = state
	if state then
		Humanoid.JumpPower = 250
		Humanoid.UseJumpPower = true
	else
		Humanoid.JumpPower = 50
	end
end)

-- TP Down
ToggleSwitch(TPToggle, function(state)
	if state then
		RootPart.CFrame = RootPart.CFrame + Vector3.new(0, -15, 0)
	end
end)

-- Carry Speed (Usa el valor de la caja)
ToggleSwitch(CarryToggle, function(state)
	if state then
		Humanoid.WalkSpeed = tonumber(CarrySpeedBox.Text) or 30
	else
		Humanoid.WalkSpeed = 16
	end
end)

-- Volar
local volando = false
local volarLoop
ToggleSwitch(VolarToggle, function(state)
	volando = state
	if state then
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
		Humanoid.PlatformStand = false
		RootPart.Velocity = Vector3.new(0, 0, 0)
		if volarLoop then volarLoop:Disconnect() end
	end
end)

-- ==========================================
--  CONFIGURACIÓN DE VELOCIDAD (Cajas de texto)
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

SpeedBox.FocusLost:Connect(function()
	Humanoid.WalkSpeed = ClampAndSet(SpeedBox)
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

-- Tecla M para abrir/cerrar todo
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode.M then
		MainPanel.Visible = not MainPanel.Visible
		if not MainPanel.Visible then ConfigPanel.Visible = false end
	end
end)