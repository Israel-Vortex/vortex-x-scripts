-- ==========================================
-- VORTEX X SYSTEM — ULTIMATE NATIVE LAUNCHER V13
-- ==========================================
-- Developer: ISRAEL CC
-- Website: https://vortex-x-system.netlify.app/
-- ==========================================

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

pcall(function()
    if CoreGui:FindFirstChild("VortexHub_NativeLauncher") then
        CoreGui.VortexHub_NativeLauncher:Destroy()
    end
    if CoreGui:FindFirstChild("Vortex_AnimIntro") then
        CoreGui.Vortex_AnimIntro:Destroy()
    end
end)

local VortexHub_NativeLauncher = Instance.new("ScreenGui")
VortexHub_NativeLauncher.Name = "VortexHub_NativeLauncher"
VortexHub_NativeLauncher.ResetOnSpawn = false
VortexHub_NativeLauncher.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
VortexHub_NativeLauncher.IgnoreGuiInset = true
pcall(function()
    VortexHub_NativeLauncher.Parent = CoreGui
end)

-- ==========================================
-- ANIMACIÓN CINEMÁTICA PROFESIONAL (RECORRIDO FLUIDO DE GRADIENTES CIAN/AZUL)
-- ==========================================
local function playLaunchAnimation(onComplete)
    local AnimGui = Instance.new("ScreenGui")
    AnimGui.Name = "Vortex_AnimIntro"
    AnimGui.ResetOnSpawn = false
    AnimGui.IgnoreGuiInset = true
    pcall(function() AnimGui.Parent = CoreGui end)

    local BG = Instance.new("Frame")
    BG.Size = UDim2.new(1, 0, 1, 0)
    BG.BackgroundColor3 = Color3.fromRGB(2, 5, 10)
    BG.BackgroundTransparency = 1
    BG.Parent = AnimGui

    local BGGradient = Instance.new("UIGradient")
    BGGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(2, 8, 18)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 2, 6))
    })
    BGGradient.Rotation = 45
    BGGradient.Parent = BG

    -- ANILLO EXTERIOR (Gradiente en movimiento continuo)
    local OuterRing = Instance.new("Frame")
    OuterRing.Size = UDim2.new(0, 250, 0, 250)
    OuterRing.AnchorPoint = Vector2.new(0.5, 0.5)
    OuterRing.Position = UDim2.new(0.5, 0, 0.5, -20)
    OuterRing.BackgroundTransparency = 1
    OuterRing.Parent = BG

    local OuterCorner = Instance.new("UICorner")
    OuterCorner.CornerRadius = UDim.new(1, 0)
    OuterCorner.Parent = OuterRing

    local OuterStroke = Instance.new("UIStroke")
    OuterStroke.Thickness = 3.5
    OuterStroke.Transparency = 1
    OuterStroke.Color = Color3.fromRGB(255, 255, 255)
    OuterStroke.Parent = OuterRing

    local OuterStrokeGrad = Instance.new("UIGradient")
    OuterStrokeGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 255)),   -- Cyan Neón
        ColorSequenceKeypoint.new(0.25, Color3.fromRGB(0, 130, 255)), -- Azul Eléctrico
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 30, 150)),   -- Azul Oscuro
        ColorSequenceKeypoint.new(0.75, Color3.fromRGB(0, 200, 255)), -- Azul Celeste
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 255))    -- Cyan Neón (Bucle Perfecto)
    })
    OuterStrokeGrad.Parent = OuterStroke

    -- ANILLO INTERIOR (Efecto Orbital Inverso)
    local InnerRing = Instance.new("Frame")
    InnerRing.Size = UDim2.new(0, 210, 0, 210)
    InnerRing.AnchorPoint = Vector2.new(0.5, 0.5)
    InnerRing.Position = UDim2.new(0.5, 0, 0.5, -20)
    InnerRing.BackgroundTransparency = 1
    InnerRing.Parent = BG

    local InnerCorner = Instance.new("UICorner")
    InnerCorner.CornerRadius = UDim.new(1, 0)
    InnerCorner.Parent = InnerRing

    local InnerStroke = Instance.new("UIStroke")
    InnerStroke.Thickness = 2.2
    InnerStroke.Transparency = 1
    InnerStroke.Color = Color3.fromRGB(255, 255, 255)
    InnerStroke.Parent = InnerRing

    local InnerStrokeGrad = Instance.new("UIGradient")
    InnerStrokeGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 80, 220)),
        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 255)),
        ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0, 160, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 80, 220))
    })
    InnerStrokeGrad.Parent = InnerStroke

    -- Logo Principal (ID: 136777157214137)
    local CenterLogo = Instance.new("ImageLabel")
    CenterLogo.Size = UDim2.new(0, 30, 0, 30)
    CenterLogo.AnchorPoint = Vector2.new(0.5, 0.5)
    CenterLogo.Position = UDim2.new(0.5, 0, 0.5, -20)
    CenterLogo.BackgroundTransparency = 1
    CenterLogo.Image = "rbxassetid://136777157214137"
    CenterLogo.ImageTransparency = 1
    CenterLogo.Parent = BG

    -- Textos
    local TitleText = Instance.new("TextLabel")
    TitleText.Size = UDim2.new(0, 400, 0, 35)
    TitleText.AnchorPoint = Vector2.new(0.5, 0.5)
    TitleText.Position = UDim2.new(0.5, 0, 0.5, 105)
    TitleText.BackgroundTransparency = 1
    TitleText.Font = Enum.Font.GothamBlack
    TitleText.Text = "VORTEX X SYSTEM"
    TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleText.TextSize = 22
    TitleText.TextTransparency = 1
    TitleText.Parent = BG

    local SubtitleText = Instance.new("TextLabel")
    SubtitleText.Size = UDim2.new(0, 300, 0, 20)
    SubtitleText.AnchorPoint = Vector2.new(0.5, 0.5)
    SubtitleText.Position = UDim2.new(0.5, 0, 0.5, 130)
    SubtitleText.BackgroundTransparency = 1
    SubtitleText.Font = Enum.Font.GothamMedium
    SubtitleText.Text = "SYSTEM INITIALIZED BY ISRAEL CC"
    SubtitleText.TextColor3 = Color3.fromRGB(0, 230, 255)
    SubtitleText.TextSize = 11
    SubtitleText.TextTransparency = 1
    SubtitleText.Parent = BG

    -- ANIMACIÓN REAL DE DESPLAZAMIENTO DE COLORES EN LOS ANILLOS
    local outerOffset = 0
    local innerOffset = 0
    local rotateConn
    rotateConn = RunService.RenderStepped:Connect(function(dt)
        if OuterRing and OuterRing.Parent then
            OuterRing.Rotation = OuterRing.Rotation + (40 * dt)
            outerOffset = (outerOffset + (0.7 * dt)) % 1
            OuterStrokeGrad.Offset = Vector2.new(outerOffset, 0)
            OuterStrokeGrad.Rotation = (OuterStrokeGrad.Rotation + (120 * dt)) % 360
            
            if InnerRing and InnerRing.Parent then
                InnerRing.Rotation = InnerRing.Rotation - (60 * dt)
                innerOffset = (innerOffset - (0.9 * dt)) % 1
                InnerStrokeGrad.Offset = Vector2.new(innerOffset, 0)
                InnerStrokeGrad.Rotation = (InnerStrokeGrad.Rotation - (150 * dt)) % 360
            end
        else
            if rotateConn then rotateConn:Disconnect() end
        end
    end)

    -- Secuencia de Entrada
    local tiBG = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tiLogo = TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local tiText = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

    TweenService:Create(BG, tiBG, {BackgroundTransparency = 0.1}):Play()
    TweenService:Create(OuterStroke, tiBG, {Transparency = 0.1}):Play()
    TweenService:Create(InnerStroke, tiBG, {Transparency = 0.25}):Play()
    TweenService:Create(CenterLogo, tiLogo, {
        ImageTransparency = 0,
        Size = UDim2.new(0, 185, 0, 185)
    }):Play()
    
    task.wait(0.3)
    TweenService:Create(TitleText, tiText, {TextTransparency = 0, Position = UDim2.new(0.5, 0, 0.5, 95)}):Play()
    TweenService:Create(SubtitleText, tiText, {TextTransparency = 0, Position = UDim2.new(0.5, 0, 0.5, 120)}):Play()

    task.wait(1.5)

    -- Secuencia de Salida
    local tiOut = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
    TweenService:Create(BG, tiOut, {BackgroundTransparency = 1}):Play()
    TweenService:Create(OuterStroke, tiOut, {Transparency = 1}):Play()
    TweenService:Create(InnerStroke, tiOut, {Transparency = 1}):Play()
    TweenService:Create(CenterLogo, tiOut, {ImageTransparency = 1, Size = UDim2.new(0, 220, 0, 220)}):Play()
    TweenService:Create(TitleText, tiOut, {TextTransparency = 1}):Play()
    TweenService:Create(SubtitleText, tiOut, {TextTransparency = 1}):Play()

    task.wait(0.45)
    if rotateConn then rotateConn:Disconnect() end
    AnimGui:Destroy()
    if onComplete then onComplete() end
