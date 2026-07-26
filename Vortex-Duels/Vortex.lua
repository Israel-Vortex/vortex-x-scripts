-- ==========================================
-- VORTEX X SYSTEM V3.1.9 [DMvSS] - CONTADOR GLOBAL EN TIEMPO REAL
-- ==========================================

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- ==========================================
-- SISTEMA DE CONEXIÓN WEB (SUPABASE)
-- ==========================================
local globalOnlineCount = 1

task.spawn(function()
    local SUPABASE_URL = "https://hieuyfqcqvvezmtiimyv.supabase.co"
    local SUPABASE_KEY = "sb_publishable_noBI5J1_1iPrTWxHqTtnqQ_dozthipq"
    
    -- Registrar al usuario actual al iniciar
    pcall(function()
        request({
            Url = SUPABASE_URL .. "/rest/v1/active_users",
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json",
                ["apikey"] = SUPABASE_KEY,
                ["Authorization"] = "Bearer " .. SUPABASE_KEY,
                ["Prefer"] = "resolution=merge-duplicates"
            },
            Body = HttpService:JSONEncode({
                player_id = LocalPlayer.UserId,
                timestamp = os.time()
            })
        })
    end)

    -- Bucle para mantener la sesión activa y consultar el total global de usuarios usando el script
    while task.wait(15) do
        pcall(function()
            -- Enviar ping de actividad
            request({
                Url = SUPABASE_URL .. "/rest/v1/active_users",
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json",
                    ["apikey"] = SUPABASE_KEY,
                    ["Authorization"] = "Bearer " .. SUPABASE_KEY,
                    ["Prefer"] = "resolution=merge-duplicates"
                },
                Body = HttpService:JSONEncode({
                    player_id = LocalPlayer.UserId,
                    timestamp = os.time()
                })
            })

            -- Consultar usuarios activos en los últimos 30 segundos (evita fantasmas por desconexiones repentinas)
            local timeThreshold = os.time() - 30
            local response = request({
                Url = SUPABASE_URL .. "/rest/v1/active_users?timestamp=gte." .. tostring(timeThreshold) .. "&select=player_id",
                Method = "GET",
                Headers = {
                    ["apikey"] = SUPABASE_KEY,
                    ["Authorization"] = "Bearer " .. SUPABASE_KEY
                }
            })

            if response and response.StatusCode == 200 then
                local data = HttpService:JSONDecode(response.Body)
                if type(data) == "table" then
                    globalOnlineCount = #data
                end
            end
        end)
    end
end)

-- Contenedor seguro aislado para evitar detección de instancias
local ProtectedGui = Instance.new("Folder")
ProtectedGui.Name = "VortexXSystem_Protected"
pcall(function()
    ProtectedGui.Parent = CoreGui
end)
if ProtectedGui.Parent ~= CoreGui then
    pcall(function()
        ProtectedGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end)
end

local WindUI = loadstring(game:HttpGet("https://github.com/MrSxxo/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "Vortex X System [DMvSS]",
    Icon = "wind",
    IconSize = "35",
    Author = "by Israelcc",
    Folder = "VortexXSystem",
    Resizable = false,
    HideSearchBar = true,
    Theme = "Dark",
    User = {
        Enabled = true,
        Anonymous = false,
    }
})

Window:EditOpenButton({
    Title = "VortexHub",
    Icon = "wind",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 55, 110)),
        ColorSequenceKeypoint.new(0.4, Color3.fromRGB(0, 162, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 240, 255))
    }),
    OnlyMobile = true,
    Enabled = true,
    Draggable = true,
})

Window:Tag({
    Title = "3.1.9",
    Icon = "github",
    Color = Color3.fromRGB(0, 162, 255)
})

