local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local HS = game:GetService("HttpService")
local player = Players.LocalPlayer
while not player do task.wait(0.1) player = Players.LocalPlayer end

if not math.clamp then
    math.clamp = function(n, low, high)
        return math.min(math.max(n, low), high)
    end
end

if not tick then
    tick = os.clock or os.time or function() return 0 end
end

local function getSafeGuiParent()
    local parent = nil
    pcall(function()
        if gethui then
            parent = gethui()
        elseif syn and syn.protect_gui then
            local test = Instance.new("ScreenGui")
            syn.protect_gui(test)
            parent = game:GetService("CoreGui")
        elseif game:GetService("CoreGui") then
            parent = game:GetService("CoreGui")
        end
    end)
    if not parent then
        pcall(function()
            local p = game:GetService("Players").LocalPlayer
            parent = p and p:FindFirstChildOfClass("PlayerGui")
        end)
    end
    return parent
end




while not player do task.wait(0.1) player = Players.LocalPlayer end

if not math.clamp then
    math.clamp = function(n, low, high)
        return math.min(math.max(n, low), high)
    end
end

if not tick then
    tick = os.clock or os.time or function() return 0 end
end

local function getSafeGuiParent()
    local parent = nil
    pcall(function()
        if gethui then
            parent = gethui()
        elseif syn and syn.protect_gui then
            local test = Instance.new("ScreenGui")
            syn.protect_gui(test)
            parent = game:GetService("CoreGui")
        elseif game:GetService("CoreGui") then
            parent = game:GetService("CoreGui")
        end
    end)
    if not parent then
        pcall(function()
            local p = game:GetService("Players").LocalPlayer
            parent = p and p:FindFirstChildOfClass("PlayerGui")
        end)
    end
    return parent
end





-- Master table
local M = {}
M._persistentConns = M._persistentConns or {}
function M.trackConn(conn)
    table.insert(M._persistentConns, conn)
    return conn
end
function M.clearPersistentConns()
    for _, c in ipairs(M._persistentConns or {}) do
        pcall(function() c:Disconnect() end)
    end
    M._persistentConns = {}
end




-- ------------------------------------------------------------
-- EARLY CONFIG LOAD
-- ------------------------------------------------------------
M.introSoundEnabled = true
M.introSongChoice = 3
M.introGUIEnabled = true
if isfile and isfile("RykeConfig.json") then
    local ok, data = pcall(function() return HS:JSONDecode(readfile("RykeConfig.json")) end)
    if ok and type(data) == "table" then
        if data.introSoundEnabled ~= nil then M.introSoundEnabled = data.introSoundEnabled end
        if data.introSongChoice then M.introSongChoice = data.introSongChoice end
        if data.introGUIEnabled ~= nil then M.introGUIEnabled = data.introGUIEnabled end
        if type(data.Theme) == "string" then M._savedTheme = data.Theme end
        if type(data.colorScheme) == "string" then M._savedTheme = data.colorScheme end
    end
end

-- ============================================================
-- SKY THEME (unchanged)
-- ============================================================
M.CANDY_SKY_TAG = "RykeSkyTheme"
M.currentSkyTheme = "Night"
M.CANDY_SKY_PRESETS = {
    ["Off"]={kind="off"},
    ["Night"]={clock=22,brightness=2,ambient={110,100,130},outAmb={120,110,140},sky={stars=4000,moon=18,sun=0,moonTex=true},atm={dens=0.45,color={120,60,180},decay={60,20,100},glare=0.5,haze=1.2}},
    ["Aurora"]={clock=14,brightness=3,ambient={150,120,150},outAmb={160,130,150},atm={dens=0.55,color={255,80,200},decay={255,20,150},glare=2.5,haze=3},clouds={cover=0.7,dens=0.7,color={255,240,250}}},
    ["Sunset"]={clock=17.2,brightness=2.5,ambient={170,120,100},outAmb={180,130,110},sky={stars=0,sun=25,moon=0},atm={dens=0.5,color={255,130,60},decay={255,80,30},glare=2,haze=2.5},clouds={cover=0.55,dens=0.55,color={255,200,140}}},
    ["Galaxy"]={clock=0,brightness=1.5,ambient={70,60,100},outAmb={80,70,110},sky={stars=10000,moon=30,sun=0},atm={dens=0.15,color={40,20,80},decay={20,10,50},glare=0.3,haze=0.5}},
    ["Cyber"]={clock=21,brightness=2.2,ambient={90,130,170},outAmb={100,140,180},sky={stars=2000,moon=12},atm={dens=0.4,color={0,200,255},decay={150,0,255},glare=2,haze=2},clouds={cover=0.4,dens=0.6,color={100,200,255}}},
    ["Sakura"]={clock=11,brightness=3.5,ambient={170,150,160},outAmb={180,160,170},sky={sun=8},atm={dens=0.3,color={255,200,220},decay={255,170,200},glare=1,haze=1.5},clouds={cover=0.6,dens=0.4,color={255,250,252}}},
    ["Pink Night"]={clock=23,brightness=2.2,ambient={120,60,110},outAmb={140,70,120},sky={stars=5000,moon=22,sun=0,moonTex=true},atm={dens=0.5,color={255,80,180},decay={140,30,100},glare=0.7,haze=1.4},clouds={cover=0.3,dens=0.5,color={180,90,150}}},
    ["Blood Moon"]={clock=22.5,brightness=1.6,ambient={130,40,40},outAmb={150,50,50},sky={stars=1500,moon=28,sun=0,moonTex=true},atm={dens=0.6,color={220,30,30},decay={120,10,10},glare=1.4,haze=2},clouds={cover=0.5,dens=0.7,color={120,30,30}}},
    ["Emerald Dawn"]={clock=6.5,brightness=2.8,ambient={130,170,140},outAmb={140,180,150},sky={sun=18,moon=0,stars=0},atm={dens=0.4,color={80,200,140},decay={40,150,90},glare=1.8,haze=2.2},clouds={cover=0.5,dens=0.5,color={200,255,220}}},
    ["Volcanic"]={clock=19,brightness=2,ambient={180,80,40},outAmb={200,90,50},sky={stars=200,sun=12,moon=0},atm={dens=0.75,color={255,60,0},decay={180,20,0},glare=3,haze=3.5},clouds={cover=0.8,dens=0.9,color={120,40,20}}},
    ["Arctic"]={clock=9,brightness=3.2,ambient={200,220,235},outAmb={210,230,245},sky={sun=10,stars=0,moon=0},atm={dens=0.3,color={180,220,255},decay={140,200,240},glare=1.5,haze=1.8},clouds={cover=0.7,dens=0.6,color={250,253,255}}},
    ["Midnight Ocean"]={clock=1.5,brightness=1.7,ambient={60,90,130},outAmb={70,100,140},sky={stars=6000,moon=24,sun=0,moonTex=true},atm={dens=0.5,color={20,60,140},decay={10,30,90},glare=0.6,haze=1.5}},
    ["Vaporwave"]={clock=19.5,brightness=2.4,ambient={180,120,200},outAmb={190,130,210},sky={stars=1000,moon=14},atm={dens=0.45,color={255,100,220},decay={120,60,255},glare=2.2,haze=2.4},clouds={cover=0.55,dens=0.55,color={200,150,255}}},
    ["Toxic"]={clock=13,brightness=2.5,ambient={140,180,80},outAmb={150,190,90},atm={dens=0.55,color={100,220,40},decay={60,150,20},glare=1.8,haze=2.6},clouds={cover=0.65,dens=0.7,color={180,255,120}}},
    ["Solar Eclipse"]={clock=12,brightness=0.9,ambient={50,40,60},outAmb={60,50,70},sky={stars=3500,sun=22,moon=0},atm={dens=0.5,color={255,140,40},decay={30,20,40},glare=2.8,haze=1.8}},
    ["Hellscape"]={clock=18,brightness=1.8,ambient={200,60,30},outAmb={220,70,40},sky={stars=100,sun=30,moon=0},atm={dens=0.85,color={255,30,0},decay={120,0,0},glare=3.5,haze=4},clouds={cover=0.95,dens=0.95,color={80,20,10}}},
    ["Heaven"]={clock=12,brightness=4,ambient={240,235,210},outAmb={250,245,220},sky={sun=16,moon=0,stars=0},atm={dens=0.25,color={255,250,220},decay={255,240,200},glare=3,haze=1.5},clouds={cover=0.85,dens=0.5,color={255,255,255}}},
    ["Storm"]={clock=15,brightness=1.4,ambient={90,90,110},outAmb={100,100,120},sky={stars=0,sun=6,moon=0},atm={dens=0.65,color={80,90,120},decay={40,50,80},glare=0.5,haze=3},clouds={cover=0.95,dens=0.95,color={60,65,80}}},
    ["Sunrise"]={clock=6.2,brightness=2.8,ambient={220,180,130},outAmb={230,190,140},sky={sun=22,stars=0,moon=0},atm={dens=0.45,color={255,180,100},decay={255,140,80},glare=2.4,haze=2.2},clouds={cover=0.4,dens=0.4,color={255,220,180}}},
    ["Deep Space"]={clock=0,brightness=1,ambient={30,25,50},outAmb={40,35,60},sky={stars=15000,moon=0,sun=0},atm={dens=0.08,color={15,5,40},decay={5,0,20},glare=0.2,haze=0.3}},
    ["Lavender Dream"]={clock=18.5,brightness=2.6,ambient={180,160,220},outAmb={190,170,230},sky={stars=800,moon=16,sun=0},atm={dens=0.4,color={200,160,255},decay={160,120,220},glare=1.4,haze=1.8},clouds={cover=0.55,dens=0.5,color={220,200,255}}},
    ["Inferno"]={clock=17.5,brightness=2.2,ambient={220,100,40},outAmb={235,110,50},sky={sun=26,moon=0,stars=0},atm={dens=0.6,color={255,90,20},decay={200,40,0},glare=3,haze=3.2},clouds={cover=0.7,dens=0.7,color={200,80,40}}},
    ["Mint Sky"]={clock=10,brightness=3.2,ambient={180,230,210},outAmb={190,240,220},sky={sun=10},atm={dens=0.32,color={150,255,210},decay={100,220,180},glare=1.6,haze=1.6},clouds={cover=0.55,dens=0.45,color={240,255,250}}},
}
M.SkyOrder = {"Off","Night","Aurora","Sunset","Galaxy","Cyber","Sakura","Pink Night","Blood Moon","Emerald Dawn","Volcanic","Arctic","Midnight Ocean","Vaporwave","Toxic","Solar Eclipse","Hellscape","Heaven","Storm","Sunrise","Deep Space","Lavender Dream","Inferno","Mint Sky"}

local function candyColor(rgb) return Color3.fromRGB(rgb[1],rgb[2],rgb[3]) end
function M.CandyApplyCustomSky(mode)
    for _,child in ipairs(Lighting:GetChildren()) do if child:GetAttribute(M.CANDY_SKY_TAG) then pcall(function() child:Destroy() end) end end
    local terrain=workspace:FindFirstChildOfClass("Terrain")
    if terrain then for _,child in ipairs(terrain:GetChildren()) do if child:GetAttribute(M.CANDY_SKY_TAG) then pcall(function() child:Destroy() end) end end end
    local preset=M.CANDY_SKY_PRESETS[mode]
    if not preset or preset.kind=="off" then Lighting.ClockTime=14;Lighting.Brightness=2;Lighting.OutdoorAmbient=Color3.fromRGB(127,127,127);Lighting.Ambient=Color3.fromRGB(127,127,127);Lighting.FogEnd=100000;Lighting.GlobalShadows=true;return end
    Lighting.FogStart=0;Lighting.FogEnd=100000;Lighting.FogColor=Color3.fromRGB(200,200,200);Lighting.ColorShift_Top=Color3.fromRGB(0,0,0);Lighting.ColorShift_Bottom=Color3.fromRGB(0,0,0);Lighting.GlobalShadows=true
    Lighting.ClockTime=preset.clock or 14;Lighting.Brightness=preset.brightness or 2
    if preset.outAmb then Lighting.OutdoorAmbient=candyColor(preset.outAmb) end
    if preset.ambient then Lighting.Ambient=candyColor(preset.ambient) end
    if preset.sky then
        local skyInst=Instance.new("Sky");skyInst:SetAttribute(M.CANDY_SKY_TAG,true)
        if preset.sky.stars then skyInst.StarCount=preset.sky.stars end
        if preset.sky.moon then skyInst.MoonAngularSize=preset.sky.moon end
        if preset.sky.sun then skyInst.SunAngularSize=preset.sky.sun end
        if preset.sky.moonTex then skyInst.MoonTextureId="rbxasset://sky/moon.jpg" end
        skyInst.Parent=Lighting
    end
    if preset.atm then
        local atm=Instance.new("Atmosphere");atm:SetAttribute(M.CANDY_SKY_TAG,true)
        atm.Density=preset.atm.dens or 0.3;atm.Color=candyColor(preset.atm.color);atm.Decay=candyColor(preset.atm.decay);atm.Glare=preset.atm.glare or 1;atm.Haze=preset.atm.haze or 1;atm.Parent=Lighting
    end
    if preset.clouds and terrain then
        local clouds=Instance.new("Clouds");clouds:SetAttribute(M.CANDY_SKY_TAG,true)
        clouds.Cover=preset.clouds.cover or 0.5;clouds.Density=preset.clouds.dens or 0.5;clouds.Color=candyColor(preset.clouds.color);clouds.Parent=terrain
    end
end

-- ============================================================
-- ANIMATION PACKS (unchanged)
-- ============================================================
M.PACKS = {
    ["Adidas Sports"] = {
        WalkAnim = 18537392113,
        RunAnim  = 18537384940,
        JumpAnim = 18537380791,
        FallAnim = 18537367238,
        SwimIdle = 18537387180,
        Swim     = 18537389531,
        Animation1 = 18537376492,
        Animation2 = 18537371272,
        ClimbAnim = 18537363391,
    },
    ["Adidas Community"] = {
        WalkAnim = 122150855457006,
        RunAnim  = 82598234841035,
        JumpAnim = 75290611992385,
        FallAnim = 98600215928904,
        SwimIdle = 109346520324160,
        Swim     = 133308483266208,
        Animation1 = 122257458498464,
        Animation2 = 102357151005774,
        ClimbAnim = 88763136693023,
    },
    ["Adidas Aura"] = {
        WalkAnim = 83842218823011,
        RunAnim  = 118320322718866,
        JumpAnim = 109996626521204,
        FallAnim = 95603166884636,
        SwimIdle = 94922130551805,
        Swim     = 134530128383903,
        Animation1 = 110211186840347,
        Animation2 = 114191137265065,
        ClimbAnim = 97824616490448,
    },
    ["Wicked Popular"] = {
        WalkAnim = 92072849924640,
        RunAnim = 72301599441680,
        JumpAnim = 104325245285198,
        FallAnim = 121152442762481,
        Animation1 = 118832222982049,
        ClimbAnim = 131326830509784,
        SwimIdle = 113199415118199,
        Swim = 99384245425157,
        Animation2 = 76049494037641,
    },
    Elder = {
        WalkAnim = 10921111375,
        RunAnim  = 10921104374,
        JumpAnim = 10921107367,
        FallAnim = 10921105765,
        SwimIdle = 10921110146,
        Swim     = 10921108971,
        ClimbAnim = 10921100400,
        Animation1 = 10921101664,
        Animation2 = 10921102574,
    },
    Zombie = {
        WalkAnim = 10921355261,
        RunAnim  = 616163682,
        JumpAnim = 10921351278,
        FallAnim = 10921350320,
        SwimIdle = 10921353442,
        Swim     = 10921352344,
        Animation1 = 10921344533,
        Animation2 = 10921345304,
        ClimbAnim = 10921343576,
    },
    Mage = {
        WalkAnim = 10921152678,
        RunAnim  = 10921148209,
        JumpAnim = 10921149743,
        FallAnim = 10921148939,
        SwimIdle = 10921151661,
        Swim     = 10921150788,
        ClimbAnim = 10921143404,
        Animation1 = 10921144709,
        Animation2 = 10921145797,
    },
    ["Catwalk Glam"] = {
        WalkAnim = 109168724482748,
        RunAnim  = 81024476153754,
        JumpAnim = 116936326516985,
        FallAnim = 92294537340807,
        SwimIdle = 98854111361360,
        Swim     = 134591743181628,
        ClimbAnim = 119377220967554,
        Animation1 = 133806214992291,
        Animation2 = 94970088341563,
    },
    Astronaut = {
        WalkAnim = 10921046031,
        RunAnim  = 10921039308,
        JumpAnim = 10921042494,
        FallAnim = 10921040576,
        SwimIdle = 10921045006,
        Swim     = 10921044000,
        ClimbAnim = 10921032124,
        Animation1 = 10921034824,
        Animation2 = 10921036806,
    },
    ['Wicked "Dancing Through Life"'] = {
        WalkAnim = 73718308412641,
        RunAnim  = 135515454877967,
        JumpAnim = 78508480717326,
        FallAnim = 78147885297412,
        SwimIdle = 129183123083281,
        Swim     = 110657013921774,
        ClimbAnim = 129447497744818,
        Animation1 = 92849173543269,
        Animation2 = 132238900951109,
    },
    Werewolf = {
        WalkAnim = 10921342074,
        RunAnim  = 10921336997,
        JumpAnim = nil,
        FallAnim = 10921337907,
        SwimIdle = 10921341319,
        Swim     = 10921340419,
        ClimbAnim = 10921329322,
        Animation1 = 10921330408,
        Animation2 = 10921333667,
    },
    Superhero = {
        WalkAnim = 10921298616,
        RunAnim  = 10921291831,
        JumpAnim = 10921294559,
        FallAnim = 10921293373,
        SwimIdle = 10921297391,
        Swim     = 10921295495,
        ClimbAnim = 10921286911,
        Animation1 = 10921288909,
        Animation2 = 10921290167,
    },
    Toy = {
        WalkAnim = 10921312010,
        RunAnim  = 10921306285,
        JumpAnim = 10921308158,
        FallAnim = 10921307241,
        SwimIdle = 10921310341,
        Swim     = 10921309319,
        ClimbAnim = 10921300839,
        Animation1 = 10921301576,
        Animation2 = nil,
    },
    ["No Boundaries"] = {
        WalkAnim = 18747074203,
        RunAnim  = 18747070484,
        JumpAnim = 18747069148,
        FallAnim = 18747062535,
        SwimIdle = 18747071682,
        Swim     = 18747073181,
        ClimbAnim = 18747060903,
        Animation1 = 18747067405,
        Animation2 = 18747063918,
    },
    NFL = {
        WalkAnim = 110358958299415,
        RunAnim  = 117333533048078,
        JumpAnim = 119846112151352,
        FallAnim = 129773241321032,
        SwimIdle = 79090109939093,
        Swim     = 132697394189921,
        ClimbAnim = 134630013742019,
        Animation1 = 92080889861410,
        Animation2 = 74451233229259,
    },
    ["Amazon Unboxed"] = {
        WalkAnim = 90478085024465,
        RunAnim  = 134824450619865,
        JumpAnim = 121454505477205,
        FallAnim = 94788218468396,
        SwimIdle = 129126268464847,
        Swim     = 105962919001086,
        ClimbAnim = 121145883950231,
        Animation1 = 98281136301627,
        Animation2 = nil,
    },
    Vampire = {
        WalkAnim = 10921326949,
        RunAnim  = 10921320299,
        JumpAnim = 10921322186,
        FallAnim = 10921321317,
        SwimIdle = 10921325443,
        Swim     = 10921324408,
        ClimbAnim = 10921314188,
        Animation1 = 10921315373,
        Animation2 = nil,
    },
    Ninja = {
        Run=656118852, Walk=656121766, Jump=656117878, Fall=656115606,
        Swim=656119721, SwimIdle=656121397, Climb=656114359,
        Idle={656117400,656118341,886742569}
    },
    Robot = {
        Run=616091570, Walk=616095330, Jump=616090535, Fall=616087089,
        Swim=616092998, SwimIdle=616094091, Climb=616086039,
        Idle={616088211,616089559,885531463}
    },
    Levitation = {
        Run=616010382, Walk=616013216, Jump=616008936, Fall=616005863,
        Swim=616011509, SwimIdle=616012453, Climb=616003713,
        Idle={616006778,616008087,886862142}
    },
    Stylish = {
        Run=616140816, Walk=616146177, Jump=616139451, Fall=616134815,
        Swim=616143378, SwimIdle=616144772, Climb=616133594,
        Idle={616136790,616138447,886888594}
    },
    Bubbly = {
        Run=910025107, Walk=910034870, Jump=910016857, Fall=910001910,
        Swim=910028158, SwimIdle=910030921, Climb=909997997,
        Idle={910004836,910009958,1018536639}
    },
    Cartoon = {
        Run=742638842, Walk=742640026, Jump=742637942, Fall=742637151,
        Swim=742639220, SwimIdle=742639812, Climb=742636889,
        Idle={742637544,742638445,885477856}
    },
}
M.animPack = "Adidas Sports"
M.animPackEnabled = true
M.savedAnimate = nil

-- ============================================================
-- CHARTER FEATURES (Headless & Korblox)
-- ============================================================
M.headlessEnabled = false
M.korbloxEnabled = false

local HEADLESS_MESH_ID = "rbxassetid://1095708"
local KORBLOX_MESH_ID = "rbxassetid://101851696"
local KORBLOX_TEXTURE_ID = "rbxassetid://101851254"
local DARK_GREY_COLOR = Color3.fromRGB(64, 64, 64)

local function removeFace(head)
    local face = head:FindFirstChild("face")
    if face then face:Destroy() end
end

function M.applyHeadlessToChar(char, enabled)
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    if enabled then
        head.Transparency = 1
        head.CanCollide = false
        removeFace(head)

        for _, child in ipairs(head:GetChildren()) do
            if child:IsA("SpecialMesh") and child.MeshId == HEADLESS_MESH_ID then
                child:Destroy()
            end
        end

        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = HEADLESS_MESH_ID
        mesh.Scale = Vector3.new(0.001, 0.001, 0.001)
        mesh.Name = "HeadlessMesh"
        mesh.Parent = head

        head:GetPropertyChangedSignal("Transparency"):Connect(function()
            if head.Transparency ~= 1 then
                head.Transparency = 1
            end
        end)
        head.ChildAdded:Connect(function(child)
            if child.Name == "face" and child:IsA("Decal") then
                child:Destroy()
            end
        end)
    else
        head.Transparency = 0
        head.CanCollide = true
        for _, child in ipairs(head:GetChildren()) do
            if child:IsA("SpecialMesh") and child.Name == "HeadlessMesh" then
                child:Destroy()
            end
        end
        removeFace(head)
    end
end

function M.applyKorbloxToChar(char, enabled)
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    if enabled then
        if humanoid.RigType == Enum.HumanoidRigType.R6 then
            local rightLeg = char:FindFirstChild("Right Leg")
            if rightLeg then
                for _, child in ipairs(rightLeg:GetChildren()) do
                    if child:IsA("SpecialMesh") or child:IsA("CharacterMesh") then
                        child:Destroy()
                    end
                end
                rightLeg.Color = DARK_GREY_COLOR
                rightLeg:GetPropertyChangedSignal("Color"):Connect(function()
                    if rightLeg.Color ~= DARK_GREY_COLOR then
                        rightLeg.Color = DARK_GREY_COLOR
                    end
                end)
                local mesh = Instance.new("SpecialMesh")
                mesh.MeshType = Enum.MeshType.FileMesh
                mesh.MeshId = KORBLOX_MESH_ID
                mesh.TextureId = KORBLOX_TEXTURE_ID
                mesh.Scale = Vector3.new(1, 1, 1)
                mesh.Name = "KorbloxMesh"
                mesh.Parent = rightLeg
            end
        elseif humanoid.RigType == Enum.HumanoidRigType.R15 then
            local rightUpperLeg = char:FindFirstChild("RightUpperLeg")
            if rightUpperLeg then
                rightUpperLeg.Transparency = 1
                local rightLowerLeg = char:FindFirstChild("RightLowerLeg")
                local rightFoot = char:FindFirstChild("RightFoot")
                if rightLowerLeg then rightLowerLeg.Transparency = 1 end
                if rightFoot then rightFoot.Transparency = 1 end

                local oldKorblox = char:FindFirstChild("KorbloxLeg")
                if oldKorblox then oldKorblox:Destroy() end

                local korbloxLeg = Instance.new("Part")
                korbloxLeg.Name = "KorbloxLeg"
                korbloxLeg.Size = Vector3.new(1, 2, 1)
                korbloxLeg.Anchored = false
                korbloxLeg.CanCollide = false
                korbloxLeg.Color = DARK_GREY_COLOR
                korbloxLeg.Parent = char

                local mesh = Instance.new("SpecialMesh")
                mesh.MeshType = Enum.MeshType.FileMesh
                mesh.MeshId = KORBLOX_MESH_ID
                mesh.TextureId = KORBLOX_TEXTURE_ID
                mesh.Scale = Vector3.new(1, 1, 1)
                mesh.Name = "KorbloxMesh"
                mesh.Parent = korbloxLeg

                local weld = Instance.new("Weld")
                weld.Part0 = rightUpperLeg
                weld.Part1 = korbloxLeg
                weld.C0 = CFrame.new(0, -0.8, 0)
                weld.Name = "KorbloxWeld"
                weld.Parent = korbloxLeg
            end
        end
    else
        if humanoid.RigType == Enum.HumanoidRigType.R6 then
            local rightLeg = char:FindFirstChild("Right Leg")
            if rightLeg then
                for _, child in ipairs(rightLeg:GetChildren()) do
                    if child:IsA("SpecialMesh") and child.Name == "KorbloxMesh" then
                        child:Destroy()
                    end
                end
                rightLeg.Color = Color3.fromRGB(255, 255, 255)
            end
        elseif humanoid.RigType == Enum.HumanoidRigType.R15 then
            local rightUpperLeg = char:FindFirstChild("RightUpperLeg")
            if rightUpperLeg then
                rightUpperLeg.Transparency = 0
                local rightLowerLeg = char:FindFirstChild("RightLowerLeg")
                local rightFoot = char:FindFirstChild("RightFoot")
                if rightLowerLeg then rightLowerLeg.Transparency = 0 end
                if rightFoot then rightFoot.Transparency = 0 end
                local korbloxLeg = char:FindFirstChild("KorbloxLeg")
                if korbloxLeg then korbloxLeg:Destroy() end
            end
        end
    end
end

function M.applyCharterToChar(char)
    if not char then return end
    M.applyHeadlessToChar(char, M.headlessEnabled)
    M.applyKorbloxToChar(char, M.korbloxEnabled)
end

player.CharacterAdded:Connect(function(char)
    task.wait(0.15)
    M.applyCharterToChar(char)
end)

RunService.Heartbeat:Connect(function()
    local char = player.Character
    if char then
        M.applyCharterToChar(char)
    end
end)

-- ============================================================
-- STATE
-- ============================================================
M.NS = 60
M.CS = 30
M.LAGGER_SPEED = 15
M.LAGGER_CARRY_SPEED = 24.5
M.speedMethod = "Velocity"
M.speedMethodList = {
    "Velocity", "AssemblyLinearVelocity", "Velocity Lerp", "AssemblyLinearVelocity Lerp",
    "CFrame", "CFrame Lerp", "Hyper CFrame", "Anchored CFrame", "PivotTo", "Model PivotTo", "Tween CFrame",
    "WalkSpeed", "Humanoid Move", "Humanoid MoveTo",
    "BodyVelocity", "BodyPosition", "BodyForce", "BodyThrust",
    "LinearVelocity", "VectorForce", "AlignPosition",
    "ApplyImpulse", "RocketPropulsion",
}
M.hyperMult = 4
M._lastSpeedMethod = nil
M._speedHRP = nil
M._anchoredBySpeed = nil
M._bodyVel = nil
M._bodyPosition = nil
M._bodyForce = nil
M._bodyThrust = nil
M._linearVel = nil
M._vectorForce = nil
M._alignPos = nil
M._rocket = nil
M._rocketTarget = nil
M._attLinVel = nil
M._attVecForce = nil
M._attAlign = nil
M._speedTween = nil
M.carrySpeedActive = false
M.laggerModeEnabled = false
M.laggerCarryActive = false

M.antiRagdollEnabled = false
M.antiRagdollMode = "Splatter"
M.infJumpEnabled = false
M.infJumpMode = "manual"
M.medusaCounterEnabled = false
M.batCounterEnabled = false
M.unwalkEnabled = false
M.medusaResetEnabled = false
M.medusaDebounce = false
M.medusaLastUsed = 0
M.dropActive = false
M.autoLeftEnabled = false
M.autoRightEnabled = false
M.autoBatEnabled = false
M.autoSwingEnabled = true
M.autoMoveSwingEnabled = false
M.autoMoveSwingInterval = 0.3
M._alSwingDebounce = false
M._arSwingDebounce = false
M.antiLagEnabled = false
M.antiSummerBaseEnabled = false
M.antiSummerBaseConn = nil
M._antiSummerCleaned = {}

M.removeAccessoriesEnabled = false
M.antiLagDescConn = nil
M.stretchRezEnabled = false
M.stretchRezConn = nil
M.unwalkSavedAnimate = nil
M._anyKeyListening = false
M.autoTPEnabled = false
M.autoTPHeight = 20
M.autoTPConn = nil
M.cursedResetRemote = nil
M.CURSED_RESET_GUID = "f888ee6e-c86d-46e1-93d7-0639d6635d42"
M.guiTransparencyEnabled = false
M.mobileButtonsEnabled = true
M.mobileButtonsLocked = false
M.mobileButtonsSize = 100
M.menuWidth = 560
M.menuHeight = 450
M.circleButtonsEnabled = false
M.mobBtnRefs = {}
M.mobGuiRef = nil
M.fovValue = 80
M.fovOptions = {80,120,180}
M.fovIndex = 1
M.laggerModePillRef = nil
M.carryModePillRef = nil
M.autoSwitchSpeedEnabled = false
M.autoTurnOffSpeedEnabled = false
M.autoSwitchLaggerSpeedEnabled = false
M.AUTO_SWITCH_THRESHOLD = 25
M._autoSwitchSpeedConn = nil
M.customFontSelected = "None"
M._fontOrig = {}
M._fontConn = nil
M._fontMy = nil
M.FONT_NAMES = {"None", "Coding Font", "Summer", "Beachy", "Scary", "Bangers"}
M.mobBtnTransparencyEnabled = false
M.perButtonDragEnabled = true
M.antiKickEnabled = false
M.brainrotDetected = false
M.safeModeEnabled = false
M.mirrorTPDownEnabled = false
M.mirrorTPPreviousY = {}
M.mirrorTPLastTeleport = 0
M.MIRROR_TP_DROP_THRESHOLD = 3
M.MIRROR_TP_DOWN_Y = -7.00
M.activeBatBillboard = nil
M.activeMedusaBillboard = nil
M.ragdollGuiEnabled = true
M.persistentRagdollGui = nil
M.uiLocked = false
M.holdInfJumpConn = nil
M.DROP_ASCEND_DURATION = 0.2
M.DROP_ASCEND_SPEED = 150
M.autoResetOnDeath = false
M.bypassAimbotEnabled = false
M.bypassAimbotConn = nil
M._bypassGodConn = nil
M._bypassGodHealthConn = nil
M._bypassGodDiedConn = nil
M._bypassGodCharConn = nil
M.bypassPrevAutoRotate = nil
M.bypassHitCD = false
M.bypassSwingCD = 0.35
M.bypassHitDist = 8
M._bypassTarget = nil

M.stealMode = "V1"
M.stealBarSize = 300
M.Steal = {
    AutoStealEnabled = false,
    StealRadius = 60,
    StealDuration = 1.4,
    StopTime = 0.35,
}
M.V3 = {
    enabled = false,
    conn = nil,
    progress = 0,
    lastInRange = 0,
    currentUid = nil,
    holding = false,
    holdPrompt = nil,
    cooldownUntil = 0,
}
M.autoRadiusEnabled = false
function M.getAutoRadius()
    local radius = math.clamp((tonumber(M.NS) or 60) + 1, 1, 500)
    return math.floor(radius * 10 + 0.5) / 10
end
function M.getActiveStealRadius()
    if M.stealMode == "Semi" or M.stealMode == "V2" then
        return math.min(tonumber(M.Semi.radius) or 10, 10)
    end
    return M.autoRadiusEnabled and M.getAutoRadius() or M.Steal.StealRadius
end
M.Semi = {
    enabled = false,
    holdMin = 1.3,
    holdMax = 2.6,
    entryDelay = 0.3,
    cooldown = 0.05,
    primeRange = 80,
    radius = 10, -- STEAL_RANGE from auto-grabber
    conn = nil,
    scanThread = nil,
    plotSync = {caches = {}, connections = {}},
    animals = {},
    promptCache = {},
    internalCache = {},
    state = {active = false, startTime = 0, phase = "idle", label = "", lastResult = "", lastResultTime = 0},
    plots = nil,
    syncReady = false,
}
M.isStealing = false
M.stealStartTime = 0
M.stealConn = nil
M.progressConn = nil
M.animalCache = {}
M.promptCache = {}
M.stealCache = {}
M.playerESPEnabled = false
M.espList = {}
M.pingPopupActive = false
M.pingPopupGui = nil
M.pingCycleTimer = nil
M.Conns = {autoSteal=nil, antiRag=nil, batCounter=nil, anchor={}}
M._persistentConns = {}
M.alConn = nil
M.arConn = nil
M.alPhase = 1
M.arPhase = 1
M.aimbotConn = nil
M.lastMoveDir = Vector3.new(0,0,0)
M.batCounterDebounce = false
M.speedLabel = nil

