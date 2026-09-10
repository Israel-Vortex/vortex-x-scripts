-- ==========================================
-- VORTEX X SOFTWARE V3.2.7 [DMvSS] - WIND UI
-- MULTI-EXECUTOR (PC, Delta, Hydrogen, CodeX, etc.)
-- ==========================================

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- Global aliases for module compatibility
local player = LocalPlayer
local camera = Camera

-- ==========================================
-- SAFE FUNCTIONS FOR MOBILE AND PC
-- ==========================================
local function copyToClipboard(text)
    pcall(function()
        if setclipboard then setclipboard(text)
        elseif setclip then setclip(text)
        elseif toclipboard then toclipboard(text) end
    end)
end

local hasDrawing = (type(Drawing) == "table" or type(Drawing) == "userdata") and Drawing.new ~= nil
local teamCheckEnabled = true

-- ==========================================
-- BASE LOGIC & IDENTITY DETECT (IMPROVED TEAM DETECTION)
-- ==========================================
local myGame, myTeam = nil, nil

local function refreshIdentity()
    pcall(function()
        myGame = LocalPlayer:GetAttribute("Game")
        myTeam = LocalPlayer:GetAttribute("Team")
    end)
end

local function isLobbyTeamName(name)
    if not name then return false end
    local n = string.lower(tostring(name))
    return n:find("lobby", 1, true) or n:find("spect", 1, true)
        or n:find("menu", 1, true) or n:find("dead", 1, true) or n:find("wait", 1, true)
end

-- ALLY: same Game + same Team (DMvSS attributes)
local function isAlly(plr)
    if not plr or plr == LocalPlayer then return false end

    local plrGame = plr:GetAttribute("Game")
    local plrTeam = plr:GetAttribute("Team")

    if myGame ~= nil and myTeam ~= nil and plrGame ~= nil and plrTeam ~= nil then
        return plrGame == myGame and plrTeam == myTeam
    end

    if LocalPlayer.Team and plr.Team then
        if isLobbyTeamName(LocalPlayer.Team.Name) or isLobbyTeamName(plr.Team.Name) then
            return false
        end
        return LocalPlayer.Team == plr.Team
    end

    return false
end

-- ENEMY: same Game + different Team. No data = do not mark (prevents ESPing everyone)
local function isEnemy(plr)
    if not plr or plr == LocalPlayer then return false end

    if not teamCheckEnabled then
        if myGame ~= nil and myTeam ~= nil then
            local plrGame = plr:GetAttribute("Game")
            return plrGame == myGame and not isAlly(plr)
        end
        return false
    end

    local plrGame = plr:GetAttribute("Game")
    local plrTeam = plr:GetAttribute("Team")

    if myGame ~= nil and myTeam ~= nil and plrGame ~= nil and plrTeam ~= nil then
        return plrGame == myGame and plrTeam ~= myTeam
    end

    if LocalPlayer.Team and plr.Team then
        if isLobbyTeamName(LocalPlayer.Team.Name) or isLobbyTeamName(plr.Team.Name) then
            return false
        end
        return LocalPlayer.Team ~= plr.Team
    end

    return false
end

task.spawn(function()
    while true do
        refreshIdentity()
        task.wait(1)
    end
end)

-- ==========================================
-- PROTECTION PC (gethui / protect_gui / hooks)
-- ==========================================
local spoofedSizes = {}
local spoofedCanCollide = {}
local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local function _randName(len)
    len = len or 12
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local out = ""
    for i = 1, len do
        local r = math.random(1, #chars)
        out = out .. string.sub(chars, r, r)
    end
    return out
end

-- Nombres tipo juego (menos sospechosos que Vortex/Astra/Invis)
local function _gameLikeName()
    local prefixes = { "Camera", "Effect", "Track", "Bind", "Cache", "Proxy", "Node", "Slot", "Layer", "Buffer", "Mesh", "Anim" }
    return prefixes[math.random(1, #prefixes)] .. _randName(8)
end

local function _safeCloneref(obj)
    local ok, res = pcall(function()
        if cloneref then return cloneref(obj) end
        return obj
    end)
    return (ok and res) or obj
end

local function _protectInstance(gui)
    if not gui then return end
    pcall(function()
        if syn and syn.protect_gui then syn.protect_gui(gui) end
    end)
    pcall(function()
        if protect_gui then protect_gui(gui) end
    end)
    pcall(function()
        if gethui and hide_gui then hide_gui(gui) end
    end)
end

local function _setHiddenParent(gui)
    local parented = false
    pcall(function()
        if gethui then
            gui.Parent = gethui()
            parented = true
        end
    end)
    if not parented then
        pcall(function()
            if syn and syn.protect_gui then syn.protect_gui(gui) end
            gui.Parent = CoreGui
            parented = true
        end)
    end
    if not parented then
        pcall(function()
            gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
        end)
    end
end

-- Spoof Size / CanCollide (hitbox) sin romper lecturas del caller
pcall(function()
    if not (getrawmetatable and setreadonly and checkcaller) then return end
    local gm = getrawmetatable(game)
    local oldIndex = gm.__index
    local wrap = function(self, key)
        if not checkcaller() then
            local spoofSize = spoofedSizes[self]
            if spoofSize and key == "Size" then return spoofSize end
            local spoofCollide = spoofedCanCollide[self]
            if spoofCollide ~= nil and key == "CanCollide" then return spoofCollide end
        end
        return oldIndex(self, key)
    end
    setreadonly(gm, false)
    if newcclosure then
        gm.__index = newcclosure(wrap)
    else
        gm.__index = wrap
    end
    setreadonly(gm, true)
end)

-- Contenedor oculto (nombre random, no "Vortex...")
local ProtectedGui = Instance.new("Folder")
ProtectedGui.Name = _gameLikeName()
_protectInstance(ProtectedGui)
_setHiddenParent(ProtectedGui)

-- Renombrar periodicamente en PC (menos predecible)
if not IsMobile then
    task.spawn(function()
        while task.wait(8) do
            pcall(function()
                if ProtectedGui and ProtectedGui.Parent then
                    ProtectedGui.Name = _gameLikeName()
                end
            end)
        end
    end)
end

local screenGui = ProtectedGui

-- Servicios cloneref (PC) para menos huella en algunas detecciones
local CoreGuiRef = _safeCloneref(CoreGui)
local PlayersRef = _safeCloneref(Players)

-- ==========================================
-- WIND UI SETUP & LOGIN NOTIFICATION
-- ==========================================
local WindUI = loadstring(game:HttpGet("https://github.com/MrSxxo/WindUI/releases/latest/download/main.lua"))()

if not WindUI then
    warn("Could not load WindUI. Your executor might not be compatible.")
    return
end

WindUI:Notify({
    Title = "Vortex x Software",
    Content = "Iniciando sesión... Por favor, espere.",
    Duration = 3
})

task.wait(2)

WindUI:Notify({
    Title = "Vortex x Software",
    Content = "Acceso concedido, " .. LocalPlayer.Name .. "! Interfaz de carga...",
    Duration = 2
})

task.wait(1)

local Window = WindUI:CreateWindow({
    Title = "Vortex x Software [DMvSS]",
    Icon = "rbxassetid://118833096342184",
    IconSize = "35",
    Author = "By Israelcc & Novak",
    Folder = "VortexXSoftware",
    Background = "rbxassetid://133044138027516",
    Size = UDim2.fromOffset(680, 520),
    MinSize = Vector2.new(480, 360),
    MaxSize = Vector2.new(1100, 800),
    Resizable = true,
    HideSearchBar = true,
    Transparent = false,
    Theme = "Dark",
    User = { Enabled = true, Anonymous = false }
})

Window:EditOpenButton({
    Title = "VXS",
    Icon = "rbxassetid://118833096342184",
    CornerRadius = UDim.new(1, 0),
    StrokeThickness = 2,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(160, 110, 20)),
        ColorSequenceKeypoint.new(0.4, Color3.fromRGB(220, 170, 40)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 215, 90))
    }),
    OnlyMobile = true,
    Enabled = true,
    Draggable = true,
})

pcall(function()
    Window:Label({
        Title = "3.2.7",
        Icon = "github",
        Color = Color3.fromRGB(220, 170, 40)
    })
end)

WindUI:AddTheme({
    Name = "VortexGoldSolid",
    Accent = Color3.fromRGB(255, 195, 45),
    Background = Color3.fromRGB(12, 12, 14),
    BackgroundTransparency = 0,
    Outline = Color3.fromRGB(255, 210, 70),
    Text = Color3.fromRGB(255, 255, 255),
    Placeholder = Color3.fromRGB(190, 190, 200),
    Button = Color3.fromRGB(210, 160, 35),
    Icon = Color3.fromRGB(255, 200, 60),
    Hover = Color3.fromRGB(255, 255, 255),
    WindowBackground = Color3.fromRGB(14, 14, 16),
    WindowShadow = Color3.fromRGB(255, 185, 50),
    DialogBackground = Color3.fromRGB(18, 18, 22),
    DialogBackgroundTransparency = 0,
    DialogTitle = Color3.fromRGB(255, 255, 255),
    DialogContent = Color3.fromRGB(235, 235, 240),
    DialogIcon = Color3.fromRGB(255, 200, 60),
    WindowTopbarButtonIcon = Color3.fromRGB(255, 255, 255),
    WindowTopbarTitle = Color3.fromRGB(255, 255, 255),
    WindowTopbarAuthor = Color3.fromRGB(210, 210, 220),
    WindowTopbarIcon = Color3.fromRGB(255, 200, 60),
    TabBackground = Color3.fromRGB(20, 20, 24),
    TabTitle = Color3.fromRGB(255, 255, 255),
    TabIcon = Color3.fromRGB(255, 205, 70),
    ElementBackground = Color3.fromRGB(24, 24, 30),
    ElementTitle = Color3.fromRGB(255, 255, 255),
    ElementDesc = Color3.fromRGB(200, 200, 210),
    ElementIcon = Color3.fromRGB(255, 205, 70),
    PopupBackground = Color3.fromRGB(18, 18, 22),
    PopupBackgroundTransparency = 0,
    PopupTitle = Color3.fromRGB(255, 255, 255),
    PopupContent = Color3.fromRGB(230, 230, 235),
    PopupIcon = Color3.fromRGB(255, 205, 70),
    Toggle = Color3.fromRGB(255, 195, 45),
    ToggleBar = Color3.fromRGB(40, 40, 50),
    Checkbox = Color3.fromRGB(40, 40, 50),
    CheckboxIcon = Color3.fromRGB(255, 255, 255),
    Slider = Color3.fromRGB(255, 195, 45),
    SliderThumb = Color3.fromRGB(255, 255, 255),
})

WindUI:SetTheme("VortexGoldSolid")
Window:SetToggleKey(Enum.KeyCode.K)
Window:OnClose(function() end)

-- ==========================================
-- HELPER FUNCTIONS FOR COMBAT MODULE
-- ==========================================
local function showBottomMessage(msg)
    WindUI:Notify({ Title = "Vortex x Software", Content = msg, Duration = 2 })
end

-- forward refs (FPS/Ping + bubbles)
local showFpsPing = false
local fpsPingLabel = nil
local fpsScreenGui = nil
local editBubblesState = false

local function makeDraggable(trigger, target, canDragFn)
    local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
    trigger.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if canDragFn and not canDragFn() then return end
            dragging = true
            dragStart = input.Position
            startPos = target.Position
            input.UserInputConsumed = true
        end
    end)
    trigger.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            if canDragFn and not canDragFn() then
                dragging = false
                return
            end
            local delta = input.Position - dragStart
            target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    trigger.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

local function restoreSize(hrp)
    if spoofedSizes[hrp] then
        hrp.Size = spoofedSizes[hrp]
        spoofedSizes[hrp] = nil
    end
end

local function restoreCollide(hrp)
    if spoofedCanCollide[hrp] ~= nil then
        hrp.CanCollide = spoofedCanCollide[hrp]
        spoofedCanCollide[hrp] = nil
    end
end

local function setSpoofedSize(hrp, size)
    if not spoofedSizes[hrp] then spoofedSizes[hrp] = hrp.Size end
    hrp.Size = size
end

local function setSpoofedCollide(hrp, collide)
    if spoofedCanCollide[hrp] == nil then spoofedCanCollide[hrp] = hrp.CanCollide end
    hrp.CanCollide = collide
end

local hitboxAdornName = _gameLikeName()
local infectAttrName = _randName(10)
local silentTargetPart = nil -- local target (no getgenv Astra*)

-- ==========================================
-- CONTENEDORES DE TABS (SECTIONS)
-- ==========================================
local mainSection = Window:Section({ Title = "Popular", Opened = true })
local extraSection = Window:Section({ Title = "Extra", Opened = true })

-- ==========================================
-- ==========================================
-- INFO TAB
-- ==========================================
local InfoTab = mainSection:Tab({ Title = "Info", Icon = "info", ShowTabTitle = true, Border = true })
InfoTab:Select()

InfoTab:Section({ Title = "Acerca del Script" })

InfoTab:Paragraph({
    Title = "Vortex X Software [DMvSS]",
    Desc = "Script multi-executor para Duels (DMvSS).\nIncluye combate, ESP, visuales, farm, emotes y configuraciones.\nCompatible con PC y móvil (Delta, Hydrogen, CodeX, etc.).\n\nDesarrolladores: Israelcc & Novak\nUI: WindUI\nVersión: 3.2.7"
})

InfoTab:Paragraph({
    Title = "Desarrolladores",
    Desc = "Israelcc & Novak\nDesarrollo principal, mantenimiento y actualizaciones."
})

InfoTab:Divider()

InfoTab:Paragraph({
    Title = "Únete a nuestro Discord",
    Desc = "Únete a nuestra comunidad oficial para soporte, actualizaciones y hablar con otros miembros.\n\nhttps://discord.gg/Fn74MpzFUn",
    Image = "rbxassetid://88267176037146",
    ImageSize = 80
})

InfoTab:Button({
    Title = "Copiar enlace de Discord",
    Callback = function()
        pcall(function()
            if setclipboard then
                setclipboard("https://discord.gg/Fn74MpzFUn")
            elseif setclip then
                setclip("https://discord.gg/Fn74MpzFUn")
            elseif toclipboard then
                toclipboard("https://discord.gg/Fn74MpzFUn")
            end
        end)
        showBottomMessage("¡Link de Discord copiado al portapapeles!")
    end
})

InfoTab:Section({ Title = "Información del Servidor" })

local gameNameStr = "Desconocido"
pcall(function()
    gameNameStr = MarketplaceService:GetProductInfo(game.PlaceId).Name
end)

InfoTab:Paragraph({
    Title = "Juego Actual",
    Desc = gameNameStr .. "\nPlace ID: " .. tostring(game.PlaceId),
    Image = "rbxthumb://type=GameIcon&id=" .. tostring(game.GameId) .. "&w=150&h=150",
    ImageSize = 48
})

local nombreEjecutor = "Desconocido"
pcall(function()
    if identifyexecutor then
        nombreEjecutor = identifyexecutor()
    elseif getexecutorname then
        nombreEjecutor = getexecutorname()
    end
end)

InfoTab:Paragraph({
    Title = "Ejecutor",
    Desc = tostring(nombreEjecutor)
})

InfoTab:Section({ Title = "Monitor" })

InfoTab:Toggle({
    Title = "Mostrar FPS y Ping",
    Desc = "Activa o desactiva el contador fijo de FPS y Ping (no se mueve con las bubbles).",
    Default = false,
    Callback = function(state)
        showFpsPing = state
        if fpsPingLabel then
            fpsPingLabel.Visible = state
        end
        if fpsScreenGui then
            fpsScreenGui.Enabled = state
        end
        showBottomMessage(state and "FPS/Ping: ON" or "FPS/Ping: OFF")
    end
})

-- =====================================
-- ========== EMOTES / ANIMACIONES ==========
-- (misma sección Extra, arriba de Config)
-- =====================================
local emotesTab = extraSection:Tab({ Title = "Emotes", Icon = "person-standing", ShowTabTitle = true, Border = true })