WindUI:AddTheme({
    Name = "VortexXSystem",
    Accent = WindUI:Gradient({
        ["0"] = { Color = Color3.fromRGB(0, 55, 110), Transparency = 0 },
        ["100"] = { Color = Color3.fromRGB(0, 162, 255), Transparency = 0 },
    }, { Rotation = 45 }),
    Background = Color3.fromRGB(2, 4, 8),
    BackgroundTransparency = 0,
    Outline = Color3.fromHex("#00a2ff"),
    Text = Color3.fromRGB(255, 255, 255),
    Placeholder = Color3.fromRGB(255, 255, 255),
    Button = Color3.fromRGB(0, 162, 255),
    Icon = Color3.fromHex("#00a2ff"),
    Hover = Color3.fromRGB(255, 255, 255),
    WindowBackground = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromRGB(2, 5, 10), Transparency = 0.35 },
        ["100"] = { Color = Color3.fromRGB(2, 5, 10), Transparency = 0.35 },
    }, { Rotation = 45 }),
    WindowShadow = Color3.fromHex("#000000"),
    DialogBackground = Color3.fromHex("#051220"),
    DialogBackgroundTransparency = 0,
    DialogTitle = Color3.fromRGB(255, 255, 255),
    DialogContent = Color3.fromRGB(255, 255, 255),
    DialogIcon = Color3.fromHex("#00a2ff"),
    WindowTopbarButtonIcon = Color3.fromRGB(255, 255, 255),
    WindowTopbarTitle = Color3.fromRGB(255, 255, 255),
    WindowTopbarAuthor = Color3.fromRGB(255, 255, 255),
    WindowTopbarIcon = Color3.fromRGB(255, 255, 255),
    TabBackground = Color3.fromHex("#030d1a"),
    TabTitle = Color3.fromRGB(255, 255, 255),
    TabIcon = Color3.fromRGB(0, 162, 255),
    ElementBackground = Color3.fromHex("#030d1a"),
    ElementTitle = Color3.fromRGB(255, 255, 255),
    ElementDesc = Color3.fromRGB(255, 255, 255),
    ElementIcon = Color3.fromHex("#00a2ff"),
    PopupBackground = Color3.fromRGB(5, 15, 25),
    PopupBackgroundTransparency = 0,
    PopupTitle = Color3.fromRGB(255, 255, 255),
    PopupContent = Color3.fromRGB(255, 255, 255),
    PopupIcon = Color3.fromHex("#00a2ff"),
    Toggle = WindUI:Gradient({
        ["0"] = { Color = Color3.fromRGB(0, 55, 110), Transparency = 0 },
        ["100"] = { Color = Color3.fromRGB(0, 162, 255), Transparency = 0 },
    }, { Rotation = 90 }),
    ToggleBar = Color3.fromRGB(5, 12, 25),
    Checkbox = Color3.fromRGB(5, 12, 25),
    CheckboxIcon = Color3.fromRGB(255, 255, 255),
    Slider = WindUI:Gradient({
        ["0"] = { Color = Color3.fromRGB(0, 55, 110), Transparency = 0 },
        ["100"] = { Color = Color3.fromRGB(0, 162, 255), Transparency = 0 },
    }, { Rotation = 0 }),
    SliderThumb = Color3.fromRGB(255, 255, 255),
})

WindUI:SetTheme("VortexXSystem")
Window:SetToggleKey(Enum.KeyCode.K)

Window:OnClose(function()
end)

-- ==========================================
-- SISTEMA DE DETECCIÓN DE ATRIBUTOS
-- ==========================================
local myGame = nil
local myTeam = nil

local function refreshIdentity()
	myGame = LocalPlayer:GetAttribute("Game")
	myTeam = LocalPlayer:GetAttribute("Team")
end

local function isIgnored(plr)
    if not plr or plr == LocalPlayer then
        return true
    end
    return false
end

local function isEnemy(plr)
	if not plr or isIgnored(plr) then
		return false
	end
	if not myGame or not myTeam then
		return false
	end
	local g = plr:GetAttribute("Game")
	local t = plr:GetAttribute("Team")
	return g == myGame and t ~= nil and t ~= myTeam
end

local function isAlly(plr)
	if not plr or plr == LocalPlayer then
		return false
	end
	if not myGame or not myTeam then
		return false
	end
	return plr:GetAttribute("Game") == myGame and plr:GetAttribute("Team") == myTeam
end

task.spawn(function()
    while true do
        refreshIdentity()
        task.wait(1)
    end
end)

-- PESTAÑA CONFIG
local InfoTab = Window:Tab({ Title = "Config", Icon = "settings", ShowTabTitle = true, Border = true })
InfoTab:Select()

InfoTab:Divider()
InfoTab:Paragraph({ Title = "Comunidad", Desc = "" })

InfoTab:Button({
    Title = "Copiar Link de Discord",
    Desc = "Copia el enlace de invitación al portapapeles",
    Callback = function()
        pcall(function() setclipboard("https://discord.gg/Fn74MpzFUn") end)
    end
})

InfoTab:Button({
    Title = "Sitio Web Oficial",
    Desc = "Copia el enlace del sitio web al portapapeles",
    Callback = function()
        pcall(function() setclipboard("https://vortex-x-system.netlify.app/") end)
    end
})

InfoTab:Paragraph({ Title = "Israelcc", Desc = "Desarrollador Principal" })
InfoTab:Paragraph({ Title = "MrSxxo", Desc = "Creditos Especiales / UI Library" })

InfoTab:Divider()
InfoTab:Paragraph({ Title = "Configuracion", Desc = "" })