-- Keybinds
M.KB = {
    DropBrainrot={kb=nil,gp=nil},
    AutoLeft={kb=nil,gp=nil},
    AutoRight={kb=nil,gp=nil},
    AutoBat={kb=nil,gp=nil},
    TPFloor={kb=nil,gp=nil},
    InstaReset={kb=nil,gp=nil},
    GuiHide={kb=nil,gp=nil},
    SpeedToggle={kb=nil,gp=nil},
    LaggerToggle={kb=nil,gp=nil},
    BypassAimbot={kb=nil,gp=nil},
}
M.AP_L1 = Vector3.new(-476.47,-6.28,92.73)
M.AP_L2 = Vector3.new(-483.12,-4.95,94.81)
M.AP_R1 = Vector3.new(-476.16,-6.52,25.62)
M.AP_R2 = Vector3.new(-483.06,-5.03,25.48)
M.MEDUSA_COOLDOWN = 25
M.BAT_COUNTER_SLAP_LIST = {"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}
M.fovConn = nil
M.defLightBrightness = nil
M.defLightClock = nil
M.defLightAmbient = nil
M.mainFrame = nil
M.normalBox = nil
M.carryBox = nil
M.laggerBox = nil
M.radInput = nil
M.autoTPHeightBox = nil
M.durationBox = nil
M.modeValLbl = nil
M.setInstaGrab = nil
M.setInfJumpVisual = nil
M.setAntiRagVisual = nil
M.setMedusaVisual = nil
M.setUnwalkVisual = nil
M.setAntiLagVisual = nil
M.setAutoSwingVisual = nil
M.setTranspVisual = nil
M.setLockVisual = nil
M.setMobVisual = nil
M.setCircleBtnsVisual = nil
M.setMedusaResetVisual = nil
M.antiKickSetVisual = nil
M.autoLeftSetVisual = nil
M.autoRightSetVisual = nil
M.autoBatSetVisual = nil
M.setAutoTPVisual = nil
M.setStretchRezVisual = nil
M.setAutoResetOnDeath = nil
M.setBypassVisual = nil
M._autoSwitchWasSteal = false

M.MOB_POS_FILE = "rykeduels_btnpos_v2.json"
M.MOVE_KEYS = {
    [Enum.KeyCode.W]=true,
    [Enum.KeyCode.A]=true,
    [Enum.KeyCode.S]=true,
    [Enum.KeyCode.D]=true,
    [Enum.KeyCode.Up]=true,
    [Enum.KeyCode.Left]=true,
    [Enum.KeyCode.Down]=true,
    [Enum.KeyCode.Right]=true
}

M.showPlayerSpeeds = false
M.playerSpeedGuis = {}
M.playerSpeedUpdateConn = nil
M.removeAccEnabled = false
M.removeAccConn = nil
M.removedAccessories = {}
M.uiScale = 0.8
if UIS.TouchEnabled and not UIS.KeyboardEnabled then
    M.uiScale = 0.7
end
M.uiScaleSliderRef = nil
M.uiScaleLabelRef = nil
M.uiScaleBoxRef = nil
M.lineESPEnabled = false
M.menuOpen = true
M.speedESPEnabled = false

M.statusGui = nil
M.statusFill = nil
M.statusPctLbl = nil
M.statusRadiusLbl = nil
M.statusDot = nil
M.statusMain = nil
M.statusFpsLbl = nil

-- ============================================================
-- UTILITY FUNCTIONS
-- ============================================================
function M.addShimmerToLabel(lbl,color1,color2)
    local gr=Instance.new("UIGradient",lbl)
    gr.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,color1 or Color3.fromRGB(100,100,100)),ColorSequenceKeypoint.new(0.5,color2 or Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,color1 or Color3.fromRGB(100,100,100))})
    gr.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.3,0),NumberSequenceKeypoint.new(0.5,0,0),NumberSequenceKeypoint.new(1,0.3,0)})
    return gr
end

function M.applyFOV()
    if M.fovConn then M.fovConn:Disconnect() end
    M.fovConn=RunService.RenderStepped:Connect(function() local cam=workspace.CurrentCamera;if cam then cam.FieldOfView=M.fovValue end end)
end

-- ============================================================
-- RAGDOLL TIMER
-- ============================================================
M.ragdollTimerThread = nil
M.ragdollTimerRemaining = 0
M.isRagdollActive = false

function M.updateRagdollTimer(duration)
    if M.ragdollTimerThread then
        task.cancel(M.ragdollTimerThread)
        M.ragdollTimerThread = nil
    end
    if duration <= 0 then
        M.isRagdollActive = false
        if M.headIndicator and M.headIndicator.ragdollTimer then
            M.headIndicator.ragdollTimer.Text = ""
        end
        return
    end
    M.isRagdollActive = true
    local startTime = tick()
    M.ragdollTimerRemaining = duration
    M.ragdollTimerThread = task.spawn(function()
        while M.isRagdollActive and M.ragdollTimerRemaining > 0 do
            local elapsed = tick() - startTime
            local remaining = math.max(0, duration - elapsed)
            M.ragdollTimerRemaining = remaining
            if M.headIndicator and M.headIndicator.ragdollTimer then
                M.headIndicator.ragdollTimer.Text = string.format("%.1fs", remaining)
            end
            if remaining <= 0 then
                M.isRagdollActive = false
                if M.headIndicator and M.headIndicator.ragdollTimer then
                    M.headIndicator.ragdollTimer.Text = ""
                end
                break
            end
            task.wait(0.05)
        end
        M.ragdollTimerThread = nil
    end)
end

function M.onHumanoidStateChanged(old,new)
    local char=player.Character;if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid");if not hum then return end
    local isRag=(new==Enum.HumanoidStateType.Physics or new==Enum.HumanoidStateType.Ragdoll or new==Enum.HumanoidStateType.FallingDown)
    if isRag and not hum.PlatformStand then
        M.updateRagdollTimer(2.6)
    end
end

function M.onMedusaStateChanged()
    local char=player.Character;if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid")
    if hum and hum.PlatformStand then
        M.updateRagdollTimer(4.5)
    end
end

function M.setupRagdollTriggers()
    local char=player.Character;if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.StateChanged:Connect(M.onHumanoidStateChanged)
        hum:GetPropertyChangedSignal("PlatformStand"):Connect(M.onMedusaStateChanged)
    end
end

-- ============================================================
-- ANIMATION FUNCTIONS (unchanged)
-- ============================================================
function M.waitForAnimate(char)
    for _ = 1, 40 do
        local a = char:FindFirstChild("Animate")
        if a and a:FindFirstChild("idle") and a:FindFirstChild("run") and a:FindFirstChild("walk") then
            return a
        end
        task.wait(0.1)
    end
    return nil
end

function M.setAnim(animObj, id)
    if animObj and id then
        animObj.AnimationId = "rbxassetid://" .. tostring(id)
    end
end

function M.stopAllTracks(hum)
    if not hum then return end
    for _, t in ipairs(hum:GetPlayingAnimationTracks()) do
        pcall(function() t:Stop(0) end)
    end
end

function M.ensureAnim(folder, name)
    if not folder then return nil end
    local a = folder:FindFirstChild(name)
    if not a then
        a = Instance.new("Animation")
        a.Name = name
        a.Parent = folder
    end
    return a
end

function M.ensureIdleSlots(idleFolder, n)
    if not idleFolder then return end
    n = n or 2
    for i=1,n do
        M.ensureAnim(idleFolder, "Animation" .. i)
    end
end

function M.pick(pack, ...)
    for i = 1, select("#", ...) do
        local k = select(i, ...)
        local v = pack[k]
        if v ~= nil then return v end
    end
    return nil
end

function M.saveOriginalAnimate(char)
    if not char then return end
    if M.savedAnimate then return end
    local animate = char:FindFirstChild("Animate")
    if animate then
        M.savedAnimate = animate:Clone()
    end
end

function M.restoreOriginalAnimate(char)
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        M.stopAllTracks(hum)
    end
    local currentAnimate = char:FindFirstChild("Animate")
    if currentAnimate then
        currentAnimate:Destroy()
    end
    if M.savedAnimate then
        local newAnimate = M.savedAnimate:Clone()
        newAnimate.Parent = char
        newAnimate.Disabled = true
        task.wait(0.06)
        newAnimate.Disabled = false
    end
end

function M.resetAnimations(char)
    if not char then return end
    M.restoreOriginalAnimate(char)
end

