-- Cargamos la librería de UI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-luarmor/main/UI%20Librarys/Roblox%20Exploits/Universal/linoria.lua"))()
local Window = Library:CreateWindow({
    Title = "Script GUI",
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    Size = UDim2.fromOffset(529, 380) -- Tamaño de la ventana principal
})

local Tab = Window:CreateTab("Main")

-- Creamos un contenedor a la derecha para ordenar los botones
local RightContainer = Instance.new("Frame")
RightContainer.Parent = Tab
RightContainer.BackgroundTransparency = 1
RightContainer.Size = UDim2.new(0, 200, 0, 250) -- Zona de botones
RightContainer.Position = UDim2.new(0.85, 0, 0.1, 0) -- Posición a la derecha
RightContainer.Name = "RightContainer"

-- Función para crear los botones con el estilo de la imagen
local function createButton(parent, text, yPos)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.Size = UDim2.new(0, 80, 0, 30) -- Tamaño pequeño
    btn.Position = UDim2.new(0, 0, 0, yPos) -- Posición vertical (unos encima de otros)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35) -- Color oscuro
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = true
    
    -- Aquí es donde conectas la función del botón
    btn.MouseButton1Click:Connect(function()
        -- AQUÍ VA EL CÓDIGO DEL BOTÓN
        print("Botón presionado: " .. text) 
        
        -- Ejemplo de cómo se vería (tendrías que buscar el código real):
        -- if text == "DROP BRAINROT" then
        --     local args = {...}
        --     game:GetService("ReplicatedStorage").Remotes.DropBrainrot:InvokeServer(unpack(args))
        -- end
    end)
    
    return btn
end

-- Lista de botones en el orden EXACTO de la imagen
local buttonList = {
    {"DROP BRAINROT", 0},
    {"AUTO LEFT", 40},
    {"AUTO BAT", 80},
    {"AUTO RIGHT", 120},
    {"TP DOWN", 160},
    {"CARRY SPEED", 200},
    {"LAGGER MODE", 240},
    {"INSTA RESET", 280},
    {"LAGGER CARRY", 320},
    {"BAT TP", 360}
}

-- Generamos los botones en el contenedor
for _, info in ipairs(buttonList) do
    createButton(RightContainer, info[1], info[2])
end

-- Nota: Esta es solo la interfaz. El botón "CARRY SPEED" tiene un color diferente en la imagen (parece blanco/grisáceo). 
-- Si quieres que ese botón tenga otro color, puedes modificar la función createButton para aceptar un color personalizado.