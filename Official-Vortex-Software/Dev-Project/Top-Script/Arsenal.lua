-- ==========================================
-- WIND UI SETUP Y TEMA (ARSENAL)
-- ==========================================
local WindUI = loadstring(game:HttpGet("https://github.com/MrSxxo/WindUI/releases/latest/download/main.lua"))()

-- Services & Variables (Core Logic Preserved)
game:GetService("StarterGui")
local PlayerService = game:GetService("Players")
local InputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
game:GetService("TweenService")
local LightingService = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local CurrentCamera = workspace.CurrentCamera
local LocalPlayer = PlayerService.LocalPlayer
local UserSettings = UserSettings()

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

Window:Tag({ Title = "v3.3.43", Icon = "github", Color = Color3.fromRGB(230, 0, 50) })
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

local FlightSettings = {
    fly = false,
    flyspeed = 50
}
local CharacterModel = nil
local Humanoid = nil
local BodyVelocity = nil
local BodyAngularVelocity = nil
local Camera = nil
local IsFlying = false
local MovementKeys = {
    W = false,
    S = false,
    A = false,
    D = false,
    Space = false,
    LeftShift = false,
    Moving = false
}

local function FlyFunction()
    if LocalPlayer.Character and (LocalPlayer.Character.Head and not IsFlying) then
        CharacterModel = LocalPlayer.Character
        Humanoid = CharacterModel.Humanoid
        Humanoid.PlatformStand = true
        Camera = Workspace:WaitForChild("Camera")
        BodyVelocity = Instance.new("BodyVelocity")
        BodyAngularVelocity = Instance.new("BodyAngularVelocity")
        local VelocityObject = BodyVelocity
        local VelocityObject1 = BodyVelocity
        local VelocityObject2 = BodyVelocity
        local ZeroVector = Vector3.new(0, 0, 0)
        local MaxForceVector = Vector3.new(10000, 10000, 10000)
        VelocityObject2.P = 1000
        VelocityObject1.MaxForce = MaxForceVector
        VelocityObject.Velocity = ZeroVector
        local AngularVelocityObject = BodyAngularVelocity
        local AngularVelocityObject1 = BodyAngularVelocity
        local AngularVelocityObject2 = BodyAngularVelocity
        local ZeroVector1 = Vector3.new(0, 0, 0)
        local MaxTorqueVector = Vector3.new(10000, 10000, 10000)
        AngularVelocityObject2.P = 1000
        AngularVelocityObject1.MaxTorque = MaxTorqueVector
        AngularVelocityObject.AngularVelocity = ZeroVector1
        BodyVelocity.Parent = CharacterModel.Head
        BodyAngularVelocity.Parent = CharacterModel.Head
        IsFlying = true
        Humanoid.Died:connect(function()
            IsFlying = false
        end)
    end
end

local function StopFlyingFunction()
    if LocalPlayer.Character and IsFlying then
        Humanoid.PlatformStand = false
        if BodyVelocity then
            BodyVelocity:Destroy()
        end
        if BodyAngularVelocity then
            BodyAngularVelocity:Destroy()
        end
        IsFlying = false
    end
end

InputService.InputBegan:connect(function(Parameter1, Parameter2)
    if not Parameter2 then
        local KeyPair, KeyPair1, KeyPair2 = pairs(MovementKeys)
        while true do
            local UnknownVariable
            KeyPair2, UnknownVariable = KeyPair(KeyPair1, KeyPair2)
            if KeyPair2 == nil then
                break
            end
            if KeyPair2 ~= "Moving" and Parameter1.KeyCode == Enum.KeyCode[KeyPair2] then
                MovementKeys[KeyPair2] = true
                MovementKeys.Moving = true
            end
        end
    end
end)

InputService.InputEnded:connect(function(Parameter3, Parameter4)
    if not Parameter4 then
        local KeyPair3, KeyPair4, KeyPair5 = pairs(MovementKeys)
        local BooleanValue = false
        while true do
            local UnknownVariable1
            KeyPair5, UnknownVariable1 = KeyPair3(KeyPair4, KeyPair5)
            if KeyPair5 == nil then
                break
            end
            if KeyPair5 ~= "Moving" then
                if Parameter3.KeyCode == Enum.KeyCode[KeyPair5] then
                    MovementKeys[KeyPair5] = false
                end
                if MovementKeys[KeyPair5] then
                    BooleanValue = true
                end
            end
        end
        MovementKeys.Moving = BooleanValue
    end
end)

local function LocalFunction(Parameter5)
    return Parameter5.Unit * FlightSettings.flyspeed
end

RunService.Heartbeat:connect(function(Parameter6)
    if IsFlying and (CharacterModel and CharacterModel.PrimaryPart) then
        local PrimaryPartPosition = CharacterModel.PrimaryPart.Position
        local CFrameValue = Camera.CFrame
        local EulerAnglesX, EulerAnglesY, EulerAnglesZ = CFrameValue:toEulerAnglesXYZ()
        CharacterModel:SetPrimaryPartCFrame(CFrame.new(PrimaryPartPosition.x, PrimaryPartPosition.y, PrimaryPartPosition.z) * CFrame.Angles(EulerAnglesX, EulerAnglesY, EulerAnglesZ))
        if MovementKeys.W or (MovementKeys.S or (MovementKeys.A or (MovementKeys.D or (MovementKeys.Space or MovementKeys.LeftShift)))) then
            local NewVector = Vector3.new()
            if MovementKeys.W then
                NewVector = NewVector + LocalFunction(CFrameValue.lookVector)
            end
            if MovementKeys.S then
                NewVector = NewVector - LocalFunction(CFrameValue.lookVector)
            end
            if MovementKeys.A then
                NewVector = NewVector - LocalFunction(CFrameValue.rightVector)
            end
            if MovementKeys.D then
                NewVector = NewVector + LocalFunction(CFrameValue.rightVector)
            end
            if MovementKeys.Space then
                NewVector = NewVector + Vector3.new(0, FlightSettings.flyspeed, 0)
            end
            if MovementKeys.LeftShift then
                NewVector = NewVector - Vector3.new(0, FlightSettings.flyspeed, 0)
            end
            CharacterModel:TranslateBy(NewVector * Parameter6)
        end
    end
end)

-- TAB: COMBAT
TabConfig.Main:Section({ Title = "Hitbox" })

local BooleanFlag = false
local ConfigTable = {}
local IntegerValue = 21
local SmallIntegerValue = 6
local GameMode = "Team-Based"
local UnknownValue = nil
local PartNames = {
    "UpperTorso",
    "Head",
    "HumanoidRootPart"
}

local function LocalFunction1(Parameter7, Parameter8)
    if not ConfigTable[Parameter7] then
        ConfigTable[Parameter7] = {}
    end
    if not ConfigTable[Parameter7][Parameter8.Name] then
        ConfigTable[Parameter7][Parameter8.Name] = {
            CanCollide = Parameter8.CanCollide,
            Transparency = Parameter8.Transparency,
            Size = Parameter8.Size
        }
    end
end

local function LocalFunction2(Parameter9)
    if ConfigTable[Parameter9] then
        local CharacterModel1 = Parameter9.Character
        if CharacterModel1 then
            local ConfigPair, ConfigPair1, ConfigPair2 = pairs(ConfigTable[Parameter9])
            while true do
                local UnknownVariable2
                ConfigPair2, UnknownVariable2 = ConfigPair(ConfigPair1, ConfigPair2)
                if ConfigPair2 == nil then
                    break
                end
                local ChildPart = CharacterModel1:FindFirstChild(ConfigPair2)
                if ChildPart and ChildPart:IsA("BasePart") then
                    ChildPart.CanCollide = UnknownVariable2.CanCollide
                    ChildPart.Transparency = UnknownVariable2.Transparency
                    ChildPart.Size = UnknownVariable2.Size
                end
            end
        end
        ConfigTable[Parameter9] = nil
    end
end

local function LocalFunction3(Parameter10, Parameter11)
    if not Parameter10.Character then
        return nil
    end
    local ChildrenTable = Parameter10.Character:GetChildren()
    local ChildIndex, ChildIndex1, ChildIndex2 = ipairs(ChildrenTable)
    while true do
        local UnknownVariable3
        ChildIndex2, UnknownVariable3 = ChildIndex(ChildIndex1, ChildIndex2)
        if ChildIndex2 == nil then
            break
        end
        if UnknownVariable3:IsA("BasePart") and UnknownVariable3.Name:lower():match(Parameter11:lower()) then
            return UnknownVariable3
        end
    end
    return nil
end

local function LocalFunction4(Parameter12)
    if Parameter12 and (Parameter12.Team and LocalPlayer.Team) then
        return (GameMode == "FFA" or GameMode == "Everyone") and true or Parameter12.Team ~= LocalPlayer.Team
    else
        return false
    end
end

local function LocalFunction5(Parameter13)
    local HumanoidRootPart = Parameter13 and Parameter13.Character and Parameter13.Character:FindFirstChild("HumanoidRootPart")
    if HumanoidRootPart then
        HumanoidRootPart = LocalFunction4(Parameter13)
    end
    return HumanoidRootPart
end

local function LocalFunction6()
    local PlayerService1 = PlayerService
    local PlayerIndex, PlayerIndex1, PlayerIndex2 = ipairs(PlayerService1:GetPlayers())
    local EmptyTable = {}
    while true do
        local UnknownVariable4
        PlayerIndex2, UnknownVariable4 = PlayerIndex(PlayerIndex1, PlayerIndex2)
        if PlayerIndex2 == nil then
            break
        end
        if UnknownVariable4 ~= LocalPlayer then
            EmptyTable[UnknownVariable4] = true
            if LocalFunction5(UnknownVariable4) then
                local PartNameIndex, PartNameIndex1, PlayerList = ipairs(PartNames)
                while true do
                    local CharacterName
                    PlayerList, CharacterName = PartNameIndex(PartNameIndex1, PlayerList)
                    if PlayerList == nil then
                        break
                    end
                    local CharacterModel = UnknownVariable4.Character:FindFirstChild(CharacterName) or LocalFunction3(UnknownVariable4, CharacterName)
                    if CharacterModel and CharacterModel:IsA("BasePart") then
                        LocalFunction1(UnknownVariable4, CharacterModel)
                        CharacterModel.CanCollide = false
                        CharacterModel.Transparency = 1 - SmallIntegerValue / 10
                        CharacterModel.Size = Vector3.new(IntegerValue, IntegerValue, IntegerValue)
                    end
                end
            elseif ConfigTable[UnknownVariable4] then
                LocalFunction2(UnknownVariable4)
            end
        end
    end
    local TableKey, TableValue, TableIndex = pairs(ConfigTable)
    while true do
        TableIndex = TableKey(TableValue, TableIndex)
        if TableIndex == nil then
            break
        end
        if not EmptyTable[TableIndex] then
            LocalFunction2(TableIndex)
        end
    end
end

PlayerService.PlayerRemoving:Connect(function(Parameter1)
    if ConfigTable[Parameter1] then
        ConfigTable[Parameter1] = nil
    end
end)