local applyingAnim = false
function M.applyAnimPack(packName)
    if not M.animPackEnabled then
        local char = player.Character
        if char then
            M.resetAnimations(char)
        end
        return false
    end
    if applyingAnim then return false end
    applyingAnim = true

    local pack = M.PACKS[packName]
    if not pack then
        applyingAnim = false
        return false
    end

    local char = player.Character or player.CharacterAdded:Wait()
    M.saveOriginalAnimate(char)

    local animate = M.waitForAnimate(char)
    if not animate then
        applyingAnim = false
        return false
    end

    local hum = char:FindFirstChildOfClass("Humanoid")
    M.stopAllTracks(hum)

    local runObj   = M.ensureAnim(animate:FindFirstChild("run"),   "RunAnim")
    local walkObj  = M.ensureAnim(animate:FindFirstChild("walk"),  "WalkAnim")
    local jumpObj  = M.ensureAnim(animate:FindFirstChild("jump"),  "JumpAnim")
    local fallObj  = M.ensureAnim(animate:FindFirstChild("fall"),  "FallAnim")
    local climbObj = M.ensureAnim(animate:FindFirstChild("climb"), "ClimbAnim")
    local swimObj  = M.ensureAnim(animate:FindFirstChild("swim"),     "Swim")
    local swimIdleObj = M.ensureAnim(animate:FindFirstChild("swimidle"), "SwimIdle")
    local idleFolder = animate:FindFirstChild("idle")

    M.setAnim(walkObj,  M.pick(pack, "WalkAnim", "Walk"))
    M.setAnim(runObj,   M.pick(pack, "RunAnim", "Run"))
    M.setAnim(jumpObj,  M.pick(pack, "JumpAnim", "Jump"))
    M.setAnim(fallObj,  M.pick(pack, "FallAnim", "Fall"))
    M.setAnim(climbObj, M.pick(pack, "ClimbAnim", "Climb"))
    M.setAnim(swimObj,      M.pick(pack, "Swim"))
    M.setAnim(swimIdleObj,  M.pick(pack, "SwimIdle") or M.pick(pack, "Swim"))

    if idleFolder then
        local a1 = M.pick(pack, "Animation1")
        local a2 = M.pick(pack, "Animation2")
        if a1 or a2 then
            M.ensureIdleSlots(idleFolder, 2)
            local id1 = a1 or a2
            local id2 = a2 or a1 or id1
            M.setAnim(idleFolder:FindFirstChild("Animation1"), id1)
            M.setAnim(idleFolder:FindFirstChild("Animation2"), id2)
        elseif pack.Idle and #pack.Idle > 0 then
            M.ensureIdleSlots(idleFolder, math.max(2, #pack.Idle))
            M.setAnim(idleFolder:FindFirstChild("Animation1"), pack.Idle[1])
            M.setAnim(idleFolder:FindFirstChild("Animation2"), pack.Idle[2] or pack.Idle[1])
            for i = 3, #pack.Idle do
                local a = idleFolder:FindFirstChild("Animation" .. i)
                if a then M.setAnim(a, pack.Idle[i]) end
            end
        end
    end

    animate.Disabled = true
    task.wait(0.06)
    animate.Disabled = false

    if hum then
        pcall(function()
            hum:ChangeState(Enum.HumanoidStateType.Landed)
            task.wait(0.03)
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end)
    end

    M.animPack = packName
    applyingAnim = false
    return true
end

-- ============================================================
-- PLAYER SPEED DISPLAY
-- ============================================================
function M.createPlayerSpeedGui(plr)
    if plr == player then return end
    if M.playerSpeedGuis[plr] then return end
    local char = plr.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    local old = head:FindFirstChild("RykePlayerSpeedBB")
    if old then old:Destroy() end
    local bb = Instance.new("BillboardGui")
    bb.Name = "RykePlayerSpeedBB"
    bb.Size = UDim2.new(0, 80, 0, 24)
    bb.StudsOffset = Vector3.new(0, 2.2, 0)
    bb.AlwaysOnTop = true
    bb.Adornee = head
    bb.Parent = head
    local label = Instance.new("TextLabel", bb)
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.Text = "0"
    label.TextColor3 = RYKE_ACCENT or Color3.fromRGB(255,255,255)
    label.Font = Enum.Font.GothamBold
    label.TextScaled = true
    label.TextStrokeTransparency = 0
    M.addShimmerToLabel(label, RYKE_ACCENT or Color3.fromRGB(255,255,255), Color3.fromRGB(255,255,255))
    local conn
    conn = char.AncestryChanged:Connect(function(_, parent)
        if not parent then
            M.removePlayerSpeedGui(plr)
            if conn then conn:Disconnect() end
        end
    end)
    M.playerSpeedGuis[plr] = {gui = bb, label = label, conn = conn}
end

function M.removePlayerSpeedGui(plr)
    local data = M.playerSpeedGuis[plr]
    if data then
        if data.conn then data.conn:Disconnect() end
        if data.gui then data.gui:Destroy() end
        M.playerSpeedGuis[plr] = nil
    end
end

function M.updatePlayerSpeed(plr)
    if not M.showPlayerSpeeds then return end
    local data = M.playerSpeedGuis[plr]
    if not data then return end
    local char = plr.Character
    if not char then M.removePlayerSpeedGui(plr); return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local speed = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z).Magnitude
    data.label.Text = string.format("%.1f", speed)
end

function M.updateAllPlayerSpeeds()
    for plr, _ in pairs(M.playerSpeedGuis) do M.updatePlayerSpeed(plr) end
end

function M.startPlayerSpeedUpdates()
    if M.playerSpeedUpdateConn then return end
    M.playerSpeedUpdateConn = RunService.Heartbeat:Connect(function() M.updateAllPlayerSpeeds() end)
end

function M.stopPlayerSpeedUpdates()
    if M.playerSpeedUpdateConn then M.playerSpeedUpdateConn:Disconnect(); M.playerSpeedUpdateConn = nil end
end

function M.togglePlayerSpeeds(on)
    M.showPlayerSpeeds = on
    if on then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player then M.createPlayerSpeedGui(plr) end
        end
        M.startPlayerSpeedUpdates()
    else
        for plr, _ in pairs(M.playerSpeedGuis) do M.removePlayerSpeedGui(plr) end
        M.stopPlayerSpeedUpdates()
    end
end

-- ============================================================
-- PLAYER ESP
-- ============================================================
function M.addESP(plr)
    if plr == player then return end
    if M.espList[plr] then return end
    local char = plr.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    local nameBB = Instance.new("BillboardGui")
    nameBB.Size = UDim2.new(0, 120, 0, 30)
    nameBB.StudsOffset = Vector3.new(0, 2.8, 0)
    nameBB.AlwaysOnTop = true
    nameBB.Adornee = head
    nameBB.Parent = head
    local nameLbl = Instance.new("TextLabel", nameBB)
    nameLbl.Size = UDim2.new(1,0,1,0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = plr.Name
    nameLbl.TextColor3 = Color3.fromRGB(255,255,255)
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextScaled = true
    nameLbl.TextStrokeTransparency = 0
    nameLbl.TextStrokeColor3 = Color3.fromRGB(0,0,0)

    local highlight = Instance.new("Highlight")
    highlight.Adornee = char
    highlight.FillTransparency = 1
    highlight.OutlineTransparency = 0.3
    highlight.OutlineColor = Color3.fromRGB(255,255,255)
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = char

    M.espList[plr] = {nameBB = nameBB, highlight = highlight}
end

function M.removeESP(plr)
    local data = M.espList[plr]
    if data then
        if data.nameBB then data.nameBB:Destroy() end
        if data.highlight then data.highlight:Destroy() end
        M.espList[plr] = nil
    end
end

function M.clearESP()
    for plr, _ in pairs(M.espList) do M.removeESP(plr) end
end

function M.toggleESP(on)
    M.playerESPEnabled = on
    if on then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player then M.addESP(plr) end
        end
        if not M._espPlayerAdded then
            M._espPlayerAdded = Players.PlayerAdded:Connect(function(p)
                if p ~= player and M.playerESPEnabled then
                    p.CharacterAdded:Connect(function()
                        task.wait(0.5)
                        M.addESP(p)
                    end)
                    if p.Character then task.wait(0.5); M.addESP(p) end
                end
            end)
            M.trackConn(M._espPlayerAdded)
        end
        if not M._espPlayerRemoved then
            M._espPlayerRemoved = Players.PlayerRemoving:Connect(function(p)
                M.removeESP(p)
            end)
            M.trackConn(M._espPlayerRemoved)
        end
    else
        M.clearESP()
        if M._espPlayerAdded then M._espPlayerAdded:Disconnect(); M._espPlayerAdded = nil end
        if M._espPlayerRemoved then M._espPlayerRemoved:Disconnect(); M._espPlayerRemoved = nil end
    end
end

-- ============================================================
-- OVER-HEAD INDICATOR
-- ============================================================
M.headIndicator = nil

function M.setupHeadIndicator(char)
    local head=char:WaitForChild("Head",5);if not head then return end
    if head:FindFirstChild("RykeHeadIndicator") then head.MoveeHeadIndicator:Destroy() end
    local bb=Instance.new("BillboardGui",head)
    bb.Name="RykeHeadIndicator"
    bb.Size=UDim2.new(0,250,0,90)
    bb.StudsOffset=Vector3.new(0,3.5,0)
    bb.AlwaysOnTop=true
    bb.Parent=head

    local accent = RYKE_ACCENT or Color3.fromRGB(255,255,255)

    local ragdollLbl=Instance.new("TextLabel",bb)
    ragdollLbl.Name="RagdollTimer"
    ragdollLbl.Size=UDim2.new(1,0,0.33,0)
    ragdollLbl.Position=UDim2.new(0,0,0,0)
    ragdollLbl.BackgroundTransparency=1
    ragdollLbl.Text=""
    ragdollLbl.TextColor3=accent
    ragdollLbl.Font=Enum.Font.GothamBold
    ragdollLbl.TextScaled=true
    ragdollLbl.TextStrokeTransparency=0

    local discordLbl=Instance.new("TextLabel",bb)
    discordLbl.Name="Discord"
    discordLbl.Size=UDim2.new(1,0,0.30,0)
    discordLbl.Position=UDim2.new(0,0,0.30,0)
    discordLbl.BackgroundTransparency=1
    discordLbl.Text="discord.gg/rykeduels"
    discordLbl.TextColor3=accent
    discordLbl.Font=Enum.Font.GothamBold
    discordLbl.TextScaled=true
    discordLbl.TextStrokeTransparency=0

    -- Divider line between discord tag and speed label
    local div = Instance.new("Frame", bb)
    div.Name = "Divider"
    div.Size = UDim2.new(0.72, 0, 0, 2)
    div.Position = UDim2.new(0.14, 0, 0.635, 0)
    div.BackgroundColor3 = accent
    div.BackgroundTransparency = 0.15
    div.BorderSizePixel = 0
    div.ZIndex = 2
    local divCorner = Instance.new("UICorner", div)
    divCorner.CornerRadius = UDim.new(1, 0)

    local speedLbl=Instance.new("TextLabel",bb)
    speedLbl.Name="Speed"
    speedLbl.Size=UDim2.new(1,0,0.30,0)
    speedLbl.Position=UDim2.new(0,0,0.66,0)
    speedLbl.BackgroundTransparency=1
    speedLbl.Text="0.0"
    speedLbl.TextColor3=accent
    speedLbl.Font=Enum.Font.GothamBold
    speedLbl.TextScaled=true
    speedLbl.TextStrokeTransparency=0

    M.headIndicator = {bb=bb, discord=discordLbl, speed=speedLbl, ragdollTimer=ragdollLbl, divider=div}
    M.updateHeadTheme()
end

function M.updateHeadTheme()
    if not M.headIndicator then return end
    local accent = UI_ACCENT or RYKE_ACCENT or Color3.fromRGB(255,255,255)
    if M.headIndicator.discord then
        M.headIndicator.discord.TextColor3 = accent
    end
    if M.headIndicator.speed then
        M.headIndicator.speed.TextColor3 = accent
    end
    if M.headIndicator.ragdollTimer then
        M.headIndicator.ragdollTimer.TextColor3 = accent
    end
    if M.headIndicator.divider then
        M.headIndicator.divider.BackgroundColor3 = accent
    end
end

local speedUpdateConn = nil
function M.startHeadSpeedUpdates()
    if speedUpdateConn then return end
    speedUpdateConn = RunService.Heartbeat:Connect(function()
        local char = player.Character
        if char and M.headIndicator and M.headIndicator.speed then
            local displaySpeed
            if M.autoLeftEnabled or M.autoRightEnabled then
                displaySpeed = M.NS
            else
                displaySpeed = M.getActiveMoveSpeed()
            end
            M.headIndicator.speed.Text = string.format("%.1f", displaySpeed)
        end
    end)
end

function M.stopHeadSpeedUpdates()
    if speedUpdateConn then
        speedUpdateConn:Disconnect()
        speedUpdateConn = nil
    end
end

-- ============================================================
-- RYKE STATUS UI (Steal Bar)
-- ============================================================
function M.buildStatusUI()
    if M.statusGui then
        pcall(function() M.statusGui:Destroy() end)
        M.statusGui = nil
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "RykeStatusUI"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    pcall(function() gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling end)
    gui.DisplayOrder = 25

    gui.Parent = getSafeGuiParent()

    pcall(function()
        local parent = getSafeGuiParent()
        if parent then
            for _, v in ipairs(parent:GetChildren()) do
                if v ~= gui and v:IsA("ScreenGui") and (v.Name == "RykeStatusUI" or v.Name == "YahyaStatusUI" or v.Name == "StealProgressWindow") then
                    pcall(function() v:Destroy() end)
                end
            end
        end
    end)

    local totalW = math.clamp(tonumber(M.stealBarSize) or 340, 260, 600)
    local trackW = math.floor(totalW * 0.62)

    -- Outer Capsule Shell (Exact match to IMG_0806.jpeg)
    local outerCapsule = Instance.new("Frame")
    outerCapsule.Name = "StealCapsuleOuter"
    outerCapsule.Size = UDim2.new(0, totalW, 0, 38)
    outerCapsule.Position = UDim2.new(0.5, -math.floor(totalW / 2), 0.74, 0)
    outerCapsule.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
    outerCapsule.BackgroundTransparency = 0
    outerCapsule.BorderSizePixel = 0
    outerCapsule.Active = false
    outerCapsule.Parent = gui
    Instance.new("UICorner", outerCapsule).CornerRadius = UDim.new(1, 0)

    -- Outer White Contour Stroke
    local outerStroke = Instance.new("UIStroke", outerCapsule)
    outerStroke.Color = Color3.fromRGB(255, 255, 255)
    outerStroke.Thickness = 1.6
    outerStroke.Transparency = 0

    -- Inner Left Progress Track Capsule
    local track = Instance.new("Frame", outerCapsule)
    track.Name = "InnerTrack"
    track.Position = UDim2.new(0, 5, 0.5, -13)
    track.Size = UDim2.new(0, trackW, 0, 26)
    track.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
    track.BorderSizePixel = 0
    track.ClipsDescendants = true
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local trackStroke = Instance.new("UIStroke", track)
    trackStroke.Color = Color3.fromRGB(70, 70, 78)
    trackStroke.Thickness = 1.2
    trackStroke.Transparency = 0.2

    -- Progress Fill Bar inside track
    local fill = Instance.new("Frame", track)
    fill.Name = "Fill"
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    fill.BorderSizePixel = 0
    fill.ZIndex = 1
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    M.statusFill = fill

    -- Inside Left Title: STEAL
    local stealText = Instance.new("TextLabel", track)
    stealText.Name = "StealText"
    stealText.Position = UDim2.new(0, 12, 0, 0)
    stealText.Size = UDim2.new(0, 80, 1, 0)
    stealText.BackgroundTransparency = 1
    stealText.RichText = true
    stealText.Text = "<b><i>STEAL</i></b>"
    stealText.TextColor3 = Color3.fromRGB(220, 220, 225)
    stealText.TextSize = 11
    stealText.Font = Enum.Font.GothamBlack
    stealText.TextXAlignment = Enum.TextXAlignment.Left
    stealText.ZIndex = 3

    -- Inside Right Percentage: 0%
    local pctText = Instance.new("TextLabel", track)
    pctText.Name = "PctText"
    pctText.Position = UDim2.new(1, -55, 0, 0)
    pctText.Size = UDim2.new(0, 45, 1, 0)
    pctText.BackgroundTransparency = 1
    pctText.RichText = true
    pctText.Text = "<b><i>0%</i></b>"
    pctText.TextColor3 = Color3.fromRGB(180, 180, 185)
    pctText.TextSize = 10
    pctText.Font = Enum.Font.GothamBlack
    pctText.TextXAlignment = Enum.TextXAlignment.Right
    pctText.ZIndex = 3
    M.statusPctLbl = pctText
    M.statusBarPctLbl = pctText

    -- Right Side Live FPS & Ping Display: FPS:252 | PING:101MS
    local statsText = Instance.new("TextLabel", outerCapsule)
    statsText.Name = "StatsText"
    statsText.Position = UDim2.new(0, trackW + 12, 0, 0)
    statsText.Size = UDim2.new(1, -(trackW + 18), 1, 0)
    statsText.BackgroundTransparency = 1
    statsText.RichText = true
    statsText.Text = "<b><i>FPS:60 | PING:15MS</i></b>"
    statsText.TextColor3 = Color3.fromRGB(255, 255, 255)
    statsText.TextSize = 10
    statsText.Font = Enum.Font.GothamBlack
    statsText.TextXAlignment = Enum.TextXAlignment.Center

    -- Live updating FPS & Ping loop for Steal Capsule
    task.spawn(function()
        local frameCount = 0
        local lastTime = tick()
        local conn
        conn = RunService.RenderStepped:Connect(function()
            if not statsText or not statsText.Parent then
                if conn then conn:Disconnect() end
                return
            end
            frameCount = frameCount + 1
            local now = tick()
            if now - lastTime >= 1 then
                local fps = math.floor(frameCount / (now - lastTime) + 0.5)
                frameCount = 0
                lastTime = now
                local ping = 15
                pcall(function()
                    local st = game:GetService("Stats")
                    local net = st and st.Network and st.Network.ServerStatsItem and st.Network.ServerStatsItem["Data Ping"]
                    if net then ping = math.floor(net:GetValue() + 0.5) end
                end)
                statsText.Text = string.format("<b><i>FPS:%d | PING:%dMS</i></b>", fps, ping)
            end
        end)
    end)

    M.statusRadiusLbl = nil
    M.statusDot = nil
    M.statusFpsLbl = nil
    M.statusMain = outerCapsule

    M.statusGui = gui
end
function M.updateStealProgress(progress, label)
    progress = math.clamp(progress or 0, 0, 1)
    local pct = math.floor(progress * 100 + 0.5)
    local col = UI_ACCENT or RYKE_ACCENT or Color3.fromRGB(255, 255, 255)
    if M.statusFill then
        M.statusFill.Size = UDim2.fromScale(progress, 1)
        M.statusFill.BackgroundColor3 = col
    end
    -- Top status text
    if M.statusPctLbl then
        if type(label) == "string" and label ~= "" then
            M.statusPctLbl.Text = label
        elseif progress > 0 then
            M.statusPctLbl.Text = pct .. "%"
        else
            local ready = M.Steal and M.Steal.AutoStealEnabled
            M.statusPctLbl.Text = ready and "READY" or "IDLE"
        end
    end
    -- Centered % on the bar (auto-grabber style)
    if M.statusBarPctLbl then
        M.statusBarPctLbl.Text = string.format("%d%%", pct)
    end
    if M.statusDot then
        M.statusDot.BackgroundColor3 = col
    end
end

function M.updateStatusRadius()
    if M.statusRadiusLbl then
        M.statusRadiusLbl.Text = "Radius: " .. tostring(M.getActiveStealRadius())
    end
    if M.updateRadiusMarker then
        M.updateRadiusMarker()
    end
end

-- ============================================================
-- AUTO STEAL (unchanged)
-- ============================================================
if not fireproximityprompt then
    fireproximityprompt = (getgenv and getgenv().fireproximityprompt)
        or (genv and genv().fireproximityprompt)
        or function(prompt)
            pcall(function()
                prompt:InputHoldBegin()
                task.wait(0.05)
                prompt:InputHoldEnd()
            end)
        end
end

local function isMyPlot(plotName)
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return false end
    local plot = plots:FindFirstChild(plotName)
    if not plot then return false end
    local sign = plot:FindFirstChild("PlotSign")
    if sign then
        local yb = sign:FindFirstChild("YourBase")
        if yb and yb:IsA("BillboardGui") then return yb.Enabled == true end
    end
    return false
end

local function scanPlotNormal(plot)
    if not plot or not plot:IsA("Model") then return end
    if isMyPlot(plot.Name) then return end
    local podiums = plot:FindFirstChild("AnimalPodiums")
    if not podiums then return end
    for _, pod in ipairs(podiums:GetChildren()) do
        if pod:IsA("Model") and pod:FindFirstChild("Base") then
            local uid = plot.Name .. "_" .. pod.Name
            for _, ex in ipairs(M.animalCache) do if ex.uid == uid then return end end
            table.insert(M.animalCache, {
                name = pod.Name,
                plot = plot.Name,
                slot = pod.Name,
                worldPosition = pod:GetPivot().Position,
                uid = uid,
            })
        end
    end
end

local function findPromptNormal(ad)
    if not ad then return nil end
    local cp = M.promptCache[ad.uid]
    if cp and cp.Parent then return cp end
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end
    local plot = plots:FindFirstChild(ad.plot)
    if not plot then return nil end
    local pods = plot:FindFirstChild("AnimalPodiums")
    if not pods then return nil end
    local pod = pods:FindFirstChild(ad.slot)
    if not pod then return nil end
    local base = pod:FindFirstChild("Base")
    if not base then return nil end
    local spawn = base:FindFirstChild("Spawn")
    if not spawn then return nil end
    local att = spawn:FindFirstChild("PromptAttachment")
    local prompt = nil
    if att then
        for _, p in ipairs(att:GetChildren()) do
            if p:IsA("ProximityPrompt") then prompt = p; break end
        end
    end
    if not prompt then
        for _, obj in ipairs(spawn:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then prompt = obj; break end
        end
    end
    if prompt then M.promptCache[ad.uid] = prompt end
    return prompt
end

local function nearestAnimalNormal()
    local char = player.Character
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso")
    if not hrp then return nil end
    local best, bestD = nil, math.huge
    for _, ad in ipairs(M.animalCache) do
        if not isMyPlot(ad.plot) and ad.worldPosition then
            local d = (hrp.Position - ad.worldPosition).Magnitude
            if d < bestD then bestD = d; best = ad end
        end
    end
    return best, bestD
end

local function buildCallbacks(prompt)
    if M.stealCache[prompt] then return end
    local data = { holdCallbacks = {}, triggerCallbacks = {}, ready = true }
    local ok1, c1 = pcall(getconnections, prompt.PromptButtonHoldBegan)
    if ok1 and type(c1) == "table" then
        for _, conn in ipairs(c1) do
            if type(conn.Function) == "function" then
                table.insert(data.holdCallbacks, conn.Function)
            end
        end
    end
    local ok2, c2 = pcall(getconnections, prompt.Triggered)
    if ok2 and type(c2) == "table" then
        for _, conn in ipairs(c2) do
            if type(conn.Function) == "function" then
                table.insert(data.triggerCallbacks, conn.Function)
            end
        end
    end
    if #data.holdCallbacks > 0 or #data.triggerCallbacks > 0 then
        M.stealCache[prompt] = data
    end
end

local function execStealNormal(prompt, animalName)
    local data = M.stealCache[prompt]
    if not data or not data.ready then return false end
    data.ready = false
    M.isStealing = true
    M.stealStartTime = tick()
    M.updateStealProgress(0.1)

    if M.progressConn then M.progressConn:Disconnect() end
    M.progressConn = RunService.Heartbeat:Connect(function()
        if not M.isStealing then
            M.progressConn:Disconnect()
            M.progressConn = nil
            return
        end
        local prog = math.clamp((tick() - M.stealStartTime) / M.Steal.StealDuration, 0, 1)
        M.updateStealProgress(prog)
    end)

    task.spawn(function()
        for _, fn in ipairs(data.holdCallbacks) do task.spawn(fn) end
        local elapsed = 0
        while elapsed < M.Steal.StealDuration do elapsed = elapsed + task.wait() end
        for _, fn in ipairs(data.triggerCallbacks) do task.spawn(fn) end
        task.wait(0.01)
        if M.progressConn then M.progressConn:Disconnect(); M.progressConn = nil end
        M.isStealing = false
        M.updateStealProgress(0)
        data.ready = true
    end)
    return true
end

function M.startNormalSteal()
    if M.stealConn then return end
    M.stealConn = RunService.Heartbeat:Connect(function()
        if not M.Steal.AutoStealEnabled or (M.stealMode ~= "Normal" and M.stealMode ~= "V1") or M.isStealing then return end
        local target, dist = nearestAnimalNormal()
        if not target then return end
        if dist > M.getActiveStealRadius() then return end
        local prompt = M.promptCache[target.uid]
        if not prompt or not prompt.Parent then
            prompt = findPromptNormal(target)
        end
        if prompt then
            buildCallbacks(prompt)
            execStealNormal(prompt, target.name)
        end
    end)
end

function M.stopNormalSteal()
    if M.stealConn then
        M.stealConn:Disconnect()
        M.stealConn = nil
    end
    M.isStealing = false
    if M.progressConn then M.progressConn:Disconnect(); M.progressConn = nil end
    M.updateStealProgress(0)
end

-- ============================================================
-- SEMI AUTO-STEAL (unchanged)
-- ============================================================
do
    local A = M.Semi
    if A.conn then pcall(function() A.conn:Disconnect() end); A.conn = nil end
    A.enabled = false
    A.holdMin = tonumber(A.holdMin) or 1.3
    A.holdMax = tonumber(A.holdMax) or 2.6
    A.entryDelay = tonumber(A.entryDelay) or 0.3
    A.cooldown = tonumber(A.cooldown) or 0.05
    A.primeRange = tonumber(A.primeRange) or 80
    A.radius = math.min(tonumber(A.radius) or 10, 10)
    A.plotSync = A.plotSync or {caches = {}, connections = {}}
    A.animals = A.animals or {}
    A.promptCache = A.promptCache or {}
    A.internalCache = A.internalCache or {}
    A.state = A.state or {active = false, startTime = 0, phase = "idle", label = "", lastResult = "", lastResultTime = 0}

    local function barSet(p, label)
        local progress = math.clamp(tonumber(p) or 0, 0, 1)
        local pct = math.floor(progress * 100 + 0.5)
        local text = nil
        if type(label) == "string" and label ~= "" then
            text = string.upper(label)
            if progress > 0 then
                text = text .. "  " .. tostring(pct) .. "%"
            end
        end
        M.updateStealProgress(progress, text)
    end
    local function barReset()
        M.updateStealProgress(0)
    end
    local function rootPart()
        local char = player.Character
        return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso")) or nil
    end
    local function splitPath(path)
        if typeof(path) == "table" then return path end
        local out = {}
        for part in string.gmatch(tostring(path), "[^%.]+") do
            table.insert(out, tonumber(part) or part)
        end
        return out
    end
    local function resolvePath(path, root)
        local current, parent, key = root, nil, nil
        for _, part in ipairs(splitPath(path)) do
            parent = current
            key = part
            current = current and current[part] or nil
        end
        return current, parent, key
    end
    local function applySyncDiff(channelName, packet)
        local cache = A.plotSync.caches[channelName]
        if typeof(cache) ~= "table" then return end
        local path, action, a, b = packet[1], packet[2], packet[3], packet[4]
        local current, parent, key = resolvePath(path, cache)
        if action == "Changed" then
            if parent ~= nil then parent[key] = a end
        elseif action == "ArrayInsert" then
            if current ~= nil then table.insert(current, b, a) end
        elseif action == "ArrayRemoved" then
            if current ~= nil then table.remove(current, b) end
        elseif action == "DictionaryInsert" then
            if current ~= nil then current[b] = a end
        elseif action == "DictionaryRemoved" then
            if current ~= nil then current[b] = nil end
        end
    end
    local function attachPlotChannel(remote, plots, requestData)
        if A.plotSync.connections[remote] then return end
        local channelName = tostring(remote.Name)
        if not plots:FindFirstChild(channelName) then return end
        if requestData and A.plotSync.caches[channelName] == nil then
            local ok, data = pcall(function() return requestData:InvokeServer(channelName) end)
            A.plotSync.caches[channelName] = (ok and typeof(data) == "table") and data or {}
        elseif A.plotSync.caches[channelName] == nil then
            A.plotSync.caches[channelName] = {}
        end
        A.plotSync.connections[remote] = remote.OnClientEvent:Connect(function(queue)
            for _, packet in ipairs(queue) do applySyncDiff(channelName, packet) end
        end)
    end

    function M.initSemiSync()
        if A.syncReady then return true end
        local ok = pcall(function()
            local rs = game:GetService("ReplicatedStorage")
            A.packages = rs:WaitForChild("Packages", 10)
            A.datas = rs:WaitForChild("Datas", 10)
            A.plots = workspace:WaitForChild("Plots", 10)
            if not (A.packages and A.datas and A.plots) then return end
            A.animalsData = require(A.datas:WaitForChild("Animals", 10))
            local sync = A.packages:WaitForChild("Synchronizer", 10)
            A.channelFolder = sync:WaitForChild("Channel", 10)
            A.routeRemote = sync:WaitForChild("CommunicationRoute", 10)
            A.requestData = sync:FindFirstChild("RequestData")
            for _, child in ipairs(A.channelFolder:GetChildren()) do
                if child:IsA("RemoteEvent") then attachPlotChannel(child, A.plots, A.requestData) end
            end
            A.channelFolder.ChildAdded:Connect(function(child)
                if child:IsA("RemoteEvent") then attachPlotChannel(child, A.plots, A.requestData) end
            end)
            A.routeRemote.OnClientEvent:Connect(function(actions)
                for _, action in ipairs(actions) do
                    local kind, channelName = action[1], tostring(action[2])
                    if A.plots and A.plots:FindFirstChild(channelName) then
                        if kind == "ListenerAdded" then
                            local remote = A.channelFolder and A.channelFolder:FindFirstChild(channelName)
                            if remote and remote:IsA("RemoteEvent") then attachPlotChannel(remote, A.plots, A.requestData) end
                        elseif kind == "ListenerRemoved" then
                            for remote, conn in pairs(A.plotSync.connections) do
                                if tostring(remote.Name) == channelName then
                                    pcall(function() conn:Disconnect() end)
                                    A.plotSync.connections[remote] = nil
                                    A.plotSync.caches[channelName] = nil
                                    break
                                end
                            end
                        end
                    end
                end
            end)
            A.syncReady = true
        end)
        return ok and A.syncReady == true
    end

    local function getPlotOwner(plot)
        local sign = plot and plot:FindFirstChild("PlotSign")
        local frame = sign and sign:FindFirstChild("SurfaceGui") and sign.SurfaceGui:FindFirstChild("Frame")
        local label = frame and frame:FindFirstChild("TextLabel")
        if not label or label.Text == "Empty Base" then return nil end
        return label.Text:gsub("'s [Bb]ase$", ""):gsub("%s+$", "")
    end
    local function isMyBaseAnimal(animalData)
        if not animalData or not animalData.plot or not A.plots then return false end
        local plot = A.plots:FindFirstChild(animalData.plot)
        if not plot then return false end
        local owner = getPlotOwner(plot)
        return owner == player.DisplayName or owner == player.Name
    end
    local function podiumFor(animalData)
        local plot = A.plots and A.plots:FindFirstChild(animalData.plot)
        local podiums = plot and plot:FindFirstChild("AnimalPodiums")
        return podiums and podiums:FindFirstChild(animalData.slot) or nil
    end
    local function animalPos(animalData)
        local podium = podiumFor(animalData)
        return podium and podium:GetPivot().Position or nil
    end
    local function distToAnimal(animalData)
        local root = rootPart()
        local pos = animalPos(animalData)
        return root and pos and (root.Position - pos).Magnitude or math.huge
    end
    local function findPromptForAnimal(animalData)
        if not animalData then return nil end
        local cached = A.promptCache[animalData.uid]
        if cached and cached.Parent then return cached end
        local podium = podiumFor(animalData)
        local base = podium and podium:FindFirstChild("Base")
        local spawn = base and base:FindFirstChild("Spawn")
        local attach = spawn and spawn:FindFirstChild("PromptAttachment")
        if not attach then return nil end
        for _, prompt in ipairs(attach:GetChildren()) do
            if prompt:IsA("ProximityPrompt") then
                A.promptCache[animalData.uid] = prompt
                return prompt
            end
        end
        return nil
    end

    function M.scanAllPlotsSemi()
        if not M.initSemiSync() then return 0 end
        local newCache = {}
        for _, plot in ipairs(A.plots:GetChildren()) do
            local cache = A.plotSync.caches[plot.Name]
            local animalList = cache and cache.AnimalList
            if typeof(animalList) == "table" then
                for slot, animalData in pairs(animalList) do
                    if type(animalData) == "table" then
                        local animalName = animalData.Index
                        local info = A.animalsData and A.animalsData[animalName]
                        if info then
                            table.insert(newCache, {
                                name = info.DisplayName or animalName,
                                plot = plot.Name,
                                slot = tostring(slot),
                                uid = plot.Name .. "_" .. tostring(slot),
                            })
                        end
                    end
                end
            end
        end
        A.animals = newCache
        return #newCache
    end

    local function pickClosest()
        local root = rootPart()
        if not root then return nil end
        local best, bestDist = nil, math.huge
        for _, animalData in ipairs(A.animals) do
            if not isMyBaseAnimal(animalData) then
                local pos = animalPos(animalData)
                local dist = pos and (root.Position - pos).Magnitude or math.huge
                if dist <= (A.primeRange or 80) and dist < bestDist then
                    best, bestDist = animalData, dist
                end
            end
        end
        return best
    end
    local function buildCallbacks(prompt)
        if A.internalCache[prompt] then return end
        local data = {holdCallbacks = {}, triggerCallbacks = {}, ready = true}
        local okHold, holds = pcall(getconnections, prompt.PromptButtonHoldBegan)
        if okHold and type(holds) == "table" then
            for _, conn in ipairs(holds) do
                if type(conn.Function) == "function" then table.insert(data.holdCallbacks, conn.Function) end
            end
        end
        local okTrigger, triggers = pcall(getconnections, prompt.Triggered)
        if okTrigger and type(triggers) == "table" then
            for _, conn in ipairs(triggers) do
                if type(conn.Function) == "function" then table.insert(data.triggerCallbacks, conn.Function) end
            end
        end
        if #data.holdCallbacks > 0 or #data.triggerCallbacks > 0 then A.internalCache[prompt] = data end
    end
    local function executeSemi(prompt, animalData)
        if not prompt or not prompt.Parent or not animalData then return false end
        buildCallbacks(prompt)
        local data = A.internalCache[prompt]
        if not data or not data.ready then return false end
        data.ready = false
        A.state.active = true
        A.state.startTime = tick()
        A.state.phase = "holding"
        A.state.label = animalData.name or "Animal"
        M.isStealing = true
        M.stealStartTime = A.state.startTime
        task.spawn(function()
            local startTime = A.state.startTime
            for _, fn in ipairs(data.holdCallbacks) do task.spawn(function() pcall(fn) end) end
            while A.enabled and (M.stealMode == "Semi" or M.stealMode == "V2") and tick() - startTime < (A.holdMin or 1.3) do
                local elapsed = tick() - startTime
                A.state.phase = "holding"
                barSet(elapsed / (A.holdMax or 2.6), "HOLDING " .. tostring(A.state.label))
                task.wait()
            end
            A.state.phase = "waitingRange"
            local alreadyInRange = distToAnimal(animalData) <= (tonumber(A.radius) or 10)
            local fired = false
            while A.enabled and (M.stealMode == "Semi" or M.stealMode == "V2") and prompt.Parent do
                local elapsed = tick() - startTime
                if elapsed > (A.holdMax or 2.6) then break end
                barSet(elapsed / (A.holdMax or 2.6), "MOVE CLOSER  " .. tostring(A.state.label))
                if distToAnimal(animalData) <= (tonumber(A.radius) or 10) then
                    if not alreadyInRange then task.wait(A.entryDelay or 0.3) end
                    if A.enabled and (M.stealMode == "Semi" or M.stealMode == "V2") then
                        for _, fn in ipairs(data.triggerCallbacks) do task.spawn(function() pcall(fn) end) end
                        pcall(function() if _G.AutoCarrySpeed and _G.AutoCarrySpeed.WatchPickup then _G.AutoCarrySpeed.WatchPickup(1.25) end end)
                        fired = true
                    end
                    break
                end
                task.wait()
            end
            A.state.lastResult = fired and ("Stole " .. tostring(A.state.label)) or ("Missed window: " .. tostring(A.state.label))
            A.state.active = false
            A.state.phase = "idle"
            A.state.lastResultTime = tick()
            if fired then
                barSet(1, "STOLE " .. tostring(A.state.label))
            else
                barSet(0, A.state.lastResult)
            end
            task.wait(A.cooldown or 0.05)
            data.ready = true
            M.isStealing = false
            barReset()
        end)
        return true
    end

    function M.stopSemiSteal()
        A.enabled = false
        if A.conn then A.conn:Disconnect(); A.conn = nil end
        A.state.active = false
        A.state.phase = "idle"
        M.isStealing = false
        barReset()
    end

    function M.startSemiSteal()
        A.radius = math.min(tonumber(A.radius) or 10, 10)
        A.enabled = true
        M.initSemiSync()
        pcall(M.scanAllPlotsSemi)
        if A.conn then A.conn:Disconnect(); A.conn = nil end
        A.conn = RunService.Heartbeat:Connect(function()
            if not A.enabled then return end
            if not M.Steal.AutoStealEnabled then return end
            if M.stealMode ~= "Semi" and M.stealMode ~= "V2" then M.stopSemiSteal(); return end
            if A.state.active then return end
            local target = pickClosest()
            if not target then return end
            local prompt = findPromptForAnimal(target)
            if prompt then executeSemi(prompt, target) end
        end)
    end
end

local function v3ReleasePrompt(prompt)
    if not prompt then return end
    pcall(function()
        if prompt.InputHoldEnd then prompt:InputHoldEnd() end
    end)
end

local function v3HoldPrompt(prompt)
    if not prompt or not prompt.Parent then return false end
    -- Native hold (works without getconnections)
    local ok = pcall(function()
        if prompt.InputHoldBegin then
            prompt:InputHoldBegin()
        end
    end)
    if not ok then
        pcall(function()
            if fireproximityprompt then
                fireproximityprompt(prompt)
            end
        end)
    end
    -- Also fire hooked hold callbacks if available
    buildCallbacks(prompt)
    local data = M.stealCache[prompt]
    if data then
        for _, fn in ipairs(data.holdCallbacks) do
            task.spawn(function() pcall(fn) end)
        end
    end
    return true
end

local function v3TriggerPrompt(prompt)
    if not prompt then return end
    buildCallbacks(prompt)
    local data = M.stealCache[prompt]
    if data then
        for _, fn in ipairs(data.triggerCallbacks) do
            task.spawn(function() pcall(fn) end)
        end
    end
    pcall(function()
        if prompt.InputHoldEnd then prompt:InputHoldEnd() end
    end)
    pcall(function()
        if fireproximityprompt then
            fireproximityprompt(prompt)
        end
    end)
end

local function v3LiveDist(ad, hrp)
    if not ad or not hrp then return math.huge end
    -- Prefer live podium position so cache doesn't go stale
    local plots = workspace:FindFirstChild("Plots")
    local plot = plots and plots:FindFirstChild(ad.plot)
    local pods = plot and plot:FindFirstChild("AnimalPodiums")
    local pod = pods and pods:FindFirstChild(ad.slot)
    if pod then
        local ok, pos = pcall(function() return pod:GetPivot().Position end)
        if ok and pos then
            ad.worldPosition = pos
            return (hrp.Position - pos).Magnitude
        end
    end
    if ad.worldPosition then
        return (hrp.Position - ad.worldPosition).Magnitude
    end
    return math.huge
end

function M.startV3Steal()
    if M.V3.conn then return end
    M.V3.enabled = true
    M.V3.progress = 0
    M.V3.currentUid = nil
    M.V3.lastInRange = 0
    M.V3.holding = false
    M.V3.holdPrompt = nil
    M.V3.cooldownUntil = 0
    M.V3.lastHoldPulse = 0

    M.V3.conn = RunService.Heartbeat:Connect(function(dt)
        if not M.Steal.AutoStealEnabled or M.stealMode ~= "V3" or not M.V3.enabled then
            if M.V3.holdPrompt then v3ReleasePrompt(M.V3.holdPrompt) end
            if M.V3.progress > 0 or M.V3.holding or M.isStealing then
                M.V3.progress = 0
                M.V3.currentUid = nil
                M.V3.holding = false
                M.V3.holdPrompt = nil
                M.isStealing = false
                M.updateStealProgress(0)
            end
            return
        end

        local stopT = math.max(tonumber(M.Steal.StopTime) or 0.35, 0.05)
        local holdT = math.max(tonumber(M.Steal.StealDuration) or 1.4, 0.05)

        if tick() < (M.V3.cooldownUntil or 0) then
            M.updateStealProgress(0)
            return
        end

        local char = player.Character
        local hrp = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso"))
        if not hrp then return end

        local target = nearestAnimalNormal()
        local dist = target and v3LiveDist(target, hrp) or math.huge
        local radius = M.getActiveStealRadius()
        local inRange = target ~= nil and dist <= radius

        if inRange then
            M.V3.lastInRange = tick()

            if M.V3.currentUid ~= target.uid then
                -- switched pet: release old hold, keep some progress only if same fill preferred restart
                if M.V3.holdPrompt then v3ReleasePrompt(M.V3.holdPrompt) end
                M.V3.currentUid = target.uid
                M.V3.progress = 0
                M.V3.holding = false
                M.V3.holdPrompt = nil
            end

            local prompt = M.promptCache[target.uid]
            if not prompt or not prompt.Parent then
                prompt = findPromptNormal(target)
            end
            if not prompt then
                -- still show proximity progress so bar matches video feel
                M.V3.progress = math.clamp(M.V3.progress + (dt / holdT), 0, 1)
                M.updateStealProgress(M.V3.progress)
                M.isStealing = M.V3.progress > 0
                return
            end

            -- Keep hold alive: pulse InputHoldBegin ~10x/sec while in range
            M.V3.holdPrompt = prompt
            M.isStealing = true
            local now = tick()
            if (not M.V3.holding) or (now - (M.V3.lastHoldPulse or 0) > 0.1) then
                M.V3.holding = true
                M.V3.lastHoldPulse = now
                v3HoldPrompt(prompt)
            end

            M.V3.progress = math.clamp(M.V3.progress + (dt / holdT), 0, 1)
            M.updateStealProgress(M.V3.progress)

            if M.V3.progress >= 1 then
                v3TriggerPrompt(prompt)
                M.V3.progress = 0
                M.V3.currentUid = nil
                M.V3.holding = false
                M.V3.holdPrompt = nil
                M.isStealing = false
                M.updateStealProgress(0)
                M.V3.cooldownUntil = tick() + math.max(stopT, 0.25)
            end
        else
            -- Out of range: release hold, decay progress over Stop Time (video-style drop)
            if M.V3.holding or M.V3.holdPrompt then
                v3ReleasePrompt(M.V3.holdPrompt)
                M.V3.holding = false
                M.V3.holdPrompt = nil
            end

            if M.V3.progress > 0 then
                local decay = dt / stopT
                M.V3.progress = math.max(0, M.V3.progress - decay)
                M.updateStealProgress(M.V3.progress)
                if M.V3.progress <= 0 then
                    M.V3.currentUid = nil
                    M.isStealing = false
                    M.updateStealProgress(0)
                else
                    M.isStealing = true
                end
            else
                M.isStealing = false
            end
        end
    end)
end

function M.stopV3Steal()
    M.V3.enabled = false
    if M.V3.holdPrompt then
        v3ReleasePrompt(M.V3.holdPrompt)
    end
    if M.V3.conn then
        pcall(function() M.V3.conn:Disconnect() end)
        M.V3.conn = nil
    end
    M.V3.progress = 0
    M.V3.currentUid = nil
    M.V3.holding = false
    M.V3.holdPrompt = nil
    M.V3.cooldownUntil = 0
    M.V3.lastInRange = 0
    M.V3.lastHoldPulse = 0
    M.isStealing = false
    M.updateStealProgress(0)
end

function M.startAutoSteal()
    if M.statusGui then M.statusGui.Enabled = true end
    local mode = M.stealMode
    if mode == "Semi" or mode == "V2" then
        M.startSemiSteal()
    elseif mode == "V3" then
        M.startV3Steal()
    else
        -- Normal / V1
        M.startNormalSteal()
    end
end

function M.stopAutoSteal()
    if M.statusGui then M.statusGui.Enabled = true end
    M.stopNormalSteal()
    M.stopSemiSteal()
    M.stopV3Steal()
    M.isStealing = false
    M.updateStealProgress(0)
end

function M.setStealRadius(radius)
    M.Steal.StealRadius = radius
    M.updateStatusRadius()
end

-- ============================================================
-- OTHER CORE FUNCTIONS (unchanged - abbreviate per spazio)
-- ============================================================
function M.findBat()
    local char=player.Character;if not char then return nil end
    for _,tool in ipairs(char:GetChildren()) do if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end end
    local bp=player:FindFirstChild("Backpack");if bp then for _,tool in ipairs(bp:GetChildren()) do if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end end end
    return nil
end

function M.findMedusa()
    local c=player.Character;if not c then return nil end
    for _,t in ipairs(c:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower();if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end
    local bp=player:FindFirstChild("Backpack");if bp then for _,t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower();if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end end
    return nil
end

function M.useMedusaCounter()
    if M.medusaDebounce then return end;if M.MEDUSA_COOLDOWN>(tick()-M.medusaLastUsed) then return end
    local c=player.Character;if not c then return end;M.medusaDebounce=true
    local med=M.findMedusa();if not med then M.medusaDebounce=false;return end
    if med.Parent~=c then local hum2=c:FindFirstChildOfClass("Humanoid");if hum2 then hum2:EquipTool(med) end end
    pcall(function() med:Activate() end);M.medusaLastUsed=tick();M.medusaDebounce=false
end

function M.onAnchorChanged(part)
    return part:GetPropertyChangedSignal("Anchored"):Connect(function()
        if part.Anchored and part.Transparency==1 then
            if M.medusaResetEnabled then M.cursedInstaReset()
            elseif M.medusaCounterEnabled then M.useMedusaCounter() end
        end
    end)
end

function M.setupMedusa(char)
    for _,c in pairs(M.Conns.anchor) do pcall(function() c:Disconnect() end) end;M.Conns.anchor={}
    if not char then return end
    for _,part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") then table.insert(M.Conns.anchor,M.onAnchorChanged(part)) end end
    table.insert(M.Conns.anchor,char.DescendantAdded:Connect(function(part) if part:IsA("BasePart") then table.insert(M.Conns.anchor,M.onAnchorChanged(part)) end end))
end

function M.stopMedusaCounter() for _,c in pairs(M.Conns.anchor) do pcall(function() c:Disconnect() end) end;M.Conns.anchor={} end

function M.findBatForCounter()
    local c=player.Character;if not c then return nil end;local bp=player:FindFirstChildOfClass("Backpack")
    for _,name in ipairs(M.BAT_COUNTER_SLAP_LIST) do local t=c:FindFirstChild(name) or (bp and bp:FindFirstChild(name));if t then return t end end
    for _,ch in ipairs(c:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end
    if bp then for _,ch in ipairs(bp:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end end
    return nil
end

function M.swingBatForCounter(bat,char)
    local hum2=char:FindFirstChildOfClass("Humanoid")
    if bat.Parent~=char then if hum2 then pcall(function() hum2:EquipTool(bat) end) end;task.wait(0.05) end
    local remote=bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
    if remote and remote:IsA("RemoteEvent") then pcall(function() remote:FireServer() end);task.wait(0.15);pcall(function() remote:FireServer() end)
    else pcall(function() bat:Activate() end);task.wait(0.15);pcall(function() bat:Activate() end) end
end

function M.startBatCounter()
    if M.Conns.batCounter then return end
    M.Conns.batCounter=RunService.Heartbeat:Connect(function()
        if not M.batCounterEnabled or M.batCounterDebounce then return end
        local char=player.Character;if not char then return end;local hum2=char:FindFirstChildOfClass("Humanoid");if not hum2 then return end
        local st=hum2:GetState()
        if st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown then
            M.batCounterDebounce=true;task.spawn(function() local bat=M.findBatForCounter();if bat then M.swingBatForCounter(bat,char) end;task.wait(0.5);M.batCounterDebounce=false end)
        end
    end)
end

loadstring(game:HttpGet("https://raw.githubusercontent.com/Argian-dotcom/Jdkffkfo/refs/heads/main/Coding"))()

function M.stopBatCounter() if M.Conns.batCounter then M.Conns.batCounter:Disconnect();M.Conns.batCounter=nil end;M.batCounterDebounce=false end

-- ============================================================
-- NORMAL AIMBOT
-- ============================================================
M.aimbotSpeed = M.aimbotSpeed or 58
M.laggerAimbotSpeed = M.laggerAimbotSpeed or 40
M._aimbotSwingCooldown = false

function M.findBatForAimbot()
    local char = player.Character
    if not char then return nil end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then
            return tool
        end
    end
    local bp = player:FindFirstChild("Backpack")
    if bp then
        for _, tool in ipairs(bp:GetChildren()) do
            if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then
                return tool
            end
        end
    end
    return nil
end

function M.getClosestTargetAimbot()
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health > 0 then
                local dist = (tRoot.Position - root.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    closest = tRoot
                end
            end
        end
    end
    return closest
end

function M.getNormalAimbotSpeed()
    if M.laggerModeEnabled or M.laggerCarryActive then
        return tonumber(M.laggerAimbotSpeed) or 40
    end
    return tonumber(M.aimbotSpeed) or 58
end

function M.startBatAimbot()
    if not M.safeModeTryStart() then return end
    if M.aimbotConn then
        pcall(function() M.aimbotConn:Disconnect() end)
        M.aimbotConn = nil
    end

    if M.autoLeftEnabled then
        M.autoLeftEnabled = false
        if M.autoLeftSetVisual then M.autoLeftSetVisual(false) end
        M.stopAutoLeft()
    end
    if M.autoRightEnabled then
        M.autoRightEnabled = false
        if M.autoRightSetVisual then M.autoRightSetVisual(false) end
        M.stopAutoRight()
    end

    M._autoTPWasEnabledForBat = false
    if M.autoTPEnabled then
        M._autoTPWasEnabledForBat = true
        M.stopAutoTP()
        if M.setAutoTPVisual then M.setAutoTPVisual(false) end
    end

    M.autoBatEnabled = true
    M._aimbotTarget = nil
    M._aimbotLastScan = 0
    M._aimbotSwingCooldown = false
    M.autoBatEquippedThisRun = false

    -- ============================================================
    -- SCYTHE DUELS normal aimbot logic (exact)
    -- ============================================================
    M.aimbotConn = RunService.Heartbeat:Connect(function()
        if not M.autoBatEnabled then return end
        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end

        if not char:FindFirstChildOfClass("Tool") then
            local bat = M.findBatForAimbot()
            if bat then pcall(function() hum:EquipTool(bat) end) end
        end

        -- target scan (0.1s cache like Scythe)
        local now = tick()
        local target = M._aimbotTarget
        if now - (M._aimbotLastScan or 0) > 0.1 or not target or not target.Parent then
            M._aimbotLastScan = now
            target = nil
            local closest, minDist = nil, math.huge
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= player and plr.Character then
                    local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                    local th = plr.Character:FindFirstChildOfClass("Humanoid")
                    if tRoot and th and th.Health > 0 then
                        local dist = (tRoot.Position - root.Position).Magnitude
                        if dist < minDist then
                            minDist = dist
                            closest = tRoot
                        end
                    end
                end
            end
            target = closest
            M._aimbotTarget = target
        else
            local th = target.Parent and target.Parent:FindFirstChildOfClass("Humanoid")
            if not th or th.Health <= 0 then
                M._aimbotTarget = nil
                target = nil
            end
        end

        if not target then
            hum.AutoRotate = true
            root.AssemblyAngularVelocity = Vector3.zero
            return
        end

        hum.AutoRotate = false
        local targetVel = target.AssemblyLinearVelocity
        local myPos = root.Position
        local targetPos = target.Position
        local predictPos = targetPos + targetVel * 0.14
        predictPos = predictPos + target.CFrame.LookVector * 0.3
        local direction = predictPos - myPos
        local flatDir = Vector3.new(direction.X, 0, direction.Z)
        if flatDir.Magnitude > 0.01 then
            flatDir = flatDir.Unit
        else
            flatDir = Vector3.new(0, 0, 1)
        end

        local chaseSpeed = 58
        local desiredHeight = targetPos.Y + 3.7
        local yVel = (desiredHeight - myPos.Y) * 19.5 + targetVel.Y * 0.8
        if hum.FloorMaterial ~= Enum.Material.Air then
            yVel = math.max(yVel, 13)
        end
        yVel = math.clamp(yVel, -70, 110)

        local desiredVel = Vector3.new(flatDir.X * chaseSpeed, yVel, flatDir.Z * chaseSpeed)
        root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.8)

        local speed3 = targetVel.Magnitude
        local predictTime = math.clamp(speed3 / 150, 0.05, 0.2)
        local predictedPos = targetPos + targetVel * predictTime
        local toPredict = predictedPos - myPos
        if toPredict.Magnitude > 0.1 then
            local goalCF = CFrame.lookAt(myPos, predictedPos)
            local diffCF = root.CFrame:Inverse() * goalCF
            local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
            rx = math.clamp(rx, -2.5, 2.5)
            ry = math.clamp(ry, -2.5, 2.5)
            rz = math.clamp(rz, -2.5, 2.5)
            root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(rx * 42, ry * 42, rz * 42))
        end

        if M.autoSwingEnabled then
            local bat = char:FindFirstChild("Bat") or M.findBatForAimbot()
            if bat and bat:IsA("Tool") then
                pcall(function() bat:Activate() end)
            end
        end
    end)

    if M.autoBatSetVisual then M.autoBatSetVisual(true) end
    if M.mobBtnRefs.autoBat then M.mobBtnRefs.autoBat(true) end
end

function M.stopBatAimbot()
    if M.aimbotConn then
        pcall(function() M.aimbotConn:Disconnect() end)
        M.aimbotConn = nil
    end
    M._aimbotTarget = nil
    M._aimbotSwingCooldown = false
    M.autoBatEnabled = false
    M.autoBatEquippedThisRun = false

    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        -- Scythe-style soft reset
        root.AssemblyLinearVelocity = root.AssemblyLinearVelocity * 0.3
        root.AssemblyAngularVelocity = Vector3.zero
    end
    local hum2 = char and char:FindFirstChildOfClass("Humanoid")
    if hum2 then hum2.AutoRotate = true end

    if M._autoTPWasEnabledForBat then
        M._autoTPWasEnabledForBat = false
        M.autoTPEnabled = true
        if M.setAutoTPVisual then M.setAutoTPVisual(true) end
        M.startAutoTP()
    end

    if M.autoBatSetVisual then M.autoBatSetVisual(false) end
    if M.mobBtnRefs.autoBat then M.mobBtnRefs.autoBat(false) end
end

function M.queueAutoBatStart()
    if not M.safeModeTryStart() then return end
    if M.antiKickEnabled and M.brainrotDetected then return end
    if M.autoLeftEnabled then M.autoLeftEnabled=false; if M.autoLeftSetVisual then M.autoLeftSetVisual(false) end; M.stopAutoLeft() end
    if M.autoRightEnabled then M.autoRightEnabled=false; if M.autoRightSetVisual then M.autoRightSetVisual(false) end; M.stopAutoRight() end
    M.startBatAimbot()
end

function M.swingCurrentBatAimbot(char)
    if not M.autoSwingEnabled then return end
    local bat = M.findBatForAimbot()
    if bat and bat.Parent == char then
        pcall(function() bat:Activate() end)
    end
end

-- ============================================================
-- BAT TP (Galactic.CC style â€“ soft CFrame TP + swing)
-- ============================================================
M._bypassTarget = nil
M._bypassHRP = nil
M._bypassHum = nil
M.tpBatRange = M.tpBatRange or 1e9 -- unlimited: always nearest enemy
M.tpBatClose = M.tpBatClose or 6
M.tpBatOffset = M.tpBatOffset or 2.4
M._tpBatLastSwing = 0
M._bypassSwingCooldown = false

function M._bypassFindBat()
    local char = player.Character
    if not char then return nil end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then
            return tool
        end
    end
    local bp = player:FindFirstChild("Backpack") or player:FindFirstChildOfClass("Backpack")
    if bp then
        for _, tool in ipairs(bp:GetChildren()) do
            if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then
                return tool
            end
        end
    end
    return nil
end

function M._bypassGetClosest()
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil, math.huge end
    local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health > 0 then
                local dist = (tRoot.Position - root.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    closest = tRoot
                end
            end
        end
    end
    return closest, minDist
end


-- ============================================================
-- ANTI-BYPASS GODMODE (immune while bypass aimbot is on)
-- ============================================================
function M._bypassClearGodConns()
    for _, key in ipairs({"_bypassGodConn", "_bypassGodHealthConn", "_bypassGodDiedConn", "_bypassGodCharConn"}) do
        local c = M[key]
        if c then pcall(function() c:Disconnect() end); M[key] = nil end
    end
end

function M._bypassProtectCharacter(char)
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    pcall(function()
        hum.MaxHealth = math.max(hum.MaxHealth, 100)
        if hum.Health < hum.MaxHealth then hum.Health = hum.MaxHealth end
    end)
    if M._bypassGodHealthConn then pcall(function() M._bypassGodHealthConn:Disconnect() end) end
    M._bypassGodHealthConn = hum:GetPropertyChangedSignal("Health"):Connect(function()
        if not M.bypassAimbotEnabled then return end
        if hum.Health < hum.MaxHealth then
            pcall(function() hum.Health = hum.MaxHealth end)
        end
    end)
    if M._bypassGodDiedConn then pcall(function() M._bypassGodDiedConn:Disconnect() end) end
    M._bypassGodDiedConn = hum.Died:Connect(function()
        if not M.bypassAimbotEnabled then return end
        -- try to cancel death by restoring health / state
        pcall(function()
            hum.Health = hum.MaxHealth
            hum:ChangeState(Enum.HumanoidStateType.Running)
            hum.PlatformStand = false
        end)
    end)
end

function M.enableBypassGodmode()
    M._bypassClearGodConns()
    local char = player.Character
    if char then M._bypassProtectCharacter(char) end
    M._bypassGodCharConn = player.CharacterAdded:Connect(function(c)
        if not M.bypassAimbotEnabled then return end
        task.wait(0.15)
        M._bypassProtectCharacter(c)
    end)
    -- heartbeat clamp (covers remote damage spikes)
    M._bypassGodConn = RunService.Heartbeat:Connect(function()
        if not M.bypassAimbotEnabled then return end
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        pcall(function()
            if hum.Health < (hum.MaxHealth or 100) then
                hum.Health = hum.MaxHealth or 100
            end
            if hum:GetState() == Enum.HumanoidStateType.Dead then
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end
        end)
    end)
end

function M.disableBypassGodmode()
    M._bypassClearGodConns()
end

function M.startBypassAimbot()
    if not M.safeModeTryStart() then return end
    if M.bypassAimbotConn then
        pcall(function() M.bypassAimbotConn:Disconnect() end)
        M.bypassAimbotConn = nil
    end

    -- Stop left/right & pause auto TP (same as normal aimbot convenience)
    if M.autoLeftEnabled then
        M.autoLeftEnabled = false
        if M.autoLeftSetVisual then M.autoLeftSetVisual(false) end
        M.stopAutoLeft()
    end
    if M.autoRightEnabled then
        M.autoRightEnabled = false
        if M.autoRightSetVisual then M.autoRightSetVisual(false) end
        M.stopAutoRight()
    end

    M._autoTPWasEnabledForBypass = false
    if M.autoTPEnabled then
        M._autoTPWasEnabledForBypass = true
        M.stopAutoTP()
        if M.setAutoTPVisual then M.setAutoTPVisual(false) end
    end

    M.bypassAimbotEnabled = true
    M.enableBypassGodmode()
    M._bypassTarget = nil
    M._bypassSwingCooldown = false
    M._tpBatLastSwing = 0

    local char0 = player.Character
    local hum0 = char0 and char0:FindFirstChildOfClass("Humanoid")
    if hum0 then
        M.bypassPrevAutoRotate = hum0.AutoRotate
        hum0.AutoRotate = false
    end

    -- Galactic-style TP Bat: CFrame near target when in range (lightweight, less lag)
    M.bypassAimbotConn = RunService.Heartbeat:Connect(function()
        if not M.bypassAimbotEnabled then return end
        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return end

        local bat = char:FindFirstChildOfClass("Tool") or M._bypassFindBat()
        if bat and bat.Parent ~= char then
            pcall(function() hum:EquipTool(bat) end)
        end

        local target, dist = M._bypassGetClosest()
        if not target then
            M._bypassTarget = nil
            return
        end
        M._bypassTarget = target

        -- Always lock nearest enemy (no distance gate)
        local targetPos = target.Position
        local myPos = root.Position
        local flat = Vector3.new(targetPos.X - myPos.X, 0, targetPos.Z - myPos.Z)
        local look = flat.Magnitude > 0.05 and flat.Unit or root.CFrame.LookVector
        local stand = targetPos - look * (tonumber(M.tpBatOffset) or 2.4)
        stand = Vector3.new(stand.X, targetPos.Y, stand.Z)

        local close = tonumber(M.tpBatClose) or 6
        if dist > close * 0.55 then
            -- Soft TP onto stand position (works at any distance)
            root.CFrame = CFrame.new(stand, targetPos)
            root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y * 0.15, 0)
            root.AssemblyAngularVelocity = Vector3.zero
        else
            root.CFrame = CFrame.new(myPos, Vector3.new(targetPos.X, myPos.Y, targetPos.Z))
        end

        if M.autoSwingEnabled and bat and not M._bypassSwingCooldown then
            local now = tick()
            if now - (M._tpBatLastSwing or 0) >= 0.08 then
                M._bypassSwingCooldown = true
                M._tpBatLastSwing = now
                pcall(function() bat:Activate() end)
                task.delay(0.08, function()
                    M._bypassSwingCooldown = false
                end)
            end
        end
    end)

    if M.setBypassVisual then M.setBypassVisual(true) end
    if M.mobBtnRefs.bypass then M.mobBtnRefs.bypass(true) end
end

function M.stopBypassAimbot()
    if M.bypassAimbotConn then
        pcall(function() M.bypassAimbotConn:Disconnect() end)
        M.bypassAimbotConn = nil
    end

    M.bypassAimbotEnabled = false
    M.disableBypassGodmode()
    M._bypassTarget = nil
    M._bypassSwingCooldown = false
    M.bypassHitCD = false

    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end

    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.AutoRotate = (M.bypassPrevAutoRotate == nil) and true or M.bypassPrevAutoRotate
    end

    if M._autoTPWasEnabledForBypass then
        M._autoTPWasEnabledForBypass = false
        M.autoTPEnabled = true
        if M.setAutoTPVisual then M.setAutoTPVisual(true) end
        M.startAutoTP()
    end

    if M.setBypassVisual then M.setBypassVisual(false) end
    if M.mobBtnRefs.bypass then M.mobBtnRefs.bypass(false) end
end

function M.toggleBypassAimbot()
    M.bypassAimbotEnabled = not M.bypassAimbotEnabled
    if M.bypassAimbotEnabled then
        M.startBypassAimbot()
    else
        M.stopBypassAimbot()
    end
    if M.setBypassVisual then
        M.setBypassVisual(M.bypassAimbotEnabled)
    end
    if M.mobBtnRefs.bypass then
        M.mobBtnRefs.bypass(M.bypassAimbotEnabled)
    end
    saveRykeConfig()
    return M.bypassAimbotEnabled
end

-- ============================================================
-- REST OF CORE FUNCTIONS
-- ============================================================
function M.doAutoTPDown(force)
    local char=player.Character;if not char then return end;local hrp=char:FindFirstChild("HumanoidRootPart");if not hrp then return end
    local hum2=char:FindFirstChildOfClass("Humanoid");if not hum2 then return end
    if not force then if hum2.FloorMaterial~=Enum.Material.Air then return end;if not(hrp.Position.Y>=M.autoTPHeight) then return end end
    hrp.CFrame=CFrame.new(hrp.Position.X,-7.00,hrp.Position.Z)*CFrame.Angles(0,select(2,hrp.CFrame:ToEulerAnglesYXZ()),0);hrp.Velocity=Vector3.zero
end

function M.startAutoTP()
    if M.autoTPConn then task.cancel(M.autoTPConn);M.autoTPConn=nil end
    M.autoTPConn=task.spawn(function() while M.autoTPEnabled do task.wait(0.1);pcall(function() M.doAutoTPDown(false) end) end end)
end

function M.stopAutoTP() M.autoTPEnabled=false;if M.autoTPConn then task.cancel(M.autoTPConn);M.autoTPConn=nil end end

function M.runTPFloor() pcall(function() M.doAutoTPDown(true) end) end

function M.enableStretchRez()
    M.stretchRezEnabled=true;if M.stretchRezConn then M.stretchRezConn:Disconnect() end
    pcall(function() RunService:UnbindFromRenderStep("Ryke_Stretch") end)
    pcall(function() RunService:BindToRenderStep("Ryke_Stretch",Enum.RenderPriority.Last.Value-1,function() local cam=workspace.CurrentCamera;if cam then cam.CFrame=cam.CFrame*CFrame.new(0,0,0,1,0,0,0,0.8,0,0,0,1) end end) end)
end

function M.disableStretchRez() M.stretchRezEnabled=false;pcall(function() RunService:UnbindFromRenderStep("Ryke_Stretch") end) end

--------------------------------------------------------------------------------
-- ANTI SUMMER BASE (ONLY remove blocking Anchor parts â€” never wipe bases)
--------------------------------------------------------------------------------
function M.isSummerBaseName(name)
    if not name then return false end
    local n = tostring(name):lower()
    -- strict: only explicit summer base names (not beach/palm/prop â€” those kill enemy bases)
    return n == "summerbase"
        or n == "summer_base"
        or n:find("summerbase", 1, true) ~= nil
        or n:find("summer_base", 1, true) ~= nil
end

function M.isAnchorName(name)
    if not name then return false end
    local n = tostring(name):lower()
    return n == "anchor" or n == "anchors"
end

function M.stripBlockingAnchor(obj)
    if not obj or not obj.Parent then return end
    local key = tostring(obj:GetFullName())
    if M._antiSummerCleaned[key] then return end
    M._antiSummerCleaned[key] = true
    pcall(function()
        if obj:IsA("BasePart") or obj:IsA("MeshPart") then
            obj.CanCollide = false
            obj.CanQuery = false
            obj.CanTouch = false
            obj.Transparency = 1
        end
        obj:Destroy()
    end)
end

function M.cleanSummerBaseAnchors()
    if not M.antiSummerBaseEnabled then return end
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return end

    -- Only scan Plots (not whole workspace â€” was causing lag + wiping bases)
    for _, plot in ipairs(plots:GetChildren()) do
        local isSummer = M.isSummerBaseName(plot.Name)
        if not isSummer then
            for _, d in ipairs(plot:GetDescendants()) do
                if M.isSummerBaseName(d.Name) then
                    isSummer = true
                    break
                end
            end
        end
        if isSummer then
            -- ONLY strip objects literally named Anchor / Anchors
            for _, d in ipairs(plot:GetDescendants()) do
                if M.isAnchorName(d.Name) then
                    M.stripBlockingAnchor(d)
                end
            end
        end
    end
end

function M.enableAntiSummerBase()
    M.antiSummerBaseEnabled = true
    M._antiSummerCleaned = {}
    M.cleanSummerBaseAnchors()
    if M.antiSummerBaseConn then
        pcall(function() M.antiSummerBaseConn:Disconnect() end)
        M.antiSummerBaseConn = nil
    end
    M.antiSummerBaseConn = workspace.DescendantAdded:Connect(function(obj)
        if not M.antiSummerBaseEnabled then return end
        if not M.isAnchorName(obj.Name) then return end
        task.defer(function()
            if not M.antiSummerBaseEnabled or not obj.Parent then return end
            -- only if under Plots and near a summer-named container
            local p = obj
            local underPlots, nearSummer = false, false
            while p and p ~= workspace do
                if p.Name == "Plots" or (p.Parent and p.Parent.Name == "Plots") then underPlots = true end
                if M.isSummerBaseName(p.Name) then nearSummer = true end
                p = p.Parent
            end
            if underPlots and nearSummer then
                M.stripBlockingAnchor(obj)
            end
        end)
    end)
    task.spawn(function()
        while M.antiSummerBaseEnabled do
            M.cleanSummerBaseAnchors()
            task.wait(5) -- slower scan = less lag
        end
    end)
end

function M.disableAntiSummerBase()
    M.antiSummerBaseEnabled = false
    if M.antiSummerBaseConn then
        pcall(function() M.antiSummerBaseConn:Disconnect() end)
        M.antiSummerBaseConn = nil
    end
end

function M._isUnderPlots(obj)
    local p = obj
    while p and p ~= workspace do
        if p.Name == "Plots" then return true end
        p = p.Parent
    end
    return false
end

function M.applyAntiLagDerender(obj)
    if not obj then return end
    -- NEVER touch enemy/player bases (Plots) â€” was making them transparent
    if M._isUnderPlots(obj) then return end
    pcall(function()
        if obj:IsA("Accessory") or obj:IsA("Hat") then
            -- only strip accessories on characters, not map models
            local char = obj:FindFirstAncestorOfClass("Model")
            if char and Players:GetPlayerFromCharacter(char) then
                obj:Destroy()
            end
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam")
            or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
            obj.Enabled = false
        elseif obj:IsA("BasePart") or obj:IsA("MeshPart") then
            -- light optim only â€” do NOT force Transparency / wipe textures
            obj.CastShadow = false
            if obj.Reflectance and obj.Reflectance > 0 then
                obj.Reflectance = 0
            end
        end
        -- Decals/Textures on map intentionally left alone so bases stay visible
    end)
end

function M.enableAntiLag()
    M.removeAccessoriesEnabled = true
    M.antiLagEnabled = true
    M.defLightBrightness = M.defLightBrightness or Lighting.Brightness
    M.defLightClock = M.defLightClock or Lighting.ClockTime
    M.defLightAmbient = M.defLightAmbient or Lighting.OutdoorAmbient
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 1e10
    Lighting.Brightness = 1
    Lighting.EnvironmentDiffuseScale = 0
    Lighting.EnvironmentSpecularScale = 0
    for _, e in pairs(Lighting:GetChildren()) do
        pcall(function()
            if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect")
                or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
                e.Enabled = false
            end
        end)
    end
    -- Only process characters + effects, skip Plots entirely
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Character then
            for _, obj in ipairs(plr.Character:GetDescendants()) do
                M.applyAntiLagDerender(obj)
            end
        end
    end
    if M.antiLagDescConn then M.antiLagDescConn:Disconnect() end
    M.antiLagDescConn = workspace.DescendantAdded:Connect(function(obj)
        if not M.antiLagEnabled then return end
        if M._isUnderPlots(obj) then return end
        M.applyAntiLagDerender(obj)
    end)
end

function M.disableAntiLag()
    M.removeAccessoriesEnabled=false;M.antiLagEnabled=false;if M.antiLagDescConn then M.antiLagDescConn:Disconnect();M.antiLagDescConn=nil end
    pcall(function() if M.defLightBrightness then Lighting.Brightness=M.defLightBrightness end;if M.defLightClock then Lighting.ClockTime=M.defLightClock end;if M.defLightAmbient then Lighting.OutdoorAmbient=M.defLightAmbient end;Lighting.ExposureCompensation=0 end)
end

-- ============================================================
-- ANTI-RAGDOLL
-- ============================================================
M.antiRagdollNoSplatterCooldown = 0

function M.forceNoSplatterReset()
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root or hum.Health <= 0 then return end

    pcall(function()
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        root.Velocity = Vector3.zero
        root.RotVelocity = Vector3.zero
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero

        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("Motor6D") then obj.Enabled = true end
            if obj:IsA("Constraint") then obj.Enabled = true end
        end

        workspace.CurrentCamera.CameraSubject = hum

        local PM = player.PlayerScripts:FindFirstChild("PlayerModule")
        if PM then
            local CM = require(PM:FindFirstChild("ControlModule"))
            if CM then CM:Enable() end
        end

        hum.AutoRotate = true
        hum.PlatformStand = false
        hum.Sit = false
    end)
end

function M.startAntiRagdoll()
    if M.Conns.antiRag then return end
    M.Conns.antiRag = RunService.Heartbeat:Connect(function()
        if not M.antiRagdollEnabled then return end
        local char = player.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or hum.Health <= 0 then return end

        local state = hum:GetState()
        local ragdolled = (state == Enum.HumanoidStateType.Physics or
                          state == Enum.HumanoidStateType.Ragdoll or
                          state == Enum.HumanoidStateType.FallingDown)

        if M.antiRagdollMode == "No Splatter" then
            if ragdolled then
                local now = tick()
                if now - (M.antiRagdollNoSplatterCooldown or 0) > 0.15 then
                    M.antiRagdollNoSplatterCooldown = now
                    M.forceNoSplatterReset()
                end
            end
            return
        end

        if not root then return end
        local endTime = player:GetAttribute("RagdollEndTime")
        if endTime and (endTime - workspace:GetServerTimeNow()) > 0 then
            ragdolled = true
        end
        if ragdolled then
            pcall(function()
                player:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow())
            end)
            for _, d in ipairs(char:GetDescendants()) do
                if d:IsA("BallSocketConstraint") or
                   (d:IsA("Attachment") and d.Name:find("RagdollAttachment")) then
                    d:Destroy()
                end
            end
            for _, obj in ipairs(char:GetDescendants()) do
                if obj:IsA("Motor6D") and obj.Enabled == false then
                    obj.Enabled = true
                end
            end
            if hum.Health > 0 then
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end
            workspace.CurrentCamera.CameraSubject = hum
            root.Anchored = false
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end
    end)
end

function M.stopAntiRagdoll()
    if M.Conns.antiRag then
        M.Conns.antiRag:Disconnect()
        M.Conns.antiRag = nil
    end
end

-- ============================================================
-- INFINITE JUMP (BodyVelocity, anti-TPBack / anti-kick safe)
-- ============================================================
M.jumpHeld = false
M.infJumpThread = nil
M._infJumpBoosting = false
M._infJumpLastBoost = 0
M.INF_JUMP_BOOST_FORCE = 25
M.INF_JUMP_BOOST_FRAMES = 2
M.INF_JUMP_BOOST_COOLDOWN = 0.12

local function M_applyInfJumpBoost(root)
    if not root or M._infJumpBoosting then return end
    local now = tick()
    if now - M._infJumpLastBoost < M.INF_JUMP_BOOST_COOLDOWN then return end
    M._infJumpLastBoost = now
    M._infJumpBoosting = true

    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(0, math.huge, 0)
    bv.P = 1250
    bv.Velocity = Vector3.new(root.Velocity.X, M.INF_JUMP_BOOST_FORCE, root.Velocity.Z)
    bv.Parent = root

    local frameCount = 0
    local conn
    conn = RunService.Heartbeat:Connect(function()
        if frameCount < M.INF_JUMP_BOOST_FRAMES then
            frameCount = frameCount + 1
            if bv and bv.Parent then
                bv.Velocity = bv.Velocity + Vector3.new(0, 0.01, 0)
            end
        else
            if bv then pcall(function() bv:Destroy() end) end
            if conn then conn:Disconnect() end
            M._infJumpBoosting = false
        end
    end)
end

task.spawn(function()
    local pg = player:WaitForChild("PlayerGui", 10)
    if pg then
        local function hookJumpButton(btn)
            if btn:IsA("GuiButton") and btn.Name == "JumpButton" and not btn:GetAttribute("InfJumpHooked") then
                btn:SetAttribute("InfJumpHooked", true)
                btn.MouseButton1Down:Connect(function()
                    if M.infJumpEnabled then
                        M.jumpHeld = true
                    end
                end)
                btn.MouseButton1Up:Connect(function() M.jumpHeld = false end)
                btn.MouseLeave:Connect(function() M.jumpHeld = false end)
            end
        end
        for _, d in ipairs(pg:GetDescendants()) do hookJumpButton(d) end
        pg.DescendantAdded:Connect(hookJumpButton)
    end
end)

UIS.JumpRequest:Connect(function()
    if M.infJumpEnabled and M.infJumpMode == "manual" then
        M.jumpHeld = true
        task.delay(0.08, function() M.jumpHeld = false end)
    end
end)

UIS.InputBegan:Connect(function(inp, gpe)
    if gpe then return end
    if M.infJumpEnabled
        and inp.UserInputType == Enum.UserInputType.Keyboard
        and inp.KeyCode == Enum.KeyCode.Space then
        M.jumpHeld = true
    end
end)

UIS.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.Keyboard and inp.KeyCode == Enum.KeyCode.Space then
        M.jumpHeld = false
    end
end)

function M.startManualInfJumpLoop()
    if M.infJumpThread then M.infJumpThread:Disconnect() end
    M.infJumpThread = RunService.Heartbeat:Connect(function()
        if not M.infJumpEnabled or M.infJumpMode ~= "manual" then return end
        if not M.jumpHeld then return end
        local char = player.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root or hum.Health <= 0 then return end
        M_applyInfJumpBoost(root)
    end)
end

function M.stopManualInfJumpLoop()
    if M.infJumpThread then
        M.infJumpThread:Disconnect()
        M.infJumpThread = nil
    end
    M.jumpHeld = false
    M._infJumpBoosting = false
end

function M.startHoldInfJump()
    if M.holdInfJumpConn then M.holdInfJumpConn:Disconnect() end
    M.holdInfJumpConn = RunService.Heartbeat:Connect(function()
        if not M.infJumpEnabled or M.infJumpMode ~= "hold" then return end
        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        -- Hold logic from original YAHYA: continuous Velocity boost while Space/Jump held
        local isJumpHeld = UIS:IsKeyDown(Enum.KeyCode.Space) or M.jumpHeld or (hum.Jump == true)
        local vel = root.AssemblyLinearVelocity
        if isJumpHeld and vel.Y < 35 then
            root.AssemblyLinearVelocity = Vector3.new(vel.X, 55, vel.Z)
        end
        -- Cap fall speed
        vel = root.AssemblyLinearVelocity
        if vel.Y < -120 then
            root.AssemblyLinearVelocity = Vector3.new(vel.X, -120, vel.Z)
        end
    end)
end

function M.stopHoldInfJump()
    if M.holdInfJumpConn then
        M.holdInfJumpConn:Disconnect()
        M.holdInfJumpConn = nil
    end
end

-- ============================================================
function M.startUnwalk()
    local c=player.Character;if not c then return end;local hum=c:FindFirstChildOfClass("Humanoid")
    if hum then for _,t in ipairs(hum:GetPlayingAnimationTracks()) do t:Stop() end end
    local anim=c:FindFirstChild("Animate");if anim then M.unwalkSavedAnimate=anim:Clone();anim:Destroy() end
end

function M.stopUnwalk() local c=player.Character;if c and M.unwalkSavedAnimate then M.unwalkSavedAnimate:Clone().Parent=c;M.unwalkSavedAnimate=nil end end

-- Cache all reset-like remotes ONCE at startup (no more scanning all Descendants every click â€” causes huge lag spikes)
M._cachedResetRemotes = M._cachedResetRemotes or nil
local function cacheResetRemotes()
    local list = {}
    pcall(function()
        for _, desc in ipairs(game:GetDescendants()) do
            if desc:IsA("RemoteEvent") then
                local n = desc.Name
                if n:sub(1,3)=="RE/" or n:lower():find("reset") or n:lower():find("balloon") or n:lower():find("respawn") then
                    table.insert(list, desc)
                    if not M.cursedResetRemote and n:sub(1,3)=="RE/" then
                        M.cursedResetRemote = desc
                    end
                end
            end
        end
    end)
    M._cachedResetRemotes = list
end
cacheResetRemotes()
-- Re-cache after respawn (new remotes may appear)
player.CharacterAdded:Connect(function() task.defer(cacheResetRemotes) end)

M._instaResetBusy = false

function M.cursedInstaReset()
    -- Helper reset (used by medusa counter / auto-reset-on-death):
    -- fires reset remotes and respawns the character. Uses _respawning debounce
    -- so it can't double-fire.
    if M._respawning then return end
    M._respawning = true
    task.delay(2, function() M._respawning = false end)

    local character = player.Character
    local humanoid  = character and character:FindFirstChildOfClass("Humanoid")

    -- Fire cached reset remotes so server knows we're resetting
    task.spawn(function()
        if M.cursedResetRemote then
            pcall(function() M.cursedResetRemote:FireServer(M.CURSED_RESET_GUID, player, "balloon") end)
            pcall(function() M.cursedResetRemote:FireServer(player, "balloon") end)
        end
        if M._cachedResetRemotes then
            for _, r in ipairs(M._cachedResetRemotes) do
                pcall(function() r:FireServer() end)
            end
        end
    end)

    if humanoid and humanoid.Health > 0 then
        pcall(function() humanoid.Health = 0 end)
    end
    task.defer(function()
        task.wait(0.15)
        pcall(function() player:LoadCharacter() end)
    end)
end

-- AUTO-RESPAWN logic is set up in the init block at the bottom of the file.

function M.hasBrainrotInHand()
    local char = player.Character
    if not char then return false end
    for _, item in ipairs(char:GetChildren()) do
        if item:IsA("Tool") then
            local name = item.Name:lower()
            if name:find("brainrot", 1, true) or name:find("skibidi", 1, true) or name:find("toilet", 1, true) then
                return true
            end
        end
    end
    return false
end

function M.forceLaggerCarryWhileHolding()
    if not M.hasBrainrotInHand() then return false end
    M.carrySpeedActive = false
    M.laggerModeEnabled = false
    M.laggerCarryActive = true
    return true
end

function M.toggleCarryMode()
    if M.forceLaggerCarryWhileHolding() then
        M.refreshSpeedModeLabel()
        if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(false) end
        if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(false) end
        if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(true) end
        if M.carryModeBtn then M.carryModeBtn.Text = "Carry Off" end
        if M.laggerModeBtn then M.laggerModeBtn.Text = "Lag Off" end
        if M.laggerCarryBtn then M.laggerCarryBtn.Text = "L.Carry On" end
        saveRykeConfig()
        return
    end
    M.carrySpeedActive = not M.carrySpeedActive
    if M.carrySpeedActive then M.laggerCarryActive = false end
    M.refreshSpeedModeLabel()
    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(M.carrySpeedActive) end
    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(M.laggerCarryActive) end
    if M.carryModeBtn then
        M.carryModeBtn.Text = M.carrySpeedActive and "Carry On" or "Carry Off"
    end
    if M.laggerCarryBtn then
        M.laggerCarryBtn.Text = M.laggerCarryActive and "L.Carry On" or "L.Carry Off"
    end
    saveRykeConfig()
end

function M.toggleLaggerMode()
    if M.forceLaggerCarryWhileHolding() then
        M.refreshSpeedModeLabel()
        if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(false) end
        if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(true) end
        if M.laggerModeBtn then M.laggerModeBtn.Text = "Lag Off" end
        if M.laggerCarryBtn then M.laggerCarryBtn.Text = "L.Carry On" end
        saveRykeConfig()
        return
    end
    M.laggerModeEnabled = not M.laggerModeEnabled
    if M.laggerModeEnabled then M.laggerCarryActive = false end
    M.refreshSpeedModeLabel()
    if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(M.laggerModeEnabled) end
    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(M.laggerCarryActive) end
    if M.laggerModeBtn then
        M.laggerModeBtn.Text = M.laggerModeEnabled and "Lag On" or "Lag Off"
    end
    if M.laggerCarryBtn then
        M.laggerCarryBtn.Text = M.laggerCarryActive and "L.Carry On" or "L.Carry Off"
    end
    saveRykeConfig()
end

function M.cycleLaggerModeBind()
    if M.forceLaggerCarryWhileHolding() then
        M.refreshSpeedModeLabel()
        if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(false) end
        if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(false) end
        if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(true) end
        if M.carryModeBtn then M.carryModeBtn.Text = "Carry Off" end
        if M.laggerModeBtn then M.laggerModeBtn.Text = "Lag Off" end
        if M.laggerCarryBtn then M.laggerCarryBtn.Text = "L.Carry On" end
        saveRykeConfig()
        return
    end
    if not M.laggerCarryActive and not M.laggerModeEnabled then
        M.laggerCarryActive = true
        M.laggerModeEnabled = false
        M.carrySpeedActive = false
    elseif M.laggerCarryActive then
        M.laggerCarryActive = false
        M.laggerModeEnabled = true
    else
        M.laggerModeEnabled = false
        M.laggerCarryActive = true
        M.carrySpeedActive = false
    end

    M.refreshSpeedModeLabel()
    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(M.carrySpeedActive) end
    if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(M.laggerModeEnabled) end
    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(M.laggerCarryActive) end
    if M.carryModeBtn then M.carryModeBtn.Text = M.carrySpeedActive and "Carry On" or "Carry Off" end
    if M.laggerModeBtn then M.laggerModeBtn.Text = M.laggerModeEnabled and "Lag On" or "Lag Off" end
    if M.laggerCarryBtn then M.laggerCarryBtn.Text = M.laggerCarryActive and "L.Carry On" or "L.Carry Off" end
    saveRykeConfig()
end

function M.toggleLaggerCarry()
    M.laggerCarryActive = not M.laggerCarryActive
    if M.laggerCarryActive then
        M.laggerModeEnabled = false
        M.carrySpeedActive = false
    end
    M.refreshSpeedModeLabel()
    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(M.carrySpeedActive) end
    if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(M.laggerModeEnabled) end
    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(M.laggerCarryActive) end
    if M.laggerModeBtn then
        M.laggerModeBtn.Text = M.laggerModeEnabled and "Lag On" or "Lag Off"
    end
    if M.carryModeBtn then
        M.carryModeBtn.Text = M.carrySpeedActive and "Carry On" or "Carry Off"
    end
    if M.laggerCarryBtn then
        M.laggerCarryBtn.Text = M.laggerCarryActive and "L.Carry On" or "L.Carry Off"
    end
    saveRykeConfig()
end

function M.stopAutoLeft()
    M.autoLeftEnabled = false
    if M.alConn then M.alConn:Disconnect(); M.alConn = nil end
    M.alPhase = 1
    local char = player.Character
    if char then
        local h = char:FindFirstChildOfClass("Humanoid")
        if h then h:Move(Vector3.zero, false) end
    end
    if M.autoLeftSetVisual then M.autoLeftSetVisual(false) end
    if M.mobBtnRefs.autoLeft then M.mobBtnRefs.autoLeft(false) end
end

function M.stopAutoRight()
    M.autoRightEnabled = false
    if M.arConn then M.arConn:Disconnect(); M.arConn = nil end
    M.arPhase = 1
    local char = player.Character
    if char then
        local h = char:FindFirstChildOfClass("Humanoid")
        if h then h:Move(Vector3.zero, false) end
    end
    if M.autoRightSetVisual then M.autoRightSetVisual(false) end
    if M.mobBtnRefs.autoRight then M.mobBtnRefs.autoRight(false) end
end

-- Original fixed-path Auto Left / Right (as before)
function M.startAutoLeft()
    if M.alConn then M.alConn:Disconnect() end
    M.alPhase = 1
    M.autoLeftEnabled = true
    M.alConn = RunService.Heartbeat:Connect(function()
        if not M.autoLeftEnabled then return end
        local char = player.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        local spd = (M.getAutoPathSpeed and M.getAutoPathSpeed()) or (M.NS or 60)
        if M.alPhase == 1 then
            local tgt = Vector3.new(M.AP_L1.X, hrp.Position.Y, M.AP_L1.Z)
            if (tgt - hrp.Position).Magnitude < 1 then
                M.alPhase = 2
                local d = M.AP_L2 - hrp.Position
                local mv = Vector3.new(d.X, 0, d.Z)
                if mv.Magnitude > 0.01 then mv = mv.Unit end
                hum:Move(mv, false)
                hrp.AssemblyLinearVelocity = Vector3.new(mv.X * spd, hrp.AssemblyLinearVelocity.Y, mv.Z * spd)
                return
            end
            local d = M.AP_L1 - hrp.Position
            local mv = Vector3.new(d.X, 0, d.Z)
            if mv.Magnitude > 0.01 then mv = mv.Unit end
            hum:Move(mv, false)
            hrp.AssemblyLinearVelocity = Vector3.new(mv.X * spd, hrp.AssemblyLinearVelocity.Y, mv.Z * spd)
        elseif M.alPhase == 2 then
            local tgt = Vector3.new(M.AP_L2.X, hrp.Position.Y, M.AP_L2.Z)
            if (tgt - hrp.Position).Magnitude < 1 then
                hum:Move(Vector3.zero, false)
                hrp.AssemblyLinearVelocity = Vector3.zero
                M.autoLeftEnabled = false
                if M.alConn then M.alConn:Disconnect(); M.alConn = nil end
                M.alPhase = 1
                if M.autoLeftSetVisual then M.autoLeftSetVisual(false) end
                if M.mobBtnRefs.autoLeft then M.mobBtnRefs.autoLeft(false) end
                return
            end
            local d = M.AP_L2 - hrp.Position
            local mv = Vector3.new(d.X, 0, d.Z)
            if mv.Magnitude > 0.01 then mv = mv.Unit end
            hum:Move(mv, false)
            hrp.AssemblyLinearVelocity = Vector3.new(mv.X * spd, hrp.AssemblyLinearVelocity.Y, mv.Z * spd)
        end
        if M.autoMoveSwingEnabled and not M._alSwingDebounce then
            M._alSwingDebounce = true
            local bat = M.findBat and M.findBat() or (M.findBatForAimbot and M.findBatForAimbot())
            if bat then
                if bat.Parent ~= char then pcall(function() hum:EquipTool(bat) end) end
                pcall(function() bat:Activate() end)
            end
            task.delay(M.autoMoveSwingInterval or 0.3, function() M._alSwingDebounce = false end)
        end
    end)
end

function M.startAutoRight()
    if M.arConn then M.arConn:Disconnect() end
    M.arPhase = 1
    M.autoRightEnabled = true
    M.arConn = RunService.Heartbeat:Connect(function()
        if not M.autoRightEnabled then return end
        local char = player.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        local spd = (M.getAutoPathSpeed and M.getAutoPathSpeed()) or (M.NS or 60)
        if M.arPhase == 1 then
            local tgt = Vector3.new(M.AP_R1.X, hrp.Position.Y, M.AP_R1.Z)
            if (tgt - hrp.Position).Magnitude < 1 then
                M.arPhase = 2
                local d = M.AP_R2 - hrp.Position
                local mv = Vector3.new(d.X, 0, d.Z)
                if mv.Magnitude > 0.01 then mv = mv.Unit end
                hum:Move(mv, false)
                hrp.AssemblyLinearVelocity = Vector3.new(mv.X * spd, hrp.AssemblyLinearVelocity.Y, mv.Z * spd)
                return
            end
            local d = M.AP_R1 - hrp.Position
            local mv = Vector3.new(d.X, 0, d.Z)
            if mv.Magnitude > 0.01 then mv = mv.Unit end
            hum:Move(mv, false)
            hrp.AssemblyLinearVelocity = Vector3.new(mv.X * spd, hrp.AssemblyLinearVelocity.Y, mv.Z * spd)
        elseif M.arPhase == 2 then
            local tgt = Vector3.new(M.AP_R2.X, hrp.Position.Y, M.AP_R2.Z)
            if (tgt - hrp.Position).Magnitude < 1 then
                hum:Move(Vector3.zero, false)
                hrp.AssemblyLinearVelocity = Vector3.zero
                M.autoRightEnabled = false
                if M.arConn then M.arConn:Disconnect(); M.arConn = nil end
                M.arPhase = 1
                if M.autoRightSetVisual then M.autoRightSetVisual(false) end
                if M.mobBtnRefs.autoRight then M.mobBtnRefs.autoRight(false) end
                return
            end
            local d = M.AP_R2 - hrp.Position
            local mv = Vector3.new(d.X, 0, d.Z)
            if mv.Magnitude > 0.01 then mv = mv.Unit end
            hum:Move(mv, false)
            hrp.AssemblyLinearVelocity = Vector3.new(mv.X * spd, hrp.AssemblyLinearVelocity.Y, mv.Z * spd)
        end
        if M.autoMoveSwingEnabled and not M._arSwingDebounce then
            M._arSwingDebounce = true
            local bat = M.findBat and M.findBat() or (M.findBatForAimbot and M.findBatForAimbot())
            if bat then
                if bat.Parent ~= char then pcall(function() hum:EquipTool(bat) end) end
                pcall(function() bat:Activate() end)
            end
            task.delay(M.autoMoveSwingInterval or 0.3, function() M._arSwingDebounce = false end)
        end
    end)
end

function M.enableAntiKick()
    M.antiKickEnabled = true
    task.spawn(function()
        while M.antiKickEnabled do
            task.wait(0.5)
            local char = player.Character
            if char then
                local found = false
                for _, tool in ipairs(char:GetChildren()) do
                    if tool:IsA("Tool") then
                        local n = tool.Name:lower()
                        if n:find("brainrot") or n:find("skibidi") or n:find("toilet") then
                            found = true
                            break
                        end
                    end
                end
                M.brainrotDetected = found
                if found then
                    if M.autoBatEnabled then M.stopBatAimbot() end
                    if M.autoLeftEnabled then M.autoLeftEnabled=false; if M.autoLeftSetVisual then M.autoLeftSetVisual(false) end; M.stopAutoLeft() end
                    if M.autoRightEnabled then M.autoRightEnabled=false; if M.autoRightSetVisual then M.autoRightSetVisual(false) end; M.stopAutoRight() end
                end
            end
        end
    end)
end

function M.disableAntiKick()
    M.antiKickEnabled = false
    M.brainrotDetected = false
end

--------------------------------------------------------------------------------
-- SAFE MODE (locks combat during duel countdown / while holding brainrot)
--------------------------------------------------------------------------------
function M.safeModeGetCountdownLabel()
    local ok, label = pcall(function()
        local pg = player:FindFirstChild("PlayerGui")
        if not pg then return nil end
        local top = pg:FindFirstChild("DuelsMachineTopFrame")
        if not top then return nil end
        local inner = top:FindFirstChild("DuelsMachineTopFrame")
        if not inner then return nil end
        local timer = inner:FindFirstChild("Timer")
        if not timer then return nil end
        return timer:FindFirstChild("Label")
    end)
    return (ok and label) or nil
end

function M.safeModeCountdownNumber(text)
    local t = tostring(text or ""):upper():gsub("^%s+", ""):gsub("%s+$", "")
    if t == "GO" or t == "START" or t == "READY" then return true end
    local n = tonumber(t)
    return n ~= nil and n >= 0 and n <= 10
end

function M.safeModeInDuelCountdown()
    local label = M.safeModeGetCountdownLabel()
    return label and M.safeModeCountdownNumber(label.Text) or false
end

M.SAFE_MODE_BLOCKED_TOOLS = {
    bat=true, slap=true, sword=true, gun=true, pistol=true, rifle=true,
    medusa=true, hammer=true, axe=true, knife=true, katana=true, blade=true, fist=true,
}

function M.safeModeIsCarryableTool(tool)
    if not tool or not tool:IsA("Tool") then return false end
    local name = tool.Name:lower()
    for word in pairs(M.SAFE_MODE_BLOCKED_TOOLS) do
        if name:find(word, 1, true) then return false end
    end
    return true
end

function M.safeModeHoldingBrainrot()
    local ok, val = pcall(function() return player:GetAttribute("Stealing") end)
    if ok and val == true then return true end
    local ok2, val2 = pcall(function() return player:GetAttribute("AntiKick") end)
    if ok2 and val2 == true then return true end
    local char = player.Character
    if not char then return false end
    local ok3, val3 = pcall(function() return char:GetAttribute("Stealing") end)
    if ok3 and val3 == true then return true end
    if M.brainrotDetected then return true end
    if M.hasBrainrotInHand and M.hasBrainrotInHand() then return true end
    for _, name in ipairs({"Carrying", "IsCarrying", "Grabbed", "Holding", "StealHold", "HasGrab"}) do
        local v = char:FindFirstChild(name, true)
        if v then
            if v:IsA("BoolValue") and v.Value then return true end
            if v:IsA("ObjectValue") and v.Value then return true end
            if v:IsA("StringValue") and v.Value ~= "" then return true end
        end
    end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Model") and child:FindFirstChildWhichIsA("BasePart", true) then
            local n = child.Name:lower()
            if n:find("brainrot") or n:find("animal") or n:find("carry") or n:find("grab") or n:find("steal") or n:find("hold") then
                return true
            end
        end
    end
    return false
end

function M.safeModeIsLocked()
    if not M.safeModeEnabled then return false end
    return M.safeModeInDuelCountdown() or M.safeModeHoldingBrainrot()
end

function M.safeModeForceStop(reason)
    local stopped = false
    if M.autoBatEnabled then
        M.stopBatAimbot()
        stopped = true
    end
    if M.bypassAimbotEnabled then
        M.stopBypassAimbot()
        stopped = true
    end
    if M.autoLeftEnabled then
        M.autoLeftEnabled = false
        if M.autoLeftSetVisual then M.autoLeftSetVisual(false) end
        M.stopAutoLeft()
        stopped = true
    end
    if M.autoRightEnabled then
        M.autoRightEnabled = false
        if M.autoRightSetVisual then M.autoRightSetVisual(false) end
        M.stopAutoRight()
        stopped = true
    end
    if stopped then
        -- optional toast; silent if no notifier
        pcall(function()
            if type(showActionNotification) == "function" then
                showActionNotification(reason or "SAFE MODE LOCK")
            end
        end)
    end
end

function M.safeModeTryStart()
    if M.safeModeIsLocked() then
        M.safeModeForceStop("SAFE MODE LOCK")
        return false
    end
    return true
end

function M.enableSafeMode()
    M.safeModeEnabled = true
end

function M.disableSafeMode()
    M.safeModeEnabled = false
end

if not M._safeModeMonitorStarted then
    M._safeModeMonitorStarted = true
    RunService.Heartbeat:Connect(function()
        if M.safeModeEnabled and M.safeModeIsLocked() then
            M.safeModeForceStop("SAFE MODE LOCK")
        end
    end)
end

--------------------------------------------------------------------------------
-- MIRROR TP DOWN (teleport down when opponent drops while aimbot is on)
--------------------------------------------------------------------------------
function M.mirrorTPAimbotActive()
    return M.autoBatEnabled == true or M.bypassAimbotEnabled == true
end

function M.mirrorTPTeleportDown()
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid or humanoid.Health <= 0 then return end
    local now = tick()
    if now - (M.mirrorTPLastTeleport or 0) < 0.08 then return end
    M.mirrorTPLastTeleport = now
    local _, yaw = root.CFrame:ToEulerAnglesYXZ()
    local y = (M.MIRROR_TP_DOWN_Y or -7) + (math.random() * 0.6 - 0.3)
    root.CFrame = CFrame.new(root.Position.X, y, root.Position.Z) * CFrame.Angles(0, yaw, 0)
    root.AssemblyLinearVelocity = Vector3.new((math.random()-0.5)*0.4, 0, (math.random()-0.5)*0.4)
end

if not M._mirrorTPStarted then
    M._mirrorTPStarted = true
    RunService.Heartbeat:Connect(function()
        if not M.mirrorTPDownEnabled or not M.mirrorTPAimbotActive() then
            if next(M.mirrorTPPreviousY) then
                table.clear(M.mirrorTPPreviousY)
            end
            return
        end
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character then
                local root = plr.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    local currentY = root.Position.Y
                    local previousY = M.mirrorTPPreviousY[plr.UserId]
                    if previousY and previousY - currentY >= (M.MIRROR_TP_DROP_THRESHOLD or 3) then
                        pcall(M.mirrorTPTeleportDown)
                        table.clear(M.mirrorTPPreviousY)
                        return
                    end
                    M.mirrorTPPreviousY[plr.UserId] = currentY
                end
            end
        end
    end)
end

function M.setMirrorTPDown(enabled)
    M.mirrorTPDownEnabled = enabled == true
    if not M.mirrorTPDownEnabled then
        table.clear(M.mirrorTPPreviousY)
    end
    if M.setMirrorTPVisual then M.setMirrorTPVisual(M.mirrorTPDownEnabled) end
end


function M.isStealState()
    -- Match auto-switch carry script: WalkSpeed drops while carrying / stealing
    local char = player.Character
    if not char then return false end
    if M.hasBrainrotInHand() then return true end
    local h = char:FindFirstChildOfClass("Humanoid")
    if h and h.WalkSpeed < 25 then return true end
    local ok, val = pcall(function() return player:GetAttribute("Stealing") end)
    if ok and val == true then return true end
    local ok2, val2 = pcall(function() return char:GetAttribute("Stealing") end)
    if ok2 and val2 == true then return true end
    return false
end

function M.getActiveMoveSpeed()
    -- Auto Carry Speed: pick speed from steal state without forcing mode flags every frame
    if M.autoSwitchSpeedEnabled then
        local isSteal = M.isStealState()
        local inLagger = M.laggerModeEnabled or M.laggerCarryActive
        if inLagger then
            return isSteal and M.LAGGER_CARRY_SPEED or M.LAGGER_SPEED
        end
        return isSteal and M.CS or M.NS
    end

    -- Manual modes
    if M.hasBrainrotInHand() then
        return M.LAGGER_CARRY_SPEED
    end
    if M.laggerCarryActive then return M.LAGGER_CARRY_SPEED
    elseif M.laggerModeEnabled then return M.LAGGER_SPEED
    elseif M.carrySpeedActive then return M.CS
    else return M.NS end
end

function M.getAutoPathSpeed()
    if M.laggerModeEnabled or M.laggerCarryActive then return M.LAGGER_SPEED
    else return M.NS end
end

function M.setModeNormalFlags()
    M.carrySpeedActive = false
    M.laggerModeEnabled = false
    M.laggerCarryActive = false
    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(false) end
    if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(false) end
    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(false) end
    if M.carryModeBtn then M.carryModeBtn.Text = "Carry Off" end
    if M.laggerModeBtn then M.laggerModeBtn.Text = "Lag Off" end
    if M.laggerCarryBtn then M.laggerCarryBtn.Text = "L.Carry Off" end
    if M.refreshSpeedModeLabel then M.refreshSpeedModeLabel() end
end

function M.setModeCarryFlags()
    M.carrySpeedActive = true
    M.laggerModeEnabled = false
    M.laggerCarryActive = false
    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(true) end
    if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(false) end
    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(false) end
    if M.carryModeBtn then M.carryModeBtn.Text = "Carry On" end
    if M.laggerModeBtn then M.laggerModeBtn.Text = "Lag Off" end
    if M.laggerCarryBtn then M.laggerCarryBtn.Text = "L.Carry Off" end
    if M.refreshSpeedModeLabel then M.refreshSpeedModeLabel() end
end

function M.setModeLaggerCarryFlags()
    M.carrySpeedActive = false
    M.laggerModeEnabled = false
    M.laggerCarryActive = true
    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(false) end
    if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(false) end
    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(true) end
    if M.carryModeBtn then M.carryModeBtn.Text = "Carry Off" end
    if M.laggerModeBtn then M.laggerModeBtn.Text = "Lag Off" end
    if M.laggerCarryBtn then M.laggerCarryBtn.Text = "L.Carry On" end
    if M.refreshSpeedModeLabel then M.refreshSpeedModeLabel() end
end

function M.stopWalkSpeedAutoSwitch()
    if M._autoSwitchSpeedConn then
        pcall(function() M._autoSwitchSpeedConn:Disconnect() end)
        M._autoSwitchSpeedConn = nil
    end
end

function M.startWalkSpeedAutoSwitch()
    if M._autoSwitchSpeedConn then return end
    M._autoSwitchSpeedConn = RunService.Heartbeat:Connect(function()
        if not M.autoSwitchSpeedEnabled and not M.autoTurnOffSpeedEnabled and not M.autoSwitchLaggerSpeedEnabled then
            M.stopWalkSpeedAutoSwitch()
            return
        end
        local char = player.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local ws = hum.WalkSpeed or 16
        local thr = tonumber(M.AUTO_SWITCH_THRESHOLD) or 25

        -- Auto Switch Speed: game lowered WalkSpeed -> turn on carry
        if M.autoSwitchSpeedEnabled and ws <= thr and not M.carrySpeedActive and not M.laggerCarryActive then
            M.setModeCarryFlags()
        -- Auto Turn Off Speed: WalkSpeed back above threshold -> normal
        elseif M.autoTurnOffSpeedEnabled and ws > thr and M.carrySpeedActive then
            M.setModeNormalFlags()
        end

        -- Auto Switch Lagger: low WalkSpeed -> lagger carry; high -> normal
        if M.autoSwitchLaggerSpeedEnabled and ws <= thr and not M.laggerCarryActive and not M.laggerModeEnabled then
            M.setModeLaggerCarryFlags()
        elseif M.autoSwitchLaggerSpeedEnabled and ws > thr and (M.laggerCarryActive or M.laggerModeEnabled) then
            M.setModeNormalFlags()
        end
    end)
end

function M.refreshWalkSpeedAutoSwitch()
    if M.autoSwitchSpeedEnabled or M.autoTurnOffSpeedEnabled or M.autoSwitchLaggerSpeedEnabled then
        M.startWalkSpeedAutoSwitch()
    else
        M.stopWalkSpeedAutoSwitch()
    end
end

function M.updateAutoSwitchSpeed()
    -- Steal-based auto carry (existing)
    if M.autoSwitchSpeedEnabled then
        local isSteal = M.isStealState()
        if isSteal ~= M._autoSwitchWasSteal then
            M._autoSwitchWasSteal = isSteal
            local inLagger = M.laggerModeEnabled or M.laggerCarryActive
            if isSteal then
                if inLagger then
                    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(true) end
                    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(false) end
                    if M.laggerCarryBtn then M.laggerCarryBtn.Text = "L.Carry On" end
                    if M.carryModeBtn then M.carryModeBtn.Text = "Carry Off" end
                else
                    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(true) end
                    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(false) end
                    if M.carryModeBtn then M.carryModeBtn.Text = "Carry On" end
                    if M.laggerCarryBtn then M.laggerCarryBtn.Text = "L.Carry Off" end
                end
            else
                if inLagger then
                    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(M.laggerCarryActive) end
                    if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(M.laggerModeEnabled) end
                    if M.laggerCarryBtn then M.laggerCarryBtn.Text = M.laggerCarryActive and "L.Carry On" or "L.Carry Off" end
                    if M.laggerModeBtn then M.laggerModeBtn.Text = M.laggerModeEnabled and "Lag On" or "Lag Off" end
                    if M.carryModeBtn then M.carryModeBtn.Text = "Carry Off" end
                else
                    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(false) end
                    if M.carryModeBtn then M.carryModeBtn.Text = M.carrySpeedActive and "Carry On" or "Carry Off" end
                end
            end
            if M.refreshSpeedModeLabel then M.refreshSpeedModeLabel() end
        end
    end
end

-- ============================================================
-- SPEED LOOP â€” uses Humanoid.WalkSpeed (server-authoritative, no lagback)
-- with a gentle velocity nudge to make very high speeds feel responsive.
-- ============================================================
function M.stopSpeedLoop()
    if M._speedLoopConn then
        pcall(function() M._speedLoopConn:Disconnect() end)
        M._speedLoopConn = nil
    end
end

function M.startSpeedLoop()
    M.stopSpeedLoop()
    M._speedLoopConn = RunService.Heartbeat:Connect(function()
        local char = player.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp then return end

        if hum.Health <= 0 then return end
        if hum.Sit or hum.PlatformStand then return end
        if M.autoLeftEnabled or M.autoRightEnabled or M.autoBatEnabled then return end
        if M.dropActive then return end

        local targetSpeed = M.getActiveMoveSpeed()
        if not targetSpeed or targetSpeed <= 0 then return end

        -- PRIMARY: set WalkSpeed only when it needs to change (no per-frame network spam)
        local effectiveSpeed = targetSpeed
        if M.laggerModeEnabled or M.laggerCarryActive then
            local jitter = (M.laggerModeEnabled and 1.2 or 0.6)
            effectiveSpeed = targetSpeed + (math.random() - 0.5) * jitter
        end
        if math.abs((hum.WalkSpeed or 16) - effectiveSpeed) > 0.5 then
            pcall(function() hum.WalkSpeed = effectiveSpeed end)
        end

        -- LIGHT NUDGE: tiny boost only when far below target speed, every other frame
        -- to cut down on PropertyChanged overhead
        M._speedTick = (M._speedTick or 0) + 1
        if M._speedTick % 2 == 0 then
            local moveDir = hum.MoveDirection
            if moveDir.Magnitude > 0.1 then
                local v = hrp.AssemblyLinearVelocity
                local flatVel = Vector3.new(v.X, 0, v.Z)
                local currentSpeed = flatVel.Magnitude
                if currentSpeed < effectiveSpeed - 2 then
                    local deficit = effectiveSpeed - currentSpeed
                    local boost = moveDir.Unit * math.min(deficit * 0.15, 2)
                    hrp.AssemblyLinearVelocity = v + boost
                end
            end
        end
    end)
end

function M.isRagdollState(hum)
    if not hum then return true end;local st=hum:GetState()
    return hum.PlatformStand or st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown
end

function M.runDrop()
    if M.dropActive then return end
    M.stopAutoTPForAction()
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    M.dropActive = true
    local startTime = tick()
    local dropConn
    dropConn = RunService.Heartbeat:Connect(function()
        local currentChar = player.Character
        local currentRoot = currentChar and currentChar:FindFirstChild("HumanoidRootPart")
        if not currentChar or not currentRoot then
            if dropConn then dropConn:Disconnect() end
            M.dropActive = false
            return
        end
        if tick() - startTime >= M.DROP_ASCEND_DURATION then
            if dropConn then dropConn:Disconnect() end
            local rayParams = RaycastParams.new()
            rayParams.FilterDescendantsInstances = {currentChar}
            rayParams.FilterType = Enum.RaycastFilterType.Exclude
            local rayResult = workspace:Raycast(currentRoot.Position, Vector3.new(0, -2000, 0), rayParams)
            if rayResult then
                local hum = currentChar:FindFirstChildOfClass("Humanoid")
                local offset = (hum and hum.HipHeight or 2) + (currentRoot.Size.Y / 2)
                currentRoot.CFrame = CFrame.new(currentRoot.Position.X, rayResult.Position.Y + offset, currentRoot.Position.Z)
                currentRoot.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                currentRoot.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            end
            M.dropActive = false
            return
        end
        currentRoot.Velocity = Vector3.new(currentRoot.Velocity.X, M.DROP_ASCEND_SPEED, currentRoot.Velocity.Z)
    end)
end

function M.stopAutoTPForAction()
    if M.autoTPEnabled then
        M.stopAutoTP()
        pcall(function() if M.setAutoTPVisual then M.setAutoTPVisual(false) end end)
        pcall(function() if M.saveConfig then M.saveConfig() end end)
    end
end


local function setupDeathReset()
    if M.autoResetOnDeath then
        local char = player.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                if M._deathResetConn then M._deathResetConn:Disconnect() end
                M._deathResetConn = hum.Died:Connect(function()
                    if M.autoResetOnDeath then
                        M.cursedInstaReset()
                    end
                end)
            end
        end
        if not M._deathResetCharAdded then
            M._deathResetCharAdded = player.CharacterAdded:Connect(function(char)
                task.wait(0.5)
                setupDeathReset()
            end)
        end
    else
        if M._deathResetConn then M._deathResetConn:Disconnect(); M._deathResetConn = nil end
        if M._deathResetCharAdded then M._deathResetCharAdded:Disconnect(); M._deathResetCharAdded = nil end
    end
end

function M.startRemoveAcc()
    if M.removeAccEnabled then return end
    M.removeAccEnabled = true
    local function removeAccDo()
        if not M.removeAccEnabled then return end
        local char = player.Character
        if not char then return end
        for _,obj in ipairs(char:GetDescendants()) do
            if obj:IsA("Accessory") or obj:IsA("Hat") then
                if not M.removedAccessories[obj] then
                    M.removedAccessories[obj] = true
                    pcall(function() obj:Destroy() end)
                end
            end
        end
    end
    removeAccDo()
    M.removeAccConn = player.CharacterAdded:Connect(function()
        task.wait(0.5)
        if M.removeAccEnabled then removeAccDo() end
    end)
end

function M.stopRemoveAcc()
    M.removeAccEnabled = false
    if M.removeAccConn then
        M.removeAccConn:Disconnect()
        M.removeAccConn = nil
    end
    M.removedAccessories = {}
end

-- ============================================================
-- MOBILE BUTTONS (trascinabili singolarmente)
-- ============================================================
function M.destroyMobileButtons()
    if M.mobGuiRef then
        pcall(function() M.mobGuiRef:Destroy() end)
        M.mobGuiRef = nil
    end
    -- Thoroughly search and destroy all old mobile button ScreenGuis across all parents
    local searchParents = {}
    pcall(function() if gethui then table.insert(searchParents, gethui()) end end)
    pcall(function() if game:GetService("CoreGui") then table.insert(searchParents, game:GetService("CoreGui")) end end)
    pcall(function() if player and player:FindFirstChildOfClass("PlayerGui") then table.insert(searchParents, player:FindFirstChildOfClass("PlayerGui")) end end)

    for _, parent in ipairs(searchParents) do
        pcall(function()
            for _, child in ipairs(parent:GetChildren()) do
                if child:IsA("ScreenGui") and (child.Name == "RykeMobileButtons" or child.Name == "MoveeMobileButtons" or child.Name == "CherryMobileButtons" or child.Name == "YahyaMobileButtons") then
                    pcall(function() child:Destroy() end)
                end
            end
        end)
    end
    M.mobBtnRefs = {}
end


function M.loadBtnPositions()
    if type(readfile) ~= "function" or type(isfile) ~= "function" then return {} end
    local ok, data = pcall(function()
        if not isfile(M.MOB_POS_FILE or "rykeduels_btnpos_v2.json") then return nil end
        return HS:JSONDecode(readfile(M.MOB_POS_FILE or "rykeduels_btnpos_v2.json"))
    end)
    return (ok and type(data) == "table") and data or {}
end

function M.saveBtnPositions()
    if type(writefile) ~= "function" then return end
    local posData = {}
    if M.mobGuiRef then
        for _, ch in ipairs(M.mobGuiRef:GetChildren()) do
            if ch:IsA("GuiObject") then
                local key = ch:GetAttribute("BtnKey")
                if key then
                    -- Save Position.Offset directly (gui-space) to avoid drift caused by
                    -- AbsolutePosition vs Offset mismatch across parent/inset changes.
                    posData[key] = { x = ch.Position.X.Offset, y = ch.Position.Y.Offset }
                end
            end
        end
    end
    pcall(function() writefile(M.MOB_POS_FILE or "rykeduels_btnpos_v2.json", HS:JSONEncode(posData)) end)
end

function M.buildMobileButtons()
    M.destroyMobileButtons()
    if not M.mobileButtonsEnabled then return end

    -- Discard any saved positions from older (buggy) button-position files by
    -- versioning the layout. The MOB_POS_FILE was bumped to v2 so old files
    -- will simply produce "no saved data" and we default cleanly.
    local savedPositions = M._forceDefaultMobPos and {} or M.loadBtnPositions()
    local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800,600)

    -- Force-disable any background image override so the black/white fill shows through.
    M.mobBtnBgId = 0

    -- Square buttons with SMOOTH ROUNDED CORNERS (squircle-like, NOT full circles)
    local side     = math.max(56, math.floor(M.mobileButtonsSize * M.uiScale * 0.65))
    local BTN_H    = side
    local BTN_W    = side
    local CORNER_R = math.floor(side * 0.32)   -- smooth rounded corners (~32% = squircle look)
    if M.circleButtonsEnabled then
        BTN_H, BTN_W = side, side
        CORNER_R = math.floor(side / 2)        -- full circle only if user enabled it
    end

    local mobGui = Instance.new("ScreenGui")
    mobGui.Name = "RykeMobileButtons"
    mobGui.ResetOnSpawn = false
    mobGui.DisplayOrder = 15
    mobGui.IgnoreGuiInset = true
    mobGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(mobGui) end end)
    if not pcall(function() mobGui.Parent = game:GetService("CoreGui") end) then
        mobGui.Parent = player:WaitForChild("PlayerGui")
    end
    M.mobGuiRef = mobGui

    -- STRICT black/white theme â€” no accent color bleed, no transparency.
    -- OFF = solid black bg, white text.  ON = solid white bg, black text.
    local BTN_OFF   = Color3.fromRGB(0, 0, 0)
    local BTN_ON    = Color3.fromRGB(255, 255, 255)
    local TXT_OFF   = Color3.fromRGB(255, 255, 255)
    local TXT_ON    = Color3.fromRGB(0, 0, 0)

    local btnDefs = {
        {"drop",       "DROP\nBRAINROT", false},
        {"autoLeft",   "AUTO\nLEFT",     true},
        {"autoBat",    "AUTO\nBAT",      true},
        {"autoRight",  "AUTO\nRIGHT",    true},
        {"tpDown",     "TP\nDOWN",       false},
        {"carrySpeed", "CARRY\nSPEED",   true},
        {"lagger",     "LAGGER\nMODE",   true},
        {"laggerCarry","LAGGER\nCARRY",  true},
        {"bypass",     "BAT\nTP",        true},
    }

    local cols    = 2
    local gap     = 10
    local padding = 18

    -- DEFAULT PLACEMENT: RIGHT SIDE, VERTICALLY CENTERED.
    -- The Roblox mobile jump button sits bottom-right (~bottom 120px, right edge),
    -- so we bias the grid slightly upward to clear it, while keeping it in the
    -- middle-right area (not pushed all the way to the top like before).
    local totalGridW = cols * BTN_W + (cols - 1) * gap
    local rows       = math.ceil(#btnDefs / cols)
    local totalGridH = rows * BTN_H + (rows - 1) * gap
    local startX = vp.X - totalGridW - padding
    -- True vertical center, shifted up just enough to clear the jump button zone.
    local startY = math.floor((vp.Y - totalGridH) * 0.5) - 40
    if startY < 20 then startY = 20 end
    -- Safety cap: never let the grid go below the screen (in case of huge button size)
    if startY + totalGridH > vp.Y - 20 then
        startY = math.max(20, vp.Y - totalGridH - 20)
    end

    -- Helper: clamp saved positions to the viewport so buttons never drift off-screen.
    local function clampPos(x, y, defX, defY)
        if type(x) ~= "number" then x = defX end
        if type(y) ~= "number" then y = defY end
        x = math.clamp(math.floor(x + 0.5), 0, vp.X - BTN_W)
        y = math.clamp(math.floor(y + 0.5), 0, vp.Y - BTN_H)
        return x, y
    end

    -- Determine if we have a valid saved layout. If saved positions look invalid
    -- (different button count / off-screen) we fall back to the clean default grid.
    local useSaved = not M._forceDefaultMobPos and savedPositions
                     and type(savedPositions) == "table"
    if useSaved then
        -- Validate every button has a sane saved position
        local needed = #btnDefs
        local validCount = 0
        for _, def in ipairs(btnDefs) do
            local s = savedPositions[def[1]]
            if s and type(s.x) == "number" and type(s.y) == "number"
               and s.x >= -50 and s.x <= vp.X + 50
               and s.y >= -50 and s.y <= vp.Y + 50 then
                validCount = validCount + 1
            end
        end
        if validCount < needed then useSaved = false end
    end

    for i, def in ipairs(btnDefs) do
        local key      = def[1]
        local label    = def[2]
        local isToggle = def[3]

        local row = math.floor((i-1) / cols)
        local col = (i-1) % cols
        local defaultX = col * (BTN_W + gap)
        local defaultY = row * (BTN_H + gap)

        local posX, posY
        if useSaved and M.uiLocked then
            -- When locked and saved positions exist, use them exactly (clamped on-screen)
            local s = savedPositions[key]
            posX, posY = clampPos(s and s.x, s and s.y, startX + defaultX, startY + defaultY)
        elseif useSaved then
            local s = savedPositions[key]
            posX, posY = clampPos(s and s.x, s and s.y, startX + defaultX, startY + defaultY)
        else
            posX, posY = startX + defaultX, startY + defaultY
        end

        local btn = Instance.new("TextButton")
        btn.Name = "Btn_" .. key
        btn.Size = UDim2.new(0, BTN_W, 0, BTN_H)
        btn.Position = UDim2.new(0, posX, 0, posY)
        btn:SetAttribute("DefaultX", startX + defaultX)
        btn:SetAttribute("DefaultY", startY + defaultY)
        btn.BackgroundColor3 = BTN_OFF
        btn.BackgroundTransparency = 0
        btn.RichText = true
        -- CROOKED (italic) + BOLD style for mobile button labels
        btn.Text = "<b><i>" .. label:gsub("\n", "</i></b>\n<b><i>") .. "</i></b>"
        btn.TextColor3 = TXT_OFF
        btn.TextSize = math.max(11, math.floor(side * 0.20))
        btn.Font = Enum.Font.GothamBlack
        btn.TextWrapped = true
        btn.TextScaled = false
        btn.TextXAlignment = Enum.TextXAlignment.Center
        btn.TextYAlignment = Enum.TextYAlignment.Center
        btn.BorderSizePixel = 0
        btn.ZIndex = 101
        btn.AutoButtonColor = false
        -- Slight black stroke for a thicker / more readable look
        btn.TextStrokeColor3 = Color3.fromRGB(0,0,0)
        btn.TextStrokeTransparency = 0.3
        btn:SetAttribute("BtnKey", key)
        btn.Parent = mobGui

        local corner = Instance.new("UICorner", btn)
        if M.circleButtonsEnabled then
            corner.CornerRadius = UDim.new(1, 0)
        else
            corner.CornerRadius = UDim.new(0, CORNER_R)
        end
        btn.TextStrokeTransparency = 1

        -- Crisp white outline (subtle so it reads on the dark game background)
        local stroke = Instance.new("UIStroke")
        stroke.Name = "BtnStroke"
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Color = Color3.fromRGB(220, 220, 220)
        stroke.Thickness = 1.2
        stroke.Transparency = 0
        stroke.Parent = btn

        local isOn = false
        -- Explicitly initialize each button to its OFF visual state before any setOn call
        btn.BackgroundColor3 = BTN_OFF
        btn.TextColor3 = TXT_OFF
        btn.TextStrokeTransparency = 1
        stroke.Color = Color3.fromRGB(220, 220, 220)
        stroke.Thickness = 1.2
        stroke.Transparency = 0

        local function setOn(v)
            isOn = v
            local s = btn:FindFirstChild("BtnStroke")
            if not s then
                s = Instance.new("UIStroke")
                s.Name = "BtnStroke"
                s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                s.Parent = btn
            end
            if v then
                TweenService:Create(btn, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BackgroundColor3 = BTN_ON,
                    TextColor3 = TXT_ON,
                }):Play()
                s.Color = Color3.fromRGB(0, 0, 0)
                s.Thickness = 1.2
                s.Transparency = 0
            else
                TweenService:Create(btn, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BackgroundColor3 = BTN_OFF,
                    TextColor3 = TXT_OFF,
                }):Play()
                s.Color = Color3.fromRGB(220, 220, 220)
                s.Thickness = 1.2
                s.Transparency = 0
            end
        end

        M.mobBtnRefs[key] = setOn

        btn.MouseButton1Down:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.05), {
                BackgroundColor3 = BTN_ON,
                TextColor3 = TXT_ON
            }):Play()
        end)
        btn.MouseButton1Up:Connect(function()
            if not isOn then
                TweenService:Create(btn, TweenInfo.new(0.1), {
                    BackgroundColor3 = BTN_OFF,
                    TextColor3 = TXT_OFF
                }):Play()
            end
        end)

        -- Drag individual buttons (BLOCKED entirely when UI is locked)
        local dragging = false
        local dragStart = nil
        local startPos = nil
        btn.InputBegan:Connect(function(input)
            if M.uiLocked then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = btn.Position
                local con
                con = input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                        if con then con:Disconnect() end
                        -- Keep buttons inside viewport after drag
                        local nx = math.clamp(btn.Position.X.Offset, 0, vp.X - BTN_W)
                        local ny = math.clamp(btn.Position.Y.Offset, 0, vp.Y - BTN_H)
                        btn.Position = UDim2.new(0, nx, 0, ny)
                        M.saveBtnPositions()
                    end
                end)
            end
        end)
        btn.InputChanged:Connect(function(input)
            if M.uiLocked then dragging = false; return end
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                local nx = math.clamp(startPos.X.Offset + delta.X, 0, vp.X - BTN_W)
                local ny = math.clamp(startPos.Y.Offset + delta.Y, 0, vp.Y - BTN_H)
                btn.Position = UDim2.new(0, nx, 0, ny)
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if dragging and M.uiLocked then
                dragging = false
                M.saveBtnPositions()
            end
        end)

        btn.Activated:Connect(function()
            if key == "drop" then
                M.runDrop()
            elseif key == "tpDown" then
                M.runTPFloor()
            elseif key == "autoLeft" then
                if M.autoBatEnabled then
                    M.stopBatAimbot()
                    if M.autoBatSetVisual then M.autoBatSetVisual(false) end
                    if M.mobBtnRefs.autoBat then M.mobBtnRefs.autoBat(false) end
                end
                if M.autoRightEnabled then
                    M.autoRightEnabled = false
                    M.stopAutoRight()
                    if M.autoRightSetVisual then M.autoRightSetVisual(false) end
                    if M.mobBtnRefs.autoRight then M.mobBtnRefs.autoRight(false) end
                end
                M.autoLeftEnabled = not M.autoLeftEnabled
                if M.autoLeftEnabled then M.startAutoLeft() else M.stopAutoLeft() end
                setOn(M.autoLeftEnabled)
                if M.autoLeftSetVisual then M.autoLeftSetVisual(M.autoLeftEnabled) end
                saveRykeConfig()
            elseif key == "autoRight" then
                if M.autoBatEnabled then
                    M.stopBatAimbot()
                    if M.autoBatSetVisual then M.autoBatSetVisual(false) end
                    if M.mobBtnRefs.autoBat then M.mobBtnRefs.autoBat(false) end
                end
                if M.autoLeftEnabled then
                    M.autoLeftEnabled = false
                    M.stopAutoLeft()
                    if M.autoLeftSetVisual then M.autoLeftSetVisual(false) end
                    if M.mobBtnRefs.autoLeft then M.mobBtnRefs.autoLeft(false) end
                end
                M.autoRightEnabled = not M.autoRightEnabled
                if M.autoRightEnabled then M.startAutoRight() else M.stopAutoRight() end
                setOn(M.autoRightEnabled)
                if M.autoRightSetVisual then M.autoRightSetVisual(M.autoRightEnabled) end
                saveRykeConfig()
            elseif key == "autoBat" then
                if M.autoLeftEnabled then
                    M.autoLeftEnabled = false
                    M.stopAutoLeft()
                    if M.autoLeftSetVisual then M.autoLeftSetVisual(false) end
                    if M.mobBtnRefs.autoLeft then M.mobBtnRefs.autoLeft(false) end
                end
                if M.autoRightEnabled then
                    M.autoRightEnabled = false
                    M.stopAutoRight()
                    if M.autoRightSetVisual then M.autoRightSetVisual(false) end
                    if M.mobBtnRefs.autoRight then M.mobBtnRefs.autoRight(false) end
                end
                if not M.autoBatEnabled then
                    M.queueAutoBatStart()
                else
                    M.stopBatAimbot()
                end
                setOn(M.autoBatEnabled)
                if M.autoBatSetVisual then M.autoBatSetVisual(M.autoBatEnabled) end
                saveRykeConfig()
            elseif key == "lagger" then
                M.toggleLaggerMode()
                setOn(M.laggerModeEnabled)
                if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(M.carrySpeedActive) end
                if M.laggerModeBtn then
                    M.laggerModeBtn.Text = M.laggerModeEnabled and "Lag On" or "Lag Off"
                end
                saveRykeConfig()
            elseif key == "carrySpeed" then
                M.toggleCarryMode()
                setOn(M.carrySpeedActive)
                if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(M.laggerModeEnabled) end
                if M.carryModeBtn then
                    M.carryModeBtn.Text = M.carrySpeedActive and "Carry On" or "Carry Off"
                end
                saveRykeConfig()
            elseif key == "bypass" then
                M.toggleBypassAimbot()
                setOn(M.bypassAimbotEnabled)
                if M.setBypassVisual then M.setBypassVisual(M.bypassAimbotEnabled) end
                saveRykeConfig()
            elseif key == "laggerCarry" then
                M.toggleLaggerCarry()
                setOn(M.laggerCarryActive)
                saveRykeConfig()
            end
        end)
    end

    if M.mobBtnRefs.autoLeft then M.mobBtnRefs.autoLeft(M.autoLeftEnabled) end
    if M.mobBtnRefs.autoRight then M.mobBtnRefs.autoRight(M.autoRightEnabled) end
    if M.mobBtnRefs.autoBat then M.mobBtnRefs.autoBat(M.autoBatEnabled) end
    if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(M.laggerModeEnabled) end
    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(M.carrySpeedActive) end
    if M.mobBtnRefs.bypass then M.mobBtnRefs.bypass(M.bypassAimbotEnabled) end
    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(M.laggerCarryActive) end

    -- AUTO-SAVE positions + config immediately on build (no click needed)
    M.saveBtnPositions()
    pcall(saveRykeConfig)