InfoTab:Keybind({
    Title = "Tecla Menu",
    Desc = "Abrir/Cerrar UI",
    Key = "K",
    Callback = function(keyVal)
        Window:SetToggleKey(Enum.KeyCode[tostring(keyVal)] or Enum.KeyCode.K)
    end
})

InfoTab:Toggle({
    Title = "Notificaciones",
    Desc = "Activar avisos en pantalla",
    Default = false,
    Callback = function(notifVal)
        WindUI:Notify({ Title = "Vortex X System", Content = "Notificaciones: " .. tostring(notifVal), Duration = 2 })
    end
})

InfoTab:Button({
    Title = "Desconectar",
    Desc = "Salir al Lobby",
    Callback = function()
        pcall(function() LocalPlayer:Kick("Desconectado por el usuario.") end)
    end
})

Window:Divider()

-- CONFIGURACIÓN DE COMBATE Y AIMBOT
local aimCamState = false
local cameraConn = nil
local wallCheckEnabled = false
local fovRadius = 150
local silentAimEnabled = false

local function isTargetVisibleLocal(targetPart)
    if not wallCheckEnabled then return true end
    if not targetPart or not LocalPlayer.Character then return true end
    
    local origin = Camera.CFrame.Position
    local direction = targetPart.Position - origin
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    
    local ignoreList = {LocalPlayer.Character}
    if LocalPlayer.Character:FindFirstChild("Head") then
        table.insert(ignoreList, LocalPlayer.Character.Head)
    end
    raycastParams.FilterDescendantsInstances = ignoreList
    raycastParams.IgnoreWater = true
    
    local result = workspace:Raycast(origin, direction, raycastParams)
    if result then
        if result.Instance:IsDescendantOf(targetPart.Parent) then
            return true
        end
        return false
    end
    return true
end

local function setupAimbotLoop()
    if cameraConn then return end
    cameraConn = RunService.RenderStepped:Connect(function()
        if not aimCamState then return end
        pcall(function()
            local target = nil
            local shortestDistance = fovRadius
            local centerScreen = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
            
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                    if isEnemy(v) then
                        local hrp = v.Character.HumanoidRootPart
                        local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                        if onScreen then
                            local distance = (Vector2.new(pos.X, pos.Y) - centerScreen).Magnitude
                            if distance < shortestDistance then
                                if isTargetVisibleLocal(hrp) then
                                    target = hrp
                                    shortestDistance = distance
                                end
                            end
                        end
                    end
                end
            end
            
            if target then
                local currentCamCFrame = Camera.CFrame
                Camera.CFrame = CFrame.new(currentCamCFrame.Position, target.Position)
            end
        end)
    end)
end

local function disconnectAimbotLoop()
    if cameraConn then
        cameraConn:Disconnect()
        cameraConn = nil
    end
end

local silentaim = Window:Tab({
    Title = "Aim Assist",
    Icon = "crosshair",
    ShowTabTitle = true,
    Border = true
})

silentaim:Divider()
silentaim:Paragraph({ Title = "Silent Aim Legit", Desc = "" })

local silentAimToggleRef = silentaim:Toggle({
    Title = "Silent Aim Legit",
    Desc = "Auto Apuntado Legit (Modifica disparos)",
    Default = false,
    Callback = function(aimMetaVal)
        silentAimEnabled = aimMetaVal
    end
})

silentaim:Keybind({
    Title = "Tecla de Silent Aim",
    Desc = "Activa o desactiva el Silent Aim",
    Key = "Z",
    Callback = function()
        silentAimEnabled = not silentAimEnabled
        pcall(function() silentAimToggleRef:SetValue(silentAimEnabled) end)
    end
})

silentaim:Divider()
silentaim:Paragraph({ Title = "Aimbot", Desc = "" })

local aimbotToggleRef = silentaim:Toggle({
    Title = "Aimbot",
    Desc = "Mueve la camara hacia el enemigo",
    Default = false,
    Callback = function(aimCamVal)
        aimCamState = aimCamVal
        if aimCamState then
            setupAimbotLoop()
        else
            disconnectAimbotLoop()
        end
    end
})

silentaim:Keybind({
    Title = "Tecla de Aimbot",
    Desc = "Activa o desactiva el Aimbot",
    Key = "X",
    Callback = function()
        aimCamState = not aimCamState
        if aimCamState then
            setupAimbotLoop()
        else
            disconnectAimbotLoop()
        end
        pcall(function() aimbotToggleRef:SetValue(aimCamState) end)
    end
})