TabConfig.Main:Toggle({
    Title = "Enable Hitbox Expander",
    Description = "Enlarges enemy hitboxes.",
    Default = false,
    Callback = function(Value)
        OptionsConfig.HitboxToggle.Value = Value
        BooleanFlag = Value
        WindUI:Notify({
            Title = "Hitbox Expander",
            Content = "Status: " .. (BooleanFlag and "Enabled" or "Disabled"),
            Duration = 3
        })
        if BooleanFlag then
            if not (UnknownValue and UnknownValue.Connected) then
                UnknownValue = RunService.Heartbeat:Connect(LocalFunction6)
            end
        else
            if UnknownValue then
                UnknownValue:Disconnect()
                UnknownValue = nil
            end
            local TableItem, TableProperty, TableAttribute = pairs(ConfigTable)
            while true do
                TableAttribute = TableItem(TableProperty, TableAttribute)
                if TableAttribute == nil then
                    break
                end
                LocalFunction2(TableAttribute)
            end
        end
    end
})

TabConfig.Main:Slider({
    Title = "Hitbox Size",
    Description = "How large the enemy hitboxes will be.",
    Default = 21,
    Min = 1,
    Max = 30,
    Increment = 1,
    Callback = function(Param1)
        OptionsConfig.HitboxSizeSlider.Value = Param1
        IntegerValue = Param1
    end
})

TabConfig.Main:Slider({
    Title = "Hitbox Visibility",
    Description = "Adjusts hitbox visibility. 0 is fully invisible, 10 is fully visible.",
    Default = 6,
    Min = 0,
    Max = 10,
    Increment = 0.1,
    Callback = function(Param2)
        OptionsConfig.HitboxTransSlider.Value = Param2
        SmallIntegerValue = Param2
    end
})

TabConfig.Main:Dropdown({
    Title = "Team Check",
    Description = "Choose who the features will target.",
    Values = {
        "FFA",
        "Team-Based",
        "Everyone"
    },
    Default = "Team-Based",
    Callback = function(Param3)
        OptionsConfig.HitboxTeamDropdown.Value = Param3
        GameMode = Param3
    end
})

TabConfig.Main:Section({ Title = "Lock On" })

local Flag1 = false
local EnemyCharacter = nil
local NullValue = nil
local DistanceValue = 200
local TimeValue = 0.2

local function Function1(FuncParam)
    if FuncParam and (FuncParam ~= LocalPlayer and (FuncParam.Team and LocalPlayer.Team)) then
        return GameMode == "Everyone" and true or FuncParam.Team ~= LocalPlayer.Team
    else
        return false
    end
end

local function Function2()
    local LocalCharacter = LocalPlayer.Character
    if not (LocalCharacter and LocalCharacter:FindFirstChild("Head")) then
        return nil
    end
    local HeadPosition = LocalCharacter.Head.Position
    local MaxValue = math.huge
    local PlayerService = PlayerService
    local PlayerList1, PlayerItem, PlayerIndex = ipairs(PlayerService:GetPlayers())
    local NullObject = nil
    while true do
        local CharacterModel1
        PlayerIndex, CharacterModel1 = PlayerList1(PlayerItem, PlayerIndex)
        if PlayerIndex == nil then
            break
        end
        if Function1(CharacterModel1) and CharacterModel1.Character and (CharacterModel1.Character:FindFirstChild("Head") and not CharacterModel1.Character:FindFirstChild("ForceField")) then
            local HeadObject = CharacterModel1.Character.Head
            local DistanceMagnitude = (HeadObject.Position - HeadPosition).Magnitude
            if DistanceMagnitude < MaxValue and DistanceMagnitude <= DistanceValue then
                local DirectionVector = (HeadObject.Position - HeadPosition).Unit * DistanceValue
                local RaycastParams1 = RaycastParams.new()
                RaycastParams1.FilterType = Enum.RaycastFilterType.Blacklist
                RaycastParams1.FilterDescendantsInstances = {
                    LocalCharacter
                }
                local RaycastResult = Workspace:Raycast(HeadPosition, DirectionVector, RaycastParams1)
                if RaycastResult and RaycastResult.Instance then
                    if RaycastResult.Instance:IsDescendantOf(CharacterModel1.Character) then
                        NullObject = CharacterModel1
                        MaxValue = DistanceMagnitude
                    end
                end
            end
        end
    end
    return NullObject
end

local function Function3()
    if not (EnemyCharacter and EnemyCharacter.Character and EnemyCharacter.Character:FindFirstChild("Head")) then
        EnemyCharacter = Function2()
    end
    if EnemyCharacter and EnemyCharacter.Character and EnemyCharacter.Character:FindFirstChild("Head") then
        local EnemyHead = EnemyCharacter.Character.Head
        local LocalCharacter1 = LocalPlayer.Character
        if not (LocalCharacter1 and LocalCharacter1:FindFirstChild("Head")) then
            return
        end
        local HeadPosition1 = LocalCharacter1.Head.Position
        local DirectionVector1 = (EnemyHead.Position - HeadPosition1).Unit * DistanceValue
        local RaycastParams2 = RaycastParams.new()
        RaycastParams2.FilterType = Enum.RaycastFilterType.Blacklist
        RaycastParams2.FilterDescendantsInstances = {
            LocalCharacter1
        }
        local RaycastResult1 = Workspace:Raycast(HeadPosition1, DirectionVector1, RaycastParams2)
        if RaycastResult1 and RaycastResult1.Instance and RaycastResult1.Instance:IsDescendantOf(EnemyCharacter.Character) then
            if OptionsConfig.SmoothLockOnToggle.Value then
                local CFrameValue = CFrame.new(CurrentCamera.CFrame.Position, EnemyHead.Position)
                CurrentCamera.CFrame = CurrentCamera.CFrame:Lerp(CFrameValue, TimeValue)
            else
                CurrentCamera.CFrame = CFrame.new(CurrentCamera.CFrame.Position, EnemyHead.Position)
            end
        else
            EnemyCharacter = nil
        end
    else
        EnemyCharacter = nil
    end
end

TabConfig.Main:Toggle({
    Title = "Enable Lock On",
    Description = "Automatically aims the camera at a visible target's head.",
    Default = false,
    Callback = function(Param4)
        OptionsConfig.LockOnToggle.Value = Param4
        Flag1 = Param4
        if Flag1 then
            if not NullValue then
                NullValue = RunService.RenderStepped:Connect(Function3)
            end
        else
            if NullValue then
                NullValue:Disconnect()
                NullValue = nil
            end
            EnemyCharacter = nil
        end
    end
})

TabConfig.Main:Dropdown({
    Title = "Lock On Target",
    Description = "Choose who the Lock On will target.",
    Values = {
        "Enemies",
        "Everyone"
    },
    Default = "Enemies",
    Callback = function(Param5)
        OptionsConfig.LockOnTargetDropdown.Value = Param5
        GameMode = Param5
        EnemyCharacter = nil
    end
})

TabConfig.Main:Toggle({
    Title = "Enable Smooth Lock On",
    Description = "Smoothly aims the camera instead of instantly snapping.",
    Default = false,
    Callback = function(Param6)
        OptionsConfig.SmoothLockOnToggle.Value = Param6
    end
})

TabConfig.Main:Slider({
    Title = "Lock On Smoothness",
    Description = "Controls the smoothing speed. Lower is slower.",
    Default = 20,
    Min = 1,
    Max = 50,
    Increment = 1,
    Callback = function(Param7)
        OptionsConfig.SmoothnessSlider.Value = Param7
        TimeValue = Param7 / 100
    end
})

TabConfig.Main:Section({ Title = "Triggerbot" })

getgenv().triggerb = false
local GameType = "Team-Based"
local BooleanValue = true
local Flag2 = false
local RaycastParams3 = RaycastParams.new()
RaycastParams3.FilterType = Enum.RaycastFilterType.Blacklist

TabConfig.Main:Toggle({
    Title = "Enable Triggerbot",
    Description = "Automatically shoots when your crosshair is over an enemy.",
    Default = false,
    Callback = function(FuncParam1)
        OptionsConfig.TriggerBotToggle.Value = FuncParam1
        getgenv().triggerb = FuncParam1
        WindUI:Notify({
            Title = "Triggerbot",
            Content = "Status: " .. (FuncParam1 and "Enabled" or "Disabled"),
            Duration = 3
        })
        if not FuncParam1 and Flag2 then
            Flag2 = false
            mouse1release()
        end
    end
})

TabConfig.Main:Dropdown({
    Title = "Triggerbot Team Mode",
    Description = "Determines who the triggerbot will fire at.",
    Values = {
        "FFA",
        "Team-Based",
        "Everyone"
    },
    Default = "Team-Based",
    Callback = function(FuncParam2)
        OptionsConfig.TriggerTeamDropdown.Value = FuncParam2
        GameType = FuncParam2
    end
})

local function Function4(Param8)
    if Param8 and (Param8.Team and LocalPlayer.Team) then
        if GameType ~= "FFA" then
            if GameType ~= "Everyone" then
                if GameType ~= "Team-Based" then
                    return false
                else
                    return Param8.Team ~= LocalPlayer.Team
                end
            else
                return Param8 ~= LocalPlayer
            end
        else
            return true
        end
    else
        return false
    end
end

local function Function5()
    local PlayerObject = LocalPlayer
    local HumanoidObject = (PlayerObject.Character or PlayerObject.CharacterAdded:Wait()):FindFirstChildOfClass("Humanoid")
    if HumanoidObject then
        BooleanValue = HumanoidObject.Health > 0
        HumanoidObject.HealthChanged:Connect(function(Param9)
            BooleanValue = Param9 > 0
            if not BooleanValue and Flag2 then
                Flag2 = false
                mouse1release()
            end
        end)
    end
end

LocalPlayer.CharacterAdded:Connect(Function5)
Function5()

RunService.RenderStepped:Connect(function()
    if getgenv().triggerb and BooleanValue then
        local CharacterModel2 = LocalPlayer.Character
        if CharacterModel2 then
            RaycastParams3.FilterDescendantsInstances = {
                CharacterModel2
            }
            local ViewportCenter = CurrentCamera.ViewportSize / 2
            local RayOrigin = CurrentCamera:ViewportPointToRay(ViewportCenter.X, ViewportCenter.Y)
            local RaycastResult2 = Workspace:Raycast(RayOrigin.Origin, RayOrigin.Direction * 5000, RaycastParams3)
            local Flag3 = false
            if RaycastResult2 and RaycastResult2.Instance then
                local ModelAncestor = RaycastResult2.Instance:FindFirstAncestorOfClass("Model")
                if ModelAncestor and ModelAncestor:FindFirstChild("Humanoid") then
                    local PlayerFromCharacter = PlayerService:GetPlayerFromCharacter(ModelAncestor)
                    Flag3 = PlayerFromCharacter and (Function4(PlayerFromCharacter) and not ModelAncestor:FindFirstChild("ForceField")) and true or Flag3
                end
            end
            if Flag3 then
                if not Flag2 then
                    Flag2 = true
                    mouse1press()
                end
            elseif Flag2 then
                Flag2 = false
                mouse1release()
            end
        end
    else
        if Flag2 then
            Flag2 = false
            mouse1release()
        end
        return
    end
end)

TabConfig.Main:Section({ Title = "Ragebot" })