end

-- ==========================================
-- BOTÓN FLOTANTE "V" (FONDO TRANSPARENTE + BORDE GRADIENTE CIAN/AZUL EN MOVIMIENTO)
-- ==========================================
local OpenButton = Instance.new("TextButton")
OpenButton.Name = "OpenButton"
OpenButton.Size = UDim2.new(0, 54, 0, 54)
OpenButton.Position = UDim2.new(0.04, 0, 0.38, 0)
OpenButton.BackgroundTransparency = 1
OpenButton.Text = ""
OpenButton.AutoButtonColor = false
OpenButton.Parent = VortexHub_NativeLauncher

local UICornerBtn = Instance.new("UICorner")
UICornerBtn.CornerRadius = UDim.new(0, 14)
UICornerBtn.Parent = OpenButton

local UIStrokeBtn = Instance.new("UIStroke")
UIStrokeBtn.Thickness = 2.8
UIStrokeBtn.Color = Color3.fromRGB(255, 255, 255)
UIStrokeBtn.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStrokeBtn.Parent = OpenButton

local StrokeGradientBtn = Instance.new("UIGradient")
StrokeGradientBtn.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 255)),   -- Cyan Neón
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 130, 255)), -- Azul Eléctrico
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 255))    -- Cyan Neón
})
StrokeGradientBtn.Rotation = 45
StrokeGradientBtn.Parent = UIStrokeBtn