local animationData = {
    ["Old School"] = { Walk = 10921244891, Run = 10921240218, Jump = 10921242013, Fall = 10921241244, SwimIdle = 10921244018, Swim = 10921243048, Idle = 10921230744, Idle2 = 10921232093, Climb = 10921229866 },
    ["Adidas Sports"] = { Walk = 18537392113, Run = 18537384940, Jump = 18537380791, Fall = 18537367238, SwimIdle = 18537387180, Swim = 18537389531, Idle = 18537376492, Idle2 = 18537371272, Climb = 18537363391 },
    ["Adidas Community"] = { Walk = 122150855457006, Run = 82598234841035, Jump = 75290611992385, Fall = 98600215928904, SwimIdle = 109346520324160, Swim = 133308483266208, Idle = 122257458498464, Idle2 = 102357151005774, Climb = 88763136693023 },
    ["Adidas Aura"] = { Walk = 83842218823011, Run = 118320322718866, Jump = 109996626521204, Fall = 95603166884636, SwimIdle = 94922130551805, Swim = 134530128383903, Idle = 110211186840347, Idle2 = 114191137265065, Climb = 97824616490448 },
    ["Wicked Popular"] = { Walk = 92072849924640, Run = 72301599441680, Jump = 104325245285198, Fall = 121152442762481, Idle = 118832222982049, Idle2 = 76049494037641, SwimIdle = 113199415118199, Swim = 99384245425157, Climb = 131326830509784 },
    ["Elder"] = { Walk = 10921111375, Run = 10921104374, Jump = 10921107367, Fall = 10921105765, SwimIdle = 10921110146, Swim = 10921108971, Idle = 10921101664, Idle2 = 10921102574, Climb = 10921100400 },
    ["Zombie"] = { Walk = 10921355261, Run = 616163682, Jump = 10921351278, Fall = 10921350320, SwimIdle = 10921353442, Swim = 10921352344, Idle = 10921344533, Idle2 = 10921345304, Climb = 10921343576 },
    ["Mage"] = { Walk = 10921152678, Run = 10921148209, Jump = 10921149743, Fall = 10921148939, SwimIdle = 10921151661, Swim = 10921150788, Idle = 10921144709, Idle2 = 10921145797, Climb = 10921143404 },
    ["Catwalk Glam"] = { Walk = 109168724482748, Run = 81024476153754, Jump = 116936326516985, Fall = 92294537340807, SwimIdle = 98854111361360, Swim = 134591743181628, Idle = 133806214992291, Idle2 = 94970088341563, Climb = 119377220967554 },
    ["Astronaut"] = { Walk = 10921046031, Run = 10921039308, Jump = 10921042494, Fall = 10921040576, SwimIdle = 10921045006, Swim = 10921044000, Idle = 10921034824, Idle2 = 10921036806, Climb = 10921032124 },
    ['Wicked "Dancing Through Life"'] = { Walk = 73718308412641, Run = 135515454877967, Jump = 78508480717326, Fall = 78147885297412, SwimIdle = 129183123083281, Swim = 110657013921774, Idle = 92849173543269, Idle2 = 132238900951109, Climb = 129447497744818 },
    ["Werewolf"] = { Walk = 10921342074, Run = 10921336997, Fall = 10921337907, SwimIdle = 10921341319, Swim = 10921340419, Idle = 10921330408, Idle2 = 10921333667, Climb = 10921329322 },
    ["Superhero"] = { Walk = 10921298616, Run = 10921291831, Jump = 10921294559, Fall = 10921293373, SwimIdle = 10921297391, Swim = 10921295495, Idle = 10921288909, Idle2 = 10921290167, Climb = 10921286911 },
    ["Toy"] = { Walk = 10921312010, Run = 10921306285, Jump = 10921308158, Fall = 10921307241, SwimIdle = 10921310341, Swim = 10921309319, Idle = 10921301576, Climb = 10921300839 },
    ["No Boundaries"] = { Walk = 18747074203, Run = 18747070484, Jump = 18747069148, Fall = 18747062535, SwimIdle = 18747071682, Swim = 18747073181, Idle = 18747067405, Idle2 = 18747063918, Climb = 18747060903 },
    ["NFL"] = { Walk = 110358958299415, Run = 117333533048078, Jump = 119846112151352, Fall = 129773241321032, SwimIdle = 79090109939093, Swim = 132697394189921, Idle = 92080889861410, Idle2 = 74451233229259, Climb = 134630013742019 },
    ["Amazon Unboxed"] = { Walk = 90478085024465, Run = 134824450619865, Jump = 121454505477205, Fall = 94788218468396, SwimIdle = 129126268464847, Swim = 105962919001086, Idle = 98281136301627, Climb = 121145883950231 },
    ["Vampire"] = { Walk = 10921326949, Run = 10921320299, Jump = 10921322186, Fall = 10921321317, SwimIdle = 10921325443, Swim = 10921324408, Idle = 10921315373, Climb = 10921314188 },
    ["Ninja"] = { Walk = 656121766, Run = 656118852, Jump = 656117878, Fall = 656115606, SwimIdle = 656121397, Swim = 656119721, Idle = 656117400, Idle2 = 656118341, Climb = 656114359 },
    ["Robot"] = { Walk = 616095330, Run = 616091570, Jump = 616090535, Fall = 616087089, SwimIdle = 616094091, Swim = 616092998, Idle = 616088211, Idle2 = 616089559, Climb = 616086039 },
    ["Levitation"] = { Walk = 616013216, Run = 616010382, Jump = 616008936, Fall = 616005863, SwimIdle = 616012453, Swim = 616011509, Idle = 616006778, Idle2 = 616008087, Climb = 616003713 },
    ["Stylish"] = { Walk = 616146177, Run = 616140816, Jump = 616139451, Fall = 616134815, SwimIdle = 616144772, Swim = 616143378, Idle = 616136790, Idle2 = 616138447, Climb = 616133594 },
    ["Bubbly"] = { Walk = 910034870, Run = 910025107, Jump = 910016857, Fall = 910001910, SwimIdle = 910030921, Swim = 910028158, Idle = 910004836, Idle2 = 910009958, Climb = 909997997 },
    ["Cartoon"] = { Walk = 742640026, Run = 742638842, Jump = 742637942, Fall = 742637151, SwimIdle = 742639812, Swim = 742639220, Idle = 742637544, Idle2 = 742638445, Climb = 742636889 }
}

local function clearAllAnimations()
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    for _, track in pairs(hum:GetPlayingAnimationTracks()) do
        track:Stop(0)
        track:Destroy()
    end
    local animator = hum:FindFirstChildOfClass("Animator")
    if animator then
        for _, track in pairs(animator:GetPlayingAnimationTracks()) do
            track:Stop(0)
            track:Destroy()
        end
    end
    task.wait(0.1)
end

local animacionActualActiva = nil
local misAnimacionesOriginales = nil

local function applyCustomAnims(customData)
    if not customData then return end
    local char = player.Character
    if not char then return end
    clearAllAnimations()

    local animate = char:FindFirstChild("Animate")
    if not animate then return end

    if not misAnimacionesOriginales then
        local function getAnim(folderName, animName)
            local folder = animate:FindFirstChild(folderName)
            if folder then
                local anim = folder:FindFirstChild(animName)
                if anim and anim:IsA("Animation") then
                    local idStr = anim.AnimationId:match("%d+")
                    if idStr then return tonumber(idStr) end
                end
            end
            return nil
        end

        misAnimacionesOriginales = {
            Idle = getAnim("idle", "Animation1") or 507766666,
            Idle2 = getAnim("idle", "Animation2") or 507766951,
            Walk = getAnim("walk", "WalkAnim") or 507777826,
            Run = getAnim("run", "RunAnim") or 507767714,
            Jump = getAnim("jump", "JumpAnim") or 507765000,
            Climb = getAnim("climb", "ClimbAnim") or 507765644,
            Fall = getAnim("fall", "FallAnim") or 507767968,
            Swim = getAnim("swim", "Swim") or 507784897,
            SwimIdle = getAnim("swimidle", "SwimIdle") or 507785072
        }
    end

    animate.Disabled = true
    task.wait(0.1)

    local function updateAnimation(folderName, animName, animId)
        if not animId then return end
        local folder = animate:FindFirstChild(folderName)
        if folder then
            local anim = folder:FindFirstChild(animName)
            if anim and anim:IsA("Animation") then
                anim.AnimationId = "rbxassetid://" .. tostring(animId)
            end
        end
    end

    updateAnimation("idle", "Animation1", customData.Idle)
    updateAnimation("idle", "Animation2", customData.Idle2 or customData.Idle)
    updateAnimation("walk", "WalkAnim", customData.Walk)
    updateAnimation("run", "RunAnim", customData.Run)
    updateAnimation("jump", "JumpAnim", customData.Jump)
    updateAnimation("climb", "ClimbAnim", customData.Climb)
    updateAnimation("fall", "FallAnim", customData.Fall)
    updateAnimation("swim", "Swim", customData.Swim)
    updateAnimation("swimidle", "SwimIdle", customData.SwimIdle or customData.Swim)

    task.wait(0.1)
    animate.Disabled = false

    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum:ChangeState(Enum.HumanoidStateType.Landed)
        task.wait(0.05)
        hum:ChangeState(Enum.HumanoidStateType.Running)
    end
end

task.spawn(function()
    while task.wait(1) do
        if animacionActualActiva then
            local char = player.Character
            if char then
                local animate = char:FindFirstChild("Animate")
                if animate then
                    local idleFolder = animate:FindFirstChild("idle")
                    if idleFolder then
                        local anim1 = idleFolder:FindFirstChild("Animation1")
                        if anim1 then
                            local currentId = anim1.AnimationId:match("%d+")
                            if currentId ~= tostring(animacionActualActiva.Idle) then
                                applyCustomAnims(animacionActualActiva)
                            end
                        end
                    end
                end
            end
        end
    end
end)

local animList = {"Ninguno"}
for name, _ in pairs(animationData) do
    table.insert(animList, name)
end
table.sort(animList)

emotesTab:Section({ Title = "Paquetes Completos" })

local selectedBundleCompleto = "Ninguno"
emotesTab:Dropdown({
    Title = "Elegir Paquete",
    Values = animList,
    Value = "Ninguno",
    Callback = function(Value)
        selectedBundleCompleto = Value
    end
})

emotesTab:Button({
    Title = "Aplicar Paquete Completo",
    Callback = function()
        if selectedBundleCompleto == "Ninguno" then return end
        task.spawn(function()
            showBottomMessage("Aplicando paquete: " .. selectedBundleCompleto)
            animacionActualActiva = animationData[selectedBundleCompleto]
            applyCustomAnims(animacionActualActiva)
        end)
    end
})

emotesTab:Button({
    Title = "Restaurar Default",
    Callback = function()
        task.spawn(function()
            local defaultAnims = misAnimacionesOriginales or {
                Idle = 507766666, Idle2 = 507766951, Walk = 507777826, Run = 507767714,
                Jump = 507765000, Climb = 507765644, Fall = 507767968, Swim = 507784897, SwimIdle = 507785072
            }
            animacionActualActiva = nil
            applyCustomAnims(defaultAnims)
            showBottomMessage("Animaciones de tu avatar restauradas.")
        end)
    end
})

emotesTab:Section({ Title = "Mezclador de Animaciones" })

local mixParts = {
    Idle = "Ninguno", Walk = "Ninguno", Run = "Ninguno",
    Jump = "Ninguno", Fall = "Ninguno", Climb = "Ninguno"
}

emotesTab:Dropdown({ Title = "Reposo", Values = animList, Value = "Ninguno", Callback = function(Value) mixParts.Idle = Value end })
emotesTab:Dropdown({ Title = "Caminar", Values = animList, Value = "Ninguno", Callback = function(Value) mixParts.Walk = Value end })
emotesTab:Dropdown({ Title = "Correr", Values = animList, Value = "Ninguno", Callback = function(Value) mixParts.Run = Value end })
emotesTab:Dropdown({ Title = "Saltar", Values = animList, Value = "Ninguno", Callback = function(Value) mixParts.Jump = Value end })
emotesTab:Dropdown({ Title = "Caer", Values = animList, Value = "Ninguno", Callback = function(Value) mixParts.Fall = Value end })
emotesTab:Dropdown({ Title = "Escalar", Values = animList, Value = "Ninguno", Callback = function(Value) mixParts.Climb = Value end })

emotesTab:Button({
    Title = "Combinar y Aplicar",
    Callback = function()
        task.spawn(function()
            local customMix = {}

            if mixParts.Idle ~= "Ninguno" and animationData[mixParts.Idle] then
                customMix.Idle = animationData[mixParts.Idle].Idle
                customMix.Idle2 = animationData[mixParts.Idle].Idle2
            end
            if mixParts.Walk ~= "Ninguno" and animationData[mixParts.Walk] then
                customMix.Walk = animationData[mixParts.Walk].Walk
            end
            if mixParts.Run ~= "Ninguno" and animationData[mixParts.Run] then
                customMix.Run = animationData[mixParts.Run].Run
            end
            if mixParts.Jump ~= "Ninguno" and animationData[mixParts.Jump] then
                customMix.Jump = animationData[mixParts.Jump].Jump
            end
            if mixParts.Fall ~= "Ninguno" and animationData[mixParts.Fall] then
                customMix.Fall = animationData[mixParts.Fall].Fall
            end
            if mixParts.Climb ~= "Ninguno" and animationData[mixParts.Climb] then
                customMix.Climb = animationData[mixParts.Climb].Climb
            end

            local hasValues = false
            for _, v in pairs(customMix) do
                if v then hasValues = true break end
            end

            if hasValues then
                showBottomMessage("Aplicando combinación de animaciones...")
                animacionActualActiva = customMix
                applyCustomAnims(animacionActualActiva)
            else
                showBottomMessage("Selecciona al menos una animación para combinar.")
            end
        end)
    end
})


local ConfigTab = extraSection:Tab({ Title = "Config", Icon = "settings", ShowTabTitle = true, Border = true })

ConfigTab:Toggle({
    Flag = "ToggleTest",
    Title = "Toggle Panel Background",
    Value = not Window.HidePanelBackground,
    Default = true,
    Callback = function(state)
        Window:SetPanelBackground(state)
    end,
})

pcall(function()
    Window:SetPanelBackground(true)
end)

ConfigTab:Input({
    Title = "Background Image ID",
    Desc = "Introduce el ID de Roblox (ej: rbxassetid://...) para cambiar el fondo",
    Value = "rbxassetid://133044138027516",
    Placeholder = "rbxassetid://...",
    Callback = function(input)
        pcall(function()
            Window:SetBackground(input)
        end)
    end,
})

ConfigTab:Divider()

local ConfigManager = Window.ConfigManager
local ConfigName = "default"

local ConfigNameInput = ConfigTab:Input({
    Title = "Config Name",
    Icon = "file-cog",
    Callback = function(value)
        ConfigName = value
    end,
})

ConfigTab:Space()

local AllConfigs = ConfigManager:AllConfigs()
local DefaultValue = table.find(AllConfigs, ConfigName) and ConfigName or nil

local AllConfigsDropdown = ConfigTab:Dropdown({
    Title = "All Configs",
    Desc = "Select existing configs",
    Values = AllConfigs,
    Value = DefaultValue,
    Callback = function(value)
        ConfigName = value
        ConfigNameInput:Set(value)
    end,
})

ConfigTab:Space()

ConfigTab:Button({
    Title = "Save Config",
    Icon = "",
    Justify = "Center",
    Callback = function()
        Window.CurrentConfig = ConfigManager:Config(ConfigName)
        if Window.CurrentConfig:Save() then
            WindUI:Notify({
                Title = "Config Saved",
                Content = "Config '" .. ConfigName .. "' saved",
                Icon = "check",
            })
        end

        AllConfigsDropdown:Refresh(ConfigManager:AllConfigs())
    end,
})

ConfigTab:Space()