TabConfig.Main:Toggle({
    Title = "Enable Ragebot / Autofarm",
    Description = "WARNING: Very blatant. Automatically finds and kills enemies.",
    Default = false,
    Callback = function(Param10)
        OptionsConfig.AutoFarmToggle.Value = Param10
        getgenv().AutoFarm = Param10
        WindUI:Notify({
            Title = "Ragebot",
            Content = "Status: " .. (Param10 and "Enabled" or "Disabled"),
            Duration = 3,
            SubContent = Param10 and "WARNING: This is a high-risk feature." or nil
        })
        local NullValue1 = nil
        local BooleanFlag1 = false
        ReplicatedStorage.wkspc.CurrentCurse.Value = Param10 and "Infinite Ammo" or ""
        local function Function6(FuncParam3)
            if FuncParam3 and FuncParam3 ~= LocalPlayer then
                if FuncParam3:IsA("Player") and PlayerService:FindFirstChild(FuncParam3.Name) then
                    if FuncParam3.Character and (FuncParam3.Character:FindFirstChild("HumanoidRootPart") and not FuncParam3.Character:FindFirstChild("ForceField")) then
                        if FuncParam3:FindFirstChild("Status") and FuncParam3.Status.Alive.Value then
                            if FuncParam3.Team and LocalPlayer.Team then
                                if FuncParam3.Team ~= LocalPlayer.Team then
                                    return FuncParam3.Team.Name ~= "Spectator"
                                else
                                    return false
                                end
                            else
                                return false
                            end
                        else
                            return false
                        end
                    else
                        return false
                    end
                else
                    return false
                end
            else
                return false
            end
        end
        local function Function7()
            local MaxValue1 = math.huge
            local PlayerService1 = PlayerService
            local PlayerList2, PlayerItem1, PlayerIndex1 = pairs(PlayerService1:GetPlayers())
            local NullObject1 = nil
            while true do
                local CharacterModel3
                PlayerIndex1, CharacterModel3 = PlayerList2(PlayerItem1, PlayerIndex1)
                if PlayerIndex1 == nil then
                    break
                end
                if Function6(CharacterModel3) then
                    local DistanceMagnitude1 = (LocalPlayer.Character.HumanoidRootPart.Position - CharacterModel3.Character.HumanoidRootPart.Position).Magnitude
                    if DistanceMagnitude1 < MaxValue1 then
                        NullObject1 = CharacterModel3
                        MaxValue1 = DistanceMagnitude1
                    end
                end
            end
            return NullObject1
        end
        local function Function8()
            ReplicatedStorage.wkspc.TimeScale.Value = 12
            NullValue1 = RunService.Stepped:Connect(function()
                if getgenv().AutoFarm then
                    if ReplicatedStorage.wkspc.Status.RoundOver.Value == true then
                        if BooleanFlag1 then
                            mouse1release()
                            BooleanFlag1 = false
                        end
                        return
                    end
                    if not (LocalPlayer:FindFirstChild("Status") and LocalPlayer.Status.Alive.Value) then
                        if BooleanFlag1 then
                            mouse1release()
                            BooleanFlag1 = false
                        end
                        return
                    end
                    local PlayerObject1 = Function7()
                    if PlayerObject1 then
                        local HumanoidRootPart = PlayerObject1.Character.HumanoidRootPart
                        local PositionOffset = HumanoidRootPart.Position - HumanoidRootPart.CFrame.LookVector * 2 + Vector3.new(0, 2, 0)
                        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(PositionOffset)
                        if PlayerObject1.Character:FindFirstChild("Head") then
                            local HeadPosition2 = PlayerObject1.Character.Head.Position
                            CurrentCamera.CFrame = CFrame.new(CurrentCamera.CFrame.Position, HeadPosition2)
                        end
                        if not BooleanFlag1 then
                            mouse1press()
                            BooleanFlag1 = true
                        end
                    elseif BooleanFlag1 then
                        mouse1release()
                        BooleanFlag1 = false
                    end
                else
                    if NullValue1 then
                        NullValue1:Disconnect()
                        NullValue1 = nil
                    end
                    if BooleanFlag1 then
                        mouse1release()
                        BooleanFlag1 = false
                    end
                end
            end)
        end
        if Param10 then
            task.wait(0.5)
            if LocalPlayer.Character then
                Function8()
            end
        else
            ReplicatedStorage.wkspc.CurrentCurse.Value = ""
            getgenv().AutoFarm = false
            ReplicatedStorage.wkspc.TimeScale.Value = 1
            if NullValue1 then
                NullValue1:Disconnect()
            end
            if BooleanFlag1 then
                mouse1release()
            end
        end
    end
})

-- TAB: WEAPON
TabConfig.Gun:Paragraph({
    Title = "Gun Mods",
    Content = "Modify your weapon's performance."
})

local WeaponConfig = {
    FireRate = {},
    ReloadTime = {},
    EReloadTime = {},
    Auto = {},
    Spread = {},
    Recoil = {}
}

TabConfig.Gun:Section({ Title = "Ammunition" })

TabConfig.Gun:Toggle({
    Title = "Infinite Ammo (Curse)",
    Description = "Uses the game's curse system for infinite ammo.",
    Default = false,
    Callback = function(Value)
        OptionsConfig.InfAmmoV1Toggle.Value = Value
        ReplicatedStorage.wkspc.CurrentCurse.Value = Value and "Infinite Ammo" or ""
    end
})

local BooleanValue1 = false
TabConfig.Gun:Toggle({
    Title = "Infinite Ammo (Override)",
    Description = "Forces your ammo count to stay full.",
    Default = false,
    Callback = function(Value)
        OptionsConfig.InfAmmoV2Toggle.Value = Value
        BooleanValue1 = Value
        if BooleanValue1 then
            game:GetService("RunService").Stepped:connect(function()
                pcall(function()
                    if BooleanValue1 and OptionsConfig.InfAmmoV2Toggle.Value then
                        local PlayerGui = LocalPlayer.PlayerGui
                        PlayerGui.GUI.Client.Variables.ammocount.Value = 99
                        PlayerGui.GUI.Client.Variables.ammocount2.Value = 99
                    end
                end)
            end)
        end
    end
})

TabConfig.Gun:Section({ Title = "Firing Mechanics" })

TabConfig.Gun:Toggle({
    Title = "Instant Reload",
    Description = "Removes reload times.",
    Default = false,
    Callback = function(Value)
        OptionsConfig.FastReloadToggle.Value = Value
        local FastReloadToggle = Value
        local WeaponList, WeaponItem, WeaponIndex = pairs(ReplicatedStorage.Weapons:GetChildren())
        while true do
            local UnusedVariable
            WeaponIndex, UnusedVariable = WeaponList(WeaponItem, WeaponIndex)
            if WeaponIndex == nil then
                break
            end
            if UnusedVariable:FindFirstChild("ReloadTime") then
                if FastReloadToggle then
                    if not WeaponConfig.ReloadTime[UnusedVariable] then
                        WeaponConfig.ReloadTime[UnusedVariable] = UnusedVariable.ReloadTime.Value
                    end
                    UnusedVariable.ReloadTime.Value = 0.01
                elseif WeaponConfig.ReloadTime[UnusedVariable] then
                    UnusedVariable.ReloadTime.Value = WeaponConfig.ReloadTime[UnusedVariable]
                end
            end
            if UnusedVariable:FindFirstChild("EReloadTime") then
                if FastReloadToggle then
                    if not WeaponConfig.EReloadTime[UnusedVariable] then
                        WeaponConfig.EReloadTime[UnusedVariable] = UnusedVariable.EReloadTime.Value
                    end
                    UnusedVariable.EReloadTime.Value = 0.01
                elseif WeaponConfig.EReloadTime[UnusedVariable] then
                    UnusedVariable.EReloadTime.Value = WeaponConfig.EReloadTime[UnusedVariable]
                end
            end
        end
    end
})

TabConfig.Gun:Toggle({
    Title = "Rapid Fire",
    Description = "Increases the fire rate of all weapons.",
    Default = false,
    Callback = function(Value)
        OptionsConfig.FastFireToggle.Value = Value
        local FastFireToggle = Value
        local WeaponDescendant, WeaponDescendantIndex, WeaponDescendant = pairs(ReplicatedStorage.Weapons:GetDescendants())
        while true do
            local UnknownValue
            WeaponDescendant, UnknownValue = WeaponDescendant(WeaponDescendantIndex, WeaponDescendant)
            if WeaponDescendant == nil then
                break
            end
            if UnknownValue.Name == "FireRate" or UnknownValue.Name == "BFireRate" then
                if FastFireToggle then
                    if not WeaponConfig.FireRate[UnknownValue] then
                        WeaponConfig.FireRate[UnknownValue] = UnknownValue.Value
                    end
                    UnknownValue.Value = 0.02
                elseif WeaponConfig.FireRate[UnknownValue] then
                    UnknownValue.Value = WeaponConfig.FireRate[UnknownValue]
                end
            end
        end
    end
})

TabConfig.Gun:Toggle({
    Title = "Force Auto",
    Description = "Makes all weapons fully automatic.",
    Default = false,
    Callback = function(Value)
        OptionsConfig.AlwaysAutoToggle.Value = Value
        local AlwaysAutoToggleValue = Value
        local WeaponDescendant1, WeaponDescendant2, WeaponDescendant3 = pairs(ReplicatedStorage.Weapons:GetDescendants())
        while true do
            local UnusedValue
            WeaponDescendant3, UnusedValue = WeaponDescendant1(WeaponDescendant2, WeaponDescendant3)
            if WeaponDescendant3 == nil then
                break
            end
            if UnusedValue.Name == "Auto" or (UnusedValue.Name == "AutoFire" or (UnusedValue.Name == "Automatic" or (UnusedValue.Name == "AutoShoot" or UnusedValue.Name == "AutoGun"))) then
                if AlwaysAutoToggleValue then
                    if not WeaponConfig.Auto[UnusedValue] then
                        WeaponConfig.Auto[UnusedValue] = UnusedValue.Value
                    end
                    UnusedValue.Value = true
                elseif WeaponConfig.Auto[UnusedValue] then
                    UnusedValue.Value = WeaponConfig.Auto[UnusedValue]
                end
            end
        end
    end
})

TabConfig.Gun:Section({ Title = "Weapon Stability" })

TabConfig.Gun:Toggle({
    Title = "No Spread",
    Description = "Removes all weapon spread.",
    Default = false,
    Callback = function(Value)
        OptionsConfig.NoSpreadToggle.Value = Value
        local NoSpreadToggleValue = Value
        local WeaponDescendant4, WeaponDescendant5, WeaponDescendant6 = pairs(ReplicatedStorage.Weapons:GetDescendants())
        while true do
            local UnusedValue1
            WeaponDescendant6, UnusedValue1 = WeaponDescendant4(WeaponDescendant5, WeaponDescendant6)
            if WeaponDescendant6 == nil then
                break
            end
            if UnusedValue1.Name == "MaxSpread" or (UnusedValue1.Name == "Spread" or UnusedValue1.Name == "SpreadControl") then
                if NoSpreadToggleValue then
                    if not WeaponConfig.Spread[UnusedValue1] then
                        WeaponConfig.Spread[UnusedValue1] = UnusedValue1.Value
                    end
                    UnusedValue1.Value = 0
                elseif WeaponConfig.Spread[UnusedValue1] then
                    UnusedValue1.Value = WeaponConfig.Spread[UnusedValue1]
                end
            end
        end
    end
})