local btnOffset = 0
local btnBorderConn
btnBorderConn = RunService.RenderStepped:Connect(function(dt)
    if OpenButton and OpenButton.Parent then
        btnOffset = (btnOffset + (0.6 * dt)) % 1
        StrokeGradientBtn.Offset = Vector2.new(btnOffset, 0)
        StrokeGradientBtn.Rotation = (StrokeGradientBtn.Rotation + (60 * dt)) % 360
    else
        if btnBorderConn then btnBorderConn:Disconnect() end
    end
end)

local VText = Instance.new("TextLabel")
VText.Name = "VText"
VText.Size = UDim2.new(1, 0, 1, 0)
VText.BackgroundTransparency = 1
VText.Font = Enum.Font.GothamBlack
VText.Text = "V"
VText.TextColor3 = Color3.fromRGB(255, 255, 255)
VText.TextSize = 26
VText.Parent = OpenButton

local VGradient = Instance.new("UIGradient")
VGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 220, 255))
})
VGradient.Rotation = 90
VGradient.Parent = VText

local VStroke = Instance.new("UIStroke")
VStroke.Thickness = 1.8
VStroke.Color = Color3.fromRGB(0, 200, 255)
VStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
VStroke.Parent = VText

OpenButton.MouseEnter:Connect(function()
    TweenService:Create(OpenButton, TweenInfo.new(0.2), {Size = UDim2.new(0, 58, 0, 58)}):Play()
end)
OpenButton.MouseLeave:Connect(function()
    TweenService:Create(OpenButton, TweenInfo.new(0.2), {Size = UDim2.new(0, 54, 0, 54)}):Play()
end)

-- ==========================================
-- VENTANA PRINCIPAL
-- ==========================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 500, 0, 360)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(3, 7, 14)
MainFrame.BackgroundTransparency = 0.22
MainFrame.Visible = false
MainFrame.Parent = VortexHub_NativeLauncher

local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0, 16)
UICornerMain.Parent = MainFrame

local UIStrokeMain = Instance.new("UIStroke")
UIStrokeMain.Thickness = 2
UIStrokeMain.Color = Color3.fromRGB(255, 255, 255)
UIStrokeMain.Transparency = 0.15
UIStrokeMain.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStrokeMain.Parent = MainFrame