ConfigTab:Button({
    Title = "Load Config",
    Icon = "",
    Justify = "Center",
    Callback = function()
        Window.CurrentConfig = ConfigManager:CreateConfig(ConfigName)
        if Window.CurrentConfig:Load() then
            WindUI:Notify({
                Title = "Config Loaded",
                Content = "Config '" .. ConfigName .. "' loaded",
                Icon = "refresh-cw",
            })
        end
    end,
})

-- ==========================================
-- BANNABLE TAB (DENTRO DEL CONTENEDOR POPULAR)
-- ==========================================
getgenv().CONFIG_BANNABLE = {
    INVIS_OFFSET_Y = 100,
    DESYNC_HEIGHT = 50
}

getgenv().invisState = getgenv().invisState or {
    isInvisible = false,
    realChar = nil,
    fakeChar = nil,
    platform = nil,
    seat = nil
}

getgenv().desyncState = getgenv().desyncState or {
    isDesynced = false,
    fakeChar = nil,
    platform = nil,
    syncConnection = nil,
    animCache = {}
}

local function setCharacterTransparency(char, transparency)
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") or part:IsA("MeshPart") then
            if part.Name ~= "HumanoidRootPart" then
                part.Transparency = transparency
            end
        elseif part:IsA("Accessory") then
            local handle = part:FindFirstChild("Handle")
            if handle then
                handle.Transparency = transparency
            end
        end
    end
end

local bannableTab = mainSection:Tab({
    Title = "Bannable",
    Icon = "shield-alert",
    ShowTabTitle = true,
    Border = true
})

bannableTab:Divider()
bannableTab:Paragraph({ Title = "Floating Controls (Bubbles)", Desc = "" })

editBubblesState = false
local bubblesScreenGui = Instance.new("ScreenGui")
bubblesScreenGui.Name = _randName(12)
bubblesScreenGui.ResetOnSpawn = false
bubblesScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() bubblesScreenGui.Parent = ProtectedGui end)
if not bubblesScreenGui.Parent then
    _protectInstance(bubblesScreenGui)
    _setHiddenParent(bubblesScreenGui)
end
_protectInstance(bubblesScreenGui)

-- FPS / Ping en GUI aparte (fijo, no se mueve con bubbles)
showFpsPing = false
fpsScreenGui = Instance.new("ScreenGui")
fpsScreenGui.Name = _randName(12)
fpsScreenGui.ResetOnSpawn = false
fpsScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
fpsScreenGui.IgnoreGuiInset = true
fpsScreenGui.DisplayOrder = 10
_protectInstance(fpsScreenGui)
_setHiddenParent(fpsScreenGui)

fpsPingLabel = Instance.new("TextLabel")
fpsPingLabel.Name = "FpsPingDisplay"
fpsPingLabel.Size = UDim2.new(0, 80, 0, 36)
fpsPingLabel.AnchorPoint = Vector2.new(1, 0)
fpsPingLabel.Position = UDim2.new(1, -28, 0, 18) -- lado derecho, no pegado al borde
fpsPingLabel.BackgroundTransparency = 1 -- sin fondo
fpsPingLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
fpsPingLabel.BorderSizePixel = 0
fpsPingLabel.TextColor3 = Color3.fromRGB(0, 255, 128)
fpsPingLabel.Font = Enum.Font.GothamBold
fpsPingLabel.TextSize = 12
fpsPingLabel.Text = "FPS: 60\nPing: 0"
fpsPingLabel.TextXAlignment = Enum.TextXAlignment.Right
fpsPingLabel.TextYAlignment = Enum.TextYAlignment.Top
fpsPingLabel.Visible = false -- apagado por default
fpsPingLabel.Active = false
fpsPingLabel.Parent = fpsScreenGui

local lastTick = tick()
local frameCount = 0
RunService.RenderStepped:Connect(function()
    if not showFpsPing then return end
    frameCount = frameCount + 1
    local currentTick = tick()
    if currentTick - lastTick >= 1 then
        local fps = math.floor(frameCount / (currentTick - lastTick))
        local ping = 0
        pcall(function()
            ping = math.floor(LocalPlayer:GetNetworkPing() * 1000)
        end)
        fpsPingLabel.Text = string.format("FPS: %d\nPing: %d", fps, ping)
        frameCount = 0
        lastTick = currentTick
    end
end)

-- Bubbles independientes (cada una se mueve sola, solo con Edit Bubble)
local bubblesContainer = Instance.new("Frame")
bubblesContainer.Name = "BubblesContainer"
bubblesContainer.Size = UDim2.new(1, 0, 1, 0)
bubblesContainer.Position = UDim2.new(0, 0, 0, 0)
bubblesContainer.BackgroundTransparency = 1
bubblesContainer.Active = false
bubblesContainer.Parent = bubblesScreenGui

local function createBubbleButton(name, text, posY)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0, 45, 0, 45)
    -- posición absoluta en pantalla (derecha), independiente
    btn.AnchorPoint = Vector2.new(1, 0)
    btn.Position = UDim2.new(0.98, 0, 0, posY)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.Visible = false
    btn.AutoButtonColor = true
    btn.Parent = bubblesContainer
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

    local bg = Instance.new("UIGradient")
    bg.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 200, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 30, 10))
    })
    bg.Rotation = 45
    bg.Parent = btn

    -- Solo se mueve ESTA bubble, y solo si Edit Bubble está activo
    makeDraggable(btn, btn, function()
        return editBubblesState == true
    end)
    return btn
end

local bubbleDesync = createBubbleButton("BubbleDesync", "DSY", 40)
local bubbleGhost = createBubbleButton("BubbleGhost", "GST", 95)
local bubbleKillAll = createBubbleButton("BubbleKillAll", "KAL", 150)
local bubbleSilentAim = createBubbleButton("BubbleSilentAim", "SA", 205)
local bubbleAutoShoot = createBubbleButton("BubbleAutoShoot", "ATS", 260)

bannableTab:Toggle({
    Title = "Edit Bubble Positions",
    Desc = "Desbloquea las burbujas flotantes para arrastrarlas libremente.",
    Default = false,
    Callback = function(state)
        editBubblesState = state
    end
})

bannableTab:Divider()
bannableTab:Paragraph({ Title = "Bubbles Visibility", Desc = "" })

bannableTab:Toggle({
    Title = "Show Bubble Ghost (GST)",
    Desc = "Muestra u oculta el botón flotante.",
    Default = false,
    Callback = function(val) bubbleGhost.Visible = val end
})

bannableTab:Toggle({
    Title = "Show Bubble Desync (DSY)",
    Desc = "Muestra u oculta el botón flotante.",
    Default = false,
    Callback = function(val) bubbleDesync.Visible = val end
})

bannableTab:Toggle({
    Title = "Show Bubble Kill All (KAL)",
    Desc = "Muestra u oculta el botón flotante de Kill All.",
    Default = false,
    Callback = function(val) bubbleKillAll.Visible = val end
})

bannableTab:Toggle({
    Title = "Show Bubble Silent Aim (SA)",
    Desc = "Muestra u oculta el botón flotante de Silent Aim.",
    Default = false,
    Callback = function(val) bubbleSilentAim.Visible = val end
})

bannableTab:Toggle({
    Title = "Show Bubble Auto Shoot (ATS)",
    Desc = "Muestra u oculta el botón flotante de Auto Shoot.",
    Default = false,
    Callback = function(val) bubbleAutoShoot.Visible = val end
})

bannableTab:Divider()
bannableTab:Paragraph({ Title = "PC Keybinds (Ghost, Desync & Kill All)", Desc = "" })

local function executeGhostLogic()
    invisState.isInvisible = not invisState.isInvisible

    WindUI:Notify({
        Title = "Vortex x Software",
        Content = "Ghost Mode: " .. (invisState.isInvisible and "ACTIVATED" or "DEACTIVATED"),
        Duration = 2
    })

    if invisState.isInvisible then
        local realChar = LocalPlayer.Character
        if not realChar then invisState.isInvisible = false return end
        local hrp = realChar:FindFirstChild("HumanoidRootPart")
        local realHumanoid = realChar:FindFirstChild("Humanoid")
        if not hrp or not realHumanoid then invisState.isInvisible = false return end

        invisState.realChar = realChar
        local savedCFrame = realChar:GetPivot()

        local safePos = savedCFrame.Position - Vector3.new(0, CONFIG_BANNABLE.INVIS_OFFSET_Y, 0)

        local safePlatform = Instance.new("Part")
        safePlatform.Name = _gameLikeName()
        safePlatform.Anchored = true
        safePlatform.Size = Vector3.new(40, 2, 40)
        safePlatform.CFrame = CFrame.new(safePos) - Vector3.new(0, 3, 0)
        safePlatform.Transparency = 1
        safePlatform.Parent = workspace
        invisState.platform = safePlatform

        local seat = Instance.new("Seat")
        seat.Name = _gameLikeName()
        seat.Anchored = true
        seat.Size = Vector3.new(2, 1, 2)
        seat.CFrame = CFrame.new(safePos)
        seat.Transparency = 1
        seat.Parent = workspace
        invisState.seat = seat

        realChar.Archivable = true
        local fakeChar = realChar:Clone()
        fakeChar.Name = _gameLikeName()

        for _, v in ipairs(fakeChar:GetDescendants()) do
            if (v:IsA("LocalScript") or v:IsA("Script")) and v.Name ~= "Animate" then 
                v:Destroy() 
            end
        end
        fakeChar.Parent = workspace
        fakeChar:PivotTo(savedCFrame)
        invisState.fakeChar = fakeChar

        realChar:PivotTo(seat.CFrame + Vector3.new(0, 3, 0))
        task.wait(0.05)
        seat:Sit(realHumanoid)

        LocalPlayer.Character = fakeChar
        workspace.CurrentCamera.CameraSubject = fakeChar:FindFirstChild("Humanoid")

        setCharacterTransparency(fakeChar, 0.5)
        setCharacterTransparency(realChar, 1)
    else
        local realChar = invisState.realChar
        local fakeChar = invisState.fakeChar

        local targetCFrame = nil
        if fakeChar and fakeChar.PrimaryPart then
            targetCFrame = fakeChar:GetPivot()
        end

        if realChar then
            local hrp = realChar:FindFirstChild("HumanoidRootPart")
            local realHumanoid = realChar:FindFirstChild("Humanoid")

            if realHumanoid then
                realHumanoid.Sit = false
            end
            task.wait(0.05) 

            if hrp then
                hrp.Anchored = true
                hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            end

            if targetCFrame then
                realChar:PivotTo(targetCFrame + Vector3.new(0, 3, 0))
            end

            setCharacterTransparency(realChar, 0)

            LocalPlayer.Character = realChar
            if realHumanoid then 
                workspace.CurrentCamera.CameraSubject = realHumanoid 
            end

            task.wait(0.05)
            if hrp then
                hrp.Anchored = false
            end
        end

        if invisState.seat then invisState.seat:Destroy(); invisState.seat = nil end
        if invisState.platform then invisState.platform:Destroy(); invisState.platform = nil end

        if fakeChar then 
            fakeChar:Destroy() 
            invisState.fakeChar = nil 
        end

        invisState.realChar = nil
    end
end

local function executeDesyncLogic()
    local realChar = LocalPlayer.Character
    if not realChar then return end
    local hrp = realChar:FindFirstChild("HumanoidRootPart")
    local realHumanoid = realChar:FindFirstChild("Humanoid")
    if not hrp or not realHumanoid then return end

    desyncState.isDesynced = not desyncState.isDesynced

    WindUI:Notify({
        Title = "Vortex x Software",
        Content = "Desync Mode: " .. (desyncState.isDesynced and "ACTIVATED" or "DEACTIVATED"),
        Duration = 2
    })

    if desyncState.isDesynced then
        local savedCFrame = hrp.CFrame
        desyncState.animCache = {}

        realChar.Archivable = true
        local fakeChar = realChar:Clone()
        fakeChar.Name = _gameLikeName()

        for _, v in ipairs(fakeChar:GetDescendants()) do
            if v:IsA("LocalScript") or v:IsA("Script") then v:Destroy() end
        end

        fakeChar.Parent = workspace
        desyncState.fakeChar = fakeChar

        local fakeHrp = fakeChar:FindFirstChild("HumanoidRootPart")
        local fakeHumanoid = fakeChar:FindFirstChild("Humanoid")
        if fakeHrp then fakeHrp.Anchored = true end

        for _, part in fakeChar:GetDescendants() do
            if part:IsA("BasePart") and part ~= fakeHrp then 
                part.CanCollide = false 
                part.Anchored = false
            end
        end

        fakeChar:PivotTo(savedCFrame)

        local realAnimator = realHumanoid:FindFirstChild("Animator")
        local fakeAnimator = fakeHumanoid and fakeHumanoid:FindFirstChild("Animator")
        if fakeHumanoid and not fakeAnimator then
            fakeAnimator = Instance.new("Animator", fakeHumanoid)
        end

        local platform = Instance.new("Part")
        platform.Name = _gameLikeName()
        platform.Size = Vector3.new(2048, 5, 2048) 
        platform.CFrame = CFrame.new(savedCFrame.X, savedCFrame.Y + CONFIG_BANNABLE.DESYNC_HEIGHT, savedCFrame.Z)
        platform.Anchored = true
        platform.Transparency = 1
        platform.Parent = workspace
        desyncState.platform = platform

        setCharacterTransparency(realChar, 1)
        hrp.CFrame = CFrame.new(savedCFrame.X, platform.Position.Y + (platform.Size.Y/2) + 3, savedCFrame.Z)

        workspace.CurrentCamera.CameraSubject = fakeHumanoid

        local rayParams = RaycastParams.new()
        rayParams.FilterType = Enum.RaycastFilterType.Exclude
        rayParams.FilterDescendantsInstances = {realChar, fakeChar, platform}

        desyncState.syncConnection = RunService.RenderStepped:Connect(function()
            if hrp and fakeChar and fakeHrp then
                local realPos = hrp.Position
                local cloneCurrentY = fakeHrp.Position.Y

                local rayOrigin = Vector3.new(realPos.X, cloneCurrentY + 3, realPos.Z)
                local raycastResult = workspace:Raycast(rayOrigin, Vector3.new(0, -1000, 0), rayParams)

                local floorY = raycastResult and raycastResult.Position.Y or cloneCurrentY
                local hipHeight = realHumanoid.HipHeight > 0 and realHumanoid.HipHeight or 2
                local platformTop = platform.Position.Y + (platform.Size.Y / 2)
                local expectedRealY = platformTop + hipHeight + (hrp.Size.Y / 2)
                local jumpOffset = math.max(0, realPos.Y - expectedRealY)

                local targetY = floorY + (fakeHrp.Size.Y / 2) + hipHeight + jumpOffset
                fakeChar:SetPrimaryPartCFrame(CFrame.new(realPos.X, targetY, realPos.Z) * hrp.CFrame.Rotation)

                if realAnimator and fakeAnimator then
                    local playingTracks = realAnimator:GetPlayingAnimationTracks()
                    for _, realTrack in ipairs(playingTracks) do
                        local animId = realTrack.Animation.AnimationId
                        local fakeTrack = desyncState.animCache[animId]
                        if not fakeTrack then
                            fakeTrack = fakeAnimator:LoadAnimation(realTrack.Animation)
                            desyncState.animCache[animId] = fakeTrack
                        end
                        if not fakeTrack.IsPlaying then fakeTrack:Play() end
                        fakeTrack.TimePosition = realTrack.TimePosition
                        fakeTrack:AdjustWeight(realTrack.WeightTarget)
                        fakeTrack:AdjustSpeed(realTrack.Speed)
                    end
                end
            end
        end)
    else
        if desyncState.syncConnection then desyncState.syncConnection:Disconnect(); desyncState.syncConnection = nil end

        local returnCFrame = nil
        if desyncState.fakeChar then
            returnCFrame = desyncState.fakeChar:GetPivot()
            desyncState.fakeChar:Destroy()
            desyncState.fakeChar = nil
        end

        if desyncState.platform then desyncState.platform:Destroy(); desyncState.platform = nil end

        if returnCFrame and hrp then hrp.CFrame = returnCFrame end
        setCharacterTransparency(realChar, 0)
        workspace.CurrentCamera.CameraSubject = realHumanoid
    end