TabConfig.Gun:Toggle({
    Title = "No Recoil",
    Description = "Removes all weapon recoil.",
    Default = false,
    Callback = function(Value)
        OptionsConfig.NoRecoilToggle.Value = Value
        local NoRecoilToggleValue = Value
        local WeaponDescendant7, WeaponDescendant8, WeaponDescendant9 = pairs(ReplicatedStorage.Weapons:GetDescendants())
        while true do
            local UnusedValue2
            WeaponDescendant9, UnusedValue2 = WeaponDescendant7(WeaponDescendant8, WeaponDescendant9)
            if WeaponDescendant9 == nil then
                break
            end
            if UnusedValue2.Name == "RecoilControl" or UnusedValue2.Name == "Recoil" then
                if NoRecoilToggleValue then
                    if not WeaponConfig.Recoil[UnusedValue2] then
                        WeaponConfig.Recoil[UnusedValue2] = UnusedValue2.Value
                    end
                    UnusedValue2.Value = 0
                elseif WeaponConfig.Recoil[UnusedValue2] then
                    UnusedValue2.Value = WeaponConfig.Recoil[UnusedValue2]
                end
            end
        end
    end
})

-- TAB: MOVEMENT
TabConfig.Player:Section({ Title = "Fly Hacks" })

TabConfig.Player:Toggle({
    Title = "Enable Fly",
    Description = "Allows you to fly around the map.",
    Default = false,
    Callback = function(Value)
        OptionsConfig.FlyToggle.Value = Value
        if Value then
            FlyFunction()
        else
            StopFlyingFunction()
        end
        WindUI:Notify({
            Title = "Fly",
            Content = "Status: " .. (Value and "Enabled" or "Disabled"),
            Duration = 3
        })
    end
})

TabConfig.Player:Slider({
    Title = "Fly Speed",
    Description = "Controls how fast you move while flying.",
    Default = 50,
    Min = 1,
    Max = 500,
    Increment = 1,
    Callback = function(Parameter1)
        OptionsConfig.FlySpeedSlider.Value = Parameter1
        FlightSettings.flyspeed = Parameter1
    end
})

TabConfig.Player:Section({ Title = "Speed Hacks" })

local WalkSpeedConfig = {
    WalkSpeed = 16
}
local BooleanValue = false

TabConfig.Player:Toggle({
    Title = "Enable Speed",
    Description = "Allows for custom walk speed.",
    Default = false,
    Callback = function(Value)
        OptionsConfig.CustomWalkSpeedToggle.Value = Value
        BooleanValue = Value
    end
})

local VectorTypes = {
    "Velocity",
    "Vector",
    "CFrame"
}
local VectorType1 = VectorTypes[1]

TabConfig.Player:Dropdown({
    Title = "Speed Method",
    Description = "The physics method used to apply speed.",
    Values = VectorTypes,
    Default = "Velocity",
    Callback = function(Parameter2)
        OptionsConfig.WalkMethodDropdown.Value = Parameter2
        VectorType1 = Parameter2
    end
})

TabConfig.Player:Slider({
    Title = "Walk Speed",
    Description = "Sets the desired walk speed.",
    Default = 16,
    Min = 16,
    Max = 500,
    Increment = 1,
    Callback = function(Parameter3)
        OptionsConfig.WalkSpeedSlider.Value = Parameter3
        WalkSpeedConfig.WalkSpeed = Parameter3
    end
})

local function LocalFunction1(Parameter4, Parameter5)
    local Character1 = Parameter4.Character
    local MoveDirection1
    if Character1 then
        MoveDirection1 = Character1:FindFirstChildOfClass("Humanoid")
    else
        MoveDirection1 = Character1
    end
    if Character1 then
        Character1 = Character1:FindFirstChild("HumanoidRootPart")
    end
    if MoveDirection1 and Character1 then
        local MoveSpeed1 = MoveDirection1.MoveDirection * WalkSpeedConfig.WalkSpeed
        if VectorType1 ~= "Velocity" then
            if VectorType1 ~= "Vector" then
                if VectorType1 ~= "CFrame" then
                    MoveDirection1.WalkSpeed = WalkSpeedConfig.WalkSpeed
                else
                    Character1.CFrame = Character1.CFrame + MoveDirection1.MoveDirection * WalkSpeedConfig.WalkSpeed * Parameter5 * 0.0001
                end
            else
                Character1.CFrame = Character1.CFrame + MoveSpeed1 * Parameter5 * 0.0001
            end
        else
            Character1.Velocity = Vector3.new(MoveSpeed1.X, Character1.Velocity.Y, MoveSpeed1.Z)
        end
    end
end

RunService.Stepped:Connect(function(Parameter6)
    if BooleanValue and (LocalPlayer and LocalPlayer.Character) and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalFunction1(LocalPlayer, Parameter6)
    end
end)

TabConfig.Player:Section({ Title = "Jump Hacks" })

local BooleanValue1 = false
TabConfig.Player:Toggle({
    Title = "Enable Infinite Jump",
    Description = "Allows you to jump in mid-air.",
    Default = false,
    Callback = function(Value)
        OptionsConfig.InfJumpToggle.Value = Value
        BooleanValue1 = Value
        if BooleanValue1 then
            InputService.JumpRequest:Connect(function()
                if BooleanValue1 and OptionsConfig.InfJumpToggle.Value then
                    LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
                end
            end)
        end
    end
})

TabConfig.Player:Section({ Title = "Misc Movement" })

local IntegerValue = 10
local NilValue = nil

TabConfig.Player:Toggle({
    Title = "Enable Anti-Aim",
    Description = "Spins you to make you harder to hit.",
    Default = false,
    Callback = function(Value)
        OptionsConfig.AntiAimToggle.Value = Value
        local AntiAimToggleValue = Value
        WindUI:Notify({
            Title = "Anti-Aim",
            Content = "Status: " .. (AntiAimToggleValue and "Enabled" or "Disabled"),
            Duration = 3
        })
        local Character2 = LocalPlayer.Character
        if Character2 then
            Character2 = Character2:FindFirstChild("HumanoidRootPart")
        end
        if AntiAimToggleValue then
            if Character2 then
                local BodyAngularVelocity1 = Instance.new("BodyAngularVelocity")
                BodyAngularVelocity1.Name = "AntiAimSpin"
                BodyAngularVelocity1.AngularVelocity = Vector3.new(0, IntegerValue, 0)
                BodyAngularVelocity1.MaxTorque = Vector3.new(0, math.huge, 0)
                BodyAngularVelocity1.P = 500000
                BodyAngularVelocity1.Parent = Character2
                NilValue = Instance.new("BodyGyro")
                NilValue.Name = "AntiAimGyro"
                NilValue.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                NilValue.CFrame = Character2.CFrame
                NilValue.P = 3000
                NilValue.Parent = Character2
            end
        elseif Character2 then
            local AntiAimSpin1 = Character2:FindFirstChild("AntiAimSpin")
            if AntiAimSpin1 then
                AntiAimSpin1:Destroy()
            end
            if NilValue then
                NilValue:Destroy()
                NilValue = nil
            end
        end
    end
})

TabConfig.Player:Slider({
    Title = "Spin Speed",
    Description = "Adjusts the rotation speed.",
    Default = 10,
    Min = 10,
    Max = 100,
    Increment = 1,
    Callback = function(Parameter7)
        OptionsConfig.SpinSpeedSlider.Value = Parameter7
        IntegerValue = Parameter7
        local Character3 = LocalPlayer.Character
        if Character3 then
            Character3 = Character3:FindFirstChild("HumanoidRootPart")
        end
        local AntiAimSpin2 = Character3 and Character3:FindFirstChild("AntiAimSpin")
        if AntiAimSpin2 then
            AntiAimSpin2.AngularVelocity = Vector3.new(0, IntegerValue, 0)
        end
    end
})

local BooleanValue2 = false
local function LocalFunction2()
    local Player1 = LocalPlayer
    while BooleanValue2 and OptionsConfig.NoClipToggle.Value do
        local Character4 = Player1.Character
        if Character4 then
            local Descendant1, Descendant2, Descendant3 = pairs(Character4:GetDescendants())
            while true do
                local UnusedValue3
                Descendant3, UnusedValue3 = Descendant1(Descendant2, Descendant3)
                if Descendant3 == nil then
                    break
                end
                if UnusedValue3:IsA("BasePart") then
                    UnusedValue3.CanCollide = false
                end
            end
        end
        RunService.Stepped:Wait()
    end
    local Character5 = Player1.Character
    if Character5 then
        local Descendant4, Descendant5, Descendant6 = pairs(Character5:GetDescendants())
        while true do
            local UnusedValue4
            Descendant6, UnusedValue4 = Descendant4(Descendant5, Descendant6)
            if Descendant6 == nil then
                break
            end
            if UnusedValue4:IsA("BasePart") then
                UnusedValue4.CanCollide = true
            end
        end
    end
end

TabConfig.Player:Toggle({
    Title = "Enable NoClip",
    Description = "Lets you walk through walls.",
    Default = false,
    Callback = function(Value)
        OptionsConfig.NoClipToggle.Value = Value
        BooleanValue2 = Value
        if BooleanValue2 then
            spawn(LocalFunction2)
        end
        WindUI:Notify({
            Title = "NoClip",
            Content = "Status: " .. (BooleanValue2 and "Enabled" or "Disabled"),
            Duration = 3
        })
    end
})

LocalPlayer.CharacterAdded:Connect(function(Parameter8)
    if BooleanValue2 and OptionsConfig.NoClipToggle.Value then
        task.spawn(function()
            while BooleanValue2 and (OptionsConfig.NoClipToggle.Value and Parameter8.Parent) do
                local Instance1 = Parameter8
                local Descendant7, Descendant8, Descendant9 = pairs(Instance1:GetDescendants())
                while true do
                    local UnusedValue5
                    Descendant9, UnusedValue5 = Descendant7(Descendant8, Descendant9)
                    if Descendant9 == nil then
                        break
                    end
                    if UnusedValue5:IsA("BasePart") then
                        UnusedValue5.CanCollide = false
                    end
                end
                RunService.Stepped:Wait()
            end
            if Parameter8 and Parameter8.Parent then
                local Instance2 = Parameter8
                local Descendant10, Descendant11, Descendant12 = pairs(Instance2:GetDescendants())
                while true do
                    local UnusedValue6
                    Descendant12, UnusedValue6 = Descendant10(Descendant11, Descendant12)
                    if Descendant12 == nil then
                        break
                    end
                    if UnusedValue6:IsA("BasePart") then
                        UnusedValue6.CanCollide = true
                    end
                end
            end
        end)
    end
end)

TabConfig.Player:Section({ Title = "Item Teleport" })

local StringOption = "Both"
local BooleanValue3 = false
local function managePickups()
    spawn(function()
        while BooleanValue3 and OptionsConfig.CollectDebrisToggle.Value do
            task.wait(0.1)
            pcall(function()
                local Character6 = LocalPlayer.Character
                local HumanoidRootPart1 = Character6 and Character6:FindFirstChild("HumanoidRootPart")
                if HumanoidRootPart1 then
                    local DebrisChild1, DebrisChild2, DebrisChild3 = pairs(Workspace.Debris:GetChildren())
                    while true do
                        local UnusedValue7
                        DebrisChild3, UnusedValue7 = DebrisChild1(DebrisChild2, DebrisChild3)
                        if DebrisChild3 == nil then
                            break
                        end
                        if StringOption == "DeadHP" and UnusedValue7.Name == "DeadHP" or (StringOption == "DeadAmmo" and UnusedValue7.Name == "DeadAmmo" or StringOption == "Both" and (UnusedValue7.Name == "DeadHP" or UnusedValue7.Name == "DeadAmmo")) then
                            UnusedValue7.CFrame = HumanoidRootPart1.CFrame * CFrame.new(0, 0.2, 0)
                        end
                    end
                end
            end)
        end
    end)
