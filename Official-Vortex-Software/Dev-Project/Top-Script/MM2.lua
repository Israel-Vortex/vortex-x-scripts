-- ==========================================
-- VORTEX X SOFTWARE v3.3.43 [MM2] - ZONE KILL AURA, AUTO FARM, WEAPON TOOLS & SILENT AIM
-- ==========================================

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local TextChatService = game:GetService("TextChatService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- ==========================================
-- VARIABLES DE ESTADO Y CONTROL (AUTO FARM & SILENT AIM)
-- ==========================================
local coinAutofarmEnabled = false -- Control Coin Autofarm
local candyAutofarmEnabled = false -- Control Candy Autofarm
local autoResetEnabled = false -- Control Auto Reset (Bolsa llena)
local autoResetAux = false -- Auxiliar de Reset
local autoFlingMurdererEnabled = false -- Control Auto Fling Murderer
local processedItemsTable = {}    -- Tabla de elementos procesados
local autofarmSpeed = 25    -- Velocidad del Autofarm (Modificada por el Slider)
local collectedCount = 0     -- Contador de objetos recolectados
local currentBagAmount = 0     -- Cantidad actual en la bolsa
local maxBagCapacity = 40    -- Capacidad máxima de la bolsa
local isRoundActive = true  -- Estado de ronda activa
local isBusy = false -- Estado ocupado (muriendo / reseteando)

local silentAimEnabled = false -- Control de Silent Aim

-- ==========================================
-- ROUND TIMER UI CREATION (SMALLER & HIGHER)
-- ==========================================
local vortexTimerUI = Instance.new("ScreenGui")
vortexTimerUI.Name = "VortexTimerUI"
vortexTimerUI.Parent = CoreGui
vortexTimerUI.Enabled = false
vortexTimerUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local timerFrame = Instance.new("Frame")
timerFrame.Name = "TimerFrame"
timerFrame.Position = UDim2.new(0.5, 0, 0, 8) 
timerFrame.Size = UDim2.new(0, 110, 0, 20)
timerFrame.AnchorPoint = Vector2.new(0.5, 0)
timerFrame.BackgroundColor3 = Color3.fromRGB(15, 8, 10)
timerFrame.BorderSizePixel = 0
timerFrame.Parent = vortexTimerUI

local uiCornerTimer = Instance.new("UICorner")
uiCornerTimer.CornerRadius = UDim.new(0, 4)
uiCornerTimer.Parent = timerFrame

local uiStrokeTimer = Instance.new("UIStroke")
uiStrokeTimer.Thickness = 1.2
uiStrokeTimer.Color = Color3.fromRGB(255, 255, 255)
uiStrokeTimer.Parent = timerFrame

local strokeGradient = Instance.new("UIGradient")
strokeGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(220, 20, 60)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 85))
})
strokeGradient.Parent = uiStrokeTimer

local timerText = Instance.new("TextLabel")
timerText.Name = "TimeText"
timerText.Size = UDim2.new(1, 0, 1, 0)
timerText.BackgroundTransparency = 1
timerText.Font = Enum.Font.GothamBold
timerText.Text = "TIME: 00:00"
timerText.TextColor3 = Color3.fromRGB(255, 255, 255)
timerText.TextSize = 10
timerText.Parent = timerFrame

local timerConnection
local cachedTimerVal = nil
local function ToggleTimerDisplay(state)
    vortexTimerUI.Enabled = state
    if state then
        local counter = 0
        timerConnection = RunService.RenderStepped:Connect(function()
            counter = counter + 1
            local foundVal = nil
            pcall(function()
                if cachedTimerVal and cachedTimerVal.Parent then
                    if cachedTimerVal:IsA("IntValue") or cachedTimerVal:IsA("NumberValue") or cachedTimerVal:IsA("StringValue") then
                        foundVal = cachedTimerVal.Value
                    elseif cachedTimerVal:IsA("TextLabel") or cachedTimerVal:IsA("TextBox") then
                        foundVal = cachedTimerVal.Text
                    end
                end
                
                if not foundVal or counter % 30 == 0 then
                    for _, v in ipairs(workspace:GetDescendants()) do
                        local nLower = v.Name:lower()
                        if nLower:find("roundtime") or nLower:find("time") or nLower:find("timer") then
                            if v:IsA("IntValue") or v:IsA("NumberValue") or v:IsA("StringValue") then
                                cachedTimerVal = v
                                foundVal = v.Value
                                break
                            elseif v:IsA("TextLabel") or v:IsA("TextBox") then
                                if v.Text and v.Text ~= "" then
                                    cachedTimerVal = v
                                    foundVal = v.Text
                                    break
                                end
                            end
                        end
                    end
                end
                
                if not foundVal then
                    local pGui = LocalPlayer:FindFirstChild("PlayerGui")
                    if pGui then
                        for _, gui in ipairs(pGui:GetDescendants()) do
                            if gui:IsA("TextLabel") then
                                local gName = gui.Name:lower()
                                local gText = gui.Text or ""
                                if gName:find("timer") or gName:find("time") or gText:match("^%d+$") or gText:match("^%d+:%d+$") then
                                    if gText ~= "" and #gText < 15 then
                                        foundVal = gText
                                        break
                                    end
                                end
                            end
                        end
                    end
                end
            end)
            
            if foundVal ~= nil and tostring(foundVal) ~= "" and tostring(foundVal):lower() ~= "waiting..." and tostring(foundVal):lower() ~= "esperando..." and tostring(foundVal):lower() ~= "waiting" then
                timerText.Text = "TIME: " .. tostring(foundVal)
            else
                timerText.Text = "TIME: --:--"
            end
        end)
    else
        cachedTimerVal = nil
        if timerConnection then
            timerConnection:Disconnect()
            timerConnection = nil
        end
    end
end

-- ==========================================
-- WIND UI SETUP Y TEMA (MM2)
-- ==========================================
local WindUI = loadstring(game:HttpGet("https://github.com/MrSxxo/WindUI/releases/latest/download/main.lua"))()

WindUI:Notify({ Title = "Vortex x Software", Content = "Iniciando sesion... Por favor espera.", Duration = 3 })
task.wait(3)
WindUI:Notify({ Title = "Vortex x Software", Content = "Acceso Concedido, " .. LocalPlayer.Name .. "! Cargando interfaz...", Duration = 2 })
task.wait(2)

WindUI:AddTheme({
    Name = "VortexCrimsonSolid",
    Accent = WindUI:Gradient({ ["0"] = { Color = Color3.fromRGB(150, 0, 30), Transparency = 0 }, ["100"] = { Color = Color3.fromRGB(255, 30, 80), Transparency = 0 } }, { Rotation = 45 }),
    Background = Color3.fromRGB(12, 12, 12), BackgroundTransparency = 0, Outline = Color3.fromRGB(255, 30, 80),
    Text = Color3.fromRGB(245, 245, 245), Placeholder = Color3.fromRGB(150, 150, 150), Button = Color3.fromRGB(210, 15, 60),
    Icon = Color3.fromRGB(255, 50, 90), Hover = Color3.fromRGB(255, 255, 255),
    WindowBackground = WindUI:Gradient({ ["0"] = { Color = Color3.fromRGB(16, 16, 16), Transparency = 0 }, ["100"] = { Color = Color3.fromRGB(10, 10, 10), Transparency = 0 } }, { Rotation = 45 }),
    WindowShadow = Color3.fromRGB(255, 30, 80), DialogBackground = Color3.fromRGB(22, 22, 22), DialogBackgroundTransparency = 0,
    DialogTitle = Color3.fromRGB(255, 255, 255), DialogContent = Color3.fromRGB(220, 220, 220), DialogIcon = Color3.fromRGB(255, 50, 90),
    WindowTopbarButtonIcon = Color3.fromRGB(255, 255, 255), WindowTopbarTitle = Color3.fromRGB(255, 255, 255),
    WindowTopbarAuthor = Color3.fromRGB(180, 180, 180), WindowTopbarIcon = Color3.fromRGB(255, 50, 90),
    TabBackground = Color3.fromRGB(20, 20, 20), TabTitle = Color3.fromRGB(240, 240, 240), TabIcon = Color3.fromRGB(255, 50, 90),
    ElementBackground = Color3.fromRGB(22, 22, 22), ElementTitle = Color3.fromRGB(255, 255, 255), ElementDesc = Color3.fromRGB(170, 170, 170),
    ElementIcon = Color3.fromRGB(255, 50, 90), PopupBackground = Color3.fromRGB(22, 22, 22), PopupBackgroundTransparency = 0,
    PopupTitle = Color3.fromRGB(255, 255, 255), PopupContent = Color3.fromRGB(200, 200, 200), PopupIcon = Color3.fromRGB(255, 50, 90),
    Toggle = WindUI:Gradient({ ["0"] = { Color = Color3.fromRGB(150, 0, 30), Transparency = 0 }, ["100"] = { Color = Color3.fromRGB(255, 30, 80), Transparency = 0 } }, { Rotation = 90 }),
    ToggleBar = Color3.fromRGB(30, 30, 30), Checkbox = Color3.fromRGB(30, 30, 30), CheckboxIcon = Color3.fromRGB(255, 255, 255),
    Slider = WindUI:Gradient({ ["0"] = { Color = Color3.fromRGB(150, 0, 30), Transparency = 0 }, ["100"] = { Color = Color3.fromRGB(255, 30, 80), Transparency = 0 } }, { Rotation = 0 }),
    SliderThumb = Color3.fromRGB(255, 255, 255)
})
WindUI:SetTheme("VortexCrimsonSolid")

local Window = WindUI:CreateWindow({
    Title = "Vortex x Software [MM2]",
    Icon = "rbxassetid://134730158740955",
    IconSize = 35,
    Author = "by ISRAEL CC",
    Folder = "VortexXSoftwareMM2",
    Resizable = false,
    HideSearchBar = true,
    Transparent = false,
    Theme = "VortexCrimsonSolid",
    User = { Enabled = true, Anonymous = false }
})