end

bannableTab:Keybind({
    Title = "Activate Ghost Mode (Invisibility)",
    Desc = "Tecla para alternar Ghost Mode",
    Key = "H",
    Callback = function() executeGhostLogic() end
})

bannableTab:Keybind({
    Title = "Activate Desync Mode",
    Desc = "Tecla para alternar Desync",
    Key = "J",
    Callback = function() executeDesyncLogic() end
})

bubbleGhost.MouseButton1Click:Connect(function()
    if editBubblesState then return end
    executeGhostLogic()
end)

bubbleDesync.MouseButton1Click:Connect(function()
    if editBubblesState then return end
    executeDesyncLogic()
end)

-- =================================================================
-- MÓDULO COMPLETO: TAB AIM (LÓGICA, HOOKS, UI Y BUCLES EN SEGUNDO PLANO)
-- =================================================================

local combatTab = mainSection:Tab({ Title = "Combat", Icon = "crosshair", ShowTabTitle = true, Border = true })
local Tabs = { Aim = combatTab }

-- AutoFarm tab (Popular, debajo de Combat)
local farmTab = mainSection:Tab({ Title = "AutoFarm", Icon = "coins", ShowTabTitle = true, Border = true })
Tabs.Farm = farmTab

local UIElements = {}

local autoShootEnabled = false
local autoShootCuchilloEnabled = false
local autoShootTargetPart = "Cabeza"

local silentAimManualEnabled = false
local silentAimFovEnabled = false
local silentAimTargetPart = "Cabeza"

local fovVisiblePreference = false
local fovRadius = 120

local hitboxEnabled = false
local hitboxInvisible = false
local hitboxSize = 10

local macroActivo = false
local macroEquipDelay = 0.04
local macroShootDelay = 0.10

local ZONAS_SEGURAS = {
    {Centro = Vector3.new(-320.50, 280.82, 16.00), Radio = 500},
    {Centro = Vector3.new(1564.14, -155.45, 40.04), Radio = 300}
}

pcall(function() silentTargetPart = nil end)

local FOVCircle = nil
if hasDrawing then
    FOVCircle = Drawing.new("Circle")
    FOVCircle.Filled = false
    FOVCircle.Color = Color3.fromRGB(255, 255, 255)
    FOVCircle.Visible = false
    FOVCircle.Thickness = 1
end

local function toggleSilentAimGlobal()
    silentAimManualEnabled = not silentAimManualEnabled
    if UIElements.TogSilentAimManual then
        pcall(function() UIElements.TogSilentAimManual:SetValue(silentAimManualEnabled) end)
    else
        showBottomMessage(silentAimManualEnabled and "Silent Aim: ACTIVADO" or "Silent Aim: DESACTIVADO")
    end
    if not silentAimManualEnabled and not autoShootEnabled and not silentAimFovEnabled then
        pcall(function() silentTargetPart = nil end)
    end
end

local function toggleAutoShootGlobal()
    autoShootEnabled = not autoShootEnabled
    if UIElements.TogAutoShoot then
        pcall(function() UIElements.TogAutoShoot:SetValue(autoShootEnabled) end)
    else
        showBottomMessage(autoShootEnabled and "Auto Shoot: ACTIVADO" or "Auto Shoot: DESACTIVADO")
    end
    if not autoShootEnabled then
        pcall(function() silentTargetPart = nil end)
    end
end

bubbleSilentAim.MouseButton1Click:Connect(function()
    if editBubblesState then return end
    toggleSilentAimGlobal()
end)

bubbleAutoShoot.MouseButton1Click:Connect(function()
    if editBubblesState then return end
    toggleAutoShootGlobal()
end)

local function esLaPistola(item)
    if not item or not item:IsA("Tool") then return false end
    if item:FindFirstChild("Throw", true) or item:FindFirstChild("KnifeClient", true) or item:FindFirstChild("KnifeServer", true) then return false end
    local nombre = string.lower(item.Name)
    local ignorar = {"combat", "fist", "wallet", "phone", "punch", "boombox", "radio", "knife", "blade", "cuchillo", "dagger", "kunai", "sword", "toy", "juguete", "pizza", "burger", "teddy", "balloon", "drink", "food"}
    for _, palabra in ipairs(ignorar) do 
        if string.find(nombre, palabra) then return false end 
    end
    return true
end

local function obtenerPistola()
    local char = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if char then 
        for _, item in ipairs(char:GetChildren()) do 
            if esLaPistola(item) then return item end 
        end 
    end
    if backpack then 
        for _, item in ipairs(backpack:GetChildren()) do 
            if esLaPistola(item) then return item end 
        end 
    end
    return nil
end

local function estaEnLobby()
    local char = LocalPlayer.Character 
    if not char then return true end
    if char:FindFirstChildOfClass("ForceField") then return true end

    if LocalPlayer.Team then
        local tName = string.lower(LocalPlayer.Team.Name)
        if string.find(tName, "lobby") or string.find(tName, "spectat") or string.find(tName, "espectador") or string.find(tName, "menu") or string.find(tName, "dead") then 
            return true 
        end
    end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        for _, zona in ipairs(ZONAS_SEGURAS) do
            if (hrp.Position - zona.Centro).Magnitude <= zona.Radio then 
                return true
            end
        end
    end
    return false
end

pcall(function()
    if hookmetamethod and getnamecallmethod and checkcaller then
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()

            if not checkcaller() and silentTargetPart then
                local target = silentTargetPart
                local cameraOrigin = workspace.CurrentCamera.CFrame.Position

                if target and target.Parent then
                    if method == "Raycast" and self == workspace then
                        local origin, direction, p3 = ...
                        if (origin - cameraOrigin).Magnitude < 1 then
                            return oldNamecall(self, ...)
                        end
                        if typeof(direction) == "Vector3" and direction.Magnitude > 5 then
                            local newDir = (target.Position - origin).Unit * 5000 
                            return oldNamecall(self, origin, newDir, p3)
                        end
                    elseif string.find(method, "FindPartOnRay") and self == workspace then
                        local ray, p2, p3, p4 = ...
                        if (ray.Origin - cameraOrigin).Magnitude < 1 then
                            return oldNamecall(self, ...)
                        end
                        if typeof(ray) == "Ray" and ray.Direction.Magnitude > 5 then
                            local newRay = Ray.new(ray.Origin, (target.Position - ray.Origin).Unit * 5000)
                            return oldNamecall(self, newRay, p2, p3, p4)
                        end
                    end
                else
                    silentTargetPart = nil
                end
            end

            return oldNamecall(self, ...)
        end)

        local oldIndex
        oldIndex = hookmetamethod(game, "__index", function(t, k)
            if not checkcaller() and t == Mouse and silentTargetPart then
                if k == "Hit" or k == "hit" then
                    return silentTargetPart.CFrame
                elseif k == "Target" or k == "target" then
                    return silentTargetPart
                end
            end
            return oldIndex(t, k)
        end)
    end
end)

Tabs.Aim:Divider()
Tabs.Aim:Paragraph({ Title = "Kill All", Desc = "" })

local function esVulnerable(char)
    if not char then return false end
    if char:FindFirstChildOfClass("ForceField") then return false end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp and hrp.Anchored then return false end

    local hum = char:FindFirstChild("Humanoid")
    if hum and (hum.WalkSpeed == 0 or hum.Health <= 0) then return false end

    return true
end

local killAllRango = 600 
local killAllEnabled = false

local function setKillAllState(state)
    killAllEnabled = state
    if UIElements.TogKillAll then
        pcall(function() UIElements.TogKillAll:SetValue(state) end)
    end
    if state then
        showBottomMessage("Kill All: ACTIVADO")
        task.spawn(function()
            while killAllEnabled do
                local myChar = player.Character

                if not myChar or not myChar:FindFirstChild("HumanoidRootPart") or not player:FindFirstChild("Backpack") then
                    task.wait(0.5)
                    continue 
                end

                if not estaEnLobby() and esVulnerable(myChar) then
                    local myHrp = myChar:FindFirstChild("HumanoidRootPart")
                    local myHum = myChar:FindFirstChild("Humanoid")

                    if myHrp and myHum and myHum.Health > 0 then
                        local posicionOriginal = myHrp.CFrame

                        for _, p in ipairs(Players:GetPlayers()) do
                            if not killAllEnabled then break end 

                            if p ~= player and isEnemy(p) and p.Character then
                                if esVulnerable(p.Character) then
                                    local enemyHum = p.Character:FindFirstChild("Humanoid")
                                    local enemyHrp = p.Character:FindFirstChild("HumanoidRootPart")

                                    if enemyHum and enemyHum.Health > 0 and enemyHrp then
                                        local distanciaAlEnemigo = (posicionOriginal.Position - enemyHrp.Position).Magnitude

                                        if distanciaAlEnemigo <= killAllRango then
                                            enemyHrp.Size = Vector3.new(30, 30, 30)
                                            enemyHrp.CanCollide = false

                                            local failSafe = 0 

                                            while killAllEnabled and p and p.Parent and enemyHum and enemyHum.Parent and enemyHum.Health > 0 and failSafe < 300 do
                                                myHum.PlatformStand = true 

                                                myHrp.CFrame = enemyHrp.CFrame * CFrame.new(0, -2, 0)
                                                myHrp.AssemblyLinearVelocity = Vector3.zero 
                                                myHrp.AssemblyAngularVelocity = Vector3.zero

                                                pcall(function()
                                                    local arma = myChar:FindFirstChildOfClass("Tool")

                                                    if arma and esLaPistola(arma) then
                                                        myHum:UnequipTools()
                                                        arma = nil
                                                    end

                                                    if not arma then
                                                        local backpack = player:FindFirstChild("Backpack")
                                                        if backpack then
                                                            for _, item in ipairs(backpack:GetChildren()) do
                                                                if item:IsA("Tool") and not esLaPistola(item) then
                                                                    myHum:EquipTool(item)
                                                                    arma = item
                                                                    task.wait(0.05)
                                                                    break
                                                                end
                                                            end
                                                        end
                                                    end

                                                    if arma then
                                                        arma:Activate()
                                                    end
                                                end)

                                                task.wait(0.03)
                                                failSafe = failSafe + 1
                                            end

                                            if myHum then
                                                myHum.PlatformStand = false
                                            end

                                            pcall(function()
                                                local arma = myChar:FindFirstChildOfClass("Tool")
                                                if arma then arma:Deactivate() end
                                            end)
                                        end
                                    end
                                end
                            end
                        end

                        if killAllEnabled and myHrp then
                            myHrp.CFrame = posicionOriginal
                            myHrp.AssemblyLinearVelocity = Vector3.zero
                            myHrp.AssemblyAngularVelocity = Vector3.zero
                            task.wait(0.2) 
                        end
                    end
                end
                task.wait(0.1) 
            end
        end)
    else
        showBottomMessage("Kill All: DESACTIVADO")
        pcall(function()
            local myHum = player.Character and player.Character:FindFirstChild("Humanoid")
            if myHum then myHum.PlatformStand = false end
        end)
    end
end

UIElements.TogKillAll = Tabs.Aim:Toggle({ 
    Title = "Activar Kill All (advertensia expulsa al usarlo Beta)",
    Desc = "Mata a todos los enemigos con cuchillo.",
    Value = false,
    Callback = function(Value)
        setKillAllState(Value)
    end
})

bannableTab:Keybind({
    Title = "Activate Kill All Mode",
    Desc = "Tecla para alternar Kill All",
    Key = "N",
    Callback = function() setKillAllState(not killAllEnabled) end
})

bubbleKillAll.MouseButton1Click:Connect(function()
    if editBubblesState then return end
    setKillAllState(not killAllEnabled)
end)

Tabs.Aim:Divider()

Tabs.Aim:Paragraph({ Title = "Macro (Pistola)", Desc = "" })

UIElements.TogMacro = Tabs.Aim:Toggle({
    Title = "Activar Macro", 
    Desc = "Dispara con un solo toque.",
    Value = false,
    Callback = function(s) macroActivo = s end
})

UIElements.SliMacroEquip = Tabs.Aim:Slider({
    Title = "Delay al Equipar",
    Desc = "Sube esto si la pistola no alcanza a salir. (Segundos)",
    Step = 0.01,
    Value = {Min = 0.01, Max = 0.50, Default = 0.04},
    Callback = function(v) macroEquipDelay = v end
})

UIElements.SliMacroShoot = Tabs.Aim:Slider({
    Title = "Delay de Disparo",
    Desc = "Sube esto si el tiro no cuenta daño. (Segundos)",
    Step = 0.01,
    Value = {Min = 0.05, Max = 0.80, Default = 0.10},
    Callback = function(v) macroShootDelay = v end
})

local deadZoneFrame = Instance.new("Frame")
deadZoneFrame.Size = UDim2.new(0, 150, 0, 150)
deadZoneFrame.Position = UDim2.new(0.8, -75, 0.8, -75) 
deadZoneFrame.BackgroundColor3 = Color3.fromRGB(255, 200, 50) 
deadZoneFrame.BackgroundTransparency = 0.5
deadZoneFrame.Visible = false
deadZoneFrame.ZIndex = 100
deadZoneFrame.Parent = screenGui 
Instance.new("UICorner", deadZoneFrame).CornerRadius = UDim.new(0, 16)

local dzStroke = Instance.new("UIStroke", deadZoneFrame)
dzStroke.Color = Color3.fromRGB(255, 255, 255)
dzStroke.Thickness = 2

local dzLabel = Instance.new("TextLabel", deadZoneFrame)
dzLabel.Size = UDim2.new(1, 0, 1, 0)
dzLabel.BackgroundTransparency = 1
dzLabel.Text = "ZONA MUERTA\n(Arrastrar)"
dzLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
dzLabel.Font = Enum.Font.GothamBold
dzLabel.TextSize = 14
dzLabel.TextWrapped = true

makeDraggable(deadZoneFrame, deadZoneFrame)

UIElements.TogDeadZone = Tabs.Aim:Toggle({
    Title = "Mostrar/Acomodar Zona Muerta", 
    Value = false,
    Callback = function(s) deadZoneFrame.Visible = s end
})

UIElements.SliDeadZone = Tabs.Aim:Slider({
    Title = "Tamaño de Zona Muerta", 
    Step = 1,
    Value = {Min = 80, Max = 400, Default = 150}, 
    Callback = function(v) deadZoneFrame.Size = UDim2.new(0, v, 0, v) end
})

Tabs.Aim:Divider()
Tabs.Aim:Paragraph({ Title = "Auto Shoot", Desc = "" })

UIElements.TogAutoShoot = Tabs.Aim:Toggle({
    Title = "Auto Shoot",
    Desc = "Dispara automáticamente a la parte del cuerpo seleccionada.",
    Value = false,
    Callback = function(Value)
        task.spawn(function()
            autoShootEnabled = Value
            showBottomMessage(Value and "Auto Shoot: ACTIVADO" or "Auto Shoot: DESACTIVADO")
            if not Value then pcall(function() silentTargetPart = nil end) end
        end)
    end,
})

UIElements.TogAutoShootCuchillo = Tabs.Aim:Toggle({
    Title = "Auto Shoot (Cuchillo)",
    Desc = "Ataca o lanza el cuchillo automáticamente.",
    Value = false,
    Callback = function(Value) autoShootCuchilloEnabled = Value end,
})

local asTargetIniciado = false
UIElements.DropAutoShootPart = Tabs.Aim:Dropdown({
    Title = "Target: Parte del cuerpo (Auto Shoot)",
    Values = {"Cabeza", "Torso", "Cuerpo Completo"},
    Value = "Cabeza",
    Callback = function(Value)
        autoShootTargetPart = Value
        if asTargetIniciado then showBottomMessage("AutoShoot Target: " .. Value) end
        asTargetIniciado = true
    end
})

Tabs.Aim:Divider()
Tabs.Aim:Paragraph({ Title = "Silent Aim & FOV", Desc = "" })