end

TabConfig.Player:Toggle({
    Title = "Enable Pickup TP",
    Description = "Teleports items to you.",
    Default = false,
    Callback = function(Value)
        OptionsConfig.CollectDebrisToggle.Value = Value
        BooleanValue3 = Value
        if BooleanValue3 then
            managePickups()
        end
    end
})

TabConfig.Player:Dropdown({
    Title = "Pickup Filter",
    Description = "Choose which items to teleport.",
    Values = {
        "Health",
        "Ammo",
        "Both"
    },
    Default = "Both",
    Callback = function(Parameter9)
        OptionsConfig.DebrisDropdown.Value = Parameter9
        StringOption = ({
            Health = "DeadHP",
            Ammo = "DeadAmmo",
            Both = "Both"
        })[Parameter9] or "Both"
    end
})

-- TAB: VISUALS
TabConfig.Visuals:Paragraph({
    Title = "Player Charms",
    Content = "Makes players visible through walls."
})

local CharmsConfigTable = {
    Enabled = false,
    TeamCheck = "Enemies",
    InnerColor = Color3.fromRGB(0, 150, 255),
    OutlineColor = Color3.fromRGB(0, 0, 0),
    InnerTransparency = 0.6,
    OutlineTransparency = 0.2
}
local PlayerGui = LocalPlayer
local PlayerGuiInstance = LocalPlayer.WaitForChild(PlayerGui, "PlayerGui")
local EmptyTable = {}
local NilValue1 = nil

local function LocalFunction3(Parameter10)
    if EmptyTable[Parameter10] then
        local TableValue1, TableValue2, TableValue3 = pairs(EmptyTable[Parameter10])
        while true do
            local UnusedValue8
            TableValue3, UnusedValue8 = TableValue1(TableValue2, TableValue3)
            if TableValue3 == nil then
                break
            end
            if UnusedValue8.fill then
                UnusedValue8.fill:Destroy()
            end
            if UnusedValue8.outline then
                UnusedValue8.outline:Destroy()
            end
        end
        EmptyTable[Parameter10] = nil
    end
end

local function LocalFunction4(Parameter11)
    if Parameter11 and (Parameter11.Character and not EmptyTable[Parameter11]) then
        EmptyTable[Parameter11] = {}
        local CharacterChild1, CharacterChild2, CharacterChild3 = pairs(Parameter11.Character:GetChildren())
        while true do
            local BoxSize
            CharacterChild3, BoxSize = CharacterChild1(CharacterChild2, CharacterChild3)
            if CharacterChild3 == nil then
                break
            end
            if BoxSize:IsA("BasePart") then
                local BoxSize1 = BoxSize.Size
                local BoxHandleAdornment1 = Instance.new("BoxHandleAdornment")
                local InnerColor = CharmsConfigTable.InnerColor
                local InnerTransparency = CharmsConfigTable.InnerTransparency
                BoxHandleAdornment1.Parent = PlayerGuiInstance
                BoxHandleAdornment1.Transparency = InnerTransparency
                BoxHandleAdornment1.Color3 = InnerColor
                BoxHandleAdornment1.Size = BoxSize1
                BoxHandleAdornment1.ZIndex = 5
                BoxHandleAdornment1.AlwaysOnTop = true
                BoxHandleAdornment1.Adornee = BoxSize
                local BoxHandleAdornment2 = Instance.new("BoxHandleAdornment")
                local BoxSize2 = BoxSize1 + Vector3.new(0.1, 0.1, 0.1)
                local OutlineColor = CharmsConfigTable.OutlineColor
                local OutlineTransparency = CharmsConfigTable.OutlineTransparency
                BoxHandleAdornment2.Parent = PlayerGuiInstance
                BoxHandleAdornment2.Transparency = OutlineTransparency
                BoxHandleAdornment2.Color3 = OutlineColor
                BoxHandleAdornment2.Size = BoxSize2
                BoxHandleAdornment2.ZIndex = 4
                BoxHandleAdornment2.AlwaysOnTop = true
                BoxHandleAdornment2.Adornee = BoxSize
                EmptyTable[Parameter11][BoxSize] = {
                    fill = BoxHandleAdornment1,
                    outline = BoxHandleAdornment2
                }
            end
        end
    end
end

local function LocalFunction5(Parameter1)
    if EmptyTable[Parameter1] and Parameter1.Character then
        local KeyValue, Key, ObjectSize = pairs(EmptyTable[Parameter1])
        while true do
            local ObjectFill
            ObjectSize, ObjectFill = KeyValue(Key, ObjectSize)
            if ObjectSize == nil then
                break
            end
            if ObjectSize and ObjectSize.Parent == Parameter1.Character then
                local SizeValue = ObjectSize.Size
                local FillColor = ObjectFill.fill
                local FillTransparency = ObjectFill.fill
                local FillColor3 = ObjectFill.fill
                local InnerColorValue = CharmsConfigTable.InnerColor
                local InnerTransparencyValue = CharmsConfigTable.InnerTransparency
                FillColor3.Size = SizeValue
                FillTransparency.Transparency = InnerTransparencyValue
                FillColor.Color3 = InnerColorValue
                local OutlineColorValue = ObjectFill.outline
                local OutlineTransparencyValue = ObjectFill.outline
                local OutlineThickness = ObjectFill.outline
                local OutlineColor = CharmsConfigTable.OutlineColor
                local OutlineTransparency = CharmsConfigTable.OutlineTransparency
                OutlineThickness.Size = SizeValue + Vector3.new(0.1, 0.1, 0.1)
                OutlineTransparencyValue.Transparency = OutlineTransparency
                OutlineColorValue.Color3 = OutlineColor
            else
                ObjectFill.fill:Destroy()
                ObjectFill.outline:Destroy()
                EmptyTable[Parameter1][ObjectSize] = nil
            end
        end
    else
        LocalFunction3(Parameter1)
    end
end

local function FunctionUtil()
    if CharmsConfigTable.Enabled then
        local TableKey, TableValue, TableIndex = pairs(EmptyTable)
        while true do
            local UnusedVariable
            TableIndex, UnusedVariable = TableKey(TableValue, TableIndex)
            if TableIndex == nil then
                break
            end
            if not (TableIndex and (TableIndex.Parent and TableIndex.Character)) then
                LocalFunction3(TableIndex)
            end
        end
        local PlayerService = PlayerService
        local PlayerList, PlayerIndex, PlayerObject = pairs(PlayerService:GetPlayers())
        while true do
            local PlayerData
            PlayerObject, PlayerData = PlayerList(PlayerIndex, PlayerObject)
            if PlayerObject == nil then
                break
            end
            if PlayerData ~= LocalPlayer then
                if (CharmsConfigTable.TeamCheck == "Everyone" or CharmsConfigTable.TeamCheck == "Allies" and LocalPlayer.Team == PlayerData.Team) and true or (CharmsConfigTable.TeamCheck == "Enemies" and LocalPlayer.Team ~= PlayerData.Team and true or false) then
                    if EmptyTable[PlayerData] then
                        LocalFunction5(PlayerData)
                    else
                        LocalFunction4(PlayerData)
                    end
                else
                    LocalFunction3(PlayerData)
                end
            end
        end
    end
end

TabConfig.Visuals:Toggle({
    Title = "Enable Charms",
    Default = false,
    Callback = function(Parameter2)
        OptionsConfig.CharmsToggle.Value = Parameter2
        CharmsConfigTable.Enabled = Parameter2
        if CharmsConfigTable.Enabled then
            NilValue1 = RunService.Heartbeat:Connect(FunctionUtil)
        else
            if NilValue1 then
                NilValue1:Disconnect()
                NilValue1 = nil
            end
            local TableKeyValue, TableKey1, TableValue1 = pairs(EmptyTable)
            while true do
                local UnusedVariable1
                TableValue1, UnusedVariable1 = TableKeyValue(TableKey1, TableValue1)
                if TableValue1 == nil then
                    break
                end
                LocalFunction3(TableValue1)
            end
            EmptyTable = {}
        end
    end
})

TabConfig.Visuals:Dropdown({
    Title = "Team Check",
    Values = {
        "Enemies",
        "Allies",
        "Everyone"
    },
    Default = "Enemies",
    Callback = function(Parameter3)
        OptionsConfig.CharmsTeamDropdown.Value = Parameter3
        CharmsConfigTable.TeamCheck = Parameter3
    end
})

TabConfig.Visuals:Colorpicker({
    Title = "Inner Color",
    Default = CharmsConfigTable.InnerColor,
    Callback = function(Parameter4)
        OptionsConfig.CharmsInnerColor.Value = Parameter4
        CharmsConfigTable.InnerColor = Parameter4
    end
})

TabConfig.Visuals:Colorpicker({
    Title = "Outline Color",
    Default = CharmsConfigTable.OutlineColor,
    Callback = function(Parameter5)
        OptionsConfig.CharmsOutlineColor.Value = Parameter5
        CharmsConfigTable.OutlineColor = Parameter5
    end
})

TabConfig.Visuals:Slider({
    Title = "Inner Transparency",
    Min = 0,
    Max = 1,
    Default = CharmsConfigTable.InnerTransparency,
    Increment = 0.01,
    Callback = function(Parameter6)
        OptionsConfig.CharmsInnerTransparency.Value = Parameter6
        CharmsConfigTable.InnerTransparency = Parameter6
    end
})

TabConfig.Visuals:Slider({
    Title = "Outline Transparency",
    Min = 0,
    Max = 1,
    Default = CharmsConfigTable.OutlineTransparency,
    Increment = 0.01,
    Callback = function(Parameter7)
        OptionsConfig.CharmsOutlineTransparency.Value = Parameter7
        CharmsConfigTable.OutlineTransparency = Parameter7
    end
})

PlayerService.PlayerRemoving:Connect(LocalFunction3)
PlayerService.PlayerAdded:Connect(function(ParameterUtil)
    ParameterUtil.CharacterRemoving:Connect(function()
        LocalFunction3(ParameterUtil)
    end)
end)

TabConfig.Visuals:Section({ Title = "World ESP" })

local WorldEspConfig = {}
local DontAskTable = "dontask"
local function FunctionUtil1(Parameter8, Parameter9)
    local BillboardGui = Instance.new("BillboardGui")
    local TextLabel = Instance.new("TextLabel")
    BillboardGui.Name = DontAskTable
    BillboardGui.Parent = Parameter8
    BillboardGui.AlwaysOnTop = true
    BillboardGui.Size = UDim2.new(0, 50, 0, 50)
    BillboardGui.StudsOffset = Vector3.new(0, 2, 0)
    TextLabel.Parent = BillboardGui
    TextLabel.BackgroundColor3 = Color3.new(1, 1, 1)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Size = UDim2.new(1, 0, 1, 0)
    TextLabel.Text = Parameter9
    TextLabel.TextColor3 = Color3.new(1, 0, 0)
    TextLabel.TextScaled = false
    return BillboardGui
end

