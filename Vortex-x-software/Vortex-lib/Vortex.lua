--[[
    NovaUI v5
    WindUI style - OpenButton interno, subtitle abajo, gradient setup
]]

local NovaUI = {}
NovaUI.__index = NovaUI
NovaUI.Version = "5.0.0"

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local IsMobile = UserInputService.TouchEnabled

-- ==================== WINDUI ICONS ====================
local IconLib
do
    local ok, res = pcall(function()
        return loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Footagesus/Icons/main/Main-v2.lua"))()
    end)
    if ok and res then
        IconLib = res
        pcall(function()
            if IconLib.SetIconsType then IconLib.SetIconsType("lucide") end
        end)
    end
end

local function ResolveIcon(name)
    if not name then return nil, nil, nil end
    if typeof(name) == "string" and string.find(name, "rbxassetid://") then
        return name, nil, nil
    end
    if not IconLib then return nil, nil, nil end
    name = tostring(name)
    local ok, data = pcall(function()
        if IconLib.GetIcon then return IconLib.GetIcon(name) end
        if IconLib.Icon then return IconLib.Icon(name) end
        return nil
    end)
    if not ok or not data then return nil, nil, nil end
    if typeof(data) == "string" then return data, nil, nil end
    if typeof(data) == "table" then
        local img = data[1] or data.Image or data.image
        local meta = data[2] or data
        local rectSize = meta and (meta.ImageRectSize or meta.imageRectSize)
        local rectPos = meta and (meta.ImageRectOffset or meta.ImageRectPosition or meta.imageRectOffset)
        return img, rectSize, rectPos
    end
    return nil, nil, nil
end

local function ApplyIcon(imageObj, name, color)
    local img, rectSize, rectPos = ResolveIcon(name)
    if not img then imageObj.Image = "" return false end
    imageObj.Image = img
    if color then imageObj.ImageColor3 = color end
    imageObj.ImageRectSize = (rectSize and typeof(rectSize) == "Vector2") and rectSize or Vector2.new(0, 0)
    imageObj.ImageRectOffset = (rectPos and typeof(rectPos) == "Vector2") and rectPos or Vector2.new(0, 0)
    return true
end

local function HexToColor3(hex)
    if typeof(hex) == "Color3" then return hex end
    if typeof(hex) \~= "string" then return Color3.fromRGB(0, 145, 255) end
    hex = hex:gsub("#", "")
    if #hex == 3 then
        hex = hex:sub(1,1)..hex:sub(1,1)..hex:sub(2,2)..hex:sub(2,2)..hex:sub(3,3)..hex:sub(3,3)
    end
    local r = tonumber(hex:sub(1, 2), 16) or 0
    local g = tonumber(hex:sub(3, 4), 16) or 0
    local b = tonumber(hex:sub(5, 6), 16) or 0
    return Color3.fromRGB(r, g, b)
end

local function IsImageSource(v)
    if not v then return false end
    if typeof(v) \~= "string" then return false end
    if string.find(v, "rbxassetid://") then return true end
    if string.match(v, "^%d+$") then return true end
    return false
end

local function ToAssetId(v)
    if not v then return nil end
    if string.find(tostring(v), "rbxassetid://") then return tostring(v) end
    if string.match(tostring(v), "^%d+$") then return "rbxassetid://" .. tostring(v) end
    return nil
end

-- ==================== THEME ====================
local Theme = {
    Background   = Color3.fromRGB(16, 16, 20),
    Sidebar      = Color3.fromRGB(20, 20, 26),
    TitleBar     = Color3.fromRGB(22, 22, 28),
    Panel        = Color3.fromRGB(26, 26, 34),
    Element      = Color3.fromRGB(30, 30, 38),
    ElementHover = Color3.fromRGB(38, 38, 48),
    Accent       = Color3.fromRGB(0, 145, 255),
    Text         = Color3.fromRGB(245, 245, 250),
    TextDim      = Color3.fromRGB(130, 130, 145),
    TextMuted    = Color3.fromRGB(100, 100, 115),
    Stroke       = Color3.fromRGB(38, 38, 48),
    ToggleOff    = Color3.fromRGB(46, 46, 56),
    ToggleOn     = Color3.fromRGB(0, 145, 255),
}

local function Tween(obj, props, t)
    TweenService:Create(obj, TweenInfo.new(t or 0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props):Play()
end

local function Corner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 10)
    c.Parent = p
    return c
end

local function Stroke(p, color, th)
    local s = Instance.new("UIStroke")
    s.Color = color or Theme.Stroke
    s.Thickness = th or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = p
    return s