Window:EditOpenButton({
    Title = "VXS",
    Icon = "rbxassetid://134730158740955",
    CornerRadius = UDim.new(1, 0),
    StrokeThickness = 2,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 0, 30)),
        ColorSequenceKeypoint.new(0.4, Color3.fromRGB(230, 0, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 50, 90))
    }),
    OnlyMobile = false,
    Enabled = true,
    Draggable = true
})

Window:Tag({ Title = "v3.3.43", Icon = "github", Color = Color3.fromRGB(230, 0, 50) })
Window:SetToggleKey(Enum.KeyCode.RightAlt)

-- ==========================================
-- INTEGRATED LOGIC AND STATES
-- ==========================================
local isFlingingActive = false
local touchFlingEnabled = false
local antiFlingEnabled = false

local autoGunTp = false

local killAuraEnabled = false
local killAuraRange = 22
local killAuraPartsTable = {}
local auraFloorDisc = nil
local ringRotation = 0

local gunAimbotEnabled = false
local currentGunTarget = nil

-- Estados ESP actualizados con modo de selección
local espEnabled = false
local currentRoleMode = "All"
local espSelf = false

local gunEspEnabled = false
local trapsEspEnabled = false
local xrayEnabled = false 
local originalTransparency = {}

local sheriffColor = Color3.fromRGB(0, 150, 255)
local murdererColor = Color3.fromRGB(255, 50, 50)
local innocentColor = Color3.fromRGB(0, 220, 100)
local gunEspColor = Color3.fromRGB(255, 215, 0)
local trapEspColor = Color3.fromRGB(255, 100, 0)

local AttackAnimations = {
    "rbxassetid://2467567750",
    "rbxassetid://1957618848",
    "rbxassetid://2470501967",
    "rbxassetid://2467577524",
}

-- ==========================================
-- MM2 HELPER & ROLE FUNCTIONS
-- ==========================================
local function getRole(plr)
    if not plr or not plr.Character then return "Innocent" end
    local character = plr.Character
    local backpack = plr:FindFirstChild("Backpack")
    
    local hasKnife = false
    local hasGun = false
    
    local function scanContainer(container)
        if not container then return end
        for _, item in ipairs(container:GetChildren()) do
            if item:IsA("Tool") then
                local name = item.Name:lower()
                if item:FindFirstChild("KnifeServer") or item:FindFirstChild("Blade") or name:find("knife") or name:find("dagger") or name:find("cuchillo") or name:find("murderer") or name:find("slash") then
                    hasKnife = true
                elseif item:FindFirstChild("GunServer") or item:FindFirstChild("ShootGun") or name:find("gun") or name:find("revolver") or name:find("pistola") or name:find("sheriff") then
                    hasGun = true
                end
            end
        end
    end
    
    pcall(function()
        scanContainer(character)
        scanContainer(backpack)
    end)
    
    if hasKnife then
        return "Murderer"
    elseif hasGun then
        return "Sheriff"
    else
        return "Innocent"
    end
end

local function getLocalRole()
    return getRole(LocalPlayer)
end

-- ==========================================
-- TELEPORT HELPER FUNCTIONS (ACTUALIZADAS)
-- ==========================================
local function getSpawnPart(name)
    local part = workspace:FindFirstChild(name, true)
    if not part then
        warn("Aviso: No se encontró la parte de destino: " .. name)
    end
    return part
end

local function teleportToLobby()
    local lobbySpawn = getSpawnPart("LobbySpawn")
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if lobbySpawn and rootPart then
        rootPart.CFrame = lobbySpawn.CFrame + Vector3.new(0, 3, 0)
        WindUI:Notify({ Title = "Vortex x Software", Content = "Teleported to Lobby!", Duration = 2 })
    else
        warn("Error: El teletransporte al lobby falló por falta de referencias.")
        WindUI:Notify({ Title = "Teleport", Content = "LobbySpawn not found.", Duration = 3 })
    end
end

local function teleportToMap()
    local mapSpawn = getSpawnPart("MapSpawn")
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if mapSpawn and rootPart then
        rootPart.CFrame = mapSpawn.CFrame + Vector3.new(0, 3, 0)
        WindUI:Notify({ Title = "Vortex x Software", Content = "Teleported to Map!", Duration = 2 })
    else
        warn("Error: El teletransporte al mapa falló porque la zona de ronda no está cargada.")
        WindUI:Notify({ Title = "Teleport", Content = "MapSpawn not active yet.", Duration = 3 })
    end
end

local function teleportToPlayer(targetPlr)
    pcall(function()
        if not targetPlr or not targetPlr.Character then return end
        local targetHrp = targetPlr.Character:FindFirstChild("HumanoidRootPart")
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if targetHrp and hrp then
            hrp.CFrame = targetHrp.CFrame + Vector3.new(0, 3, 0)
            WindUI:Notify({ Title = "Vortex x Software", Content = "Teleported to " .. targetPlr.Name, Duration = 2 })
        end
    end)
end

local function getAndEquipKnife()
    local char = LocalPlayer.Character
    if not char then return nil end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return nil end

    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            local name = tool.Name:lower()
            if tool:FindFirstChild("KnifeServer") or tool:FindFirstChild("Blade") or name:find("knife") or name:find("dagger") or name:find("cuchillo") or name:find("murderer") or (not name:find("gun") and not name:find("revolver") and not name:find("pistola") and not name:find("sheriff") and not name:find("perk") and not name:find("emote")) then
                return tool
            end
        end
    end

    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                local name = tool.Name:lower()
                if tool:FindFirstChild("KnifeServer") or tool:FindFirstChild("Blade") or name:find("knife") or name:find("dagger") or name:find("cuchillo") or name:find("murderer") or (not name:find("gun") and not name:find("revolver") and not name:find("pistola") and not name:find("sheriff") and not name:find("perk") and not name:find("emote")) then
                    hum:EquipTool(tool)
                    task.wait(0.12)
                    return char:FindFirstChild(tool.Name) or tool
                end
            end
        end
    end
    return nil
end

local function getAndEquipGun()
    local char = LocalPlayer.Character
    if not char then return nil end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return nil end

    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            local name = tool.Name:lower()
            if tool:FindFirstChild("GunServer") or tool:FindFirstChild("ShootGun") or tool:FindFirstChild("Shoot") or name:find("gun") or name:find("revolver") or name:find("pistola") or name:find("sheriff") then
                return tool
            end
        end
    end

    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                local name = tool.Name:lower()
                if tool:FindFirstChild("GunServer") or tool:FindFirstChild("ShootGun") or tool:FindFirstChild("Shoot") or name:find("gun") or name:find("revolver") or name:find("pistola") or name:find("sheriff") then
                    hum:EquipTool(tool)
                    task.wait(0.15)
                    return char:FindFirstChild(tool.Name) or tool
                end
            end
        end
    end
    return nil
end

-- ==========================================
-- RED VISUALS & RANGED ATTACK FUNCTIONS
-- ==========================================
local RED_COLOR = Color3.fromRGB(255, 0, 0)

local function applyRedVisuals(character)
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local rootPart = character.HumanoidRootPart
    if not rootPart:FindFirstChild("RedLightPart") then
        local lightPart = Instance.new("Part")
        lightPart.Name = "RedLightPart"
        lightPart.Size = Vector3.new(0.5, 0.5, 0.5)
        lightPart.Transparency = 1
        lightPart.CanCollide = false
        lightPart.Anchored = false
        lightPart.Parent = character
        
        local weld = Instance.new("WeldConstraint")
        weld.Part0 = rootPart
        weld.Part1 = lightPart
        weld.Parent = lightPart
        
        local pointLight = Instance.new("PointLight")
        pointLight.Color = RED_COLOR
        pointLight.Range = 16
        pointLight.Brightness = 8
        pointLight.Parent = lightPart
    end
end

local function attackTarget(targetPlr)
    if not targetPlr or not targetPlr.Character then return end
    local targetHrp = targetPlr.Character:FindFirstChild("HumanoidRootPart") or targetPlr.Character:FindFirstChild("Head")
    local targetHum = targetPlr.Character:FindFirstChildOfClass("Humanoid")
    if not targetHrp or not targetHum or targetHum.Health <= 0 then return end

    applyRedVisuals(targetPlr.Character)

    local knife = getAndEquipKnife()
    if not knife then return end

    local handle = knife:FindFirstChild("Handle") or knife:FindFirstChildOfClass("BasePart")
    
    pcall(function()
        local remote = knife:FindFirstChild("KnifeServer") or knife:FindFirstChild("RemoteEvent") or knife:FindFirstChildWhichIsA("RemoteEvent")
        if remote then
            pcall(function() remote:FireServer(targetHrp.Position) end)
            pcall(function() remote:FireServer(targetHrp.CFrame) end)
            pcall(function() remote:FireServer(targetPlr.Character) end)
        end

        knife:Activate()
        if handle and targetHrp then
            firetouchinterest(targetHrp, handle, 0)
            firetouchinterest(targetHrp, handle, 1)
        end
    end)
end

