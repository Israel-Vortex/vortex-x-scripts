-- ==========================================
-- VORTEXHUB v3.3.35 [MM2] - MOBILE SAFE
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
-- WEB CONNECTION SYSTEM (SUPABASE - UNIVERSAL)
-- ==========================================
local globalOnlineCount = 1
local httpRequest = (syn and syn.request) or (http and http.request) or http_request or request or (fluxus and fluxus.request)

task.spawn(function()
    local SUPABASE_URL = "https://hieuyfqcqvvezmtiimyv.supabase.co"
    local SUPABASE_KEY = "sb_publishable_noBI5J1_1iPrTWxHqTtnqQ_dozthipq"
    
    if not httpRequest then return end

    pcall(function()
        httpRequest({
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

    while task.wait(30) do
        pcall(function()
            httpRequest({
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

            local timeThreshold = os.time() - 40
            local response = httpRequest({
                Url = SUPABASE_URL .. "/rest/v1/active_users?timestamp=gte." .. tostring(timeThreshold) .. "&select=player_id",
                Method = "GET",
                Headers = {
                    ["apikey"] = SUPABASE_KEY,
                    ["Authorization"] = "Bearer " .. SUPABASE_KEY
                }
            })

            if response and response.StatusCode == 200 then
                local data = HttpService:JSONEncode(response.Body)
                if type(data) == "table" then
                    globalOnlineCount = #data
                end
            end
        end)
    end
end)

local ProtectedGui = Instance.new("Folder")
ProtectedGui.Name = "VortexXSystem_MM2_Protected"
pcall(function() ProtectedGui.Parent = CoreGui end)
if ProtectedGui.Parent ~= CoreGui then
    pcall(function() ProtectedGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end)
end

local WindUI = loadstring(game:HttpGet("https://github.com/MrSxxo/WindUI/releases/latest/download/main.lua"))()

WindUI:AddTheme({
    Name = "VortexXSystem",
    Accent = WindUI:Gradient({
        ["0"] = { Color = Color3.fromRGB(0, 60, 150), Transparency = 0 },
        ["100"] = { Color = Color3.fromRGB(0, 220, 255), Transparency = 0 },
    }, { Rotation = 45 }),
    Background = Color3.fromRGB(3, 7, 14),
    BackgroundTransparency = 0,
    Outline = Color3.fromHex("#00d2ff"),
    Text = Color3.fromRGB(255, 255, 255),
    Placeholder = Color3.fromRGB(255, 255, 255),
    Button = Color3.fromRGB(0, 130, 255),
    Icon = Color3.fromHex("#00d2ff"),
    Hover = Color3.fromRGB(255, 255, 255),
    WindowBackground = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromRGB(5, 12, 22), Transparency = 0.35 },
        ["100"] = { Color = Color3.fromRGB(5, 12, 22), Transparency = 0.35 },
    }, { Rotation = 45 }),
    WindowShadow = Color3.fromHex("#000000"),
    DialogBackground = Color3.fromHex("#081220"),
    DialogBackgroundTransparency = 0,
    DialogTitle = Color3.fromRGB(255, 255, 255),
    DialogContent = Color3.fromRGB(255, 255, 255),
    DialogIcon = Color3.fromHex("#00d2ff"),
    WindowTopbarButtonIcon = Color3.fromRGB(255, 255, 255),
    WindowTopbarTitle = Color3.fromRGB(255, 255, 255),
    WindowTopbarAuthor = Color3.fromRGB(255, 255, 255),
    WindowTopbarIcon = Color3.fromRGB(255, 255, 255),
    TabBackground = Color3.fromHex("#06101c"),
    TabTitle = Color3.fromRGB(255, 255, 255),
    TabIcon = Color3.fromRGB(0, 200, 255),
    ElementBackground = Color3.fromHex("#06101c"),
    ElementTitle = Color3.fromRGB(255, 255, 255),
    ElementDesc = Color3.fromRGB(255, 255, 255),
    ElementIcon = Color3.fromHex("#00d2ff"),
    PopupBackground = Color3.fromRGB(8, 16, 28),
    PopupBackgroundTransparency = 0,
    PopupTitle = Color3.fromRGB(255, 255, 255),
    PopupContent = Color3.fromRGB(255, 255, 255),
    PopupIcon = Color3.fromHex("#00d2ff"),
    Toggle = WindUI:Gradient({
        ["0"] = { Color = Color3.fromRGB(0, 60, 150), Transparency = 0 },
        ["100"] = { Color = Color3.fromRGB(0, 220, 255), Transparency = 0 },
    }, { Rotation = 90 }),
    ToggleBar = Color3.fromRGB(8, 16, 28),
    Checkbox = Color3.fromRGB(8, 16, 28),
    CheckboxIcon = Color3.fromRGB(255, 255, 255),
    Slider = WindUI:Gradient({
        ["0"] = { Color = Color3.fromRGB(0, 60, 150), Transparency = 0 },
        ["100"] = { Color = Color3.fromRGB(0, 220, 255), Transparency = 0 },
    }, { Rotation = 0 }),
    SliderThumb = Color3.fromRGB(255, 255, 255),
})

local Window = WindUI:CreateWindow({
    Title = "Vortex x System [MM2]",
    Icon = "rbxassetid://136777157214137",
    IconSize = "35",
    Author = "by ISRAEL CC",
    Folder = "VortexXSystemMM2",
    Resizable = false,
    HideSearchBar = true,
    Theme = "VortexXSystem",
    User = { Enabled = true, Anonymous = false }
})

Window:EditOpenButton({
    Title = "VortexHub",
    Icon = "rbxassetid://136777157214137",
    CornerRadius = UDim.new(0, 16),
    StrokeThickness = 1,
    StrokeColor = Color3.fromHex("#00d2ff"),
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 60, 150)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 180, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 220, 255))
    }),
    OnlyMobile = true,
    Enabled = true,
    Draggable = true,
})

