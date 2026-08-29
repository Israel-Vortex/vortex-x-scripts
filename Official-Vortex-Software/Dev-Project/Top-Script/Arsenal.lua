-- ==========================================
-- VORTEX X SOFTWARE - ARSENAL (MOBILE & PC FIXED)
-- ==========================================
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local PlayerService = game:GetService("Players")
local InputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local LightingService = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local CurrentCamera = workspace.CurrentCamera
local LocalPlayer = PlayerService.LocalPlayer
local UserSettings = UserSettings()

-- Safe mouse and clipboard wrappers for mobile executor compatibility
local function SafeMousePress()
    pcall(function()
        if mouse1press then mouse1press() end
    end)
end

local function SafeMouseRelease()
    pcall(function()
        if mouse1release then mouse1release() end
    end)
end

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
    Title = "Vortex x Software [ARSENAL]",
    Icon = "rbxassetid://134730158740955",
    IconSize = 35,
    Author = "by ISRAEL CC",
    Folder = "VortexXSoftwareArsenal",
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
    OnlyMobile = true,
    Enabled = true,
    Draggable = true
})

Window:Tag({ Title = "v3.3.44", Icon = "github", Color = Color3.fromRGB(230, 0, 50) })
Window:SetToggleKey(Enum.KeyCode.RightAlt)

local TabConfig = {
    Main = Window:Tab({ Title = "Combat", Icon = "swords" }),
    Gun = Window:Tab({ Title = "Weapon", Icon = "crosshair" }),
    Player = Window:Tab({ Title = "Movement", Icon = "user" }),
    Visuals = Window:Tab({ Title = "Visuals", Icon = "eye" }),
    World = Window:Tab({ Title = "World", Icon = "globe" }),
    Skins = Window:Tab({ Title = "Skins", Icon = "palette" }),
    Extra = Window:Tab({ Title = "Misc", Icon = "puzzle" }),
    Settings = Window:Tab({ Title = "System", Icon = "settings" })
}

local OptionsConfig = setmetatable({}, {
    __index = function(t, k)
        t[k] = { Value = false }
        return t[k]
    end
})

-- ==================== FLY ====================
local FlightSettings = { fly = false, flyspeed = 50 }
local CharacterModel, Humanoid, BodyVelocity, BodyAngularVelocity, Camera = nil, nil, nil, nil, nil
local IsFlying = false
local MovementKeys = { W = false, S = false, A = false, D = false, Space = false, LeftShift = false, Moving = false }

local function FlyFunction()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") and not IsFlying then
        CharacterModel = LocalPlayer.Character
        Humanoid = CharacterModel:FindFirstChildOfClass("Humanoid")
        if Humanoid then Humanoid.PlatformStand = true end
        Camera = Workspace:WaitForChild("Camera")
        BodyVelocity = Instance.new("BodyVelocity")
        BodyAngularVelocity = Instance.new("BodyAngularVelocity")
        BodyVelocity.P = 1000
        BodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
        BodyVelocity.Velocity = Vector3.zero
        BodyAngularVelocity.P = 1000
        BodyAngularVelocity.MaxTorque = Vector3.new(10000, 10000, 10000)
        BodyAngularVelocity.AngularVelocity = Vector3.zero
        BodyVelocity.Parent = CharacterModel.Head
        BodyAngularVelocity.Parent = CharacterModel.Head
        IsFlying = true
        if Humanoid then Humanoid.Died:Connect(function() IsFlying = false end) end
    end
end

local function StopFlyingFunction()
    if LocalPlayer.Character and IsFlying then
        if Humanoid then Humanoid.PlatformStand = false end
        if BodyVelocity then BodyVelocity:Destroy() end
        if BodyAngularVelocity then BodyAngularVelocity:Destroy() end
        IsFlying = false
    end
end

InputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    for k in pairs(MovementKeys) do
        if k ~= "Moving" and input.KeyCode == Enum.KeyCode[k] then
            MovementKeys[k] = true
            MovementKeys.Moving = true
        end
    end
end)

InputService.InputEnded:Connect(function(input, gpe)
    if gpe then return end
    local any = false
    for k in pairs(MovementKeys) do
        if k ~= "Moving" then
            if input.KeyCode == Enum.KeyCode[k] then MovementKeys[k] = false end
            if MovementKeys[k] then any = true end
        end
    end
    MovementKeys.Moving = any
end)

local function DirUnit(v)
    return v.Unit * FlightSettings.flyspeed
end

RunService.Heartbeat:Connect(function(dt)
    if IsFlying and CharacterModel and CharacterModel.PrimaryPart then
        local pos = CharacterModel.PrimaryPart.Position
        local cf = Camera.CFrame
        local x, y, z = cf:toEulerAnglesXYZ()
        CharacterModel:SetPrimaryPartCFrame(CFrame.new(pos.x, pos.y, pos.z) * CFrame.Angles(x, y, z))
        if MovementKeys.W or MovementKeys.S or MovementKeys.A or MovementKeys.D or MovementKeys.Space or MovementKeys.LeftShift then
            local move = Vector3.zero
            if MovementKeys.W then move = move + DirUnit(cf.lookVector) end
            if MovementKeys.S then move = move - DirUnit(cf.lookVector) end
            if MovementKeys.A then move = move - DirUnit(cf.rightVector) end
            if MovementKeys.D then move = move + DirUnit(cf.rightVector) end
            if MovementKeys.Space then move = move + Vector3.new(0, FlightSettings.flyspeed, 0) end
            if MovementKeys.LeftShift then move = move - Vector3.new(0, FlightSettings.flyspeed, 0) end
            CharacterModel:TranslateBy(move * dt)
        end
    end
end)

-- ==================== COMBAT / HITBOX ====================
TabConfig.Main:Section({ Title = "Hitbox" })

local HitboxEnabled = false
local HitboxSize = 21
local HitboxVisibility = 6
local HitboxTeamMode = "Team-Based"
local HitboxConnection = nil
local HitboxCache = {}
local PartNames = { "UpperTorso", "Head", "HumanoidRootPart" }

local function SavePart(plr, part)
    HitboxCache[plr] = HitboxCache[plr] or {}
    if not HitboxCache[plr][part.Name] then
        HitboxCache[plr][part.Name] = {
            CanCollide = part.CanCollide,
            Transparency = part.Transparency,
            Size = part.Size
        }
    end
end

local function RestorePlayer(plr)
    if not HitboxCache[plr] then return end
    local char = plr.Character
    if char then
        for name, data in pairs(HitboxCache[plr]) do
            local p = char:FindFirstChild(name)
            if p and p:IsA("BasePart") then
                p.CanCollide = data.CanCollide
                p.Transparency = data.Transparency
                p.Size = data.Size
            end
        end
    end
    HitboxCache[plr] = nil
end

local function FindPartByName(plr, name)
    if not plr.Character then return nil end
    for _, c in ipairs(plr.Character:GetChildren()) do
        if c:IsA("BasePart") and c.Name:lower():match(name:lower()) then
            return c
        end
    end
    return nil
end

local function IsEnemyHitbox(plr)
    if not (plr and plr.Team and LocalPlayer.Team) then return false end
    if HitboxTeamMode == "FFA" or HitboxTeamMode == "Everyone" then return true end
    return plr.Team ~= LocalPlayer.Team
end

local function ShouldExpand(plr)
    local hrp = plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    return hrp and IsEnemyHitbox(plr)
end

local function UpdateHitboxes()
    local alive = {}
    for _, plr in ipairs(PlayerService:GetPlayers()) do
        if plr ~= LocalPlayer then
            alive[plr] = true
            if ShouldExpand(plr) then
                for _, pname in ipairs(PartNames) do
                    local part = plr.Character:FindFirstChild(pname) or FindPartByName(plr, pname)
                    if part and part:IsA("BasePart") then
                        SavePart(plr, part)
                        part.CanCollide = false
                        part.Transparency = 1 - (HitboxVisibility / 10)
                        part.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
                    end
                end
            elseif HitboxCache[plr] then
                RestorePlayer(plr)
            end
        end
    end
    for plr in pairs(HitboxCache) do
        if not alive[plr] then RestorePlayer(plr) end
    end
end

PlayerService.PlayerRemoving:Connect(function(plr)
    if HitboxCache[plr] then HitboxCache[plr] = nil end
end)