-- ==========================================
-- KILL AURA AREA RING PARTS & CONNECTED BEAMS VISUAL
-- ==========================================
local function updateKillAuraVisual(enabled, range)
    pcall(function()
        if enabled then
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                if not auraFloorDisc or not auraFloorDisc.Parent then
                    auraFloorDisc = Instance.new("Part")
                    auraFloorDisc.Name = "VortexAuraDisc"
                    auraFloorDisc.Shape = Enum.PartType.Cylinder
                    auraFloorDisc.Material = Enum.Material.Neon
                    auraFloorDisc.Color = Color3.fromRGB(255, 30, 80)
                    auraFloorDisc.Transparency = 0.88
                    auraFloorDisc.Anchored = true
                    auraFloorDisc.CanCollide = false
                    auraFloorDisc.CastShadow = false
                    auraFloorDisc.Parent = workspace
                end
                
                local centerPos = hrp.Position - Vector3.new(0, 2.5, 0)
                auraFloorDisc.Size = Vector3.new(0.2, range * 2, range * 2)
                auraFloorDisc.CFrame = CFrame.new(centerPos) * CFrame.Angles(0, 0, math.rad(90))

                local cantidadPartes = 16
                ringRotation = ringRotation + 0.03
                
                if #killAuraPartsTable ~= cantidadPartes then
                    for _, p in ipairs(killAuraPartsTable) do
                        if p and p.Parent then p:Destroy() end
                    end
                    killAuraPartsTable = {}
                    
                    for i = 1, cantidadPartes do
                        local part = Instance.new("Part")
                        part.Name = "VortexAuraBorderPart"
                        part.Size = Vector3.new(0.5, 0.5, 0.5)
                        part.Shape = Enum.PartType.Ball
                        part.Material = Enum.Material.Neon
                        part.Color = Color3.fromRGB(255, 0, 60)
                        part.Anchored = true
                        part.CanCollide = false
                        part.CastShadow = false
                        part.Parent = workspace

                        local att0 = Instance.new("Attachment")
                        att0.Name = "BeamAtt"
                        att0.Parent = part
                        
                        table.insert(killAuraPartsTable, part)
                    end

                    for i = 1, cantidadPartes do
                        local currentPart = killAuraPartsTable[i]
                        local nextPart = killAuraPartsTable[i % cantidadPartes + 1]
                        
                        local att1 = Instance.new("Attachment")
                        att1.Name = "BeamAttNext"
                        att1.Parent = nextPart

                        local beam = Instance.new("Beam")
                        beam.Name = "VortexRingBeam"
                        beam.Attachment0 = currentPart:FindFirstChild("BeamAtt")
                        beam.Attachment1 = att1
                        beam.Color = ColorSequence.new(Color3.fromRGB(255, 30, 80))
                        beam.Width0 = 0.35
                        beam.Width1 = 0.35
                        beam.Transparency = NumberSequence.new(0.25)
                        beam.FaceCamera = true
                        beam.Parent = currentPart
                    end
                end
                
                for i, part in ipairs(killAuraPartsTable) do
                    if part and part.Parent then
                        local angulo = (i / cantidadPartes) * (math.pi * 2) + ringRotation
                        local offsetX = math.cos(angulo) * range
                        local offsetZ = math.sin(angulo) * range
                        part.Position = centerPos + Vector3.new(offsetX, 0.2, offsetZ)
                    end
                end
            end
        else
            if auraFloorDisc and auraFloorDisc.Parent then
                auraFloorDisc:Destroy()
                auraFloorDisc = nil
            end
            for _, p in ipairs(killAuraPartsTable) do
                if p and p.Parent then p:Destroy() end
            end
            killAuraPartsTable = {}
        end
    end)
end

local function executeKillAll()
    pcall(function()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then 
            WindUI:Notify({ Title = "Kill All", Content = "Your character is not available.", Duration = 3 })
            return 
        end

        local knife = getAndEquipKnife()
        if not knife then 
            WindUI:Notify({ Title = "Kill All", Content = "You do not have a knife in your inventory.", Duration = 3 })
            return 
        end

        local oldPos = hrp.CFrame
        local targetsKilled = 0

        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local targetHrp = plr.Character:FindFirstChild("HumanoidRootPart")
                local targetHum = plr.Character:FindFirstChildOfClass("Humanoid")
                if targetHrp and targetHum and targetHum.Health > 0 then
                    targetsKilled = targetsKilled + 1
                    for i = 1, 3 do
                        hrp.CFrame = targetHrp.CFrame * CFrame.new(0, 0, 1.2)
                        task.wait(0.03)
                        attackTarget(plr)
                    end
                    task.wait(0.05)
                end
            end
        end

        task.wait(0.05)
        hrp.CFrame = oldPos

        if targetsKilled > 0 then
            WindUI:Notify({ Title = "Vortex x Software", Content = "Kill All successfully executed!", Duration = 2 })
        else
            WindUI:Notify({ Title = "Kill All", Content = "There are no living players to eliminate.", Duration = 3 })
        end
    end)
end

local function getMurderer()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local hum = plr.Character:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 and getRole(plr) == "Murderer" then
                return plr
            end
        end
    end
    return nil
end

local function getSheriff()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local hum = plr.Character:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 and getRole(plr) == "Sheriff" then
                return plr
            end
        end
    end
    return nil
end

local env = getgenv and getgenv() or _G
env.timeout = env.timeout or 2.5

local function flingTarget(TargetPlayer)
    task.spawn(function()
        if not TargetPlayer or not TargetPlayer.Character then return end
        isFlingingActive = true

        local Char = LocalPlayer.Character
        local Hum = Char and Char:FindFirstChildWhichIsA("Humanoid")
        local Root = Hum and Hum.RootPart or Char:FindFirstChild("HumanoidRootPart")
        
        if not (Char and Hum and Root) then 
            isFlingingActive = false
            return 
        end
        
        local TCharacter = TargetPlayer.Character
        if not TCharacter then 
            isFlingingActive = false
            return 
        end
        local THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
        local TRootPart = THumanoid and THumanoid.RootPart
        local THead = TCharacter:FindFirstChild("Head")
        local Accessory = TCharacter:FindFirstChildOfClass("Accessory")
        local Handle = Accessory and Accessory:FindFirstChild("Handle")
        local targetPart = TRootPart or THead or Handle
        
        if not targetPart then 
            isFlingingActive = false
            return 
        end

        env.OldPos = Root.CFrame

        pcall(function()
            workspace.CurrentCamera.CameraSubject = THead or Handle or THumanoid
        end)

        local function FPos(BasePart, Pos, Ang)
            local targetCF = CFrame.new(BasePart.Position) * Pos * Ang
            Root.CFrame = targetCF
            Char:SetPrimaryPartCFrame(targetCF)
            Root.Velocity = Vector3.new(9e7, 9e8, 9e7)
            Root.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
        end

        local function SFBasePart(BasePart)
            local start = tick()
            local angle = 0
            repeat
                if Root and THumanoid then
                    angle = angle + 100
                    local offsets = {
                        CFrame.new(0, 1.5, 0),
                        CFrame.new(0, -1.5, 0),
                        CFrame.new(2.25, 1.5, -2.25),
                        CFrame.new(-2.25, -1.5, 2.25)
                    }
                    for _, offset in ipairs(offsets) do
                        FPos(BasePart, offset + THumanoid.MoveDirection, CFrame.Angles(math.rad(angle), 0, 0))
                        task.wait()
                    end
                end
            until BasePart.Velocity.Magnitude > 500 or (tick() - start) > env.timeout
        end

        local BV = Instance.new("BodyVelocity")
        BV.Name = "FlingVel"
        BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
        BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        BV.Parent = Root

        pcall(function()
            Hum:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
        end)

        SFBasePart(targetPart)

        pcall(function()
            BV:Destroy()
            Hum:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
            workspace.CurrentCamera.CameraSubject = Hum
        end)

        repeat
            local cf = env.OldPos * CFrame.new(0, 0.5, 0)
            Root.CFrame = cf
            Char:SetPrimaryPartCFrame(cf)
            Hum:ChangeState("GettingUp")
            for _, part in ipairs(Char:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Velocity, part.RotVelocity = Vector3.zero, Vector3.zero
                end
            end
            task.wait()
        until (Root.Position - env.OldPos.Position).Magnitude < 25

        task.wait(0.3)
        isFlingingActive = false
    end)
end

local function hasGunEquippedOrInBag()
    local char = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    
    local function scan(container)
        if not container then return false end
        for _, tool in ipairs(container:GetChildren()) do
            if tool:IsA("Tool") then
                local name = tool.Name:lower()
                if tool:FindFirstChild("GunServer") or name:find("gun") or name:find("revolver") or name:find("pistola") then
                    return true
                end
            end
        end
        return false
    end
    
    return scan(char) or scan(backpack)
end

local function findGunDrop()
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == "GunDrop" and v:IsA("BasePart") then
            return v
        end
    end
    return nil
end

local function instantGrabGun()
    if getLocalRole() == "Murderer" then return end
    local gunDrop = findGunDrop()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    
    if gunDrop and hrp then
        local oldCFrame = hrp.CFrame
        hrp.CFrame = gunDrop.CFrame + Vector3.new(0, 1, 0)
        task.wait(0.03)
        pcall(function() 
            firetouchinterest(hrp, gunDrop, 0)
            firetouchinterest(hrp, gunDrop, 1) 
        end)
        task.wait(0.05)
        hrp.CFrame = oldCFrame
    else
        WindUI:Notify({ Title = "Gun TP", Content = "No gun drop found.", Duration = 3 })
    end
end

local function sendChatMessage(msg)
    local sent = false
    pcall(function()
        if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
            local rbxGeneral = TextChatService:FindFirstChild("TextChannels") and TextChatService.TextChannels:FindFirstChild("RBXGeneral")
            if rbxGeneral then
                rbxGeneral:SendAsync(msg)
                sent = true
            end
        end
    end)
    if sent then return end

    pcall(function()
        local sayRemote = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents") and ReplicatedStorage.DefaultChatSystemChatEvents:FindFirstChild("SayMessageRequest")
        if sayRemote then
            sayRemote:FireServer(msg, "All")
        end
    end)
end

-- ==========================================
-- GUN AIMBOT & SILENT AIM LOGIC
-- ==========================================
RunService.RenderStepped:Connect(function()
    if gunAimbotEnabled then
        pcall(function()
            local char = LocalPlayer.Character
            if not char then return end
            local tool = char:FindFirstChildOfClass("Tool")
            if tool then
                local name = tool.Name:lower()
                if tool:FindFirstChild("GunServer") or name:find("gun") or name:find("revolver") or name:find("pistola") or name:find("sheriff") then
                    local murderer = getMurderer()
                    
                    if not currentGunTarget or not currentGunTarget.Character or not currentGunTarget.Character:FindFirstChild("Humanoid") or currentGunTarget.Character.Humanoid.Health <= 0 then
                        currentGunTarget = murderer
                    end
                    
                    if currentGunTarget and currentGunTarget.Character then
                        local targetHrp = currentGunTarget.Character:FindFirstChild("HumanoidRootPart") or currentGunTarget.Character:FindFirstChild("Head")
                        if targetHrp then
                            local predictedPos = targetHrp.Position + (targetHrp.AssemblyLinearVelocity * 0.1) + Vector3.new(0, 0.5, 0)
                            local targetCF = CFrame.new(Camera.CFrame.Position, predictedPos)
                            Camera.CFrame = Camera.CFrame:Lerp(targetCF, 0.25)
                        end
                    end
                else
                    currentGunTarget = nil
                end
            else
                currentGunTarget = nil
            end
        end)
    else
        currentGunTarget = nil
    end
end)

-- Silent Aim Hook for MM2 Gun Remotes
pcall(function()
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        if silentAimEnabled and method == "FireServer" then
            local name = self.Name:lower()
            if name:find("shoot") or name:find("gun") or name:find("bullet") or name:find("revolver") then
                local murderer = getMurderer()
                if murderer and murderer.Character then
                    local hrp = murderer.Character:FindFirstChild("HumanoidRootPart") or murderer.Character:FindFirstChild("Head")
                    if hrp then
                        local predPos = hrp.Position + (hrp.AssemblyLinearVelocity * 0.08) + Vector3.new(0, 0.2, 0)
                        for i, arg in ipairs(args) do
                            if typeof(arg) == "Vector3" then
                                args[i] = predPos
                            elseif typeof(arg) == "CFrame" then
                                args[i] = CFrame.new(predPos)
                            end
                        end
                    end
                end
            end
        end
        return oldNamecall(self, unpack(args))
    end)
end)