local UIStrokeMainGrad = Instance.new("UIGradient")
UIStrokeMainGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 140, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 60, 200))
})
UIStrokeMainGrad.Rotation = 45
UIStrokeMainGrad.Parent = UIStrokeMain

local UIGradientMain = Instance.new("UIGradient")
UIGradientMain.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(5, 12, 22)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(2, 5, 10))
})
UIGradientMain.Rotation = 45
UIGradientMain.Parent = MainFrame

-- ==========================================
-- TOPBAR CON FPS Y LOGO
-- ==========================================
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 52)
TopBar.BackgroundTransparency = 1
TopBar.Parent = MainFrame

local HeaderLogo = Instance.new("ImageLabel")
HeaderLogo.Size = UDim2.new(0, 32, 0, 32)
HeaderLogo.Position = UDim2.new(0, 16, 0.5, -16)
HeaderLogo.BackgroundTransparency = 1
HeaderLogo.Image = "rbxassetid://136777157214137"
HeaderLogo.Parent = TopBar

local VortexTitle = Instance.new("TextLabel")
VortexTitle.Size = UDim2.new(0, 210, 1, 0)
VortexTitle.Position = UDim2.new(0, 56, 0, 0)
VortexTitle.BackgroundTransparency = 1
VortexTitle.Font = Enum.Font.GothamBold
VortexTitle.Text = "Vortex X System"
VortexTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
VortexTitle.TextSize = 15
VortexTitle.TextXAlignment = Enum.TextXAlignment.Left
VortexTitle.Parent = TopBar

local FPSBadge = Instance.new("Frame")
FPSBadge.Name = "FPSBadge"
FPSBadge.Size = UDim2.new(0, 80, 0, 22)
FPSBadge.Position = UDim2.new(1, -210, 0.5, -11)
FPSBadge.BackgroundColor3 = Color3.fromRGB(6, 16, 30)
FPSBadge.BackgroundTransparency = 0.3
FPSBadge.Parent = TopBar

local UICornerFPS = Instance.new("UICorner")
UICornerFPS.CornerRadius = UDim.new(0, 6)
UICornerFPS.Parent = FPSBadge

local UIStrokeFPS = Instance.new("UIStroke")
UIStrokeFPS.Thickness = 1
UIStrokeFPS.Color = Color3.fromRGB(0, 220, 255)
UIStrokeFPS.Transparency = 0.5
UIStrokeFPS.Parent = FPSBadge

local FPSLabel = Instance.new("TextLabel")
FPSLabel.Size = UDim2.new(1, 0, 1, 0)
FPSLabel.BackgroundTransparency = 1
FPSLabel.Font = Enum.Font.GothamBold
FPSLabel.Text = "⚡ 60 FPS"
FPSLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
FPSLabel.TextSize = 11
FPSLabel.Parent = FPSBadge

local AuthorLabel = Instance.new("TextLabel")
AuthorLabel.Size = UDim2.new(0, 115, 1, 0)
AuthorLabel.Position = UDim2.new(1, -125, 0, 0)
AuthorLabel.BackgroundTransparency = 1
AuthorLabel.Font = Enum.Font.GothamMedium
AuthorLabel.Text = "by ISRAEL CC"
AuthorLabel.TextColor3 = Color3.fromRGB(0, 220, 255)
AuthorLabel.TextSize = 12
AuthorLabel.TextXAlignment = Enum.TextXAlignment.Right
AuthorLabel.Parent = TopBar

local DividerLine = Instance.new("Frame")
DividerLine.Size = UDim2.new(1, -32, 0, 1)
DividerLine.Position = UDim2.new(0, 16, 0, 52)
DividerLine.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
DividerLine.BackgroundTransparency = 0.7
DividerLine.BorderSizePixel = 0
DividerLine.Parent = MainFrame

local FrameTimes = {}
local fpsConnection
fpsConnection = RunService.RenderStepped:Connect(function()
    local now = os.clock()
    table.insert(FrameTimes, now)
    
    while FrameTimes[1] and FrameTimes[1] < now - 1 do
        table.remove(FrameTimes, 1)
    end
    
    if MainFrame and MainFrame.Parent then
        FPSLabel.Text = "⚡ " .. tostring(#FrameTimes) .. " FPS"
    else
        if fpsConnection then fpsConnection:Disconnect() end
    end
end)

-- ==========================================
-- SCROLLING FRAME
-- ==========================================
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(1, -32, 1, -72)
ScrollingFrame.Position = UDim2.new(0, 16, 0, 62)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 380)
ScrollingFrame.ScrollBarThickness = 3
ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 220, 255)
ScrollingFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.Parent = ScrollingFrame

