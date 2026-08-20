--[[
    NovaUI v6 (WindUI Pure Replica)
    Sidebar Ampliada, Border Gradients, Modal Fixes & WindUI Aesthetics
]]

local NovaUI = {}
NovaUI.__index = NovaUI
NovaUI.Version = "6.0.0"

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local IsMobile = UserInputService.TouchEnabled

-- ==================== ICONS ====================
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
    if typeof(name) == "string" and string.find(name, "rbxassetid://") then return name, nil, nil end
    if not IconLib then return nil, nil, nil end
    local ok, data = pcall(function()
        if IconLib.GetIcon then return IconLib.GetIcon(tostring(name)) end
        if IconLib.Icon then return IconLib.Icon(tostring(name)) end
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
    if typeof(hex) ~= "string" then return Color3.fromRGB(0, 145, 255) end
    hex = hex:gsub("#", "")
    if #hex == 3 then hex = hex:sub(1,1)..hex:sub(1,1)..hex:sub(2,2)..hex:sub(2,2)..hex:sub(3,3)..hex:sub(3,3) end
    local r = tonumber(hex:sub(1, 2), 16) or 0
    local g = tonumber(hex:sub(3, 4), 16) or 0
    local b = tonumber(hex:sub(5, 6), 16) or 0
    return Color3.fromRGB(r, g, b)
end

-- ==================== THEME SYSTEM ====================
local Theme = {
    Background   = Color3.fromRGB(15, 15, 20),
    Sidebar      = Color3.fromRGB(18, 18, 24),
    TitleBar     = Color3.fromRGB(15, 15, 20),
    Panel        = Color3.fromRGB(24, 24, 32),
    Element      = Color3.fromRGB(30, 30, 40),
    ElementHover = Color3.fromRGB(40, 40, 55),
    Accent       = Color3.fromRGB(0, 160, 255),
    Text         = Color3.fromRGB(250, 250, 255),
    TextDim      = Color3.fromRGB(140, 140, 160),
    TextMuted    = Color3.fromRGB(90, 90, 110),
    Stroke       = Color3.fromRGB(40, 40, 55),
    ToggleOff    = Color3.fromRGB(45, 45, 58),
    ToggleOn     = Color3.fromRGB(0, 160, 255),
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

local function ApplyBorderGradient(strokeObj, colors, rotation)
    if not colors or #colors < 2 then return end
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, HexToColor3(colors[1])),
        ColorSequenceKeypoint.new(1, HexToColor3(colors[2])),
    })
    g.Rotation = rotation or 0
    g.Parent = strokeObj
    strokeObj.Color = Color3.fromRGB(255, 255, 255) -- Base white to allow gradient
end