silentaim:Slider({
    Title = "Rango de Vision (FOV)",
    Step = 1,
    Value = {Min = 10, Max = 500, Default = 150},
    Flag = "fov_size",
    Callback = function(fovVal)
        fovRadius = fovVal
    end
})

silentaim:Divider()
silentaim:Paragraph({ Title = "Wall-Check", Desc = "" })

silentaim:Toggle({
    Title = "Wall-Check",
    Desc = "Verificar si el objetivo es visible a través de paredes",
    Default = false,
    Callback = function(wallCheckVal)
        wallCheckEnabled = wallCheckVal
    end
})

pcall(function()
    local mt = getrawmetatable(Mouse)
    local oldIndex = mt.__index
    setreadonly(mt, false)

    mt.__index = newcclosure(function(self, index)
        if (index == "Hit" or index == "Target") and silentAimEnabled then
            local target = nil
            local shortestDistance = math.huge
            local centerScreen = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
            
            for _, v in pairs(Players:GetPlayers()) do
                if isEnemy(v) and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                    local hrp = v.Character.HumanoidRootPart
                    if isTargetVisibleLocal(hrp) then
                        local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                        
                        if onScreen then
                            local distance = (Vector2.new(pos.X, pos.Y) - centerScreen).Magnitude
                            if distance < shortestDistance then
                                target = hrp
                                shortestDistance = distance
                            end
                        end
                    end
                end
            end
            
            if target then
                if index == "Hit" then return target.CFrame end
                if index == "Target" then return target end
            end
        end
        return oldIndex(self, index)
    end)
    setreadonly(mt, true)
end)

silentaim:Divider()
silentaim:Paragraph({ Title = "Crosshair", Desc = "" })

local crosshairGui = nil
local crosshairColor = Color3.fromRGB(0, 162, 255)
local crosshairSizeVal = 6
local crosshairGapVal = 4

local function updateCrosshairUI()
    if not crosshairGui then return end
    local container = crosshairGui:FindFirstChild("Container")
    if not container then return end

    local top = container:FindFirstChild("Top")
    local topOutline = container:FindFirstChild("Top_Outline")
    local bottom = container:FindFirstChild("Bottom")
    local bottomOutline = container:FindFirstChild("Bottom_Outline")
    local left = container:FindFirstChild("Left")
    local leftOutline = container:FindFirstChild("Left_Outline")
    local right = container:FindFirstChild("Right")
    local rightOutline = container:FindFirstChild("Right_Outline")

    if top and topOutline and bottom and bottomOutline and left and leftOutline and right and rightOutline then
        topOutline.Size = UDim2.new(0, 4, 0, crosshairSizeVal + 2)
        topOutline.Position = UDim2.new(0.5, -2, 0, -crosshairGapVal - crosshairSizeVal - 1)
        top.Size = UDim2.new(0, 2, 0, crosshairSizeVal)
        top.Position = UDim2.new(0.5, -1, 0, -crosshairGapVal - crosshairSizeVal)

        bottomOutline.Size = UDim2.new(0, 4, 0, crosshairSizeVal + 2)
        bottomOutline.Position = UDim2.new(0.5, -2, 0, crosshairGapVal - 1)
        bottom.Size = UDim2.new(0, 2, 0, crosshairSizeVal)
        bottom.Position = UDim2.new(0.5, -1, 0, crosshairGapVal)

        leftOutline.Size = UDim2.new(0, crosshairSizeVal + 2, 0, 4)
        leftOutline.Position = UDim2.new(0, -crosshairGapVal - crosshairSizeVal - 1, 0.5, -2)
        left.Size = UDim2.new(0, crosshairSizeVal, 0, 2)
        left.Position = UDim2.new(0, -crosshairGapVal - crosshairSizeVal, 0.5, -1)

        rightOutline.Size = UDim2.new(0, crosshairSizeVal + 2, 0, 4)
        rightOutline.Position = UDim2.new(0, crosshairGapVal - 1, 0.5, -2)
        right.Size = UDim2.new(0, crosshairSizeVal, 0, 2)
        right.Position = UDim2.new(0, crosshairGapVal, 0.5, -1)
    end
end