TabConfig.Main:Toggle({
    Title = "Enable Hitbox Expander",
    Desc = "Enlarges enemy hitboxes.",
    Default = false,
    Callback = function(Value)
        OptionsConfig.HitboxToggle.Value = Value
        HitboxEnabled = Value
        WindUI:Notify({ Title = "Hitbox Expander", Content = "Status: " .. (HitboxEnabled and "Enabled" or "Disabled"), Duration = 3 })
        if HitboxEnabled then
            if not (HitboxConnection and HitboxConnection.Connected) then
                HitboxConnection = RunService.Heartbeat:Connect(UpdateHitboxes)
            end
        else
            if HitboxConnection then HitboxConnection:Disconnect(); HitboxConnection = nil end
            for plr in pairs(HitboxCache) do RestorePlayer(plr) end
        end
    end
})

TabConfig.Main:Slider({
    Title = "Hitbox Size",
    Desc = "How large the enemy hitboxes will be.",
    Step = 1,
    Value = { Min = 1, Max = 30, Default = 21 },
    Callback = function(v)
        OptionsConfig.HitboxSizeSlider.Value = v
        HitboxSize = v
    end
})

TabConfig.Main:Slider({
    Title = "Hitbox Visibility",
    Desc = "0 fully invisible, 10 fully visible.",
    Step = 0.1,
    Value = { Min = 0, Max = 10, Default = 6 },
    Callback = function(v)
        OptionsConfig.HitboxTransSlider.Value = v
        HitboxVisibility = v
    end
})

TabConfig.Main:Dropdown({
    Title = "Team Check",
    Desc = "Choose who the features will target.",
    Values = { "FFA", "Team-Based", "Everyone" },
    Value = "Team-Based",
    Callback = function(v)
        OptionsConfig.HitboxTeamDropdown.Value = v
        HitboxTeamMode = v
    end
})

-- ==================== LOCK ON ====================
TabConfig.Main:Section({ Title = "Lock On" })

local LockOnEnabled = false
local LockOnTarget = nil
local LockOnConn = nil
local LockOnDistance = 200
local LockOnSmooth = 0.2
local LockOnTeamMode = "Team-Based"

local function IsLockEnemy(plr)
    if not (plr and plr ~= LocalPlayer and plr.Team and LocalPlayer.Team) then return false end
    if LockOnTeamMode == "Everyone" then return true end
    return plr.Team ~= LocalPlayer.Team
end

local function FindLockTarget()
    local char = LocalPlayer.Character
    if not (char and char:FindFirstChild("Head")) then return nil end
    local origin = char.Head.Position
    local best, bestDist = nil, math.huge
    for _, plr in ipairs(PlayerService:GetPlayers()) do
        if IsLockEnemy(plr) and plr.Character and plr.Character:FindFirstChild("Head") and not plr.Character:FindFirstChild("ForceField") then
            local head = plr.Character.Head
            local dist = (head.Position - origin).Magnitude
            if dist < bestDist and dist <= LockOnDistance then
                local params = RaycastParams.new()
                params.FilterType = Enum.RaycastFilterType.Blacklist
                params.FilterDescendantsInstances = { char }
                local res = Workspace:Raycast(origin, (head.Position - origin).Unit * LockOnDistance, params)
                if res and res.Instance and res.Instance:IsDescendantOf(plr.Character) then
                    best = plr
                    bestDist = dist
                end
            end
        end
    end
    return best
end

local function UpdateLockOn()
    if not (LockOnTarget and LockOnTarget.Character and LockOnTarget.Character:FindFirstChild("Head")) then
        LockOnTarget = FindLockTarget()
    end
    if LockOnTarget and LockOnTarget.Character and LockOnTarget.Character:FindFirstChild("Head") then
        local head = LockOnTarget.Character.Head
        local char = LocalPlayer.Character
        if not (char and char:FindFirstChild("Head")) then return end
        local origin = char.Head.Position
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Blacklist
        params.FilterDescendantsInstances = { char }
        local res = Workspace:Raycast(origin, (head.Position - origin).Unit * LockOnDistance, params)
        if res and res.Instance and res.Instance:IsDescendantOf(LockOnTarget.Character) then
            if OptionsConfig.SmoothLockOnToggle.Value then
                local goal = CFrame.new(CurrentCamera.CFrame.Position, head.Position)
                CurrentCamera.CFrame = CurrentCamera.CFrame:Lerp(goal, LockOnSmooth)
            else
                CurrentCamera.CFrame = CFrame.new(CurrentCamera.CFrame.Position, head.Position)
            end
        else
            LockOnTarget = nil
        end
    else
        LockOnTarget = nil
    end
end

TabConfig.Main:Toggle({
    Title = "Enable Lock On",
    Desc = "Automatically aims the camera at a visible target's head.",
    Default = false,
    Callback = function(v)
        OptionsConfig.LockOnToggle.Value = v
        LockOnEnabled = v
        if LockOnEnabled then
            if not LockOnConn then LockOnConn = RunService.RenderStepped:Connect(UpdateLockOn) end
        else
            if LockOnConn then LockOnConn:Disconnect(); LockOnConn = nil end
            LockOnTarget = nil
        end
    end
})

TabConfig.Main:Dropdown({
    Title = "Lock On Target",
    Desc = "Choose who the Lock On will target.",
    Values = { "Enemies", "Everyone" },
    Value = "Enemies",
    Callback = function(v)
        OptionsConfig.LockOnTargetDropdown.Value = v
        LockOnTeamMode = (v == "Everyone") and "Everyone" or "Team-Based"
        LockOnTarget = nil
    end
})

TabConfig.Main:Toggle({
    Title = "Enable Smooth Lock On",
    Desc = "Smoothly aims the camera instead of instantly snapping.",
    Default = false,
    Callback = function(v)
        OptionsConfig.SmoothLockOnToggle.Value = v
    end
})

TabConfig.Main:Slider({
    Title = "Lock On Smoothness",
    Desc = "Controls the smoothing speed. Lower is slower.",
    Step = 1,
    Value = { Min = 1, Max = 50, Default = 20 },
    Callback = function(v)
        OptionsConfig.SmoothnessSlider.Value = v
        LockOnSmooth = v / 100
    end
})

-- ==================== TRIGGERBOT ====================
TabConfig.Main:Section({ Title = "Triggerbot" })

getgenv().triggerb = false
local TriggerTeamMode = "Team-Based"
local PlayerAlive = true
local TriggerHolding = false
local TriggerRayParams = RaycastParams.new()
TriggerRayParams.FilterType = Enum.RaycastFilterType.Blacklist

TabConfig.Main:Toggle({
    Title = "Enable Triggerbot",
    Desc = "Automatically shoots when your crosshair is over an enemy.",
    Default = false,
    Callback = function(v)
        OptionsConfig.TriggerBotToggle.Value = v
        getgenv().triggerb = v
        WindUI:Notify({ Title = "Triggerbot", Content = "Status: " .. (v and "Enabled" or "Disabled"), Duration = 3 })
        if not v and TriggerHolding then
            TriggerHolding = false
            SafeMouseRelease()
        end
    end
})

TabConfig.Main:Dropdown({
    Title = "Triggerbot Team Mode",
    Desc = "Determines who the triggerbot will fire at.",
    Values = { "FFA", "Team-Based", "Everyone" },
    Value = "Team-Based",
    Callback = function(v)
        OptionsConfig.TriggerTeamDropdown.Value = v
        TriggerTeamMode = v
    end
})

local function TriggerIsTarget(plr)
    if not (plr and plr.Team and LocalPlayer.Team) then return false end
    if TriggerTeamMode == "FFA" then return true end
    if TriggerTeamMode == "Everyone" then return plr ~= LocalPlayer end
    return plr.Team ~= LocalPlayer.Team
end

local function SetupAliveWatch()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        PlayerAlive = hum.Health > 0
        hum.HealthChanged:Connect(function(h)
            PlayerAlive = h > 0
            if not PlayerAlive and TriggerHolding then
                TriggerHolding = false
                SafeMouseRelease()
            end
        end)
    end
end
LocalPlayer.CharacterAdded:Connect(SetupAliveWatch)
SetupAliveWatch()

RunService.RenderStepped:Connect(function()
    if getgenv().triggerb and PlayerAlive then
        local char = LocalPlayer.Character
        if not char then return end
        TriggerRayParams.FilterDescendantsInstances = { char }
        local center = CurrentCamera.ViewportSize / 2
        local ray = CurrentCamera:ViewportPointToRay(center.X, center.Y)
        local hit = Workspace:Raycast(ray.Origin, ray.Direction * 5000, TriggerRayParams)
        local shouldShoot = false
        if hit and hit.Instance then
            local model = hit.Instance:FindFirstAncestorOfClass("Model")
            if model and model:FindFirstChild("Humanoid") then
                local plr = PlayerService:GetPlayerFromCharacter(model)
                if plr and TriggerIsTarget(plr) and not model:FindFirstChild("ForceField") then
                    shouldShoot = true
                end
            end
        end
        if shouldShoot then
            if not TriggerHolding then TriggerHolding = true; SafeMousePress() end
        elseif TriggerHolding then
            TriggerHolding = false
            SafeMouseRelease()
        end
    elseif TriggerHolding then
        TriggerHolding = false
        SafeMouseRelease()
    end
end)