Window:Tag({ Title = "v3.3.35", Icon = "github", Color = Color3.fromRGB(0, 220, 255) })

WindUI:SetTheme("VortexXSystem")
Window:SetToggleKey(Enum.KeyCode.K)

-- ==========================================
-- LOGICAS Y ESTADOS INTEGRADOS
-- ==========================================
local isFlingingActive = false
local touchFlingEnabled = false
local antiFlingEnabled = false

local autoCollectCoins = false
local autoGunTp = false
local isBagFullPaused = false

local killAuraEnabled = false
local gunAimbotEnabled = false

local espEnabled = false
local espMurderer = true
local espSheriff = true
local espInnocent = true
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
    "rbxassetid://2467567750";
    "rbxassetid://1957618848";
    "rbxassetid://2470501967";
    "rbxassetid://2467577524";
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
                elseif item:FindFirstChild("GunServer") or name:find("gun") or name:find("revolver") or name:find("pistola") or name:find("sheriff") then
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

local function getLobbyCFrame()
    local lobby = workspace:FindFirstChild("Lobby")
    if lobby then
        local spawnPart = lobby:FindFirstChild("SpawnLocation", true) or lobby:FindFirstChild("Spawn", true)
        if spawnPart and spawnPart:IsA("BasePart") then
            return spawnPart.CFrame + Vector3.new(0, 3.5, 0)
        end
    end
    return nil
end

local function getActiveMap()
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("Model") and obj.Name ~= "Lobby" and obj ~= LocalPlayer.Character and not Players:GetPlayerFromCharacter(obj) then
            if obj:FindFirstChild("SpawnLocation", true) or obj:FindFirstChild("CoinContainer") then
                return obj
            end
        end
    end
    return nil
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
            if tool:FindFirstChild("GunServer") or tool:FindFirstChild("Shoot") or name:find("gun") or name:find("revolver") or name:find("pistola") or name:find("sheriff") then
                return tool
            end
        end
    end

    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                local name = tool.Name:lower()
                if tool:FindFirstChild("GunServer") or tool:FindFirstChild("Shoot") or name:find("gun") or name:find("revolver") or name:find("pistola") or name:find("sheriff") then
                    hum:EquipTool(tool)
                    task.wait(0.15)
                    return char:FindFirstChild(tool.Name) or tool
                end
            end
        end
    end
    return nil
end