end

-- ============================================================
-- CONFIG SAVE/LOAD
-- ============================================================
local RYKE_CONFIG_NAME = "RykeConfig.json"
local RykeConfig = { Theme="Default" }
local RYKE_THEMES = {
    Default  = { Accent=Color3.fromRGB(255,255,255), AccentDim=Color3.fromRGB(180,180,190), Bg=Color3.fromRGB(0,0,0),     Row=Color3.fromRGB(8,8,12) },
    Purple   = { Accent=Color3.fromRGB(207,159,255), AccentDim=Color3.fromRGB(160,120,210), Bg=Color3.fromRGB(8,4,14),    Row=Color3.fromRGB(16,10,24) },
    Blue     = { Accent=Color3.fromRGB(58,128,245),  AccentDim=Color3.fromRGB(40,90,180),   Bg=Color3.fromRGB(4,8,16),    Row=Color3.fromRGB(10,16,28) },
    Red      = { Accent=Color3.fromRGB(232,52,68),   AccentDim=Color3.fromRGB(180,40,50),   Bg=Color3.fromRGB(14,4,6),    Row=Color3.fromRGB(24,10,12) },
    Pink     = { Accent=Color3.fromRGB(255,105,180), AccentDim=Color3.fromRGB(200,80,140),  Bg=Color3.fromRGB(14,6,12),   Row=Color3.fromRGB(24,12,20) },
    Yellow   = { Accent=Color3.fromRGB(255,214,0),   AccentDim=Color3.fromRGB(200,170,0),   Bg=Color3.fromRGB(12,12,4),   Row=Color3.fromRGB(20,18,8) },
    Grey     = { Accent=Color3.fromRGB(180,180,185), AccentDim=Color3.fromRGB(120,120,125), Bg=Color3.fromRGB(10,10,12),  Row=Color3.fromRGB(18,18,20) },
    Forest   = { Accent=Color3.fromRGB(46,200,120),  AccentDim=Color3.fromRGB(30,140,80),   Bg=Color3.fromRGB(4,12,8),    Row=Color3.fromRGB(10,22,14) },
    Cyan     = { Accent=Color3.fromRGB(0,220,255),   AccentDim=Color3.fromRGB(0,160,190),   Bg=Color3.fromRGB(4,12,16),   Row=Color3.fromRGB(8,20,26) },
    Orange   = { Accent=Color3.fromRGB(255,140,40),  AccentDim=Color3.fromRGB(200,100,30),  Bg=Color3.fromRGB(14,8,4),    Row=Color3.fromRGB(24,14,8) },
}
if M._savedTheme and RYKE_THEMES[M._savedTheme] then
    RykeConfig.Theme = M._savedTheme