end

local function Padding(p, t, b, l, r)
    local x = Instance.new("UIPadding")
    x.PaddingTop = UDim.new(0, t or 0)
    x.PaddingBottom = UDim.new(0, b or 0)
    x.PaddingLeft = UDim.new(0, l or 0)
    x.PaddingRight = UDim.new(0, r or 0)
    x.Parent = p
    return x
end

local function ApplyGradient(parent, colors, rotation)
    if not colors or #colors < 2 then return end
    local g = Instance.new("UIGradient")
    local c1 = HexToColor3(colors[1])
    local c2 = HexToColor3(colors[2])
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, c1),
        ColorSequenceKeypoint.new(1, c2),
    })
    g.Rotation = rotation or 90
    g.Parent = parent
    return g
end

-- ==================== NOTIFY ====================
local NotifyGui, NotifyHolder

local function EnsureNotify()
    if NotifyHolder and NotifyHolder.Parent then return end
    NotifyGui = Instance.new("ScreenGui")
    NotifyGui.Name = "NovaUI_Notify"
    NotifyGui.ResetOnSpawn = false
    NotifyGui.IgnoreGuiInset = true
    NotifyGui.DisplayOrder = 1000
    NotifyGui.Parent = PlayerGui

    NotifyHolder = Instance.new("Frame")
    NotifyHolder.AnchorPoint = Vector2.new(1, 0)
    NotifyHolder.Position = UDim2.new(1, -16, 0, 16)
    NotifyHolder.Size = UDim2.new(0, 300, 1, -32)
    NotifyHolder.BackgroundTransparency = 1
    NotifyHolder.Parent = NotifyGui

    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 10)
    list.HorizontalAlignment = Enum.HorizontalAlignment.Right
    list.Parent = NotifyHolder
end

function NovaUI:Notify(cfg)
    EnsureNotify()
    cfg = cfg or {}
    local card = Instance.new("Frame")
    card.AutomaticSize = Enum.AutomaticSize.Y
    card.Size = UDim2.new(1, 0, 0, 0)
    card.BackgroundColor3 = Theme.Panel
    card.BackgroundTransparency = 1
    card.Parent = NotifyHolder
    Corner(card, 12)
    local st = Stroke(card)
    Padding(card, 14, 14, 16, 16)

    local accent = Instance.new("Frame")
    accent.Size = UDim2.new(0, 3, 1, 0)
    accent.BackgroundColor3 = Theme.Accent
    accent.BorderSizePixel = 0
    accent.Parent = card
    Corner(accent, 2)

    local t = Instance.new("TextLabel")
    t.BackgroundTransparency = 1
    t.Position = UDim2.new(0, 10, 0, 0)
    t.Size = UDim2.new(1, -10, 0, 18)
    t.Font = Enum.Font.GothamBold
    t.TextSize = 14
    t.TextColor3 = Theme.Text
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.Text = cfg.Title or "Notify"
    t.Parent = card

    local d = Instance.new("TextLabel")
    d.BackgroundTransparency = 1
    d.Position = UDim2.new(0, 10, 0, 22)
    d.AutomaticSize = Enum.AutomaticSize.Y
    d.Size = UDim2.new(1, -10, 0, 0)
    d.Font = Enum.Font.Gotham
    d.TextSize = 12
    d.TextColor3 = Theme.TextDim
    d.TextXAlignment = Enum.TextXAlignment.Left
    d.TextWrapped = true
    d.Text = cfg.Content or ""
    d.Parent = card

    Tween(card, { BackgroundTransparency = 0 }, 0.22)
    task.delay(cfg.Duration or 3, function()
        if not card or not card.Parent then return end
        Tween(card, { BackgroundTransparency = 1 }, 0.2)
        if st then Tween(st, { Transparency = 1 }, 0.2) end
        task.wait(0.2)
        card:Destroy()
    end)
end