local function attackTarget(targetPlr)
    if not targetPlr or not targetPlr.Character then return end
    local targetHrp = targetPlr.Character:FindFirstChild("HumanoidRootPart") or targetPlr.Character:FindFirstChild("Head")
    local targetHum = targetPlr.Character:FindFirstChildOfClass("Humanoid")
    if not targetHrp or not targetHum or targetHum.Health <= 0 then return end

    local knife = getAndEquipKnife()
    if not knife then return end

    local handle = knife:FindFirstChild("Handle") or knife:FindFirstChildOfClass("BasePart")
    
    pcall(function()
        knife:Activate()
        if handle and targetHrp then
            firetouchinterest(targetHrp, handle, 0)
            firetouchinterest(targetHrp, handle, 1)
        end
    end)
end

local function executeKillAll()
    pcall(function()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then 
            WindUI:Notify({ Title = "Kill All", Content = "Tu personaje no está disponible.", Duration = 3 })
            return 
        end

        local knife = getAndEquipKnife()
        if not knife then 
            WindUI:Notify({ Title = "Kill All", Content = "No tienes un cuchillo en tu inventario.", Duration = 3 })
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
            WindUI:Notify({ Title = "Vortex x System", Content = "¡Kill All ejecutado con éxito!", Duration = 2 })
        else
            WindUI:Notify({ Title = "Kill All", Content = "No hay jugadores vivos para eliminar.", Duration = 3 })
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

local function shootAtMurderer()
    pcall(function()
        local murderer = getMurderer()
        if not murderer or not murderer.Character then
            WindUI:Notify({ Title = "Gun Shoot", Content = "Murderer no encontrado o muerto.", Duration = 3 })
            return
        end
        
        local mHrp = murderer.Character:FindFirstChild("HumanoidRootPart") or murderer.Character:FindFirstChild("UpperTorso") or murderer.Character:FindFirstChild("Head")
        if not mHrp then return end

        local gun = getAndEquipGun()
        if not gun then
            WindUI:Notify({ Title = "Gun Shoot", Content = "No tienes una pistola en tu inventario.", Duration = 3 })
            return
        end

        -- Predicción exacta de posición del Murderer
        local velocity = mHrp.AssemblyLinearVelocity or Vector3.new(0, 0, 0)
        local mPos = mHrp.Position + (velocity * 0.12)

        -- Disparo directo por RemoteEvent de MM2 (Dispara invisible al instante sin trabar la cámara)
        local fired = false
        pcall(function()
            if gun:FindFirstChild("Shoot") then
                gun.Shoot:FireServer(mPos)
                fired = true
            elseif ReplicatedStorage:FindFirstChild("Shoot") then
                ReplicatedStorage.Shoot:FireServer(mPos)
                fired = true
            end
        end)

        if not fired then
            -- Fallback: activar herramienta si el remote está oculto
            pcall(function()
                gun:Activate()
            end)
        end

        WindUI:Notify({ Title = "Vortex x System", Content = "¡Disparo ejecutado al Murderer!", Duration = 2 })
    end)
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
            Workspace.CurrentCamera.CameraSubject = THead or Handle or THumanoid
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
            Workspace.CurrentCamera.CameraSubject = Hum
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
        until (Root.Position - env.OldPos.p).Magnitude < 25

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
-- BUCLES Y EVENTOS DE SERVICIO
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
                    if murderer and murderer.Character then
                        local targetHrp = murderer.Character:FindFirstChild("HumanoidRootPart") or murderer.Character:FindFirstChild("Head")
                        if targetHrp then
                            local predictedPos = targetHrp.Position + (targetHrp.AssemblyLinearVelocity * 0.1)
                            Camera.CFrame = CFrame.new(Camera.CFrame.Position, predictedPos)
                        end
                    end
                end
            end
        end)
    end
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

-- ==========================================
-- FLOATING BUTTONS FOR MOBILE
-- ==========================================
local floatingBubbleGui = nil
local bubbleButton = nil
local floatingShootGui = nil
local shootBubbleButton = nil

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
        bubbleButton.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
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
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 100, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 220, 255))
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