-- ==================== OPEN BUTTON ====================
local function CreateOpenButton(parent, cfg, onOpen)
    cfg = cfg or {}
    local mode = cfg.Mode or "Image"

    local btn = Instance.new("ImageButton")
    btn.Name = "WindOpenBtn"
    btn.AutoButtonColor = false
    btn.BorderSizePixel = 0
    btn.Visible = false
    btn.BackgroundColor3 = cfg.BackgroundColor or Theme.Panel
    btn.BackgroundTransparency = cfg.BackgroundTransparency or 0
    btn.Parent = parent
    Corner(btn, 12)
    
    local stroke = Stroke(btn, Theme.Stroke, 1.5)
    if cfg.BorderGradient then
        ApplyBorderGradient(stroke, cfg.BorderGradient, cfg.GradientRotation)
    end

    if mode == "Text" then
        btn.Size = cfg.Size or UDim2.new(0, 130, 0, 40)
        btn.Position = cfg.Position or UDim2.new(0, 20, 1, -60)

        local layout = Instance.new("UIListLayout")
        layout.FillDirection = Enum.FillDirection.Horizontal
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        layout.VerticalAlignment = Enum.VerticalAlignment.Center
        layout.Padding = UDim.new(0, 8)
        layout.Parent = btn

        if cfg.Icon then
            local iconImg = Instance.new("ImageLabel")
            iconImg.BackgroundTransparency = 1
            iconImg.Size = UDim2.new(0, 18, 0, 18)
            iconImg.Parent = btn
            ApplyIcon(iconImg, cfg.Icon, Theme.Text)
        end

        local label = Instance.new("TextLabel")
        label.BackgroundTransparency = 1
        label.AutomaticSize = Enum.AutomaticSize.X
        label.Size = UDim2.new(0, 0, 1, 0)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 13
        label.TextColor3 = Theme.Text
        label.Text = cfg.Text or "Open"
        label.Parent = btn
    else
        local side = 46
        btn.Size = cfg.Size or UDim2.new(0, side, 0, side)
        btn.Position = cfg.Position or UDim2.new(0, 20, 1, -66)

        local img = Instance.new("ImageLabel")
        img.BackgroundTransparency = 1
        img.AnchorPoint = Vector2.new(0.5, 0.5)
        img.Position = UDim2.new(0.5, 0, 0.5, 0)
        img.Size = UDim2.new(0, 26, 0, 26) 
        img.Parent = btn
        ApplyIcon(img, cfg.Icon or "menu", Theme.Text)
    end

    local dragging, dStart, pStart
    btn.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true dStart = i.Position pStart = btn.Position
            Tween(btn, { Size = UDim2.new(0, btn.Size.X.Offset - 4, 0, btn.Size.Y.Offset - 4) }, 0.1)
        end
    end)
    btn.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            Tween(btn, { Size = UDim2.new(0, btn.Size.X.Offset + 4, 0, btn.Size.Y.Offset + 4) }, 0.1)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - dStart
            btn.Position = UDim2.new(pStart.X.Scale, pStart.X.Offset + d.X, pStart.Y.Scale, pStart.Y.Offset + d.Y)
        end
    end)

    btn.MouseButton1Click:Connect(function() if onOpen then onOpen() end end)
    return btn
end