end
M.colorScheme = RykeConfig.Theme
M.customBgId = 0
M.customBgOpacity = 0.35
M.mobBtnBgId = 0
M.BG_IMAGE_IDS = {
    79737099962715,
    71211662493854,
    15556272558,
    1471587689,
    14349182390,
    108236541541009,
}
M.MOB_BTN_IMAGE_IDS = {
    15101684346,
    39396,
    109592813321691,
    83661129801187,
    94353803110527,
    109100201685955,
}


local function loadRykeConfig()
    if type(readfile)~="function" or type(isfile)~="function" then return end
    local ok,d = pcall(function()
        if not isfile(RYKE_CONFIG_NAME) then return nil end
        return HS:JSONDecode(readfile(RYKE_CONFIG_NAME))
    end)
    if ok and type(d)=="table" then
        local themeName = nil
        if type(d.Theme)=="string" and RYKE_THEMES[d.Theme] then themeName = d.Theme end
        if type(d.colorScheme)=="string" and RYKE_THEMES[d.colorScheme] then themeName = d.colorScheme end
        if themeName then
            RykeConfig.Theme = themeName
            M.colorScheme = themeName
            M._savedTheme = themeName
        end
        if type(d.normalSpeed)=="number" then M.NS=d.normalSpeed end
        if type(d.carrySpeed)=="number" then M.CS=d.carrySpeed end
        if type(d.laggerSpeed)=="number" then M.LAGGER_SPEED=d.laggerSpeed end
        if type(d.laggerCarrySpeed)=="number" then M.LAGGER_CARRY_SPEED=d.laggerCarrySpeed end
        if type(d.speedMethod)=="string" then
            for _,sm in ipairs(M.speedMethodList) do if sm==d.speedMethod then M.speedMethod=sm; break end end
        end
        if type(d.grabRadius)=="number" then M.Steal.StealRadius=d.grabRadius end
        if type(d.stealDuration)=="number" then M.Steal.StealDuration=d.stealDuration end
        if type(d.stealStopTime)=="number" then M.Steal.StopTime=d.stealStopTime end
        if type(d.stealMode)=="string" then
            if d.stealMode == "Semi" or d.stealMode == "Normal" or d.stealMode == "V1" or d.stealMode == "V2" or d.stealMode == "V3" then
                M.stealMode=d.stealMode
            end
        end
        if type(d.autoTPHeight)=="number" then M.autoTPHeight=d.autoTPHeight end
        if type(d.fovValue)=="number" then M.fovValue=d.fovValue end
        if type(d.uiScale)=="number" then M.uiScale=d.uiScale end
        if type(d.infJumpMode)=="string" then M.infJumpMode=d.infJumpMode end
        if type(d.mobileButtonsSize)=="number" then M.mobileButtonsSize=d.mobileButtonsSize end
        if type(d.menuWidth)=="number" then M.menuWidth=math.clamp(math.floor(d.menuWidth+0.5), 360, 1200) end
        if type(d.menuHeight)=="number" then M.menuHeight=math.clamp(math.floor(d.menuHeight+0.5), 300, 1000) end
        if type(d.skyTheme)=="string" then M.currentSkyTheme=d.skyTheme end
        if type(d.stealBarSize)=="number" then M.stealBarSize=d.stealBarSize end
        -- Load speed mode active flags (carry/lagger/lagger carry) so they persist across executions.
        if d.carrySpeedActive~=nil then M.carrySpeedActive=d.carrySpeedActive==true end
        if d.laggerModeEnabled~=nil then M.laggerModeEnabled=d.laggerModeEnabled==true end
        if d.laggerCarryActive~=nil then M.laggerCarryActive=d.laggerCarryActive==true end
        if d.autoSwing~=nil then M.autoSwingEnabled=d.autoSwing==true end
        if d.introSoundEnabled~=nil then M.introSoundEnabled=d.introSoundEnabled==true end
        if d.introSongChoice then M.introSongChoice=d.introSongChoice end
        if d.introGUIEnabled~=nil then M.introGUIEnabled=d.introGUIEnabled==true end
        if d.ragdollGui~=nil then M.ragdollGuiEnabled=d.ragdollGui==true end
        if d.circleButtonsEnabled~=nil then M.circleButtonsEnabled=d.circleButtonsEnabled==true end
        if d.perButtonDrag~=nil then M.perButtonDragEnabled=d.perButtonDrag==true end
        if d.mobileButtonsEnabled~=nil then M.mobileButtonsEnabled=d.mobileButtonsEnabled end
        if d.medusaReset~=nil then M.medusaResetEnabled=d.medusaReset==true end
        if d.autoMoveSwing~=nil then M.autoMoveSwingEnabled=d.autoMoveSwing==true end
        if d.autoSwitchSpeed~=nil then M.autoSwitchSpeedEnabled=d.autoSwitchSpeed==true end
        if d.autoTurnOffSpeed~=nil then M.autoTurnOffSpeedEnabled=d.autoTurnOffSpeed==true end
        if d.autoSwitchLaggerSpeed~=nil then M.autoSwitchLaggerSpeedEnabled=d.autoSwitchLaggerSpeed==true end
        if type(d.customFont)=="string" then M.customFontSelected=d.customFont end
        if d.showPlayerSpeeds~=nil then M.showPlayerSpeeds=d.showPlayerSpeeds==true end
        if d.removeAcc~=nil then M.removeAccEnabled=d.removeAcc end
        if d.playerESPEnabled~=nil then M.playerESPEnabled=d.playerESPEnabled end
        if d.antiRagdoll~=nil then M.antiRagdollEnabled=d.antiRagdoll end
        if type(d.antiRagdollMode)=="string" and (d.antiRagdollMode=="Splatter" or d.antiRagdollMode=="No Splatter") then M.antiRagdollMode=d.antiRagdollMode end
        if d.autoStealEnabled~=nil then M.Steal.AutoStealEnabled=d.autoStealEnabled end
        if d.autoRadiusEnabled~=nil then M.autoRadiusEnabled=d.autoRadiusEnabled==true end

        if d.infiniteJump~=nil then M.infJumpEnabled=d.infiniteJump end
        if d.medusaCounter~=nil then M.medusaCounterEnabled=d.medusaCounter end
        if d.batCounter~=nil then M.batCounterEnabled=d.batCounter end
        if d.unwalkEnabled~=nil then M.unwalkEnabled=d.unwalkEnabled end
        if d.antiLag~=nil then M.antiLagEnabled=d.antiLag end
        if d.antiSummerBase~=nil then M.antiSummerBaseEnabled=d.antiSummerBase end
        if d.uiLocked~=nil then M.uiLocked=d.uiLocked==true end
        if d.stretchRez~=nil then M.stretchRezEnabled=d.stretchRez end
        if d.autoTPEnabled~=nil then M.autoTPEnabled=d.autoTPEnabled end
        if d.antiKick~=nil then M.antiKickEnabled=d.antiKick end
        if d.safeMode~=nil then M.safeModeEnabled=d.safeMode end
        if d.mirrorTPDown~=nil then M.mirrorTPDownEnabled=d.mirrorTPDown end
        if type(d.customBgId)=="number" then M.customBgId=d.customBgId end
        if type(d.customBgOpacity)=="number" then M.customBgOpacity=math.clamp(d.customBgOpacity,0,1) end
        if type(d.mobBtnBgId)=="number" then M.mobBtnBgId=d.mobBtnBgId end
        if d.autoBat~=nil then M.autoBatEnabled=d.autoBat end
        if d.semiHoldMin then M.Semi.holdMin=d.semiHoldMin end
        if d.semiHoldMax then M.Semi.holdMax=d.semiHoldMax end
        if d.semiEntryDelay then M.Semi.entryDelay=d.semiEntryDelay end
        if d.semiPrimeRange then M.Semi.primeRange=d.semiPrimeRange end
        if type(d.semiRadius)=="number" then M.Semi.radius=math.min(d.semiRadius, 10) end
        if d.lineESPEnabled~=nil then M.lineESPEnabled=d.lineESPEnabled end
        if d.menuOpen~=nil then M.menuOpen=d.menuOpen~=false end
        -- theme already applied above; keep M._savedTheme in sync
        if type(d.Theme)=="string" and RYKE_THEMES[d.Theme] then M._savedTheme=d.Theme; M.colorScheme=d.Theme end
        if type(d.colorScheme)=="string" and RYKE_THEMES[d.colorScheme] then M._savedTheme=d.colorScheme; M.colorScheme=d.colorScheme end
        if d.speedESPEnabled~=nil then M.speedESPEnabled=d.speedESPEnabled end
        if d.autoResetOnDeath~=nil then M.autoResetOnDeath=d.autoResetOnDeath end
        if type(d.animPack)=="string" then M.animPack=d.animPack end
        if d.headlessEnabled~=nil then M.headlessEnabled=d.headlessEnabled end
        if d.korbloxEnabled~=nil then M.korbloxEnabled=d.korbloxEnabled end
        if d.bypassAimbotEnabled~=nil then M.bypassAimbotEnabled=d.bypassAimbotEnabled end
        if d.animPackEnabled~=nil then M.animPackEnabled=d.animPackEnabled end
        local function lk(e,d2)
            if type(d2)~="table" then return end
            if d2.kb and Enum.KeyCode[d2.kb] then e.kb=Enum.KeyCode[d2.kb] else e.kb=nil end
            if d2.gp and Enum.KeyCode[d2.gp] then e.gp=Enum.KeyCode[d2.gp] else e.gp=nil end
        end
        if d.dropBrainrotKey then lk(M.KB.DropBrainrot,d.dropBrainrotKey) end
        if d.autoLeftKey then lk(M.KB.AutoLeft,d.autoLeftKey) end
        if d.autoRightKey then lk(M.KB.AutoRight,d.autoRightKey) end
        if d.autoBatKey then lk(M.KB.AutoBat,d.autoBatKey) end
        if d.laggerToggleKey then lk(M.KB.LaggerToggle,d.laggerToggleKey) end
        if d.tpFloorKey then lk(M.KB.TPFloor,d.tpFloorKey) end
        if d.guiHideKey then lk(M.KB.GuiHide,d.guiHideKey) end
        if d.speedToggleKey then lk(M.KB.SpeedToggle,d.speedToggleKey) end
        if d.bypassAimbotKey then lk(M.KB.BypassAimbot,d.bypassAimbotKey) end
        -- Load saved menu frame position (so the window stays where you dragged it)
        if type(d.menuFramePos) == "table" then
            M.menuFramePos = d.menuFramePos
        end
        if type(d.toggleBtnPos) == "table" then
            M.toggleBtnPos = d.toggleBtnPos
        end
    end