-- ==================== RAGEBOT ====================
TabConfig.Main:Section({ Title = "Ragebot" })

TabConfig.Main:Toggle({
    Title = "Enable Ragebot / Autofarm",
    Desc = "WARNING: Very blatant. Automatically finds and kills enemies.",
    Default = false,
    Callback = function(Param10)
        OptionsConfig.AutoFarmToggle.Value = Param10
        getgenv().AutoFarm = Param10
        WindUI:Notify({
            Title = "Ragebot",
            Content = "Status: " .. (Param10 and "Enabled" or "Disabled"),
            Duration = 3
        })
        local rageConn = nil
        local holding = false
        pcall(function()
            if ReplicatedStorage:FindFirstChild("wkspc") and ReplicatedStorage.wkspc:FindFirstChild("CurrentCurse") then
                ReplicatedStorage.wkspc.CurrentCurse.Value = Param10 and "Infinite Ammo" or ""
            end
        end)

        local function ValidRage(plr)
            if not plr or plr == LocalPlayer then return false end
            if not plr:IsA("Player") or not PlayerService:FindFirstChild(plr.Name) then return false end
            if not (plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and not plr.Character:FindFirstChild("ForceField")) then return false end
            if not (plr:FindFirstChild("Status") and plr.Status.Alive.Value) then return false end
            if not (plr.Team and LocalPlayer.Team) then return false end
            if plr.Team == LocalPlayer.Team then return false end
            return plr.Team.Name ~= "Spectator"
        end

        local function NearestEnemy()
            local best, bestD = nil, math.huge
            for _, plr in pairs(PlayerService:GetPlayers()) do
                if ValidRage(plr) then
                    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local d = (hrp.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                        if d < bestD then best, bestD = plr, d end
                    end
                end
            end
            return best
        end

        if Param10 then
            task.wait(0.5)
            pcall(function()
                if ReplicatedStorage:FindFirstChild("wkspc") and ReplicatedStorage.wkspc:FindFirstChild("TimeScale") then
                    ReplicatedStorage.wkspc.TimeScale.Value = 12
                end
            end)
            rageConn = RunService.Stepped:Connect(function()
                if not getgenv().AutoFarm then
                    if rageConn then rageConn:Disconnect() end
                    if holding then SafeMouseRelease(); holding = false end
                    return
                end
                pcall(function()
                    if ReplicatedStorage.wkspc.Status.RoundOver.Value == true then
                        if holding then SafeMouseRelease(); holding = false end
                        return
                    end
                end)
                if not (LocalPlayer:FindFirstChild("Status") and LocalPlayer.Status.Alive.Value) then
                    if holding then SafeMouseRelease(); holding = false end
                    return
                end
                local t = NearestEnemy()
                if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = t.Character.HumanoidRootPart
                    local pos = hrp.Position - hrp.CFrame.LookVector * 2 + Vector3.new(0, 2, 0)
                    local localHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if localHrp then localHrp.CFrame = CFrame.new(pos) end
                    if t.Character:FindFirstChild("Head") then
                        CurrentCamera.CFrame = CFrame.new(CurrentCamera.CFrame.Position, t.Character.Head.Position)
                    end
                    if not holding then SafeMousePress(); holding = true end
                elseif holding then
                    SafeMouseRelease(); holding = false
                end
            end)
        else
            pcall(function()
                if ReplicatedStorage:FindFirstChild("wkspc") then
                    if ReplicatedStorage.wkspc:FindFirstChild("CurrentCurse") then ReplicatedStorage.wkspc.CurrentCurse.Value = "" end
                    if ReplicatedStorage.wkspc:FindFirstChild("TimeScale") then ReplicatedStorage.wkspc.TimeScale.Value = 1 end
                end
            end)
            getgenv().AutoFarm = false
            if holding then SafeMouseRelease() end
        end
    end
})

-- ==================== WEAPON ====================
TabConfig.Gun:Paragraph({ Title = "Gun Mods", Content = "Modify your weapon's performance." })

local WeaponConfig = { FireRate = {}, ReloadTime = {}, EReloadTime = {}, Auto = {}, Spread = {}, Recoil = {} }

TabConfig.Gun:Section({ Title = "Ammunition" })

TabConfig.Gun:Toggle({
    Title = "Infinite Ammo (Curse)",
    Desc = "Uses the game's curse system for infinite ammo.",
    Default = false,
    Callback = function(Value)
        OptionsConfig.InfAmmoV1Toggle.Value = Value
        pcall(function()
            if ReplicatedStorage:FindFirstChild("wkspc") and ReplicatedStorage.wkspc:FindFirstChild("CurrentCurse") then
                ReplicatedStorage.wkspc.CurrentCurse.Value = Value and "Infinite Ammo" or ""
            end
        end)
    end
})

local InfAmmoOverride = false
TabConfig.Gun:Toggle({
    Title = "Infinite Ammo (Override)",
    Desc = "Forces your ammo count to stay full.",
    Default = false,
    Callback = function(Value)
        OptionsConfig.InfAmmoV2Toggle.Value = Value
        InfAmmoOverride = Value
        if InfAmmoOverride then
            RunService.Stepped:Connect(function()
                pcall(function()
                    if InfAmmoOverride and OptionsConfig.InfAmmoV2Toggle.Value then
                        local pg = LocalPlayer:FindFirstChild("PlayerGui")
                        if pg and pg:FindFirstChild("GUI") then
                            local vars = pg.GUI.Client:FindFirstChild("Variables")
                            if vars and vars:FindFirstChild("ammocount") then
                                vars.ammocount.Value = 99
                                vars.ammocount2.Value = 99
                            end
                        end
                    end
                end)
            end)
        end
    end
})

TabConfig.Gun:Section({ Title = "Firing Mechanics" })

TabConfig.Gun:Toggle({
    Title = "Instant Reload",
    Desc = "Removes reload times.",
    Default = false,
    Callback = function(Value)
        OptionsConfig.FastReloadToggle.Value = Value
        pcall(function()
            local weapons = ReplicatedStorage:FindFirstChild("Weapons")
            if weapons then
                for _, w in pairs(weapons:GetChildren()) do
                    if w:FindFirstChild("ReloadTime") then
                        if Value then
                            if not WeaponConfig.ReloadTime[w] then WeaponConfig.ReloadTime[w] = w.ReloadTime.Value end
                            w.ReloadTime.Value = 0.01
                        elseif WeaponConfig.ReloadTime[w] then
                            w.ReloadTime.Value = WeaponConfig.ReloadTime[w]
                        end
                    end
                    if w:FindFirstChild("EReloadTime") then
                        if Value then
                            if not WeaponConfig.EReloadTime[w] then WeaponConfig.EReloadTime[w] = w.EReloadTime.Value end
                            w.EReloadTime.Value = 0.01
                        elseif WeaponConfig.EReloadTime[w] then
                            w.EReloadTime.Value = WeaponConfig.EReloadTime[w]
                        end
                    end
                end
            end
        end)
    end
})

TabConfig.Gun:Toggle({
    Title = "Rapid Fire",
    Desc = "Increases the fire rate of all weapons.",
    Default = false,
    Callback = function(Value)
        OptionsConfig.FastFireToggle.Value = Value
        pcall(function()
            local weapons = ReplicatedStorage:FindFirstChild("Weapons")
            if weapons then
                for _, v in pairs(weapons:GetDescendants()) do
                    if v.Name == "FireRate" or v.Name == "BFireRate" then
                        if Value then
                            if not WeaponConfig.FireRate[v] then WeaponConfig.FireRate[v] = v.Value end
                            v.Value = 0.02
                        elseif WeaponConfig.FireRate[v] then
                            v.Value = WeaponConfig.FireRate[v]
                        end
                    end
                end
            end
        end)
    end
})

TabConfig.Gun:Toggle({
    Title = "Force Auto",
    Desc = "Makes all weapons fully automatic.",
    Default = false,
    Callback = function(Value)
        OptionsConfig.AlwaysAutoToggle.Value = Value
        pcall(function()
            local weapons = ReplicatedStorage:FindFirstChild("Weapons")
            if weapons then
                for _, v in pairs(weapons:GetDescendants()) do
                    if v.Name == "Auto" or v.Name == "AutoFire" or v.Name == "Automatic" or v.Name == "AutoShoot" or v.Name == "AutoGun" then
                        if Value then
                            if not WeaponConfig.Auto[v] then WeaponConfig.Auto[v] = v.Value end
                            v.Value = true
                        elseif WeaponConfig.Auto[v] then
                            v.Value = WeaponConfig.Auto[v]
                        end
                    end
                end
            end
        end)
    end
})

TabConfig.Gun:Section({ Title = "Weapon Stability" })

TabConfig.Gun:Toggle({
    Title = "No Spread",
    Desc = "Removes all weapon spread.",
    Default = false,
    Callback = function(Value)
        OptionsConfig.NoSpreadToggle.Value = Value
        pcall(function()
            local weapons = ReplicatedStorage:FindFirstChild("Weapons")
            if weapons then
                for _, v in pairs(weapons:GetDescendants()) do
                    if v.Name == "MaxSpread" or v.Name == "Spread" or v.Name == "SpreadControl" then
                        if Value then
                            if not WeaponConfig.Spread[v] then WeaponConfig.Spread[v] = v.Value end
                            v.Value = 0
                        elseif WeaponConfig.Spread[v] then
                            v.Value = WeaponConfig.Spread[v]
                        end
                    end
                end
            end
        end)
    end
})

TabConfig.Gun:Toggle({
    Title = "No Recoil",
    Desc = "Removes all weapon recoil.",
    Default = false,
    Callback = function(Value)
        OptionsConfig.NoRecoilToggle.Value = Value
        pcall(function()
            local weapons = ReplicatedStorage:FindFirstChild("Weapons")
            if weapons then
                for _, v in pairs(weapons:GetDescendants()) do
                    if v.Name == "RecoilControl" or v.Name == "Recoil" then
                        if Value then
                            if not WeaponConfig.Recoil[v] then WeaponConfig.Recoil[v] = v.Value end
                            v.Value = 0
                        elseif WeaponConfig.Recoil[v] then
                            v.Value = WeaponConfig.Recoil[v]
                        end
                    end
                end
            end
        end)
    end
})

-- ==================== MOVEMENT ====================
TabConfig.Player:Section({ Title = "Fly Hacks" })

TabConfig.Player:Toggle({
    Title = "Enable Fly",
    Desc = "Allows you to fly around the map.",
    Default = false,
    Callback = function(Value)
        OptionsConfig.FlyToggle.Value = Value
        if Value then FlyFunction() else StopFlyingFunction() end
        WindUI:Notify({ Title = "Fly", Content = "Status: " .. (Value and "Enabled" or "Disabled"), Duration = 3 })
    end
})

TabConfig.Player:Slider({
    Title = "Fly Speed",
    Desc = "Controls how fast you move while flying.",
    Step = 1,
    Value = { Min = 1, Max = 500, Default = 50 },
    Callback = function(v)
        OptionsConfig.FlySpeedSlider.Value = v
        FlightSettings.flyspeed = v
    end
})

TabConfig.Player:Section({ Title = "Speed Hacks" })

local WalkSpeedConfig = { WalkSpeed = 16 }
local SpeedEnabled = false
local SpeedMethod = "Velocity"

TabConfig.Player:Toggle({
    Title = "Enable Speed",
    Desc = "Allows for custom walk speed.",
    Default = false,
    Callback = function(Value)
        OptionsConfig.CustomWalkSpeedToggle.Value = Value
        SpeedEnabled = Value
    end
})

TabConfig.Player:Dropdown({
    Title = "Speed Method",
    Desc = "The physics method used to apply speed.",
    Values = { "Velocity", "Vector", "CFrame" },
    Value = "Velocity",
    Callback = function(v)
        OptionsConfig.WalkMethodDropdown.Value = v
        SpeedMethod = v
    end
})

TabConfig.Player:Slider({
    Title = "Walk Speed",
    Desc = "Sets the desired walk speed.",
    Step = 1,
    Value = { Min = 16, Max = 500, Default = 16 },
    Callback = function(v)
        OptionsConfig.WalkSpeedSlider.Value = v
        WalkSpeedConfig.WalkSpeed = v
    end
})

RunService.Stepped:Connect(function(dt)
    if not (SpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) then return end
    local char = LocalPlayer.Character
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not (hum and hrp) then return end
    local move = hum.MoveDirection * WalkSpeedConfig.WalkSpeed
    if SpeedMethod == "Velocity" then
        hrp.Velocity = Vector3.new(move.X, hrp.Velocity.Y, move.Z)
    elseif SpeedMethod == "Vector" then
        hrp.CFrame = hrp.CFrame + move * dt * 0.0001
    elseif SpeedMethod == "CFrame" then
        hrp.CFrame = hrp.CFrame + hum.MoveDirection * WalkSpeedConfig.WalkSpeed * dt * 0.0001
    else
        hum.WalkSpeed = WalkSpeedConfig.WalkSpeed
    end
end)

TabConfig.Player:Section({ Title = "Jump Hacks" })

local InfJumpEnabled = false
TabConfig.Player:Toggle({
    Title = "Enable Infinite Jump",
    Desc = "Allows you to jump in mid-air.",
    Default = false,
    Callback = function(Value)
        OptionsConfig.InfJumpToggle.Value = Value
        InfJumpEnabled = Value
        if InfJumpEnabled then
            InputService.JumpRequest:Connect(function()
                if InfJumpEnabled and OptionsConfig.InfJumpToggle.Value then
                    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if hum then hum:ChangeState("Jumping") end
                end
            end)
        end
    end
})

TabConfig.Player:Section({ Title = "Misc Movement" })

local SpinSpeed = 10
local AntiAimGyro = nil

TabConfig.Player:Toggle({
    Title = "Enable Anti-Aim",
    Desc = "Spins you to make you harder to hit.",
    Default = false,
    Callback = function(Value)
        OptionsConfig.AntiAimToggle.Value = Value
        WindUI:Notify({ Title = "Anti-Aim", Content = "Status: " .. (Value and "Enabled" or "Disabled"), Duration = 3 })
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if Value then
            if hrp then
                local spin = Instance.new("BodyAngularVelocity")
                spin.Name = "AntiAimSpin"
                spin.AngularVelocity = Vector3.new(0, SpinSpeed, 0)
                spin.MaxTorque = Vector3.new(0, math.huge, 0)
                spin.P = 500000
                spin.Parent = hrp
                AntiAimGyro = Instance.new("BodyGyro")
                AntiAimGyro.Name = "AntiAimGyro"
                AntiAimGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                AntiAimGyro.CFrame = hrp.CFrame
                AntiAimGyro.P = 3000
                AntiAimGyro.Parent = hrp
            end
        elseif hrp then
            local s = hrp:FindFirstChild("AntiAimSpin")
            if s then s:Destroy() end
            if AntiAimGyro then AntiAimGyro:Destroy(); AntiAimGyro = nil end
        end
    end
})

TabConfig.Player:Slider({
    Title = "Spin Speed",
    Desc = "Adjusts the rotation speed.",
    Step = 1,
    Value = { Min = 10, Max = 100, Default = 10 },
    Callback = function(v)
        OptionsConfig.SpinSpeedSlider.Value = v
        SpinSpeed = v
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local spin = hrp and hrp:FindFirstChild("AntiAimSpin")
        if spin then spin.AngularVelocity = Vector3.new(0, SpinSpeed, 0) end
    end
})

local NoClipEnabled = false
local function NoClipLoop()
    while NoClipEnabled and OptionsConfig.NoClipToggle.Value do
        local char = LocalPlayer.Character
        if char then
            for _, p in pairs(char:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end
        RunService.Stepped:Wait()
    end
    local char = LocalPlayer.Character
    if char then
        for _, p in pairs(char:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = true end
        end
    end
end

TabConfig.Player:Toggle({
    Title = "Enable NoClip",
    Desc = "Lets you walk through walls.",
    Default = false,
    Callback = function(Value)
        OptionsConfig.NoClipToggle.Value = Value
        NoClipEnabled = Value
        if NoClipEnabled then task.spawn(NoClipLoop) end
        WindUI:Notify({ Title = "NoClip", Content = "Status: " .. (NoClipEnabled and "Enabled" or "Disabled"), Duration = 3 })
    end
})

LocalPlayer.CharacterAdded:Connect(function(char)
    if NoClipEnabled and OptionsConfig.NoClipToggle.Value then
        task.spawn(function()
            while NoClipEnabled and OptionsConfig.NoClipToggle.Value and char.Parent do
                for _, p in pairs(char:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end
                RunService.Stepped:Wait()
            end
        end)
    end
end)

TabConfig.Player:Section({ Title = "Item Teleport" })

local PickupFilter = "Both"
local PickupEnabled = false

local function managePickups()
    task.spawn(function()
        while PickupEnabled and OptionsConfig.CollectDebrisToggle.Value do
            task.wait(0.1)
            pcall(function()
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                local debris = Workspace:FindFirstChild("Debris")
                if debris then
                    for _, item in pairs(debris:GetChildren()) do
                        local ok = (PickupFilter == "DeadHP" and item.Name == "DeadHP")
                            or (PickupFilter == "DeadAmmo" and item.Name == "DeadAmmo")
                            or (PickupFilter == "Both" and (item.Name == "DeadHP" or item.Name == "DeadAmmo"))
                        if ok and item:IsA("BasePart") then
                            item.CFrame = hrp.CFrame * CFrame.new(0, 0.2, 0)
                        end
                    end
                end
            end)
        end
    end)
end

TabConfig.Player:Toggle({
    Title = "Enable Pickup TP",
    Desc = "Teleports items to you.",
    Default = false,
    Callback = function(Value)
        OptionsConfig.CollectDebrisToggle.Value = Value
        PickupEnabled = Value
        if PickupEnabled then managePickups() end
    end
})

TabConfig.Player:Dropdown({
    Title = "Pickup Filter",
    Desc = "Choose which items to teleport.",
    Values = { "Health", "Ammo", "Both" },
    Value = "Both",
    Callback = function(v)
        OptionsConfig.DebrisDropdown.Value = v
        PickupFilter = ({ Health = "DeadHP", Ammo = "DeadAmmo", Both = "Both" })[v] or "Both"
    end
})

-- ==================== VISUALS ====================
TabConfig.Visuals:Paragraph({ Title = "Player Charms", Content = "Makes players visible through walls." })

local CharmsConfigTable = {
    Enabled = false,
    TeamCheck = "Enemies",
    InnerColor = Color3.fromRGB(0, 150, 255),
    OutlineColor = Color3.fromRGB(0, 0, 0),
    InnerTransparency = 0.6,
    OutlineTransparency = 0.2
}
local PlayerGuiInstance = LocalPlayer:WaitForChild("PlayerGui")
local CharmsTable = {}
local CharmsConn = nil

local function ClearCharms(plr)
    if not CharmsTable[plr] then return end
    for _, data in pairs(CharmsTable[plr]) do
        if data.fill then data.fill:Destroy() end
        if data.outline then data.outline:Destroy() end
    end
    CharmsTable[plr] = nil
end

local function CreateCharms(plr)
    if not (plr and plr.Character) or CharmsTable[plr] then return end
    CharmsTable[plr] = {}
    for _, part in pairs(plr.Character:GetChildren()) do
        if part:IsA("BasePart") then
            local fill = Instance.new("BoxHandleAdornment")
            fill.Parent = PlayerGuiInstance
            fill.Transparency = CharmsConfigTable.InnerTransparency
            fill.Color3 = CharmsConfigTable.InnerColor
            fill.Size = part.Size
            fill.ZIndex = 5
            fill.AlwaysOnTop = true
            fill.Adornee = part
            local outline = Instance.new("BoxHandleAdornment")
            outline.Parent = PlayerGuiInstance
            outline.Transparency = CharmsConfigTable.OutlineTransparency
            outline.Color3 = CharmsConfigTable.OutlineColor
            outline.Size = part.Size + Vector3.new(0.1, 0.1, 0.1)
            outline.ZIndex = 4
            outline.AlwaysOnTop = true
            outline.Adornee = part
            CharmsTable[plr][part] = { fill = fill, outline = outline }
        end
    end
end

local function RefreshCharms(plr)
    if CharmsTable[plr] and plr.Character then
        for part, data in pairs(CharmsTable[plr]) do
            if part and part.Parent == plr.Character then
                data.fill.Size = part.Size
                data.fill.Transparency = CharmsConfigTable.InnerTransparency
                data.fill.Color3 = CharmsConfigTable.InnerColor
                data.outline.Size = part.Size + Vector3.new(0.1, 0.1, 0.1)
                data.outline.Transparency = CharmsConfigTable.OutlineTransparency
                data.outline.Color3 = CharmsConfigTable.OutlineColor
            else
                data.fill:Destroy()
                data.outline:Destroy()
                CharmsTable[plr][part] = nil
            end
        end
    else
        ClearCharms(plr)
    end
end

local function UpdateAllCharms()
    if not CharmsConfigTable.Enabled then return end
    for plr in pairs(CharmsTable) do
        if not (plr and plr.Parent and plr.Character) then ClearCharms(plr) end
    end
    for _, plr in pairs(PlayerService:GetPlayers()) do
        if plr ~= LocalPlayer then
            local show = false
            if CharmsConfigTable.TeamCheck == "Everyone" then
                show = true
            elseif CharmsConfigTable.TeamCheck == "Allies" then
                show = LocalPlayer.Team == plr.Team
            elseif CharmsConfigTable.TeamCheck == "Enemies" then
                show = LocalPlayer.Team ~= plr.Team
            end
            if show then
                if CharmsTable[plr] then RefreshCharms(plr) else CreateCharms(plr) end
            else
                ClearCharms(plr)
            end
        end
    end
end

TabConfig.Visuals:Toggle({
    Title = "Enable Charms",
    Default = false,
    Callback = function(v)
        OptionsConfig.CharmsToggle.Value = v
        CharmsConfigTable.Enabled = v
        if v then
            CharmsConn = RunService.Heartbeat:Connect(UpdateAllCharms)
        else
            if CharmsConn then CharmsConn:Disconnect(); CharmsConn = nil end
            for plr in pairs(CharmsTable) do ClearCharms(plr) end
            CharmsTable = {}
        end
    end
})

TabConfig.Visuals:Dropdown({
    Title = "Team Check",
    Values = { "Enemies", "Allies", "Everyone" },
    Value = "Enemies",
    Callback = function(v)
        OptionsConfig.CharmsTeamDropdown.Value = v
        CharmsConfigTable.TeamCheck = v
    end
})

TabConfig.Visuals:Colorpicker({
    Title = "Inner Color",
    Default = CharmsConfigTable.InnerColor,
    Callback = function(v)
        OptionsConfig.CharmsInnerColor.Value = v
        CharmsConfigTable.InnerColor = v
    end
})

TabConfig.Visuals:Colorpicker({
    Title = "Outline Color",
    Default = CharmsConfigTable.OutlineColor,
    Callback = function(v)
        OptionsConfig.CharmsOutlineColor.Value = v
        CharmsConfigTable.OutlineColor = v
    end
})

TabConfig.Visuals:Slider({
    Title = "Inner Transparency",
    Step = 0.01,
    Value = { Min = 0, Max = 1, Default = 0.6 },
    Callback = function(v)
        OptionsConfig.CharmsInnerTransparency.Value = v
        CharmsConfigTable.InnerTransparency = v
    end
})

TabConfig.Visuals:Slider({
    Title = "Outline Transparency",
    Step = 0.01,
    Value = { Min = 0, Max = 1, Default = 0.2 },
    Callback = function(v)
        OptionsConfig.CharmsOutlineTransparency.Value = v
        CharmsConfigTable.OutlineTransparency = v
    end
})

PlayerService.PlayerRemoving:Connect(ClearCharms)
PlayerService.PlayerAdded:Connect(function(plr)
    plr.CharacterRemoving:Connect(function() ClearCharms(plr) end)
end)

TabConfig.Visuals:Section({ Title = "World ESP" })

local WorldEspConfig = {}
local EspTag = "dontask"

local function MakeEspBillboard(parent, text)
    local gui = Instance.new("BillboardGui")
    local label = Instance.new("TextLabel")
    gui.Name = EspTag
    gui.Parent = parent
    gui.AlwaysOnTop = true
    gui.Size = UDim2.new(0, 50, 0, 50)
    gui.StudsOffset = Vector3.new(0, 2, 0)
    label.Parent = gui
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Text = text
    label.TextColor3 = Color3.new(1, 0, 0)
    label.TextScaled = false
    return gui
end

local function AttachEsp(obj, text)
    if obj:IsA("TouchTransmitter") then
        local parent = obj.Parent
        if parent and not parent:FindFirstChild(EspTag) then
            WorldEspConfig[parent] = MakeEspBillboard(parent, text)
        end
    end
end

local function ToggleWorldEsp(enabled, partName, label, flagName)
    if enabled then
        for _, d in ipairs(Workspace:GetDescendants()) do
            if d:IsA("TouchTransmitter") and d.Parent and d.Parent.Name == partName then
                AttachEsp(d, label)
            end
        end
        Workspace.DescendantAdded:Connect(function(obj)
            if OptionsConfig[flagName].Value and obj:IsA("TouchTransmitter") and obj.Parent and obj.Parent.Name == partName then
                AttachEsp(obj, label)
            end
        end)
    else
        for parent, gui in pairs(WorldEspConfig) do
            if gui and gui:FindFirstChild("TextLabel") and gui.TextLabel.Text == label then
                gui:Destroy()
                WorldEspConfig[parent] = nil
            end
        end
    end
end

TabConfig.Visuals:Toggle({
    Title = "Ammo ESP",
    Desc = "Shows the location of ammo pickups.",
    Default = false,
    Callback = function(Value)
        OptionsConfig.DeadAmmoESPToggle.Value = Value
        ToggleWorldEsp(Value, "DeadAmmo", "Ammo Box", "DeadAmmoESPToggle")
    end
})

TabConfig.Visuals:Toggle({
    Title = "Health ESP",
    Desc = "Shows the location of health pickups.",
    Default = false,
    Callback = function(Value)
        OptionsConfig.DeadHPESPToggle.Value = Value
        ToggleWorldEsp(Value, "DeadHP", "HP Jar", "DeadHPESPToggle")
    end
})

-- ==================== WORLD ====================
TabConfig.World:Section({ Title = "Lighting & Effects" })

local LightingBackup = {
    Ambient = LightingService.Ambient,
    ColorShift_Top = LightingService.ColorShift_Top,
    ColorShift_Bottom = LightingService.ColorShift_Bottom,
    FogEnd = LightingService.FogEnd,
    GlobalShadows = LightingService.GlobalShadows
}

TabConfig.World:Toggle({
    Title = "Full Bright",
    Desc = "Removes shadows and makes everything bright.",
    Default = false,
    Callback = function(v)
        OptionsConfig.FullBrightToggle.Value = v
        if v then
            LightingService.Ambient = Color3.new(1, 1, 1)
            LightingService.ColorShift_Top = Color3.new(1, 1, 1)
            LightingService.ColorShift_Bottom = Color3.new(1, 1, 1)
        else
            LightingService.Ambient = LightingBackup.Ambient
            LightingService.ColorShift_Top = LightingBackup.ColorShift_Top
            LightingService.ColorShift_Bottom = LightingBackup.ColorShift_Bottom
        end
    end
})

TabConfig.World:Toggle({
    Title = "No Fog",
    Desc = "Removes distance fog.",
    Default = false,
    Callback = function(v)
        OptionsConfig.NoFogToggle.Value = v
        LightingService.FogEnd = v and 1000000 or LightingBackup.FogEnd
    end
})

TabConfig.World:Toggle({
    Title = "No Shadows",
    Desc = "Disables global shadows for potential performance gain.",
    Default = false,
    Callback = function(v)
        OptionsConfig.NoShadowsToggle.Value = v
        LightingService.GlobalShadows = not v
    end
})

local XrayEnabled = false
TabConfig.World:Toggle({
    Title = "Enable X-Ray",
    Desc = "Makes world geometry transparent.",
    Default = false,
    Callback = function(Value)
        OptionsConfig.XrayToggle.Value = Value
        XrayEnabled = Value
        WindUI:Notify({ Title = "X-Ray Vision", Content = "Status: " .. (XrayEnabled and "Enabled" or "Disabled"), Duration = 3 })
        if XrayEnabled then
            for _, p in pairs(Workspace:GetDescendants()) do
                if p:IsA("BasePart") then
                    if not p:FindFirstChild("OriginalTransparency") then
                        local nv = Instance.new("NumberValue")
                        nv.Name = "OriginalTransparency"
                        nv.Value = p.Transparency
                        nv.Parent = p
                    end
                    p.Transparency = 0.5
                end
            end
        else
            for _, p in pairs(Workspace:GetDescendants()) do
                if p:IsA("BasePart") and p:FindFirstChild("OriginalTransparency") then
                    p.Transparency = p.OriginalTransparency.Value
                    p.OriginalTransparency:Destroy()
                end
            end
        end
    end
})

TabConfig.World:Section({ Title = "Camera" })

TabConfig.World:Slider({
    Title = "Field of View (FOV)",
    Desc = "Adjusts the camera's field of view.",
    Step = 1,
    Value = { Min = 0, Max = 120, Default = 70 },
    Callback = function(v)
        OptionsConfig.FovSliderWorld.Value = v
        pcall(function() LocalPlayer.Settings.FOV.Value = v end)
    end
})

TabConfig.World:Section({ Title = "Performance" })

local MatCache, TexCache, EffectCache = {}, {}, {}
local LightingPerf = {
    GlobalShadows = LightingService.GlobalShadows,
    FogEnd = LightingService.FogEnd,
    Brightness = LightingService.Brightness
}
local TerrainPerf = {
    WaterWaveSize = Workspace.Terrain.WaterWaveSize,
    WaterWaveSpeed = Workspace.Terrain.WaterWaveSpeed,
    WaterReflectance = Workspace.Terrain.WaterReflectance,
    WaterTransparency = Workspace.Terrain.WaterTransparency
}

TabConfig.World:Toggle({
    Title = "Anti-Lag",
    Desc = "Reduces textures and materials for better FPS.",
    Default = false,
    Callback = function(Value)
        OptionsConfig.AntiLagToggle.Value = Value
        if Value then
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") and not (obj.Parent and obj.Parent:FindFirstChild("Humanoid")) then
                    MatCache[obj] = obj.Material
                    obj.Material = Enum.Material.SmoothPlastic
                end
            end
        else
            for obj, mat in pairs(MatCache) do
                if obj and obj:IsA("BasePart") then obj.Material = mat end
            end
            MatCache = {}
        end
    end
})

TabConfig.World:Toggle({
    Title = "FPS Boost",
    Desc = "Strips almost all visuals for maximum FPS.",
    Default = false,
    Callback = function(Value)
        OptionsConfig.FPSBoostToggle.Value = Value
        if Value then
            local t = Workspace.Terrain
            t.WaterWaveSize, t.WaterWaveSpeed, t.WaterReflectance, t.WaterTransparency = 0, 0, 0, 0
            LightingService.GlobalShadows = false
            LightingService.FogEnd = 387420489
            LightingService.Brightness = 0
            pcall(function() settings().Rendering.QualityLevel = "Level01" end)
            for _, obj in pairs(game:GetDescendants()) do
                if obj:IsA("Part") or obj:IsA("Union") or obj:IsA("CornerWedgePart") or obj:IsA("TrussPart") then
                    MatCache[obj] = obj.Material
                    obj.Material = Enum.Material.Plastic
                    obj.Reflectance = 0
                elseif obj:IsA("Decal") or obj:IsA("Texture") then
                    table.insert(TexCache, obj)
                    obj.Transparency = 1
                elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                    obj.Lifetime = NumberRange.new(0)
                elseif obj:IsA("Fire") or obj:IsA("SpotLight") or obj:IsA("Smoke") then
                    obj.Enabled = false
                elseif obj:IsA("MeshPart") then
                    MatCache[obj] = obj.Material
                    obj.Material = Enum.Material.Plastic
                    obj.Reflectance = 0
                end
            end
            for _, fx in pairs(LightingService:GetChildren()) do
                if fx:IsA("BlurEffect") or fx:IsA("SunRaysEffect") or fx:IsA("ColorCorrectionEffect") or fx:IsA("BloomEffect") or fx:IsA("DepthOfFieldEffect") then
                    EffectCache[fx] = fx.Enabled
                    fx.Enabled = false
                end
            end
        else
            local t = Workspace.Terrain
            t.WaterWaveSize = TerrainPerf.WaterWaveSize
            t.WaterWaveSpeed = TerrainPerf.WaterWaveSpeed
            t.WaterReflectance = TerrainPerf.WaterReflectance
            t.WaterTransparency = TerrainPerf.WaterTransparency
            LightingService.GlobalShadows = LightingPerf.GlobalShadows
            LightingService.FogEnd = LightingPerf.FogEnd
            LightingService.Brightness = LightingPerf.Brightness
            pcall(function() settings().Rendering.QualityLevel = "Automatic" end)
            for obj, mat in pairs(MatCache) do
                if obj and obj:IsA("BasePart") then obj.Material = mat; obj.Reflectance = 0 end
            end
            MatCache = {}
            for fx, en in pairs(EffectCache) do if fx then fx.Enabled = en end end
            EffectCache = {}
            for _, obj in pairs(TexCache) do if obj and obj.Parent then obj.Transparency = 0 end end
            TexCache = {}
        end
    end
})

-- ==================== SKINS ====================
TabConfig.Skins:Section({ Title = "Arm Skins" })

local function ColorToVector(c)
    return Vector3.new(c.R, c.G, c.B)
end

local ArmMaterial = "Plastic"
local ArmColor = Color3.fromRGB(50, 50, 50)
local ArmSkinEnabled = false

TabConfig.Skins:Dropdown({
    Title = "Arm Material",
    Values = { "Plastic", "ForceField", "Wood", "Grass" },
    Value = "Plastic",
    Callback = function(v) OptionsConfig.ArmMatDropdown.Value = v; ArmMaterial = v end
})

TabConfig.Skins:Colorpicker({
    Title = "Arm Color",
    Default = Color3.fromRGB(50, 50, 50),
    Callback = function(v) OptionsConfig.ArmColorPicker.Value = v; ArmColor = v end
})

TabConfig.Skins:Toggle({
    Title = "Enable Arm Skin",
    Default = false,
    Callback = function(Value)
        OptionsConfig.ArmCharmsToggle.Value = Value
        ArmSkinEnabled = Value
        if ArmSkinEnabled then
            task.spawn(function()
                while ArmSkinEnabled and OptionsConfig.ArmCharmsToggle.Value do
                    task.wait(0.01)
                    pcall(function()
                        local arms = Workspace.Camera:FindFirstChild("Arms")
                        if arms then
                            for _, obj in pairs(arms:GetDescendants()) do
                                if (obj.Name == "Right Arm" or obj.Name == "Left Arm") and obj:IsA("BasePart") then
                                    obj.Material = Enum.Material[ArmMaterial]
                                    obj.Color = ArmColor
                                elseif obj:IsA("SpecialMesh") and obj.TextureId == "" then
                                    obj.TextureId = "rbxassetid://0"
                                    obj.VertexColor = ColorToVector(ArmColor)
                                elseif obj.Name == "L" or obj.Name == "R" then
                                    obj:Destroy()
                                end
                            end
                        end
                    end)
                end
            end)
        end
    end
})

TabConfig.Skins:Section({ Title = "Gun Skins" })

local GunMaterial = "Plastic"
local GunColor = Color3.fromRGB(50, 50, 50)
local GunSkinEnabled = false

TabConfig.Skins:Dropdown({
    Title = "Gun Material",
    Values = { "Plastic", "ForceField", "Wood", "Grass" },
    Value = "Plastic",
    Callback = function(v) OptionsConfig.GunMatDropdown.Value = v; GunMaterial = v end
})

TabConfig.Skins:Colorpicker({
    Title = "Gun Color",
    Default = Color3.fromRGB(50, 50, 50),
    Callback = function(v) OptionsConfig.GunColorPicker.Value = v; GunColor = v end
})

TabConfig.Skins:Toggle({
    Title = "Enable Gun Skin",
    Default = false,
    Callback = function(Value)
        OptionsConfig.GunCharmsToggle.Value = Value
        GunSkinEnabled = Value
        if GunSkinEnabled then
            task.spawn(function()
                while GunSkinEnabled and OptionsConfig.GunCharmsToggle.Value do
                    task.wait(0.01)
                    pcall(function()
                        local arms = Workspace.Camera:FindFirstChild("Arms")
                        if arms then
                            for _, obj in pairs(arms:GetDescendants()) do
                                if obj:IsA("MeshPart") then
                                    obj.Material = Enum.Material[GunMaterial]
                                    obj.Color = GunColor
                                end
                            end
                        end
                    end)
                end
            end)
        end
    end
})

TabConfig.Skins:Section({ Title = "Chroma / Rainbow Gun" })

local RainbowWave = false
local RainbowPulse = false
local WaveCount = 1
local PulseHue = 0

local function zigzag(n)
    return math.acos(math.cos(n * math.pi)) / math.pi
end

TabConfig.Skins:Toggle({
    Title = "Rainbow Effect (Wave)",
    Default = false,
    Callback = function(v) OptionsConfig.Rainbow1Toggle.Value = v; RainbowWave = v end
})

TabConfig.Skins:Toggle({
    Title = "Rainbow Effect (Pulse)",
    Default = false,
    Callback = function(v) OptionsConfig.Rainbow2Toggle.Value = v; RainbowPulse = v end
})

RunService.RenderStepped:Connect(function()
    pcall(function()
        local arms = Workspace.Camera:FindFirstChild("Arms")
        if not arms then return end
        if RainbowWave then
            for _, obj in pairs(arms:GetDescendants()) do
                if obj.ClassName == "MeshPart" then
                    obj.Color = Color3.fromHSV(zigzag(WaveCount), 1, 1)
                    WaveCount = WaveCount + 0.0001
                end
            end
        end
        if RainbowPulse then
            PulseHue = (PulseHue + 0.1) % 1
            for _, obj in pairs(arms:GetDescendants()) do
                if obj.ClassName == "MeshPart" then
                    obj.Color = Color3.fromHSV(PulseHue, 1, 1)
                end
            end
        end
    end)
end)

-- ==================== MISC ====================
TabConfig.Extra:Section({ Title = "Profile Spoofing" })

local ScoreboardData = { Score = nil, Kills = nil }

TabConfig.Extra:Toggle({
    Title = "Spoof Level",
    Desc = "Visually sets your level and stats to max (client-side).",
    Default = false,
    Callback = function(Value)
        OptionsConfig.MaxLevelToggle.Value = Value
        local cs = LocalPlayer:FindFirstChild("CareerStatsCache")
        if not cs then return end
        if Value then
            if not ScoreboardData.Score then ScoreboardData.Score = cs.Score.Value end
            if not ScoreboardData.Kills then ScoreboardData.Kills = cs.Kills.Value end
            cs.Score.Value = 1
            cs.Kills.Value = 1
        elseif ScoreboardData.Score and ScoreboardData.Kills then
            cs.Score.Value = ScoreboardData.Score
            cs.Kills.Value = ScoreboardData.Kills
        end
    end
})

local GameInfo = { GUIName = nil, KillFeed = {}, WinnerName = nil, ScorecardName = nil }
local NameSpoofActive = false

local function ApplyNameSpoof()
    local Username, UserDisplayName = "Twistzz", "Twistzz User"
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if not pg then return end
    pcall(function()
        if pg:FindFirstChild("Menew_Main") and pg.Menew_Main:FindFirstChild("Container") and pg.Menew_Main.Container:FindFirstChild("PlrName") then
            pg.Menew_Main.Container.PlrName.Text = Username
        end
        if pg:FindFirstChild("GUI_Scorecard") and pg.GUI_Scorecard:FindFirstChild("Scorecard") then
            pg.GUI_Scorecard.Scorecard.Scrolling.Visible = false
            if pg.GUI_Scorecard.Scorecard:FindFirstChild("PlayerCard") and pg.GUI_Scorecard.Scorecard.PlayerCard:FindFirstChild("Username") then
                pg.GUI_Scorecard.Scorecard.PlayerCard.Username.Text = "Twistzz Development"
            end
        end
        local killFeed = Workspace:FindFirstChild("KillFeed")
        if killFeed then
            for i = 1, 6 do
                if killFeed:FindFirstChild(tostring(i)) then
                    killFeed[tostring(i)].Killer.Value = UserDisplayName
                end
            end
        end
        if pg:FindFirstChild("GUI") and pg.GUI:FindFirstChild("Winner") then
            pg.GUI.Winner.Visible = false
        end
    end)
end

local function RestoreNameSpoof()
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if not pg then return end
    pcall(function()
        if GameInfo.GUIName and pg:FindFirstChild("Menew_Main") and pg.Menew_Main.Container and pg.Menew_Main.Container:FindFirstChild("PlrName") then
            pg.Menew_Main.Container.PlrName.Text = GameInfo.GUIName
        end
        local killFeed = Workspace:FindFirstChild("KillFeed")
        if killFeed then
            for i, val in pairs(GameInfo.KillFeed) do
                if killFeed:FindFirstChild(tostring(i)) then
                    killFeed[tostring(i)].Killer.Value = val
                end
            end
        end
        if GameInfo.WinnerName ~= nil and pg:FindFirstChild("GUI") and pg.GUI:FindFirstChild("Winner") then
            pg.GUI.Winner.Visible = GameInfo.WinnerName
        end
        if GameInfo.ScorecardName and pg:FindFirstChild("GUI_Scorecard") then
            local u = pg.GUI_Scorecard.Scorecard and pg.GUI_Scorecard.Scorecard.PlayerCard and pg.GUI_Scorecard.Scorecard.PlayerCard:FindFirstChild("Username")
            if u then u.Text = GameInfo.ScorecardName end
        end
    end)
end

TabConfig.Extra:Toggle({
    Title = "Spoof Name",
    Desc = "Changes your name on most UI elements (client-side).",
    Default = false,
    Callback = function(Value)
        OptionsConfig.HideNameToggle.Value = Value
        NameSpoofActive = Value
        if Value then
            local pg = LocalPlayer:FindFirstChild("PlayerGui")
            pcall(function()
                if pg and pg:FindFirstChild("Menew_Main") and pg.Menew_Main.Container and pg.Menew_Main.Container:FindFirstChild("PlrName") then
                    GameInfo.GUIName = pg.Menew_Main.Container.PlrName.Text
                end
                if pg and pg:FindFirstChild("GUI") and pg.GUI:FindFirstChild("Winner") then
                    GameInfo.WinnerName = pg.GUI.Winner.Visible
                end
                if pg and pg:FindFirstChild("GUI_Scorecard") and pg.GUI_Scorecard.Scorecard and pg.GUI_Scorecard.Scorecard.PlayerCard and pg.GUI_Scorecard.Scorecard.PlayerCard:FindFirstChild("Username") then
                    GameInfo.ScorecardName = pg.GUI_Scorecard.Scorecard.PlayerCard.Username.Text
                end
                local killFeed = Workspace:FindFirstChild("KillFeed")
                if killFeed then
                    for i = 1, 6 do
                        if killFeed:FindFirstChild(tostring(i)) then
                            GameInfo.KillFeed[i] = killFeed[tostring(i)].Killer.Value
                        end
                    end
                end
            end)
            task.spawn(function()
                while NameSpoofActive and OptionsConfig.HideNameToggle.Value do
                    pcall(ApplyNameSpoof)
                    task.wait(0.2)
                end
            end)
        else
            NameSpoofActive = false
            pcall(RestoreNameSpoof)
        end
    end
})

TabConfig.Extra:Section({ Title = "Chat Badges" })

local function CreateTagToggle(tagName, label)
    TabConfig.Extra:Toggle({
        Title = "Enable " .. label .. " Badge",
        Default = false,
        Callback = function(Value)
            OptionsConfig[tagName .. "TagToggle"].Value = Value
            if Value then
                if not LocalPlayer:FindFirstChild(tagName) then
                    Instance.new("IntValue", LocalPlayer).Name = tagName
                end
            elseif LocalPlayer:FindFirstChild(tagName) then
                LocalPlayer[tagName]:Destroy()
            end
        end
    })
end

CreateTagToggle("IsChad", "Chad")
CreateTagToggle("VIP", "VIP")
CreateTagToggle("OldVIP", "Old VIP")
CreateTagToggle("Romin", "Romin")
CreateTagToggle("IsAdmin", "Admin")

-- ==================== SETTINGS ====================
TabConfig.Settings:Section({ Title = "Server Utilities" })

local isMobile = InputService.TouchEnabled and not InputService.KeyboardEnabled
if isMobile then
    TabConfig.Settings:Section({ Title = "Persistent Mobile Sensitivity" })
    local UserGameSettings = UserSettings:GetService("UserGameSettings")
    local DefaultTouchSens = UserGameSettings.TouchCameraMovementSensitivity
    local SensConn = nil

    local function UpdateSens()
        if not UserGameSettings then return end
        if OptionsConfig.MobileSensToggle.Value then
            local level = (OptionsConfig.MobileSensSlider.Value or 100) / 100
            if UserGameSettings.TouchCameraMovementSensitivity ~= level then
                UserGameSettings.TouchCameraMovementSensitivity = level
            end
        else
            if UserGameSettings.TouchCameraMovementSensitivity ~= DefaultTouchSens then
                UserGameSettings.TouchCameraMovementSensitivity = DefaultTouchSens
            end
        end
    end

    TabConfig.Settings:Toggle({
        Title = "Enable Persistent Sensitivity",
        Desc = "Overrides mobile camera sensitivity.",
        Default = false,
        Callback = function(Value)
            OptionsConfig.MobileSensToggle.Value = Value
            if Value then
                if not (SensConn and SensConn.Connected) then
                    SensConn = RunService.Heartbeat:Connect(UpdateSens)
                end
            else
                if SensConn then SensConn:Disconnect(); SensConn = nil end
                UpdateSens()
            end
        end
    })

    TabConfig.Settings:Slider({
        Title = "Sensitivity Level",
        Desc = "Touch camera sensitivity.",
        Step = 1,
        Value = { Min = 1, Max = 200, Default = math.floor(DefaultTouchSens * 100) },
        Callback = function(v)
            OptionsConfig.MobileSensSlider.Value = v
            UpdateSens()
        end
    })

    game:BindToClose(function()
        if UserGameSettings then
            UserGameSettings.TouchCameraMovementSensitivity = DefaultTouchSens
        end
    end)
end

TabConfig.Settings:Button({
    Title = "Server Hop",
    Desc = "Finds and teleports you to a new server.",
    Callback = function()
        local PlaceId = game.PlaceId
        local servers = {}
        local cursor = ""
        local hour = os.date("!*t").hour
        pcall(function()
            if readfile and isfile and isfile("NotSameServers.json") then
                servers = HttpService:JSONDecode(readfile("NotSameServers.json"))
            end
        end)
        if #servers == 0 then
            table.insert(servers, hour)
            pcall(function()
                if writefile then writefile("NotSameServers.json", HttpService:JSONEncode(servers)) end
            end)
        end
        local function tryHop()
            local url = "https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
            if cursor ~= "" then url = url .. "&cursor=" .. cursor end
            local success, response = pcall(function()
                return game:HttpGet(url)
            end)
            if success and response then
                local data = HttpService:JSONDecode(response)
                if data.nextPageCursor and data.nextPageCursor ~= "null" then cursor = data.nextPageCursor end
                if data.data then
                    for _, s in pairs(data.data) do
                        local id = tostring(s.id)
                        local free = tonumber(s.maxPlayers) > tonumber(s.playing)
                        local seen = false
                        for _, old in pairs(servers) do
                            if tostring(old) == id then seen = true end
                        end
                        if free and not seen then
                            table.insert(servers, id)
                            pcall(function()
                                if writefile then writefile("NotSameServers.json", HttpService:JSONEncode(servers)) end
                            end)
                            TeleportService:TeleportToPlaceInstance(PlaceId, id, LocalPlayer)
                            return
                        end
                    end
                end
            end
        end
        task.spawn(function()
            while task.wait(1) do
                pcall(tryHop)
            end
        end)
    end
})

TabConfig.Settings:Button({
    Title = "Rejoin Server",
    Desc = "Teleports you back to the current server.",
    Callback = function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
})

TabConfig.Settings:Section({ Title = "Game Settings" })

TabConfig.Settings:Input({
    Title = "Game Speed (Client)",
    Desc = "Adjusts the overall speed of the game. Default is 1.",
    Value = "1",
    Callback = function(Value)
        OptionsConfig.TimeScaleInput.Value = Value
        local n = tonumber(Value)
        if n then
            pcall(function()
                if ReplicatedStorage:FindFirstChild("wkspc") and ReplicatedStorage.wkspc:FindFirstChild("TimeScale") then
                    ReplicatedStorage.wkspc.TimeScale.Value = n
                end
            end)
        end
    end
})

TabConfig.Settings:Section({ Title = "Community" })

TabConfig.Settings:Button({
    Title = "Copy Discord Invite",
    Desc = "Join our community for support, updates, and more.",
    Callback = function()
        pcall(function()
            if setclipboard then setclipboard("https://discord.gg/Fn74MpzFUn") end
        end)
        WindUI:Notify({
            Title = "Link Copied",
            Content = "The Discord invite has been copied to your clipboard.",
            Duration = 4
        })
    end
})

Window:SelectTab(1)
WindUI:Notify({
    Title = "Vortex x Software",
    Content = "Script successfully initialized with WindUI.",
    Duration = 8
})