local function toggleCrosshairFunc(crosshairVal)
    if crosshairVal then
        if not crosshairGui then
            local screenGui = Instance.new("ScreenGui")
            screenGui.Name = "VortexXSystemCrosshair"
            screenGui.ResetOnSpawn = false
            pcall(function() screenGui.Parent = ProtectedGui end)
            if not screenGui.Parent then
                screenGui.Parent = (gethui and gethui()) or CoreGui
            end

            local centerFrame = Instance.new("Frame")
            centerFrame.Name = "Container"
            centerFrame.AnchorPoint = Vector2.new(0.5, 0.5)
            centerFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
            centerFrame.Size = UDim2.new(0, 0, 0, 0)
            centerFrame.BackgroundTransparency = 1
            centerFrame.Parent = screenGui

            local function createPart(name, size, pos)
                local outline = Instance.new("Frame")
                outline.Name = name .. "_Outline"
                outline.Size = UDim2.new(size.X.Scale, size.X.Offset + 2, size.Y.Scale, size.Y.Offset + 2)
                outline.Position = UDim2.new(pos.X.Scale, pos.X.Offset - 1, pos.Y.Scale, pos.Y.Offset - 1)
                outline.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                outline.BorderSizePixel = 0
                outline.Parent = centerFrame

                local line = Instance.new("Frame")
                line.Name = name
                line.Size = size
                line.Position = pos
                line.BackgroundColor3 = crosshairColor
                line.BorderSizePixel = 0
                line.Parent = centerFrame

                return line
            end

            createPart("Top", UDim2.new(0, 2, 0, crosshairSizeVal), UDim2.new(0.5, -1, 0, -crosshairGapVal - crosshairSizeVal))
            createPart("Bottom", UDim2.new(0, 2, 0, crosshairSizeVal), UDim2.new(0.5, -1, 0, crosshairGapVal))
            createPart("Left", UDim2.new(0, crosshairSizeVal, 0, 2), UDim2.new(0, -crosshairGapVal - crosshairSizeVal, 0.5, -1))
            createPart("Right", UDim2.new(0, crosshairSizeVal, 0, 2), UDim2.new(0, crosshairGapVal, 0.5, -1))

            crosshairGui = screenGui
        else
            crosshairGui.Enabled = true
        end
        updateCrosshairUI()
    else
        if crosshairGui then
            crosshairGui.Enabled = false
        end
    end
end

silentaim:Toggle({
    Title = "Crosshair",
    Desc = "Activar mira flotante tipo cruzeta",
    Default = false,
    Callback = toggleCrosshairFunc
})

silentaim:Slider({
    Title = "Tamaño Crosshair",
    Step = 1,
    Value = {Min = 2, Max = 30, Default = 6},
    Flag = "crosshair_size",
    Callback = function(sizeVal)
        crosshairSizeVal = sizeVal
        updateCrosshairUI()
    end
})

silentaim:Colorpicker({
    Title = "Color Crosshair",
    Desc = "Cambiar color de la cruz",
    Default = Color3.fromRGB(0, 162, 255),
    Callback = function(colorVal)
        crosshairColor = colorVal
        if crosshairGui then
            local container = crosshairGui:FindFirstChild("Container")
            if container then
                for _, line in ipairs(container:GetChildren()) do
                    if line:IsA("Frame") and not line.Name:find("Outline") then
                        line.BackgroundColor3 = colorVal
                    end
                end
            end
        end
    end
})

local hitboxState = false
local visibleState = false
local hitboxSizeVal = 10