-- ==========================================
-- COMPONENTES DE BOTONES (SEPARADOS)
-- ==========================================

-- 1. Para Scripts (Ejecuta animación y destruye el launcher)
local function createScriptButton(layoutOrder, title, description, callbackAction)
    local Button = Instance.new("TextButton")
    Button.Name = title
    Button.Size = UDim2.new(1, 0, 0, 52)
    Button.BackgroundColor3 = Color3.fromRGB(6, 15, 28)
    Button.BackgroundTransparency = 0.25
    Button.AutoButtonColor = false
    Button.Text = ""
    Button.LayoutOrder = layoutOrder
    Button.Parent = ScrollingFrame

    local UICornerBtnBox = Instance.new("UICorner")
    UICornerBtnBox.CornerRadius = UDim.new(0, 10)
    UICornerBtnBox.Parent = Button

    local UIStrokeBtnBox = Instance.new("UIStroke")
    UIStrokeBtnBox.Thickness = 1.2
    UIStrokeBtnBox.Color = Color3.fromRGB(255, 255, 255)
    UIStrokeBtnBox.Transparency = 0.4
    UIStrokeBtnBox.Parent = Button

    local BtnStrokeGrad = Instance.new("UIGradient")
    BtnStrokeGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 110, 255))
    })
    BtnStrokeGrad.Rotation = 45
    BtnStrokeGrad.Parent = UIStrokeBtnBox

    local TitleLbl = Instance.new("TextLabel")
    TitleLbl.Size = UDim2.new(1, -20, 0, 20)
    TitleLbl.Position = UDim2.new(0, 12, 0, 7)
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Font = Enum.Font.GothamBold
    TitleLbl.Text = title
    TitleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLbl.TextSize = 14
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    TitleLbl.Parent = Button

    local DescLbl = Instance.new("TextLabel")
    DescLbl.Size = UDim2.new(1, -20, 0, 16)
    DescLbl.Position = UDim2.new(0, 12, 0, 27)
    DescLbl.BackgroundTransparency = 1
    DescLbl.Font = Enum.Font.Gotham
    DescLbl.Text = description
    DescLbl.TextColor3 = Color3.fromRGB(160, 175, 195)
    DescLbl.TextSize = 11
    DescLbl.TextXAlignment = Enum.TextXAlignment.Left
    DescLbl.Parent = Button

    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.05,
            BackgroundColor3 = Color3.fromRGB(0, 110, 255)
        }):Play()
        TweenService:Create(UIStrokeBtnBox, TweenInfo.new(0.2), {Transparency = 0.1}):Play()
    end)

    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.25,
            BackgroundColor3 = Color3.fromRGB(6, 15, 28)
        }):Play()
        TweenService:Create(UIStrokeBtnBox, TweenInfo.new(0.2), {Transparency = 0.4}):Play()
    end)

    Button.MouseButton1Click:Connect(function()
        if callbackAction then
            MainFrame.Visible = false
            pcall(function()
                VortexHub_NativeLauncher:Destroy()
            end)

            playLaunchAnimation(function()
                callbackAction()
            end)
        end
    end)

    return Button
end