UIElements.TogSilentAimManual = Tabs.Aim:Toggle({
    Title = "Silent Aim",
    Desc = "Redirige las balas al enemigo.",
    Value = false,
    Callback = function(Value)
        task.spawn(function()
            silentAimManualEnabled = Value
            showBottomMessage(Value and "Silent Aim: ACTIVADO" or "Silent: DESACTIVADO")
            if not Value and not autoShootEnabled then pcall(function() silentTargetPart = nil end) end
        end)
    end,
})

local aimTargetIniciado = false
UIElements.DropSilentAimPart = Tabs.Aim:Dropdown({
    Title = "Target: Parte del cuerpo",
    Values = {"Cabeza", "Torso", "Cuerpo Completo"},
    Value = "Cabeza",
    Callback = function(Value)
        silentAimTargetPart = Value
        if aimTargetIniciado then showBottomMessage("Apuntando a: " .. Value) end
        aimTargetIniciado = true
    end
})

UIElements.TogSilentAimFOV = Tabs.Aim:Toggle({
    Title = "Silent Aim (Con FOV)",
    Desc = "Igual que el Silent Aim, pero solo afecta a los enemigos dentro del círculo.",
    Value = false,
    Callback = function(Value)
        task.spawn(function()
            silentAimFovEnabled = Value
            showBottomMessage(Value and "Silent Aim FOV: ACTIVADO" or "Silent FOV: DESACTIVADO")
            if not Value and not silentAimManualEnabled and not autoShootEnabled then 
                pcall(function() silentTargetPart = nil end) 
            end
        end)
    end,
})

UIElements.TogShowFOV = Tabs.Aim:Toggle({
    Title = "Mostrar Círculo FOV",
    Desc = "Dibuja un círculo en pantalla para el Silent Aim.",
    Value = false,
    Callback = function(Value) fovVisiblePreference = Value end,
})

UIElements.SliFOVSize = Tabs.Aim:Slider({
    Title = "Tamaño del FOV", 
    Step = 1,
    Value = {Min = 10, Max = 800, Default = 120}, 
    Callback = function(v) fovRadius = v end
})

Tabs.Aim:Divider()
Tabs.Aim:Paragraph({ Title = "Expandir Hitbox", Desc = "" })

UIElements.TogHitbox = Tabs.Aim:Toggle({
    Title = "Aumentar Hitbox",
    Desc = "Expande la caja de colisión de los enemigos.",
    Value = false,
    Callback = function(s) 
        task.spawn(function()
            hitboxEnabled = s 
            if not s then
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        local hrp = v.Character.HumanoidRootPart
                        restoreSize(hrp)
                        restoreCollide(hrp)
                        hrp.Transparency = 1
                        hrp.Material = Enum.Material.Plastic
                        local box = hrp:FindFirstChild(hitboxAdornName)
                        if box then box:Destroy() end
                    end
                end
            end
        end)
    end
})

UIElements.TogHbInv = Tabs.Aim:Toggle({
    Title = "Hitbox Invisible", 
    Desc = "Oculta las cajas de los enemigos.",
    Value = false,
    Callback = function(s) hitboxInvisible = s end
})

UIElements.SliHitbox = Tabs.Aim:Slider({
    Title = "Tamaño de Hitbox",
    Desc = "10 - 20 max recomendado",
    Step = 1,
    Value = {Min = 2, Max = 50, Default = 10}, 
    Callback = function(v) hitboxSize = v end
})

Tabs.Aim:Input({
    Title = "Escribir Tamaño Exacto",
    Placeholder = "Ej: 2, 12, 25...",
    Callback = function(Text)
        local num = tonumber(Text)
        if num then
            hitboxSize = num
            pcall(function() if num >= 2 and num <= 50 then UIElements.SliHitbox:Set(num) end end)
            showBottomMessage("Hitbox fijada en: " .. num)
        end
    end,
})

local function ejecutarAccionMacro()
    if estaEnLobby() then return end

    local hayEnemigos = false
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and isEnemy(p) and p.Character then
            local hum = p.Character:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 then
                hayEnemigos = true
                break
            end
        end
    end
    if not hayEnemigos then return end

    local char = LocalPlayer.Character if not char then return end
    local hum = char:FindFirstChild("Humanoid") if not hum then return end
    local herramientaEnMano = char:FindFirstChildOfClass("Tool")
    if herramientaEnMano and not esLaPistola(herramientaEnMano) then return end

    local pistola = obtenerPistola()
    if not pistola then return end

    task.spawn(function()
        hum:UnequipTools() 
        task.wait() 
        hum:EquipTool(pistola) 
        task.wait(macroEquipDelay) 

        if pistola.Parent == char then 
            pistola:Activate() 
            task.wait(macroShootDelay) 
            pistola:Deactivate()
            hum:UnequipTools() 
        end
    end)
end

local toquesPantalla = {} 
UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch and toquesPantalla[input] then
        if (toquesPantalla[input].posicion - input.Position).Magnitude > 10 then
            toquesPantalla = {} 
        end
    end
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if processed or not macroActivo then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then 
        ejecutarAccionMacro()
    elseif input.UserInputType == Enum.UserInputType.Touch then
        local pos = input.Position
        local dzPos = deadZoneFrame.AbsolutePosition
        local dzSize = deadZoneFrame.AbsoluteSize
        local tocoZonaMuerta = (pos.X >= dzPos.X) and (pos.X <= dzPos.X + dzSize.X) and (pos.Y >= dzPos.Y) and (pos.Y <= dzPos.Y + dzSize.Y)
        if not tocoZonaMuerta then 
            toquesPantalla[input] = {posicion = input.Position, tiempo = tick()} 
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if not macroActivo then return end
    if input.UserInputType == Enum.UserInputType.Touch and toquesPantalla[input] then
        local datosToque = toquesPantalla[input] 
        local tiempoPresionado = tick() - datosToque.tiempo
        toquesPantalla[input] = nil
        if (datosToque.posicion - input.Position).Magnitude < 10 and tiempoPresionado < 0.35 and tiempoPresionado > 0.03 then 
            ejecutarAccionMacro() 
        end
    end
end)

task.spawn(function()
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude

    while task.wait(0.1) do
        if (autoShootEnabled or autoShootCuchilloEnabled) and not estaEnLobby() then
            local char = LocalPlayer.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then continue end

            local arma = char:FindFirstChildOfClass("Tool")
            if not arma or not arma:FindFirstChild("Handle") then 
                silentTargetPart = nil
                continue 
            end

            local esGun = esLaPistola(arma)
            if (esGun and not autoShootEnabled) or (not esGun and not autoShootCuchilloEnabled) then
                silentTargetPart = nil
                continue
            end

            local myPos = char.HumanoidRootPart.Position
            local headPos = char:FindFirstChild("Head") and char.Head.Position or myPos
            local objetivosPotenciales = {}

            for _, p in ipairs(Players:GetPlayers()) do
                if isEnemy(p) and p.Character then
                    local enemyHum = p.Character:FindFirstChild("Humanoid")
                    if enemyHum and enemyHum.Health > 0 then
                        local partesAEscanear = {}
                        if autoShootTargetPart == "Cabeza" then partesAEscanear = {"Head"}
                        elseif autoShootTargetPart == "Torso" then partesAEscanear = {"UpperTorso", "Torso", "HumanoidRootPart"}
                        elseif autoShootTargetPart == "Cuerpo Completo" then partesAEscanear = {"Head", "UpperTorso", "LowerTorso", "Torso", "LeftArm", "RightArm", "LeftLeg", "RightLeg"} end

                        for _, partName in ipairs(partesAEscanear) do
                            local part = p.Character:FindFirstChild(partName)
                            if part and part:IsA("BasePart") then 
                                table.insert(objetivosPotenciales, {Part = part, Dist = (part.Position - myPos).Magnitude, Char = p.Character})
                            end
                        end
                    end 
                end 
            end 

            table.sort(objetivosPotenciales, function(a, b) return a.Dist < b.Dist end)

            local closestTargetPart = nil
            for _, obj in ipairs(objetivosPotenciales) do
                local part = obj.Part
                params.FilterDescendantsInstances = {char, obj.Char}

                local isVisible = not workspace:Raycast(headPos, part.Position - headPos, params)
                if isVisible then
                    closestTargetPart = part
                    break
                end
            end

            if closestTargetPart then
                silentTargetPart = closestTargetPart
                pcall(function() 
                    arma:Activate() 
                    task.delay(0.02, function() 
                        if arma.Parent == char then arma:Deactivate() end
                    end)
                end)
                task.wait(0.08) 
            else
                silentTargetPart = nil
            end
        end
    end
end)

task.spawn(function()
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude

    while task.wait(0.03) do
        if (silentAimManualEnabled or silentAimFovEnabled) and not estaEnLobby() then
            local char = LocalPlayer.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then continue end

            local closestTargetPart = nil
            local shortestDistToCenter = math.huge 
            local shortestDistanceFisica = math.huge 

            local myPos = char.HumanoidRootPart.Position
            local headPos = char:FindFirstChild("Head") and char.Head.Position or myPos
            local viewport = Camera.ViewportSize
            local mousePos = Vector2.new(viewport.X / 2, viewport.Y / 2)

            for _, p in ipairs(Players:GetPlayers()) do
                if isEnemy(p) and p.Character then
                    local enemyHum = p.Character:FindFirstChild("Humanoid")
                    if enemyHum and enemyHum.Health > 0 then
                        local partesAEscanear = {}

                        if silentAimTargetPart == "Cabeza" then
                            local head = p.Character:FindFirstChild("Head")
                            if head then table.insert(partesAEscanear, head) end
                        elseif silentAimTargetPart == "Torso" then
                            for _, pName in ipairs({"UpperTorso", "Torso", "HumanoidRootPart"}) do
                                local part = p.Character:FindFirstChild(pName)
                                if part then table.insert(partesAEscanear, part) end
                            end
                        elseif silentAimTargetPart == "Cuerpo Completo" then
                            for _, part in ipairs(p.Character:GetChildren()) do
                                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then table.insert(partesAEscanear, part) end
                            end
                        end

                        params.FilterDescendantsInstances = {char, p.Character}

                        for _, part in ipairs(partesAEscanear) do
                            local distFisica = (part.Position - myPos).Magnitude
                            local pos2D, onScreen = Camera:WorldToViewportPoint(part.Position)
                            local distToCenter = (Vector2.new(pos2D.X, pos2D.Y) - mousePos).Magnitude
                            local pasaFiltro = false

                            if silentAimFovEnabled then
                                if onScreen and distToCenter <= fovRadius and distToCenter < shortestDistToCenter then pasaFiltro = true end
                            elseif silentAimManualEnabled then
                                if distFisica < shortestDistanceFisica then pasaFiltro = true end
                            end

                            if pasaFiltro then
                                if not workspace:Raycast(headPos, part.Position - headPos, params) then
                                    if silentAimFovEnabled then
                                        shortestDistToCenter = distToCenter
                                        closestTargetPart = part
                                    else
                                        shortestDistanceFisica = distFisica
                                        closestTargetPart = part
                                    end
                                end
                            end
                        end
                    end
                end
            end

            if closestTargetPart then
                silentTargetPart = closestTargetPart
            else
                if not autoShootEnabled then silentTargetPart = nil end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        if hitboxEnabled and not estaEnLobby() then
            for _, v in pairs(Players:GetPlayers()) do
                if isEnemy(v) and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                    local hrp = v.Character.HumanoidRootPart 
                    setSpoofedSize(hrp, Vector3.new(hitboxSize, hitboxSize, hitboxSize))
                    setSpoofedCollide(hrp, false)

                    local targetTrans = hitboxInvisible and 1 or 0.5
                    if hrp.Transparency ~= targetTrans then hrp.Transparency = targetTrans end
                    if hrp.Material ~= Enum.Material.ForceField then hrp.Material = Enum.Material.ForceField end

                    local box = hrp:FindFirstChild(hitboxAdornName)
                    if not box then 
                        box = Instance.new("BoxHandleAdornment") 
                        box.Name = hitboxAdornName 
                        box.Adornee = hrp 
                        box.AlwaysOnTop = true 
                        box.ZIndex = 5 
                        box.Parent = hrp 
                    end

                    box.Size = hrp.Size
                    box.Color3 = Color3.fromRGB(255, 190, 40)
                    box.Transparency = hitboxInvisible and 1 or 0.3
                    box.Visible = not hitboxInvisible
                else
                    if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        local hrp = v.Character.HumanoidRootPart
                        restoreSize(hrp)
                        restoreCollide(hrp)
                        hrp.Transparency = 1
                        hrp.Material = Enum.Material.Plastic
                        local box = hrp:FindFirstChild(hitboxAdornName)
                        if box then box:Destroy() end
                    end
                end
            end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if FOVCircle then
        if fovVisiblePreference then
            local viewport = Camera.ViewportSize
            FOVCircle.Position = Vector2.new(viewport.X / 2, viewport.Y / 2)
            FOVCircle.Radius = fovRadius
            FOVCircle.Visible = true
            FOVCircle.Color = silentTargetPart and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
        else
            FOVCircle.Visible = false
        end
    end
end)

-- ==========================================
-- TAB VISUAL (ESP ENEMIGO / ESP ALIADO / PROFESIONAL)
-- ==========================================
local visualsTab = mainSection:Tab({ Title = "Visuals", Icon = "eye", ShowTabTitle = true, Border = true })
Tabs.Vis = visualsTab

local espEnabled = false
local allyEspEnabled = false
local professionalEspEnabled = false
local outlineEnabled = true
local enemyOutlineColor = Color3.fromRGB(255, 190, 40)
local allyOutlineColor = Color3.fromRGB(0, 255, 128)
local professionalEspDrawings = {}


-- =====================================
-- VISUALES: Identidad / Nombre (lógica)
-- =====================================
local visualConnections = {}
local originalData = {}

local hideNameEnabled = false
local fakeNameEnabled = false
local rainbowEnabled = false
local creatorTagEnabled = false
local spoofNameText = "Nombre falso"

local function safeReplace(str, find, replace)
    local safeFind = find:gsub("[%-%^%$%(%)%%%.%[%]%*%+%?]", "%%%1")
    return (str:gsub(safeFind, replace))
end

local function processText(v, myName, myDisp)
    local parentGui = v:FindFirstAncestorWhichIsA("ScreenGui")
    if parentGui and (string.find(parentGui.Name, "WindUI") or string.find(parentGui.Name, "Onyx") or string.find(parentGui.Name, "Vortex")) then
        return
    end

    if v:IsA("TextLabel") or v:IsA("TextBox") or v:IsA("TextButton") then
        local txt = v.Text
        local hasName = false

        if txt and txt ~= "" then
            if string.find(txt, myName, 1, true) or string.find(txt, myDisp, 1, true) then
                hasName = true
            end
        end

        if hasName and not originalData[v] then
            originalData[v] = {
                Text = txt,
                Color = v.TextColor3,
                TextTransp = v.TextTransparency,
                StrokeTransp = v.TextStrokeTransparency,
                Strokes = {}
            }
            for _, obj in pairs(v:GetChildren()) do
                if obj:IsA("UIStroke") then
                    originalData[v].Strokes[obj] = {
                        Enabled = obj.Enabled,
                        Transp = obj.Transparency,
                        Thickness = obj.Thickness
                    }
                end
            end
        end

        if originalData[v] then
            if fakeNameEnabled or creatorTagEnabled then
                local newText = originalData[v].Text
                local baseName = fakeNameEnabled and spoofNameText or myDisp

                newText = string.gsub(newText, "%[VIP%] ", "")
                newText = string.gsub(newText, "%[VIP%]", "")
                newText = string.gsub(newText, '<font color="#bee1e7">%[Content Creator%]</font> ', "")
                newText = string.gsub(newText, "%[Content Creator%] ", "")
                newText = string.gsub(newText, "%[Content Creator%]", "")

                local isOverheadTag = false
                if player.Character then
                    if v:IsDescendantOf(player.Character) then
                        isOverheadTag = true
                    else
                        local pGuiAdornee = v:FindFirstAncestorWhichIsA("BillboardGui")
                        if pGuiAdornee and pGuiAdornee.Adornee and pGuiAdornee.Adornee:IsDescendantOf(player.Character) then
                            isOverheadTag = true
                        end
                    end
                end

                local finalName = baseName
                if creatorTagEnabled and isOverheadTag then
                    v.RichText = true
                    finalName = '<font color="#bee1e7">[Content Creator]</font> ' .. baseName
                end

                newText = safeReplace(newText, myName, finalName)
                newText = safeReplace(newText, myDisp, finalName)

                v.Text = newText
                v.TextTransparency = originalData[v].TextTransp
                v.TextStrokeTransparency = originalData[v].StrokeTransp

                for _, obj in pairs(v:GetChildren()) do
                    if obj:IsA("UIStroke") and originalData[v].Strokes[obj] then
                        obj.Enabled = originalData[v].Strokes[obj].Enabled
                    end
                end

                if rainbowEnabled then
                    v.TextColor3 = Color3.fromHSV((tick() % 4) / 4, 1, 1)
                else
                    v.TextColor3 = originalData[v].Color
                end

            elseif hideNameEnabled then
                v.Text = " "
                v.TextTransparency = 1
                v.TextStrokeTransparency = 1
                for _, obj in pairs(v:GetChildren()) do
                    if obj:IsA("UIStroke") then
                        obj.Enabled = false
                        obj.Transparency = 1
                        obj.Thickness = 0
                    end
                end
            else
                v.Text = originalData[v].Text
                if rainbowEnabled then
                    v.TextColor3 = Color3.fromHSV((tick() % 4) / 4, 1, 1)
                else
                    v.TextColor3 = originalData[v].Color
                end
                v.TextTransparency = originalData[v].TextTransp
                v.TextStrokeTransparency = originalData[v].StrokeTransp

                for _, obj in pairs(v:GetChildren()) do
                    if obj:IsA("UIStroke") and originalData[v].Strokes[obj] then
                        obj.Enabled = originalData[v].Strokes[obj].Enabled
                        obj.Transparency = originalData[v].Strokes[obj].Transp
                        obj.Thickness = originalData[v].Strokes[obj].Thickness
                    end
                end
            end
        end
    end
