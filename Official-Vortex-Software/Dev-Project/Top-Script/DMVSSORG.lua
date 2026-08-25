-- ==========================================
-- SOFTWARE VORTEX X V3.2.4 [DMvSS] - WIND UI
-- MULTI-EXECUTOR (PC, Delta, Hydrogen, CodeX, etc.)
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
local freeMouseEnabled = false

-- ==========================================
-- OPTIMIZED PROTECTION & ANTI-DETECTION
-- ==========================================
local spoofedSizes = {}
local spoofedCanCollide = {}

pcall(function()
    if getrawmetatable and setreadonly and newcclosure and checkcaller then
        local gm = getrawmetatable(game)
        local oldIndex = gm.__index

        setreadonly(gm, false)

        gm.__index = newcclosure(function(self, key)
            if not checkcaller() then
                local spoofSize = spoofedSizes[self]
                if spoofSize and key == "Size" then return spoofSize end
                
                local spoofCollide = spoofedCanCollide[self]
                if spoofCollide ~= nil and key == "CanCollide" then return spoofCollide end
            end
            return oldIndex(self, key)
        end)

        setreadonly(gm, true)
    end
end)

local ProtectedGui = Instance.new("Folder")
ProtectedGui.Name = "VortexXSoftware_Protected"
pcall(function()
    ProtectedGui.Parent = (gethui and gethui()) or CoreGui
end)
if ProtectedGui.Parent ~= CoreGui and not gethui then
    pcall(function()
        ProtectedGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end)
end

-- ==========================================
-- WIND UI SETUP & LOGIN NOTIFICATION
-- ==========================================
local WindUI = loadstring(game:HttpGet("https://github.com/MrSxxo/WindUI/releases/latest/download/main.lua"))()

if not WindUI then
    warn("Failed to load WindUI. Your executor might not be compatible.")
    return
end

WindUI:Notify({
    Title = "Software Vortex-x",
    Content = "Logging in... Please wait.",
    Duration = 3
})

task.wait(2)

WindUI:Notify({
    Title = "Software Vortex-x",
    Content = "Access Granted, " .. LocalPlayer.Name .. "! Loading interface...",
    Duration = 2
})

task.wait(1)

local Window = WindUI:CreateWindow({
    Title = "Software Vortex X [DMvSS]",
    Icon = "rbxassetid://134730158740955",
    IconSize = "35",
    Author = "by Israelcc",
    Folder = "VortexXSoftware",
    Resizable = false,
    HideSearchBar = true,
    Transparent = false,
    Theme = "Dark",
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
    OnlyMobile = true,
    Enabled = true,
    Draggable = true,
})

pcall(function()
    Window:Label({
        Title = "3.2.4",
        Icon = "github",
        Color = Color3.fromRGB(230, 0, 50)
    })
end)

WindUI:AddTheme({
    Name = "VortexCrimsonSolid",
    Accent = Color3.fromRGB(255, 30, 80),
    Background = Color3.fromRGB(14, 14, 14),
    BackgroundTransparency = 0,
    Outline = Color3.fromRGB(255, 30, 80),
    Text = Color3.fromRGB(245, 245, 245),
    Placeholder = Color3.fromRGB(150, 150, 150),
    Button = Color3.fromRGB(210, 15, 60),
    Icon = Color3.fromRGB(255, 50, 90),
    Hover = Color3.fromRGB(255, 255, 255),
    WindowBackground = Color3.fromRGB(14, 14, 14),
    WindowShadow = Color3.fromRGB(255, 30, 80),
    DialogBackground = Color3.fromRGB(22, 22, 22),
    DialogBackgroundTransparency = 0,
    DialogTitle = Color3.fromRGB(255, 255, 255),
    DialogContent = Color3.fromRGB(220, 220, 220),
    DialogIcon = Color3.fromRGB(255, 50, 90),
    WindowTopbarButtonIcon = Color3.fromRGB(255, 255, 255),
    WindowTopbarTitle = Color3.fromRGB(255, 255, 255),
    WindowTopbarAuthor = Color3.fromRGB(180, 180, 180),
    WindowTopbarIcon = Color3.fromRGB(255, 50, 90),
    TabBackground = Color3.fromRGB(20, 20, 20),
    TabTitle = Color3.fromRGB(240, 240, 240),
    TabIcon = Color3.fromRGB(255, 50, 90),
    ElementBackground = Color3.fromRGB(22, 22, 22),
    ElementTitle = Color3.fromRGB(255, 255, 255),
    ElementDesc = Color3.fromRGB(170, 170, 170),
    ElementIcon = Color3.fromRGB(255, 50, 90),
    PopupBackground = Color3.fromRGB(22, 22, 22),
    PopupBackgroundTransparency = 0,
    PopupTitle = Color3.fromRGB(255, 255, 255),
    PopupContent = Color3.fromRGB(200, 200, 200),
    PopupIcon = Color3.fromRGB(255, 50, 90),
    Toggle = Color3.fromRGB(255, 30, 80),
    ToggleBar = Color3.fromRGB(30, 30, 30),
    Checkbox = Color3.fromRGB(30, 30, 30),
    CheckboxIcon = Color3.fromRGB(255, 255, 255),
    Slider = Color3.fromRGB(255, 30, 80),
    SliderThumb = Color3.fromRGB(255, 255, 255),
})

WindUI:SetTheme("VortexCrimsonSolid")
Window:SetToggleKey(Enum.KeyCode.K)
Window:OnClose(function() end)

