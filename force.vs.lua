--[[
    SCRIPT LOCAL PARA DUELOS PVP - ROBA UN BRAINROT
    - Sistema de combate con habilidades brainrot
    - Detección de enemigos cercanos
    - Efectos visuales y de sonido
    - Sistema de daño con temática de memes
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- CONFIGURACIÓN DE BRAINROT
local BRAINROT_CONFIG = {
    -- Habilidades
    SKILLS = {
        BRAINROT_BLAST = {
            Name = "🧠 Brainrot Blast",
            Cooldown = 3,
            Damage = 20,
            Range = 15,
            Color = Color3.fromRGB(255, 0, 200)
        },
        SIGMA_STRIKE = {
            Name = "⚔️ Sigma Strike",
            Cooldown = 2,
            Damage = 15,
            Range = 8,
            Color = Color3.fromRGB(0, 255, 200)
        },
        RIZZ_FLASH = {
            Name = "🔥 Rizz Flash",
            Cooldown = 5,
            Damage = 30,
            Range = 5,
            Color = Color3.fromRGB(255, 150, 0)
        },
        FANUM_TAX = {
            Name = "💰 Fanum Tax",
            Cooldown = 4,
            Damage = 10,
            Range = 10,
            Color = Color3.fromRGB(0, 255, 0)
        }
    },
    
    -- Frases brainrot
    PHRASES = {
        "SKIBIDI SIGMA! 💀",
        "FANUM TAX! 🤑",
        "WHAT THE SIGMA?! 🤯",
        "RIZZ LEVEL 100! 😎",
        "GYATTT! 🥵",
        "NO CAP! 🧢",
        "BET! 🎰",
        "SUS! 👾",
        "AMOGUS! 🚀",
        "MOEWING! 🐱",
        "SHEEEEEESH! 🔥",
        "L RATIO! 📉",
        "CAPPIN'! 🤥",
        "BASED! 💪",
        "COOKING! 🍳",
        "LET HIM COOK! 👨‍🍳",
        "MAIN CHARACTER! 🌟",
        "NPC BEHAVIOR! 🗿",
        "W RIZZ! 💯",
        "L RIZZ! 😭"
    },
    
    -- Efectos
    EFFECTS = {
        PARTICLE_COUNT = 30,
        EXPLOSION_SIZE = 5,
        FLOATING_TEXT_DURATION = 2
    }
}

-- CREAR GUI DE DUELO
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BrainrotDuelGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- BARRA DE SALUD Y HUD
local hudFrame = Instance.new("Frame")
hudFrame.Size = UDim2.new(0, 300, 0, 80)
hudFrame.Position = UDim2.new(0.5, -150, 0.02, 0)
hudFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
hudFrame.BackgroundTransparency = 0.3
hudFrame.BorderSizePixel = 2
hudFrame.BorderColor3 = Color3.fromRGB(255, 0, 200)
hudFrame.Parent = screenGui

-- TÍTULO DEL JUEGO
local gameTitle = Instance.new("TextLabel")
gameTitle.Size = UDim2.new(1, 0, 0, 25)
gameTitle.Position = UDim2.new(0, 0, 0, 0)
gameTitle.BackgroundTransparency = 1
gameTitle.Text = "⚔️ ROBA UN BRAINROT - DUELO ⚔️"
gameTitle.TextColor3 = Color3.fromRGB(255, 0, 200)
gameTitle.TextScaled = true
gameTitle.Font = Enum.Font.Bangers
gameTitle.Parent = hudFrame

-- BARRA DE SALUD DEL JUGADOR
local healthFrame = Instance.new("Frame")
healthFrame.Size = UDim2.new(0.45, 0, 0, 20)
healthFrame.Position = UDim2.new(0.02, 0, 0.5, 0)
healthFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
healthFrame.BorderSizePixel = 1
healthFrame.Parent = hudFrame

local healthBar = Instance.new("Frame")
healthBar.Size = UDim2.new(1, 0, 1, 0)
healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
healthBar.BorderSizePixel = 0
healthBar.Parent = healthFrame

local healthText = Instance.new("TextLabel")
healthText.Size = UDim2.new(1, 0, 1, 0)
healthText.BackgroundTransparency = 1
healthText.Text = "100/100 HP"
healthText.TextColor3 = Color3.fromRGB(255, 255, 255)
healthText.TextScaled = true
healthText.Font = Enum.Font.GothamBold
healthText.Parent = healthFrame

-- BARRA DE ENERGÍA BRAINROT
local energyFrame = Instance.new("Frame")
energyFrame.Size = UDim2.new(0.45, 0, 0, 10)
energyFrame.Position = UDim2.new(0.02, 0, 0.75, 0)
energyFrame.BackgroundColor3 = Color3.fromRGB(30, 0, 30)
energyFrame.BorderSizePixel = 1
energyFrame.Parent = hudFrame

local energyBar = Instance.new("Frame")
energyBar.Size = UDim2.new(1, 0, 1, 0)
energyBar.BackgroundColor3 = Color3.fromRGB(255, 0, 200)
energyBar.BorderSizePixel = 0
energyBar.Parent = energyFrame

local energyText = Instance.new("TextLabel")
energyText.Size = UDim2.new(1, 0, 1, 0)
energyText.BackgroundTransparency = 1
energyText.Text = "BRAINROT: 100%"
energyText.TextColor3 = Color3.fromRGB(255, 255, 255)
energyText.TextScaled = true
energyText.Font = Enum.Font.GothamBold
energyText.Parent = energyFrame

-- HUD DE HABILIDADES
local skillsFrame = Instance.new("Frame")
skillsFrame.Size = UDim2.new(0, 300, 0, 60)
skillsFrame.Position = UDim2.new(0.5, -150, 0.9, 0)
skillsFrame.BackgroundTransparency = 1
skillsFrame.Parent = screenGui

local skillButtons = {}
local skillCooldowns = {}

-- CREAR BOTONES DE HABILIDADES
local skillNames = {"Brainrot Blast", "Sigma Strike", "Rizz Flash", "Fanum Tax"}
local skillKeys = {"Q", "E", "R", "F"}
local skillColors = {
    Color3.fromRGB(255, 0, 200),
    Color3.fromRGB(0, 255, 200),
    Color3.fromRGB(255, 150, 0),
    Color3.fromRGB(0, 255, 0)
}

for i = 1, 4 do
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.22, 0, 1, 0)
    button.Position = UDim2.new((i-1) * 0.26 + 0.01, 0, 0, 0)
    button.BackgroundColor3 = skillColors[i]
    button.BackgroundTransparency = 0.3
    button.BorderSizePixel = 2
    button.BorderColor3 = Color3.fromRGB(255, 255, 255)
    button.Text = skillNames[i] .. "\n[" .. skillKeys[i] .. "]"
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.Font = Enum.Font.GothamBold
    button.Parent = skillsFrame
    
    skillButtons[skillKeys[i]] = button
    skillCooldowns[skillKeys[i]] = 0
    
    -- Tooltip
    local tooltip = Instance.new("TextLabel")
    tooltip.Size = UDim2.new(1, 0, 0.4, 0)
    tooltip.Position = UDim2.new(0, 0, -0.5, 0)
    tooltip.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    tooltip.BackgroundTransparency = 0.8
    tooltip.Text = "Daño: " .. BRAINROT_CONFIG.SKILLS[skillNames[i]:gsub(" ", "_"):upper()].Damage .. " | Rango: " .. BRAINROT_CONFIG.SKILLS[skillNames[i]:gsub(" ", "_"):upper()].Range .. "m"
    tooltip.TextColor3 = Color3.fromRGB(255, 255, 255)
    tooltip.TextScaled = true
    tooltip.Font = Enum.Font.GothamBold
    tooltip.Visible = false
    tooltip.Parent = button
    
    button.MouseEnter:Connect(function()
        tooltip.Visible = true
    end)
    
    button.MouseLeave:Connect(function()
        tooltip.Visible = false
    end)
end

-- VARIABLES DEL JUGADOR
local playerHealth = 100
local maxHealth = 100
local brainrotEnergy = 100
local maxEnergy = 100
local isDead = false
local enemies = {}
local currentTarget = nil

-- FUNCIÓN PARA OBTENER ENEMIGOS CERCANOS
function getNearbyEnemies(range)
    local nearby = {}
    local players = Players:GetPlayers()
    
    for _, p in pairs(players) do
        if p ~= player then
            local char = p.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
                local distance = (rootPart.Position - char.HumanoidRootPart.Position).Magnitude
                if distance <= range then
                    table.insert(nearby, {
                        Player = p,
                        Character = char,
                        Distance = distance,
                        Humanoid = char.Humanoid,
                        RootPart = char.HumanoidRootPart
                    })
                end
            end
        end
    end
    
    -- Ordenar por distancia
    table.sort(nearby, function(a, b)
        return a.Distance < b.Distance
    end)
    
    return nearby
end

-- FUNCIÓN PARA OBTENER EL ENEMIGO MÁS CERCANO
function getClosestEnemy(range)
    local enemies = getNearbyEnemies(range)
    if #enemies > 0 then
        return enemies[1]
    end
    return nil
end

-- FUNCIÓN PARA CREAR EFECTO DE PARTÍCULAS
function createParticleEffect(position, color, count, size)
    for i = 1, count do
        local particle = Instance.new("Part")
        particle.Size = Vector3.new(size or 0.5, size or 0.5, size or 0.5)
        particle.Position = position + Vector3.new(
            math.random(-5, 5),
            math.random(-5, 5),
            math.random(-5, 5)
        )
        particle.Anchored = true
        particle.CanCollide = false
        particle.Material = Enum.Material.Neon
        particle.BrickColor = BrickColor.new(color)
        particle.Parent = Workspace
        
        local velocity = Vector3.new(
            math.random(-20, 20),
            math.random(-10, 20),
            math.random(-20, 20)
        )
        
        -- Animación de partícula
        local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(particle, tweenInfo, {
            Position = particle.Position + velocity,
            Size = Vector3.new(0, 0, 0)
        })
        tween:Play()
        
        Debris:AddItem(particle, 1.5)
    end
end

-- FUNCIÓN PARA CREAR TEXTO FLOTANTE
function createFloatingText(position, text, color, size)
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.Adornee = Workspace.Terrain
    billboard.Parent = Workspace
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    label.TextScaled = true
    label.Font = Enum.Font.Bangers
    label.Parent = billboard
    
    -- Mover el billboard a la posición
    billboard.Position = position
    
    -- Animación
    local tweenInfo = TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(billboard, tweenInfo, {
        Position = position + Vector3.new(0, 10, 0)
    })
    tween:Play()
    
    Debris:AddItem(billboard, 2)
end

-- FUNCIÓN PARA MOSTRAR TEXTO EN PANTALLA
function showScreenText(text, color, duration)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 500, 0, 80)
    label.Position = UDim2.new(0.5, -250, 0.4, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color or Color3.fromRGB(255, 0, 200)
    label.TextScaled = true
    label.Font = Enum.Font.Bangers
    label.Parent = screenGui
    
    task.wait(duration or 1.5)
    label:Destroy()
end

-- FUNCIÓN PARA EJECUTAR HABILIDAD
function useSkill(skillKey)
    local skillName = nil
    for name, data in pairs(BRAINROT_CONFIG.SKILLS) do
        if data.Key == skillKey then
            skillName = name
            break
        end
    end
    
    if not skillName then return end
    
    local skill = BRAINROT_CONFIG.SKILLS[skillName]
    
    -- Verificar cooldown
    if skillCooldowns[skillKey] > 0 then
        showScreenText("⏳ Habilidad en cooldown!", Color3.fromRGB(255, 0, 0), 0.8)
        return
    end
    
    -- Verificar energía
    if brainrotEnergy < 20 then
        showScreenText("❌ Energía Brainrot insuficiente!", Color3.fromRGB(255, 0, 0), 0.8)
        return
    end
    
    -- Buscar enemigo
    local target = getClosestEnemy(skill.Range)
    if not target then
        showScreenText("🎯 No hay enemigos cerca!", Color3.fromRGB(255, 200, 0), 0.8)
        return
    end
    
    -- Aplicar daño
    brainrotEnergy = math.max(0, brainrotEnergy - 20)
    updateEnergyBar()
    
    local damage = skill.Damage + math.random(0, 5)
    target.Humanoid.Health = math.max(0, target.Humanoid.Health - damage)
    
    -- Efectos visuales
    local targetPos = target.RootPart.Position
    createParticleEffect(targetPos, skill.Color, BRAINROT_CONFIG.EFFECTS.PARTICLE_COUNT, 1)
    createParticleEffect(targetPos, Color3.fromRGB(255, 255, 255), 10, 0.5)
    
    -- Texto flotante
    local phrase = BRAINROT_CONFIG.PHRASES[math.random(1, #BRAINROT_CONFIG.PHRASES)]
    createFloatingText(
        targetPos + Vector3.new(0, 3, 0),
        "-" .. damage .. " " .. phrase,
        skill.Color,
        2
    )
    
    showScreenText(
        "💥 " .. skill.Name .. "! -" .. damage .. " HP!",
        skill.Color,
        1
    )
    
    -- Efecto de sonido (simulado)
    if UserInputService.VibrateDevice then
        UserInputService:VibrateDevice(50)
    end
    
    -- Cooldown
    skillCooldowns[skillKey] = skill.Cooldown
    
    -- Verificar si el enemigo murió
    if target.Humanoid.Health <= 0 then
        showScreenText("💀 " .. target.Player.Name .. " ha sido eliminado! 💀", Color3.fromRGB(255, 0, 0), 2)
        createParticleEffect(targetPos, Color3.fromRGB(255, 0, 0), 50, 2)
        createFloatingText(
            targetPos + Vector3.new(0, 5, 0),
            "💀 L RATIO! 💀",
            Color3.fromRGB(255, 0, 0),
            3
        )
        
        -- Recompensa de energía
        brainrotEnergy = math.min(maxEnergy, brainrotEnergy + 30)
        updateEnergyBar()
    end
end

-- FUNCIÓN PARA ACTUALIZAR BARRA DE SALUD
function updateHealthBar()
    local healthPercent = playerHealth / maxHealth
    healthBar.Size = UDim2.new(healthPercent, 0, 1, 0)
    
    if healthPercent > 0.5 then
        healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    elseif healthPercent > 0.25 then
        healthBar.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
    else
        healthBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    end
    
    healthText.Text = math.floor(playerHealth) .. "/" .. maxHealth .. " HP"
end

-- FUNCIÓN PARA ACTUALIZAR BARRA DE ENERGÍA
function updateEnergyBar()
    local energyPercent = brainrotEnergy / maxEnergy
    energyBar.Size = UDim2.new(energyPercent, 0, 1, 0)
    energyText.Text = "BRAINROT: " .. math.floor(brainrotEnergy) .. "%"
end

-- FUNCIÓN PARA RECIBIR DAÑO
function takeDamage(damage, attacker)
    if isDead then return end
    
    playerHealth = math.max(0, playerHealth - damage)
    updateHealthBar()
    
    if playerHealth <= 0 then
        isDead = true
        showScreenText("💀 HAS SIDO ELIMINADO! 💀", Color3.fromRGB(255, 0, 0), 3)
        showScreenText("L RATIO! 💀", Color3.fromRGB(255, 0, 0), 2)
        humanoid.Health = 0
    end
end

-- FUNCIÓN PARA REGENERAR ENERGÍA
function regenerateEnergy()
    if isDead then return end
    brainrotEnergy = math.min(maxEnergy, brainrotEnergy + 0.5)
    updateEnergyBar()
end

-- FUNCIÓN PARA BUSCAR ENEMIGOS CERCANOS
function scanForEnemies()
    local nearby = getNearbyEnemies(20)
    
    -- Actualizar lista de enemigos
    enemies = nearby
    
    -- Si hay un objetivo actual, verificar si sigue vivo
    if currentTarget then
        local found = false
        for _, enemy in pairs(enemies) do
            if enemy.Player == currentTarget then
                found = true
                break
            end
        end
        if not found then
            currentTarget = nil
        end
    end
    
    -- Si no hay objetivo, seleccionar el más cercano
    if not currentTarget and #enemies > 0 then
        currentTarget = enemies[1].Player
    end
end

-- CONEXIÓN DE HABILIDADES A TECLAS
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.Q then
        useSkill("Q")
    elseif input.KeyCode == Enum.KeyCode.E then
        useSkill("E")
    elseif input.KeyCode == Enum.KeyCode.R then
        useSkill("R")
    elseif input.KeyCode == Enum.KeyCode.F then
        useSkill("F")
    elseif input.KeyCode == Enum.KeyCode.LeftShift then
        -- Dash (esprintar)
        if brainrotEnergy >= 10 then
            brainrotEnergy = math.max(0, brainrotEnergy - 10)
            updateEnergyBar()
            showScreenText("💨 DASH!", Color3.fromRGB(0, 200, 255), 0.5)
            -- Simular dash
            local dashDirection = rootPart.CFrame.LookVector * 20
            rootPart.Position = rootPart.Position + dashDirection
            createParticleEffect(rootPart.Position, Color3.fromRGB(0, 200, 255), 20, 0.5)
        else
            showScreenText("❌ Energía insuficiente!", Color3.fromRGB(255, 0, 0), 0.5)
        end
    end
end)

-- CONEXIÓN DE BOTONES DE HABILIDADES
for key, button in pairs(skillButtons) do
    button.MouseButton1Click:Connect(function()
        useSkill(key)
    end)
end

-- LOOP PRINCIPAL
RunService.Heartbeat:Connect(function()
    -- Actualizar salud desde el humanoid
    if humanoid then
        playerHealth = humanoid.Health
        updateHealthBar()
    end
    
    -- Regenerar energía
    regenerateEnergy()
    
    -- Escanear enemigos
    scanForEnemies()
    
    -- Actualizar cooldowns
    for key, cooldown in pairs(skillCooldowns) do
        if cooldown > 0 then
            skillCooldowns[key] = math.max(0, cooldown - 0.1)
            skillButtons[key].BackgroundTransparency = 0.7
        else
            skillButtons[key].BackgroundTransparency = 0.3
        end
    end
end)

-- ACTUALIZAR SALUD CUANDO EL HUMANÓIDE CAMBIA
humanoid:GetPropertyChangedSignal("Health"):Connect(function()
    playerHealth = humanoid.Health
    updateHealthBar()
end)

-- REVIVIR CUANDO EL JUGADOR RESPAWNEA
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    isDead = false
    playerHealth = maxHealth
    brainrotEnergy = maxEnergy
    updateHealthBar()
    updateEnergyBar()
    showScreenText("🔄 HAS RESPAWNEADO! 🔄", Color3.fromRGB(0, 255, 0), 1)
end)

-- INICIALIZAR
updateHealthBar()
updateEnergyBar()
showScreenText("🎮 BIENVENIDO AL DUELO BRAINROT! 🎮", Color3.fromRGB(255, 0, 200), 2)
showScreenText("Q/E/R/F = HABILIDADES | SHIFT = DASH", Color3.fromRGB(255, 255, 255), 2)

print("🔥 ROBA UN BRAINROT - DUELO PVP CARGADO!")
print("🎮 HABILIDADES: Q, E, R, F")
print("💨 DASH: SHIFT")
print("⚔️ ENCUENTRA ENEMIGOS Y DERROTALOS!")

-- EFECTO DE BIENVENIDA
task.wait(1)
createParticleEffect(rootPart.Position, Color3.fromRGB(255, 0, 200), 30, 1)