local function createFloatingShootButton(enabled)
    if enabled then
        if floatingShootGui then return end
        
        floatingShootGui = Instance.new("ScreenGui")
        floatingShootGui.Name = "VortexFloatingShootButton"
        floatingShootGui.ResetOnSpawn = false
        pcall(function() floatingShootGui.Parent = CoreGui end)
        if floatingShootGui.Parent ~= CoreGui then
            floatingShootGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
        end
        
        shootBubbleButton = Instance.new("TextButton")
        shootBubbleButton.Name = "ShootMurdererBubble"
        shootBubbleButton.Size = UDim2.new(0, 110, 0, 42)
        shootBubbleButton.Position = UDim2.new(0.82, 0, 0.48, 0)
        shootBubbleButton.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
        shootBubbleButton.Text = "Shoot Murder"
        shootBubbleButton.TextSize = 13
        shootBubbleButton.Font = Enum.Font.GothamBold
        shootBubbleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        shootBubbleButton.TextStrokeTransparency = 1
        shootBubbleButton.BorderSizePixel = 0
        shootBubbleButton.AutoButtonColor = true
        shootBubbleButton.Parent = floatingShootGui
        
        local uiCorner = Instance.new("UICorner")
        uiCorner.CornerRadius = UDim.new(0, 10)
        uiCorner.Parent = shootBubbleButton
        
        local uigradient = Instance.new("UIGradient")
        uigradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 100, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 220, 255))
        })
        uigradient.Rotation = 45
        uigradient.Parent = shootBubbleButton

        local dragging, dragInput, dragStart, startPos
        
        shootBubbleButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = shootBubbleButton.Position
                
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
        
        shootBubbleButton.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                shootBubbleButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
        
        shootBubbleButton.MouseButton1Click:Connect(function()
            shootAtMurderer()
        end)
    else
        if floatingShootGui then
            floatingShootGui:Destroy()
            floatingShootGui = nil
            shootBubbleButton = nil
        end
    end
end

-- ==========================================
-- TABS SYSTEM
-- ==========================================

--------------------------------------------------
-- 1. CONFIG TAB
--------------------------------------------------
local configTab = Window:Tab({ Title = "Config", Icon = "cog", ShowTabTitle = true, Border = true })
configTab:Select()

configTab:Divider()
configTab:Paragraph({ Title = "Community Links", Desc = "Official Vortex x System platforms" })

configTab:Button({ 
    Title = "Copy Discord Link", 
    Callback = function() 
        pcall(function() 
            setclipboard("https://discord.gg/Fn74MpzFUn") 
            WindUI:Notify({ Title = "Vortex x System", Content = "Discord link copied!", Duration = 2 })
        end) 
    end 
})

configTab:Button({ 
    Title = "Official Website", 
    Callback = function() 
        pcall(function() 
            setclipboard("https://vortex-x-system.netlify.app/") 
            WindUI:Notify({ Title = "Vortex x System", Content = "Website link copied!", Duration = 2 })
        end) 
    end 
})

configTab:Paragraph({ Title = "Lead Developer", Desc = "ISRAEL CC" })
configTab:Paragraph({ Title = "UI Framework", Desc = "MrSxxo (WindUI)" })

configTab:Divider()
configTab:Paragraph({ Title = "Interface Settings", Desc = "Menu customization and safety" })

configTab:Keybind({ 
    Title = "Menu Keybind", 
    Key = "K", 
    Callback = function(keyVal) 
        pcall(function()
            Window:SetToggleKey(Enum.KeyCode[tostring(keyVal)] or Enum.KeyCode.K) 
        end)
    end 
})