RunService.Heartbeat:Connect(function()
    if touchFlingEnabled and not isFlingingActive then
        pcall(function()
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local vel = hrp.AssemblyLinearVelocity
                hrp.AssemblyAngularVelocity = Vector3.new(0, 999999, 0)
                hrp.AssemblyLinearVelocity = Vector3.new(vel.X, 9999, vel.Z)
            end
        end)
    end
end)

RunService.Heartbeat:Connect(function()
    if antiFlingEnabled and not isFlingingActive then
        pcall(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                if hrp.AssemblyAngularVelocity.Magnitude > 300 or hrp.AssemblyLinearVelocity.Magnitude > 300 then
                    hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                end
            end
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    end
end)

local floatingBubbleGui = nil
local bubbleButton = nil
local floatingGunGui = nil
local gunBubbleButton = nil

local floatingFlingMurderGui = nil
local flingMurderBubbleButton = nil
local floatingFlingSheriffGui = nil
local flingSheriffBubbleButton = nil

local function createFloatingGunButton(enabled)
    if enabled then
        if floatingGunGui then return end

        floatingGunGui = Instance.new("ScreenGui")
        floatingGunGui.Name = "VortexFloatingGunButton"
        floatingGunGui.ResetOnSpawn = false
        pcall(function() floatingGunGui.Parent = CoreGui end)
        if floatingGunGui.Parent ~= CoreGui then
            floatingGunGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
        end

        gunBubbleButton = Instance.new("TextButton")
        gunBubbleButton.Name = "GetGunBubble"
        gunBubbleButton.Size = UDim2.new(0, 110, 0, 42)
        gunBubbleButton.Position = UDim2.new(0.82, 0, 0.72, 0)
        gunBubbleButton.BackgroundColor3 = Color3.fromRGB(200, 0, 40)
        gunBubbleButton.Text = "Get Gun"
        gunBubbleButton.TextSize = 13
        gunBubbleButton.Font = Enum.Font.GothamBold
        gunBubbleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        gunBubbleButton.BorderSizePixel = 0
        gunBubbleButton.AutoButtonColor = true
        gunBubbleButton.Parent = floatingGunGui

        local uiCorner = Instance.new("UICorner")
        uiCorner.CornerRadius = UDim.new(0, 10)
        uiCorner.Parent = gunBubbleButton

        local uigradient = Instance.new("UIGradient")
        uigradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 0, 30)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 85))
        })
        uigradient.Rotation = 45
        uigradient.Parent = gunBubbleButton

        local dragging, dragInput, dragStart, startPos
        gunBubbleButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = gunBubbleButton.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
        gunBubbleButton.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                gunBubbleButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)

        gunBubbleButton.MouseButton1Click:Connect(function()
            pcall(instantGrabGun)
        end)
    else
        if floatingGunGui then
            floatingGunGui:Destroy()
            floatingGunGui = nil
            gunBubbleButton = nil
        end
    end
end

local function createFloatingKillButton(enabled)
    if enabled then
        if floatingBubbleGui then return end
        
        floatingBubbleGui = Instance.new("ScreenGui")
        floatingBubbleGui.Name = "VortexFloatingKillButton"
        floatingBubbleGui.ResetOnSpawn = false
        pcall(function() floatingBubbleGui.Parent = CoreGui end)
        if floatingBubbleGui.Parent ~= CoreGui then
            floatingBubbleGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
        end
        
        bubbleButton = Instance.new("TextButton")
        bubbleButton.Name = "KillAllBubble"
        bubbleButton.Size = UDim2.new(0, 110, 0, 42)
        bubbleButton.Position = UDim2.new(0.82, 0, 0.6, 0)
        bubbleButton.BackgroundColor3 = Color3.fromRGB(200, 0, 40)
        bubbleButton.Text = "Kill All"
        bubbleButton.TextSize = 14
        bubbleButton.Font = Enum.Font.GothamBold
        bubbleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        bubbleButton.TextStrokeTransparency = 1
        bubbleButton.BorderSizePixel = 0
        bubbleButton.AutoButtonColor = true
        bubbleButton.Parent = floatingBubbleGui
        
        local uiCorner = Instance.new("UICorner")
        uiCorner.CornerRadius = UDim.new(0, 10)
        uiCorner.Parent = bubbleButton
        
        local uigradient = Instance.new("UIGradient")
        uigradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 0, 30)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 85))
        })
        uigradient.Rotation = 45
        uigradient.Parent = bubbleButton

        local dragging, dragInput, dragStart, startPos
        
        bubbleButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = bubbleButton.Position
                
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
        
        bubbleButton.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                bubbleButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
        
        bubbleButton.MouseButton1Click:Connect(function()
            executeKillAll()
        end)
    else
        if floatingBubbleGui then
            floatingBubbleGui:Destroy()
            floatingBubbleGui = nil
            bubbleButton = nil
        end
    end
end

local function createFloatingFlingMurderButton(enabled)
    if enabled then
        if floatingFlingMurderGui then return end

        floatingFlingMurderGui = Instance.new("ScreenGui")
        floatingFlingMurderGui.Name = "VortexFloatingFlingMurderButton"
        floatingFlingMurderGui.ResetOnSpawn = false
        pcall(function() floatingFlingMurderGui.Parent = CoreGui end)
        if floatingFlingMurderGui.Parent ~= CoreGui then
            floatingFlingMurderGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
        end

        flingMurderBubbleButton = Instance.new("TextButton")
        flingMurderBubbleButton.Name = "FlingMurderBubble"
        flingMurderBubbleButton.Size = UDim2.new(0, 110, 0, 42)
        flingMurderBubbleButton.Position = UDim2.new(0.82, 0, 0.36, 0)
        flingMurderBubbleButton.BackgroundColor3 = Color3.fromRGB(200, 0, 40)
        flingMurderBubbleButton.Text = "Fling Murder"
        flingMurderBubbleButton.TextSize = 13
        flingMurderBubbleButton.Font = Enum.Font.GothamBold
        flingMurderBubbleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        flingMurderBubbleButton.BorderSizePixel = 0
        flingMurderBubbleButton.AutoButtonColor = true
        flingMurderBubbleButton.Parent = floatingFlingMurderGui

        local uiCorner = Instance.new("UICorner")
        uiCorner.CornerRadius = UDim.new(0, 10)
        uiCorner.Parent = flingMurderBubbleButton

        local uigradient = Instance.new("UIGradient")
        uigradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 0, 30)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 85))
        })
        uigradient.Rotation = 45
        uigradient.Parent = flingMurderBubbleButton

        local dragging, dragInput, dragStart, startPos
        flingMurderBubbleButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = flingMurderBubbleButton.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
        flingMurderBubbleButton.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                flingMurderBubbleButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)

        flingMurderBubbleButton.MouseButton1Click:Connect(function()
            pcall(function()
                local target = getMurderer()
                if target then
                    flingTarget(target)
                else
                    WindUI:Notify({ Title = "Fling", Content = "Murderer not found.", Duration = 3 })
                end
            end)
        end)
    else
        if floatingFlingMurderGui then
            floatingFlingMurderGui:Destroy()
            floatingFlingMurderGui = nil
            flingMurderBubbleButton = nil
        end
    end
end