-- ==================== MAIN WINDOW ====================
function NovaUI:CreateWindow(cfg)
    cfg = cfg or {}
    if cfg.Theme then for k, v in pairs(cfg.Theme) do Theme[k] = v end end

    local openCfg = cfg.OpenButton or {}
    if openCfg.Enabled == nil then openCfg.Enabled = true end

    -- Dimensiones WindUI
    local SIZE_NORMAL = IsMobile and UDim2.new(0.92, 0, 0, 380) or UDim2.new(0, 620, 0, 400)
    local SIZE_MAX    = IsMobile and UDim2.new(0.98, 0, 0.9, 0)  or UDim2.new(0, 850, 0, 550)
    local SIDE_W      = IsMobile and 56 or 180 -- Barra lateral mucho mas grande
    local TITLE_H     = 42

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NovaUI_WindUI"
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
    Corner(Main, 12)
    Stroke(Main, Theme.Stroke, 1)

    -- Topbar
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, TITLE_H)
    TitleBar.BackgroundColor3 = Theme.TitleBar
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = Main
    Corner(TitleBar, 12)
    
    local fix = Instance.new("Frame")
    fix.BackgroundColor3 = Theme.TitleBar
    fix.BorderSizePixel = 0
    fix.Position = UDim2.new(0, 0, 1, -6)
    fix.Size = UDim2.new(1, 0, 0, 6)
    fix.Parent = TitleBar

    local WinIcon = Instance.new("ImageLabel")
    WinIcon.BackgroundTransparency = 1
    WinIcon.Position = UDim2.new(0, 16, 0.5, -9)
    WinIcon.Size = UDim2.new(0, 18, 0, 18)
    WinIcon.Parent = TitleBar
    ApplyIcon(WinIcon, cfg.Icon or "layout", Theme.Accent)

    local TitleLbl = Instance.new("TextLabel")
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Position = UDim2.new(0, 42, 0, 0)
    TitleLbl.Size = UDim2.new(1, -150, 1, 0)
    TitleLbl.Font = Enum.Font.GothamBold
    TitleLbl.TextSize = 13
    TitleLbl.TextColor3 = Theme.Text
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    TitleLbl.Text = cfg.Title or "WindUI"
    TitleLbl.Parent = TitleBar

    -- Controles Ventana
    local Controls = Instance.new("Frame")
    Controls.AnchorPoint = Vector2.new(1, 0.5)
    Controls.Position = UDim2.new(1, -12, 0.5, 0)
    Controls.Size = UDim2.new(0, 90, 0, 26)
    Controls.BackgroundTransparency = 1
    Controls.Parent = TitleBar

    local cl = Instance.new("UIListLayout")
    cl.FillDirection = Enum.FillDirection.Horizontal
    cl.HorizontalAlignment = Enum.HorizontalAlignment.Right
    cl.Padding = UDim.new(0, 6)
    cl.Parent = Controls

    local function CtrlBtn(iconName, hColor)
        local b = Instance.new("ImageButton")
        b.Size = UDim2.new(0, 26, 0, 26)
        b.BackgroundColor3 = Theme.Element
        b.AutoButtonColor = false
        b.Parent = Controls
        Corner(b, 6)
        local i = Instance.new("ImageLabel")
        i.BackgroundTransparency = 1
        i.Size = UDim2.new(0, 14, 0, 14)
        i.AnchorPoint = Vector2.new(0.5, 0.5)
        i.Position = UDim2.new(0.5, 0, 0.5, 0)
        i.Parent = b
        ApplyIcon(i, iconName, Theme.TextDim)
        
        b.MouseEnter:Connect(function() 
            Tween(b, {BackgroundColor3 = hColor or Theme.ElementHover}, 0.15) 
            Tween(i, {ImageColor3 = Theme.Text}, 0.15)
        end)
        b.MouseLeave:Connect(function() 
            Tween(b, {BackgroundColor3 = Theme.Element}, 0.15) 
            Tween(i, {ImageColor3 = Theme.TextDim}, 0.15)
        end)
        return b, i
    end

    local MinBtn = CtrlBtn("minus", Theme.ElementHover)
    local MaxBtn, MaxIco = CtrlBtn("maximize-2", Theme.ElementHover)
    local CloseBtn = CtrlBtn("x", Color3.fromRGB(220, 50, 60))

    -- Cuerpo y Sidebar
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

    local sep = Instance.new("Frame")
    sep.AnchorPoint = Vector2.new(1, 0)
    sep.Position = UDim2.new(1, 0, 0, 0)
    sep.Size = UDim2.new(0, 1, 1, 0)
    sep.BackgroundColor3 = Theme.Stroke
    sep.BorderSizePixel = 0
    sep.Parent = Sidebar

    local TabList = Instance.new("ScrollingFrame")
    TabList.Position = UDim2.new(0, 10, 0, 10)
    TabList.Size = UDim2.new(1, -20, 1, -20)
    TabList.BackgroundTransparency = 1
    TabList.BorderSizePixel = 0
    TabList.ScrollBarThickness = 0
    TabList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabList.Parent = Sidebar

    local tl = Instance.new("UIListLayout")
    tl.Padding = UDim.new(0, 6)
    tl.Parent = TabList

    local Content = Instance.new("Frame")
    Content.Position = UDim2.new(0, SIDE_W + 12, 0, 12)
    Content.Size = UDim2.new(1, -(SIDE_W + 24), 1, -24)
    Content.BackgroundTransparency = 1
    Content.Parent = Body

    -- Dragging
    local drag, dStart, pStart
    TitleBar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            drag = true dStart = i.Position pStart = Main.Position
        end
    end)
    TitleBar.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = false end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - dStart
            Main.Position = UDim2.new(pStart.X.Scale, pStart.X.Offset + d.X, pStart.Y.Scale, pStart.Y.Offset + d.Y)
        end
    end)

    -- Visibilidad
    local state = { max = false, hid = false, lSize = SIZE_NORMAL, lPos = Main.Position }
    local OpenBtn
    
    local function ShowUI() state.hid = false Main.Visible = true if OpenBtn then OpenBtn.Visible = false end end
    local function HideUI() state.hid = true Main.Visible = false if OpenBtn then OpenBtn.Visible = true end end

    if openCfg.Enabled then OpenBtn = CreateOpenButton(ScreenGui, openCfg, ShowUI) end
    MinBtn.MouseButton1Click:Connect(HideUI)

    MaxBtn.MouseButton1Click:Connect(function()
        state.max = not state.max
        if state.max then
            state.lSize = Main.Size state.lPos = Main.Position
            Tween(Main, {Size = SIZE_MAX, Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.3)
            ApplyIcon(MaxIco, "minimize", Theme.TextDim)
        else
            Tween(Main, {Size = state.lSize, Position = state.lPos}, 0.3)
            ApplyIcon(MaxIco, "maximize-2", Theme.TextDim)
        end
    end)

    -- Modal Close
    local ModalLayer = Instance.new("Frame")
    ModalLayer.Size = UDim2.new(1, 0, 1, 0)
    ModalLayer.BackgroundColor3 = Color3.fromRGB(0,0,0)
    ModalLayer.BackgroundTransparency = 1
    ModalLayer.Visible = false
    ModalLayer.ZIndex = 50
    ModalLayer.Parent = Main

    local Modal = Instance.new("Frame")
    Modal.AnchorPoint = Vector2.new(0.5, 0.5)
    Modal.Position = UDim2.new(0.5, 0, 0.5, 0)
    Modal.Size = UDim2.new(0, 280, 0, 140)
    Modal.BackgroundColor3 = Theme.Panel
    Modal.Parent = ModalLayer
    Corner(Modal, 12) Stroke(Modal, Theme.Stroke, 1)

    local mTitle = Instance.new("TextLabel")
    mTitle.BackgroundTransparency = 1
    mTitle.Position = UDim2.new(0, 20, 0, 20)
    mTitle.Size = UDim2.new(1, -40, 0, 20)
    mTitle.Font = Enum.Font.GothamBold
    mTitle.TextSize = 14
    mTitle.TextColor3 = Theme.Text
    mTitle.TextXAlignment = Enum.TextXAlignment.Left
    mTitle.Text = "Exit Script"
    mTitle.Parent = Modal

    local mDesc = Instance.new("TextLabel")
    mDesc.BackgroundTransparency = 1
    mDesc.Position = UDim2.new(0, 20, 0, 45)
    mDesc.Size = UDim2.new(1, -40, 0, 30)
    mDesc.Font = Enum.Font.Gotham
    mDesc.TextSize = 12
    mDesc.TextColor3 = Theme.TextDim
    mDesc.TextXAlignment = Enum.TextXAlignment.Left
    mDesc.TextWrapped = true
    mDesc.Text = "Are you sure you want to completely close the interface?"
    mDesc.Parent = Modal

    local mBtns = Instance.new("Frame")
    mBtns.BackgroundTransparency = 1
    mBtns.Position = UDim2.new(0, 20, 1, -45)
    mBtns.Size = UDim2.new(1, -40, 0, 30)
    mBtns.Parent = Modal

    local ml = Instance.new("UIListLayout")
    ml.FillDirection = Enum.FillDirection.Horizontal
    ml.HorizontalAlignment = Enum.HorizontalAlignment.Right
    ml.Padding = UDim.new(0, 10)
    ml.Parent = mBtns

    local YesBtn = Instance.new("TextButton")
    YesBtn.Size = UDim2.new(0, 100, 1, 0)
    YesBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 60)
    YesBtn.Font = Enum.Font.GothamBold
    YesBtn.TextSize = 12
    YesBtn.TextColor3 = Color3.fromRGB(255,255,255)
    YesBtn.Text = "Close Window"
    YesBtn.Parent = mBtns Corner(YesBtn, 8)

    local NoBtn = Instance.new("TextButton")
    NoBtn.Size = UDim2.new(0, 80, 1, 0)
    NoBtn.BackgroundColor3 = Theme.Element
    NoBtn.Font = Enum.Font.GothamBold
    NoBtn.TextSize = 12
    NoBtn.TextColor3 = Theme.Text
    NoBtn.Text = "Cancel"
    NoBtn.Parent = mBtns Corner(NoBtn, 8) Stroke(NoBtn, Theme.Stroke, 1)

    CloseBtn.MouseButton1Click:Connect(function()
        ModalLayer.Visible = true
        Tween(ModalLayer, {BackgroundTransparency = 0.4}, 0.2)
    end)
    NoBtn.MouseButton1Click:Connect(function()
        Tween(ModalLayer, {BackgroundTransparency = 1}, 0.15)
        task.wait(0.15) ModalLayer.Visible = false
    end)
    YesBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    local WinObj = { _tabs = {} }

    function WinObj:Tab(opt)
        opt = opt or {}
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, IsMobile and 42 or 36)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = ""
        TabBtn.Parent = TabList
        Corner(TabBtn, 8)

        local Ico = Instance.new("ImageLabel")
        Ico.BackgroundTransparency = 1
        Ico.Size = UDim2.new(0, 16, 0, 16)
        if IsMobile then
            Ico.AnchorPoint = Vector2.new(0.5, 0.5)
            Ico.Position = UDim2.new(0.5, 0, 0.5, 0)
        else
            Ico.Position = UDim2.new(0, 12, 0.5, -8)
        end
        Ico.Parent = TabBtn
        local hasIco = ApplyIcon(Ico, opt.Icon, Theme.TextDim)
        Ico.Visible = hasIco

        local Txt = Instance.new("TextLabel")
        Txt.BackgroundTransparency = 1
        Txt.Position = UDim2.new(0, hasIco and 36 or 12, 0, 0)
        Txt.Size = UDim2.new(1, -40, 1, 0)
        Txt.Font = Enum.Font.GothamMedium
        Txt.TextSize = 12
        Txt.TextColor3 = Theme.TextDim
        Txt.TextXAlignment = Enum.TextXAlignment.Left
        Txt.Text = opt.Title or "Tab"
        Txt.Visible = not IsMobile
        Txt.Parent = TabBtn

        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.BorderSizePixel = 0
        Page.ScrollBarThickness = 2
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Page.Visible = false
        Page.Parent = Content

        local pl = Instance.new("UIListLayout")
        pl.Padding = UDim.new(0, 8)
        pl.Parent = Page

        local function Select()
            for _, t in ipairs(WinObj._tabs) do
                t.Page.Visible = false
                Tween(t.Btn, {BackgroundTransparency = 1}, 0.15)
                Tween(t.Txt, {TextColor3 = Theme.TextDim}, 0.15)
                if t.Ico then Tween(t.Ico, {ImageColor3 = Theme.TextDim}, 0.15) end
            end
            Page.Visible = true
            Tween(TabBtn, {BackgroundTransparency = 0, BackgroundColor3 = Theme.ElementHover}, 0.15)
            Tween(Txt, {TextColor3 = Theme.Accent}, 0.15)
            if hasIco then Tween(Ico, {ImageColor3 = Theme.Accent}, 0.15) end
        end

        TabBtn.MouseButton1Click:Connect(Select)
        local TabObj = { Btn = TabBtn, Page = Page, Txt = Txt, Ico = Ico }

        function TabObj:Section(c)
            local l = Instance.new("TextLabel")
            l.BackgroundTransparency = 1
            l.Size = UDim2.new(1, 0, 0, 24)
            l.Font = Enum.Font.GothamBold
            l.TextSize = 11
            l.TextColor3 = Theme.TextDim
            l.TextXAlignment = Enum.TextXAlignment.Left
            l.Text = string.upper(c.Title or "SECTION")
            l.Parent = Page
        end

        function TabObj:Toggle(c)
            local on = c.Value or false
            local Row = Instance.new("Frame")
            Row.Size = UDim2.new(1, 0, 0, 42)
            Row.BackgroundColor3 = Theme.Element
            Row.Parent = Page Corner(Row, 10) Stroke(Row, Theme.Stroke, 1)

            local l = Instance.new("TextLabel")
            l.BackgroundTransparency = 1
            l.Position = UDim2.new(0, 14, 0, 0)
            l.Size = UDim2.new(1, -70, 1, 0)
            l.Font = Enum.Font.GothamMedium
            l.TextSize = 12
            l.TextColor3 = Theme.Text
            l.TextXAlignment = Enum.TextXAlignment.Left
            l.Text = c.Title or "Toggle"
            l.Parent = Row

            local bg = Instance.new("Frame")
            bg.AnchorPoint = Vector2.new(1, 0.5)
            bg.Position = UDim2.new(1, -14, 0.5, 0)
            bg.Size = UDim2.new(0, 42, 0, 22)
            bg.BackgroundColor3 = on and Theme.ToggleOn or Theme.ToggleOff
            bg.Parent = Row Corner(bg, 11)

            local knob = Instance.new("Frame")
            knob.Size = UDim2.new(0, 16, 0, 16)
            knob.Position = on and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
            knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
            knob.Parent = bg Corner(knob, 8)

            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1,0,1,0) btn.BackgroundTransparency = 1 btn.Text = "" btn.Parent = Row
            btn.MouseButton1Click:Connect(function()
                on = not on
                Tween(bg, {BackgroundColor3 = on and Theme.ToggleOn or Theme.ToggleOff}, 0.2)
                Tween(knob, {Position = on and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)}, 0.2)
                if c.Callback then task.spawn(c.Callback, on) end
            end)
        end

        function TabObj:Slider(c)
            local min, max, val = c.Min or 0, c.Max or 100, c.Default or c.Min or 0
            local Row = Instance.new("Frame")
            Row.Size = UDim2.new(1, 0, 0, 56)
            Row.BackgroundColor3 = Theme.Element
            Row.Parent = Page Corner(Row, 10) Stroke(Row, Theme.Stroke, 1)

            local l = Instance.new("TextLabel")
            l.BackgroundTransparency = 1 l.Position = UDim2.new(0, 14, 0, 8) l.Size = UDim2.new(1, -70, 0, 16)
            l.Font = Enum.Font.GothamMedium l.TextSize = 12 l.TextColor3 = Theme.Text l.TextXAlignment = Enum.TextXAlignment.Left
            l.Text = c.Title or "Slider" l.Parent = Row

            local vL = Instance.new("TextLabel")
            vL.BackgroundTransparency = 1 vL.AnchorPoint = Vector2.new(1, 0) vL.Position = UDim2.new(1, -14, 0, 8)
            vL.Size = UDim2.new(0, 40, 0, 16) vL.Font = Enum.Font.GothamBold vL.TextSize = 12
            vL.TextColor3 = Theme.Accent vL.TextXAlignment = Enum.TextXAlignment.Right vL.Text = tostring(val) vL.Parent = Row

            local bg = Instance.new("Frame")
            bg.Position = UDim2.new(0, 14, 0, 36) bg.Size = UDim2.new(1, -28, 0, 6)
            bg.BackgroundColor3 = Theme.ToggleOff bg.Parent = Row Corner(bg, 3)

            local fill = Instance.new("Frame")
            fill.Size = UDim2.new((val - min) / math.max(max - min, 1), 0, 1, 0)
            fill.BackgroundColor3 = Theme.Accent fill.Parent = bg Corner(fill, 3)

            local slide = false
            local function up(x)
                local pct = math.clamp((x - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)
                val = math.floor(min + (max - min) * pct + 0.5)
                Tween(fill, {Size = UDim2.new(pct, 0, 1, 0)}, 0.1)
                vL.Text = tostring(val)
                if c.Callback then task.spawn(c.Callback, val) end
            end

            bg.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then slide = true up(i.Position.X) end end)
            UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then slide = false end end)
            UserInputService.InputChanged:Connect(function(i) if slide and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then up(i.Position.X) end end)
        end

        table.insert(WinObj._tabs, TabObj)
        if #WinObj._tabs == 1 then Select() end
        return TabObj
    end

    Main.Size = UDim2.new(0,0,0,0)
    Tween(Main, {Size = SIZE_NORMAL}, 0.35)
    return WinObj
end

return NovaUI