configTab:Button({ 
    Title = "Clear Stuck Texts / UI", 
    Callback = function() 
        pcall(function()
            for _, gui in ipairs(LocalPlayer.PlayerGui:GetDescendants()) do
                if gui:IsA("TextLabel") or gui:IsA("TextButton") then
                    if gui.Text:find("MURDER") or gui.Text:find("SHERIFT") or gui.Text:find("Asesino") then
                        if gui.Visible then
                            gui.Visible = false
                        end
                    end
                end
            end
            WindUI:Notify({ Title = "Vortex x System", Content = "Ghost texts cleared.", Duration = 2 })
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
combatTab:Paragraph({ Title = "Murderer Automation", Desc = "Aggressive tools when playing as Murderer" })

combatTab:Toggle({ 
    Title = "Kill Aura", 
    Default = false, 
    Callback = function(val) 
        killAuraEnabled = val 
    end 
})

combatTab:Button({
    Title = "Kill All Players",
    Callback = function()
        executeKillAll()
    end
})

combatTab:Toggle({
    Title = "Floating Kill All Bubble (Mobile)",
    Desc = "Crea un botón flotante cian y movible para ejecutar Kill All.",
    Default = false,
    Callback = function(val)
        createFloatingKillButton(val)
    end
})

task.spawn(function()
    while true do
        if killAuraEnabled then
            pcall(function()
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    for _, plr in ipairs(Players:GetPlayers()) do
                        if plr ~= LocalPlayer and plr.Character then
                            local targetHrp = plr.Character:FindFirstChild("HumanoidRootPart")
                            local targetHum = plr.Character:FindFirstChildOfClass("Humanoid")
                            if targetHrp and targetHum and targetHum.Health > 0 then
                                if (hrp.Position - targetHrp.Position).Magnitude <= 22 then
                                    attackTarget(plr)
                                end
                            end
                        end
                    end
                end
            end)
        end
        task.wait(0.2)
    end
end)

combatTab:Divider()
combatTab:Paragraph({ Title = "Sheriff & Gun Utilities", Desc = "Aimbot, auto-shoot, and mobile gun tools" })

combatTab:Toggle({
    Title = "Gun Aimbot",
    Desc = "Apunta automáticamente la cámara hacia el Murderer al sostener la pistola.",
    Default = false,
    Callback = function(val)
        gunAimbotEnabled = val
    end
})

combatTab:Button({
    Title = "Shoot Murderer (Instant)",
    Desc = "Dispara automáticamente al Asesino sin bloquear la cámara.",
    Callback = function()
        shootAtMurderer()
    end
})

combatTab:Toggle({
    Title = "Floating Shoot Button (Mobile)",
    Desc = "Crea un botón flotante cian para dispararle al Murderer con un toque.",
    Default = false,
    Callback = function(val)
        createFloatingShootButton(val)
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
                WindUI:Notify({ Title = "Fling", Content = "Murderer no encontrado.", Duration = 3 })
            end 
        end) 
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
                WindUI:Notify({ Title = "Fling", Content = "Sheriff no encontrado.", Duration = 3 })
            end 
        end) 
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

combatTab:Dropdown({
    Title = "Select Player to Fling",
    Values = getPlayerNames(),
    Callback = function(selected)
        selectedFlingPlayer = selected
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
                WindUI:Notify({ Title = "Fling", Content = "Jugador no encontrado.", Duration = 3 })
            end
        else
            WindUI:Notify({ Title = "Fling", Content = "Selecciona un jugador primero.", Duration = 3 })
        end
    end
})

combatTab:Toggle({
    Title = "Touch Fling",
    Desc = "Gira a velocidad extrema lanzando por los aires a cualquiera que te toque.",
    Default = false,
    Callback = function(val)
        touchFlingEnabled = val
    end
})

combatTab:Toggle({
    Title = "Anti-Fling",
    Desc = "Anula colisiones y fuerzas físicas externas impidiendo que te hagan Fling.",
    Default = false,
    Callback = function(val)
        antiFlingEnabled = val
    end
})

--------------------------------------------------
-- 3. VISUALS / ESP TAB
--------------------------------------------------
local visualsTab = Window:Tab({ Title = "Visuals", Icon = "eye", ShowTabTitle = true, Border = true })

visualsTab:Divider()
visualsTab:Paragraph({ Title = "Role ESP System", Desc = "Highlight players based on their MM2 role" })

local function updateMM2ESP()
    local localHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Character then
            local char = plr.Character
            if not char.Parent then continue end 
            
            local root = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChild("Humanoid")
            
            if root and hum and hum.Health > 0 then
                local isLocal = (plr == LocalPlayer)
                if isLocal and not espSelf then
                    local hl = root:FindFirstChild("MM2_ESP")
                    local bgui = root:FindFirstChild("MM2_DistText")
                    if hl then hl:Destroy() end
                    if bgui then bgui:Destroy() end
                    continue
                end

                local hl = root:FindFirstChild("MM2_ESP")
                local bgui = root:FindFirstChild("MM2_DistText")
                local role = getRole(plr)

                local shouldShow = espEnabled and (
                    (role == "Murderer" and espMurderer) or
                    (role == "Sheriff" and espSheriff) or
                    (role == "Innocent" and espInnocent)
                )

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
                                    label.Text = "[SHERIFT] " .. dist .. " studs"
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
            elseif root then
                local hl = root:FindFirstChild("MM2_ESP")
                local bgui = root:FindFirstChild("MM2_DistText")
                if hl then hl:Destroy() end
                if bgui then bgui:Destroy() end
            end
        end
    end
end

visualsTab:Toggle({ Title = "Master Role ESP", Default = false, Callback = function(val) espEnabled = val end })
visualsTab:Toggle({ Title = "ESP Murderer", Default = true, Callback = function(val) espMurderer = val end })
visualsTab:Toggle({ Title = "ESP Sheriff", Default = true, Callback = function(val) espSheriff = val end })
visualsTab:Toggle({ Title = "ESP Innocent", Default = true, Callback = function(val) espInnocent = val end })
visualsTab:Toggle({ Title = "Self ESP", Default = false, Callback = function(val) espSelf = val end })

visualsTab:Divider()
visualsTab:Paragraph({ Title = "World & Item ESP", Desc = "Detect weapons and map hazards" })

visualsTab:Toggle({ Title = "Enable Gun ESP", Default = false, Callback = function(val) gunEspEnabled = val end })
visualsTab:Toggle({ Title = "Traps & Hazards ESP", Default = false, Callback = function(val) trapsEspEnabled = val end })

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
                                hl.FillColor = Color3.fromRGB(255, 0, 255)
                                hl.OutlineColor = Color3.fromRGB(255, 0, 255)
                                
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
                            tlabel.Text = "🔫 DROPPED GUN"
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
        if espEnabled then updateMM2ESP() end
        task.wait(0.6)
    end
end)

--------------------------------------------------
-- 4. PLAYER TAB
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
        if (playerSettings.Noclip or autoCollectCoins) and LocalPlayer.Character then
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
-- 5. NAVIGATION TAB
--------------------------------------------------
local teleportsTab = Window:Tab({ Title = "Navigation", Icon = "navigation", ShowTabTitle = true, Border = true })

teleportsTab:Divider()
teleportsTab:Paragraph({ Title = "Map & Lobby Teleports", Desc = "Fast travel across round environments" })

teleportsTab:Button({ 
    Title = "Teleport to Lobby", 
    Callback = function()
        pcall(function()
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local lobbyCFrame = getLobbyCFrame()
            if lobbyCFrame then 
                hrp.CFrame = lobbyCFrame 
            else
                WindUI:Notify({ Title = "Teleport", Content = "Lobby no encontrado.", Duration = 3 })
            end
        end)
    end 
})

teleportsTab:Button({ 
    Title = "Teleport to Map", 
    Callback = function()
        pcall(function()
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            
            local mapFound = getActiveMap()
            if mapFound then
                local spawnPart = mapFound:FindFirstChild("SpawnLocation", true) or mapFound:FindFirstChild("Spawn", true)
                
                if spawnPart and spawnPart:IsA("BasePart") then
                    hrp.CFrame = spawnPart.CFrame + Vector3.new(0, 3, 0)
                    WindUI:Notify({ Title = "Vortex x System", Content = "¡Teletransportado al mapa con éxito!", Duration = 3 })
                else
                    local success, pivot = pcall(function() return mapFound:GetPivot() end)
                    if success and pivot then
                        hrp.CFrame = pivot + Vector3.new(0, 5, 0)
                        WindUI:Notify({ Title = "Vortex x System", Content = "Teletransportado al centro del mapa.", Duration = 3 })
                    else
                        local foundPart = mapFound:FindFirstChildOfClass("BasePart")
                        if foundPart then
                            hrp.CFrame = foundPart.CFrame + Vector3.new(0, 5, 0)
                            WindUI:Notify({ Title = "Vortex x System", Content = "Teletransportado al mapa.", Duration = 3 })
                        else
                            WindUI:Notify({ Title = "Teleport", Content = "El mapa no tiene partes válidas para teletransporte.", Duration = 3 })
                        end
                    end
                end
            else
                WindUI:Notify({ Title = "Teleport", Content = "Mapa no activo (Espera a que empiece la ronda).", Duration = 3 })
            end
        end)
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

teleportsTab:Toggle({ 
    Title = "Auto Get Gun", 
    Default = false, 
    Callback = function(state) 
        autoGunTp = state 
    end 
})

teleportsTab:Divider()
teleportsTab:Paragraph({ Title = "Coin Farm Automation", Desc = "Safe automated currency collection" })

teleportsTab:Toggle({ 
    Title = "Auto Collect Coins", 
    Default = false, 
    Callback = function(state) 
        autoCollectCoins = state 
        if not state then
            isBagFullPaused = false
        end
    end 
})

task.spawn(function()
    while true do
        if autoCollectCoins then
            pcall(function()
                if isFlingingActive then
                    task.wait(0.5)
                    return
                end

                local char = LocalPlayer.Character
                if not char then 
                    task.wait(1.5)
                    return 
                end
                
                local hum = char:FindFirstChildOfClass("Humanoid")
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hum or hum.Health <= 0 or not hrp then
                    task.wait(1.5)
                    return
                end
                
                local currentCoinsNum = -1
                pcall(function()
                    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
                    if playerGui then
                        for _, gui in ipairs(playerGui:GetDescendants()) do
                            if gui:IsA("TextLabel") or gui:IsA("TextButton") then
                                local textVal = gui.Text or ""
                                local c, m = textVal:match("(%d+)%s*/%s*(%d+)")
                                if c then
                                    currentCoinsNum = tonumber(c) or -1
                                    break
                                else
                                    local numOnly = textVal:match("^%s*(%d+)%s*$")
                                    if numOnly then
                                        local n = tonumber(numOnly)
                                        if n and n <= 40 and n >= 0 then
                                            currentCoinsNum = n
                                            break
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)

                if isBagFullPaused then
                    if currentCoinsNum == 0 then
                        isBagFullPaused = false
                        WindUI:Notify({ Title = "Vortex x System", Content = "Bolsa vacía. Reanudando Auto Collect.", Duration = 3 })
                    else
                        task.wait(1)
                        return
                    end
                end

                if currentCoinsNum >= 40 then
                    isBagFullPaused = true
                    WindUI:Notify({ Title = "Vortex x System", Content = "Bolsa llena (40/40). Pausando...", Duration = 4 })
                    task.wait(1.5)
                    return
                end

                local lobbyModel = workspace:FindFirstChild("Lobby")
                if lobbyModel then
                    local lobbyCenter = lobbyModel:GetPivot().Position
                    if (hrp.Position - lobbyCenter).Magnitude < 300 then
                        task.wait(1.5)
                        return
                    end
                end

                local activeMapModel = getActiveMap()
                if not activeMapModel then
                    task.wait(1.5)
                    return
                end
                
                local coins = {}
                for _, v in ipairs(workspace:GetChildren()) do
                    if v.Name == "CoinContainer" then
                        for _, coin in ipairs(v:GetChildren()) do
                            table.insert(coins, coin)
                        end
                    elseif v:IsA("Model") and v.Name ~= "Lobby" and not Players:GetPlayerFromCharacter(v) then
                        local cc = v:FindFirstChild("CoinContainer")
                        if cc then
                            for _, coin in ipairs(cc:GetChildren()) do
                                table.insert(coins, coin)
                            end
                        end
                    end
                end
                
                if #coins == 0 then
                    task.wait(1)
                else
                    for _, coin in ipairs(coins) do
                        if not autoCollectCoins or isBagFullPaused or isFlingingActive or not coin or not coin.Parent then break end
                        local currentHum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                        local currentHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if not currentHum or currentHum.Health <= 0 or not currentHrp then break end
                        
                        local mapStillExists = false
                        for _, obj in ipairs(workspace:GetChildren()) do
                            if obj == activeMapModel then mapStillExists = true break end
                        end
                        if not mapStillExists then break end

                        local coinPart = coin:FindFirstChild("Coin") or coin:FindFirstChildOfClass("BasePart") or (coin:IsA("BasePart") and coin)
                        
                        if coinPart and coinPart:IsA("BasePart") then
                            local distance = (currentHrp.Position - coinPart.Position).Magnitude
                            local speed = 15 
                            local timeVal = math.clamp(distance / speed, 0.1, 4.0)
                            local targetCFrame = coinPart.CFrame + Vector3.new(0, 2.5, 0)
                            
                            local tweenInfo = TweenInfo.new(timeVal, Enum.EasingStyle.Linear)
                            local tween = TweenService:Create(currentHrp, tweenInfo, {CFrame = targetCFrame})
                            tween:Play()
                            
                            local connection
                            connection = RunService.Heartbeat:Connect(function()
                                local liveHum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                                if not autoCollectCoins or isBagFullPaused or isFlingingActive or not liveHum or liveHum.Health <= 0 then 
                                    tween:Cancel()
                                    if connection then connection:Disconnect() end
                                end
                            end)
                            
                            tween.Completed:Wait()
                            if connection then connection:Disconnect() end
                            
                            if not isFlingingActive and not isBagFullPaused then
                                pcall(function()
                                    local activeHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                                    if activeHrp then
                                        activeHrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                                        firetouchinterest(activeHrp, coinPart, 0)
                                        firetouchinterest(activeHrp, coinPart, 1)
                                    end
                                end)
                            end
                            
                            task.wait(0.7)
                        end
                    end
                end
            end)
        end
        task.wait(0.4)
    end
end)

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
-- 6. PC KEYBINDING TAB
--------------------------------------------------
local pcTab = Window:Tab({ Title = "PC Keybinds", Icon = "keyboard", ShowTabTitle = true, Border = true })

pcTab:Divider()
pcTab:Paragraph({ Title = "Keyboard Shortcuts", Desc = "Asigna teclas para activar opciones rápidamente en PC" })

pcTab:Keybind({
    Title = "Kill All Keybind",
    Key = "None",
    Callback = function()
        executeKillAll()
    end
})

pcTab:Keybind({
    Title = "Shoot Murderer Keybind",
    Key = "None",
    Callback = function()
        shootAtMurderer()
    end
})

pcTab:Keybind({
    Title = "Master ESP Keybind",
    Key = "None",
    Callback = function()
        pcall(function()
            espEnabled = not espEnabled
            WindUI:Notify({ Title = "Vortex x System", Content = "Master ESP: " .. (espEnabled and "ON" or "OFF"), Duration = 2 })
        end)
    end
})

pcTab:Keybind({
    Title = "Auto Collect Coins Keybind",
    Key = "None",
    Callback = function()
        pcall(function()
            autoCollectCoins = not autoCollectCoins
            if not autoCollectCoins then isBagFullPaused = false end
            WindUI:Notify({ Title = "Vortex x System", Content = "Auto Collect Coins: " .. (autoCollectCoins and "ON" or "OFF"), Duration = 2 })
        end)
    end
})

pcTab:Keybind({
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
            WindUI:Notify({ Title = "Vortex x System", Content = "X-Ray: " .. (xrayEnabled and "ON" or "OFF"), Duration = 2 })
        end)
    end
})

pcTab:Keybind({
    Title = "Teleport to Map Keybind",
    Key = "None",
    Callback = function()
        pcall(function()
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local mapFound = getActiveMap()
            if mapFound then
                local spawnPart = mapFound:FindFirstChild("SpawnLocation", true) or mapFound:FindFirstChild("Spawn", true)
                if spawnPart and spawnPart:IsA("BasePart") then
                    hrp.CFrame = spawnPart.CFrame + Vector3.new(0, 3, 0)
                else
                    local success, pivot = pcall(function() return mapFound:GetPivot() end)
                    if success and pivot then
                        hrp.CFrame = pivot + Vector3.new(0, 5, 0)
                    end
                end
            end
        end)
    end
})

pcTab:Keybind({
    Title = "Teleport to Lobby Keybind",
    Key = "None",
    Callback = function()
        pcall(function()
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local lobbyCFrame = getLobbyCFrame()
            if lobbyCFrame then hrp.CFrame = lobbyCFrame end
        end)
    end
})

pcTab:Keybind({
    Title = "Get Gun Instantly Keybind",
    Key = "None",
    Callback = function()
        pcall(instantGrabGun)
    end
})

--------------------------------------------------
-- 7. MISC / FUN TAB
--------------------------------------------------
local miscTab = Window:Tab({ Title = "Misc / Fun", Icon = "sparkles", ShowTabTitle = true, Border = true })

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
            if murderer then sendChatMessage("[VORTEX] 🔪 MURDER: " .. murderer.Name) task.wait(0.3) end
            if sheriff then sendChatMessage("[VORTEX] 🔫 SHERIFT: " .. sheriff.Name) end
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
                        if murderer then sendChatMessage("[VORTEX] 🔪 MURDER: " .. murderer.Name) task.wait(0.3) end
                        if sheriff then sendChatMessage("[VORTEX] 🔫 SHERIFT: " .. sheriff.Name) end
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