end

local isWorkspaceLooping = false

local function updateSystem()
    local myName = player.Name
    local myDisp = player.DisplayName

    task.spawn(function()
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character then
                for _, v in pairs(p.Character:GetDescendants()) do
                    if v:IsA("TextLabel") or v:IsA("TextBox") then
                        processText(v, myName, myDisp)
                    end
                end
            end
        end
        local pGui = player:FindFirstChild("PlayerGui")
        if pGui then
            for _, v in pairs(pGui:GetDescendants()) do
                if v:IsA("TextLabel") or v:IsA("TextBox") then
                    processText(v, myName, myDisp)
                end
            end
        end
    end)

    if hideNameEnabled or fakeNameEnabled or rainbowEnabled or creatorTagEnabled then
        if not isWorkspaceLooping then
            isWorkspaceLooping = true

            local function infectarTextoSeguro(v)
                local parentGui = v:FindFirstAncestorWhichIsA("ScreenGui")
                if parentGui and (string.find(parentGui.Name, "WindUI") or string.find(parentGui.Name, "Onyx") or string.find(parentGui.Name, "Vortex")) then
                    return
                end

                if v:IsA("TextLabel") or v:IsA("TextBox") or v:IsA("TextButton") then
                    processText(v, myName, myDisp)
                    if not v:GetAttribute(infectAttrName) then
                        v:SetAttribute(infectAttrName, true)
                        v:GetPropertyChangedSignal("Text"):Connect(function()
                            if isWorkspaceLooping and v.Text ~= spoofNameText and v.Text ~= " " and not string.find(v.Text, spoofNameText) and not string.find(v.Text, "%[Content Creator%]") then
                                originalData[v] = nil
                                processText(v, myName, myDisp)
                            end
                        end)
                    end
                end
            end

            local pGui = player:FindFirstChild("PlayerGui")
            if pGui then
                table.insert(visualConnections, pGui.DescendantAdded:Connect(function(nuevoObjeto)
                    if isWorkspaceLooping and (nuevoObjeto:IsA("TextLabel") or nuevoObjeto:IsA("TextBox") or nuevoObjeto:IsA("TextButton")) then
                        task.spawn(function() infectarTextoSeguro(nuevoObjeto) end)
                    end
                end))
            end

            local successCore, coreGui = pcall(function() return game:GetService("CoreGui") end)
            if successCore and coreGui then
                table.insert(visualConnections, coreGui.DescendantAdded:Connect(function(nuevoObjeto)
                    if isWorkspaceLooping and (nuevoObjeto:IsA("TextLabel") or nuevoObjeto:IsA("TextBox") or nuevoObjeto:IsA("TextButton")) then
                        task.spawn(function() infectarTextoSeguro(nuevoObjeto) end)
                    end
                end))
            end
        end
    else
        isWorkspaceLooping = false

        for _, conn in ipairs(visualConnections) do
            pcall(function() conn:Disconnect() end)
        end
        visualConnections = {}

        local char = player.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
            end
        end

        for v, data in pairs(originalData) do
            if v and v.Parent then
                v.Text = data.Text
                v.TextColor3 = data.Color
                v.TextTransparency = data.TextTransp
                v.TextStrokeTransparency = data.StrokeTransp
                for stroke, strokeData in pairs(data.Strokes) do
                    if stroke and stroke.Parent then
                        stroke.Enabled = strokeData.Enabled
                        stroke.Transparency = strokeData.Transp
                        stroke.Thickness = strokeData.Thickness
                    end
                end
            end
        end
    end
end

-- Rainbow live update
task.spawn(function()
    while task.wait(0.08) do
        if rainbowEnabled then
            local myName = player.Name
            local myDisp = player.DisplayName
            for v, _ in pairs(originalData) do
                if v and v.Parent then
                    pcall(processText, v, myName, myDisp)
                end
            end
        end
    end
end)



-- ============================================================
-- ============================================================
-- ESP HIGHLIGHT PROTEGIDO (sin Drawing)
-- - Highlight NO se parenta al Character
-- - Vive en ScreenGui de gethui con nombres random
-- - GetChildren/FindFirstChild del Character ocultan el Highlight
-- - Adornee = character (se ve igual)
-- ============================================================

local EspHolder = Instance.new("ScreenGui")
EspHolder.Name = _randName(16)
EspHolder.ResetOnSpawn = false
EspHolder.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
EspHolder.DisplayOrder = 0
EspHolder.IgnoreGuiInset = true
EspHolder.Enabled = true
_protectInstance(EspHolder)
_setHiddenParent(EspHolder)

local enemyEspMap = {} -- [Player] = Highlight
local allyEspMap = {}
local protectedHighlights = setmetatable({}, { __mode = "k" }) -- weak keys, sin Attribute visible

local function markProtectedHighlight(hl)
    if hl then protectedHighlights[hl] = true end
end

local function isProtectedHighlight(inst)
    return typeof(inst) == "Instance" and inst:IsA("Highlight") and protectedHighlights[inst] == true
end

-- Hook PC: oculta Highlights protegidos de GetChildren / FindFirstChild del juego
local hideHooked = false
pcall(function()
    if hideHooked then return end
    if not (hookmetamethod and getnamecallmethod and checkcaller) then return end
    hideHooked = true
    local old
    local wrapper = function(self, ...)
        local method = getnamecallmethod()
        if not checkcaller() and typeof(self) == "Instance" then
            if method == "GetChildren" or method == "GetDescendants" then
                local children = old(self, ...)
                if type(children) == "table" then
                    local filtered = {}
                    for i = 1, #children do
                        local c = children[i]
                        if not isProtectedHighlight(c) then
                            filtered[#filtered + 1] = c
                        end
                    end
                    return filtered
                end
            elseif method == "FindFirstChild" or method == "FindFirstChildOfClass" or method == "FindFirstChildWhichIsA" then
                local res = old(self, ...)
                if isProtectedHighlight(res) then
                    return nil
                end
                return res
            end
        end
        return old(self, ...)
    end
    if newcclosure then
        old = hookmetamethod(game, "__namecall", newcclosure(wrapper))
    else
        old = hookmetamethod(game, "__namecall", wrapper)
    end
end)

-- En PC renombrar holder cada cierto tiempo
if not IsMobile then
    task.spawn(function()
        while task.wait(7) do
            pcall(function()
                if EspHolder and EspHolder.Parent then
                    EspHolder.Name = _randName(16)
                end
            end)
        end
    end)
end

local function randName()
    return _randName(12)
end

local function makeProtectedHighlight(char, outlineColor, fillColor)
    local hl = Instance.new("Highlight")
    hl.Name = _randName(12)
    markProtectedHighlight(hl)
    hl.Adornee = char
    hl.FillColor = fillColor or outlineColor
    hl.OutlineColor = outlineColor
    hl.FillTransparency = 0.85
    hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    -- NO parent al character: va a EspHolder (gethui)
    hl.Parent = EspHolder
    return hl
end

local function addEnemyESP(char, plr)
    if not char or not char.Parent or not plr then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not root or not hum or hum.Health <= 0 then return end

    local existing = enemyEspMap[plr]
    if existing and existing.Parent then
        pcall(function()
            existing.Adornee = char
            existing.OutlineColor = enemyOutlineColor
            existing.FillColor = enemyOutlineColor
        end)
        return
    end

    if existing then pcall(function() existing:Destroy() end) end
    local ok, hl = pcall(makeProtectedHighlight, char, enemyOutlineColor, enemyOutlineColor)
    if ok and hl then
        enemyEspMap[plr] = hl
    end
end

local function removeEnemyESP(plr)
    if not plr then return end
    local hl = enemyEspMap[plr]
    enemyEspMap[plr] = nil
    if hl then pcall(function() hl:Destroy() end) end
end

local function clearAllEnemyESP()
    for plr, hl in pairs(enemyEspMap) do
        pcall(function() if hl then hl:Destroy() end end)
        enemyEspMap[plr] = nil
    end
end

local function addAllyESP(char, plr)
    if not char or not char.Parent or not plr then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not root or not hum or hum.Health <= 0 then return end

    local existing = allyEspMap[plr]
    if existing and existing.Parent then
        pcall(function()
            existing.Adornee = char
            existing.OutlineColor = allyOutlineColor
            existing.FillColor = allyOutlineColor
        end)
        return
    end

    if existing then pcall(function() existing:Destroy() end) end
    local ok, hl = pcall(makeProtectedHighlight, char, allyOutlineColor, allyOutlineColor)
    if ok and hl then
        hl.FillTransparency = 0.9
        allyEspMap[plr] = hl
    end
end

local function removeAllyESP(plr)
    if not plr then return end
    local hl = allyEspMap[plr]
    allyEspMap[plr] = nil
    if hl then pcall(function() hl:Destroy() end) end
end

local function clearAllAllyESP()
    for plr, hl in pairs(allyEspMap) do
        pcall(function() if hl then hl:Destroy() end end)
        allyEspMap[plr] = nil
    end
end

local function refreshEnemyESP()
    if not espEnabled then
        clearAllEnemyESP()
        return
    end
    local active = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and isEnemy(plr) then
            local char = plr.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                active[plr] = true
                removeAllyESP(plr)
                addEnemyESP(char, plr)
            end
        end
    end
    for plr, _ in pairs(enemyEspMap) do
        if not active[plr] then removeEnemyESP(plr) end
    end
end

local function refreshAllyESP()
    if not allyEspEnabled then
        clearAllAllyESP()
        return
    end
    local active = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and isAlly(plr) then
            local char = plr.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                active[plr] = true
                removeEnemyESP(plr)
                addAllyESP(char, plr)
            end
        end
    end
    for plr, _ in pairs(allyEspMap) do
        if not active[plr] then removeAllyESP(plr) end
    end
end

-- Renombrar Highlights periodicamente (anti name-scan)
task.spawn(function()
    while task.wait(5) do
        for _, map in ipairs({enemyEspMap, allyEspMap}) do
            for plr, hl in pairs(map) do
                if hl and hl.Parent then
                    pcall(function() hl.Name = randName() end)
                end
            end
        end
        pcall(function() EspHolder.Name = randName() end)
    end
end)

local function removeSingleProfDrawings(plr)
    local drawings = professionalEspDrawings[plr]
    if drawings then
        if drawings.box then for _, line in ipairs(drawings.box) do if line then line:Remove() end end end
        if drawings.tracer then drawings.tracer:Remove() end
        if drawings.nameText then drawings.nameText:Remove() end
        professionalEspDrawings[plr] = nil
    end
end

local function clearProfessionalESP()
    for plr, _ in pairs(professionalEspDrawings) do
        removeSingleProfDrawings(plr)
    end
    professionalEspDrawings = {}
end

local function refreshProfessionalESP()
    if not professionalEspEnabled then
        clearProfessionalESP()
        return
    end

    local currentActive = {}

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and isEnemy(plr) and plr.Character then
            local char = plr.Character
            local root = char:FindFirstChild("HumanoidRootPart")
            local head = char:FindFirstChild("Head")
            local hum = char:FindFirstChild("Humanoid")

            if root and head and hum and hum.Health > 0 then
                currentActive[plr] = true

                if not professionalEspDrawings[plr] and hasDrawing then
                    local bLines = {}
                    for i = 1, 4 do
                        local l = Drawing.new("Line")
                        l.Thickness = 1.5
                        l.Color = enemyOutlineColor
                        l.Transparency = 0.8
                        bLines[i] = l
                    end
                    local tracer = Drawing.new("Line")
                    tracer.Thickness = 1.5
                    tracer.Color = enemyOutlineColor
                    tracer.Transparency = 0.8

                    local nameText = Drawing.new("Text")
                    nameText.Text = plr.Name
                    nameText.Size = 13
                    nameText.Center = true
                    nameText.Outline = true
                    nameText.Color = enemyOutlineColor
                    nameText.Transparency = 0.9

                    professionalEspDrawings[plr] = { box = bLines, tracer = tracer, nameText = nameText }
                end

                local drawings = professionalEspDrawings[plr]
                if drawings then
                    local bLines = drawings.box
                    local tracer = drawings.tracer
                    local nameText = drawings.nameText

                    local vector, onScreen = Camera:WorldToViewportPoint(root.Position)
                    local headPos, headOnScreen = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                    local legPos, legOnScreen = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))

                    if onScreen and tracer then
                        tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        tracer.To = Vector2.new(vector.X, vector.Y)
                        tracer.Visible = true
                    elseif tracer then
                        tracer.Visible = false
                    end

                    if headOnScreen and legOnScreen and bLines and nameText then
                        local height = math.abs(headPos.Y - legPos.Y)
                        local width = height / 2
                        local boxPos = Vector2.new(headPos.X - width / 2, headPos.Y)

                        bLines[1].From = boxPos
                        bLines[1].To = Vector2.new(boxPos.X + width, boxPos.Y)
                        bLines[2].From = Vector2.new(boxPos.X + width, boxPos.Y)
                        bLines[2].To = Vector2.new(boxPos.X + width, boxPos.Y + height)
                        bLines[3].From = Vector2.new(boxPos.X + width, boxPos.Y + height)
                        bLines[3].To = Vector2.new(boxPos.X, boxPos.Y + height)
                        bLines[4].From = Vector2.new(boxPos.X, boxPos.Y + height)
                        bLines[4].To = boxPos

                        for i = 1, 4 do bLines[i].Visible = true end
                        nameText.Position = Vector2.new(boxPos.X + (width / 2), boxPos.Y - 16)
                        nameText.Visible = true
                    elseif bLines and nameText then
                        for _, l in ipairs(bLines) do l.Visible = false end
                        nameText.Visible = false
                    end
                end
            else
                removeSingleProfDrawings(plr)
            end
        else
            removeSingleProfDrawings(plr)
        end
    end

    for plr, _ in pairs(professionalEspDrawings) do
        if not currentActive[plr] then
            removeSingleProfDrawings(plr)
        end
    end
end


Players.PlayerRemoving:Connect(function(plr)
    removeEnemyESP(plr)
    removeAllyESP(plr)
    removeSingleProfDrawings(plr)
end)


-- Identity controls (arriba de ESP)
visualsTab:Section({ Title = "Opciones de Identidad y Nombre" })