local function applyStealthHitbox()
    pcall(function()
        if not hitboxState then return end
        for _, plr in pairs(Players:GetPlayers()) do
            if isEnemy(plr) and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = plr.Character.HumanoidRootPart
                local humanoid = plr.Character:FindFirstChild("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    hrp.Size = Vector3.new(hitboxSizeVal, hitboxSizeVal, hitboxSizeVal)
                    hrp.CanCollide = false
                    if visibleState then
                        hrp.Transparency = 0.5
                        hrp.Color = Color3.fromRGB(0, 162, 255)
                        hrp.Material = Enum.Material.Neon
                    else
                        hrp.Transparency = 1
                    end
                end
            elseif plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = plr.Character.HumanoidRootPart
                hrp.Size = Vector3.new(2, 2, 1)
            end
        end
    end)
end

local hitbox = Window:Tab({
    Title = "Hitbox",
    Icon = "box",
    ShowTabTitle = true,
    Border = true
})

hitbox:Divider()
hitbox:Paragraph({ Title = "Hitbox Extendido", Desc = "" })

local hitboxToggleRef = hitbox:Toggle({
    Title = "Activar Hitbox",
    Desc = "Ampliar hitbox exclusivamente de enemigos",
    Default = false,
    Callback = function(hitboxVal)
        hitboxState = hitboxVal
        if not hitboxVal then
            pcall(function()
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        local hrp = plr.Character.HumanoidRootPart
                        hrp.Size = Vector3.new(2, 2, 1)
                        hrp.Transparency = 1
                        hrp.Material = Enum.Material.Plastic
                    end
                end
            end)
        end
    end
})

hitbox:Keybind({
    Title = "Tecla de Hitbox",
    Desc = "Activa o desactiva la Hitbox",
    Key = "C",
    Callback = function()
        hitboxState = not hitboxState
        pcall(function() hitboxToggleRef:SetValue(hitboxState) end)
    end
})

hitbox:Divider()
hitbox:Paragraph({ Title = "Hitbox Visible", Desc = "" })

hitbox:Toggle({
    Title = "Hitbox Visible",
    Desc = "Mostrar hitboxes visualmente para enemigos",
    Default = false,
    Callback = function(visibleVal)
        visibleState = visibleVal
    end
})

hitbox:Slider({
    Title = "Tamaño de Hitbox",
    Step = 1,
    Value = {Min = 1, Max = 50, Default = 10},
    Flag = "hitbox_size",
    Callback = function(sizeVal)
        hitboxSizeVal = sizeVal
    end
})

task.spawn(function()
    while true do
        if hitboxState then
            applyStealthHitbox()
        end
        task.wait(0.2)
    end
end)

local espEnabled = false
local allyEspEnabled = false
local outlineEnabled = true
local enemyOutlineColor = Color3.fromRGB(0, 162, 255)
local allyOutlineColor = Color3.fromRGB(0, 255, 128)

local function addEnemyESP(char)
	if not char or not char.Parent then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root or root:FindFirstChild("ESPAura") then return end
	local hum = char:FindFirstChild("Humanoid")
	if not hum or hum.Health <= 0 then return end
	pcall(function()
		local hl = Instance.new("Highlight")
		hl.Name = "ESPAura"
		hl.Adornee = char
		hl.FillColor = Color3.fromRGB(0, 0, 0)
		hl.OutlineColor = enemyOutlineColor
		hl.FillTransparency = 0.9
		hl.OutlineTransparency = outlineEnabled and 0 or 1
		hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		hl.Parent = root
	end)
end

local function removeEnemyESP(char)
	if not char then return end
	pcall(function()
		local root = char:FindFirstChild("HumanoidRootPart")
		if root then
			local hl = root:FindFirstChild("ESPAura")
			if hl then hl:Destroy() end
		end
	end)
end

local function clearAllEnemyESP()
	for _, p in ipairs(Players:GetPlayers()) do
		if p.Character then removeEnemyESP(p.Character) end
	end
end

local function refreshEnemyESP()
	if not espEnabled then return end
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character then
			local char = plr.Character
			if char.Parent and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
				if isEnemy(plr) then addEnemyESP(char) end
			end
		end
	end
end

local function addAllyESP(char)
	if not char or not char.Parent then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root or root:FindFirstChild("AllyESPAura") then return end
	local hum = char:FindFirstChild("Humanoid")
	if not hum or hum.Health <= 0 then return end
	pcall(function()
		local hl = Instance.new("Highlight")
		hl.Name = "AllyESPAura"
		hl.Adornee = char
		hl.FillColor = Color3.fromRGB(0, 0, 0)
		hl.OutlineColor = allyOutlineColor
		hl.FillTransparency = 0.9
		hl.OutlineTransparency = 0
		hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		hl.Parent = root
	end)
end

local function removeAllyESP(char)
	if not char then return end
	pcall(function()
		local root = char:FindFirstChild("HumanoidRootPart")
		if root then
			local hl = root:FindFirstChild("AllyESPAura")
			if hl then hl:Destroy() end
		end
	end)
end

local function clearAllAllyESP()
	for _, p in ipairs(Players:GetPlayers()) do
		if p.Character then removeAllyESP(p.Character) end
	end
end

local function refreshAllyESP()
	if not allyEspEnabled then return end
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character then
			local char = plr.Character
			if char.Parent and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
				if isAlly(plr) then addAllyESP(char) end
			end
		end
	end
end

local visuals = Window:Tab({
    Title = "Esp",
    Icon = "eye",
    ShowTabTitle = true,
    Border = true
})

visuals:Divider()
visuals:Paragraph({ Title = "Shaders / Modo Noche", Desc = "" })

local function applyShaders()
    for _, v in ipairs(Lighting:GetChildren()) do
        if v:IsA("Sky") or v:IsA("Atmosphere")
        or v:IsA("BloomEffect")
        or v:IsA("ColorCorrectionEffect")
        or v:IsA("SunRaysEffect") then
            v:Destroy()
        end
    end
    Lighting.ClockTime = 1
    Lighting.Brightness = 1
    Lighting.ExposureCompensation = 0.1
    Lighting.Ambient = Color3.fromRGB(15, 25, 45)
    Lighting.OutdoorAmbient = Color3.fromRGB(25, 35, 60)
    Lighting.FogEnd = 100000

    local Sky = Instance.new("Sky")
    Sky.Parent = Lighting
    Sky.SkyboxBk = "rbxassetid://159454299"
    Sky.SkyboxDn = "rbxassetid://159454296"
    Sky.SkyboxFt = "rbxassetid://159454293"
    Sky.SkyboxLf = "rbxassetid://159454286"
    Sky.SkyboxRt = "rbxassetid://159454300"
    Sky.SkyboxUp = "rbxassetid://159454288"
    Sky.StarCount = 5000
    Sky.CelestialBodiesShown = true

    local Atmosphere = Instance.new("Atmosphere")
    Atmosphere.Parent = Lighting
    Atmosphere.Color = Color3.fromRGB(100, 180, 255)
    Atmosphere.Decay = Color3.fromRGB(10, 40, 90)
    Atmosphere.Density = 0.21
    Atmosphere.Haze = 1.5

    local CC = Instance.new("ColorCorrectionEffect")
    CC.Parent = Lighting
    CC.TintColor = Color3.fromRGB(170, 220, 255)
    CC.Contrast = 0.1
    CC.Saturation = 0.2
    CC.Brightness = 0.06

    local Bloom = Instance.new("BloomEffect")
    Bloom.Parent = Lighting
    Bloom.Intensity = 1.5
    Bloom.Size = 45
    Bloom.Threshold = 0.8
end

local function shadersCallback(state)
    if state then
        applyShaders()
    else
        for _, v in ipairs(Lighting:GetChildren()) do
            if v:IsA("Sky") or v:IsA("Atmosphere")
            or v:IsA("BloomEffect")
            or v:IsA("ColorCorrectionEffect")
            or v:IsA("SunRaysEffect") then
                v:Destroy()
            end
        end
        Lighting.ClockTime = 14
        Lighting.Brightness = 2
        Lighting.ExposureCompensation = 0
        Lighting.Ambient = Color3.fromRGB(128, 128, 128)
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    end
end

visuals:Toggle({
    Title = "Shaders Modo Noche",
    Desc = "Activa la galaxia oscura y efectos visuales",
    Default = false,
    Callback = shadersCallback
})

visuals:Divider()
visuals:Paragraph({ Title = "Esp Enemigos", Desc = "" })

local espToggleRef = visuals:Toggle({
    Title = "ESP Activo",
    Desc = "Ver jugadores enemigos con claridad",
    Default = false,
    Callback = function(espEnemyVal)
        espEnabled = espEnemyVal
        if not espEnabled then
            clearAllEnemyESP()
        end
    end
})

visuals:Keybind({
    Title = "Tecla de ESP",
    Desc = "Activa o desactiva el ESP",
    Key = "V",
    Callback = function()
        espEnabled = not espEnabled
        if not espEnabled then
            clearAllEnemyESP()
        end
        pcall(function() espToggleRef:SetValue(espEnabled) end)
    end
})

visuals:Colorpicker({
    Title = "Color Outline",
    Desc = "Color del contorno del ESP de enemigos",
    Default = Color3.fromRGB(0, 162, 255),
    Callback = function(colorVal)
        enemyOutlineColor = colorVal
    end
})

visuals:Divider()
visuals:Paragraph({ Title = "Esp Ally", Desc = "" })

visuals:Toggle({
    Title = "Ally ESP",
    Desc = "Ver aliados claramente",
    Default = false,
    Callback = function(espAllyVal)
        allyEspEnabled = espAllyVal
        if not allyEspEnabled then
            clearAllAllyESP()
        end
    end
})

visuals:Colorpicker({
    Title = "Color Ally Outline",
    Desc = "Color del contorno del ESP de aliados",
    Default = Color3.fromRGB(0, 255, 128),
    Callback = function(colorVal)
        allyOutlineColor = colorVal
    end
})

task.spawn(function()
    while true do
        if espEnabled then
            refreshEnemyESP()
        end
        if allyEspEnabled then
            refreshAllyESP()
        end
        task.wait(0.5)
    end
end)

local playerSettings = {
    WalkSpeed = { Enabled = false, Value = 16 },
    JumpPower = { Enabled = false, Value = 50 },
    InfiniteJump = false,
    Noclip = false
}

local playerTab = Window:Tab({
    Title = "Player Cheats",
    Icon = "user",
    ShowTabTitle = true,
    Border = true
})

playerTab:Divider()
playerTab:Paragraph({ Title = "WalkSpeed / JumpPower", Desc = "" })

playerTab:Toggle({
    Title = "Activar WalkSpeed",
    Desc = "Modificar velocidad de movimiento",
    Default = false,
    Callback = function(state)
        playerSettings.WalkSpeed.Enabled = state
    end
})

playerTab:Slider({
    Title = "Velocidad",
    Step = 1,
    Value = {Min = 16, Max = 200, Default = 16},
    Callback = function(val)
        playerSettings.WalkSpeed.Value = val
    end
})

playerTab:Toggle({
    Title = "Activar JumpPower",
    Desc = "Modificar potencia de salto",
    Default = false,
    Callback = function(state)
        playerSettings.JumpPower.Enabled = state
    end
})

playerTab:Slider({
    Title = "Poder de Salto",
    Step = 1,
    Value = {Min = 50, Max = 300, Default = 50},
    Callback = function(val)
        playerSettings.JumpPower.Value = val
    end
})

playerTab:Divider()
playerTab:Paragraph({ Title = "Movimiento Especial", Desc = "" })

playerTab:Toggle({
    Title = "Salto Infinito",
    Desc = "Saltar multiples veces en el aire",
    Default = false,
    Callback = function(state)
        playerSettings.InfiniteJump = state
    end
})

playerTab:Toggle({
    Title = "Noclip",
    Desc = "Atravesar paredes y objetos",
    Default = false,
    Callback = function(state)
        playerSettings.Noclip = state
    end
})

Window:Divider()
Window:Divider()

local externalScriptsTab = Window:Tab({
    Title = "External Scripts",
    Icon = "terminal",
    ShowTabTitle = true,
    Border = true
})

externalScriptsTab:Divider()
externalScriptsTab:Paragraph({ Title = "Scripts Externos", Desc = "" })

externalScriptsTab:Button({
    Title = "Emotes",
    Desc = "Ejecutar script de emotes universales",
    Callback = function()
        pcall(function()
            loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-AFEM-Max-Open-Alpha-50210"))()
        end)
    end
})

externalScriptsTab:Button({
    Title = "Copiar Emotes Script",
    Desc = "Copia el loadstring completo del script de emotes al portapapeles",
    Callback = function()
        pcall(function() setclipboard('loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-AFEM-Max-Open-Alpha-50210"))()') end)
    end
})

externalScriptsTab:Divider()
externalScriptsTab:Paragraph({ Title = "Streamer Mode", Desc = "by Ryshub" })

externalScriptsTab:Button({
    Title = "Streamer Mode",
    Desc = "Ejecutar script Streamer Mode",
    Callback = function()
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Ryshub/scripts_public/main/streamer_mode_dmvss.lua"))()
        end)
    end
})