local function FunctionUtil2(Parameter10, Parameter11)
    if Parameter10:IsA("TouchTransmitter") then
        local ParentObject = Parameter10.Parent
        if not ParentObject:FindFirstChild(DontAskTable) then
            WorldEspConfig[ParentObject] = FunctionUtil1(ParentObject, Parameter11)
        end
    end
end

local function FunctionUtil3(Parameter12, ParameterUtil1, ParameterUtil2, ParameterUtil3)
    if Parameter12 then
        local WorkspaceObject = Workspace
        local DescendantIndex, DescendantObject, DescendantName = ipairs(WorkspaceObject:GetDescendants())
        while true do
            local UnusedVariable2
            DescendantName, UnusedVariable2 = DescendantIndex(DescendantObject, DescendantName)
            if DescendantName == nil then
                break
            end
            if UnusedVariable2:IsA("TouchTransmitter") and UnusedVariable2.Parent.Name == ParameterUtil1 then
                FunctionUtil2(UnusedVariable2, ParameterUtil2)
            end
        end
        game.Workspace.DescendantAdded:Connect(function(Parameter13)
            if OptionsConfig[ParameterUtil3].Value and (Parameter13:IsA("TouchTransmitter") and Parameter13.Parent.Name == ParameterUtil1) then
                FunctionUtil2(Parameter13, ParameterUtil2)
            end
        end)
    else
        local ConfigKey, ConfigValue, ConfigIndex = pairs(WorldEspConfig)
        while true do
            local UnusedVariable3
            ConfigIndex, UnusedVariable3 = ConfigKey(ConfigValue, ConfigIndex)
            if ConfigIndex == nil then
                break
            end
            if ConfigIndex and (UnusedVariable3 and (UnusedVariable3:FindFirstChild("TextLabel") and UnusedVariable3.TextLabel.Text == ParameterUtil2)) then
                UnusedVariable3:Destroy()
                WorldEspConfig[ConfigIndex] = nil
            end
        end
    end
end

TabConfig.Visuals:Toggle({
    Title = "Ammo ESP",
    Description = "Shows the location of ammo pickups.",
    Default = false,
    Callback = function(Value)
        OptionsConfig.DeadAmmoESPToggle.Value = Value
        FunctionUtil3(Value, "DeadAmmo", "Ammo Box", "DeadAmmoESPToggle")
    end
})

TabConfig.Visuals:Toggle({
    Title = "Health ESP",
    Description = "Shows the location of health pickups.",
    Default = false,
    Callback = function(Value)
        OptionsConfig.DeadHPESPToggle.Value = Value
        FunctionUtil3(Value, "DeadHP", "HP Jar", "DeadHPESPToggle")
    end
})

-- TAB: WORLD
TabConfig.World:Section({ Title = "Lighting & Effects" })

local LightingConfig = {
    Ambient = LightingService.Ambient,
    ColorShift_Top = LightingService.ColorShift_Top,
    ColorShift_Bottom = LightingService.ColorShift_Bottom,
    FogEnd = LightingService.FogEnd,
    GlobalShadows = LightingService.GlobalShadows
}

TabConfig.World:Toggle({
    Title = "Full Bright",
    Description = "Removes shadows and makes everything bright.",
    Default = false,
    Callback = function(Parameter14)
        OptionsConfig.FullBrightToggle.Value = Parameter14
        if Parameter14 then
            LightingService.Ambient = Color3.new(1, 1, 1)
            LightingService.ColorShift_Top = Color3.new(1, 1, 1)
            LightingService.ColorShift_Bottom = Color3.new(1, 1, 1)
        else
            LightingService.Ambient = LightingConfig.Ambient
            LightingService.ColorShift_Top = LightingConfig.ColorShift_Top
            LightingService.ColorShift_Bottom = LightingConfig.ColorShift_Bottom
        end
    end
})

TabConfig.World:Toggle({
    Title = "No Fog",
    Description = "Removes distance fog.",
    Default = false,
    Callback = function(Parameter15)
        OptionsConfig.NoFogToggle.Value = Parameter15
        if Parameter15 then
            LightingService.FogEnd = 1000000
        else
            LightingService.FogEnd = LightingConfig.FogEnd
        end
    end
})

TabConfig.World:Toggle({
    Title = "No Shadows",
    Description = "Disables global shadows for potential performance gain.",
    Default = false,
    Callback = function(Parameter16)
        OptionsConfig.NoShadowsToggle.Value = Parameter16
        LightingService.GlobalShadows = not Parameter16
    end
})

local BooleanValueXray = false
TabConfig.World:Toggle({
    Title = "Enable X-Ray",
    Description = "Makes world geometry transparent.",
    Default = false,
    Callback = function(Value)
        OptionsConfig.XrayToggle.Value = Value
        BooleanValueXray = Value
        WindUI:Notify({
            Title = "X-Ray Vision",
            Content = "Status: " .. (BooleanValueXray and "Enabled" or "Disabled"),
            Duration = 3
        })
        if BooleanValueXray then
            local WorkspaceObject1 = Workspace
            local DescendantIndex1, DescendantObject1, DescendantName1 = pairs(WorkspaceObject1:GetDescendants())
            while true do
                local UnusedVariable4
                DescendantName1, UnusedVariable4 = DescendantIndex1(DescendantObject1, DescendantName1)
                if DescendantName1 == nil then
                    break
                end
                if UnusedVariable4:IsA("BasePart") then
                    if not UnusedVariable4:FindFirstChild("OriginalTransparency") then
                        local NumberValue = Instance.new("NumberValue")
                        NumberValue.Name = "OriginalTransparency"
                        NumberValue.Value = UnusedVariable4.Transparency
                        NumberValue.Parent = UnusedVariable4
                    end
                    UnusedVariable4.Transparency = 0.5
                end
            end
        else
            local WorkspaceObject2 = Workspace
            local DescendantIndex2, DescendantObject2, DescendantName2 = pairs(WorkspaceObject2:GetDescendants())
            while true do
                local UnusedVariable5
                DescendantName2, UnusedVariable5 = DescendantIndex2(DescendantObject2, DescendantName2)
                if DescendantName2 == nil then
                    break
                end
                if UnusedVariable5:IsA("BasePart") and UnusedVariable5:FindFirstChild("OriginalTransparency") then
                    UnusedVariable5.Transparency = UnusedVariable5.OriginalTransparency.Value
                    UnusedVariable5.OriginalTransparency:Destroy()
                end
            end
        end
    end
})

TabConfig.World:Section({ Title = "Camera" })

TabConfig.World:Slider({
    Title = "Field of View (FOV)",
    Description = "Adjusts the camera's field of view.",
    Default = 70,
    Min = 0,
    Max = 120,
    Increment = 1,
    Callback = function(Parameter17)
        OptionsConfig.FovSliderWorld.Value = Parameter17
        LocalPlayer.Settings.FOV.Value = Parameter17
    end
})

TabConfig.World:Section({ Title = "Performance" })

local ConfigTable1 = {}
local ConfigTable2 = {}
local LightingConfig1 = {
    GlobalShadows = LightingService.GlobalShadows,
    FogEnd = LightingService.FogEnd,
    Brightness = LightingService.Brightness
}
local TerrainConfig = {
    WaterWaveSize = Workspace.Terrain.WaterWaveSize,
    WaterWaveSpeed = Workspace.Terrain.WaterWaveSpeed,
    WaterReflectance = Workspace.Terrain.WaterReflectance,
    WaterTransparency = Workspace.Terrain.WaterTransparency
}
local ConfigTable3 = {}

TabConfig.World:Toggle({
    Title = "Anti-Lag",
    Description = "Reduces textures and materials for better FPS.",
    Default = false,
    Callback = function(Value)
        OptionsConfig.AntiLagToggle.Value = Value
        if Value then
            local WorkspaceObject3 = Workspace
            local DescendantIndex3, DescendantObject3, DescendantName3 = pairs(WorkspaceObject3:GetDescendants())
            while true do
                local UnusedVariable6
                DescendantName3, UnusedVariable6 = DescendantIndex3(DescendantObject3, DescendantName3)
                if DescendantName3 == nil then
                    break
                end
                if UnusedVariable6:IsA("BasePart") and not UnusedVariable6.Parent:FindFirstChild("Humanoid") then
                    ConfigTable1[UnusedVariable6] = UnusedVariable6.Material
                    UnusedVariable6.Material = Enum.Material.SmoothPlastic
                    if UnusedVariable6:IsA("Texture") then
                        table.insert(ConfigTable2, UnusedVariable6)
                        UnusedVariable6:Destroy()
                    end
                end
            end
        else
            local ConfigKey1, ConfigValue1, ConfigIndex1 = pairs(ConfigTable1)
            while true do
                local UnusedVariable7
                ConfigIndex1, UnusedVariable7 = ConfigKey1(ConfigValue1, ConfigIndex1)
                if ConfigIndex1 == nil then
                    break
                end
                if ConfigIndex1 and ConfigIndex1:IsA("BasePart") then
                    ConfigIndex1.Material = UnusedVariable7
                end
            end
            ConfigTable1 = {}
        end
    end
})