end

local function saveRykeConfig()
    if type(writefile)~="function" then return end
    local function ks(e)
        if type(e) ~= "table" then return {kb=nil,gp=nil} end
        return {
            kb = (e.kb and e.kb.Name) or nil,
            gp = (e.gp and e.gp.Name) or nil,
        }
    end
    local cfg = {
        Theme=RykeConfig.Theme, colorScheme=M.colorScheme or RykeConfig.Theme, menuOpen=M.menuOpen~=false,
        normalSpeed=M.NS, carrySpeed=M.CS, laggerSpeed=M.LAGGER_SPEED,
        laggerCarrySpeed=M.LAGGER_CARRY_SPEED, speedMethod=M.speedMethod, grabRadius=M.Steal.StealRadius,
        stealDuration=M.Steal.StealDuration, stealStopTime=M.Steal.StopTime, stealMode=M.stealMode,
        autoTPHeight=M.autoTPHeight, fovValue=M.fovValue, uiScale=M.uiScale,
        infJumpMode=M.infJumpMode,
        mobileButtonsSize=M.mobileButtonsSize, menuWidth=M.menuWidth, menuHeight=M.menuHeight, skyTheme=M.currentSkyTheme,
        customBgId=tonumber(M.customBgId) or 0, customBgOpacity=tonumber(M.customBgOpacity) or 0.35,
        mobBtnBgId=tonumber(M.mobBtnBgId) or 0,
        stealBarSize=M.stealBarSize,
        carrySpeedActive=M.carrySpeedActive, laggerModeEnabled=M.laggerModeEnabled, laggerCarryActive=M.laggerCarryActive,
        autoSwing=M.autoSwingEnabled, introSoundEnabled=M.introSoundEnabled,
        introSongChoice=M.introSongChoice,
        introGUIEnabled=M.introGUIEnabled,
        ragdollGui=M.ragdollGuiEnabled, circleButtonsEnabled=M.circleButtonsEnabled,
        perButtonDrag=M.perButtonDragEnabled, mobileButtonsEnabled=M.mobileButtonsEnabled,
        medusaReset=M.medusaResetEnabled, autoMoveSwing=M.autoMoveSwingEnabled,
        autoSwitchSpeed=M.autoSwitchSpeedEnabled, autoTurnOffSpeed=M.autoTurnOffSpeedEnabled, autoSwitchLaggerSpeed=M.autoSwitchLaggerSpeedEnabled, customFont=M.customFontSelected, showPlayerSpeeds=M.showPlayerSpeeds,
        removeAcc=M.removeAccEnabled,
        playerESPEnabled=M.playerESPEnabled,
        autoStealEnabled=M.Steal.AutoStealEnabled,
        autoRadiusEnabled=M.autoRadiusEnabled,
        antiRagdoll=M.antiRagdollEnabled, antiRagdollMode=M.antiRagdollMode, infiniteJump=M.infJumpEnabled,
        medusaCounter=M.medusaCounterEnabled, batCounter=M.batCounterEnabled,
        unwalkEnabled=M.unwalkEnabled, antiLag=M.antiLagEnabled, antiSummerBase=M.antiSummerBaseEnabled, uiLocked=M.uiLocked,
        stretchRez=M.stretchRezEnabled, autoTPEnabled=M.autoTPEnabled,
        antiKick=M.antiKickEnabled, safeMode=M.safeModeEnabled, mirrorTPDown=M.mirrorTPDownEnabled, autoBat=M.autoBatEnabled,
        semiHoldMin=M.Semi.holdMin, semiHoldMax=M.Semi.holdMax,
        semiEntryDelay=M.Semi.entryDelay,
        semiPrimeRange=M.Semi.primeRange,
        semiRadius=math.min(M.Semi.radius, 10),
        lineESPEnabled=M.lineESPEnabled,
        speedESPEnabled=M.speedESPEnabled,
        autoResetOnDeath=M.autoResetOnDeath,
        animPack=M.animPack,
        headlessEnabled=M.headlessEnabled,
        korbloxEnabled=M.korbloxEnabled,
        bypassAimbotEnabled=M.bypassAimbotEnabled,
        animPackEnabled=M.animPackEnabled,
        dropBrainrotKey=ks(M.KB.DropBrainrot), autoLeftKey=ks(M.KB.AutoLeft),
        autoRightKey=ks(M.KB.AutoRight), autoBatKey=ks(M.KB.AutoBat),
        laggerToggleKey=ks(M.KB.LaggerToggle), tpFloorKey=ks(M.KB.TPFloor),
        guiHideKey=ks(M.KB.GuiHide),
        speedToggleKey=ks(M.KB.SpeedToggle), bypassAimbotKey=ks(M.KB.BypassAimbot),
        menuFramePos=M.menuFramePos or nil,
        toggleBtnPos=M.toggleBtnPos or nil,
    }
    pcall(function() writefile(RYKE_CONFIG_NAME, HS:JSONEncode(cfg)) end)
end

M.saveConfig = saveRykeConfig

-- ============================================================
-- RYKE ESP
-- ============================================================
local RunService2 = game:GetService("RunService")
local rykeESPState = { LineESP=false, SpeedESP=false }
local rykeESPObjects = {}
local DrawingAvailable = false
pcall(function() DrawingAvailable = Drawing and type(Drawing.new)=="function" end)

local function rykeRemoveESP(p)
    local r = rykeESPObjects[p]
    if not r then return end
    for _,o in pairs(r) do pcall(function()
        if typeof(o)=="Instance" then o:Destroy()
        elseif o.Remove then o:Remove() end
    end) end
    rykeESPObjects[p]=nil
end

local function rykeGetSpeed(root)
    local v
    pcall(function() v=root.AssemblyLinearVelocity end)
    if not v then pcall(function() v=root.Velocity end) end
    if not v then return 0 end
    return Vector3.new(v.X,0,v.Z).Magnitude
end

local function rykeCreateESP(p)
    if rykeESPObjects[p] then return rykeESPObjects[p] end
    local r={}
    local hl=Instance.new("Highlight")
    hl.FillTransparency=1; hl.OutlineTransparency=0
    hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
    hl.Enabled=false; hl.Parent=workspace
    r.Highlight=hl
    local bb=Instance.new("BillboardGui")
    bb.Size=UDim2.fromOffset(150,32); bb.StudsOffset=Vector3.new(0,3.25,0)
    bb.AlwaysOnTop=true; bb.Enabled=false; bb.ResetOnSpawn=false
    bb.Parent=player:WaitForChild("PlayerGui")
    local sl=Instance.new("TextLabel",bb)
    sl.Size=UDim2.fromScale(1,1); sl.BackgroundTransparency=1; sl.Text="0.0 spd"
    sl.TextStrokeColor3=Color3.new(0,0,0); sl.TextStrokeTransparency=0
    sl.Font=Enum.Font.GothamBlack; sl.TextSize=18
    sl.TextXAlignment=Enum.TextXAlignment.Center; sl.TextYAlignment=Enum.TextYAlignment.Center
    r.Billboard=bb; r.SpeedText=sl
    if DrawingAvailable then
        local ln=Drawing.new("Line")
        ln.Visible=false; ln.Thickness=2.75; ln.Transparency=1
        r.Line=ln
    end
    rykeESPObjects[p]=r
    return r
end

Players.PlayerRemoving:Connect(function(p) rykeRemoveESP(p) end)

-- Build dark UI colours from a chosen accent (every "black" becomes that colour family)
local function themeDarkFromAccent(accent, amount)
    -- amount 0 = pure black, 1 = full accent
    amount = math.clamp(tonumber(amount) or 0.12, 0, 1)
    return Color3.new(
        math.clamp(accent.R * amount, 0, 1),
        math.clamp(accent.G * amount, 0, 1),
        math.clamp(accent.B * amount, 0, 1)
    )
end

local function isNearBlack(c, threshold)
    if typeof(c) ~= "Color3" then return false end
    threshold = threshold or 0.14
    return c.R <= threshold and c.G <= threshold and c.B <= threshold
end

local function applyAccentFromTheme()
    local name = RykeConfig.Theme or M.colorScheme or M._savedTheme or "Default"
    if not RYKE_THEMES[name] then name = "Default" end
    RykeConfig.Theme = name
    M.colorScheme = name
    M._savedTheme = name
    local t = RYKE_THEMES[name]
    local accent = t.Accent
    local dim = t.AccentDim or Color3.new(accent.R * 0.65, accent.G * 0.65, accent.B * 0.65)

    -- EVERY black UI slot is derived from the chosen accent colour
    local bg  = themeDarkFromAccent(accent, 0.10)   -- main background
    local row = themeDarkFromAccent(accent, 0.18)   -- rows / cards
    local btn = themeDarkFromAccent(accent, 0.22)   -- buttons
    local tog = themeDarkFromAccent(accent, 0.28)   -- toggle off track
    local gradTop = themeDarkFromAccent(accent, 0.26)
    local gradBot = themeDarkFromAccent(accent, 0.08)

    RYKE_ACCENT = accent
    UI_ACCENT = accent
    UI_ACCENT_DIM = dim
    UI_BG_DARK = bg
    UI_ROW_BG = row
    UI_BTN_BG = btn
    UI_TOGGLE_OFF = tog
    UI_TOGGLE_KNOB = Color3.fromRGB(200, 200, 210)
    UI_KNOB_ON = Color3.fromRGB(255, 255, 255)
    UI_TEXT_PRIMARY = Color3.fromRGB(255, 255, 255)
    UI_TEXT_WHITE = Color3.fromRGB(255, 255, 255)
    UI_TEXT_DIM = Color3.fromRGB(200,200,210)
    UI_TEXT_SECTION = accent
    UI_CARD_STROKE = dim
    UI_GRAD_TOP = gradTop
    UI_GRAD_BOT = gradBot

    M.Theme = {
        Name = name,
        Accent = accent,
        AccentDim = dim,
        Bg = bg,
        Row = row,
    }
end

-- Walk any GUI tree and replace near-black BackgroundColor3 / stroke blacks with theme colours
function M.recolorBlacksToTheme(root)
    if not root then return end
    local bg = UI_BG_DARK or themeDarkFromAccent(UI_ACCENT or Color3.new(1,1,1), 0.10)
    local row = UI_ROW_BG or themeDarkFromAccent(UI_ACCENT or Color3.new(1,1,1), 0.18)
    local btn = UI_BTN_BG or themeDarkFromAccent(UI_ACCENT or Color3.new(1,1,1), 0.22)
    local accent = UI_ACCENT or Color3.new(1,1,1)
    local dim = UI_ACCENT_DIM or accent

    local function recolor(obj)
        if obj:IsA("GuiObject") then
            local ok, col = pcall(function() return obj.BackgroundColor3 end)
            if ok and isNearBlack(col) then
                -- Main frames stay darkest; smaller elements get row/btn tint
                if obj:IsA("Frame") and (obj.Name == "Main" or obj.Name == "MainFrame" or obj.Size.X.Scale >= 0.9) then
                    obj.BackgroundColor3 = bg
                elseif obj:IsA("TextButton") or obj:IsA("ImageButton") then
                    obj.BackgroundColor3 = btn
                else
                    obj.BackgroundColor3 = row
                end
            end
        end
        if obj:IsA("UIStroke") then
            local ok, col = pcall(function() return obj.Color end)
            if ok and isNearBlack(col, 0.25) then
                obj.Color = dim
            end
        end
        if obj:IsA("UIGradient") then
            pcall(function()
                obj.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, UI_GRAD_TOP or gradTop or row),
                    ColorSequenceKeypoint.new(1, UI_GRAD_BOT or bg),
                })
            end)
        end
    end

    recolor(root)
    for _, d in ipairs(root:GetDescendants()) do
        recolor(d)
    end
end

local RYKE_ACCENT = RYKE_THEMES[RykeConfig.Theme].Accent

RunService2.RenderStepped:Connect(function()
    local cam=workspace.CurrentCamera; if not cam then return end
    local lc=player.Character
    local lr=lc and lc:FindFirstChild("HumanoidRootPart")
    local lineStart=Vector2.new(cam.ViewportSize.X*0.5, cam.ViewportSize.Y*0.82)
    if lr then
        local rp,rv=cam:WorldToViewportPoint(lr.Position)
        if rv and rp.Z>0 then lineStart=Vector2.new(rp.X,rp.Y) end
    end
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= player then
            local r=rykeCreateESP(p)
            local ch=p.Character
            local hum=ch and ch:FindFirstChildOfClass("Humanoid")
            local root=ch and ch:FindFirstChild("HumanoidRootPart")
            local head=ch and ch:FindFirstChild("Head")
            local alive=ch and hum and root and hum.Health>0
            if not alive then
                if r.Line then r.Line.Visible=false end
                r.Highlight.Enabled=false; r.Billboard.Enabled=false
                r.Highlight.Adornee=nil; r.Billboard.Adornee=nil
            else
                local liveAccent = UI_ACCENT or RYKE_ACCENT or Color3.fromRGB(255,255,255)
                r.Highlight.Adornee=ch; r.Highlight.Enabled=rykeESPState.LineESP
                r.Highlight.OutlineColor=liveAccent
                r.Highlight.FillColor=liveAccent
                r.Highlight.FillTransparency=0.85
                if r.Line then
                    local tp,tv=cam:WorldToViewportPoint(root.Position)
                    if rykeESPState.LineESP and tv and tp.Z>0 then
                        r.Line.From=lineStart; r.Line.To=Vector2.new(tp.X,tp.Y)
                        r.Line.Color=liveAccent; r.Line.Thickness=2.75; r.Line.Visible=true
                    else r.Line.Visible=false end
                end
                if rykeESPState.SpeedESP and head then
                    r.Billboard.Adornee=head; r.Billboard.Enabled=true
                    r.SpeedText.Text=string.format("%.1f spd",rykeGetSpeed(root))
                    r.SpeedText.TextColor3=liveAccent
                else r.Billboard.Enabled=false; r.Billboard.Adornee=nil end
            end
        end
    end
end)

function M.trackConn(conn) table.insert(M._persistentConns,conn); return conn end
function M.clearPersistentConns()
    for _,c in ipairs(M._persistentConns) do pcall(function() c:Disconnect() end) end
    M._persistentConns={}
end

function M.makeNumberCallback(tbl,key,min,max)
    return function(v)
        if min and v<min then return end
        if max and v>max then return end
        tbl[key]=v
        if key=="mobileButtonsSize" and M.mobileButtonsEnabled then M.buildMobileButtons() end
        if key=="stealBarSize" then M.buildStatusUI() end
        saveRykeConfig()
    end
end

-- ============================================================
function M.applyStealBarTheme(accentColor)
    local col = accentColor or UI_ACCENT or RYKE_ACCENT or Color3.fromRGB(255, 255, 255)
    if M.statusFill then
        M.statusFill.BackgroundColor3 = col
    end
    if M.statusDot then
        M.statusDot.BackgroundColor3 = col
    end
    if M.statusMain then
        local st = M.statusMain:FindFirstChildOfClass("UIStroke")
        if st then st.Color = col end
    end
end

-- ============================================================
-- RESET ALL SETTINGS
-- ============================================================
function M.resetAllSettings()
    -- Clear saved config files and positions
    if type(delfile) == "function" then
        pcall(function() if isfile and isfile("RykeConfig.json") then delfile("RykeConfig.json") end end)
        pcall(function() if isfile and isfile("rykeduels_btnpos_v2.json") then delfile("rykeduels_btnpos_v2.json") end end)
    end
    M._forceDefaultMobPos = true

    -- Clear saved config files and positions
    if type(delfile) == "function" then
        pcall(function() if isfile and isfile("RykeConfig.json") then delfile("RykeConfig.json") end end)
        pcall(function() if isfile and isfile("rykeduels_btnpos_v2.json") then delfile("rykeduels_btnpos_v2.json") end end)
    end
    M._forceDefaultMobPos = true

    M.NS = 60
    M.CS = 30
    M.LAGGER_SPEED = 15
    M.LAGGER_CARRY_SPEED = 24.5
    M.speedMethod = "Velocity"
    M.hyperMult = 4
    M._lastSpeedMethod = nil
    M._anchoredBySpeed = nil
    M.carrySpeedActive = false
    M.laggerModeEnabled = false
    M.laggerCarryActive = false
    M.antiRagdollEnabled = false
    M.antiRagdollMode = "Splatter"
    M.infJumpEnabled = false
    M.infJumpMode = "manual"
    M.medusaCounterEnabled = false
    M.batCounterEnabled = false
    M.unwalkEnabled = false
    M.medusaResetEnabled = false
    M.medusaDebounce = false
    M.medusaLastUsed = 0
    M.autoLeftEnabled = false
    M.autoRightEnabled = false
    M.autoBatEnabled = false
    M.autoSwingEnabled = true
    M.autoMoveSwingEnabled = false
    M.antiLagEnabled = false
    M.removeAccessoriesEnabled = false
    M.stretchRezEnabled = false
    M.autoTPEnabled = false
    M.autoTPHeight = 20
    M.guiTransparencyEnabled = false
    M.mobileButtonsEnabled = true
    M.mobileButtonsSize = 100
    M.menuWidth = 560
    M.menuHeight = 450
    M.circleButtonsEnabled = false
    M.fovValue = 80
    M.fovIndex = 1
    M.autoSwitchSpeedEnabled = false
    M.antiKickEnabled = false
    M.brainrotDetected = false
    M.ragdollGuiEnabled = true
    M.introSoundEnabled = true
    M.introSongChoice = 3
    M.introGUIEnabled = true
    M.Steal.AutoStealEnabled = false
    M.autoRadiusEnabled = false
    M.Steal.StealRadius = 60
    M.Steal.StealDuration = 1.4
    M.Steal.StopTime = 0.35
    M.stealMode = "V1"
    M.Semi.holdMin = 1.3
    M.Semi.holdMax = 2.6
    M.Semi.entryDelay = 0.3
    M.Semi.radius = 10
    M.Semi.primeRange = 80
    M.removeAccEnabled = false
    M.playerESPEnabled = false
    M.showPlayerSpeeds = false
    M.uiScale = 0.8
    M.perButtonDragEnabled = true
    M.stealBarSize = 300
    M.lineESPEnabled = false
    M.speedESPEnabled = false
    M.autoResetOnDeath = false
    M.animPack = "Adidas Sports"
    M.headlessEnabled = false
    M.korbloxEnabled = false
    M.bypassAimbotEnabled = false
    M.animPackEnabled = true

    M.stopAutoSteal()
    M.stopBatAimbot()
    M.stopAutoLeft()
    M.stopAutoRight()
    M.stopAntiRagdoll()
    M.stopHoldInfJump()
    M.stopManualInfJumpLoop()
    M.stopMedusaCounter()
    M.stopBatCounter()
    M.stopUnwalk()
    M.disableAntiLag()
    M.disableStretchRez()
    M.stopAutoTP()
    M.disableAntiKick()
    M.stopBypassAimbot()
    M.stopRemoveAcc()
    M.toggleESP(false)
    M.togglePlayerSpeeds(false)
    M.autoResetOnDeath = false
    setupDeathReset()

    saveRykeConfig()
    M.buildGui()