-- ==========================================
-- BASE LOGIC
-- ==========================================
local myGame, myTeam = nil, nil

local function refreshIdentity()
    pcall(function()
        myGame = LocalPlayer:GetAttribute("Game")
        myTeam = LocalPlayer:GetAttribute("Team")
    end)
end

local function isEnemy(plr)
    if not plr or plr == LocalPlayer then return false end
    if not myGame or not myTeam then return false end
    local g = plr:GetAttribute("Game")
    local t = plr:GetAttribute("Team")
    return g == myGame and t ~= nil and t ~= myTeam
end

local function isAlly(plr)
    if not plr or plr == LocalPlayer then return false end
    if not myGame or not myTeam then return false end
    return plr:GetAttribute("Game") == myGame and plr:GetAttribute("Team") == myTeam
end

task.spawn(function()
    while true do
        refreshIdentity()
        task.wait(2)
    end
end)

-- ==========================================
-- CONFIG TAB
-- ==========================================
local InfoTab = Window:Tab({ Title = "Config", Icon = "info", ShowTabTitle = true, Border = true })
InfoTab:Select()

InfoTab:Divider()
InfoTab:Paragraph({ Title = "Community", Desc = "" })

InfoTab:Button({
    Title = "Copy Discord Link",
    Desc = "Copia el enlace de invitación al portapapeles",
    Callback = function()
        copyToClipboard("https://discord.gg/Fn74MpzFUn")
    end
})

InfoTab:Button({
    Title = "Official Website",
    Desc = "Copia el enlace del sitio web al portapapeles",
    Callback = function()
        copyToClipboard("https://vortex-x-software.netlify.app/")
    end
})

InfoTab:Paragraph({ Title = "Israelcc", Desc = "Desarrollador Principal" })
InfoTab:Paragraph({ Title = "WindUI", Desc = "Créditos Especiales / UI Library" })

InfoTab:Divider()
InfoTab:Paragraph({ Title = "Configuration", Desc = "" })

InfoTab:Keybind({
    Title = "Menu Keybind",
    Desc = "Interfaz de usuario de Abir/Cerrar",
    Key = "K",
    Callback = function(keyVal)
        Window:SetToggleKey(Enum.KeyCode[tostring(keyVal)] or Enum.KeyCode.K)
    end
})

InfoTab:Button({
    Title = "Toggle UI",
    Desc = "Esconde o muestra el menú rápido",
    Callback = function()
        pcall(function()
            local ui = (gethui and gethui()) or CoreGui
            for _, gui in ipairs(ui:GetChildren()) do
                if gui:IsA("ScreenGui") and (string.find(gui.Name, "WindUI") or string.find(gui.Name, "Luna") or string.find(gui.Name, "Vortex")) then
                    gui.Enabled = not gui.Enabled
                    break
                end
            end
        end)
    end
})

InfoTab:Toggle({
    Title = "Free Mouse (Lock Camera)",
    Desc = "Permite usar el ratón para hacer clic en la interfaz sin que el juego mueva la cámara",
    Default = false,
    Callback = function(estado)
        freeMouseEnabled = estado
        if not estado then
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        end
    end
})

InfoTab:Toggle({
    Title = "Notifications",
    Desc = "Activar avisos en pantalla",
    Default = false,
    Callback = function(notifVal)
        WindUI:Notify({ Title = "Software Vortex X", Content = "Notifications: " .. tostring(notifVal), Duration = 2 })
    end
})

InfoTab:Button({
    Title = "Disconnect",
    Desc = "Salir al Lobby",
    Callback = function()
        pcall(function() LocalPlayer:Kick("Desconectado por el usuario.") end)
    end
})

Window:Divider()

-- ==========================================
-- BANNABLE TAB
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

getgenv().instaKillState = getgenv().instaKillState or false

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

local bannableTab = Window:Tab({
    Title = "Bannable",
    Icon = "shield-alert",
    ShowTabTitle = true,
    Border = true
})

bannableTab:Divider()
bannableTab:Paragraph({ Title = "Floating Controls (Bubbles)", Desc = "" })

local editBubblesState = false
local bubblesScreenGui = Instance.new("ScreenGui")
bubblesScreenGui.Name = "Vortex_SystemGUI"
bubblesScreenGui.ResetOnSpawn = false
bubblesScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() bubblesScreenGui.Parent = ProtectedGui end)
if not bubblesScreenGui.Parent then bubblesScreenGui.Parent = CoreGui end

local bubblesContainer = Instance.new("Frame")
bubblesContainer.Name = "BubblesContainer"
bubblesContainer.Size = UDim2.new(0, 50, 0, 165)
bubblesContainer.AnchorPoint = Vector2.new(1, 0.5)
bubblesContainer.Position = UDim2.new(0.98, 0, 0.45, 0) 
bubblesContainer.BackgroundTransparency = 1
bubblesContainer.Active = false
bubblesContainer.Parent = bubblesScreenGui

local bubbleDesync = Instance.new("TextButton")
bubbleDesync.Name = "BubbleDesync"
bubbleDesync.Size = UDim2.new(0, 45, 0, 45)
bubbleDesync.Position = UDim2.new(0, 2, 0, 0)
bubbleDesync.Text = "DSY"
bubbleDesync.TextColor3 = Color3.fromRGB(255, 255, 255)
bubbleDesync.Font = Enum.Font.GothamBold
bubbleDesync.TextSize = 13
bubbleDesync.Visible = false 
bubbleDesync.Parent = bubblesContainer
Instance.new("UICorner", bubbleDesync).CornerRadius = UDim.new(1, 0)