visualsTab:Toggle({
    Title = "Ocultar mi Nombre (Visual)",
    Desc = "Vuelve tu nombre invisible en tu pantalla.",
    Default = false,
    Callback = function(s)
        hideNameEnabled = s
        updateSystem()
        showBottomMessage(s and "Nombre invisible activado." or "Nombre visible.")
    end
})

visualsTab:Toggle({
    Title = "Activar Nombre Falso",
    Desc = "Reemplaza tu nombre por uno falso (Solo tú lo ves).",
    Default = false,
    Callback = function(s)
        fakeNameEnabled = s
        updateSystem()
        showBottomMessage(s and "Nombre falso activado." or "Nombre falso desactivado.")
    end
})

visualsTab:Input({
    Title = "Nuevo Nombre Falso",
    Placeholder = "Escribe tu nombre falso...",
    Callback = function(txt)
        if txt ~= "" then
            spoofNameText = txt
            if fakeNameEnabled then
                updateSystem()
            end
            showBottomMessage("Nombre guardado: " .. spoofNameText)
        end
    end
})

visualsTab:Toggle({
    Title = "Tag [Content Creator]",
    Desc = "Te pone la etiqueta de creador de contenido de manera visual.",
    Default = false,
    Callback = function(s)
        creatorTagEnabled = s
        updateSystem()
        pcall(function()
            showBottomMessage(s and "Tag de Creador activado." or "Tag de Creador desactivado.")
        end)
    end
})

visualsTab:Toggle({
    Title = "Efecto Arcoíris en Nombre",
    Desc = "Hace que tu nombre brille cambiando de colores dinámicamente RGB.",
    Default = false,
    Callback = function(s)
        rainbowEnabled = s
        updateSystem()
        showBottomMessage(s and "Arcoíris activado." or "Arcoíris desactivado.")
    end
})


visualsTab:Divider()
visualsTab:Paragraph({ Title = "Enemy ESP", Desc = "" })

local espToggleRef = visualsTab:Toggle({
    Title = "ESP Active",
    Desc = "Resalta a los enemigos con Highlight",
    Default = false,
    Callback = function(espEnemyVal)
        espEnabled = espEnemyVal
        if not espEnabled then clearAllEnemyESP() end
    end
})

visualsTab:Keybind({
    Title = "ESP Keybind",
    Desc = "Activar o desactivar el ESP simple",
    Key = "V",
    Callback = function()
        espEnabled = not espEnabled
        if not espEnabled then clearAllEnemyESP() end
        pcall(function() espToggleRef:SetValue(espEnabled) end)
    end
})

local profEspToggleRef = visualsTab:Toggle({
    Title = "Professional ESP",
    Desc = "ESP Unificado 2D (Caja + Líneas + Nombre de Jugador)",
    Default = false,
    Callback = function(val)
        professionalEspEnabled = val
        if not val then clearProfessionalESP() end
    end
})

visualsTab:Keybind({
    Title = "Professional ESP Keybind",
    Desc = "Activar o desactivar el ESP Profesional",
    Key = "B",
    Callback = function()
        professionalEspEnabled = not professionalEspEnabled
        if not professionalEspEnabled then clearProfessionalESP() end
        pcall(function() profEspToggleRef:SetValue(professionalEspEnabled) end)
    end
})

visualsTab:Colorpicker({
    Title = "Outline & Elements Color",
    Desc = "Color del ESP de enemigos (Highlight, líneas, caja y nombre)",
    Default = Color3.fromRGB(255, 190, 40),
    Callback = function(colorVal)
        enemyOutlineColor = colorVal
        for plr, hl in pairs(enemyEspMap) do
            if hl then pcall(function() hl.OutlineColor = colorVal; hl.FillColor = colorVal end) end
        end
        for _, drawings in pairs(professionalEspDrawings) do
            if drawings then
                if drawings.tracer then drawings.tracer.Color = colorVal end
                if drawings.nameText then drawings.nameText.Color = colorVal end
                if drawings.box then
                    for i = 1, #drawings.box do
                        if drawings.box[i] then drawings.box[i].Color = colorVal end
                    end
                end
            end
        end
    end
})

visualsTab:Divider()
visualsTab:Paragraph({ Title = "Ally ESP", Desc = "" })

visualsTab:Toggle({ Title = "Ally ESP", Desc = "Resalta aliados en pantalla", Default = false, Callback = function(espAllyVal) allyEspEnabled = espAllyVal if not allyEspEnabled then clearAllAllyESP() end end })
visualsTab:Colorpicker({ Title = "Ally Outline Color", Desc = "Color del contorno del ESP de aliados", Default = Color3.fromRGB(0, 255, 128), Callback = function(colorVal)
    allyOutlineColor = colorVal
    for plr, hl in pairs(allyEspMap) do
        if hl then pcall(function() hl.OutlineColor = colorVal; hl.FillColor = colorVal end) end
    end
end })




task.spawn(function()
    while task.wait(0.3) do
        if espEnabled then refreshEnemyESP() end
        if allyEspEnabled then refreshAllyESP() end
    end
end)

for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then
        plr.CharacterAdded:Connect(function()
            task.wait(0.35)
            if espEnabled then refreshEnemyESP() end
            if allyEspEnabled then refreshAllyESP() end
        end)
    end
end
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(0.35)
        if espEnabled then refreshEnemyESP() end
        if allyEspEnabled then refreshAllyESP() end
    end)
end)

RunService.RenderStepped:Connect(function()
    if professionalEspEnabled then refreshProfessionalESP() end
end)

-- ==========================================
-- GRAPHICS TAB (MODOS VISUALES / SHADERS)
-- ==========================================
local graphicsTab = mainSection:Tab({ Title = "Graphics", Icon = "monitor", ShowTabTitle = true, Border = true })
Tabs.Graficos = graphicsTab

local shaderEffects = {}
local tokyowamiEffects = {}
local nightEffects = {}
local pinkEffects = {}
local nightActivo = false
local pinkActivo = false

local shaderAjustes = {
    Exposicion = 0.28,
    Sombras = 5,
    Neon = 0.45,
    LunaPos = 85,          
    Desenfoque = 2,        
    SuavidadSombras = 0.1, 
    ColorSaturacion = 0.15,

    PinkRosa = 0.8,
    PinkMorado = 0.7,
    PinkSaturacion = 0.4,
    PinkNeon = 0.3
}

local function ToggleNubesYAtmo(apagar, tag)
    local Lighting = game:GetService("Lighting")

    for _, obj in ipairs(Lighting:GetChildren()) do
        if obj:IsA("Atmosphere") then
            if apagar then
                if not obj:GetAttribute("OrigGuardado_"..tag) then
                    obj:SetAttribute("OrigDensity_"..tag, obj.Density)
                    obj:SetAttribute("OrigCapacity_"..tag, obj.Capacity)
                    obj:SetAttribute("OrigGuardado_"..tag, true)
                end
                obj.Density = 0
                obj.Capacity = 0
            else
                if obj:GetAttribute("OrigGuardado_"..tag) then
                    obj.Density = obj:GetAttribute("OrigDensity_"..tag)
                    obj.Capacity = obj:GetAttribute("OrigCapacity_"..tag)
                    obj:SetAttribute("OrigGuardado_"..tag, nil)
                end
            end
        end
    end

    local function checkClouds(parentObj)
        if not parentObj then return end
        for _, obj in ipairs(parentObj:GetChildren()) do
            if obj:IsA("Clouds") then
                if apagar then
                    if not obj:GetAttribute("OrigGuardado_"..tag) then
                        obj:SetAttribute("OrigEnabled_"..tag, obj.Enabled)
                        obj:SetAttribute("OrigGuardado_"..tag, true)
                    end
                    obj.Enabled = false
                else
                    if obj:GetAttribute("OrigGuardado_"..tag) then
                        obj.Enabled = obj:GetAttribute("OrigEnabled_"..tag)
                        obj:SetAttribute("OrigGuardado_"..tag, nil)
                    end
                end
            end
        end
    end

    checkClouds(workspace)
    checkClouds(workspace:FindFirstChildOfClass("Terrain"))
end

local function UpdatePinkHourVibe()
    if not pinkActivo then return end
    local Lighting = game:GetService("Lighting")

    local rosa = shaderAjustes.PinkRosa
    local morado = shaderAjustes.PinkMorado

    local r = math.clamp(math.floor(255 - (100 * morado)), 0, 255)
    local g = math.clamp(math.floor(255 - (155 * rosa) - (200 * morado)), 0, 255)
    local b = 255

    for _, effect in ipairs(pinkEffects) do
        if effect:IsA("ColorCorrectionEffect") then
            effect.TintColor = Color3.fromRGB(r, g, b)
            effect.Saturation = shaderAjustes.PinkSaturacion
            effect.Contrast = 0.05 + (0.1 * morado) + (0.05 * rosa)
        elseif effect:IsA("BloomEffect") then
            effect.Intensity = shaderAjustes.PinkNeon
        end
    end

    Lighting.ColorShift_Top = Color3.fromRGB(math.floor(255 - (50 * morado)), math.floor(50 + (50 * (1-rosa))), math.floor(150 + (105 * morado)))
    Lighting.ColorShift_Bottom = Color3.fromRGB(math.floor(30 + (70 * rosa)), 0, math.floor(50 + (80 * morado)))
    Lighting.OutdoorAmbient = Color3.fromRGB(math.floor(50 + (80 * rosa)), 0, math.floor(80 + (80 * morado)))
    Lighting.Ambient = Color3.fromRGB(math.floor(60 + (30 * rosa)), math.floor(20 * (1-morado)), math.floor(80 + (40 * morado)))

    Lighting.ExposureCompensation = 0.1 - (0.25 * morado)
end

Tabs.Graficos:Section({Title = "Modos Visuales (Elige solo uno)"})

UIElements.TogTokyowami = Tabs.Graficos:Toggle({
    Title = "Shaders Tokyowami",
    Desc = "Aplica Shaders originales.",
    Callback = function(Value)
        local Lighting = game:GetService("Lighting")

        if Value then
            if not Lighting:GetAttribute("OrigSaved") then
                Lighting:SetAttribute("OrigBright", Lighting.Brightness) Lighting:SetAttribute("OrigCSB", Lighting.ColorShift_Bottom) Lighting:SetAttribute("OrigCST", Lighting.ColorShift_Top) Lighting:SetAttribute("OrigOA", Lighting.OutdoorAmbient) Lighting:SetAttribute("OrigTime", Lighting.ClockTime) Lighting:SetAttribute("OrigFogC", Lighting.FogColor) Lighting:SetAttribute("OrigFogE", Lighting.FogEnd) Lighting:SetAttribute("OrigFogS", Lighting.FogStart) Lighting:SetAttribute("OrigExp", Lighting.ExposureCompensation) Lighting:SetAttribute("OrigShadow", Lighting.ShadowSoftness) Lighting:SetAttribute("OrigAmbient", Lighting.Ambient) Lighting:SetAttribute("OrigSaved", true)
            end

            for _, v in ipairs(tokyowamiEffects) do pcall(function() v:Destroy() end) end table.clear(tokyowamiEffects)

            local Bloom = Instance.new("BloomEffect") Bloom.Intensity = 0.1 Bloom.Threshold = 0 Bloom.Size = 100 Bloom.Parent = Lighting table.insert(tokyowamiEffects, Bloom)
            local Tropic = Instance.new("Sky") Tropic.Name = "Tropic" Tropic.SkyboxUp = "http://www.roblox.com/asset/?id=169210149" Tropic.SkyboxLf = "http://www.roblox.com/asset/?id=169210133" Tropic.SkyboxBk = "http://www.roblox.com/asset/?id=169210090" Tropic.SkyboxFt = "http://www.roblox.com/asset/?id=169210121" Tropic.StarCount = 100 Tropic.SkyboxDn = "http://www.roblox.com/asset/?id=169210108" Tropic.SkyboxRt = "http://www.roblox.com/asset/?id=169210143" Tropic.Parent = Lighting table.insert(tokyowamiEffects, Tropic)
            local Sky = Instance.new("Sky") Sky.SkyboxUp = "http://www.roblox.com/asset/?id=196263782" Sky.SkyboxLf = "http://www.roblox.com/asset/?id=196263721" Sky.SkyboxBk = "http://www.roblox.com/asset/?id=196263721" Sky.SkyboxFt = "http://www.roblox.com/asset/?id=196263721" Sky.CelestialBodiesShown = false Sky.SkyboxDn = "http://www.roblox.com/asset/?id=196263643" Sky.SkyboxRt = "http://www.roblox.com/asset/?id=196263721" Sky.Parent = Lighting table.insert(tokyowamiEffects, Sky)
            local Blur = Instance.new("BlurEffect") Blur.Size = 2 Blur.Parent = Lighting table.insert(tokyowamiEffects, Blur)
            local Inaritaisha = Instance.new("ColorCorrectionEffect") Inaritaisha.Name = "Inari taisha" Inaritaisha.Saturation = 0.05 Inaritaisha.TintColor = Color3.fromRGB(255, 224, 219) Inaritaisha.Parent = Lighting table.insert(tokyowamiEffects, Inaritaisha)
            local SunRays = Instance.new("SunRaysEffect") SunRays.Intensity = 0.05 SunRays.Parent = Lighting table.insert(tokyowamiEffects, SunRays)
            local Sunset = Instance.new("Sky") Sunset.Name = "Sunset" Sunset.SkyboxUp = "rbxassetid://323493360" Sunset.SkyboxLf = "rbxassetid://323494252" Sunset.SkyboxBk = "rbxassetid://323494035" Sunset.SkyboxFt = "rbxassetid://323494130" Sunset.SkyboxDn = "rbxassetid://323494368" Sunset.SunAngularSize = 14 Sunset.SkyboxRt = "rbxassetid://323494067" Sunset.Parent = Lighting table.insert(tokyowamiEffects, Sunset)

            Lighting.Brightness = 2.14 Lighting.ColorShift_Bottom = Color3.fromRGB(11, 0, 20) Lighting.ColorShift_Top = Color3.fromRGB(240, 127, 14) Lighting.OutdoorAmbient = Color3.fromRGB(34, 0, 49) Lighting.ClockTime = 6.7 Lighting.FogColor = Color3.fromRGB(94, 76, 106) Lighting.FogEnd = 1000 Lighting.ExposureCompensation = 0.24 Lighting.ShadowSoftness = 0 Lighting.Ambient = Color3.fromRGB(59, 33, 27)
            showBottomMessage("Tokyowami: ON")
        else
            for _, v in ipairs(tokyowamiEffects) do pcall(function() v:Destroy() end) end table.clear(tokyowamiEffects)
            if Lighting:GetAttribute("OrigSaved") then
                Lighting.Brightness = Lighting:GetAttribute("OrigBright") Lighting.ColorShift_Bottom = Lighting:GetAttribute("OrigCSB") Lighting.ColorShift_Top = Lighting:GetAttribute("OrigCST") Lighting.OutdoorAmbient = Lighting:GetAttribute("OrigOA") Lighting.ClockTime = Lighting:GetAttribute("OrigTime") Lighting.FogColor = Lighting:GetAttribute("OrigFogC") Lighting.FogEnd = Lighting:GetAttribute("OrigFogE") Lighting.ExposureCompensation = Lighting:GetAttribute("OrigExp") Lighting.ShadowSoftness = Lighting:GetAttribute("OrigShadow") Lighting.Ambient = Lighting:GetAttribute("OrigAmbient")
            end
            showBottomMessage("Tokyowami: OFF")
        end
    end
})