end

-- ============================================================
-- INITIALIZATION


-- ============================================================

-- ============================================================
-- MAIN HUB GUI (AQUA HUB AESTHETIC - DEAD CENTER SPAWN)
-- ============================================================
function M.applyCustomBackground(frame)
    if not frame then return end
    local existing = frame:FindFirstChild("CustomBgImage")
    if existing then pcall(function() existing:Destroy() end) end
    local id = tonumber(M.customBgId) or 0
    if id <= 0 then return end
    local img = Instance.new("ImageLabel")
    img.Name = "CustomBgImage"
    img.BackgroundTransparency = 1
    img.Image = "rbxassetid://" .. tostring(id)
    img.ScaleType = Enum.ScaleType.Crop
    img.Size = UDim2.fromScale(1, 1)
    img.Position = UDim2.fromScale(0, 0)
    img.ZIndex = 0
    img.ImageTransparency = math.clamp(tonumber(M.customBgOpacity) or 0.35, 0, 1)
    img.Parent = frame
end


local function uiCardStyle(f)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 12); c.Parent = f
    local s = Instance.new("UIStroke"); s.Thickness = 1; s.Color = Color3.fromRGB(30, 30, 36); s.Transparency = 0.2; s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; s.Parent = f
    f.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
end

local function uiAccentBar(parent, on)
    local b = Instance.new("Frame")
    b.Position = UDim2.new(0, 0, 0.5, -9); b.Size = UDim2.new(0, 3, 0, 18)
    b.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    b.BackgroundTransparency = 0; b.BorderSizePixel = 0; b.Parent = parent
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 2); c.Parent = b
    return b
end

local function uiAutoCanvas(scroll)
    local lay = scroll:FindFirstChildOfClass("UIListLayout"); if not lay then return end
    local pad = scroll:FindFirstChildOfClass("UIPadding")
    local function upd()
        local padBottom = (pad and pad.PaddingBottom.Offset or 0)
        local padTop = (pad and pad.PaddingTop.Offset or 0)
        local h = lay.AbsoluteContentSize.Y + padBottom + padTop + 24
        scroll.CanvasSize = UDim2.new(0, 0, 0, math.max(h, 1))
    end
    lay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(upd)
    task.defer(upd)
    task.delay(0.15, upd)
    task.delay(0.5, upd)
end

local function uiCardToggleRow(parent, titleText, subtitleText, initialValue, callback)
    local r = Instance.new("Frame"); r.ClipsDescendants = true; r.Size = UDim2.new(1, 0, 0, 56)
    r.Parent = parent; uiCardStyle(r)
    local bar = uiAccentBar(r, true)

    local l = Instance.new("TextLabel")
    l.Position = UDim2.new(0, 14, 0, 8); l.Size = UDim2.new(1, -74, 0, 20)
    l.BackgroundTransparency = 1; l.RichText = true; l.Text = "<b><i>" .. string.upper(titleText) .. "</i></b>"; l.TextColor3 = Color3.fromRGB(255, 255, 255); l.TextSize = 13
    l.Font = Enum.Font.GothamBlack; l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = r

    local sub = Instance.new("TextLabel")
    sub.Position = UDim2.new(0, 14, 0, 28); sub.Size = UDim2.new(1, -74, 0, 18)
    sub.BackgroundTransparency = 1; sub.RichText = true; sub.Text = initialValue and "<b><i>STATUS: ENABLED</i></b>" or "<b><i>STATUS: DISABLED</i></b>"
    sub.TextColor3 = Color3.fromRGB(140, 140, 145); sub.TextSize = 10; sub.Font = Enum.Font.GothamBold; sub.TextXAlignment = Enum.TextXAlignment.Left; sub.Parent = r

    local tb = Instance.new("TextButton"); tb.Position = UDim2.new(1, -58, 0.5, -12); tb.Size = UDim2.new(0, 46, 0, 24)
    tb.BackgroundColor3 = initialValue and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(25, 25, 30); tb.BorderSizePixel = 0; tb.Text = ""; tb.AutoButtonColor = false; tb.Parent = r
    Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 12)
    local tStroke = Instance.new("UIStroke", tb); tStroke.Thickness = 1; tStroke.Color = Color3.fromRGB(50, 50, 55)

    local knob = Instance.new("Frame"); knob.Size = UDim2.new(0, 18, 0, 18); knob.BorderSizePixel = 0
    knob.Position = initialValue and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
    knob.BackgroundColor3 = initialValue and Color3.fromRGB(12, 12, 14) or Color3.fromRGB(120, 120, 125); knob.Parent = tb
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local state = initialValue
    local function set(v)
        state = v
        sub.Text = v and "<b><i>STATUS: ENABLED</i></b>" or "<b><i>STATUS: DISABLED</i></b>"
        sub.TextColor3 = v and Color3.fromRGB(220, 220, 225) or Color3.fromRGB(140, 140, 145)
        TweenService:Create(tb, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            BackgroundColor3 = v and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(25, 25, 30)
        }):Play()
        TweenService:Create(knob, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Position = v and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9),
            BackgroundColor3 = v and Color3.fromRGB(12, 12, 14) or Color3.fromRGB(120, 120, 125)
        }):Play()
    end

    tb.MouseButton1Click:Connect(function()
        set(not state)
        if callback then callback(state) end
        saveRykeConfig()
    end)
    return r, set
end

local function uiCardNumberRow(parent, titleText, subtitleText, initialValue, minV, maxV, callback)
    local r = Instance.new("Frame"); r.ClipsDescendants = true; r.Size = UDim2.new(1, 0, 0, 56)
    r.Parent = parent; uiCardStyle(r)
    local bar = uiAccentBar(r, true)

    local l = Instance.new("TextLabel")
    l.Position = UDim2.new(0, 14, 0, 8); l.Size = UDim2.new(1, -95, 0, 20)
    l.BackgroundTransparency = 1; l.RichText = true; l.Text = "<b><i>" .. string.upper(titleText) .. "</i></b>"; l.TextColor3 = Color3.fromRGB(255, 255, 255); l.TextSize = 13
    l.Font = Enum.Font.GothamBlack; l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = r

    local sub = Instance.new("TextLabel")
    sub.Position = UDim2.new(0, 14, 0, 28); sub.Size = UDim2.new(1, -95, 0, 18)
    sub.BackgroundTransparency = 1; sub.RichText = true; sub.Text = "<b><i>" .. string.upper(subtitleText or "VALUE") .. "</i></b>"
    sub.TextColor3 = Color3.fromRGB(140, 140, 145); sub.TextSize = 10; sub.Font = Enum.Font.GothamBold; sub.TextXAlignment = Enum.TextXAlignment.Left; sub.Parent = r

    local boxBg = Instance.new("Frame")
    boxBg.Position = UDim2.new(1, -80, 0.5, -13); boxBg.Size = UDim2.new(0, 68, 0, 26)
    boxBg.BackgroundColor3 = Color3.fromRGB(24, 24, 28); boxBg.Parent = r
    Instance.new("UICorner", boxBg).CornerRadius = UDim.new(0, 8)
    local bStroke = Instance.new("UIStroke", boxBg); bStroke.Thickness = 1; bStroke.Color = Color3.fromRGB(45, 45, 50)

    local bx = Instance.new("TextBox")
    bx.Size = UDim2.new(1, 0, 1, 0); bx.BackgroundTransparency = 1; bx.RichText = true; bx.Text = "<b><i>" .. tostring(initialValue) .. "</i></b>"
    bx.TextColor3 = Color3.fromRGB(255, 255, 255); bx.TextSize = 12; bx.Font = Enum.Font.GothamBlack; bx.Parent = boxBg

    bx.FocusLost:Connect(function()
        local n = tonumber(bx.Text:gsub("<[^>]+>", ""))
        if n and n >= minV and n <= maxV then
            bx.Text = "<b><i>" .. tostring(n) .. "</i></b>"
            if callback then callback(n) end
            saveRykeConfig()
        else
            bx.Text = "<b><i>" .. tostring(initialValue) .. "</i></b>"
        end
    end)
    return r, bx
end

local function uiCardChoiceRow(parent, titleText, subtitleText, options, defaultIndex, callback)
    local r = Instance.new("Frame"); r.ClipsDescendants = true; r.Size = UDim2.new(1, 0, 0, 56)
    r.Parent = parent; uiCardStyle(r)
    local bar = uiAccentBar(r, true)

    local l = Instance.new("TextLabel")
    l.Position = UDim2.new(0, 14, 0, 8); l.Size = UDim2.new(1, -120, 0, 20)
    l.BackgroundTransparency = 1; l.RichText = true; l.Text = "<b><i>" .. string.upper(titleText) .. "</i></b>"; l.TextColor3 = Color3.fromRGB(255, 255, 255); l.TextSize = 13
    l.Font = Enum.Font.GothamBlack; l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = r

    local sub = Instance.new("TextLabel")
    sub.Position = UDim2.new(0, 14, 0, 28); sub.Size = UDim2.new(1, -120, 0, 18)
    sub.BackgroundTransparency = 1; sub.RichText = true; sub.Text = "<b><i>" .. string.upper(subtitleText or "MODE") .. "</i></b>"
    sub.TextColor3 = Color3.fromRGB(140, 140, 145); sub.TextSize = 10; sub.Font = Enum.Font.GothamBold; sub.TextXAlignment = Enum.TextXAlignment.Left; sub.Parent = r

    local btnBg = Instance.new("TextButton")
    btnBg.Position = UDim2.new(1, -100, 0.5, -13); btnBg.Size = UDim2.new(0, 88, 0, 26)
    btnBg.BackgroundColor3 = Color3.fromRGB(24, 24, 28); btnBg.RichText = true; btnBg.Text = "<b><i>" .. string.upper(options[defaultIndex or 1]) .. "</i></b>"
    btnBg.TextColor3 = Color3.fromRGB(255, 255, 255); btnBg.TextSize = 11; btnBg.Font = Enum.Font.GothamBlack; btnBg.AutoButtonColor = false; btnBg.Parent = r
    Instance.new("UICorner", btnBg).CornerRadius = UDim.new(0, 8)
    local bStroke = Instance.new("UIStroke", btnBg); bStroke.Thickness = 1; bStroke.Color = Color3.fromRGB(45, 45, 50)

    local idx = defaultIndex or 1
    local function upd()
        btnBg.Text = "<b><i>" .. string.upper(options[idx]) .. "</i></b>"
        if callback then callback(options[idx]) end
        saveRykeConfig()
    end

    btnBg.MouseButton1Click:Connect(function()
        idx = idx % #options + 1
        upd()
    end)

    local function setVal(v)
        for i, o in ipairs(options) do
            if string.lower(tostring(o)) == string.lower(tostring(v)) then
                idx = i; btnBg.Text = "<b><i>" .. string.upper(o) .. "</i></b>"; break
            end
        end
    end

    return r, setVal
end

local function uiCardActionRow(parent, titleText, subtitleText, btnLabel, callback)
    local r = Instance.new("Frame"); r.ClipsDescendants = true; r.Size = UDim2.new(1, 0, 0, 56)
    r.Parent = parent; uiCardStyle(r)
    local bar = uiAccentBar(r, true)

    local l = Instance.new("TextLabel")
    l.Position = UDim2.new(0, 14, 0, 8); l.Size = UDim2.new(1, -110, 0, 20)
    l.BackgroundTransparency = 1; l.RichText = true; l.Text = "<b><i>" .. string.upper(titleText) .. "</i></b>"; l.TextColor3 = Color3.fromRGB(255, 255, 255); l.TextSize = 13
    l.Font = Enum.Font.GothamBlack; l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = r

    local sub = Instance.new("TextLabel")
    sub.Position = UDim2.new(0, 14, 0, 28); sub.Size = UDim2.new(1, -110, 0, 18)
    sub.BackgroundTransparency = 1; sub.RichText = true; sub.Text = "<b><i>" .. string.upper(subtitleText or "ACTION") .. "</i></b>"
    sub.TextColor3 = Color3.fromRGB(140, 140, 145); sub.TextSize = 10; sub.Font = Enum.Font.GothamBold; sub.TextXAlignment = Enum.TextXAlignment.Left; sub.Parent = r

    local btn = Instance.new("TextButton")
    btn.Position = UDim2.new(1, -95, 0.5, -13); btn.Size = UDim2.new(0, 82, 0, 26)
    btn.BackgroundColor3 = Color3.fromRGB(28, 28, 34); btn.RichText = true; btn.Text = "<b><i>" .. string.upper(btnLabel or "RUN") .. "</i></b>"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255); btn.TextSize = 11; btn.Font = Enum.Font.GothamBlack; btn.AutoButtonColor = false; btn.Parent = r
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    local bStroke = Instance.new("UIStroke", btn); bStroke.Thickness = 1; bStroke.Color = Color3.fromRGB(50, 50, 55)

    btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
    return r, btn
end

local function uiMakePage(parent, name, order, vis)
    local p = Instance.new("ScrollingFrame"); p.Name = name; p.Visible = vis ~= false; p.LayoutOrder = order
    p.Size = UDim2.new(1, 0, 1, 0); p.BackgroundTransparency = 1; p.BorderSizePixel = 0
    p.ScrollBarThickness = 4
    p.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
    p.ScrollBarImageTransparency = 0.4
    p.ScrollingEnabled = true
    p.ScrollingDirection = Enum.ScrollingDirection.Y
    p.ElasticBehavior = Enum.ElasticBehavior.Always
    p.AutomaticCanvasSize = Enum.AutomaticSize.Y
    p.CanvasSize = UDim2.new(0, 0, 0, 0)
    p.Parent = parent
    local l = Instance.new("UIListLayout"); l.Padding = UDim.new(0, 8); pcall(function() l.SortOrder = Enum.SortOrder.LayoutOrder end); l.Parent = p
    local pd = Instance.new("UIPadding")
    pd.PaddingTop = UDim.new(0, 2)
    pd.PaddingBottom = UDim.new(0, 30)
    pd.PaddingRight = UDim.new(0, 6)
    pd.PaddingLeft = UDim.new(0, 2)
    pd.Parent = p
    uiAutoCanvas(p)
    return p
end

local function uiMakeTabButton(parent, name, text, active)
    local b = Instance.new("TextButton"); b.Name = name
    b.Size = UDim2.new(1, 0, 0, 32)
    b.BackgroundColor3 = active and Color3.fromRGB(32, 32, 38) or Color3.fromRGB(0, 0, 0)
    b.BackgroundTransparency = active and 0 or 1
    b.BorderSizePixel = 0
    b.RichText = true
    b.Text = "<b><i>" .. string.upper(text) .. "</i></b>"
    b.TextColor3 = active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(130, 130, 135)
    b.TextSize = 12; b.Font = Enum.Font.GothamBlack; b.AutoButtonColor = false; b.Parent = parent
    b.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)

    local pad = Instance.new("UIPadding", b)
    pad.PaddingLeft = UDim.new(0, 20)

    local bar = Instance.new("Frame")
    bar.Name = "ActiveBar"
    bar.Position = UDim2.new(0, 6, 0.5, -8)
    bar.Size = UDim2.new(0, 3, 0, 16)
    bar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    bar.BackgroundTransparency = active and 0 or 1
    bar.BorderSizePixel = 0
    bar.Parent = b
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 2)

    b:SetAttribute("IsActiveTab", active and true or false)

    b.MouseEnter:Connect(function()
        if not b:GetAttribute("IsActiveTab") then
            TweenService:Create(b, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                TextColor3 = Color3.fromRGB(200, 200, 205)
            }):Play()
        end
    end)
    b.MouseLeave:Connect(function()
        if not b:GetAttribute("IsActiveTab") then
            TweenService:Create(b, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                TextColor3 = Color3.fromRGB(130, 130, 135)
            }):Play()
        end
    end)

    return b
end


local function uiSizeChangerRow(parent, titleText, subtitleText, getValueFn, setValueFn, stepVal, minV, maxV, isFloat)
    local r = Instance.new("Frame"); r.ClipsDescendants = true; r.Size = UDim2.new(1, 0, 0, 56)
    r.Parent = parent; uiCardStyle(r)
    local bar = uiAccentBar(r, true)

    local l = Instance.new("TextLabel")
    l.Position = UDim2.new(0, 14, 0, 8); l.Size = UDim2.new(0.48, 0, 0, 20)
    l.BackgroundTransparency = 1; l.RichText = true; l.Text = "<b><i>" .. string.upper(titleText) .. "</i></b>"; l.TextColor3 = Color3.fromRGB(255, 255, 255); l.TextSize = 12
    l.Font = Enum.Font.GothamBlack; l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = r

    local sub = Instance.new("TextLabel")
    sub.Position = UDim2.new(0, 14, 0, 28); sub.Size = UDim2.new(0.48, 0, 0, 18)
    sub.BackgroundTransparency = 1; sub.RichText = true; sub.Text = "<b><i>" .. string.upper(subtitleText or "SIZE CONTROL") .. "</i></b>"
    sub.TextColor3 = Color3.fromRGB(140, 140, 145); sub.TextSize = 10; sub.Font = Enum.Font.GothamBold; sub.TextXAlignment = Enum.TextXAlignment.Left; sub.Parent = r

    -- Control Container Right: Minus Button, TextBox, Plus Button
    local ctr = Instance.new("Frame", r)
    ctr.Position = UDim2.new(1, -150, 0.5, -13)
    ctr.Size = UDim2.new(0, 140, 0, 26)
    ctr.BackgroundTransparency = 1

    local minusBtn = Instance.new("TextButton", ctr)
    minusBtn.Size = UDim2.new(0, 28, 1, 0)
    minusBtn.Position = UDim2.new(0, 0, 0, 0)
    minusBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
    minusBtn.RichText = true; minusBtn.Text = "<b><i>-</i></b>"
    minusBtn.TextColor3 = Color3.fromRGB(255, 255, 255); minusBtn.TextSize = 14; minusBtn.Font = Enum.Font.GothamBlack
    minusBtn.AutoButtonColor = false
    Instance.new("UICorner", minusBtn).CornerRadius = UDim.new(0, 6)
    local mSt = Instance.new("UIStroke", minusBtn); mSt.Thickness = 1; mSt.Color = Color3.fromRGB(45, 45, 50)

    local boxBg = Instance.new("Frame", ctr)
    boxBg.Position = UDim2.new(0, 34, 0, 0)
    boxBg.Size = UDim2.new(0, 72, 1, 0)
    boxBg.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
    Instance.new("UICorner", boxBg).CornerRadius = UDim.new(0, 6)
    local bSt = Instance.new("UIStroke", boxBg); bSt.Thickness = 1; bSt.Color = Color3.fromRGB(45, 45, 50)

    local bx = Instance.new("TextBox", boxBg)
    bx.Size = UDim2.new(1, 0, 1, 0); bx.BackgroundTransparency = 1; bx.RichText = true
    local curVal = getValueFn()
    bx.Text = isFloat and string.format("<b><i>%.2f</i></b>", curVal) or string.format("<b><i>%d</i></b>", math.floor(curVal))
    bx.TextColor3 = Color3.fromRGB(255, 255, 255); bx.TextSize = 11; bx.Font = Enum.Font.GothamBlack

    local plusBtn = Instance.new("TextButton", ctr)
    plusBtn.Size = UDim2.new(0, 28, 1, 0)
    plusBtn.Position = UDim2.new(1, -28, 0, 0)
    plusBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
    plusBtn.RichText = true; plusBtn.Text = "<b><i>+</i></b>"
    plusBtn.TextColor3 = Color3.fromRGB(255, 255, 255); plusBtn.TextSize = 14; plusBtn.Font = Enum.Font.GothamBlack
    plusBtn.AutoButtonColor = false
    Instance.new("UICorner", plusBtn).CornerRadius = UDim.new(0, 6)
    local pSt = Instance.new("UIStroke", plusBtn); pSt.Thickness = 1; pSt.Color = Color3.fromRGB(45, 45, 50)

    local function applyVal(v)
        v = math.clamp(v, minV, maxV)
        setValueFn(v)
        bx.Text = isFloat and string.format("<b><i>%.2f</i></b>", v) or string.format("<b><i>%d</i></b>", math.floor(v))
        saveRykeConfig()
    end

    minusBtn.MouseButton1Click:Connect(function()
        applyVal(getValueFn() - stepVal)
    end)

    plusBtn.MouseButton1Click:Connect(function()
        applyVal(getValueFn() + stepVal)
    end)

    bx.FocusLost:Connect(function()
        local n = tonumber(bx.Text:gsub("<[^>]+>", ""))
        if n then
            applyVal(n)
        else
            local v = getValueFn()
            bx.Text = isFloat and string.format("<b><i>%.2f</i></b>", v) or string.format("<b><i>%d</i></b>", math.floor(v))
        end
    end)

    return r
end


