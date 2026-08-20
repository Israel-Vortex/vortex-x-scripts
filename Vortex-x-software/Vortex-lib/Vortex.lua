--[[
    NovaUI v3
    Libreria UI estilo WindUI
]]

local NovaUI = {}
NovaUI.__index = NovaUI
NovaUI.Version = "3.0.1"

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local IsMobile = UserInputService.TouchEnabled

local Icons = {
    ["swords"] = "rbxassetid://10734975692",
    ["settings"] = "rbxassetid://10734950309",
    ["eye"] = "rbxassetid://10723346959",
    ["map-pin"] = "rbxassetid://10734886004",
    ["shopping-cart"] = "rbxassetid://10734952479",
    ["more-horizontal"] = "rbxassetid://10734897250",
    ["target"] = "rbxassetid://10734977012",
    ["user"] = "rbxassetid://10747373176",
    ["shield"] = "rbxassetid://10734951847",
    ["home"] = "rbxassetid://10723407389",
    ["info"] = "rbxassetid://10723415903",
    ["flame"] = "rbxassetid://10723376114",
    ["gem"] = "rbxassetid://10723396000",
    ["star"] = "rbxassetid://10734966248",
    ["menu"] = "rbxassetid://10734887784",
    ["moon"] = "rbxassetid://10734897102",
    ["waves"] = "rbxassetid://10747376931",
    ["scroll"] = "rbxassetid://10734943448",
}

local function GetIcon(name)
    if not name then return nil end
    if typeof(name) == "string" and string.find(name, "rbxassetid://") then
        return name
    end
    return Icons[tostring(name)]
end

local Theme = {
    Background   = Color3.fromRGB(14, 14, 18),
    Sidebar      = Color3.fromRGB(18, 18, 24),
    TitleBar     = Color3.fromRGB(22, 22, 30),
    Panel        = Color3.fromRGB(26, 26, 34),
    Element      = Color3.fromRGB(32, 32, 42),
    ElementHover = Color3.fromRGB(42, 42, 54),
    Accent       = Color3.fromRGB(0, 200, 255),
    Text         = Color3.fromRGB(245, 245, 250),
    TextDim      = Color3.fromRGB(145, 145, 160),
    Stroke       = Color3.fromRGB(45, 45, 58),
    ToggleOff    = Color3.fromRGB(50, 50, 65),
    ToggleOn     = Color3.fromRGB(0, 200, 255),
    Danger       = Color3.fromRGB(255, 75, 95),
    Warning      = Color3.fromRGB(255, 180, 50),
    Success      = Color3.fromRGB(70, 220, 130),
}

local function Tween(obj, props, t)
    local tw = TweenService:Create(obj, TweenInfo.new(t or 0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props)
    tw:Play()
    return tw
end

local function Corner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = p
    return c
end

local function Stroke(p, color, th)
    local s = Instance.new("UIStroke")
    s.Color = color or Theme.Stroke
    s.Thickness = th or 1
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
    NotifyHolder.Name = "Holder"
    NotifyHolder.AnchorPoint = Vector2.new(1, 0)
    NotifyHolder.Position = UDim2.new(1, -14, 0, 14)
    NotifyHolder.Size = UDim2.new(0, 280, 1, -28)
    NotifyHolder.BackgroundTransparency = 1
    NotifyHolder.Parent = NotifyGui

    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 8)
    list.HorizontalAlignment = Enum.HorizontalAlignment.Right
    list.SortOrder = Enum.SortOrder.LayoutOrder
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
    Corner(card, 10)
    local st = Stroke(card)
    Padding(card, 12, 12, 14, 14)

    local t = Instance.new("TextLabel")
    t.BackgroundTransparency = 1
    t.Size = UDim2.new(1, 0, 0, 18)
    t.Font = Enum.Font.GothamBold
    t.TextSize = 14
    t.TextColor3 = Theme.Text
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.Text = cfg.Title or "Notify"
    t.Parent = card

    local d = Instance.new("TextLabel")
    d.BackgroundTransparency = 1
    d.Position = UDim2.new(0, 0, 0, 20)
    d.AutomaticSize = Enum.AutomaticSize.Y
    d.Size = UDim2.new(1, 0, 0, 0)
    d.Font = Enum.Font.Gotham
    d.TextSize = 12
    d.TextColor3 = Theme.TextDim
    d.TextXAlignment = Enum.TextXAlignment.Left
    d.TextWrapped = true
    d.Text = cfg.Content or ""
    d.Parent = card

    Tween(card, { BackgroundTransparency = 0 }, 0.2)

    task.delay(cfg.Duration or 3, function()
        if not card or not card.Parent then return end
        Tween(card, { BackgroundTransparency = 1 }, 0.2)
        if st then Tween(st, { Transparency = 1 }, 0.2) end
        task.wait(0.2)
        card:Destroy()
    end)