-- 2. Para Utilidades / Enlaces (NO cierra el launcher ni muestra animación)
local function createUtilityButton(layoutOrder, title, description, callbackAction)
    local Button = Instance.new("TextButton")
    Button.Name = title
    Button.Size = UDim2.new(1, 0, 0, 52)
    Button.BackgroundColor3 = Color3.fromRGB(6, 15, 28)
    Button.BackgroundTransparency = 0.25
    Button.AutoButtonColor = false
    Button.Text = ""
    Button.LayoutOrder = layoutOrder
    Button.Parent = ScrollingFrame

    local UICornerBtnBox = Instance.new("UICorner")
    UICornerBtnBox.CornerRadius = UDim.new(0, 10)
    UICornerBtnBox.Parent = Button

    local UIStrokeBtnBox = Instance.new("UIStroke")
    UIStrokeBtnBox.Thickness = 1.2
    UIStrokeBtnBox.Color = Color3.fromRGB(255, 255, 255)
    UIStrokeBtnBox.Transparency = 0.4
    UIStrokeBtnBox.Parent = Button

    local BtnStrokeGrad = Instance.new("UIGradient")
    BtnStrokeGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 110, 255))
    })
    BtnStrokeGrad.Rotation = 45
    BtnStrokeGrad.Parent = UIStrokeBtnBox

    local TitleLbl = Instance.new("TextLabel")
    TitleLbl.Size = UDim2.new(1, -20, 0, 20)
    TitleLbl.Position = UDim2.new(0, 12, 0, 7)
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Font = Enum.Font.GothamBold
    TitleLbl.Text = title
    TitleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLbl.TextSize = 14
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    TitleLbl.Parent = Button

    local DescLbl = Instance.new("TextLabel")
    DescLbl.Size = UDim2.new(1, -20, 0, 16)
    DescLbl.Position = UDim2.new(0, 12, 0, 27)
    DescLbl.BackgroundTransparency = 1
    DescLbl.Font = Enum.Font.Gotham
    DescLbl.Text = description
    DescLbl.TextColor3 = Color3.fromRGB(160, 175, 195)
    DescLbl.TextSize = 11
    DescLbl.TextXAlignment = Enum.TextXAlignment.Left
    DescLbl.Parent = Button

    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.05,
            BackgroundColor3 = Color3.fromRGB(0, 110, 255)
        }):Play()
        TweenService:Create(UIStrokeBtnBox, TweenInfo.new(0.2), {Transparency = 0.1}):Play()
    end)

    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.25,
            BackgroundColor3 = Color3.fromRGB(6, 15, 28)
        }):Play()
        TweenService:Create(UIStrokeBtnBox, TweenInfo.new(0.2), {Transparency = 0.4}):Play()
    end)

    Button.MouseButton1Click:Connect(function()
        if callbackAction then
            callbackAction()
        end
    end)

    return Button
end

-- ==========================================
-- LISTA DE BOTONES
-- ==========================================

-- 1. VortexHub Duels (SCRIPT -> Con animación)
createScriptButton(1, "VortexHub Duels", "Carga la versión de Duels con Aim Assist, Hitbox y ESP", function()
    task.spawn(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/vortex-x-system/vortex-x-scripts/refs/heads/main/Vortex-Duels/Vortex.lua"))()
    end)
end)

-- 2. VortexHub MM2 (SCRIPT -> Con animación)
createScriptButton(2, "VortexHub MM2", "Carga las funciones para Murder Mystery 2 (Silent Aim, ESP, etc.)", function()
    task.spawn(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/vortex-x-system/vortex-x-scripts/refs/heads/main/Vortex-MM2/Vortex.lua"))()
    end)
end)

-- 3. VortexHub Kaiju Alpha (Reservado)
createScriptButton(3, "VortexHub Kaiju Alpha", "Espacio reservado para el próximo lanzamiento", nil)

-- 4. Hospital de Animales (Reservado)
createScriptButton(4, "Hospital de Animales", "Carga el script para Hospital de Animales", nil)

-- 5. Copiar Link de Discord (UTILIDAD -> Solo copia, sin animación)
createUtilityButton(5, "Copiar Link de Discord", "Copia el enlace de invitación al portapapeles", function()
    pcall(function()
        setclipboard("https://discord.gg/Fn74MpzFUn")
    end)
end)

-- 6. Sitio Web Oficial (UTILIDAD -> Solo copia, sin animación)
createUtilityButton(6, "Sitio Web Oficial", "Copia el enlace del sitio web al portapapeles", function()
    pcall(function()
        setclipboard("https://vortex-x-system.netlify.app/")
    end)
end)

-- ==========================================
-- CONTROL DE APERTURA Y CIERRE (TOGGLE)
-- ==========================================
local isOpened = false

OpenButton.MouseButton1Click:Connect(function()
    isOpened = not isOpened
    if isOpened then
        MainFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 500, 0, 360)
        }):Play()
    else
        local closeTween = TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0)
        })
        closeTween:Play()
        closeTween.Completed:Connect(function()
            if not isOpened then
                MainFrame.Visible = false
            end
        end)
    end
end)