function M.buildGui()
    applyAccentFromTheme()
    M.clearPersistentConns()

    local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800, 600)

    for _, n in ipairs({"RykeHubUI", "YahyaHubUI", "MoveeDuels", "Cherry_Menu", "K7HubGUI", "RykeToggleUI"}) do
        pcall(function()
            local parent = getSafeGuiParent()
            if parent then
                local old = parent:FindFirstChild(n)
                if old then old:Destroy() end
            end
        end)
    end

    M.buildStatusUI()

    -- ALWAYS FORCE MENU OPEN ON LOAD
    M.menuOpen = true

    local gui = Instance.new("ScreenGui")
    gui.Name = "RykeHubUI"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    pcall(function() gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling end)
    gui.DisplayOrder = 30
    gui.Parent = getSafeGuiParent()

    -- MAIN HUB FRAME: Spawns Dead-Center of Screen
    local Frame = Instance.new("Frame")
    Frame.Name = "RykeHubFrame"
    Frame.ClipsDescendants = true
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    Frame.Size = UDim2.new(0, M.menuWidth or 560, 0, M.menuHeight or 450)
    Frame.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
    Frame.BorderSizePixel = 0
    Frame.Active = true
    Frame.Visible = true
    Frame.Parent = gui
    M.mainFrame = Frame

    -- Restore saved window position (if any)
    if M.menuFramePos and type(M.menuFramePos) == "table"
       and type(M.menuFramePos.sx) == "number" and type(M.menuFramePos.ox) == "number"
       and type(M.menuFramePos.sy) == "number" and type(M.menuFramePos.oy) == "number" then
        Frame.Position = UDim2.new(M.menuFramePos.sx, M.menuFramePos.ox, M.menuFramePos.sy, M.menuFramePos.oy)
    end

    local UIScale = Instance.new("UIScale")
    UIScale.Name = "BDUIScale"
    UIScale.Scale = M.uiScale or 0.7
    UIScale.Parent = Frame
    M.uiScaleRef = UIScale

    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 16)
    frameCorner.Parent = Frame

    local mainStroke = Instance.new("UIStroke")
    mainStroke.Name = "MainStroke"
    mainStroke.Color = Color3.fromRGB(35, 35, 40)
    mainStroke.Thickness = 1.4
    mainStroke.Parent = Frame

    -- Apply background image if customBgId is set
    M.applyCustomBackground(Frame)

    -- PROMINENT SQUARE FLOATING TOGGLE BUTTON NAMED RYKE (46x46px)
    local toggleGui = Instance.new("ScreenGui")
    toggleGui.Name = "RykeToggleUI"
    toggleGui.ResetOnSpawn = false
    toggleGui.IgnoreGuiInset = true
    pcall(function() toggleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling end)
    toggleGui.DisplayOrder = 35
    toggleGui.Parent = getSafeGuiParent()

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Name = "RykeToggleSquare"
    toggleBtn.Position = UDim2.new(0, 16, 0.35, 0)
    toggleBtn.Size = UDim2.new(0, 46, 0, 46) -- Square Formed
    toggleBtn.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
    toggleBtn.BackgroundTransparency = 0.1
    toggleBtn.RichText = true
    toggleBtn.Text = "<b><i>RYKE</i></b>"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.TextSize = 11
    toggleBtn.Font = Enum.Font.GothamBlack
    toggleBtn.TextStrokeTransparency = 0   -- thicker stroke
    toggleBtn.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    toggleBtn.AutoButtonColor = false
    toggleBtn.Active = true
    toggleBtn.Parent = toggleGui

    -- Clean Rounded Corners (10px)
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 10)
    local tgStroke = Instance.new("UIStroke", toggleBtn)
    tgStroke.Thickness = 1.4; tgStroke.Color = Color3.fromRGB(60, 60, 70); tgStroke.Transparency = 0.2

    toggleBtn.MouseButton1Click:Connect(function()
        M.menuOpen = not M.menuOpen
        Frame.Visible = M.menuOpen
        saveRykeConfig()
    end)

    -- Draggable Toggle Button
    do
        local dragging, dragStart, startPos
        toggleBtn.InputBegan:Connect(function(inp)
            if M.uiLocked then return end
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = inp.Position
                startPos = toggleBtn.Position
            end
        end)
        UIS.InputChanged:Connect(function(inp)
            if M.uiLocked then dragging = false; return end
            if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
                local delta = inp.Position - dragStart
                local nx = math.clamp(startPos.X.Offset + delta.X, 0, vp.X - 50)
                local ny = math.clamp(startPos.Y.Offset + delta.Y, 0, vp.Y - 30)
                toggleBtn.Position = UDim2.new(0, nx, 0, ny)
            end
        end)
        UIS.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                if dragging then
                    dragging = false
                    M.toggleBtnPos = { x = toggleBtn.Position.X.Offset, y = toggleBtn.Position.Y.Offset }
                    saveRykeConfig()
                end
            end
        end)
        -- Restore saved toggle button position
        if M.toggleBtnPos and type(M.toggleBtnPos.x) == "number" and type(M.toggleBtnPos.y) == "number" then
            toggleBtn.Position = UDim2.new(0, math.clamp(M.toggleBtnPos.x, 0, vp.X - 50), 0, math.clamp(M.toggleBtnPos.y, 0, vp.Y - 30))
        end
    end

    -- TOP HEADER BAR (Draggable Main Window)
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 52)
    Header.BackgroundTransparency = 1
    Header.Active = true
    Header.Parent = Frame

    local titleBar = Instance.new("Frame")
    titleBar.Position = UDim2.new(0, 16, 0.5, -9)
    titleBar.Size = UDim2.new(0, 3, 0, 18)
    titleBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = Header
    Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 2)

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Position = UDim2.new(0, 26, 0.5, -10)
    titleLbl.Size = UDim2.new(0, 160, 0, 20)
    titleLbl.BackgroundTransparency = 1
    titleLbl.RichText = true
    titleLbl.Text = "<b><i>RYKE DUELS</i></b>"
    titleLbl.Font = Enum.Font.GothamBlack
    titleLbl.TextStrokeTransparency = 0.3
    titleLbl.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    titleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLbl.TextSize = 16
    titleLbl.Font = Enum.Font.GothamBlack
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = Header

    -- Header Right: Stats & Action Badges Container
    local badgeBar = Instance.new("Frame")
    badgeBar.Position = UDim2.new(1, -260, 0.5, -14)
    badgeBar.Size = UDim2.new(0, 246, 0, 28)
    badgeBar.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    badgeBar.Parent = Header
    Instance.new("UICorner", badgeBar).CornerRadius = UDim.new(0, 12)
    local bStroke = Instance.new("UIStroke", badgeBar)
    bStroke.Thickness = 1; bStroke.Color = Color3.fromRGB(32, 32, 38)

    local badgeLayout = Instance.new("UIListLayout", badgeBar)
    pcall(function() badgeLayout.FillDirection = Enum.FillDirection.Horizontal end)
    pcall(function() badgeLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right end)
    pcall(function() badgeLayout.VerticalAlignment = Enum.VerticalAlignment.Center end)
    badgeLayout.Padding = UDim.new(0, 6)

    local bPad = Instance.new("UIPadding", badgeBar)
    bPad.PaddingRight = UDim.new(0, 4)
    bPad.PaddingLeft = UDim.new(0, 8)

    local statsLbl = Instance.new("TextLabel")
    statsLbl.Size = UDim2.new(0, 130, 1, 0)
    statsLbl.BackgroundTransparency = 1
    statsLbl.RichText = true
    statsLbl.Text = "<b><i>60 FPS  15 MS  NORMAL</i></b>"
    statsLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    statsLbl.TextSize = 10
    statsLbl.Font = Enum.Font.GothamBlack
    statsLbl.TextXAlignment = Enum.TextXAlignment.Center
    statsLbl.Parent = badgeBar

    task.spawn(function()
        local frameCount = 0
        local lastTime = tick()
        local fps = 60
        local conn
        conn = RunService.RenderStepped:Connect(function()
            if not statsLbl or not statsLbl.Parent then
                if conn then conn:Disconnect() end
                return
            end
            frameCount = frameCount + 1
            local now = tick()
            if now - lastTime >= 1 then
                fps = math.floor(frameCount / (now - lastTime) + 0.5)
                frameCount = 0
                lastTime = now
                local ping = 15
                pcall(function()
                    local st = game:GetService("Stats")
                    local net = st and st.Network and st.Network.ServerStatsItem and st.Network.ServerStatsItem["Data Ping"]
                    if net then ping = math.floor(net:GetValue() + 0.5) end
                end)
                local modeTag = "NORMAL"
                if M.carrySpeedActive then modeTag = "CARRY"
                elseif M.laggerModeEnabled then modeTag = "LAGGER"
                elseif M.laggerCarryActive then modeTag = "L.CARRY" end

                statsLbl.Text = string.format("<b><i>%d FPS  %d MS  %s</i></b>", fps, ping, modeTag)
            end
        end)
    end)

    local lockBtn = Instance.new("TextButton")
    lockBtn.Size = UDim2.new(0, 50, 0, 22)
    lockBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
    lockBtn.RichText = true
    lockBtn.Text = M.uiLocked and "<b><i>LOCKED</i></b>" or "<b><i>LOCK</i></b>"
    lockBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    lockBtn.TextSize = 9; lockBtn.Font = Enum.Font.GothamBlack
    lockBtn.AutoButtonColor = false
    lockBtn.Parent = badgeBar
    Instance.new("UICorner", lockBtn).CornerRadius = UDim.new(0, 8)
    local lStroke = Instance.new("UIStroke", lockBtn); lStroke.Thickness = 1; lStroke.Color = Color3.fromRGB(45, 45, 50)

    lockBtn.MouseButton1Click:Connect(function()
        M.uiLocked = not M.uiLocked
        lockBtn.Text = M.uiLocked and "<b><i>LOCKED</i></b>" or "<b><i>LOCK</i></b>"
        saveRykeConfig()
    end)

    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0, 26, 0, 22)
    minBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
    minBtn.RichText = true
    minBtn.Text = "<b><i>-</i></b>"
    minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minBtn.TextSize = 14; minBtn.Font = Enum.Font.GothamBlack
    minBtn.AutoButtonColor = false
    minBtn.Parent = badgeBar
    Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 8)
    local mStroke = Instance.new("UIStroke", minBtn); mStroke.Thickness = 1; mStroke.Color = Color3.fromRGB(45, 45, 50)

    minBtn.MouseButton1Click:Connect(function()
        M.menuOpen = false
        Frame.Visible = false
        saveRykeConfig()
    end)

    -- Window Dragging Logic (Supports Both Touch and Mouse)
    do
        local dragging, dragStart, startPos
        local function initDrag(inp)
            if M.uiLocked then return end
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = inp.Position
                startPos = Frame.Position
            end
        end
        Header.InputBegan:Connect(initDrag)
        Frame.InputBegan:Connect(function(inp)
            if M.uiLocked then return end
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                if inp.Position.Y < Frame.AbsolutePosition.Y + 54 then
                    initDrag(inp)
                end
            end
        end)
        UIS.InputChanged:Connect(function(inp)
            if M.uiLocked then dragging = false; return end
            if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
                local delta = inp.Position - dragStart
                -- Use actual rendered size (accounting for UIScale) to clamp inside viewport
                local absSize = Frame.AbsoluteSize
                local halfW, halfH = absSize.X * 0.5, absSize.Y * 0.5
                local nx = math.clamp(startPos.X.Offset + delta.X, -vp.X/2 + halfW, vp.X/2 - halfW)
                local ny = math.clamp(startPos.Y.Offset + delta.Y, -vp.Y/2 + halfH, vp.Y/2 - halfH)
                Frame.Position = UDim2.new(startPos.X.Scale, nx, startPos.Y.Scale, ny)
            end
        end)
        UIS.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                if dragging then
                    dragging = false
                    -- Auto-save window position after drag
                    M.menuFramePos = { sx = Frame.Position.X.Scale, ox = Frame.Position.X.Offset, sy = Frame.Position.Y.Scale, oy = Frame.Position.Y.Offset }
                    saveRykeConfig()
                end
            end
        end)
    end

    -- LEFT NAVIGATION SIDEBAR
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Position = UDim2.new(0, 10, 0, 54)
    Sidebar.Size = UDim2.new(0, 140, 1, -64)
    Sidebar.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = Frame
    Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 12)
    local sbStroke = Instance.new("UIStroke", Sidebar); sbStroke.Thickness = 1; sbStroke.Color = Color3.fromRGB(30, 30, 35)

    local tabList = Instance.new("Frame")
    tabList.Size = UDim2.new(1, -12, 1, -34)
    tabList.Position = UDim2.new(0, 6, 0, 8)
    tabList.BackgroundTransparency = 1
    tabList.Parent = Sidebar

    local tabLayout = Instance.new("UIListLayout", tabList)
    pcall(function() tabLayout.FillDirection = Enum.FillDirection.Vertical end)
    pcall(function() tabLayout.SortOrder = Enum.SortOrder.LayoutOrder end)
    tabLayout.Padding = UDim.new(0, 4)

    local TMovement = uiMakeTabButton(tabList, "Tab_MOVEMENT", "MOVEMENT", true); TMovement.LayoutOrder = 1
    local TCombat   = uiMakeTabButton(tabList, "Tab_COMBAT",   "COMBAT",   false); TCombat.LayoutOrder = 2
    local TSteal    = uiMakeTabButton(tabList, "Tab_STEAL",    "STEAL",    false); TSteal.LayoutOrder = 3
    local TKeybinds = uiMakeTabButton(tabList, "Tab_KEYBINDS", "KEYBINDS", false); TKeybinds.LayoutOrder = 4
    local TVisuals  = uiMakeTabButton(tabList, "Tab_VISUALS",  "VISUALS",  false); TVisuals.LayoutOrder = 5
    local TSettings = uiMakeTabButton(tabList, "Tab_SETTINGS", "SETTINGS", false); TSettings.LayoutOrder = 6

    local footerBar = Instance.new("Frame", Sidebar)
    footerBar.Position = UDim2.new(0, 12, 1, -20)
    footerBar.Size = UDim2.new(0, 3, 0, 12)
    footerBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    footerBar.BorderSizePixel = 0
    Instance.new("UICorner", footerBar).CornerRadius = UDim.new(0, 2)

    local footerLbl = Instance.new("TextLabel", Sidebar)
    footerLbl.Position = UDim2.new(0, 20, 1, -22)
    footerLbl.Size = UDim2.new(1, -24, 0, 16)
    footerLbl.BackgroundTransparency = 1
    footerLbl.RichText = true
    footerLbl.Text = "<b><i>DISCORD.GG/RYKEDUELS</i></b>"
    footerLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    footerLbl.TextSize = 9; footerLbl.Font = Enum.Font.GothamBlack
    footerLbl.TextXAlignment = Enum.TextXAlignment.Left

    -- RIGHT CONTENT AREA
    local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.Position = UDim2.new(0, 158, 0, 54)
    Content.Size = UDim2.new(1, -168, 1, -64)
    Content.BackgroundTransparency = 1
    Content.Parent = Frame

    local PMovement = uiMakePage(Content, "Page_MOVEMENT", 1, true)
    local PCombat   = uiMakePage(Content, "Page_COMBAT",   2, false)
    local PSteal    = uiMakePage(Content, "Page_STEAL",    3, false)
    local PKeybinds = uiMakePage(Content, "Page_KEYBINDS", 4, false)
    local PVisuals  = uiMakePage(Content, "Page_VISUALS",  5, false)
    local PSettings = uiMakePage(Content, "Page_SETTINGS", 6, false)

    local Pages = {
        MOVEMENT = PMovement,
        COMBAT   = PCombat,
        STEAL    = PSteal,
        KEYBINDS = PKeybinds,
        VISUALS  = PVisuals,
        SETTINGS = PSettings,
    }

    local Tabs = {
        MOVEMENT = TMovement,
        COMBAT   = TCombat,
        STEAL    = TSteal,
        KEYBINDS = TKeybinds,
        VISUALS  = TVisuals,
        SETTINGS = TSettings,
    }

    local curTab = "MOVEMENT"
    local function switchTab(name)
        if curTab == name then return end
        curTab = name
        for k, p in pairs(Pages) do p.Visible = (k == name) end
        for k, b in pairs(Tabs) do
            local act = (k == name)
            b:SetAttribute("IsActiveTab", act)
            b.BackgroundColor3 = act and Color3.fromRGB(32, 32, 38) or Color3.fromRGB(0, 0, 0)
            b.BackgroundTransparency = act and 0 or 1
            b.TextColor3 = act and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(130, 130, 135)
            local bar = b:FindFirstChild("ActiveBar")
            if bar then bar.BackgroundTransparency = act and 0 or 1 end
        end
    end
    M.selectTab = switchTab

    TMovement.MouseButton1Click:Connect(function() switchTab("MOVEMENT") end)
    TCombat.MouseButton1Click:Connect(function() switchTab("COMBAT") end)
    TSteal.MouseButton1Click:Connect(function() switchTab("STEAL") end)
    TKeybinds.MouseButton1Click:Connect(function() switchTab("KEYBINDS") end)
    TVisuals.MouseButton1Click:Connect(function() switchTab("VISUALS") end)
    TSettings.MouseButton1Click:Connect(function() switchTab("SETTINGS") end)

    -- PAGE: MOVEMENT
    local _, autoCarryTog = uiCardToggleRow(PMovement, "Auto Carry Speed", "AUTOMATIC CARRY TOGGLE", M.autoSwitchSpeedEnabled, function(on)
        M.autoSwitchSpeedEnabled = on
        M._autoSwitchWasSteal = nil
        M.refreshWalkSpeedAutoSwitch()
        saveRykeConfig()
    end)
    M.setAutoCarryVisual = autoCarryTog

    local _, nsBox = uiCardNumberRow(PMovement, "Normal Speed", "WALK SPEED VALUE", M.NS, 1, 500, function(v) M.NS = v end)
    local _, csBox = uiCardNumberRow(PMovement, "Carry Speed", "CARRY SPEED VALUE", M.CS, 1, 500, function(v) M.CS = v end)
    M.normalBox = nsBox; M.carryBox = csBox

    local _, carryChoice = uiCardChoiceRow(PMovement, "Speed Mode", "ACTIVE SPEED MODE", {"NORMAL", "CARRY"}, M.carrySpeedActive and 2 or 1, function(opt)
        M.carrySpeedActive = (opt == "CARRY")
        if M.carrySpeedActive then M.laggerCarryActive = false end
        saveRykeConfig()
    end)

    local _, lsBox = uiCardNumberRow(PMovement, "Lagger Speed", "LAGGER NORMAL VALUE", M.LAGGER_SPEED, 1, 500, function(v) M.LAGGER_SPEED = v end)
    local _, lcBox = uiCardNumberRow(PMovement, "Lagger Carry Speed", "LAGGER CARRY VALUE", math.min(M.LAGGER_CARRY_SPEED, 23), 1, 23, function(v) M.LAGGER_CARRY_SPEED = math.min(v, 23) end)

    local _, lagChoice = uiCardChoiceRow(PMovement, "Lagger Mode", "LAGGER STATE", {"NORMAL", "LAGGER", "LAG CARRY"},
        M.laggerModeEnabled and 2 or (M.laggerCarryActive and 3 or 1),
        function(opt)
            if opt == "LAGGER" then
                M.laggerModeEnabled = true; M.laggerCarryActive = false
            elseif opt == "LAG CARRY" then
                M.laggerCarryActive = true; M.laggerModeEnabled = false
            else
                M.laggerModeEnabled = false; M.laggerCarryActive = false
            end
            saveRykeConfig()
        end
    )

    local _, autoTurnOff = uiCardToggleRow(PMovement, "Auto Turn Off Speed", "AUTO DISABLE SPEED", M.autoTurnOffSpeedEnabled, function(on)
        M.autoTurnOffSpeedEnabled = on
        M.refreshWalkSpeedAutoSwitch()
        saveRykeConfig()
    end)
    M.setAutoTurnOffVisual = autoTurnOff

    local _, autoLagSwitch = uiCardToggleRow(PMovement, "Auto Switch Lagger", "AUTO LAGGER TOGGLE", M.autoSwitchLaggerSpeedEnabled, function(on)
        M.autoSwitchLaggerSpeedEnabled = on
        M.refreshWalkSpeedAutoSwitch()
        saveRykeConfig()
    end)
    M.setAutoSwitchLaggerVisual = autoLagSwitch

    -- PAGE: COMBAT
    local _, setBatAimbot = uiCardToggleRow(PCombat, "Bat Aimbot", "AUTO TARGET LOCK", M.autoBatEnabled, function(on)
        if on then M.queueAutoBatStart() else M.stopBatAimbot() end
    end)
    M.autoBatSetVisual = setBatAimbot

    local _, setBypassVis = uiCardToggleRow(PCombat, "Bat TP", "SOFT TELEPORT BAT", M.bypassAimbotEnabled, function(on)
        M.bypassAimbotEnabled = on
        if on then M.startBypassAimbot() else M.stopBypassAimbot() end
        if M.mobBtnRefs.bypass then M.mobBtnRefs.bypass(on) end
        saveRykeConfig()
    end)
    M.setBypassVisual = setBypassVis

    local _, setBatCounter = uiCardToggleRow(PCombat, "Bat Counter", "AUTO SLAP COUNTER", M.batCounterEnabled, function(on)
        M.batCounterEnabled = on
        if on then M.startBatCounter() else M.stopBatCounter() end
    end)
    M.setBatCounterVisual = setBatCounter

    local _, setAntiRag = uiCardToggleRow(PCombat, "Anti Ragdoll", "PREVENT FALL STATE", M.antiRagdollEnabled, function(on)
        M.antiRagdollEnabled = on
        if on then M.startAntiRagdoll() else M.stopAntiRagdoll() end
    end)
    M.setAntiRagVisual = setAntiRag

    local _, setAntiRagModeUI = uiCardChoiceRow(PCombat, "Anti Ragdoll Mode", "RAGDOLL RESET TYPE", {"Splatter", "No Splatter"},
        M.antiRagdollMode == "No Splatter" and 2 or 1,
        function(newMode)
            M.antiRagdollMode = (newMode == "No Splatter") and "No Splatter" or "Splatter"
            if M.antiRagdollEnabled then M.stopAntiRagdoll(); M.startAntiRagdoll() end
        end
    )
    M.setAntiRagModeUI = setAntiRagModeUI

    local _, setMedusa = uiCardToggleRow(PCombat, "Medusa Counter", "AUTO MEDUSA REFLECT", M.medusaCounterEnabled, function(on)
        M.medusaCounterEnabled = on
        if on then M.setupMedusa(player.Character) else M.stopMedusaCounter() end
    end)
    M.setMedusaVisual = setMedusa

    local _, setMedReset = uiCardToggleRow(PCombat, "Medusa Reset", "AUTO CURSED RESET", M.medusaResetEnabled, function(on)
        M.medusaResetEnabled = on
    end)
    M.setMedusaResetVisual = setMedReset

    local _, setAutoSwing = uiCardToggleRow(PCombat, "Auto Swing", "CONTINUOUS SWING", M.autoSwingEnabled, function(on)
        M.autoSwingEnabled = on
    end)
    M.setAutoSwingVisual = setAutoSwing

    local _, setAutoResetOnDeath = uiCardToggleRow(PCombat, "Auto Reset on Death", "FAST RESPAWN", M.autoResetOnDeath, function(on)
        M.autoResetOnDeath = on
        setupDeathReset()
    end)
    M.setAutoResetOnDeath = setAutoResetOnDeath

    -- PAGE: STEAL
    local _, setAutoSteal = uiCardToggleRow(PSteal, "Auto Steal", "AUTOMATIC PET GRAB", M.Steal.AutoStealEnabled, function(on)
        M.Steal.AutoStealEnabled = on
        if on then M.startAutoSteal() else M.stopAutoSteal() end
    end)
    M.setInstaGrab = setAutoSteal

    local _, setStealModeChoice = uiCardChoiceRow(PSteal, "Steal Mode", "GRABBER ALGORITHM", {"V1", "V2", "V3"},
        (M.stealMode == "V2" or M.stealMode == "Semi") and 2 or (M.stealMode == "V3" and 3 or 1),
        function(mode)
            local oldMode = M.stealMode
            M.stealMode = mode
            if oldMode ~= M.stealMode and M.Steal.AutoStealEnabled then
                M.stopAutoSteal(); M.startAutoSteal()
            end
            M.updateStatusRadius()
        end
    )
    M.setStealModeUI = setStealModeChoice

    local _, srBox = uiCardNumberRow(PSteal, "Grab Radius", "DISTANCE IN STUDS", M.Steal.StealRadius, 0.5, 300, function(v)
        M.Steal.StealRadius = v; M.setStealRadius(v); M.updateStatusRadius()
    end)
    M.radInput = srBox

    local _, sdBox = uiCardNumberRow(PSteal, "Hold Duration", "HOLD TIME IN SECONDS", M.Steal.StealDuration, 0.1, 10, function(v)
        M.Steal.StealDuration = v
    end)
    M.durationBox = sdBox

    uiSizeChangerRow(PSteal, "Steal Bar Size", "BAR WIDTH IN PIXELS",
        function() return M.stealBarSize end,
        function(v) M.stealBarSize = math.floor(v+0.5); M.buildStatusUI() end,
        10, 100, 600, false)

    local _, setAutoRadius = uiCardToggleRow(PSteal, "Auto Radius", "DYNAMIC RADIUS MATCH", M.autoRadiusEnabled, function(on)
        M.autoRadiusEnabled = on; M.updateStatusRadius()
    end)
    M.setAutoRadiusVisual = setAutoRadius

    -- PAGE: KEYBINDS
    M._anyKeyListening = false
    local activeKBBtn = nil
    M.keybindButtons = M.keybindButtons or {}
    local listeningTimeout = nil

    local function resetKeybindCapture()
        if activeKBBtn then
            for e, b in pairs(M.keybindButtons) do
                if b == activeKBBtn then
                    local parts = {}
                    if e.kb then table.insert(parts, e.kb.Name) end
                    if e.gp then table.insert(parts, e.gp.Name) end
                    b.Text = (#parts > 0) and "<b><i>" .. string.upper(table.concat(parts, " / ")) .. "</i></b>" or "<b><i>NONE</i></b>"
                    break
                end
            end
            activeKBBtn = nil
            M._anyKeyListening = false
            if listeningTimeout then task.cancel(listeningTimeout); listeningTimeout = nil end
        end
    end

    local function formatKeybindText(entry)
        if not entry then return "<b><i>NONE</i></b>" end
        local parts = {}
        if entry.kb then table.insert(parts, entry.kb.Name) end
        if entry.gp then table.insert(parts, entry.gp.Name) end
        if #parts == 0 then return "<b><i>NONE</i></b>" end
        return "<b><i>" .. string.upper(table.concat(parts, " / ")) .. "</i></b>"
    end

    local function uiKeybindRow(parent, titleText, subtitleText, kbEntry)
        local r = Instance.new("Frame"); r.ClipsDescendants = true; r.Size = UDim2.new(1, 0, 0, 56)
        r.Parent = parent; uiCardStyle(r)
        local bar = uiAccentBar(r, true)

        local l = Instance.new("TextLabel")
        l.Position = UDim2.new(0, 14, 0, 8); l.Size = UDim2.new(1, -120, 0, 20)
        l.BackgroundTransparency = 1; l.RichText = true; l.Text = "<b><i>" .. string.upper(titleText) .. "</i></b>"; l.TextColor3 = Color3.fromRGB(255, 255, 255); l.TextSize = 13
        l.Font = Enum.Font.GothamBlack; l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = r

        local sub = Instance.new("TextLabel")
        sub.Position = UDim2.new(0, 14, 0, 28); sub.Size = UDim2.new(1, -120, 0, 18)
        sub.BackgroundTransparency = 1; sub.RichText = true; sub.Text = "<b><i>" .. string.upper(subtitleText or "KEYBIND") .. "</i></b>"
        sub.TextColor3 = Color3.fromRGB(140, 140, 145); sub.TextSize = 10; sub.Font = Enum.Font.GothamBold; sub.TextXAlignment = Enum.TextXAlignment.Left; sub.Parent = r

        local btn = Instance.new("TextButton")
        btn.Position = UDim2.new(1, -110, 0.5, -13); btn.Size = UDim2.new(0, 98, 0, 26)
        btn.BackgroundColor3 = Color3.fromRGB(24, 24, 28); btn.RichText = true; btn.Text = formatKeybindText(kbEntry)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255); btn.TextSize = 10; btn.Font = Enum.Font.GothamBlack; btn.AutoButtonColor = false; btn.Parent = r
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        local bStroke = Instance.new("UIStroke", btn); bStroke.Thickness = 1; bStroke.Color = Color3.fromRGB(45, 45, 50)

        M.keybindButtons[kbEntry] = btn

        btn.MouseButton1Click:Connect(function()
            if activeKBBtn and activeKBBtn ~= btn then resetKeybindCapture() end
            activeKBBtn = btn
            btn.Text = "<b><i>PRESS KEY...</i></b>"
            M._anyKeyListening = true
            if listeningTimeout then task.cancel(listeningTimeout) end
            listeningTimeout = task.delay(8, resetKeybindCapture)
        end)
        return r
    end

    uiKeybindRow(PKeybinds, "Hide GUI", "TOGGLE MENU VISIBILITY", M.KB.GuiHide)
    uiKeybindRow(PKeybinds, "Carry Mode", "SPEED MODE TOGGLE", M.KB.SpeedToggle)
    uiKeybindRow(PKeybinds, "Lagger Mode", "LAGGER MODE TOGGLE", M.KB.LaggerToggle)
    uiKeybindRow(PKeybinds, "Bat Aimbot", "BAT LOCK TOGGLE", M.KB.AutoBat)
    uiKeybindRow(PKeybinds, "Bat TP", "BAT TELEPORT TOGGLE", M.KB.BypassAimbot)
    uiKeybindRow(PKeybinds, "Auto Left", "AUTO LEFT DANCE", M.KB.AutoLeft)
    uiKeybindRow(PKeybinds, "Auto Right", "AUTO RIGHT DANCE", M.KB.AutoRight)
    uiKeybindRow(PKeybinds, "Drop Brainrot", "DROP ITEM INSTANT", M.KB.DropBrainrot)
    uiKeybindRow(PKeybinds, "TP Down", "TELEPORT TO FLOOR", M.KB.TPFloor)

    -- KEYBIND CAPTURE LISTENER (auto-saves on capture)
    M._keybindCaptureConn = M._keybindCaptureConn
    pcall(function() if M._keybindCaptureConn then M._keybindCaptureConn:Disconnect() end end)
    M._keybindCaptureConn = UIS.InputBegan:Connect(function(inp, gpe)
        if gpe then return end
        if not activeKBBtn then return end
        if inp.UserInputType == Enum.UserInputType.Keyboard then
            local entry = nil
            for e, b in pairs(M.keybindButtons) do
                if b == activeKBBtn then entry = e; break end
            end
            if entry then
                if inp.KeyCode == Enum.KeyCode.Escape then
                    resetKeybindCapture()
                    return
                end
                entry.kb = (inp.KeyCode ~= Enum.KeyCode.Unknown) and inp.KeyCode or nil
                entry.gp = nil
                activeKBBtn.Text = formatKeybindText(entry)
                activeKBBtn = nil
                M._anyKeyListening = false
                if listeningTimeout then task.cancel(listeningTimeout); listeningTimeout = nil end
                saveRykeConfig() -- AUTO-SAVE keybind immediately
            end
        end
    end)
    local skyNames = M.SkyOrder
    local skyIdx = 1
    for i, s in ipairs(skyNames) do if s == M.currentSkyTheme then skyIdx = i break end end
    local _, skyChoice = uiCardChoiceRow(PVisuals, "Sky Theme", "ENVIRONMENT SKY", skyNames, skyIdx, function(t)
        M.currentSkyTheme = t
        M.CandyApplyCustomSky(t)
        saveRykeConfig()
    end)

    local fovIdx = 1
    for i, f in ipairs(M.fovOptions) do if f == M.fovValue then fovIdx = i break end end
    local fovOpts = {"80", "120", "180"}
    local _, fovChoice = uiCardChoiceRow(PVisuals, "FOV", "FIELD OF VIEW", fovOpts, fovIdx, function(v)
        M.fovValue = tonumber(v) or 80
        M.applyFOV()
        saveRykeConfig()
    end)

    local _, setLineESP = uiCardToggleRow(PVisuals, "Line ESP", "TRACER LINES TO PLAYERS", M.lineESPEnabled, function(on)
        M.lineESPEnabled = on; cherryESPState.LineESP = on
    end)

    local _, setSpeedESP = uiCardToggleRow(PVisuals, "Speed ESP", "OVERHEAD SPEED DISPLAY", M.speedESPEnabled, function(on)
        M.speedESPEnabled = on; cherryESPState.SpeedESP = on
    end)

    -- PAGE: SETTINGS
    local _, setInfJump = uiCardToggleRow(PSettings, "Infinite Jump", "UNLIMITED AIR JUMPS", M.infJumpEnabled, function(on)
        M.infJumpEnabled = on
        if on and M.infJumpMode == "manual" then M.startManualInfJumpLoop()
        elseif on and M.infJumpMode == "hold" then M.startHoldInfJump()
        else M.stopManualInfJumpLoop(); M.stopHoldInfJump() end
    end)
    M.setInfJumpVisual = setInfJump

    local _, setJumpModeChoice = uiCardChoiceRow(PSettings, "Jump Mode", "INFINITE JUMP TYPE", {"MANUAL", "HOLD"}, M.infJumpMode == "hold" and 2 or 1, function(mode)
        local wasOn = M.infJumpEnabled
        M.infJumpMode = (mode == "HOLD") and "hold" or "manual"
        if wasOn then
            M.stopManualInfJumpLoop(); M.stopHoldInfJump()
            if M.infJumpMode == "manual" then M.startManualInfJumpLoop()
            else M.startHoldInfJump() end
        end
    end)

    local _, setAL = uiCardToggleRow(PSettings, "Auto Left", "AUTOMATIC LEFT DANCE", M.autoLeftEnabled, function(on)
        if on then
            if M.autoRightEnabled then M.autoRightEnabled = false; M.stopAutoRight(); if M.autoRightSetVisual then M.autoRightSetVisual(false) end end
            if M.autoBatEnabled then M.stopBatAimbot(); if M.autoBatSetVisual then M.autoBatSetVisual(false) end end
            M.autoLeftEnabled = true; M.startAutoLeft()
        else M.autoLeftEnabled = false; M.stopAutoLeft() end
        if M.mobBtnRefs.autoLeft then M.mobBtnRefs.autoLeft(on) end
    end)
    M.autoLeftSetVisual = setAL

    local _, setAR = uiCardToggleRow(PSettings, "Auto Right", "AUTOMATIC RIGHT DANCE", M.autoRightEnabled, function(on)
        if on then
            if M.autoLeftEnabled then M.autoLeftEnabled = false; M.stopAutoLeft(); if M.autoLeftSetVisual then M.autoLeftSetVisual(false) end end
            if M.autoBatEnabled then M.stopBatAimbot(); if M.autoBatSetVisual then M.autoBatSetVisual(false) end end
            M.autoRightEnabled = true; M.startAutoRight()
        else M.autoRightEnabled = false; M.stopAutoRight() end
        if M.mobBtnRefs.autoRight then M.mobBtnRefs.autoRight(on) end
    end)
    M.autoRightSetVisual = setAR

    local _, setATP = uiCardToggleRow(PSettings, "Auto TP Down", "TELEPORT ON AIR", M.autoTPEnabled, function(on)
        M.autoTPEnabled = on
        if on then M.startAutoTP() else M.stopAutoTP() end
    end)
    M.setAutoTPVisual = setATP

    local _, setUnwalk = uiCardToggleRow(PSettings, "Unwalk", "FREEZE WALK ANIMATION", M.unwalkEnabled, function(on)
        M.unwalkEnabled = on
        if on then M.startUnwalk() else M.stopUnwalk() end
    end)
    M.setUnwalkVisual = setUnwalk

    local _, setAntiLag = uiCardToggleRow(PSettings, "Anti-Lag", "PERFORMANCE OPTIMIZER", M.antiLagEnabled, function(on)
        M.antiLagEnabled = on
        if on then M.enableAntiLag() else M.disableAntiLag() end
        saveRykeConfig()
    end)
    M.setAntiLagVisual = setAntiLag

    local _, setAntiSummer = uiCardToggleRow(PSettings, "Anti Summer Base", "CLEAR BLOCKING MAP ANCHORS", M.antiSummerBaseEnabled, function(on)
        M.antiSummerBaseEnabled = on
        if on then M.enableAntiSummerBase() else M.disableAntiSummerBase() end
        saveRykeConfig()
    end)
    M.setAntiSummerVisual = setAntiSummer

    local _, setStretch = uiCardToggleRow(PSettings, "Stretch Rez", "STRETCHED CAMERA REZ", M.stretchRezEnabled, function(on)
        M.stretchRezEnabled = on
        if on then M.enableStretchRez() else M.disableStretchRez() end
    end)
    M.setStretchRezVisual = setStretch

    local _, setAntiKick = uiCardToggleRow(PSettings, "Anti-Kick", "DISCONNECT PROTECTION", M.antiKickEnabled, function(on)
        M.antiKickEnabled = on
        if on then M.enableAntiKick() else M.disableAntiKick() end
        saveRykeConfig()
    end)
    M.antiKickSetVisual = setAntiKick

    local _, setSafeMode = uiCardToggleRow(PSettings, "Safe Mode", "SAFE DUEL LOCK", M.safeModeEnabled, function(on)
        M.safeModeEnabled = on
        if on then M.enableSafeMode() else M.disableSafeMode() end
        saveRykeConfig()
    end)
    M.setSafeModeVisual = setSafeMode

    local packNames = {}
    for name in pairs(M.PACKS) do table.insert(packNames, name) end
    table.sort(packNames)
    local packDefaultIdx = 1
    for i, v in ipairs(packNames) do if v == M.animPack then packDefaultIdx = i break end end

    local _, packChoice = uiCardChoiceRow(PSettings, "Animation Pack", "CHARTER ANIMATIONS", packNames, packDefaultIdx, function(pack)
        M.animPack = pack
        if M.animPackEnabled then M.applyAnimPack(pack) end
        saveRykeConfig()
    end)

    local _, setHeadless = uiCardToggleRow(PSettings, "Headless", "INVIS HEAD CHARTER", M.headlessEnabled, function(on)
        M.headlessEnabled = on
        M.applyHeadlessToChar(player.Character, on)
        saveRykeConfig()
    end)

    local _, setKorblox = uiCardToggleRow(PSettings, "Korblox", "KORBLOX LEG CHARTER", M.korbloxEnabled, function(on)
        M.korbloxEnabled = on
        M.applyKorbloxToChar(player.Character, on)
        saveRykeConfig()
    end)

    local _, setMobBtns = uiCardToggleRow(PSettings, "Mobile Buttons", "FLOATING BUTTONS", M.mobileButtonsEnabled, function(on)
        M.mobileButtonsEnabled = on
        if on then M.buildMobileButtons() else M.destroyMobileButtons() end
        saveRykeConfig()
    end)

    -- Mobile Buttons Size changer (- / textbox / +)
    uiSizeChangerRow(PSettings, "Mobile Buttons Size", "FLOATING BUTTON SIZE",
        function() return M.mobileButtonsSize end,
        function(v)
            M.mobileButtonsSize = math.floor(v + 0.5)
            if M.mobileButtonsEnabled then M.buildMobileButtons() end
        end,
        5, 50, 200, false)

    -- Main GUI Size changers: width + height
    uiSizeChangerRow(PSettings, "GUI Width", "MAIN MENU WIDTH",
        function() return M.menuWidth end,
        function(v)
            M.menuWidth = math.floor(v + 0.5)
            if M.mainFrame then
                M.mainFrame.Size = UDim2.new(0, M.menuWidth, 0, M.menuHeight)
            end
        end,
        10, 360, 1200, false)

    uiSizeChangerRow(PSettings, "GUI Height", "MAIN MENU HEIGHT",
        function() return M.menuHeight end,
        function(v)
            M.menuHeight = math.floor(v + 0.5)
            if M.mainFrame then
                M.mainFrame.Size = UDim2.new(0, M.menuWidth, 0, M.menuHeight)
            end
        end,
        10, 300, 1000, false)

    uiCardActionRow(PSettings, "Save Settings", "SAVE CONFIGURATION", "SAVE", function()
        saveRykeConfig()
    end)

    uiCardActionRow(PSettings, "Reset Settings", "RESTORE DEFAULTS", "RESET", function()
        M.resetAllSettings()
    end)

    M.startHeadSpeedUpdates()
end


-- RYKE DUELS INITIALIZATION


-- ============================================================
-- RYKE DUELS INITIALIZATION


-- ============================================================
-- RYKE DUELS INITIALIZATION
-- ============================================================
pcall(function() loadRykeConfig() end)
pcall(function() applyAccentFromTheme() end)

-- Mobile UI scale adjustment (only default on first run; saved value wins)
local isTouch = false
pcall(function() isTouch = UIS.TouchEnabled end)
if isTouch and not M._uiScaleSetByConfig then
    M.uiScale = 0.7
end

-- FORCE MENU OPEN & BUILD ALL GUIS IMMEDIATELY
M.menuOpen = true
pcall(function() M.buildGui() end)
pcall(function() M.buildStatusUI() end)
pcall(function() if M.mobileButtonsEnabled ~= false then M.buildMobileButtons() end end)

-- Start the speed loop (applies Normal/Carry/Lagger via WalkSpeed)
pcall(function() M.startSpeedLoop() end)
pcall(function() M.startHeadSpeedUpdates() end)
pcall(function() M.updateAutoSwitchSpeed() end)
pcall(function() M.refreshWalkSpeedAutoSwitch() end)

-- Apply feature states
if M.antiRagdollEnabled then pcall(function() M.startAntiRagdoll() end) end
if M.infJumpEnabled then
    if M.infJumpMode == "manual" then pcall(function() M.startManualInfJumpLoop() end)
    elseif M.infJumpMode == "hold" then pcall(function() M.startHoldInfJump() end) end
end
if M.medusaCounterEnabled then pcall(function() M.setupMedusa(player.Character) end) end
if M.batCounterEnabled then pcall(function() M.startBatCounter() end) end
if M.unwalkEnabled then pcall(function() M.startUnwalk() end) end
if M.autoTPEnabled then pcall(function() M.startAutoTP() end) end
if M.autoBatEnabled then pcall(function() M.queueAutoBatStart() end) end
if M.autoLeftEnabled then pcall(function() M.startAutoLeft() end) end
if M.autoRightEnabled then pcall(function() M.startAutoRight() end) end
if M.Steal and M.Steal.AutoStealEnabled then pcall(function() M.startAutoSteal() end) end
if M.bypassAimbotEnabled then pcall(function() M.startBypassAimbot() end) end
if M.antiKickEnabled then pcall(function() M.enableAntiKick() end) end
if M.antiLagEnabled then pcall(function() M.enableAntiLag() end) end
if M.antiSummerBaseEnabled then pcall(function() M.enableAntiSummerBase() end) end
if M.stretchRezEnabled then pcall(function() M.enableStretchRez() end) end
if M.removeAccEnabled then pcall(function() M.startRemoveAcc() end) end

if player and player.Character then
    pcall(function() M.setupHeadIndicator(player.Character) end)
    pcall(function() M.setupRagdollTriggers() end)
    -- Apply saved animations (anim pack + headless + korblox) on first spawn too
    if M.animPackEnabled and M.animPack then
        task.spawn(function() pcall(function() M.applyAnimPack(M.animPack) end) end)
    end
    if M.headlessEnabled or M.korbloxEnabled then
        pcall(function() M.applyCharterToChar(player.Character) end)
    end
end

-- AUTO-RESPAWN: respawn instantly when you die (no waiting on ground)
-- Fires the balloon reset remote + LoadCharacter for fastest reliable respawn.
do
    local function hookDied(char)
        if not char then return end
        local hum = char:WaitForChild("Humanoid", 10)
        if not hum then return end
        hum.Died:Connect(function()
            if M._respawning then return end
            M._respawning = true
            -- Fire cached reset remotes so server knows we're resetting
            task.spawn(function()
                if M.cursedResetRemote then
                    pcall(function() M.cursedResetRemote:FireServer(M.CURSED_RESET_GUID, player, "balloon") end)
                end
                if M._cachedResetRemotes then
                    for _, r in ipairs(M._cachedResetRemotes) do
                        pcall(function() r:FireServer() end)
                    end
                end
            end)
            -- Brief wait so server registers death, then force respawn
            task.wait(0.15)
            pcall(function() player:LoadCharacter() end)
            task.delay(2, function() M._respawning = false end)
        end)
    end
    if player.Character then hookDied(player.Character) end
    player.CharacterAdded:Connect(function(char)
        M._respawning = false
        -- Wait for character to fully load
        task.wait(0.3)
        pcall(function() M.setupHeadIndicator(char) end)
        pcall(function() M.setupRagdollTriggers() end)
        -- Re-apply animations (anim pack + headless + korblox) on every respawn
        if M.animPackEnabled and M.animPack then
            task.wait(0.4)
            pcall(function() M.applyAnimPack(M.animPack) end)
        end
        if M.headlessEnabled or M.korbloxEnabled then
            task.wait(0.2)
            pcall(function() M.applyCharterToChar(char) end)
        end
        if M.medusaCounterEnabled then pcall(function() M.setupMedusa(char) end) end
        if M.batCounterEnabled then pcall(function() M.startBatCounter() end) end
        if M.unwalkEnabled then pcall(function() M.startUnwalk() end) end
        if M.bypassAimbotEnabled then
            task.wait(0.2)
            pcall(function() M.startBypassAimbot() end)
        end
        if M.autoTPEnabled then pcall(function() M.startAutoTP() end) end
        -- Restart speed loop
        pcall(function() M.startSpeedLoop() end)
        -- Hook died on new character
        hookDied(char)
    end)
end

pcall(function() M.CandyApplyCustomSky(M.currentSkyTheme or "Night") end)
pcall(function() M.updateStatusRadius() end)
pcall(function() M.startHeadSpeedUpdates() end)

print("RYKE DUELS loaded successfully!")
return M