-- ==================== OPEN BUTTON (interno, estilo WindUI) ====================
local function CreateOpenButton(parent, cfg, onOpen)
    -- cfg: Text, Icon, Image, Gradient, Position
    local useImage = false
    local imageSrc = nil

    if cfg.Image and IsImageSource(tostring(cfg.Image)) then
        useImage = true
        imageSrc = ToAssetId(cfg.Image) or tostring(cfg.Image)
    elseif cfg.Icon and IsImageSource(tostring(cfg.Icon)) then
        useImage = true
        imageSrc = ToAssetId(cfg.Icon) or tostring(cfg.Icon)
    elseif cfg.Icon and ResolveIcon(cfg.Icon) then
        useImage = true
        -- icon name from WindUI pack
        imageSrc = nil -- se aplica con ApplyIcon
    end

    -- Si hay Text y no forzaron imagen, modo texto largo
    local forceText = (cfg.Mode == "Text") or (cfg.Text and cfg.Mode \~= "Image" and not cfg.Image)

    local btn = Instance.new("ImageButton")
    btn.Name = "NovaOpenButton"
    btn.AutoButtonColor = false
    btn.BorderSizePixel = 0
    btn.Visible = false
    btn.Parent = parent

    if forceText and cfg.Text and cfg.Text \~= "" and not cfg.Image then
        -- Modo TEXTO: largo, fondo semi-transparente
        btn.Size = cfg.Size or UDim2.new(0, 130, 0, 40)
        btn.Position = cfg.Position or UDim2.new(0, 16, 1, -64)
        btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        btn.BackgroundTransparency = 0.15
        Corner(btn, 12)
        Stroke(btn, Color3.fromRGB(255, 255, 255), 1)

        if cfg.Gradient and #cfg.Gradient >= 2 then
            ApplyGradient(btn, cfg.Gradient, cfg.GradientRotation or 0)
            btn.BackgroundTransparency = 0.1
        else
            btn.BackgroundColor3 = Theme.Panel
            btn.BackgroundTransparency = 0.25
        end

        local label = Instance.new("TextLabel")
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, -16, 1, 0)
        label.Position = UDim2.new(0, 8, 0, 0)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 13
        label.TextColor3 = Theme.Text
        label.Text = cfg.Text
        label.Parent = btn
    else
        -- Modo IMAGEN: cuadrado
        local side = 50
        if cfg.Size then
            btn.Size = cfg.Size
        else
            btn.Size = UDim2.new(0, side, 0, side)
        end
        btn.Position = cfg.Position or UDim2.new(0, 16, 1, -72)
        btn.BackgroundColor3 = Theme.Panel
        btn.BackgroundTransparency = 0.1
        Corner(btn, 14)
        Stroke(btn, Theme.Stroke, 1)

        if cfg.Gradient and #cfg.Gradient >= 2 then
            ApplyGradient(btn, cfg.Gradient, cfg.GradientRotation or 45)
            btn.BackgroundTransparency = 0
        end

        local img = Instance.new("ImageLabel")
        img.BackgroundTransparency = 1
        img.AnchorPoint = Vector2.new(0.5, 0.5)
        img.Position = UDim2.new(0.5, 0, 0.5, 0)
        img.Size = UDim2.new(0, 24, 0, 24)
        img.Parent = btn

        if imageSrc and string.find(imageSrc, "rbxassetid://") then
            img.Image = imageSrc
            img.ImageColor3 = Color3.fromRGB(255, 255, 255)
        else
            ApplyIcon(img, cfg.Icon or "menu", Color3.fromRGB(255, 255, 255))
        end
    end

    -- drag
    local dragging, dStart, pStart
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dStart = input.Position
            pStart = btn.Position
        end
    end)
    btn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dStart
            btn.Position = UDim2.new(pStart.X.Scale, pStart.X.Offset + d.X, pStart.Y.Scale, pStart.Y.Offset + d.Y)
        end
    end)

    btn.MouseButton1Click:Connect(function()
        if onOpen then onOpen() end
    end)

    return btn
end