local function createFloatingFlingSheriffButton(enabled)
    if enabled then
        if floatingFlingSheriffGui then return end

        floatingFlingSheriffGui = Instance.new("ScreenGui")
        floatingFlingSheriffGui.Name = "VortexFloatingFlingSheriffButton"
        floatingFlingSheriffGui.ResetOnSpawn = false
        pcall(function() floatingFlingSheriffGui.Parent = CoreGui end)
        if floatingFlingSheriffGui.Parent ~= CoreGui then
            floatingFlingSheriffGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
        end

        flingSheriffBubbleButton = Instance.new("TextButton")
        flingSheriffBubbleButton.Name = "FlingSheriffBubble"
        flingSheriffBubbleButton.Size = UDim2.new(0, 110, 0, 42)
        flingSheriffBubbleButton.Position = UDim2.new(0.82, 0, 0.24, 0)
        flingSheriffBubbleButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
        flingSheriffBubbleButton.Text = "Fling Sheriff"
        flingSheriffBubbleButton.TextSize = 13
        flingSheriffBubbleButton.Font = Enum.Font.GothamBold
        flingSheriffBubbleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        flingSheriffBubbleButton.BorderSizePixel = 0
        flingSheriffBubbleButton.AutoButtonColor = true
        flingSheriffBubbleButton.Parent = floatingFlingSheriffGui

        local uiCorner = Instance.new("UICorner")
        uiCorner.CornerRadius = UDim.new(0, 10)
        uiCorner.Parent = flingSheriffBubbleButton

        local uigradient = Instance.new("UIGradient")
        uigradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 100, 200)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 180, 255))
        })
        uigradient.Rotation = 45
        uigradient.Parent = flingSheriffBubbleButton

        local dragging, dragInput, dragStart, startPos
        flingSheriffBubbleButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = flingSheriffBubbleButton.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
        flingSheriffBubbleButton.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                flingSheriffBubbleButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)

        flingSheriffBubbleButton.MouseButton1Click:Connect(function()
            pcall(function()
                local target = getSheriff()
                if target then
                    flingTarget(target)
                else
                    WindUI:Notify({ Title = "Fling", Content = "Sheriff not found.", Duration = 3 })
                end
            end)
        end)
    else
        if floatingFlingSheriffGui then
            floatingFlingSheriffGui:Destroy()
            floatingFlingSheriffGui = nil
            flingSheriffBubbleButton = nil
        end
    end
end

--------------------------------------------------
-- TABS SYSTEM
--------------------------------------------------

--------------------------------------------------
-- 1. CONFIG TAB
--------------------------------------------------
local configTab = Window:Tab({ Title = "Config", Icon = "cog", ShowTabTitle = true, Border = true })
configTab:Select()

configTab:Divider()
configTab:Paragraph({ Title = "Community Links", Desc = "Official Vortex x Software platforms" })

configTab:Button({ 
    Title = "Copy Discord Link", 
    Callback = function() 
        pcall(function() 
            setclipboard("https://discord.gg/Fn74MpzFUn") 
            WindUI:Notify({ Title = "Vortex x Software", Content = "Discord link copied!", Duration = 2 })
        end) 
    end 
})

configTab:Button({ 
    Title = "Official Website", 
    Callback = function() 
        pcall(function() 
            setclipboard("https://vortex-x-software.netlify.app/") 
            WindUI:Notify({ Title = "Vortex x Software", Content = "Website link copied!", Duration = 2 })
        end) 
    end 
})

configTab:Paragraph({ Title = "Lead Developer", Desc = "ISRAEL CC" })
configTab:Paragraph({ Title = "UI Framework", Desc = "MrSxxo (WindUI)" })

configTab:Divider()
configTab:Paragraph({ Title = "Interface Settings", Desc = "Menu customization and safety" })

configTab:Keybind({ 
    Title = "Menu Toggle Keybind", 
    Key = "RightAlt", 
    Callback = function(keyVal) 
        pcall(function()
            Window:SetToggleKey(Enum.KeyCode[tostring(keyVal)] or Enum.KeyCode.RightAlt) 
        end)
    end 
})

configTab:Button({ 
    Title = "Clear Stuck Texts / UI", 
    Callback = function() 
        pcall(function()
            for _, gui in ipairs(LocalPlayer.PlayerGui:GetDescendants()) do
                if gui:IsA("TextLabel") or gui:IsA("TextButton") then
                    if gui.Text:find("MURDER") or gui.Text:find("SHERIFF") or gui.Text:find("Asesino") then
                        if gui.Visible then
                            gui.Visible = false
                        end
                    end
                end
            end
            WindUI:Notify({ Title = "Vortex x Software", Content = "Ghost texts cleared.", Duration = 2 })
        end)
    end 
})

configTab:Button({ 
    Title = "Disconnect Session", 
    Callback = function() 
        pcall(function() 
            LocalPlayer:Kick("Disconnected by user.") 
        end) 
    end 
})

--------------------------------------------------
-- 2. COMBAT TAB
--------------------------------------------------
local combatTab = Window:Tab({ Title = "Combat", Icon = "swords", ShowTabTitle = true, Border = true })

combatTab:Divider()
combatTab:Paragraph({ Title = "Murderer Automation", Desc = "Zone Kill Aura tools with ranged attack and connected ring parts visual" })

combatTab:Toggle({ 
    Title = "Kill Aura (Zone)", 
    Desc = "Crea un disco redondo en el suelo con esferas rojas conectadas por haces de luz brillantes; cualquier jugador que entre será eliminado.",
    Default = false, 
    Callback = function(val) 
        killAuraEnabled = val 
        if not val then
            updateKillAuraVisual(false, killAuraRange)
        end
    end 
})

combatTab:Slider({
    Title = "Kill Aura Range / Zone Size",
    Step = 1,
    Value = {Min = 5, Max = 50, Default = 22},
    Callback = function(val)
        killAuraRange = val
    end
})

combatTab:Button({
    Title = "Kill All Players",
    Callback = function()
        executeKillAll()
    end
})

combatTab:Keybind({
    Title = "Kill All Keybind",
    Key = "None",
    Callback = function()
        executeKillAll()
    end
})

combatTab:Toggle({
    Title = "Floating Kill All Bubble (Mobile)",
    Desc = "Creates a floating movable crimson button to execute Kill All.",
    Default = false,
    Callback = function(val)
        createFloatingKillButton(val)
    end
})

task.spawn(function()
    while true do
        if killAuraEnabled then
            pcall(function()
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    updateKillAuraVisual(true, killAuraRange)
                    for _, plr in ipairs(Players:GetPlayers()) do
                        if plr ~= LocalPlayer and plr.Character then
                            local targetHrp = plr.Character:FindFirstChild("HumanoidRootPart")
                            local targetHum = plr.Character:FindFirstChildOfClass("Humanoid")
                            if targetHrp and targetHum and targetHum.Health > 0 then
                                local dist = (hrp.Position - targetHrp.Position).Magnitude
                                if dist <= killAuraRange then
                                    attackTarget(plr)
                                end
                            end
                        end
                    end
                else
                    updateKillAuraVisual(false, killAuraRange)
                end
            end)
        else
            updateKillAuraVisual(false, killAuraRange)
        end
        task.wait(0.05)
    end
end)

combatTab:Divider()
combatTab:Paragraph({ Title = "Sheriff & Gun Utilities", Desc = "Aimbot, auto-shoot, silent aim and mobile gun tools" })

combatTab:Toggle({
    Title = "Gun Aimbot",
    Desc = "Apunta la cámara suavemente hacia el Asesino al sostener el arma (sin tirones).",
    Default = false,
    Callback = function(val)
        gunAimbotEnabled = val
    end
})

combatTab:Toggle({
    Title = "Silent Aim (Gun)",
    Desc = "Redirige automáticamente los disparos de tu arma hacia el Asesino sin mover la cámara.",
    Default = false,
    Callback = function(val)
        silentAimEnabled = val
    end
})

combatTab:Divider()
combatTab:Paragraph({ Title = "Fling & Protection Tools", Desc = "High-velocity physical disturbance options" })

combatTab:Button({ 
    Title = "Fling Murderer", 
    Callback = function() 
        pcall(function() 
            local target = getMurderer() 
            if target then 
                flingTarget(target) 
            else
                WindUI:Notify({ Title = "Fling", Content = "Murderer not found.", Duration = 3 })
            end 
        end) 
    end 
})

combatTab:Toggle({
    Title = "Floating Fling Murderer Button (Mobile)",
    Desc = "Creates a floating button to fling the Murderer instantly.",
    Default = false,
    Callback = function(val)
        createFloatingFlingMurderButton(val)
    end
})

combatTab:Button({ 
    Title = "Fling Sheriff", 
    Callback = function() 
        pcall(function() 
            local target = getSheriff() 
            if target then 
                flingTarget(target) 
            else
                WindUI:Notify({ Title = "Fling", Content = "Sheriff not found.", Duration = 3 })
            end 
        end) 
    end 
})

combatTab:Toggle({
    Title = "Floating Fling Sheriff Button (Mobile)",
    Desc = "Creates a floating button to fling the Sheriff instantly.",
    Default = false,
    Callback = function(val)
        createFloatingFlingSheriffButton(val)
    end
})

local selectedFlingPlayer = ""

local function getPlayerNames()
    local names = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(names, p.Name)
        end
    end
    return names
end

local flingDropdown = combatTab:Dropdown({
    Title = "Select Player to Fling",
    Values = getPlayerNames(),
    Callback = function(selected)
        selectedFlingPlayer = selected
    end
})

local function updateFlingDropdown()
    pcall(function()
        local updatedNames = getPlayerNames()
        flingDropdown:SetValues(updatedNames)
    end)
end

Players.PlayerAdded:Connect(function(p)
    task.wait(1)
    updateFlingDropdown()
end)

Players.PlayerRemoving:Connect(function(p)
    updateFlingDropdown()
end)

combatTab:Button({
    Title = "Refresh Player List",
    Desc = "Manually updates the server player list.",
    Callback = function()
        updateFlingDropdown()
        WindUI:Notify({ Title = "Vortex x Software", Content = "Player list updated.", Duration = 2 })
    end
})

combatTab:Button({
    Title = "Fling Selected Player",
    Callback = function()
        if selectedFlingPlayer ~= "" then
            local target = Players:FindFirstChild(selectedFlingPlayer)
            if target then
                flingTarget(target)
            else
                WindUI:Notify({ Title = "Fling", Content = "Player not found.", Duration = 3 })
            end
        else
            WindUI:Notify({ Title = "Fling", Content = "Select a player first.", Duration = 3 })
        end
    end
})

combatTab:Toggle({
    Title = "Touch Fling",
    Desc = "Spins at extreme speed, launching anyone who touches you.",
    Default = false,
    Callback = function(val)
        touchFlingEnabled = val
    end
})