externalScriptsTab:Button({
    Title = "Copiar Streamer Mode Script",
    Desc = "Copia el loadstring completo del script Streamer Mode al portapapeles",
    Callback = function()
        pcall(function() setclipboard('loadstring(game:HttpGet("https://raw.githubusercontent.com/Ryshub/scripts_public/main/streamer_mode_dmvss.lua"))()') end)
    end
})

getgenv().Config = getgenv().Config or {}
getgenv().Config.autoCollect = false

local eventBoxesTab = Window:Tab({
    Title = "Event & Boxes",
    Icon = "gift",
    ShowTabTitle = true,
    Border = true
})

eventBoxesTab:Divider()
eventBoxesTab:Paragraph({ Title = "Atlantis Event", Desc = "" })

eventBoxesTab:Toggle({
    Title = "Atlantis Event",
    Desc = "Recolecta automáticamente tokens o coins del evento de Atlantis",
    Default = false,
    Callback = function(val)
        getgenv().Config.autoCollect = val
    end
})

task.spawn(function()
    while task.wait(0.5) do
        if getgenv().Config and getgenv().Config.autoCollect then
            pcall(function()
                local Networking = ReplicatedStorage:FindFirstChild("Packages") and ReplicatedStorage.Packages:FindFirstChild("Networking")
                if Networking and Networking:FindFirstChild("RE/Events/CollectEventSpawnable") then
                    Networking["RE/Events/CollectEventSpawnable"]:FireServer()
                end
            end)
        end
    end
end)

task.spawn(function()
    while true do
        pcall(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                local humanoid = LocalPlayer.Character.Humanoid
                if playerSettings.WalkSpeed.Enabled then
                    humanoid.WalkSpeed = playerSettings.WalkSpeed.Value
                end
                if playerSettings.JumpPower.Enabled then
                    humanoid.UseJumpPower = true
                    humanoid.JumpPower = playerSettings.JumpPower.Value
                end
            end
        end)
        task.wait(0.1)
    end
end)

RunService.Stepped:Connect(function()
    pcall(function()
        if playerSettings.Noclip and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end)
end)

UserInputService.JumpRequest:Connect(function()
    pcall(function()
        if playerSettings.InfiniteJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end)