TabConfig.World:Toggle({
    Title = "FPS Boost",
    Description = "Strips almost all visuals for maximum FPS.",
    Default = false,
    Callback = function(Value)
        OptionsConfig.FPSBoostToggle.Value = Value
        if Value then
            local TerrainObject = Workspace.Terrain
            TerrainObject.WaterWaveSize = 0
            TerrainObject.WaterWaveSpeed = 0
            TerrainObject.WaterReflectance = 0
            TerrainObject.WaterTransparency = 0
            LightingService.GlobalShadows = false
            LightingService.FogEnd = 387420489
            LightingService.Brightness = 0
            settings().Rendering.QualityLevel = "Level01"
            local GameDescendantIndex, GameDescendantObject, GameDescendantName = pairs(game:GetDescendants())
            while true do
                local UnusedVariable8
                GameDescendantName, UnusedVariable8 = GameDescendantIndex(GameDescendantObject, GameDescendantName)
                if GameDescendantName == nil then
                    break
                end
                if UnusedVariable8:IsA("Part") or (UnusedVariable8:IsA("Union") or (UnusedVariable8:IsA("CornerWedgePart") or UnusedVariable8:IsA("TrussPart"))) then
                    ConfigTable1[UnusedVariable8] = UnusedVariable8.Material
                    UnusedVariable8.Material = "Plastic"
                    UnusedVariable8.Reflectance = 0
                elseif UnusedVariable8:IsA("Decal") or UnusedVariable8:IsA("Texture") then
                    table.insert(ConfigTable2, UnusedVariable8)
                    UnusedVariable8.Transparency = 1
                elseif UnusedVariable8:IsA("ParticleEmitter") or UnusedVariable8:IsA("Trail") then
                    UnusedVariable8.Lifetime = NumberRange.new(0)
                elseif UnusedVariable8:IsA("Explosion") then
                    UnusedVariable8.BlastPressure = 1
                    UnusedVariable8.BlastRadius = 1
                elseif UnusedVariable8:IsA("Fire") or (UnusedVariable8:IsA("SpotLight") or UnusedVariable8:IsA("Smoke")) then
                    UnusedVariable8.Enabled = false
                elseif UnusedVariable8:IsA("MeshPart") then
                    ConfigTable1[UnusedVariable8] = UnusedVariable8.Material
                    UnusedVariable8.Material = "Plastic"
                    UnusedVariable8.Reflectance = 0
                    UnusedVariable8.TextureID = 1.0385902758728956e16
                end
            end
            local LightingObject = LightingService
            local ChildInstance, ChildName, ChildObject = pairs(LightingObject:GetChildren())
            while true do
                local UnknownVariable
                ChildObject, UnknownVariable = ChildInstance(ChildName, ChildObject)
                if ChildObject == nil then
                    break
                end
                if UnknownVariable:IsA("BlurEffect") or (UnknownVariable:IsA("SunRaysEffect") or (UnknownVariable:IsA("ColorCorrectionEffect") or (UnknownVariable:IsA("BloomEffect") or UnknownVariable:IsA("DepthOfFieldEffect")))) then
                    ConfigTable3[UnknownVariable] = UnknownVariable.Enabled
                    UnknownVariable.Enabled = false
                end
            end
        else
            local TerrainProperty = Workspace.Terrain
            TerrainProperty.WaterWaveSize = TerrainConfig.WaterWaveSize
            TerrainProperty.WaterWaveSpeed = TerrainConfig.WaterWaveSpeed
            TerrainProperty.WaterReflectance = TerrainConfig.WaterReflectance
            TerrainProperty.WaterTransparency = TerrainConfig.WaterTransparency
            LightingService.GlobalShadows = LightingConfig1.GlobalShadows
            LightingService.FogEnd = LightingConfig1.FogEnd
            LightingService.Brightness = LightingConfig1.Brightness
            settings().Rendering.QualityLevel = "Automatic"
            local CollectionKey, CollectionValue, CollectionObject = pairs(ConfigTable1)
            while true do
                local UnusedVariable
                CollectionObject, UnusedVariable = CollectionKey(CollectionValue, CollectionObject)
                if CollectionObject == nil then
                    break
                end
                if CollectionObject and CollectionObject:IsA("BasePart") then
                    CollectionObject.Material = UnusedVariable
                    CollectionObject.Reflectance = 0
                end
            end
            ConfigTable1 = {}
            local ItemKey, ItemValue, ItemObject = pairs(ConfigTable3)
            while true do
                local TempVariable
                ItemObject, TempVariable = ItemKey(ItemValue, ItemObject)
                if ItemObject == nil then
                    break
                end
                if ItemObject then
                    ItemObject.Enabled = TempVariable
                end
            end
            ConfigTable3 = {}
            local PairKey, PairValue, PairObject = pairs(ConfigTable2)
            while true do
                local DummyVariable
                PairObject, DummyVariable = PairKey(PairValue, PairObject)
                if PairObject == nil then
                    break
                end
                if DummyVariable and DummyVariable.Parent then
                    DummyVariable.Transparency = 0
                end
            end
            ConfigTable2 = {}
        end
    end
})

-- TAB: SKINS
TabConfig.Skins:Section({ Title = "Arm Skins" })

local function FunctionParam(FunctionArgument)
    return Vector3.new(FunctionArgument.R, FunctionArgument.G, FunctionArgument.B)
end

local MaterialType = "Plastic"
TabConfig.Skins:Dropdown({
    Title = "Arm Material",
    Values = {
        "Plastic",
        "ForceField",
        "Wood",
        "Grass"
    },
    Default = "Plastic",
    Callback = function(ParameterValue)
        OptionsConfig.ArmMatDropdown.Value = ParameterValue
        MaterialType = ParameterValue
    end
})

local ColorValue = Color3.new(0.19607843137254902, 0.19607843137254902, 0.19607843137254902)
TabConfig.Skins:Colorpicker({
    Title = "Arm Color",
    Default = Color3.fromRGB(50, 50, 50),
    Callback = function(Value)
        OptionsConfig.ArmColorPicker.Value = Value
        ColorValue = Value
    end
})

local BooleanFlagArm = false
TabConfig.Skins:Toggle({
    Title = "Enable Arm Skin",
    Default = false,
    Callback = function(Value)
        OptionsConfig.ArmCharmsToggle.Value = Value
        BooleanFlagArm = Value
        if BooleanFlagArm then
            spawn(function()
                while BooleanFlagArm and OptionsConfig.ArmCharmsToggle.Value do
                    task.wait(0.01)
                    local ArmsModel = Workspace.Camera:FindFirstChild("Arms")
                    if ArmsModel then
                        local DescendantInstance, DescendantName, DescendantObject = pairs(ArmsModel:GetDescendants())
                        while true do
                            local UnusedModel
                            DescendantObject, UnusedModel = DescendantInstance(DescendantName, DescendantObject)
                            if DescendantObject == nil then
                                break
                            end
                            if UnusedModel.Name == "Right Arm" or UnusedModel.Name == "Left Arm" then
                                if UnusedModel:IsA("BasePart") then
                                    UnusedModel.Material = Enum.Material[MaterialType]
                                    UnusedModel.Color = ColorValue
                                end
                            elseif UnusedModel:IsA("SpecialMesh") then
                                if UnusedModel.TextureId == "" then
                                    UnusedModel.TextureId = "rbxassetid://0"
                                    UnusedModel.VertexColor = FunctionParam(ColorValue)
                                end
                            elseif UnusedModel.Name == "L" or UnusedModel.Name == "R" then
                                UnusedModel:Destroy()
                            end
                        end
                    end
                end
            end)
        end
    end
})

TabConfig.Skins:Section({ Title = "Gun Skins" })

local MaterialProperty = "Plastic"
TabConfig.Skins:Dropdown({
    Title = "Gun Material",
    Values = {
        "Plastic",
        "ForceField",
        "Wood",
        "Grass"
    },
    Default = "Plastic",
    Callback = function(ArgumentValue)
        OptionsConfig.GunMatDropdown.Value = ArgumentValue
        MaterialProperty = ArgumentValue
    end
})

local ColorProperty = Color3.new(0.19607843137254902, 0.19607843137254902, 0.19607843137254902)
TabConfig.Skins:Colorpicker({
    Title = "Gun Color",
    Default = Color3.fromRGB(50, 50, 50),
    Callback = function(Value)
        OptionsConfig.GunColorPicker.Value = Value
        ColorProperty = Value
    end
})

local FlagValueGun = false
TabConfig.Skins:Toggle({
    Title = "Enable Gun Skin",
    Default = false,
    Callback = function(Value)
        OptionsConfig.GunCharmsToggle.Value = Value
        FlagValueGun = Value
        if FlagValueGun then
            spawn(function()
                while FlagValueGun and OptionsConfig.GunCharmsToggle.Value do
                    task.wait(0.01)
                    if Workspace.Camera:FindFirstChild("Arms") then
                        local ArmDescendant, ArmInstance, ArmObject = pairs(Workspace.Camera.Arms:GetDescendants())
                        while true do
                            local TempModel
                            ArmObject, TempModel = ArmDescendant(ArmInstance, ArmObject)
                            if ArmObject == nil then
                                break
                            end
                            if TempModel:IsA("MeshPart") then
                                TempModel.Material = Enum.Material[MaterialProperty]
                                TempModel.Color = ColorProperty
                            end
                        end
                    end
                end
            end)
        end
    end
})

TabConfig.Skins:Section({ Title = "Chroma / Rainbow Gun" })

local EnabledFlag = false
local CountValue = 1
local function zigzag(ParamValue)
    return math.acos(math.cos(ParamValue * math.pi)) / math.pi
end

TabConfig.Skins:Toggle({
    Title = "Rainbow Effect (Wave)",
    Default = false,
    Callback = function(Value)
        OptionsConfig.Rainbow1Toggle.Value = Value
        EnabledFlag = Value
    end
})

RunService.RenderStepped:Connect(function()
    if EnabledFlag and Workspace.Camera:FindFirstChild("Arms") then
        local ArmChild, ArmKey, ArmValue = pairs(Workspace.Camera.Arms:GetDescendants())
        while true do
            local DummyModel
            ArmValue, DummyModel = ArmChild(ArmKey, ArmValue)
            if ArmValue == nil then
                break
            end
            if DummyModel.ClassName == "MeshPart" then
                DummyModel.Color = Color3.fromHSV(zigzag(CountValue), 1, 1)
                CountValue = CountValue + 0.0001
            end
        end
    end
end)

local DisabledFlag = false
local ZeroValue = 0
local DecimalValue = 0.1

TabConfig.Skins:Toggle({
    Title = "Rainbow Effect (Pulse)",
    Default = false,
    Callback = function(Value)
        OptionsConfig.Rainbow2Toggle.Value = Value
        DisabledFlag = Value
    end
})

RunService.RenderStepped:Connect(function()
    if DisabledFlag and Workspace.Camera:FindFirstChild("Arms") then
        ZeroValue = (ZeroValue + DecimalValue) % 1
        local ArmDescendant1, ArmInstance1, ArmObject1 = pairs(Workspace.Camera.Arms:GetDescendants())
        while true do
            local UnusedInstance
            ArmObject1, UnusedInstance = ArmDescendant1(ArmInstance1, ArmObject1)
            if ArmObject1 == nil then
                break
            end
            if UnusedInstance.ClassName == "MeshPart" then
                UnusedInstance.Color = Color3.fromHSV(ZeroValue, 1, 1)
            end
        end
    end
end)

-- TAB: MISC / EXTRA
TabConfig.Extra:Section({ Title = "Profile Spoofing" })

local ScoreboardData = {
    Score = nil,
    Kills = nil
}

TabConfig.Extra:Toggle({
    Title = "Spoof Level",
    Description = "Visually sets your level and stats to max (client-side).",
    Default = false,
    Callback = function(Value)
        OptionsConfig.MaxLevelToggle.Value = Value
        local MaxLevelToggle = Value
        local CareerStats = LocalPlayer.CareerStatsCache
        if MaxLevelToggle then
            if not ScoreboardData.Score then
                ScoreboardData.Score = CareerStats.Score.Value
            end
            if not ScoreboardData.Kills then
                ScoreboardData.Kills = CareerStats.Kills.Value
            end
            CareerStats.Score.Value = 1
            CareerStats.Kills.Value = 1
        elseif ScoreboardData.Score and ScoreboardData.Kills then
            CareerStats.Score.Value = ScoreboardData.Score
            CareerStats.Kills.Value = ScoreboardData.Kills
        end
    end
})

local GameInfo = {
    GUIName = nil,
    KillFeed = {},
    WinnerName = nil,
    ScorecardName = nil
}
local GameFlag = false
local GameProperty = false

local function LocalFunctionSpoof()
    local Username = "Twistzz"
    local UserDisplayName = "Twistzz User"
    local PlayerGui = LocalPlayer.PlayerGui
    if PlayerGui:FindFirstChild("Menew_Main") and (PlayerGui.Menew_Main:FindFirstChild("Container") and PlayerGui.Menew_Main.Container:FindFirstChild("PlrName")) then
        PlayerGui.Menew_Main.Container.PlrName.Text = Username
    end
    if PlayerGui:FindFirstChild("GUI_Scorecard") and PlayerGui.GUI_Scorecard:FindFirstChild("Scorecard") then
        PlayerGui.GUI_Scorecard.Scorecard.Scrolling.Visible = false
        if PlayerGui.GUI_Scorecard.Scorecard:FindFirstChild("PlayerCard") and PlayerGui.GUI_Scorecard.Scorecard.PlayerCard:FindFirstChild("Username") then
            PlayerGui.GUI_Scorecard.Scorecard.PlayerCard.Username.Text = "Twistzz Development"
        end
    end
    for LoopCounter = 1, 6 do
        if Workspace.KillFeed:FindFirstChild(tostring(LoopCounter)) then
            Workspace.KillFeed[tostring(LoopCounter)].Killer.Value = UserDisplayName
        end
    end
    if PlayerGui:FindFirstChild("GUI") and PlayerGui.GUI:FindFirstChild("Winner") then
        PlayerGui.GUI.Winner.Visible = false
    end