combatTab:Toggle({
    Title = "Anti-Fling",
    Desc = "Cancels collisions and external physical forces to prevent flinging.",
    Default = false,
    Callback = function(val)
        antiFlingEnabled = val
    end
})

--------------------------------------------------
-- 3. AUTO FARM TAB
--------------------------------------------------
local autoFarmTab = Window:Tab({
    Title = "Auto Farm",
    Icon = "trending-up"
})

autoFarmTab:Divider()
autoFarmTab:Paragraph({
    Title = "Coin & Candy Collection",
    Desc = "Automated farming options for currencies and event items."
})

autoFarmTab:Toggle({
    Flag = "CoinAutofarm",
    Title = "Coin Autofarm",
    Desc = "Automatically collect coins from the map",
    Default = false,
    Callback = function(state)
        coinAutofarmEnabled = state
        if state then
            processedItemsTable = {}
            collectedCount = 0
            currentBagAmount = 0
        end
    end
})

autoFarmTab:Divider()

autoFarmTab:Toggle({
    Flag = "CandyAutofarm",
    Title = "Candy Autofarm",
    Desc = "Collect Halloween candy for event rewards",
    Default = false,
    Callback = function(state)
        candyAutofarmEnabled = state
        if state then
            processedItemsTable = {}
            collectedCount = 0
            currentBagAmount = 0
        end
    end
})

autoFarmTab:Divider()

autoFarmTab:Toggle({
    Flag = "AutoEndRound",
    Title = "Auto Reset Character",
    Desc = "Automatically reset character when bag is full",
    Default = false,
    Callback = function(state)
        autoResetEnabled = state
        autoResetAux = state
    end
})

autoFarmTab:Divider()

autoFarmTab:Toggle({
    Flag = "AutoFlingMurderer",
    Title = "Auto Fling Murderer",
    Desc = "Automatically fling murderer when bag is full",
    Default = false,
    Callback = function(state)
        autoFlingMurdererEnabled = state
    end
})

autoFarmTab:Divider()

autoFarmTab:Slider({
    Flag = "FlySpeed",
    Title = "Autofarm Speed",
    Desc = "Adjust collection speed",
    Step = 1,
    Value = {
        Min = 5,
        Max = 50,
        Default = 25
    },
    Callback = function(speed)
        autofarmSpeed = speed
    end
})

local function getLocalRootPart()
    local char = LocalPlayer.Character
    if char then
        return char:FindFirstChild("HumanoidRootPart")
    end
    return nil
end

local function getClosestCoin()
    local root = getLocalRootPart()
    if not root then return nil, math.huge end
    local minDist = math.huge
    local bestPart = nil
    
    for _, container in pairs(workspace:GetChildren()) do
        if container:FindFirstChild("CoinContainer") then
            for _, item in pairs(container.CoinContainer:GetChildren()) do
                if item:IsA("BasePart") and item:FindFirstChild("TouchInterest") then
                    local dist = (root.Position - item.Position).Magnitude
                    if dist < minDist then
                        bestPart = item
                        minDist = dist
                    end
                end
            end
        end
    end
    return bestPart, minDist
end