UIElements.TogNight = Tabs.Graficos:Toggle({
    Title = "Modo Noche",
    Desc = "Modo noche ajustable.",
    Callback = function(Value)
        local Lighting = game:GetService("Lighting")
        local Terrain = workspace:FindFirstChildOfClass("Terrain")
        nightActivo = Value

        if Value then
            if not Lighting:GetAttribute("OrigSavedNight") then
                Lighting:SetAttribute("OrigBright", Lighting.Brightness) Lighting:SetAttribute("OrigCSB", Lighting.ColorShift_Bottom) Lighting:SetAttribute("OrigCST", Lighting.ColorShift_Top) Lighting:SetAttribute("OrigOA", Lighting.OutdoorAmbient) Lighting:SetAttribute("OrigTime", Lighting.ClockTime) Lighting:SetAttribute("OrigFogC", Lighting.FogColor) Lighting:SetAttribute("OrigFogE", Lighting.FogEnd) Lighting:SetAttribute("OrigExp", Lighting.ExposureCompensation) Lighting:SetAttribute("OrigShadow", Lighting.ShadowSoftness) Lighting:SetAttribute("OrigAmbient", Lighting.Ambient) Lighting:SetAttribute("OrigSpec", Lighting.EnvironmentSpecularScale) Lighting:SetAttribute("OrigDiff", Lighting.EnvironmentDiffuseScale) Lighting:SetAttribute("OrigGlobalS", Lighting.GlobalShadows) Lighting:SetAttribute("OrigGeo", Lighting.GeographicLatitude) Lighting:SetAttribute("OrigSavedNight", true)
            end

            ToggleNubesYAtmo(true, "Night")

            if Terrain and not Terrain:GetAttribute("OrigWaterSavedNight") then
                Terrain:SetAttribute("OrigWaveSize", Terrain.WaterWaveSize) Terrain:SetAttribute("OrigWaveSpeed", Terrain.WaterWaveSpeed) Terrain:SetAttribute("OrigReflectance", Terrain.WaterReflectance) Terrain:SetAttribute("OrigTransparency", Terrain.WaterTransparency) Terrain:SetAttribute("OrigWaterColor", Terrain.WaterColor) Terrain:SetAttribute("OrigWaterSavedNight", true)
            end

            for _, v in ipairs(nightEffects) do pcall(function() v:Destroy() end) end table.clear(nightEffects)

            local blur = Instance.new("BlurEffect") blur.Size = shaderAjustes.Desenfoque blur.Parent = Lighting table.insert(nightEffects, blur)
            local bloom = Instance.new("BloomEffect") bloom.Intensity = shaderAjustes.Neon bloom.Size = 40 bloom.Threshold = 0.2 bloom.Parent = Lighting table.insert(nightEffects, bloom)
            local cc = Instance.new("ColorCorrectionEffect") cc.Brightness = 0.02 cc.Contrast = 0.15 cc.Saturation = shaderAjustes.ColorSaturacion cc.TintColor = Color3.fromRGB(210, 225, 255) cc.Parent = Lighting table.insert(nightEffects, cc)
            local moonRays = Instance.new("SunRaysEffect") moonRays.Intensity = 0.15 moonRays.Spread = 0.75 moonRays.Parent = Lighting table.insert(nightEffects, moonRays)
            local Tropic = Instance.new("Sky") Tropic.Name = "OnyxTokyowamiNight" Tropic.SkyboxUp = "http://www.roblox.com/asset/?id=169210149" Tropic.SkyboxLf = "http://www.roblox.com/asset/?id=169210133" Tropic.SkyboxBk = "http://www.roblox.com/asset/?id=169210090" Tropic.SkyboxFt = "http://www.roblox.com/asset/?id=169210121" Tropic.SkyboxDn = "http://www.roblox.com/asset/?id=169210108" Tropic.SkyboxRt = "http://www.roblox.com/asset/?id=169210143" Tropic.StarCount = 5000 Tropic.MoonAngularSize = 18 Tropic.Parent = Lighting table.insert(nightEffects, Tropic)

            Lighting.ClockTime = 0 
            Lighting.Brightness = 4 Lighting.EnvironmentSpecularScale = 1 Lighting.EnvironmentDiffuseScale = 1 Lighting.GlobalShadows = true 
            Lighting.GeographicLatitude = shaderAjustes.LunaPos Lighting.ShadowSoftness = shaderAjustes.SuavidadSombras Lighting.ExposureCompensation = shaderAjustes.Exposicion Lighting.OutdoorAmbient = Color3.fromRGB(50, 65, 95) 
            local s = shaderAjustes.Sombras Lighting.Ambient = Color3.fromRGB(s, s + 3, s + 10) 
            Lighting.ColorShift_Bottom = Color3.fromRGB(25, 40, 60) Lighting.ColorShift_Top = Color3.fromRGB(160, 180, 240) Lighting.FogColor = Color3.fromRGB(15, 20, 30) Lighting.FogEnd = 2500

            if Terrain then Terrain.WaterWaveSize = 0.12 Terrain.WaterWaveSpeed = 8 Terrain.WaterReflectance = 1 Terrain.WaterTransparency = 0.85 Terrain.WaterColor = Color3.fromRGB(15, 25, 45) end
            showBottomMessage("Noche: ON (Cielo despejado)")
        else
            for _, v in ipairs(nightEffects) do pcall(function() v:Destroy() end) end table.clear(nightEffects)
            if Lighting:GetAttribute("OrigSavedNight") then
                Lighting.Brightness = Lighting:GetAttribute("OrigBright") Lighting.ColorShift_Bottom = Lighting:GetAttribute("OrigCSB") Lighting.ColorShift_Top = Lighting:GetAttribute("OrigCST") Lighting.OutdoorAmbient = Lighting:GetAttribute("OrigOA") Lighting.ClockTime = Lighting:GetAttribute("OrigTime") Lighting.FogColor = Lighting:GetAttribute("OrigFogC") Lighting.FogEnd = Lighting:GetAttribute("OrigFogE") Lighting.ExposureCompensation = Lighting:GetAttribute("OrigExp") Lighting.ShadowSoftness = Lighting:GetAttribute("OrigShadow") Lighting.Ambient = Lighting:GetAttribute("OrigAmbient") Lighting.GlobalShadows = Lighting:GetAttribute("OrigGlobalS")
                if Lighting:GetAttribute("OrigGeo") then Lighting.GeographicLatitude = Lighting:GetAttribute("OrigGeo") end
                if Lighting:GetAttribute("OrigSpec") then Lighting.EnvironmentSpecularScale = Lighting:GetAttribute("OrigSpec") Lighting.EnvironmentDiffuseScale = Lighting:GetAttribute("OrigDiff") end
            end
            ToggleNubesYAtmo(false, "Night")
            if Terrain and Terrain:GetAttribute("OrigWaterSavedNight") then
                Terrain.WaterWaveSize = Terrain:GetAttribute("OrigWaveSize") Terrain.WaterWaveSpeed = Terrain:GetAttribute("OrigWaveSpeed") Terrain.WaterReflectance = Terrain:GetAttribute("OrigReflectance") Terrain.WaterTransparency = Terrain:GetAttribute("OrigTransparency") Terrain.WaterColor = Terrain:GetAttribute("OrigWaterColor")
            end
            showBottomMessage("Noche: OFF")
        end
    end
})

UIElements.TogPink = Tabs.Graficos:Toggle({
    Title = "Pink Hour",
    Desc = "Estilo Synthwave. Cielo y ambiente ajustable con los sliders.",
    Callback = function(Value)
        local Lighting = game:GetService("Lighting")
        pinkActivo = Value

        if Value then
            if not Lighting:GetAttribute("OrigSavedPink") then
                Lighting:SetAttribute("OrigBrightP", Lighting.Brightness) Lighting:SetAttribute("OrigCSBP", Lighting.ColorShift_Bottom) Lighting:SetAttribute("OrigCSTP", Lighting.ColorShift_Top) Lighting:SetAttribute("OrigOAP", Lighting.OutdoorAmbient) Lighting:SetAttribute("OrigTimeP", Lighting.ClockTime) Lighting:SetAttribute("OrigFogCP", Lighting.FogColor) Lighting:SetAttribute("OrigFogEP", Lighting.FogEnd) Lighting:SetAttribute("OrigAmbientP", Lighting.Ambient) Lighting:SetAttribute("OrigExpP", Lighting.ExposureCompensation) Lighting:SetAttribute("OrigShadowP", Lighting.ShadowSoftness) Lighting:SetAttribute("OrigSavedPink", true)
            end

            ToggleNubesYAtmo(true, "Pink")

            for _, v in ipairs(pinkEffects) do pcall(function() v:Destroy() end) end table.clear(pinkEffects)

            local cc = Instance.new("ColorCorrectionEffect")
            cc.Parent = Lighting
            table.insert(pinkEffects, cc)

            local bloom = Instance.new("BloomEffect") bloom.Size = 25 bloom.Threshold = 0.85 bloom.Parent = Lighting table.insert(pinkEffects, bloom)
            local blur = Instance.new("BlurEffect") blur.Size = 2 blur.Parent = Lighting table.insert(pinkEffects, blur)
            local sunRays = Instance.new("SunRaysEffect") sunRays.Intensity = 0.08 sunRays.Spread = 0.8 sunRays.Parent = Lighting table.insert(pinkEffects, sunRays)

            local sky = Instance.new("Sky") sky.Name = "AstraPinkSky" sky.SkyboxUp = "rbxassetid://323493360" sky.SkyboxLf = "rbxassetid://323494252" sky.SkyboxBk = "rbxassetid://323494035" sky.SkyboxFt = "rbxassetid://323494130" sky.SkyboxDn = "rbxassetid://323494368" sky.SkyboxRt = "rbxassetid://323494067" sky.SunAngularSize = 14 sky.StarCount = 3000 sky.Parent = Lighting table.insert(pinkEffects, sky)

            Lighting.Brightness = 2.0 
            Lighting.ClockTime = 6.7 
            Lighting.FogColor = Color3.fromRGB(120, 20, 150) 
            Lighting.FogEnd = 1200 
            Lighting.ShadowSoftness = 0.2 

            UpdatePinkHourVibe()

            showBottomMessage("Pink Hour: ON")
        else
            for _, v in ipairs(pinkEffects) do pcall(function() v:Destroy() end) end table.clear(pinkEffects)
            if Lighting:GetAttribute("OrigSavedPink") then
                Lighting.Brightness = Lighting:GetAttribute("OrigBrightP") Lighting.ColorShift_Bottom = Lighting:GetAttribute("OrigCSBP") Lighting.ColorShift_Top = Lighting:GetAttribute("OrigCSTP") Lighting.OutdoorAmbient = Lighting:GetAttribute("OrigOAP") Lighting.ClockTime = Lighting:GetAttribute("OrigTimeP") Lighting.FogColor = Lighting:GetAttribute("OrigFogEP") Lighting.Ambient = Lighting:GetAttribute("OrigAmbientP") Lighting.ExposureCompensation = Lighting:GetAttribute("OrigExpP") Lighting.ShadowSoftness = Lighting:GetAttribute("OrigShadowP")
            end
            ToggleNubesYAtmo(false, "Pink")
            showBottomMessage("Pink Hour: OFF")
        end
    end
})

Tabs.Graficos:Section({Title = "Ajustes: Modo Noche"})

Tabs.Graficos:Slider({
    Title = "Claridad del Mapa",
    Desc = "Afecta solo al Modo Noche. Úsalo si está muy oscuro.",
    Step = 0.05,
    Value = {Min = 0.0, Max = 1.0, Default = 0.28},
    Callback = function(v)
        shaderAjustes.Exposicion = v
        if nightActivo then game:GetService("Lighting").ExposureCompensation = v end
    end
})

Tabs.Graficos:Slider({
    Title = "Profundidad de Sombras",
    Desc = "0 = Oscuridad total. 50 = Sombra suave y clara.",
    Step = 5,
    Value = {Min = 0, Max = 50, Default = 5},
    Callback = function(v)
        shaderAjustes.Sombras = v
        if nightActivo then game:GetService("Lighting").Ambient = Color3.fromRGB(v, v + 3, v + 10) end
    end
})

Tabs.Graficos:Slider({
    Title = "Resplandor",
    Desc = "Ajusta qué tanto brillan las armas y las luces del mapa.",
    Step = 0.05,
    Value = {Min = 0.1, Max = 1.0, Default = 0.45},
    Callback = function(v)
        shaderAjustes.Neon = v
        if nightActivo then
            for _, effect in ipairs(nightEffects) do
                if effect:IsA("BloomEffect") then effect.Intensity = v end
            end
        end
    end
})

Tabs.Graficos:Slider({
    Title = "Fondo Borroso",
    Desc = "0 = Sin borrosidad. Añade un efecto de cámara cinematográfica.",
    Step = 0.5,
    Value = {Min = 0, Max = 10, Default = 2},
    Callback = function(v)
        shaderAjustes.Desenfoque = v
        if nightActivo then
            for _, effect in ipairs(nightEffects) do
                if effect:IsA("BlurEffect") then effect.Size = v end
            end
        end
    end
})

Tabs.Graficos:Slider({
    Title = "Posición de la Luna",
    Desc = "Mueve la luna en el cielo.",
    Step = 5,
    Value = {Min = 0, Max = 360, Default = 85},
    Callback = function(v)
        shaderAjustes.LunaPos = v
        if nightActivo then game:GetService("Lighting").GeographicLatitude = v end
    end
})

Tabs.Graficos:Section({Title = "Ajustes: Pink Hour"})

Tabs.Graficos:Slider({
    Title = "Intensidad del Morado",
    Desc = "Añade oscuridad y tonos violetas al cielo y al mapa.",
    Step = 0.05,
    Value = {Min = 0.0, Max = 1.0, Default = 0.7},
    Callback = function(v)
        shaderAjustes.PinkMorado = v
        UpdatePinkHourVibe()
    end
})

Tabs.Graficos:Slider({
    Title = "Intensidad del Rosa",
    Desc = "Agrega tonos magentas y rosas a las luces.",
    Step = 0.05,
    Value = {Min = 0.0, Max = 1.0, Default = 0.8},
    Callback = function(v)
        shaderAjustes.PinkRosa = v
        UpdatePinkHourVibe()
    end
})

Tabs.Graficos:Slider({
    Title = "Saturación de Color",
    Desc = "0 = Grisáceo y apagado. 1 = Colores fluorescentes.",
    Step = 0.05,
    Value = {Min = 0.0, Max = 1.0, Default = 0.4},
    Callback = function(v)
        shaderAjustes.PinkSaturacion = v
        UpdatePinkHourVibe()
    end
})

Tabs.Graficos:Slider({
    Title = "Resplandor",
    Desc = "Haz que el cielo y los neones brillen mas.",
    Step = 0.05,
    Value = {Min = 0.0, Max = 1.0, Default = 0.3},
    Callback = function(v)
        shaderAjustes.PinkNeon = v
        if pinkActivo then
            for _, effect in ipairs(pinkEffects) do
                if effect:IsA("BloomEffect") then effect.Intensity = v end
            end
        end
    end
})


-- =====================================
-- ========== AUTO FARM (lógica) ==========
-- =====================================

local AutoFarmActivo = false
local autoFarmLoopRunning = false

Tabs.Farm:Section({ Title = "Opciones de Recolección" })

Tabs.Farm:Toggle({
    Title = "Auto Farm",
    Value = false,
    Callback = function(state)
        AutoFarmActivo = state
        if AutoFarmActivo and not autoFarmLoopRunning then
            autoFarmLoopRunning = true
            task.spawn(function()
                local container = workspace:FindFirstChild("SpawnablesClient")
                if not container then
                    container = workspace:WaitForChild("SpawnablesClient", 10)
                end
                if not container then
                    showBottomMessage("Auto Farm: No se encontró SpawnablesClient")
                    AutoFarmActivo = false
                    autoFarmLoopRunning = false
                    return
                end

                while AutoFarmActivo do
                    for _, obj in ipairs(container:GetChildren()) do
                        if not AutoFarmActivo then break end
                        local touchPart = obj:FindFirstChild("Touch")
                        if touchPart and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            pcall(function()
                                if firetouchinterest then
                                    firetouchinterest(player.Character.HumanoidRootPart, touchPart, 0)
                                    firetouchinterest(player.Character.HumanoidRootPart, touchPart, 1)
                                end
                            end)
                        end
                    end
                    task.wait(0.45)
                end
                autoFarmLoopRunning = false
            end)
        elseif not state then
            AutoFarmActivo = false
        end
    end
})

print("[Vortex] DMvSS v3.2.7 loaded")