end

function NovaUI:CreateWindow(cfg)
    cfg = cfg or {}
    local title = cfg.Title or "NovaUI"
    local subTitle = cfg.SubTitle or cfg.Author or ""
    local toggleKey = cfg.ToggleKey or Enum.KeyCode.RightControl

    local SIZE_NORMAL = IsMobile and UDim2.new(0.94, 0, 0, 400) or UDim2.new(0, 620, 0, 400)
    local SIZE_MINI   = IsMobile and UDim2.new(0.94, 0, 0, 44) or UDim2.new(0, 620, 0, 44)
    local SIZE_MAX    = IsMobile and UDim2.new(0.96, 0, 0.82, 0) or UDim2.new(0, 900, 0, 560)
    local SIDE_W      = IsMobile and 54 or 156
    local TITLE_H     = 44

    local miniCfg = cfg.Minimizer
    if miniCfg == false then
        miniCfg = { Enabled = false }
    elseif not (typeof(miniCfg) == "table") then
        miniCfg = {
            Enabled = true,
            Icon = cfg.Icon or "menu",
            Image = nil,
            Text = nil,
            Size = UDim2.new(0, 52, 0, 52),
            Position = UDim2.new(0, 16, 1, -80),
            BackgroundColor = Theme.Panel,
            IconColor = Theme.Accent,
            TextColor = Theme.Text,
            Stroke = true,
            StrokeColor = Theme.Stroke,
            StrokeThickness = 1.2,
            CornerRadius = 14,
        }
    else
        if miniCfg.Enabled == nil then miniCfg.Enabled = true end
        miniCfg.Icon = miniCfg.Icon or cfg.Icon or "menu"
        miniCfg.Size = miniCfg.Size or UDim2.new(0, 52, 0, 52)
        miniCfg.Position = miniCfg.Position or UDim2.new(0, 16, 1, -80)
        miniCfg.BackgroundColor = miniCfg.BackgroundColor or Theme.Panel
        miniCfg.IconColor = miniCfg.IconColor or Theme.Accent
        miniCfg.TextColor = miniCfg.TextColor or Theme.Text
        if miniCfg.Stroke == nil then miniCfg.Stroke = true end
        miniCfg.StrokeColor = miniCfg.StrokeColor or Theme.Stroke
        miniCfg.StrokeThickness = miniCfg.StrokeThickness or 1.2
        miniCfg.CornerRadius = miniCfg.CornerRadius or 14
    end

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
    Corner(Main, 14)
    Stroke(Main)

    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, TITLE_H)
    TitleBar.BackgroundColor3 = Theme.TitleBar
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = Main
    Corner(TitleBar, 14)

    local titleFix = Instance.new("Frame")
    titleFix.BackgroundColor3 = Theme.TitleBar
    titleFix.BorderSizePixel = 0
    titleFix.Position = UDim2.new(0, 0, 1, -14)
    titleFix.Size = UDim2.new(1, 0, 0, 14)
    titleFix.Parent = TitleBar

    local TitleLbl = Instance.new("TextLabel")
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Position = UDim2.new(0, 16, 0, 0)
    TitleLbl.Size = UDim2.new(1, -140, 1, 0)
    TitleLbl.Font = Enum.Font.GothamBold
    TitleLbl.TextSize = 14
    TitleLbl.TextColor3 = Theme.Text
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    if subTitle == "" then
        TitleLbl.Text = title
    else
        TitleLbl.Text = title .. "  |  " .. subTitle
    end
    TitleLbl.Parent = TitleBar

    local Controls = Instance.new("Frame")
    Controls.AnchorPoint = Vector2.new(1, 0.5)
    Controls.Position = UDim2.new(1, -10, 0.5, 0)
    Controls.Size = UDim2.new(0, 120, 0, 28)
    Controls.BackgroundTransparency = 1
    Controls.Parent = TitleBar

    local cl = Instance.new("UIListLayout")
    cl.FillDirection = Enum.FillDirection.Horizontal
    cl.HorizontalAlignment = Enum.HorizontalAlignment.Right
    cl.VerticalAlignment = Enum.VerticalAlignment.Center
    cl.Padding = UDim.new(0, 6)
    cl.Parent = Controls

    local function Ctrl(symbol, color)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 26, 0, 26)
        b.BackgroundColor3 = Theme.Element
        b.BorderSizePixel = 0
        b.AutoButtonColor = false
        b.Font = Enum.Font.GothamBold
        b.TextSize = 13
        b.TextColor3 = color
        b.Text = symbol
        b.Parent = Controls
        Corner(b, 6)
        b.MouseEnter:Connect(function()
            Tween(b, { BackgroundColor3 = Theme.ElementHover }, 0.12)
        end)
        b.MouseLeave:Connect(function()
            Tween(b, { BackgroundColor3 = Theme.Element }, 0.12)
        end)
        return b
    end

    local MinBtn = Ctrl("-", Theme.TextDim)
    local MaxBtn = Ctrl("[]", Theme.TextDim)
    local HideBtn = Ctrl("O", Theme.Warning)
    local CloseBtn = Ctrl("X", Theme.Danger)

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

    local TabList = Instance.new("ScrollingFrame")
    TabList.Position = UDim2.new(0, 8, 0, 8)
    TabList.Size = UDim2.new(1, -16, 1, -16)
    TabList.BackgroundTransparency = 1
    TabList.BorderSizePixel = 0
    TabList.ScrollBarThickness = 2
    TabList.ScrollBarImageColor3 = Theme.Accent
    TabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabList.Parent = Sidebar

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Padding = UDim.new(0, 4)
    TabLayout.Parent = TabList

    local Content = Instance.new("Frame")
    Content.Position = UDim2.new(0, SIDE_W + 8, 0, 8)
    Content.Size = UDim2.new(1, -(SIDE_W + 16), 1, -16)
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

    local MinimizerBtn

    local function SetMainVisible(vis)
        Main.Visible = vis
        if MinimizerBtn then
            MinimizerBtn.Visible = not vis
        end
    end

    if miniCfg.Enabled then
        MinimizerBtn = Instance.new("ImageButton")
        MinimizerBtn.Name = "Minimizer"
        MinimizerBtn.Size = miniCfg.Size
        MinimizerBtn.Position = miniCfg.Position
        MinimizerBtn.BackgroundColor3 = miniCfg.BackgroundColor
        MinimizerBtn.BorderSizePixel = 0
        MinimizerBtn.AutoButtonColor = false
        MinimizerBtn.Visible = false
        MinimizerBtn.Parent = ScreenGui
        Corner(MinimizerBtn, miniCfg.CornerRadius)

        if miniCfg.Stroke then
            Stroke(MinimizerBtn, miniCfg.StrokeColor, miniCfg.StrokeThickness)
        end

        local imgId = miniCfg.Image or GetIcon(miniCfg.Icon)
        if imgId and not (imgId == "") then
            MinimizerBtn.Image = imgId
            MinimizerBtn.ImageColor3 = miniCfg.IconColor
            MinimizerBtn.ScaleType = Enum.ScaleType.Fit
            local pad = Instance.new("UIPadding")
            pad.PaddingTop = UDim.new(0, 11)
            pad.PaddingBottom = UDim.new(0, 11)
            pad.PaddingLeft = UDim.new(0, 11)
            pad.PaddingRight = UDim.new(0, 11)
            pad.Parent = MinimizerBtn
        end

        if miniCfg.Text and not (miniCfg.Text == "") then
            local tl = Instance.new("TextLabel")
            tl.BackgroundTransparency = 1
            tl.Size = UDim2.new(1, 0, 1, 0)
            tl.Font = Enum.Font.GothamBold
            tl.TextSize = 12
            tl.TextColor3 = miniCfg.TextColor
            tl.Text = miniCfg.Text
            tl.ZIndex = 2
            tl.Parent = MinimizerBtn
            if imgId then
                tl.Position = UDim2.new(0, 0, 0.55, 0)
                tl.Size = UDim2.new(1, 0, 0.4, 0)
                tl.TextSize = 10
                MinimizerBtn.ImageTransparency = 0.1
            end
        end

        MinimizerBtn.MouseButton1Click:Connect(function()
            state.hidden = false
            SetMainVisible(true)
        end)

        local mDrag, mStart, mPos
        MinimizerBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                mDrag = true
                mStart = input.Position
                mPos = MinimizerBtn.Position
            end
        end)
        MinimizerBtn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                mDrag = false
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if mDrag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local d = input.Position - mStart
                MinimizerBtn.Position = UDim2.new(mPos.X.Scale, mPos.X.Offset + d.X, mPos.Y.Scale, mPos.Y.Offset + d.Y)
            end
        end)
    end

    MinBtn.MouseButton1Click:Connect(function()
        state.minimized = not state.minimized
        if state.minimized then
            state.lastSize = Main.Size
            Body.Visible = false
            Tween(Main, { Size = SIZE_MINI }, 0.25)
            MinBtn.Text = "+"
        else
            Body.Visible = true
            Tween(Main, { Size = state.maximized and SIZE_MAX or state.lastSize }, 0.25)
            MinBtn.Text = "-"
        end
    end)

    MaxBtn.MouseButton1Click:Connect(function()
        if state.minimized then return end
        state.maximized = not state.maximized
        if state.maximized then
            state.lastSize = Main.Size
            state.lastPos = Main.Position
            Tween(Main, { Size = SIZE_MAX, Position = UDim2.new(0.5, 0, 0.5, 0) }, 0.25)
            MaxBtn.Text = "[=]"
        else
            Tween(Main, { Size = state.lastSize, Position = state.lastPos }, 0.25)
            MaxBtn.Text = "[]"
        end
    end)

    local function HideUI()
        state.hidden = true
        SetMainVisible(false)
        NovaUI:Notify({ Title = "UI Oculta", Content = "Boton flotante o RightControl", Duration = 2 })
    end

    local function ShowUI()
        state.hidden = false
        SetMainVisible(true)
    end

    HideBtn.MouseButton1Click:Connect(HideUI)

    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
        if NotifyGui then
            NotifyGui:Destroy()
            NotifyGui = nil
            NotifyHolder = nil
        end
    end)

    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == toggleKey then
            if state.hidden then ShowUI() else HideUI() end
        end
    end)

    local WindowObj = {
        _tabs = {},
        _gui = ScreenGui,
        _main = Main,
        Show = ShowUI,
        Hide = HideUI,
        Destroy = function()
            ScreenGui:Destroy()
            if NotifyGui then
                NotifyGui:Destroy()
                NotifyGui = nil
                NotifyHolder = nil
            end
        end,
    }

    function WindowObj:Tab(tabCfg)
        tabCfg = tabCfg or {}
        local tabTitle = tabCfg.Title or "Tab"
        local iconId = GetIcon(tabCfg.Icon)

        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, IsMobile and 44 or 36)
        TabBtn.BackgroundTransparency = 1
        TabBtn.BorderSizePixel = 0
        TabBtn.AutoButtonColor = false
        TabBtn.Text = ""
        TabBtn.Parent = TabList
        Corner(TabBtn, 8)

        local IconImg = Instance.new("ImageLabel")
        IconImg.BackgroundTransparency = 1
        IconImg.Size = UDim2.new(0, 18, 0, 18)
        if IsMobile then
            IconImg.AnchorPoint = Vector2.new(0.5, 0.5)
            IconImg.Position = UDim2.new(0.5, 0, 0.5, 0)
        else
            IconImg.Position = UDim2.new(0, 10, 0.5, -9)
        end
        IconImg.Image = iconId or ""
        IconImg.ImageColor3 = Theme.TextDim
        IconImg.Visible = not (iconId == nil)
        IconImg.Parent = TabBtn

        local TabText = Instance.new("TextLabel")
        TabText.BackgroundTransparency = 1
        TabText.Position = UDim2.new(0, iconId and 34 or 12, 0, 0)
        TabText.Size = UDim2.new(1, -40, 1, 0)
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
        PageLayout.Padding = UDim.new(0, 8)
        PageLayout.Parent = Page
        Padding(Page, 4, 8, 4, 8)

        local function Select()
            for _, t in ipairs(WindowObj._tabs) do
                t.Page.Visible = false
                t.Btn.BackgroundTransparency = 1
                t.Text.TextColor3 = Theme.TextDim
                if t.Icon then t.Icon.ImageColor3 = Theme.TextDim end
            end
            Page.Visible = true
            TabBtn.BackgroundTransparency = 0
            TabBtn.BackgroundColor3 = Theme.Element
            TabText.TextColor3 = Theme.Text
            if iconId then IconImg.ImageColor3 = Theme.Accent end
        end

        TabBtn.MouseButton1Click:Connect(Select)

        local TabObj = { Btn = TabBtn, Page = Page, Text = TabText, Icon = IconImg }

        function TabObj:Section(opt)
            local h = Instance.new("Frame")
            h.Size = UDim2.new(1, 0, 0, 22)
            h.BackgroundTransparency = 1
            h.Parent = Page
            local l = Instance.new("TextLabel")
            l.BackgroundTransparency = 1
            l.Size = UDim2.new(1, 0, 1, 0)
            l.Font = Enum.Font.GothamBold
            l.TextSize = 12
            l.TextColor3 = Theme.Accent
            l.TextXAlignment = Enum.TextXAlignment.Left
            l.Text = (opt and opt.Title) or "Section"
            l.Parent = h
        end

        function TabObj:Toggle(opt)
            opt = opt or {}
            local on = opt.Value or false
            local cb = opt.Callback or function() end

            local Row = Instance.new("Frame")
            Row.Size = UDim2.new(1, 0, 0, IsMobile and 46 or 40)
            Row.BackgroundColor3 = Theme.Element
            Row.BorderSizePixel = 0
            Row.Parent = Page
            Corner(Row, 8)
            Stroke(Row)

            local Lbl = Instance.new("TextLabel")
            Lbl.BackgroundTransparency = 1
            Lbl.Position = UDim2.new(0, 12, 0, 0)
            Lbl.Size = UDim2.new(1, -70, 1, 0)
            Lbl.Font = Enum.Font.GothamMedium
            Lbl.TextSize = 13
            Lbl.TextColor3 = Theme.Text
            Lbl.TextXAlignment = Enum.TextXAlignment.Left
            Lbl.Text = opt.Title or "Toggle"
            Lbl.Parent = Row

            local Track = Instance.new("Frame")
            Track.AnchorPoint = Vector2.new(1, 0.5)
            Track.Position = UDim2.new(1, -12, 0.5, 0)
            Track.Size = UDim2.new(0, 40, 0, 22)
            Track.BackgroundColor3 = on and Theme.ToggleOn or Theme.ToggleOff
            Track.BorderSizePixel = 0
            Track.Parent = Row
            Corner(Track, 11)

            local Knob = Instance.new("Frame")
            Knob.Size = UDim2.new(0, 16, 0, 16)
            Knob.Position = on and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
            Knob.BackgroundColor3 = Theme.Text
            Knob.BorderSizePixel = 0
            Knob.Parent = Track
            Corner(Knob, 8)

            local Hit = Instance.new("TextButton")
            Hit.Size = UDim2.new(1, 0, 1, 0)
            Hit.BackgroundTransparency = 1
            Hit.Text = ""
            Hit.Parent = Row

            Hit.MouseButton1Click:Connect(function()
                on = not on
                Tween(Track, { BackgroundColor3 = on and Theme.ToggleOn or Theme.ToggleOff }, 0.18)
                Tween(Knob, { Position = on and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8) }, 0.18)
                task.spawn(cb, on)
            end)
        end

        function TabObj:Button(opt)
            opt = opt or {}
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, 0, 0, IsMobile and 44 or 38)
            Btn.BackgroundColor3 = Theme.Element
            Btn.BorderSizePixel = 0
            Btn.AutoButtonColor = false
            Btn.Font = Enum.Font.GothamMedium
            Btn.TextSize = 13
            Btn.TextColor3 = Theme.Text
            Btn.Text = opt.Title or "Button"
            Btn.Parent = Page
            Corner(Btn, 8)
            Stroke(Btn)
            Btn.MouseButton1Click:Connect(function()
                task.spawn(opt.Callback or function() end)
            end)
            Btn.MouseEnter:Connect(function()
                Tween(Btn, { BackgroundColor3 = Theme.ElementHover }, 0.12)
            end)
            Btn.MouseLeave:Connect(function()
                Tween(Btn, { BackgroundColor3 = Theme.Element }, 0.12)
            end)
        end

        function TabObj:Slider(opt)
            opt = opt or {}
            local min = (opt.Value and opt.Value.Min) or opt.Min or 0
            local max = (opt.Value and opt.Value.Max) or opt.Max or 100
            local value = (opt.Value and opt.Value.Default) or opt.Default or min
            local cb = opt.Callback or function() end

            local Row = Instance.new("Frame")
            Row.Size = UDim2.new(1, 0, 0, 54)
            Row.BackgroundColor3 = Theme.Element
            Row.BorderSizePixel = 0
            Row.Parent = Page
            Corner(Row, 8)
            Stroke(Row)

            local Lbl = Instance.new("TextLabel")
            Lbl.BackgroundTransparency = 1
            Lbl.Position = UDim2.new(0, 12, 0, 6)
            Lbl.Size = UDim2.new(1, -60, 0, 18)
            Lbl.Font = Enum.Font.GothamMedium
            Lbl.TextSize = 13
            Lbl.TextColor3 = Theme.Text
            Lbl.TextXAlignment = Enum.TextXAlignment.Left
            Lbl.Text = opt.Title or "Slider"
            Lbl.Parent = Row

            local ValLbl = Instance.new("TextLabel")
            ValLbl.BackgroundTransparency = 1
            ValLbl.AnchorPoint = Vector2.new(1, 0)
            ValLbl.Position = UDim2.new(1, -12, 0, 6)
            ValLbl.Size = UDim2.new(0, 50, 0, 18)
            ValLbl.Font = Enum.Font.Gotham
            ValLbl.TextSize = 12
            ValLbl.TextColor3 = Theme.Accent
            ValLbl.TextXAlignment = Enum.TextXAlignment.Right
            ValLbl.Text = tostring(value)
            ValLbl.Parent = Row

            local BarBG = Instance.new("Frame")
            BarBG.Position = UDim2.new(0, 12, 0, 34)
            BarBG.Size = UDim2.new(1, -24, 0, 6)
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
            Row.Size = UDim2.new(1, 0, 0, 40)
            Row.BackgroundColor3 = Theme.Element
            Row.BorderSizePixel = 0
            Row.ClipsDescendants = true
            Row.Parent = Page
            Corner(Row, 8)
            Stroke(Row)

            local Lbl = Instance.new("TextLabel")
            Lbl.BackgroundTransparency = 1
            Lbl.Position = UDim2.new(0, 12, 0, 0)
            Lbl.Size = UDim2.new(0.45, 0, 0, 40)
            Lbl.Font = Enum.Font.GothamMedium
            Lbl.TextSize = 13
            Lbl.TextColor3 = Theme.Text
            Lbl.TextXAlignment = Enum.TextXAlignment.Left
            Lbl.Text = opt.Title or "Dropdown"
            Lbl.Parent = Row

            local SelectedLbl = Instance.new("TextLabel")
            SelectedLbl.BackgroundTransparency = 1
            SelectedLbl.AnchorPoint = Vector2.new(1, 0)
            SelectedLbl.Position = UDim2.new(1, -12, 0, 0)
            SelectedLbl.Size = UDim2.new(0.5, 0, 0, 40)
            SelectedLbl.Font = Enum.Font.Gotham
            SelectedLbl.TextSize = 12
            SelectedLbl.TextColor3 = Theme.Accent
            SelectedLbl.TextXAlignment = Enum.TextXAlignment.Right
            SelectedLbl.Text = tostring(selected or "Select")
            SelectedLbl.Parent = Row

            local open = false
            local Hit = Instance.new("TextButton")
            Hit.Size = UDim2.new(1, 0, 0, 40)
            Hit.BackgroundTransparency = 1
            Hit.Text = ""
            Hit.Parent = Row

            local OptionsFrame = Instance.new("Frame")
            OptionsFrame.Position = UDim2.new(0, 8, 0, 40)
            OptionsFrame.Size = UDim2.new(1, -16, 0, 0)
            OptionsFrame.BackgroundTransparency = 1
            OptionsFrame.Parent = Row

            local OptLayout = Instance.new("UIListLayout")
            OptLayout.Padding = UDim.new(0, 2)
            OptLayout.Parent = OptionsFrame

            for _, v in ipairs(values) do
                local OptBtn = Instance.new("TextButton")
                OptBtn.Size = UDim2.new(1, 0, 0, 28)
                OptBtn.BackgroundColor3 = Theme.Panel
                OptBtn.BorderSizePixel = 0
                OptBtn.AutoButtonColor = false
                OptBtn.Font = Enum.Font.Gotham
                OptBtn.TextSize = 12
                OptBtn.TextColor3 = Theme.TextDim
                OptBtn.Text = tostring(v)
                OptBtn.Parent = OptionsFrame
                Corner(OptBtn, 6)
                OptBtn.MouseButton1Click:Connect(function()
                    selected = v
                    SelectedLbl.Text = tostring(v)
                    open = false
                    Row.Size = UDim2.new(1, 0, 0, 40)
                    task.spawn(cb, v)
                end)
            end

            Hit.MouseButton1Click:Connect(function()
                open = not open
                Row.Size = open and UDim2.new(1, 0, 0, 40 + (#values * 30) + 8) or UDim2.new(1, 0, 0, 40)
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