local bgDesync = Instance.new("UIGradient")
bgDesync.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 30, 80)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
})
bgDesync.Rotation = 45
bgDesync.Parent = bubbleDesync

local bubbleGhost = Instance.new("TextButton")
bubbleGhost.Name = "BubbleGhost"
bubbleGhost.Size = UDim2.new(0, 45, 0, 45)
bubbleGhost.Position = UDim2.new(0, 2, 0, 55)
bubbleGhost.Text = "GST"
bubbleGhost.TextColor3 = Color3.fromRGB(255, 255, 255)
bubbleGhost.Font = Enum.Font.GothamBold
bubbleGhost.TextSize = 13
bubbleGhost.Visible = false 
bubbleGhost.Parent = bubblesContainer
Instance.new("UICorner", bubbleGhost).CornerRadius = UDim.new(1, 0)

local bgGhost = Instance.new("UIGradient")
bgGhost.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 30, 80)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
})
bgGhost.Rotation = 45
bgGhost.Parent = bubbleGhost

local bubbleInstaKill = Instance.new("TextButton")
bubbleInstaKill.Name = "BubbleInstaKill"
bubbleInstaKill.Size = UDim2.new(0, 45, 0, 45)
bubbleInstaKill.Position = UDim2.new(0, 2, 0, 110)
bubbleInstaKill.Text = "IKL"
bubbleInstaKill.TextColor3 = Color3.fromRGB(255, 255, 255)
bubbleInstaKill.Font = Enum.Font.GothamBold
bubbleInstaKill.TextSize = 13
bubbleInstaKill.Visible = false 
bubbleInstaKill.Parent = bubblesContainer
Instance.new("UICorner", bubbleInstaKill).CornerRadius = UDim.new(1, 0)

local bgInstaKill = Instance.new("UIGradient")
bgInstaKill.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 30, 80)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
})
bgInstaKill.Rotation = 45
bgInstaKill.Parent = bubbleInstaKill

local function makeDraggable(trigger, target)
    local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
    trigger.InputBegan:Connect(function(input)
        if editBubblesState and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
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
            local delta = input.Position - dragStart
            target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    trigger.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

makeDraggable(bubbleDesync, bubblesContainer)
makeDraggable(bubbleGhost, bubblesContainer)
makeDraggable(bubbleInstaKill, bubblesContainer)

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
    Callback = function(val)
        bubbleGhost.Visible = val
    end
})

bannableTab:Toggle({
    Title = "Show Bubble Desync (DSY)",
    Desc = "Muestra u oculta el botón flotante.",
    Default = false,
    Callback = function(val)
        bubbleDesync.Visible = val
    end
})

bannableTab:Toggle({
    Title = "Show Bubble Insta Kill Beta (IKL)",
    Desc = "Muestra u oculta el botón flotante de Insta Kill (Beta).",
    Default = false,
    Callback = function(val)
        bubbleInstaKill.Visible = val
    end
})

bannableTab:Divider()
bannableTab:Paragraph({ Title = "PC Keybinds (Ghost, Desync & Insta Kill Beta)", Desc = "" })

local function executeGhostLogic()
    invisState.isInvisible = not invisState.isInvisible

    WindUI:Notify({
        Title = "Software Vortex X",
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
        safePlatform.Name = "InvisSafePlatform"
        safePlatform.Anchored = true
        safePlatform.Size = Vector3.new(40, 2, 40)
        safePlatform.CFrame = CFrame.new(safePos) - Vector3.new(0, 3, 0)
        safePlatform.Transparency = 1
        safePlatform.Parent = workspace
        invisState.platform = safePlatform

        local seat = Instance.new("Seat")
        seat.Name = "InvisSeat"
        seat.Anchored = true
        seat.Size = Vector3.new(2, 1, 2)
        seat.CFrame = CFrame.new(safePos)
        seat.Transparency = 1
        seat.Parent = workspace
        invisState.seat = seat

        realChar.Archivable = true
        local fakeChar = realChar:Clone()
        fakeChar.Name = "Vortex_FakeChar_Invis"
        
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
        Title = "Software Vortex X",
        Content = "Desync Mode: " .. (desyncState.isDesynced and "ACTIVATED" or "DEACTIVATED"),
        Duration = 2
    })
    
    if desyncState.isDesynced then
        local savedCFrame = hrp.CFrame
        desyncState.animCache = {}
        
        realChar.Archivable = true
        local fakeChar = realChar:Clone()
        fakeChar.Name = "Vortex_FakeChar_Desync"
        
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
        platform.Name = "desyncplatform"
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

local function executeInstaKillLogic()
    getgenv().instaKillState = not getgenv().instaKillState

    WindUI:Notify({
        Title = "Software Vortex X",
        Content = "Insta Kill (Beta): " .. (getgenv().instaKillState and "ACTIVATED" or "DEACTIVATED"),
        Duration = 2
    })
end

bannableTab:Keybind({
    Title = "Activate Ghost Mode (Invisibility)",
    Desc = "Tecla para alternar Ghost Mode",
    Key = "H",
    Callback = function()
        executeGhostLogic()
    end
})

bannableTab:Keybind({
    Title = "Activate Desync Mode",
    Desc = "Tecla para alternar Desync",
    Key = "J",
    Callback = function()
        executeDesyncLogic()
    end
})