local function getClosestCandy()
    local root = getLocalRootPart()
    if not root then return nil, math.huge end
    local minDist = math.huge
    local bestPart = nil
    
    for _, container in pairs(workspace:GetChildren()) do
        if container:FindFirstChild("CoinContainer") then
            for _, item in pairs(container.CoinContainer:GetChildren()) do
                if item:IsA("BasePart") and (item:GetAttribute("CoinID") == "Candy" and item:FindFirstChild("TouchInterest")) then
                    local dist = (root.Position - item.Position).Magnitude
                    if dist < minDist then
                        bestPart = item
                        minDist = dist
                    end
                end
            end
        end
    end
    
    if not bestPart then
        for _, item in ipairs(workspace:GetDescendants()) do
            if item:IsA("BasePart") and item.Name == "candy" then
                local dist = (root.Position - item.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    bestPart = item
                end
            end
        end
    end
    return bestPart, minDist
end

task.spawn(function()
    while true do
        if (coinAutofarmEnabled or candyAutofarmEnabled) and (isRoundActive and not isBusy) then
            local root = getLocalRootPart()
            local target, dist = nil, math.huge
            
            if candyAutofarmEnabled then
                target, dist = getClosestCandy()
            elseif coinAutofarmEnabled then
                target, dist = getClosestCoin()
            end
            
            if target and root then
                if dist > 150 then
                    root.CFrame = target.CFrame
                else
                    local tw = TweenService:Create(root, TweenInfo.new(dist / autofarmSpeed, Enum.EasingStyle.Linear), {
                        CFrame = target.CFrame
                    })
                    tw:Play()
                    repeat task.wait() until not (target:FindFirstChild("TouchInterest") and (isRoundActive and (coinAutofarmEnabled or candyAutofarmEnabled)))
                    tw:Cancel()
                end
                
                collectedCount = collectedCount + 1
                currentBagAmount = currentBagAmount + 1
                
                if currentBagAmount >= maxBagCapacity then
                    isBusy = true
                    WindUI:Notify({ Title = "Auto Farm", Content = "¡Bolsa llena (" .. currentBagAmount .. "/" .. maxBagCapacity .. ")!", Duration = 2 })
                    
                    if autoFlingMurdererEnabled then
                        local murderer = getMurderer()
                        if murderer then
                            WindUI:Notify({ Title = "Auto Farm", Content = "Eliminando al Asesino por bolsa llena...", Duration = 2 })
                            flingTarget(murderer)
                            task.wait(1.5)
                        end
                    end
                    
                    if autoResetEnabled or autoResetAux then
                        pcall(function()
                            local char = LocalPlayer.Character
                            if char and char:FindFirstChildOfClass("Humanoid") then
                                char.Humanoid.Health = 0
                            end
                        end)
                        task.wait(3)
                    end
                    
                    currentBagAmount = 0
                    isBusy = false
                end
            end
        end
        task.wait(0.2)
    end
end)

RunService.Stepped:Connect(function()
    if (coinAutofarmEnabled or candyAutofarmEnabled) and (isRoundActive and not isBusy) then
        local char = LocalPlayer.Character
        if char and char:IsDescendantOf(workspace) then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)

--------------------------------------------------
-- 4. VISUALS / ESP TAB
--------------------------------------------------
local visualsTab = Window:Tab({ Title = "Visuals", Icon = "eye", ShowTabTitle = true, Border = true })

visualsTab:Divider()
visualsTab:Paragraph({ Title = "Role ESP System", Desc = "Highlight players based on their MM2 role" })

local function updateMM2ESP()
    local localHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    
    for _, plr in ipairs(Players:GetPlayers()) do
        local char = plr.Character
        if char and char.Parent then
            local root = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChild("Humanoid")
            
            if espEnabled and root and hum and hum.Health > 0 then
                local isLocal = (plr == LocalPlayer)
                if isLocal and not espSelf then
                    local hl = root:FindFirstChild("MM2_ESP")
                    local bgui = root:FindFirstChild("MM2_DistText")
                    if hl then hl:Destroy() end
                    if bgui then bgui:Destroy() end
                else
                    local hl = root:FindFirstChild("MM2_ESP")
                    local bgui = root:FindFirstChild("MM2_DistText")
                    local role = getRole(plr)

                    local shouldShow = false
                    if currentRoleMode == "All" then
                        shouldShow = true
                    elseif currentRoleMode == "Murderer & Sheriff" then
                        shouldShow = (role == "Murderer" or role == "Sheriff")
                    elseif currentRoleMode == "Innocent" then
                        shouldShow = (role == "Innocent")
                    end

                    if shouldShow then
                        if not hl then
                            hl = Instance.new("Highlight")
                            hl.Name = "MM2_ESP"
                            hl.Adornee = char
                            hl.FillTransparency = 0.85
                            hl.OutlineTransparency = 0
                            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            hl.Parent = root
                        end
                        
                        if not hl:GetAttribute("IsAttacking") then
                            if role == "Sheriff" then
                                hl.FillColor = sheriffColor; hl.OutlineColor = sheriffColor
                            elseif role == "Murderer" then
                                hl.FillColor = murdererColor; hl.OutlineColor = murdererColor
                            else
                                hl.FillColor = innocentColor; hl.OutlineColor = innocentColor
                            end
                        end

                        if localHrp then
                            if role == "Murderer" or role == "Sheriff" then
                                local dist = math.floor((localHrp.Position - root.Position).Magnitude)
                                if not bgui then
                                    bgui = Instance.new("BillboardGui")
                                    bgui.Name = "MM2_DistText"
                                    bgui.Adornee = root
                                    bgui.Size = UDim2.new(0, 140, 0, 40)
                                    bgui.StudsOffset = Vector3.new(0, 3.5, 0)
                                    bgui.AlwaysOnTop = true
                                    
                                    local tlabel = Instance.new("TextLabel")
                                    tlabel.Name = "DistLabel"
                                    tlabel.Size = UDim2.new(1, 0, 1, 0)
                                    tlabel.BackgroundTransparency = 1
                                    tlabel.TextStrokeColor3 = Color3.new(0, 0, 0)
                                    tlabel.TextStrokeTransparency = 0
                                    tlabel.Font = Enum.Font.GothamBold
                                    tlabel.TextSize = 13
                                    tlabel.Parent = bgui
                                    bgui.Parent = root
                                end
                                
                                local label = bgui:FindFirstChild("DistLabel")
                                if label then
                                    if role == "Murderer" then
                                        label.Text = "[MURDER] " .. dist .. " studs"
                                        label.TextColor3 = murdererColor
                                    elseif role == "Sheriff" then
                                        label.Text = "[SHERIFF] " .. dist .. " studs"
                                        label.TextColor3 = sheriffColor
                                    end
                                end
                            else
                                if bgui then bgui:Destroy() end
                            end
                        else
                            if bgui then bgui:Destroy() end
                        end
                    else
                        if hl then hl:Destroy() end
                        if bgui then bgui:Destroy() end
                    end
                end
            else
                if root then
                    local hl = root:FindFirstChild("MM2_ESP")
                    local bgui = root:FindFirstChild("MM2_DistText")
                    if hl then hl:Destroy() end
                    if bgui then bgui:Destroy() end
                end
            end
        end
    end
end

-- Dropdown para seleccionar el modo de roles de ESP
visualsTab:Dropdown({
    Title = "Filtrar Roles de ESP",
    Values = {"All", "Murderer & Sheriff", "Innocent"},
    Default = 1,
    Callback = function(val)
        currentRoleMode = val
    end
})

-- Toggle principal para encender/apagar la ESP
visualsTab:Toggle({ 
    Title = "Activar ESP", 
    Default = false, 
    Callback = function(val) 
        espEnabled = val 
        if not val then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr.Character then
                    local root = plr.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        local hl = root:FindFirstChild("MM2_ESP")
                        local bgui = root:FindFirstChild("MM2_DistText")
                        if hl then hl:Destroy() end
                        if bgui then bgui:Destroy() end
                    end
                end
            end
        end
    end 
})

visualsTab:Keybind({
    Title = "ESP Keybind",
    Key = "None",
    Callback = function()
        pcall(function()
            espEnabled = not espEnabled
            if not espEnabled then
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr.Character then
                        local root = plr.Character:FindFirstChild("HumanoidRootPart")
                        if root then
                            local hl = root:FindFirstChild("MM2_ESP")
                            local bgui = root:FindFirstChild("MM2_DistText")
                            if hl then hl:Destroy() end
                            if bgui then bgui:Destroy() end
                        end
                    end
                end
            end
            WindUI:Notify({ Title = "Vortex x Software", Content = "ESP: " .. (espEnabled and "ON" or "OFF"), Duration = 2 })
        end)
    end
})

visualsTab:Toggle({ Title = "Self ESP", Default = false, Callback = function(val) espSelf = val end })

visualsTab:Divider()
visualsTab:Paragraph({ Title = "World & Item ESP", Desc = "Detect weapons and map hazards" })

visualsTab:Toggle({ Title = "Enable Gun ESP", Default = false, Callback = function(val) gunEspEnabled = val end })
visualsTab:Toggle({ Title = "Traps & Hazards ESP", Default = false, Callback = function(val) trapsEspEnabled = val end })

visualsTab:Toggle({ 
    Title = "Round Timer", 
    Default = false, 
    Callback = function(Value) 
        ToggleTimerDisplay(Value) 
    end 
})

visualsTab:Toggle({ 
    Title = "X-Ray", 
    Default = false, 
    Callback = function(val) 
        xrayEnabled = val 
        pcall(function()
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and not obj:IsA("Terrain") then
                    local isPlayerPart = false
                    for _, plr in ipairs(Players:GetPlayers()) do
                        if plr.Character and obj:IsDescendantOf(plr.Character) then
                            isPlayerPart = true
                            break
                        end
                    end
                    
                    if not isPlayerPart then
                        if val then
                            if originalTransparency[obj] == nil then
                                originalTransparency[obj] = obj.Transparency
                            end
                            if obj.Name ~= "HumanoidRootPart" then
                                obj.Transparency = 0.65 
                            end
                        else
                            if originalTransparency[obj] ~= nil then
                                obj.Transparency = originalTransparency[obj]
                            end
                        end
                    end
                end
            end
        end)
    end 
})

visualsTab:Keybind({
    Title = "X-Ray Keybind",
    Key = "None",
    Callback = function()
        pcall(function()
            xrayEnabled = not xrayEnabled
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and not obj:IsA("Terrain") then
                    local isPlayerPart = false
                    for _, plr in ipairs(Players:GetPlayers()) do
                        if plr.Character and obj:IsDescendantOf(plr.Character) then
                            isPlayerPart = true
                            break
                        end
                    end
                    if not isPlayerPart then
                        if xrayEnabled then
                            if originalTransparency[obj] == nil then
                                originalTransparency[obj] = obj.Transparency
                            end
                            if obj.Name ~= "HumanoidRootPart" then
                                obj.Transparency = 0.65 
                            end
                        else
                            if originalTransparency[obj] ~= nil then
                                obj.Transparency = originalTransparency[obj]
                            end
                        end
                    end
                end
            end
            WindUI:Notify({ Title = "Vortex x Software", Content = "X-Ray: " .. (xrayEnabled and "ON" or "OFF"), Duration = 2 })
        end)
    end
})

local function setupAttackListener(player)
    player.CharacterAdded:Connect(function(char)
        local hum = char:WaitForChild("Humanoid", 5)
        if hum then
            local animator = hum:WaitForChild("Animator", 5)
            if animator then
                animator.AnimationPlayed:Connect(function(animTrack)
                    if animTrack and animTrack.Animation and table.find(AttackAnimations, animTrack.Animation.AnimationId) then
                        pcall(function()
                            local root = char:FindFirstChild("HumanoidRootPart")
                            local hl = root and root:FindFirstChild("MM2_ESP")
                            if hl then
                                hl:SetAttribute("IsAttacking", true)
                                hl.FillColor = Color3.fromRGB(255, 0, 150)
                                hl.OutlineColor = Color3.fromRGB(255, 0, 150)
                                
                                task.spawn(function()
                                    while true do
                                        RunService.Heartbeat:Wait()
                                        local stillAttacking = false
                                        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                                            if table.find(AttackAnimations, track.Animation.AnimationId) then
                                                stillAttacking = true
                                            end
                                        end
                                        if not stillAttacking then break end
                                    end
                                    if hl and hl.Parent then
                                        hl:SetAttribute("IsAttacking", false)
                                    end
                                end)
                            end
                        end)
                    end
                end)
            end
        end
    end)
end

for _, p in ipairs(Players:GetPlayers()) do
    setupAttackListener(p)
end
Players.PlayerAdded:Connect(setupAttackListener)

task.spawn(function()
    while true do
        pcall(function()
            if gunEspEnabled then
                for _, v in pairs(workspace:GetDescendants()) do
                    if v.Name == "GunDrop" and v:IsA("BasePart") then
                        if not v:FindFirstChild("GunESP_Highlight") then
                            local hl = Instance.new("Highlight")
                            hl.Name = "GunESP_Highlight"
                            hl.Adornee = v
                            hl.FillColor = gunEspColor
                            hl.OutlineColor = gunEspColor
                            hl.FillTransparency = 0.3
                            hl.OutlineTransparency = 0
                            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            hl.Parent = v
                        end
                        
                        if not v:FindFirstChild("GunESP_Text") then
                            local bgui = Instance.new("BillboardGui")
                            bgui.Name = "GunESP_Text"
                            bgui.Adornee = v
                            bgui.Size = UDim2.new(0, 120, 0, 50)
                            bgui.StudsOffset = Vector3.new(0, 2, 0)
                            bgui.AlwaysOnTop = true
                            
                            local tlabel = Instance.new("TextLabel")
                            tlabel.Size = UDim2.new(1, 0, 1, 0)
                            tlabel.BackgroundTransparency = 1
                            tlabel.Text = "DROPPED GUN"
                            tlabel.TextColor3 = gunEspColor
                            tlabel.TextStrokeColor3 = Color3.new(0, 0, 0)
                            tlabel.TextStrokeTransparency = 0
                            tlabel.Font = Enum.Font.GothamBold
                            tlabel.TextSize = 14
                            tlabel.Parent = bgui
                            
                            bgui.Parent = v
                        end
                    end
                end
            end

            if trapsEspEnabled then
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("BasePart") or v:IsA("Model") then
                        local nameLower = v.Name:lower()
                        if nameLower:find("trap") or nameLower:find("bear") or nameLower:find("hazard") then
                            local part = v:IsA("BasePart") and v or v.PrimaryPart or v:FindFirstChildOfClass("BasePart")
                            if part and not part:FindFirstChild("TrapESP_Highlight") then
                                local hl = Instance.new("Highlight")
                                hl.Name = "TrapESP_Highlight"
                                hl.Adornee = v
                                hl.FillColor = trapEspColor
                                hl.OutlineColor = trapEspColor
                                hl.FillTransparency = 0.2
                                hl.OutlineTransparency = 0
                                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                                hl.Parent = part
                            end
                        end
                    end
                end
            end

            if xrayEnabled then
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and not obj:IsA("Terrain") then
                        local isPlayerPart = false
                        for _, plr in ipairs(Players:GetPlayers()) do
                            if plr.Character and obj:IsDescendantOf(plr.Character) then
                                isPlayerPart = true
                                break
                            end
                        end
                        if not isPlayerPart and obj.Name ~= "HumanoidRootPart" then
                            if originalTransparency[obj] == nil then
                                originalTransparency[obj] = obj.Transparency
                            end
                            obj.Transparency = 0.65
                        end
                    end
                end
            end
        end)
        task.wait(1.5) 
    end
end)

task.spawn(function()
    while true do
        updateMM2ESP()
        task.wait(0.6)
    end
end)

--------------------------------------------------
-- 5. PLAYER TAB
--------------------------------------------------
local playerTab = Window:Tab({ Title = "Player", Icon = "user", ShowTabTitle = true, Border = true })

playerTab:Divider()
playerTab:Paragraph({ Title = "Speed & Jumping", Desc = "Character physics modifications" })

local playerSettings = { 
    WalkSpeed = { Enabled = false, Value = 16 }, 
    JumpPower = { Enabled = false, Value = 50 }, 
    InfiniteJump = false, 
    Noclip = false 
}

playerTab:Toggle({ 
    Title = "Enable WalkSpeed", 
    Default = false, 
    Callback = function(state) 
        playerSettings.WalkSpeed.Enabled = state 
    end 
})

playerTab:Slider({ 
    Title = "Speed Value", 
    Step = 1, 
    Value = {Min = 16, Max = 100, Default = 16}, 
    Callback = function(val) 
        playerSettings.WalkSpeed.Value = val 
    end 
})

playerTab:Toggle({ 
    Title = "Enable JumpPower", 
    Default = false, 
    Callback = function(state) 
        playerSettings.JumpPower.Enabled = state 
    end 
})

playerTab:Slider({ 
    Title = "Jump Power Value", 
    Step = 1, 
    Value = {Min = 50, Max = 200, Default = 50}, 
    Callback = function(val) 
        playerSettings.JumpPower.Value = val 
    end 
})

playerTab:Divider()
playerTab:Paragraph({ Title = "Movement Modifiers", Desc = "Advanced mobility and physics bypass" })

playerTab:Toggle({ 
    Title = "Infinite Jump", 
    Default = false, 
    Callback = function(state) 
        playerSettings.InfiniteJump = state 
    end 
})

playerTab:Toggle({ 
    Title = "Noclip", 
    Default = false, 
    Callback = function(state) 
        playerSettings.Noclip = state 
    end 
})

task.spawn(function()
    while true do
        pcall(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                local humanoid = LocalPlayer.Character.Humanoid
                if playerSettings.WalkSpeed.Enabled then humanoid.WalkSpeed = playerSettings.WalkSpeed.Value end
                if playerSettings.JumpPower.Enabled then humanoid.UseJumpPower = true; humanoid.JumpPower = playerSettings.JumpPower.Value end
            end
        end)
        task.wait(0.2)
    end
end)

RunService.Stepped:Connect(function()
    pcall(function()
        if playerSettings.Noclip and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
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

--------------------------------------------------
-- 6. NAVIGATION TAB
--------------------------------------------------
local teleportsTab = Window:Tab({ Title = "Navigation", Icon = "navigation", ShowTabTitle = true, Border = true })

teleportsTab:Divider()
teleportsTab:Paragraph({ Title = "Map & Lobby Teleports", Desc = "Fast travel across round environments" })

teleportsTab:Button({ 
    Title = "Teleport to Lobby", 
    Callback = function()
        pcall(teleportToLobby)
    end 
})

teleportsTab:Keybind({
    Title = "Teleport to Lobby Keybind",
    Key = "None",
    Callback = function()
        pcall(teleportToLobby)
    end
})

teleportsTab:Button({ 
    Title = "Teleport to Map", 
    Callback = function()
        pcall(teleportToMap)
    end 
})

teleportsTab:Keybind({
    Title = "Teleport to Map Keybind",
    Key = "None",
    Callback = function()
        pcall(teleportToMap)
    end
})

teleportsTab:Divider()
teleportsTab:Paragraph({ Title = "Role Teleports", Desc = "Instant teleport to Murderer or Sheriff" })

teleportsTab:Button({
    Title = "Teleport to Murderer",
    Callback = function()
        pcall(function()
            local target = getMurderer()
            if target then
                teleportToPlayer(target)
            else
                WindUI:Notify({ Title = "Navigation", Content = "Murderer not found.", Duration = 3 })
            end
        end)
    end
})

teleportsTab:Button({
    Title = "Teleport to Sheriff",
    Callback = function()
        pcall(function()
            local target = getSheriff()
            if target then
                teleportToPlayer(target)
            else
                WindUI:Notify({ Title = "Navigation", Content = "Sheriff not found.", Duration = 3 })
            end
        end)
    end
})

teleportsTab:Divider()
teleportsTab:Paragraph({ Title = "Player Teleport List", Desc = "Select and teleport to any player in the server" })

local selectedTpPlayer = ""

local tpDropdown = teleportsTab:Dropdown({
    Title = "Select Player to TP",
    Values = getPlayerNames(),
    Callback = function(selected)
        selectedTpPlayer = selected
    end
})

local function updateTpDropdown()
    pcall(function()
        local updatedNames = getPlayerNames()
        tpDropdown:SetValues(updatedNames)
    end)
end

Players.PlayerAdded:Connect(function(p)
    task.wait(1)
    updateTpDropdown()
end)

Players.PlayerRemoving:Connect(function(p)
    updateTpDropdown()
end)

teleportsTab:Button({
    Title = "Refresh Player List",
    Desc = "Manually updates the server player list.",
    Callback = function()
        updateTpDropdown()
        WindUI:Notify({ Title = "Vortex x Software", Content = "Player list updated.", Duration = 2 })
    end
})

teleportsTab:Button({
    Title = "Teleport to Selected Player",
    Callback = function()
        if selectedTpPlayer ~= "" then
            local target = Players:FindFirstChild(selectedTpPlayer)
            if target then
                teleportToPlayer(target)
            else
                WindUI:Notify({ Title = "Navigation", Content = "Player not found.", Duration = 3 })
            end
        else
            WindUI:Notify({ Title = "Navigation", Content = "Select a player first.", Duration = 3 })
        end
    end
})

teleportsTab:Divider()
teleportsTab:Paragraph({ Title = "Sheriff Gun Utilities", Desc = "Instant gun retrieval options" })

teleportsTab:Button({ 
    Title = "Get Gun Instantly", 
    Callback = function() 
        pcall(instantGrabGun) 
    end 
})

teleportsTab:Keybind({
    Title = "Get Gun Instantly Keybind",
    Key = "None",
    Callback = function()
        pcall(instantGrabGun)
    end
})

teleportsTab:Toggle({ 
    Title = "Auto Get Gun", 
    Default = false, 
    Callback = function(state) 
        autoGunTp = state 
    end 
})

teleportsTab:Toggle({
    Title = "Floating Get Gun Button (Mobile)",
    Desc = "Boton flotante: TP a la pistola, la toma y regresa.",
    Default = false,
    Callback = function(val)
        createFloatingGunButton(val)
    end
})

task.spawn(function()
    while true do
        if autoGunTp then
            pcall(function()
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 and not isFlingingActive then
                    if getLocalRole() ~= "Murderer" and not hasGunEquippedOrInBag() then
                        if findGunDrop() then
                            instantGrabGun()
                            task.wait(1.5)
                        end
                    end
                end
            end)
        end
        task.wait(0.8)
    end
end)

--------------------------------------------------
-- 7. MISC / FUN TAB
--------------------------------------------------
local miscTab = Window:Tab({ Title = "Misc / Fun", Icon = "sparkles", ShowTabTitle = true, Border = true })

miscTab:Divider()
miscTab:Paragraph({ Title = "Emotes & Animations", Desc = "Loads the universal emotes script" })

miscTab:Button({
    Title = "AFEM Max (Emotes)",
    Desc = "Opens the full animation and emote menu.",
    Callback = function()
        pcall(function()
            loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-AFEM-Max-Open-Alpha-50210"))()
            WindUI:Notify({ Title = "Vortex x Software", Content = "Loading AFEM Max Emotes...", Duration = 3 })
        end)
    end
})

miscTab:Divider()
miscTab:Paragraph({ Title = "Trade Exploits", Desc = "Force trade interaction tools" })

local tradeTargetName = ""
miscTab:Input({ 
    Title = "Player Username", 
    Placeholder = "Enter username...", 
    Callback = function(text) 
        tradeTargetName = text 
    end 
})

miscTab:Button({
    Title = "Force Trade Request",
    Callback = function()
        pcall(function()
            if tradeTargetName == "" then 
                WindUI:Notify({ Title = "Trade", Content = "Enter a valid username.", Duration = 3 })
                return 
            end
            local target = Players:FindFirstChild(tradeTargetName)
            if target then
                local tradeFolder = ReplicatedStorage:FindFirstChild("Trade")
                if tradeFolder then
                    local sendReq = tradeFolder:FindFirstChild("SendRequest")
                    local acceptReq = tradeFolder:FindFirstChild("AcceptRequest")
                    if sendReq then sendReq:InvokeServer(target) end
                    if acceptReq then acceptReq:FireServer() end
                    WindUI:Notify({ Title = "Force Trade", Content = "Trade sent to: " + target.Name, Duration = 3 })
                end
            else
                WindUI:Notify({ Title = "Trade", Content = "Player not found in server.", Duration = 3 })
            end
        end)
    end
})

miscTab:Divider()
miscTab:Paragraph({ Title = "Chat Role Revealer", Desc = "Broadcast roles to game chat" })

local autoExposeEnabled = false
local rolesExposedThisRound = false

miscTab:Button({
    Title = "Expose Roles in Chat",
    Callback = function()
        pcall(function()
            local murderer = getMurderer()
            local sheriff = getSheriff()
            if murderer then sendChatMessage("[VORTEX] MURDER: " .. murderer.Name) task.wait(0.3) end
            if sheriff then sendChatMessage("[VORTEX] SHERIFF: " .. sheriff.Name) end
            if not murderer and not sheriff then
                WindUI:Notify({ Title = "Role Revealer", Content = "No active roles detected yet.", Duration = 3 })
            end
        end)
    end
})

miscTab:Toggle({ 
    Title = "Auto Expose Roles in Chat", 
    Default = false, 
    Callback = function(val) 
        autoExposeEnabled = val 
        if not val then 
            rolesExposedThisRound = false 
        end 
    end 
})

task.spawn(function()
    while true do
        if autoExposeEnabled then
            pcall(function()
                local murderer = getMurderer()
                local sheriff = getSheriff()
                if (murderer or sheriff) then
                    if not rolesExposedThisRound then
                        if murderer then sendChatMessage("[VORTEX] MURDER: " .. murderer.Name) task.wait(0.3) end
                        if sheriff then sendChatMessage("[VORTEX] SHERIFF: " .. sheriff.Name) end
                        rolesExposedThisRound = true
                    end
                else
                    rolesExposedThisRound = false
                end
            end)
        else
            rolesExposedThisRound = false
        end
        task.wait(1.5)
    end
end)

print("[Vortex] Script cargado OK con teletransporte optimizado y selector de roles ESP mediante Dropdown + Toggle maestro.")