-- ==================== WINDOW ====================
function NovaUI:CreateWindow(cfg)
    cfg = cfg or {}
    local title = cfg.Title or "NovaUI"
    local subTitle = cfg.SubTitle or cfg.Author or ""
    local toggleKey = cfg.ToggleKey or Enum.KeyCode.RightControl

    -- OpenButton config (opcional en setup; si no hay, defaults internos)
    local openCfg = cfg.OpenButton or {}
    if openCfg.Enabled == nil then openCfg.Enabled = true end
    openCfg.Text = openCfg.Text or title
    openCfg.Icon = openCfg.Icon or cfg.Icon or "menu"
    openCfg.Image = openCfg.Image
    openCfg.Gradient = openCfg.Gradient -- ej: {"#FF0000", "#FF8800"}
    openCfg.GradientRotation = openCfg.GradientRotation or 45
    openCfg.Mode = openCfg.Mode -- "Image" | "Text" | nil auto
    openCfg.Position = openCfg.Position or UDim2.new(0, 16, 1, -72)
    openCfg.Size = openCfg.Size

    local SIZE_NORMAL = IsMobile and UDim2.new(0.94, 0, 0, 430) or UDim2.new(0, 650, 0, 430)
    local SIZE_MINI   = IsMobile and UDim2.new(0.94, 0, 0, 52) or UDim2.new(0, 650, 0, 52)
    local SIZE_MAX    = IsMobile and UDim2.new(0.96, 0, 0.85, 0) or UDim2.new(0, 940, 0, 590)
    local SIDE_W      = IsMobile and 58 or 172
    local TITLE_H     = 54

    local old = PlayerGui:FindFirstChild("NovaUI_Window")
    if old then old:Destroy() end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NovaUI_Window"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = PlayerGui

    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.Size = SIZE_NORMAL
    Main.BackgroundColor3 = Theme.Background
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    Main.Parent = ScreenGui
    Corner(Main, 16)
    Stroke(Main)

    -- Title bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, TITLE_H)
    TitleBar.BackgroundColor3 = Theme.TitleBar
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = Main
    Corner(TitleBar, 16)

    local titleFix = Instance.new("Frame")
    titleFix.BackgroundColor3 = Theme.TitleBar
    titleFix.BorderSizePixel = 0
    titleFix.Position = UDim2.new(0, 0, 1, -16)
    titleFix.Size = UDim2.new(1, 0, 0, 16)
    titleFix.Parent = TitleBar

    local WinIcon = Instance.new("ImageLabel")
    WinIcon.BackgroundTransparency = 1
    WinIcon.Position = UDim2.new(0, 16, 0.5, -10)
    WinIcon.Size = UDim2.new(0, 20, 0, 20)
    WinIcon.Parent = TitleBar
    ApplyIcon(WinIcon, cfg.Icon or "menu", Theme.Accent)

    -- Title + Subtitle (subtitle ABAJO, color más bajo)
    local TitleWrap = Instance.new("Frame")
    TitleWrap.BackgroundTransparency = 1
    TitleWrap.Position = UDim2.new(0, 44, 0, 0)
    TitleWrap.Size = UDim2.new(1, -150, 1, 0)
    TitleWrap.Parent = TitleBar

    local TitleLbl = Instance.new("TextLabel")
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Position = UDim2.new(0, 0, 0, subTitle \~= "" and 8 or 0)
    TitleLbl.Size = UDim2.new(1, 0, 0, subTitle \~= "" and 18 or TITLE_H)
    TitleLbl.Font = Enum.Font.GothamBold
    TitleLbl.TextSize = 14
    TitleLbl.TextColor3 = Theme.Text
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    TitleLbl.TextYAlignment = Enum.TextYAlignment.Center
    TitleLbl.Text = title
    TitleLbl.Parent = TitleWrap

    if subTitle \~= "" then
        local SubLbl = Instance.new("TextLabel")
        SubLbl.BackgroundTransparency = 1
        SubLbl.Position = UDim2.new(0, 0, 0, 26)
        SubLbl.Size = UDim2.new(1, 0, 0, 16)
        SubLbl.Font = Enum.Font.Gotham
        SubLbl.TextSize = 11
        SubLbl.TextColor3 = Theme.TextMuted
        SubLbl.TextXAlignment = Enum.TextXAlignment.Left
        SubLbl.Text = subTitle
        SubLbl.Parent = TitleWrap
    end

    -- Controls: min max close
    local Controls = Instance.new("Frame")
    Controls.AnchorPoint = Vector2.new(1, 0.5)
    Controls.Position = UDim2.new(1, -12, 0.5, 0)
    Controls.Size = UDim2.new(0, 96, 0, 28)
    Controls.BackgroundTransparency = 1
    Controls.Parent = TitleBar

    local cl = Instance.new("UIListLayout")
    cl.FillDirection = Enum.FillDirection.Horizontal
    cl.HorizontalAlignment = Enum.HorizontalAlignment.Right
    cl.VerticalAlignment = Enum.VerticalAlignment.Center
    cl.Padding = UDim.new(0, 6)
    cl.Parent = Controls

    local function IconBtn(iconName, hoverColor)
        local b = Instance.new("ImageButton")
        b.Size = UDim2.new(0, 28, 0, 28)
        b.BackgroundColor3 = Theme.Element
        b.BorderSizePixel = 0
        b.AutoButtonColor = false
        b.Parent = Controls
        Corner(b, 8)
        local img = Instance.new("ImageLabel")
        img.BackgroundTransparency = 1
        img.AnchorPoint = Vector2.new(0.5, 0.5)
        img.Position = UDim2.new(0.5, 0, 0.5, 0)
        img.Size = UDim2.new(0, 14, 0, 14)
        img.Parent = b
        ApplyIcon(img, iconName, Theme.TextDim)
        b.MouseEnter:Connect(function()
            Tween(b, { BackgroundColor3 = hoverColor or Theme.ElementHover }, 0.12)
            Tween(img, { ImageColor3 = Theme.Text }, 0.12)
        end)
        b.MouseLeave:Connect(function()
            Tween(b, { BackgroundColor3 = Theme.Element }, 0.12)
            Tween(img, { ImageColor3 = Theme.TextDim }, 0.12)
        end)
        return b, img
    end

    local MinBtn = IconBtn("minus", Theme.ElementHover)
    local MaxBtn, MaxImg = IconBtn("maximize-2", Theme.ElementHover)
    local CloseBtn = IconBtn("x", Color3.fromRGB(60, 28, 32))

    local Body = Instance.new("Frame")
    Body.Position = UDim2.new(0, 0, 0, TITLE_H)
    Body.Size = UDim2.new(1, 0, 1, -TITLE_H)
    Body.BackgroundTransparency = 1
    Body.Parent = Main

    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, SIDE_W, 1, 0)
    Sidebar.BackgroundColor3 = Theme.Sidebar
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = Body

    local sideLine = Instance.new("Frame")
    sideLine.AnchorPoint = Vector2.new(1, 0)
    sideLine.Position = UDim2.new(1, 0, 0, 0)
    sideLine.Size = UDim2.new(0, 1, 1, 0)
    sideLine.BackgroundColor3 = Theme.Stroke
    sideLine.BorderSizePixel = 0
    sideLine.Parent = Sidebar

    local TabList = Instance.new("ScrollingFrame")
    TabList.Position = UDim2.new(0, 10, 0, 10)
    TabList.Size = UDim2.new(1, -20, 1, -20)
    TabList.BackgroundTransparency = 1
    TabList.BorderSizePixel = 0
    TabList.ScrollBarThickness = 2
    TabList.ScrollBarImageColor3 = Theme.Accent
    TabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabList.Parent = Sidebar

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Padding = UDim.new(0, 6)
    TabLayout.Parent = TabList

    local Content = Instance.new("Frame")
    Content.Position = UDim2.new(0, SIDE_W + 12, 0, 12)
    Content.Size = UDim2.new(1, -(SIDE_W + 24), 1, -24)
    Content.BackgroundTransparency = 1
    Content.Parent = Body

    local state = {
        minimized = false,
        maximized = false,
        hidden = false,
        lastSize = SIZE_NORMAL,
        lastPos = Main.Position,
    }

    local dragging, dragStart, startPos
    TitleBar.InputBegan:Connect(function(input)
        if state.maximized then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)
    TitleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)

    local OpenBtn
    local function SetMainVisible(vis)
        Main.Visible = vis
        if OpenBtn then OpenBtn.Visible = not vis end
    end

    local function HideUI()
        state.hidden = true
        SetMainVisible(false)
    end

    local function ShowUI()
        state.hidden = false
        SetMainVisible(true)
    end

    -- OpenButton INTERNO (siempre si Enabled)
    if openCfg.Enabled then
        OpenBtn = CreateOpenButton(ScreenGui, openCfg, ShowUI)
    end

    MinBtn.MouseButton1Click:Connect(function()
        state.minimized = not state.minimized
        if state.minimized then
            state.lastSize = Main.Size
            Body.Visible = false
            Tween(Main, { Size = SIZE_MINI }, 0.25)
        else
            Body.Visible = true
            Tween(Main, { Size = state.maximized and SIZE_MAX or state.lastSize }, 0.25)
        end
    end)

    MaxBtn.MouseButton1Click:Connect(function()
        if state.minimized then return end
        state.maximized = not state.maximized
        if state.maximized then
            state.lastSize = Main.Size
            state.lastPos = Main.Position
            Tween(Main, { Size = SIZE_MAX, Position = UDim2.new(0.5, 0, 0.5, 0) }, 0.25)
            ApplyIcon(MaxImg, "minimize", Theme.TextDim)
        else
            Tween(Main, { Size = state.lastSize, Position = state.lastPos }, 0.25)
            ApplyIcon(MaxImg, "maximize-2", Theme.TextDim)
        end
    end)

    -- Cerrar = ocultar + boton abrir (como WindUI)
    CloseBtn.MouseButton1Click:Connect(function()
        HideUI()
    end)

    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == toggleKey then
            if state.hidden then ShowUI() else HideUI() end
        end
    end)

    local WindowObj = {
        _tabs = {},
        Show = ShowUI,
        Hide = HideUI,
        Destroy = function()
            ScreenGui:Destroy()
            if NotifyGui then NotifyGui:Destroy() NotifyGui = nil NotifyHolder = nil end
        end,
    }

    function WindowObj:Tab(tabCfg)
        tabCfg = tabCfg or {}
        local tabTitle = tabCfg.Title or "Tab"
        local iconName = tabCfg.Icon

        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, IsMobile and 44 or 40)
        TabBtn.BackgroundTransparency = 1
        TabBtn.BorderSizePixel = 0
        TabBtn.AutoButtonColor = false
        TabBtn.Text = ""
        TabBtn.Parent = TabList
        Corner(TabBtn, 10)

        local IconImg = Instance.new("ImageLabel")
        IconImg.BackgroundTransparency = 1
        IconImg.Size = UDim2.new(0, 18, 0, 18)
        if IsMobile then
            IconImg.AnchorPoint = Vector2.new(0.5, 0.5)
            IconImg.Position = UDim2.new(0.5, 0, 0.5, 0)
        else
            IconImg.Position = UDim2.new(0, 12, 0.5, -9)
        end
        IconImg.Parent = TabBtn
        local hasIcon = ApplyIcon(IconImg, iconName, Theme.TextDim)
        IconImg.Visible = hasIcon

        local TabText = Instance.new("TextLabel")
        TabText.BackgroundTransparency = 1
        TabText.Position = UDim2.new(0, hasIcon and 38 or 12, 0, 0)
        TabText.Size = UDim2.new(1, -44, 1, 0)
        TabText.Font = Enum.Font.GothamMedium
        TabText.TextSize = 13
        TabText.TextColor3 = Theme.TextDim
        TabText.TextXAlignment = Enum.TextXAlignment.Left
        TabText.Text = tabTitle
        TabText.Visible = not IsMobile
        TabText.Parent = TabBtn

        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.BorderSizePixel = 0
        Page.ScrollBarThickness = 3
        Page.ScrollBarImageColor3 = Theme.Accent
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Page.Visible = false
        Page.Parent = Content

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Padding = UDim.new(0, 10)
        PageLayout.Parent = Page
        Padding(Page, 2, 8, 2, 2)

        local function Select()
            for _, t in ipairs(WindowObj._tabs) do
                t.Page.Visible = false
                t.Btn.BackgroundTransparency = 1
                t.Text.TextColor3 = Theme.TextDim
                if t.Icon then Tween(t.Icon, { ImageColor3 = Theme.TextDim }, 0.15) end
            end
            Page.Visible = true
            TabBtn.BackgroundTransparency = 0
            TabBtn.BackgroundColor3 = Theme.Element
            TabText.TextColor3 = Theme.Text
            if hasIcon then Tween(IconImg, { ImageColor3 = Theme.Accent }, 0.15) end
        end

        TabBtn.MouseButton1Click:Connect(Select)
        local TabObj = { Btn = TabBtn, Page = Page, Text = TabText, Icon = IconImg }

        function TabObj:Section(opt)
            local h = Instance.new("Frame")
            h.Size = UDim2.new(1, 0, 0, 20)
            h.BackgroundTransparency = 1
            h.Parent = Page
            local l = Instance.new("TextLabel")
            l.BackgroundTransparency = 1
            l.Size = UDim2.new(1, 0, 1, 0)
            l.Font = Enum.Font.GothamBold
            l.TextSize = 11
            l.TextColor3 = Theme.Accent
            l.TextXAlignment = Enum.TextXAlignment.Left
            l.Text = string.upper((opt and opt.Title) or "SECTION")
            l.Parent = h
        end

        function TabObj:Toggle(opt)
            opt = opt or {}
            local on = opt.Value or false
            local cb = opt.Callback or function() end
            local Row = Instance.new("Frame")
            Row.Size = UDim2.new(1, 0, 0, IsMobile and 48 or 44)
            Row.BackgroundColor3 = Theme.Element
            Row.BorderSizePixel = 0
            Row.Parent = Page
            Corner(Row, 12)
            Stroke(Row)
            local Lbl = Instance.new("TextLabel")
            Lbl.BackgroundTransparency = 1
            Lbl.Position = UDim2.new(0, 14, 0, 0)
            Lbl.Size = UDim2.new(1, -72, 1, 0)
            Lbl.Font = Enum.Font.GothamMedium
            Lbl.TextSize = 13
            Lbl.TextColor3 = Theme.Text
            Lbl.TextXAlignment = Enum.TextXAlignment.Left
            Lbl.Text = opt.Title or "Toggle"
            Lbl.Parent = Row
            local Track = Instance.new("Frame")
            Track.AnchorPoint = Vector2.new(1, 0.5)
            Track.Position = UDim2.new(1, -14, 0.5, 0)
            Track.Size = UDim2.new(0, 42, 0, 24)
            Track.BackgroundColor3 = on and Theme.ToggleOn or Theme.ToggleOff
            Track.BorderSizePixel = 0
            Track.Parent = Row
            Corner(Track, 12)
            local Knob = Instance.new("Frame")
            Knob.Size = UDim2.new(0, 18, 0, 18)
            Knob.Position = on and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
            Knob.BackgroundColor3 = Theme.Text
            Knob.BorderSizePixel = 0
            Knob.Parent = Track
            Corner(Knob, 9)
            local Hit = Instance.new("TextButton")
            Hit.Size = UDim2.new(1, 0, 1, 0)
            Hit.BackgroundTransparency = 1
            Hit.Text = ""
            Hit.Parent = Row
            Hit.MouseButton1Click:Connect(function()
                on = not on
                Tween(Track, { BackgroundColor3 = on and Theme.ToggleOn or Theme.ToggleOff }, 0.18)
                Tween(Knob, { Position = on and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9) }, 0.18)
                task.spawn(cb, on)
            end)
        end

        function TabObj:Button(opt)
            opt = opt or {}
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, 0, 0, IsMobile and 46 or 42)
            Btn.BackgroundColor3 = Theme.Element
            Btn.BorderSizePixel = 0
            Btn.AutoButtonColor = false
            Btn.Font = Enum.Font.GothamMedium
            Btn.TextSize = 13
            Btn.TextColor3 = Theme.Text
            Btn.Text = opt.Title or "Button"
            Btn.Parent = Page
            Corner(Btn, 12)
            Stroke(Btn)
            Btn.MouseButton1Click:Connect(function()
                task.spawn(opt.Callback or function() end)
            end)
            Btn.MouseEnter:Connect(function() Tween(Btn, { BackgroundColor3 = Theme.ElementHover }, 0.12) end)
            Btn.MouseLeave:Connect(function() Tween(Btn, { BackgroundColor3 = Theme.Element }, 0.12) end)
        end

        function TabObj:Slider(opt)
            opt = opt or {}
            local min = (opt.Value and opt.Value.Min) or opt.Min or 0
            local max = (opt.Value and opt.Value.Max) or opt.Max or 100
            local value = (opt.Value and opt.Value.Default) or opt.Default or min
            local cb = opt.Callback or function() end
            local Row = Instance.new("Frame")
            Row.Size = UDim2.new(1, 0, 0, 58)
            Row.BackgroundColor3 = Theme.Element
            Row.BorderSizePixel = 0
            Row.Parent = Page
            Corner(Row, 12)
            Stroke(Row)
            local Lbl = Instance.new("TextLabel")
            Lbl.BackgroundTransparency = 1
            Lbl.Position = UDim2.new(0, 14, 0, 8)
            Lbl.Size = UDim2.new(1, -70, 0, 18)
            Lbl.Font = Enum.Font.GothamMedium
            Lbl.TextSize = 13
            Lbl.TextColor3 = Theme.Text
            Lbl.TextXAlignment = Enum.TextXAlignment.Left
            Lbl.Text = opt.Title or "Slider"
            Lbl.Parent = Row
            local ValLbl = Instance.new("TextLabel")
            ValLbl.BackgroundTransparency = 1
            ValLbl.AnchorPoint = Vector2.new(1, 0)
            ValLbl.Position = UDim2.new(1, -14, 0, 8)
            ValLbl.Size = UDim2.new(0, 50, 0, 18)
            ValLbl.Font = Enum.Font.Gotham
            ValLbl.TextSize = 12
            ValLbl.TextColor3 = Theme.Accent
            ValLbl.TextXAlignment = Enum.TextXAlignment.Right
            ValLbl.Text = tostring(value)
            ValLbl.Parent = Row
            local BarBG = Instance.new("Frame")
            BarBG.Position = UDim2.new(0, 14, 0, 36)
            BarBG.Size = UDim2.new(1, -28, 0, 6)
            BarBG.BackgroundColor3 = Theme.ToggleOff
            BarBG.BorderSizePixel = 0
            BarBG.Parent = Row
            Corner(BarBG, 3)
            local BarFill = Instance.new("Frame")
            BarFill.Size = UDim2.new((value - min) / math.max(max - min, 1), 0, 1, 0)
            BarFill.BackgroundColor3 = Theme.Accent
            BarFill.BorderSizePixel = 0
            BarFill.Parent = BarBG
            Corner(BarFill, 3)
            local sliding = false
            local function update(x)
                local rel = math.clamp((x - BarBG.AbsolutePosition.X) / BarBG.AbsoluteSize.X, 0, 1)
                value = math.floor(min + (max - min) * rel + 0.5)
                BarFill.Size = UDim2.new(rel, 0, 1, 0)
                ValLbl.Text = tostring(value)
                task.spawn(cb, value)
            end
            BarBG.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = true
                    update(input.Position.X)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = false
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    update(input.Position.X)
                end
            end)
        end

        function TabObj:Dropdown(opt)
            opt = opt or {}
            local values = opt.Values or opt.Options or {}
            local selected = opt.Value or values[1]
            local cb = opt.Callback or function() end
            local Row = Instance.new("Frame")
            Row.Size = UDim2.new(1, 0, 0, 44)
            Row.BackgroundColor3 = Theme.Element
            Row.BorderSizePixel = 0
            Row.ClipsDescendants = true
            Row.Parent = Page
            Corner(Row, 12)
            Stroke(Row)
            local Lbl = Instance.new("TextLabel")
            Lbl.BackgroundTransparency = 1
            Lbl.Position = UDim2.new(0, 14, 0, 0)
            Lbl.Size = UDim2.new(0.45, 0, 0, 44)
            Lbl.Font = Enum.Font.GothamMedium
            Lbl.TextSize = 13
            Lbl.TextColor3 = Theme.Text
            Lbl.TextXAlignment = Enum.TextXAlignment.Left
            Lbl.Text = opt.Title or "Dropdown"
            Lbl.Parent = Row
            local SelectedLbl = Instance.new("TextLabel")
            SelectedLbl.BackgroundTransparency = 1
            SelectedLbl.AnchorPoint = Vector2.new(1, 0)
            SelectedLbl.Position = UDim2.new(1, -14, 0, 0)
            SelectedLbl.Size = UDim2.new(0.5, 0, 0, 44)
            SelectedLbl.Font = Enum.Font.Gotham
            SelectedLbl.TextSize = 12
            SelectedLbl.TextColor3 = Theme.Accent
            SelectedLbl.TextXAlignment = Enum.TextXAlignment.Right
            SelectedLbl.Text = tostring(selected or "Select")
            SelectedLbl.Parent = Row
            local open = false
            local Hit = Instance.new("TextButton")
            Hit.Size = UDim2.new(1, 0, 0, 44)
            Hit.BackgroundTransparency = 1
            Hit.Text = ""
            Hit.Parent = Row
            local OptionsFrame = Instance.new("Frame")
            OptionsFrame.Position = UDim2.new(0, 10, 0, 44)
            OptionsFrame.Size = UDim2.new(1, -20, 0, 0)
            OptionsFrame.BackgroundTransparency = 1
            OptionsFrame.Parent = Row
            local OptLayout = Instance.new("UIListLayout")
            OptLayout.Padding = UDim.new(0, 4)
            OptLayout.Parent = OptionsFrame
            for _, v in ipairs(values) do
                local OptBtn = Instance.new("TextButton")
                OptBtn.Size = UDim2.new(1, 0, 0, 30)
                OptBtn.BackgroundColor3 = Theme.Panel
                OptBtn.BorderSizePixel = 0
                OptBtn.AutoButtonColor = false
                OptBtn.Font = Enum.Font.Gotham
                OptBtn.TextSize = 12
                OptBtn.TextColor3 = Theme.TextDim
                OptBtn.Text = tostring(v)
                OptBtn.Parent = OptionsFrame
                Corner(OptBtn, 8)
                OptBtn.MouseButton1Click:Connect(function()
                    selected = v
                    SelectedLbl.Text = tostring(v)
                    open = false
                    Row.Size = UDim2.new(1, 0, 0, 44)
                    task.spawn(cb, v)
                end)
            end
            Hit.MouseButton1Click:Connect(function()
                open = not open
                Row.Size = open and UDim2.new(1, 0, 0, 44 + (#values * 34) + 10) or UDim2.new(1, 0, 0, 44)
            end)
        end

        table.insert(WindowObj._tabs, TabObj)
        if #WindowObj._tabs == 1 then Select() end
        return TabObj
    end

    Main.Size = UDim2.new(0, 0, 0, 0)
    Tween(Main, { Size = SIZE_NORMAL }, 0.35)
    return WindowObj
end

return NovaUI