bannableTab:Keybind({
    Title = "Activate Insta Kill Mode (Beta)",
    Desc = "Tecla para alternar Insta Kill (Beta)",
    Key = "N",
    Callback = function()
        executeInstaKillLogic()
    end
})

bubbleGhost.MouseButton1Click:Connect(function()
    if editBubblesState then return end
    executeGhostLogic()
end)

bubbleDesync.MouseButton1Click:Connect(function()
    if editBubblesState then return end
    executeDesyncLogic()
end)

bubbleInstaKill.MouseButton1Click:Connect(function()
    if editBubblesState then return end
    executeInstaKillLogic()
end)

-- ==========================================
-- OPTIMIZED INSTA KILL LOOP
-- ==========================================
task.spawn(function()
    while task.wait(0.3) do
        if getgenv().instaKillState then
            pcall(function()
                local character = LocalPlayer.Character
                if not character then return end
                
                local tool = character:FindFirstChildOfClass("Tool")
                if tool then
                    tool:Activate()
                end

                for _, plr in ipairs(Players:GetPlayers()) do
                    if isEnemy(plr) and plr.Character then
                        local targetChar = plr.Character
                        local targetHrp = targetChar:FindFirstChild("HumanoidRootPart")
                        local hum = targetChar:FindFirstChild("Humanoid")
                        if targetHrp and hum and hum.Health > 0 then
                            local dist = (character.PrimaryPart.Position - targetHrp.Position).Magnitude
                            if dist < 12 and tool then
                                pcall(function()
                                    tool:Activate()
                                    if mouse1click then
                                        pcall(mouse1click)
                                    end
                                end)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ==========================================
-- COMBAT TAB (AIMBOT / SILENT AIM / CROSSHAIR)
-- ==========================================
local aimCamState = false
local cameraConn = nil
local wallCheckEnabled = false
local fovRadius = 150
local silentAimEnabled = false
local currentSilentTarget = nil

local function isTargetVisibleLocal(targetPart)
    if not wallCheckEnabled then return true end
    if not targetPart or not LocalPlayer.Character then return true end
    local origin = Camera.CFrame.Position
    local direction = targetPart.Position - origin
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    local ignoreList = {LocalPlayer.Character}
    if LocalPlayer.Character:FindFirstChild("Head") then table.insert(ignoreList, LocalPlayer.Character.Head) end
    raycastParams.FilterDescendantsInstances = ignoreList
    raycastParams.IgnoreWater = true
    local result = workspace:Raycast(origin, direction, raycastParams)
    if result then
        if result.Instance:IsDescendantOf(targetPart.Parent) then return true end
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

local combatTab = Window:Tab({ Title = "Combat", Icon = "crosshair", ShowTabTitle = true, Border = true })

combatTab:Divider()
combatTab:Paragraph({ Title = "Silent Aim Legit", Desc = "" })

local silentAimToggleRef = combatTab:Toggle({
    Title = "Silent Aim Legit",
    Desc = "Auto Apuntado Legit (Modifica disparos)",
    Default = false,
    Callback = function(aimMetaVal) silentAimEnabled = aimMetaVal end
})

combatTab:Keybind({
    Title = "Silent Aim Keybind",
    Desc = "Activa o desactiva el Silent Aim",
    Key = "Z",
    Callback = function()
        silentAimEnabled = not silentAimEnabled
        pcall(function() silentAimToggleRef:SetValue(silentAimEnabled) end)
    end
})

combatTab:Divider()
combatTab:Paragraph({ Title = "Aimbot", Desc = "" })

local aimbotToggleRef = combatTab:Toggle({
    Title = "Aimbot",
    Desc = "Mueve la camara hacia el enemigo",
    Default = false,
    Callback = function(aimCamVal)
        aimCamState = aimCamVal
        if aimCamState then setupAimbotLoop() else disconnectAimbotLoop() end
    end
})

combatTab:Keybind({
    Title = "Aimbot Keybind",
    Desc = "Activar o desactivar el Aimbot",
    Key = "X",
    Callback = function()
        aimCamState = not aimCamState
        if aimCamState then setupAimbotLoop() else disconnectAimbotLoop() end
        pcall(function() aimbotToggleRef:SetValue(aimCamState) end)
    end
})

combatTab:Slider({ Title = "Field of View (FOV)", Step = 1, Value = {Min = 10, Max = 500, Default = 150}, Flag = "fov_size", Callback = function(fovVal) fovRadius = fovVal end })

combatTab:Divider()
combatTab:Paragraph({ Title = "Wall Check", Desc = "" })

combatTab:Toggle({ Title = "Wall-Check", Desc = "Verificar si el objetivo es visible a través de paredes", Default = false, Callback = function(wallCheckVal) wallCheckEnabled = wallCheckVal end })

-- Optimized Silent Target finder loop via RenderStepped throttle
local silentClock = 0
RunService.RenderStepped:Connect(function(dt)
    if not silentAimEnabled then 
        currentSilentTarget = nil
        return 
    end
    
    silentClock = silentClock + dt
    if silentClock < 0.05 then return end -- Throttled to 20fps for performance
    silentClock = 0

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
    currentSilentTarget = target
end)

pcall(function()
    if getrawmetatable and setreadonly then
        local mt = getrawmetatable(Mouse)
        local oldIndex = mt.__index
        setreadonly(mt, false)

        mt.__index = newcclosure(function(self, index)
            if (index == "Hit" or index == "Target") and silentAimEnabled and currentSilentTarget then
                if index == "Hit" then return currentSilentTarget.CFrame end
                if index == "Target" then return currentSilentTarget end
            end
            return oldIndex(self, index)
        end)
        setreadonly(mt, true)
    end
end)

combatTab:Divider()
combatTab:Paragraph({ Title = "Crosshair", Desc = "" })

local crosshairGui = nil
local crosshairColor = Color3.fromRGB(255, 30, 80)
local crosshairSizeVal = 6
local crosshairGapVal = 4

local function updateCrosshairUI()
    if not crosshairGui then return end
    local container = crosshairGui:FindFirstChild("Contenedor")
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
            screenGui.Name = "VortexXSoftwareCrosshair"
            screenGui.ResetOnSpawn = false
            pcall(function() screenGui.Parent = ProtectedGui end)
            if not screenGui.Parent then screenGui.Parent = (gethui and gethui()) or CoreGui end

            local centerFrame = Instance.new("Frame")
            centerFrame.Name = "Contenedor"
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
        if crosshairGui then crosshairGui.Enabled = false end
    end
end

combatTab:Toggle({ Title = "Crosshair", Desc = "Activar mira flotante tipo cruzeta", Default = false, Callback = toggleCrosshairFunc })
combatTab:Slider({ Title = "Crosshair Size", Step = 1, Value = {Min = 2, Max = 30, Default = 6}, Flag = "tamaño_de_la_mira", Callback = function(sizeVal) crosshairSizeVal = sizeVal updateCrosshairUI() end })
combatTab:Colorpicker({ Title = "Crosshair Color", Desc = "Cambiar color de la cruz", Default = Color3.fromRGB(255, 30, 80), Callback = function(colorVal)
    crosshairColor = colorVal
    if crosshairGui then
        local container = crosshairGui:FindFirstChild("Contenedor")
        if container then
            for _, line in ipairs(container:GetChildren()) do
                if line:IsA("Frame") and not line.Name:find("Outline") then line.BackgroundColor3 = colorVal end
            end
        end
    end
end })

-- ==========================================
-- HITBOX TAB
-- ==========================================
local hitboxState = false
local visibleState = false
local hitboxSizeVal = 6
local originalSizes = {}

local function applyRealHitbox()
    pcall(function()
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = plr.Character.HumanoidRootPart
                local humanoid = plr.Character:FindFirstChild("Humanoid")
                if isEnemy(plr) and humanoid and humanoid.Health > 0 then
                    if not originalSizes[plr] or originalSizes[plr].hrp ~= hrp then
                        originalSizes[plr] = {hrp = hrp, size = hrp.Size, canCollide = hrp.CanCollide}
                        spoofedSizes[hrp] = hrp.Size
                        spoofedCanCollide[hrp] = hrp.CanCollide
                    end
                    hrp.Size = Vector3.new(hitboxSizeVal, hitboxSizeVal, hitboxSizeVal)
                    hrp.CanCollide = false
                    if visibleState then
                        hrp.Transparency = 0.5
                        hrp.Color = Color3.fromRGB(255, 30, 80)
                        hrp.Material = Enum.Material.Neon
                    else
                        hrp.Transparency = 1
                    end
                else
                    if originalSizes[plr] and originalSizes[plr].hrp == hrp then
                        hrp.Size = originalSizes[plr].size
                        hrp.CanCollide = originalSizes[plr].canCollide
                        spoofedSizes[hrp] = nil
                        spoofedCanCollide[hrp] = nil
                        originalSizes[plr] = nil
                    end
                    hrp.Transparency = 1
                    hrp.Material = Enum.Material.Plastic
                end
            end
        end
    end)
end

local function restaurarHitboxes()
    pcall(function()
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = plr.Character.HumanoidRootPart
                if originalSizes[plr] and originalSizes[plr].hrp == hrp then
                    hrp.Size = originalSizes[plr].size
                    hrp.CanCollide = originalSizes[plr].canCollide
                    spoofedSizes[hrp] = nil
                    spoofedCanCollide[hrp] = nil
                    originalSizes[plr] = nil
                end
                hrp.Transparency = 1
                hrp.Material = Enum.Material.Plastic
            end
        end
    end)
end

local hitboxTab = Window:Tab({ Title = "Hitbox", Icon = "box", ShowTabTitle = true, Border = true })

hitboxTab:Divider()
hitboxTab:Paragraph({ Title = "Real Hitbox (Size Modifier)", Desc = "" })

local hitboxToggleRef = hitboxTab:Toggle({
    Title = "Enable Real Hitbox",
    Desc = "Ampliar hitbox exclusivamente de enemigos",
    Default = false,
    Callback = function(hitboxVal)
        hitboxState = hitboxVal
        if not hitboxState then restaurarHitboxes() end
    end
})

hitboxTab:Keybind({
    Title = "Hitbox Keybind",
    Desc = "Activar o desactivar la Hitbox",
    Key = "C",
    Callback = function()
        hitboxState = not hitboxState
        if not hitboxState then restaurarHitboxes() end
        pcall(function() hitboxToggleRef:SetValue(hitboxState) end)
    end
})

hitboxTab:Divider()
hitboxTab:Paragraph({ Title = "Hitbox Options", Desc = "" })

hitboxTab:Toggle({ Title = "Visualize Hitbox", Desc = "Mostrar hitboxes visualmente para enemigos", Default = false, Callback = function(visibleVal) visibleState = visibleVal end })
hitboxTab:Slider({ Title = "Hitbox Size", Step = 1, Value = {Min = 2, Max = 20, Default = 6}, Flag = "hitbox_size", Callback = function(sizeVal) hitboxSizeVal = sizeVal end })

task.spawn(function()
    while task.wait(0.8) do
        if hitboxState then applyRealHitbox() end
    end
end)

-- ==========================================
-- ESP TAB
-- ==========================================
local espEnabled = false
local allyEspEnabled = false
local professionalEspEnabled = false
local outlineEnabled = true
local enemyOutlineColor = Color3.fromRGB(255, 30, 80)
local allyOutlineColor = Color3.fromRGB(0, 255, 128)
local professionalEspDrawings = {}

local function addEnemyESP(char, plr)
    if not char or not char.Parent or not plr then return end
    local hlName = plr.Name .. "_EnemyESP"
    local existingHl = ProtectedGui:FindFirstChild(hlName)
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not root or not hum or hum.Health <= 0 then return end
    if existingHl then
        if existingHl.Adornee ~= char then existingHl.Adornee = char end
        return
    end
    pcall(function()
        local hl = Instance.new("Highlight")
        hl.Name = hlName
        hl.Adornee = char
        hl.FillColor = Color3.fromRGB(0, 0, 0)
        hl.OutlineColor = enemyOutlineColor
        hl.FillTransparency = 0.9
        hl.OutlineTransparency = outlineEnabled and 0 or 1
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = ProtectedGui
    end)
end

local function removeEnemyESP(plr)
    if not plr then return end
    pcall(function()
        local hl = ProtectedGui:FindFirstChild(plr.Name .. "_EnemyESP")
        if hl then hl:Destroy() end
    end)
end

local function clearAllEnemyESP()
    for _, p in ipairs(Players:GetPlayers()) do removeEnemyESP(p) end
end

local function clearProfessionalESP()
    for plr, drawings in pairs(professionalEspDrawings) do
        if drawings then
            if drawings.box then for _, line in ipairs(drawings.box) do if line then line:Remove() end end end
            if drawings.tracer then drawings.tracer:Remove() end
            if drawings.nameText then drawings.nameText:Remove() end
        end
    end
    professionalEspDrawings = {}
end

local function refreshEnemyESP()
    if not espEnabled then
        clearAllEnemyESP()
        return
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local char = plr.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                if isEnemy(plr) then addEnemyESP(char, plr) else removeEnemyESP(plr) end
            else
                removeEnemyESP(plr)
            end
        end
    end
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
            end
        end
    end

    for plr, drawings in pairs(professionalEspDrawings) do
        if not currentActive[plr] or not professionalEspEnabled then
            if drawings then
                if drawings.box then for _, l in ipairs(drawings.box) do l:Remove() end end
                if drawings.tracer then drawings.tracer:Remove() end
                if drawings.nameText then drawings.nameText:Remove() end
            end
            professionalEspDrawings[plr] = nil
        end
    end
end

local function addAllyESP(char, plr)
    if not char or not char.Parent or not plr then return end
    local hlName = plr.Name .. "_AllyESP"
    local existingHl = ProtectedGui:FindFirstChild(hlName)
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not root or not hum or hum.Health <= 0 then return end
    if existingHl then
        if existingHl.Adornee ~= char then existingHl.Adornee = char end
        return
    end
    pcall(function()
        local hl = Instance.new("Highlight")
        hl.Name = hlName
        hl.Adornee = char
        hl.FillColor = Color3.fromRGB(0, 0, 0)
        hl.OutlineColor = allyOutlineColor
        hl.FillTransparency = 0.9
        hl.OutlineTransparency = 0
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = ProtectedGui
    end)
end

local function removeAllyESP(plr)
    if not plr then return end
    pcall(function()
        local hl = ProtectedGui:FindFirstChild(plr.Name .. "_AllyESP")
        if hl then hl:Destroy() end
    end)
end

local function clearAllAllyESP()
    for _, p in ipairs(Players:GetPlayers()) do removeAllyESP(p) end
end

local function refreshAllyESP()
    if not allyEspEnabled then
        clearAllAllyESP()
        return
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local char = plr.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                if isAlly(plr) then addAllyESP(char, plr) else removeAllyESP(plr) end
            else
                removeAllyESP(plr)
            end
        end
    end
end

Players.PlayerRemoving:Connect(function(plr)
    removeEnemyESP(plr)
    removeAllyESP(plr)
    if professionalEspDrawings[plr] then
        if professionalEspDrawings[plr].box then
            for _, l in ipairs(professionalEspDrawings[plr].box) do l:Remove() end
        end
        if professionalEspDrawings[plr].tracer then professionalEspDrawings[plr].tracer:Remove() end
        if professionalEspDrawings[plr].nameText then professionalEspDrawings[plr].nameText:Remove() end
        professionalEspDrawings[plr] = nil
    end
    if originalSizes and originalSizes[plr] then
        spoofedSizes[originalSizes[plr].hrp] = nil
        spoofedCanCollide[originalSizes[plr].hrp] = nil
        originalSizes[plr] = nil
    end
end)

local visualsTab = Window:Tab({ Title = "ESP", Icon = "eye", ShowTabTitle = true, Border = true })

visualsTab:Divider()
visualsTab:Paragraph({ Title = "Shaders / Night Mode", Desc = "" })

local function applyShaders()
    for _, v in ipairs(Lighting:GetChildren()) do
        if v:IsA("Sky") or v:IsA("Atmosphere") or v:IsA("BloomEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("SunRaysEffect") then v:Destroy() end
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

local function shadersCallback(estado)
    if estado then
        applyShaders()
    else
        for _, v in ipairs(Lighting:GetChildren()) do
            if v:IsA("Sky") or v:IsA("Atmosphere") or v:IsA("BloomEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("SunRaysEffect") then v:Destroy() end
        end
        Lighting.ClockTime = 14
        Lighting.Brightness = 2
        Lighting.ExposureCompensation = 0
        Lighting.Ambient = Color3.fromRGB(128, 128, 128)
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    end
end

visualsTab:Toggle({ Title = "Night Mode Shaders", Desc = "Activa galaxia oscura, profunda y cristalina", Default = false, Callback = shadersCallback })

visualsTab:Divider()
visualsTab:Paragraph({ Title = "Enemy ESP", Desc = "" })

local espToggleRef = visualsTab:Toggle({
    Title = "ESP Active",
    Desc = "Ver jugadores enemigos con claridad",
    Default = false,
    Callback = function(espEnemyVal)
        espEnabled = espEnemyVal
        if not espEnabled then clearAllEnemyESP() end
    end
})

visualsTab:Keybind({
    Title = "ESP Keybind",
    Desc = "Activar o desactivar el ESP",
    Key = "V",
    Callback = function()
        espEnabled = not espEnabled
        if not espEnabled then clearAllEnemyESP() end
        pcall(function() espToggleRef:SetValue(espEnabled) end)
    end
})

local profEspToggleRef = visualsTab:Toggle({
    Title = "Professional ESP",
    Desc = "ESP Unificado (Caja 2D + Líneas / Tracers + Nombre de Usuario)",
    Default = false,
    Callback = function(val)
        professionalEspEnabled = val
        if not val then clearProfessionalESP() end
    end
})

visualsTab:Keybind({
    Title = "Professional ESP Keybind",
    Desc = "Activa o desactiva el ESP Profesional",
    Key = "B",
    Callback = function()
        professionalEspEnabled = not professionalEspEnabled
        if not professionalEspEnabled then clearProfessionalESP() end
        pcall(function() profEspToggleRef:SetValue(professionalEspEnabled) end)
    end
})

visualsTab:Colorpicker({
    Title = "Outline & Elements Color",
    Desc = "Color del contorno (Highlight), líneas, cuadros y nombre del ESP",
    Default = Color3.fromRGB(255, 30, 80),
    Callback = function(colorVal)
        enemyOutlineColor = colorVal
        for _, hl in ipairs(ProtectedGui:GetChildren()) do
            if hl:IsA("Highlight") and hl.Name:find("_EnemyESP") then hl.OutlineColor = colorVal end
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

visualsTab:Toggle({ Title = "Ally ESP", Desc = "Ver aliados claramente", Default = false, Callback = function(espAllyVal) allyEspEnabled = espAllyVal if not allyEspEnabled then clearAllAllyESP() end end })
visualsTab:Colorpicker({ Title = "Ally Outline Color", Desc = "Color del contorno del ESP de aliados", Default = Color3.fromRGB(0, 255, 128), Callback = function(colorVal)
    allyOutlineColor = colorVal
    for _, hl in ipairs(ProtectedGui:GetChildren()) do
        if hl:IsA("Highlight") and hl.Name:find("_AllyESP") then hl.OutlineColor = colorVal end
    end
end })

task.spawn(function()
    while task.wait(0.4) do
        if espEnabled then refreshEnemyESP() end
        if allyEspEnabled then refreshAllyESP() end
    end
end)

RunService.RenderStepped:Connect(function()
    if professionalEspEnabled then refreshProfessionalESP() end
end)

-- ==========================================
-- PLAYER CHEATS TAB
-- ==========================================
local playerSettings = { WalkSpeed = { Enabled = false, Value = 16 }, JumpPower = { Enabled = false, Value = 50 }, Noclip = false }

local playerTab = Window:Tab({ Title = "Player Cheats", Icon = "user", ShowTabTitle = true, Border = true })

playerTab:Divider()
playerTab:Paragraph({ Title = "WalkSpeed / JumpPower", Desc = "" })

playerTab:Toggle({ Title = "Enable WalkSpeed", Desc = "Modificar velocidad de movimiento", Default = false, Callback = function(state) playerSettings.WalkSpeed.Enabled = state end })
playerTab:Slider({ Title = "Speed", Step = 1, Value = {Min = 16, Max = 200, Default = 16}, Callback = function(val) playerSettings.WalkSpeed.Value = val end })

playerTab:Toggle({ Title = "Enable JumpPower", Desc = "Modificar potencia de salto", Default = false, Callback = function(state) playerSettings.JumpPower.Enabled = state end })
playerTab:Slider({ Title = "Jump Power", Step = 1, Value = {Min = 50, Max = 300, Default = 50}, Callback = function(val) playerSettings.JumpPower.Value = val end })

playerTab:Divider()
playerTab:Paragraph({ Title = "Special Movement", Desc = "" })

playerTab:Toggle({
    Title = "Noclip",
    Desc = "Atravesar paredes y objetos (Sin ser detectado)",
    Default = false,
    Callback = function(estado)
        playerSettings.Noclip = estado
        if not estado then
            pcall(function()
                if LocalPlayer.Character then
                    for _, part in ipairs(LocalPlayer.Character:GetChildren()) do
                        if part:IsA("BasePart") and spoofedCanCollide[part] ~= nil then
                            part.CanCollide = spoofedCanCollide[part]
                            spoofedCanCollide[part] = nil
                        end
                    end
                end
            end)
        end
    end
})

Window:Divider()

-- ==========================================
-- EXTERNAL SCRIPTS TAB
-- ==========================================
local externalScriptsTab = Window:Tab({ Title = "External Scripts", Icon = "terminal", ShowTabTitle = true, Border = true })

externalScriptsTab:Divider()
externalScriptsTab:Paragraph({ Title = "External Scripts", Desc = "" })

externalScriptsTab:Button({
    Title = "Emotes",
    Desc = "Ejecutar script de emotes universales",
    Callback = function()
        pcall(function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-AFEM-Max-Open-Alpha-50210"))() end)
    end
})

externalScriptsTab:Button({
    Title = "Copy Emotes Script",
    Desc = "Copia el loadstring completo del script de emotes al portapapeles",
    Callback = function()
        copyToClipboard('loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-AFEM-Max-Open-Alpha-50210"))()')
    end
})

externalScriptsTab:Divider()
externalScriptsTab:Paragraph({ Title = "Streamer Mode", Desc = "por Ryshub" })

externalScriptsTab:Button({
    Title = "Streamer Mode",
    Desc = "Ejecutar script en modo Streamer",
    Callback = function()
        pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Ryshub/scripts_public/main/streamer_mode_dmvss.lua"))() end)
    end
})

externalScriptsTab:Button({
    Title = "Copy Streamer Mode Script",
    Desc = "Copia el loadstring completo del script Streamer Mode al portapapeles",
    Callback = function()
        copyToClipboard('loadstring(game:HttpGet("https://raw.githubusercontent.com/Ryshub/scripts_public/main/streamer_mode_dmvss.lua"))()')
    end
})

-- ==========================================
-- EVENTS & CASES TAB
-- ==========================================
getgenv().Config = getgenv().Config or {}
getgenv().Config.autoCollect = false
getgenv().Config.autoBuyCrates = false
getgenv().Config.selectedCrate = "Caja de cuchillos n.° 1"

local eventBoxesTab = Window:Tab({ Title = "Events & Cases", Icon = "gift", ShowTabTitle = true, Border = true })

eventBoxesTab:Divider()
eventBoxesTab:Paragraph({ Title = "Atlantis Event", Desc = "" })

eventBoxesTab:Toggle({
    Title = "Atlantis Event",
    Desc = "Recolecta automáticamente tokens o monedas del evento de Atlantis",
    Default = false,
    Callback = function(val) getgenv().Config.autoCollect = val end
})

eventBoxesTab:Divider()
eventBoxesTab:Paragraph({ Title = "Auto Buy Cases", Desc = "" })

eventBoxesTab:Dropdown({
    Title = "Select Case",
    Desc = "Elige qué caja deseas comprar automáticamente",
    Values = {
        "Caja de cuchillos n.° 1",
        "Caja de cuchillos n.° 2",
        "Caja de armas n.° 1",
        "Caja de armas n.° 2",
        "Caja mítica n.º 1",
        "Caja mítica n.º 2",
        "Caja mítica n.º 3",
        "Caja mítica n.º 4"
    },
    Default = "Caja de cuchillos n.° 1",
    Callback = function(option) getgenv().Config.selectedCrate = option end
})

eventBoxesTab:Toggle({
    Title = "Auto Buy Cases",
    Desc = "Compra la caja seleccionada en bucle",
    Default = false,
    Callback = function(val) getgenv().Config.autoBuyCrates = val end
})

-- ==========================================
-- GLOBAL LOOPS & THREADS
-- ==========================================
task.spawn(function()
    while task.wait(0.8) do
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
    while task.wait(6) do
        if getgenv().Config and getgenv().Config.autoBuyCrates then
            pcall(function()
                local args = { [1] = getgenv().Config.selectedCrate }
                local buyRemote = ReplicatedStorage:FindFirstChild("Packages")
                    and ReplicatedStorage.Packages:FindFirstChild("Networking")
                    and ReplicatedStorage.Packages.Networking:FindFirstChild("RF/Shop/BuyCase")
                if buyRemote then buyRemote:InvokeServer(unpack(args)) end
            end)
        end
    end
end)

task.spawn(function()
    while true do
        pcall(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                local humanoid = LocalPlayer.Character.Humanoid
                if playerSettings.WalkSpeed.Enabled then humanoid.WalkSpeed = playerSettings.WalkSpeed.Value end
                if playerSettings.JumpPower.Enabled then humanoid.UseJumpPower = true humanoid.JumpPower = playerSettings.JumpPower.Value end
            end
        end)
        task.wait(0.2)
    end
end)

RunService.Stepped:Connect(function()
    pcall(function()
        if playerSettings.Noclip and LocalPlayer.Character then
            for _, part in ipairs(LocalPlayer.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    if spoofedCanCollide[part] == nil then spoofedCanCollide[part] = part.CanCollide end
                    part.CanCollide = false
                end
            end
        end
    end)
end)

RunService.RenderStepped:Connect(function()
    if freeMouseEnabled then
        pcall(function()
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
            UserInputService.MouseIconEnabled = true
        end)
    end
end)