end

local function FunctionSpoofRestore()
    local PlayerGui1 = LocalPlayer.PlayerGui
    if GameInfo.GUIName and PlayerGui1:FindFirstChild("Menew_Main") and (PlayerGui1.Menew_Main:FindFirstChild("Container") and PlayerGui1.Menew_Main.Container:FindFirstChild("PlrName")) then
        PlayerGui1.Menew_Main.Container.PlrName.Text = GameInfo.GUIName
    end
    local KillFeedKey, KillFeedValue, KillFeedObject = pairs(GameInfo.KillFeed)
    while true do
        local TempVariable1
        KillFeedObject, TempVariable1 = KillFeedKey(KillFeedValue, KillFeedObject)
        if KillFeedObject == nil then
            break
        end
        if Workspace.KillFeed:FindFirstChild(tostring(KillFeedObject)) then
            Workspace.KillFeed[tostring(KillFeedObject)].Killer.Value = TempVariable1
        end
    end
    if GameInfo.WinnerName ~= nil and PlayerGui1:FindFirstChild("GUI") and PlayerGui1.GUI:FindFirstChild("Winner") then
        PlayerGui1.GUI.Winner.Visible = GameInfo.WinnerName
    end
    if GameInfo.ScorecardName and PlayerGui1:FindFirstChild("GUI_Scorecard") and (PlayerGui1.GUI_Scorecard:FindFirstChild("Scorecard") and (PlayerGui1.GUI_Scorecard.Scorecard:FindFirstChild("PlayerCard") and PlayerGui1.GUI_Scorecard.Scorecard.PlayerCard:FindFirstChild("Username"))) then
        PlayerGui1.GUI_Scorecard.Scorecard.PlayerCard.Username.Text = GameInfo.ScorecardName
    end
end

TabConfig.Extra:Toggle({
    Title = "Spoof Name",
    Description = "Changes your name on most UI elements (client-side).",
    Default = false,
    Callback = function(Value)
        OptionsConfig.HideNameToggle.Value = Value
        GameFlag = Value
        GameProperty = GameFlag
        if GameFlag then
            local PlayerGui2 = LocalPlayer.PlayerGui
            if PlayerGui2:FindFirstChild("Menew_Main") and (PlayerGui2.Menew_Main:FindFirstChild("Container") and PlayerGui2.Menew_Main.Container:FindFirstChild("PlrName")) then
                GameInfo.GUIName = PlayerGui2.Menew_Main.Container.PlrName.Text
            end
            if PlayerGui2:FindFirstChild("GUI") and PlayerGui2.GUI:FindFirstChild("Winner") then
                GameInfo.WinnerName = PlayerGui2.GUI.Winner.Visible
            end
            if PlayerGui2:FindFirstChild("GUI_Scorecard") and (PlayerGui2.GUI_Scorecard:FindFirstChild("Scorecard") and (PlayerGui2.GUI_Scorecard.Scorecard:FindFirstChild("PlayerCard") and PlayerGui2.GUI_Scorecard.Scorecard.PlayerCard:FindFirstChild("Username"))) then
                GameInfo.ScorecardName = PlayerGui2.GUI_Scorecard.Scorecard.PlayerCard.Username.Text
            end
            for LoopCounter1 = 1, 6 do
                if Workspace.KillFeed:FindFirstChild(tostring(LoopCounter1)) then
                    GameInfo.KillFeed[LoopCounter1] = Workspace.KillFeed[tostring(LoopCounter1)].Killer.Value
                end
            end
            spawn(function()
                while GameProperty and OptionsConfig.HideNameToggle.Value do
                    pcall(LocalFunctionSpoof)
                    task.wait(0.2)
                end
            end)
        else
            GameProperty = false
            pcall(FunctionSpoofRestore)
        end
    end
})

TabConfig.Extra:Section({ Title = "Chat Badges" })

local function CreateTagToggle(Param1, Argument1)
    TabConfig.Extra:Toggle({
        Title = "Enable " .. Argument1 .. " Badge",
        Default = false,
        Callback = function(Value)
            OptionsConfig[Param1 .. "TagToggle"].Value = Value
            local PlayerObject = LocalPlayer
            if Value then
                if not PlayerObject:FindFirstChild(Param1) then
                    Instance.new("IntValue", PlayerObject).Name = Param1
                end
            elseif PlayerObject:FindFirstChild(Param1) then
                PlayerObject[Param1]:Destroy()
            end
        end
    })
end

CreateTagToggle("IsChad", "Chad")
CreateTagToggle("VIP", "VIP")
CreateTagToggle("OldVIP", "Old VIP")
CreateTagToggle("Romin", "Romin")
CreateTagToggle("IsAdmin", "Admin")

-- TAB: SYSTEM / SETTINGS
TabConfig.Settings:Section({ Title = "Server Utilities" })

local TouchEnabled = InputService.TouchEnabled
if TouchEnabled then
    TouchEnabled = not InputService.KeyboardEnabled
end

if TouchEnabled then
    TabConfig.Settings:Section({ Title = "Persistent Mobile Sensitivity" })
    local UserGameSettings = UserSettings():GetService("UserGameSettings")
    local TouchSensitivity = UserGameSettings.TouchCameraMovementSensitivity
    local NilValueSens = nil
    
    local MobileSensToggle = TabConfig.Settings:Toggle({
        Title = "Enable Persistent Sensitivity",
        Description = "Aggressively overrides the mobile camera sensitivity. This will not be reset by the game.",
        Default = false,
        Callback = function(Value)
            OptionsConfig.MobileSensToggle.Value = Value
        end
    })
    
    local MobileSensSlider = TabConfig.Settings:Slider({
        Title = "Sensitivity Level",
        Description = "Adjust the camera sensitivity for touch controls.",
        Default = TouchSensitivity * 100,
        Min = 1,
        Max = 200,
        Increment = 1,
        Callback = function(Value)
            OptionsConfig.MobileSensSlider.Value = Value
        end
    })
    
    local function UpdateSens()
        if UserGameSettings then
            if OptionsConfig.MobileSensToggle.Value then
                local SensitivityLevel = OptionsConfig.MobileSensSlider.Value / 100
                if UserGameSettings.TouchCameraMovementSensitivity ~= SensitivityLevel then
                    UserGameSettings.TouchCameraMovementSensitivity = SensitivityLevel
                end
            elseif UserGameSettings.TouchCameraMovementSensitivity ~= TouchSensitivity then
                UserGameSettings.TouchCameraMovementSensitivity = TouchSensitivity
            end
        end
    end
    
    local function ToggleSens()
        if OptionsConfig.MobileSensToggle.Value then
            if not (NilValueSens and NilValueSens.Connected) then
                NilValueSens = RunService.Heartbeat:Connect(UpdateSens)
            end
        else
            if NilValueSens and NilValueSens.Connected then
                NilValueSens:Disconnect()
                NilValueSens = nil
            end
            UpdateSens()
        end
    end
    
    MobileSensToggle.Callback = ToggleSens
    MobileSensSlider.Callback = UpdateSens
    
    game:BindToClose(function()
        if UserGameSettings then
            UserGameSettings.TouchCameraMovementSensitivity = TouchSensitivity
        end
    end)
    task.spawn(ToggleSens)
end

TabConfig.Settings:Button({
    Title = "Server Hop",
    Description = "Finds and teleports you to a new server.",
    Callback = function()
        local PlaceId = game.PlaceId
        local EmptyTable = {}
        local EmptyString = ""
        local CurrentHour = os.date("!*t").hour
        if not pcall(function()
            EmptyTable = HttpService:JSONDecode(readfile("NotSameServers.json"))
        end) then
            table.insert(EmptyTable, CurrentHour)
            local HttpService = HttpService
            writefile("NotSameServers.json", HttpService:JSONEncode(EmptyTable))
        end
        local function teleportReturner()
            local DataContainer
            if EmptyString ~= "" then
                DataContainer = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100&cursor=" .. EmptyString))
            else
                DataContainer = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
            end
            if DataContainer.nextPageCursor and (DataContainer.nextPageCursor ~= "null" and DataContainer.nextPageCursor ~= nil) then
                EmptyString = DataContainer.nextPageCursor
            end
            local DataKey, DataValue, DataObject = pairs(DataContainer.data)
            local ZeroCount = 0
            while true do
                local IdContainer
                DataObject, IdContainer = DataKey(DataValue, DataObject)
                if DataObject == nil then
                    break
                end
                local BooleanValue = true
                local IdString = tostring(IdContainer.id)
                if tonumber(IdContainer.maxPlayers) > tonumber(IdContainer.playing) then
                    local TableKey, TableValue, TableObject = pairs(EmptyTable)
                    while true do
                        local TempVariable2
                        TableObject, TempVariable2 = TableKey(TableValue, TableObject)
                        if TableObject == nil then
                            break
                        end
                        if ZeroCount == 0 then
                            if tonumber(CurrentHour) ~= tonumber(TempVariable2) then
                                pcall(function()
                                    delfile("NotSameServers.json")
                                    EmptyTable = {}
                                    table.insert(EmptyTable, CurrentHour)
                                end)
                            end
                        elseif IdString == tostring(TempVariable2) then
                            BooleanValue = false
                        end
                        ZeroCount = ZeroCount + 1
                    end
                    if BooleanValue == true then
                        table.insert(EmptyTable, IdString)
                        task.wait()
                        pcall(function()
                            local HttpService1 = HttpService
                            writefile("NotSameServers.json", HttpService1:JSONEncode(EmptyTable))
                            task.wait()
                            TeleportService:TeleportToPlaceInstance(PlaceId, IdString, LocalPlayer)
                        end)
                        task.wait(4)
                    end
                end
            end
        end
        local function teleport()
            while task.wait() do
                pcall(function()
                    teleportReturner()
                    if EmptyString ~= "" then
                        teleportReturner()
                    end
                end)
            end
        end
        teleport()
    end
})

TabConfig.Settings:Button({
    Title = "Rejoin Server",
    Description = "Teleports you back to the current server.",
    Callback = function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
})

TabConfig.Settings:Section({ Title = "Game Settings" })

TabConfig.Settings:Input({
    Title = "Game Speed (Client)",
    Description = "Adjusts the overall speed of the game. Default is 1.",
    Default = "1",
    Callback = function(Value)
        OptionsConfig.TimeScaleInput.Value = Value
        local TimeScaleValue = tonumber(Value)
        if TimeScaleValue then
            ReplicatedStorage.wkspc.TimeScale.Value = TimeScaleValue
        end
    end
})

TabConfig.Settings:Section({ Title = "Community" })

TabConfig.Settings:Button({
    Title = "Copy Discord Invite",
    Description = "Join our community for support, updates, and more.",
    Callback = function()
        setclipboard("https://discord.gg/Fn74MpzFUn")
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
