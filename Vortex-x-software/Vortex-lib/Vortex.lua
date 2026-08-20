--[[
    NovaUI v7.1 (True WindUI Experience + OpenButton)
    Global Gradients, Advanced Tabs, Modern UI & Floating Button
]]

local NovaUI = {}
NovaUI.__index = NovaUI

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local IsMobile = UserInputService.TouchEnabled

-- ==================== ICONS ====================
local IconLib
pcall(function()
    IconLib = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Footagesus/Icons/main/Main-v2.lua"))()
    if IconLib and IconLib.SetIconsType then IconLib.SetIconsType("lucide") end
end)

local function ApplyIcon(imageObj, name, color)
    if not name or not IconLib then imageObj.Image = "" return false end
    local ok, data = pcall(function() return IconLib.GetIcon(name) or IconLib.Icon(name) end)
    if not ok or not data then imageObj.Image = "" return false end
    
    if typeof(data) == "string" then
        imageObj.Image = data
    elseif typeof(data) == "table" then
        imageObj.Image = data[1] or data.Image
        local meta = data[2] or data
        imageObj.ImageRectSize = meta.ImageRectSize or Vector2.new(0,0)
        imageObj.ImageRectOffset = meta.ImageRectOffset or Vector2.new(0,0)
    end
    if color then imageObj.ImageColor3 = color end
    return true
end

-- ==================== UTILS ====================
local function HexToColor3(hex)
    hex = hex:gsub("#", "")
    return Color3.fromRGB(tonumber(hex:sub(1, 2), 16) or 255, tonumber(hex:sub(3, 4), 16) or 255, tonumber(hex:sub(5, 6), 16) or 255)
end

local function Tween(obj, props, t)
    TweenService:Create(obj, TweenInfo.new(t or 0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props):Play()
end

local function Corner(p, r)
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, r or 8) c.Parent = p return c
end

local function Stroke(p, color, th)
    local s = Instance.new("UIStroke") s.Color = color s.Thickness = th or 1 s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border s.Parent = p return s
end

local function ApplyAccent(element, prop, accentData)
    for _, v in pairs(element:GetChildren()) do if v:IsA("UIGradient") then v:Destroy() end end
    if typeof(accentData) == "table" then
        element[prop] = Color3.fromRGB(255, 255, 255)
        local grad = Instance.new("UIGradient")
        grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, HexToColor3(accentData[1])),
            ColorSequenceKeypoint.new(1, HexToColor3(accentData[2]))
        })
        grad.Parent = element
    else
        element[prop] = accentData
    end
end

-- ==================== OPEN BUTTON ====================
local function CreateOpenButton(parent, cfg, onOpen)
    local mode = cfg.Mode or "Image"
    local btn = Instance.new("ImageButton")
    btn.Name = "NovaOpenBtn"
    btn.AutoButtonColor = false
    btn.BackgroundColor3 = cfg.BackgroundColor or Color3.fromRGB(15,15,20)
    btn.BackgroundTransparency = cfg.BackgroundTransparency or 0
    btn.Visible = false
    btn.Parent = parent
    Corner(btn, 12)
    
    local stroke = Stroke(btn, Color3.fromRGB(255,255,255), 1.5)
    ApplyAccent(stroke, "Color", cfg.BorderGradient or { "#0091FF", "#00D4FF" })

    if mode == "Text" then
        btn.Size = UDim2.new(0, 130, 0, 40)
        btn.Position = UDim2.new(0, 20, 1, -60)

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
            ApplyIcon(iconImg, cfg.Icon, Color3.fromRGB(250,250,255))
        end

        local label = Instance.new("TextLabel")
        label.BackgroundTransparency = 1
        label.AutomaticSize = Enum.AutomaticSize.X
        label.Size = UDim2.new(0, 0, 1, 0)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 13
        label.TextColor3 = Color3.fromRGB(250,250,255)
        label.Text = cfg.Text or "Open"
        label.Parent = btn
    else
        btn.Size = UDim2.new(0, 46, 0, 46)
        btn.Position = UDim2.new(0, 20, 1, -66)

        local img = Instance.new("ImageLabel")
        img.BackgroundTransparency = 1
        img.AnchorPoint = Vector2.new(0.5, 0.5)
        img.Position = UDim2.new(0.5, 0, 0.5, 0)
        img.Size = UDim2.new(0, 26, 0, 26) 
        img.Parent = btn
        ApplyIcon(img, cfg.Icon or "menu", Color3.fromRGB(250,250,255))
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

-- ==================== MAIN ====================
function NovaUI:CreateWindow(cfg)
    cfg = cfg or {}
    local Theme = cfg.Theme or {}
    local Accent = Theme.Accent or Color3.fromRGB(0, 145, 255)
    local openCfg = cfg.OpenButton or { Enabled = false }
    
    local MainSize = IsMobile and UDim2.new(0.92, 0, 0, 380) or UDim2.new(0, 650, 0, 420)
    local SidebarWidth = 180 
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "WindUI_Modern"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = PlayerGui

    local Main = Instance.new("Frame")
    Main.Size = MainSize
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.BackgroundColor3 = Theme.Background
    Main.ClipsDescendants = true
    Main.Parent = ScreenGui
    Corner(Main, 12) Stroke(Main, Theme.Stroke, 1)

    -- Topbar
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 44)
    TitleBar.BackgroundColor3 = Theme.TitleBar
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = Main
    Corner(TitleBar, 12)
    
    local fix = Instance.new("Frame")
    fix.Size = UDim2.new(1, 0, 0, 10)
    fix.Position = UDim2.new(0, 0, 1, -10)
    fix.BackgroundColor3 = Theme.TitleBar
    fix.BorderSizePixel = 0
    fix.Parent = TitleBar

    local WinIcon = Instance.new("ImageLabel")
    WinIcon.BackgroundTransparency = 1
    WinIcon.Position = UDim2.new(0, 16, 0.5, -9)
    WinIcon.Size = UDim2.new(0, 18, 0, 18)
    WinIcon.Parent = TitleBar
    ApplyIcon(WinIcon, cfg.Icon or "layout", Theme.Text)

    local TitleLbl = Instance.new("TextLabel")
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Position = UDim2.new(0, 44, 0, 0)
    TitleLbl.Size = UDim2.new(1, -150, 1, 0)
    TitleLbl.Font = Enum.Font.GothamBold
    TitleLbl.TextSize = 13
    TitleLbl.TextColor3 = Theme.Text
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    TitleLbl.Text = cfg.Title or "Window"
    TitleLbl.Parent = TitleBar

    -- Controles Superiores (Minimizar)
    local MinBtn = Instance.new("ImageButton")
    MinBtn.Size = UDim2.new(0, 26, 0, 26)
    MinBtn.AnchorPoint = Vector2.new(1, 0.5)
    MinBtn.Position = UDim2.new(1, -16, 0.5, 0)
    MinBtn.BackgroundColor3 = Theme.Element
    MinBtn.AutoButtonColor = false
    MinBtn.Parent = TitleBar
    Corner(MinBtn, 6)
    
    local MinIco = Instance.new("ImageLabel")
    MinIco.BackgroundTransparency = 1
    MinIco.Size = UDim2.new(0, 14, 0, 14)
    MinIco.AnchorPoint = Vector2.new(0.5, 0.5)
    MinIco.Position = UDim2.new(0.5, 0, 0.5, 0)
    MinIco.Parent = MinBtn
    ApplyIcon(MinIco, "minus", Theme.TextDim)
    
    MinBtn.MouseEnter:Connect(function() Tween(MinBtn, {BackgroundColor3 = Theme.ElementHover}, 0.15) Tween(MinIco, {ImageColor3 = Theme.Text}, 0.15) end)
    MinBtn.MouseLeave:Connect(function() Tween(MinBtn, {BackgroundColor3 = Theme.Element}, 0.15) Tween(MinIco, {ImageColor3 = Theme.TextDim}, 0.15) end)

    -- Sidebar y Cuerpo
    local Body = Instance.new("Frame")
    Body.Size = UDim2.new(1, 0, 1, -44)
    Body.Position = UDim2.new(0, 0, 0, 44)
    Body.BackgroundTransparency = 1
    Body.Parent = Main

    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, SidebarWidth, 1, 0)
    Sidebar.BackgroundColor3 = Theme.Sidebar
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = Body

    local sep = Instance.new("Frame")
    sep.Size = UDim2.new(0, 1, 1, 0)
    sep.Position = UDim2.new(1, 0, 0, 0)
    sep.AnchorPoint = Vector2.new(1, 0)
    sep.BackgroundColor3 = Theme.Stroke
    sep.BorderSizePixel = 0
    sep.Parent = Sidebar

    local TabList = Instance.new("ScrollingFrame")
    TabList.Size = UDim2.new(1, -20, 1, -20)
    TabList.Position = UDim2.new(0, 10, 0, 10)
    TabList.BackgroundTransparency = 1
    TabList.ScrollBarThickness = 0
    TabList.Parent = Sidebar
    local tl = Instance.new("UIListLayout") tl.Padding = UDim.new(0, 4) tl.Parent = TabList

    local Content = Instance.new("Frame")
    Content.Size = UDim2.new(1, -(SidebarWidth + 24), 1, -24)
    Content.Position = UDim2.new(0, SidebarWidth + 12, 0, 12)
    Content.BackgroundTransparency = 1
    Content.Parent = Body

    -- Dragging
    local drag, dStart, pStart
    TitleBar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = true dStart = i.Position pStart = Main.Position end end)
    TitleBar.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = false end end)
    UserInputService.InputChanged:Connect(function(i) if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local d = i.Position - dStart Main.Position = UDim2.new(pStart.X.Scale, pStart.X.Offset + d.X, pStart.Y.Scale, pStart.Y.Offset + d.Y) end end)

    -- Visibilidad (Minimizar / Maximizar)
    local OpenBtn
    local function ShowUI() Main.Visible = true if OpenBtn then OpenBtn.Visible = false end end
    local function HideUI() Main.Visible = false if OpenBtn then OpenBtn.Visible = true end end

    if openCfg.Enabled then OpenBtn = CreateOpenButton(ScreenGui, openCfg, ShowUI) end
    MinBtn.MouseButton1Click:Connect(HideUI)

    local WinObj = { _tabs = {} }

    -- ==================== TABS ====================
    function WinObj:Tab(opt)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 38)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = ""
        TabBtn.Parent = TabList Corner(TabBtn, 6)

        local Indicator = Instance.new("Frame")
        Indicator.Size = UDim2.new(0, 3, 0, 0)
        Indicator.Position = UDim2.new(0, 0, 0.5, 0)
        Indicator.AnchorPoint = Vector2.new(0, 0.5)
        Indicator.BackgroundTransparency = 0
        Indicator.Parent = TabBtn Corner(Indicator, 4)
        ApplyAccent(Indicator, "BackgroundColor3", Accent)

        local Layout = Instance.new("UIListLayout")
        Layout.FillDirection = Enum.FillDirection.Horizontal
        Layout.VerticalAlignment = Enum.VerticalAlignment.Center
        Layout.Padding = UDim.new(0, 10)
        Layout.Parent = TabBtn

        local Pad = Instance.new("UIPadding") Pad.PaddingLeft = UDim.new(0, 12) Pad.Parent = TabBtn

        local Ico = Instance.new("ImageLabel")
        Ico.Size = UDim2.new(0, 18, 0, 18)
        Ico.BackgroundTransparency = 1
        Ico.Parent = TabBtn ApplyIcon(Ico, opt.Icon, Theme.TextDim)

        local Txt = Instance.new("TextLabel")
        Txt.Size = UDim2.new(1, -28, 1, 0)
        Txt.BackgroundTransparency = 1
        Txt.Font = Enum.Font.GothamMedium
        Txt.TextSize = 13
        Txt.TextColor3 = Theme.TextDim
        Txt.TextXAlignment = Enum.TextXAlignment.Left
        Txt.Text = opt.Title or "Tab"
        Txt.Parent = TabBtn

        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 2
        Page.BorderSizePixel = 0
        Page.Visible = false
        Page.Parent = Content
        local pl = Instance.new("UIListLayout") pl.Padding = UDim.new(0, 8) pl.Parent = Page

        local function Select()
            for _, t in ipairs(WinObj._tabs) do
                t.Page.Visible = false Tween(t.Btn, {BackgroundTransparency = 1}, 0.2) Tween(t.Txt, {TextColor3 = Theme.TextDim}, 0.2) Tween(t.Ico, {ImageColor3 = Theme.TextDim}, 0.2) Tween(t.Ind, {Size = UDim2.new(0, 3, 0, 0)}, 0.2)
            end
            Page.Visible = true Tween(TabBtn, {BackgroundTransparency = 0, BackgroundColor3 = Theme.ElementHover}, 0.2) Tween(Indicator, {Size = UDim2.new(0, 3, 0, 20)}, 0.2)
            local activeColor = typeof(Accent) == "table" and Color3.fromRGB(255,255,255) or Accent
            Tween(Txt, {TextColor3 = activeColor}, 0.2) Tween(Ico, {ImageColor3 = activeColor}, 0.2)
        end

        TabBtn.MouseButton1Click:Connect(Select)
        local TabObj = { Btn = TabBtn, Page = Page, Txt = Txt, Ico = Ico, Ind = Indicator }

        -- ==================== ELEMENTS ====================
        function TabObj:Section(c)
            local l = Instance.new("TextLabel") l.Size = UDim2.new(1, 0, 0, 24) l.BackgroundTransparency = 1 l.Font = Enum.Font.GothamBold l.TextSize = 12 l.TextColor3 = Theme.TextDim l.TextXAlignment = Enum.TextXAlignment.Left l.Text = string.upper(c.Title or "SECTION") l.Parent = Page
        end

        function TabObj:Toggle(c)
            local on = c.Value or false
            local Row = Instance.new("Frame") Row.Size = UDim2.new(1, 0, 0, 44) Row.BackgroundColor3 = Theme.Element Row.Parent = Page Corner(Row, 8) Stroke(Row, Theme.Stroke, 1)

            local l = Instance.new("TextLabel") l.Size = UDim2.new(1, -70, 1, 0) l.Position = UDim2.new(0, 14, 0, 0) l.BackgroundTransparency = 1 l.Font = Enum.Font.GothamMedium l.TextSize = 13 l.TextColor3 = Theme.Text l.TextXAlignment = Enum.TextXAlignment.Left l.Text = c.Title or "Toggle" l.Parent = Row

            local bg = Instance.new("Frame") bg.Size = UDim2.new(0, 42, 0, 22) bg.AnchorPoint = Vector2.new(1, 0.5) bg.Position = UDim2.new(1, -14, 0.5, 0) bg.BackgroundColor3 = Theme.ToggleOff bg.Parent = Row Corner(bg, 11)
            local knob = Instance.new("Frame") knob.Size = UDim2.new(0, 16, 0, 16) knob.Position = on and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8) knob.BackgroundColor3 = Color3.fromRGB(255,255,255) knob.Parent = bg Corner(knob, 8)

            local function Update()
                if on then ApplyAccent(bg, "BackgroundColor3", Accent) else for _, v in pairs(bg:GetChildren()) do if v:IsA("UIGradient") then v:Destroy() end end bg.BackgroundColor3 = Theme.ToggleOff end
                Tween(knob, {Position = on and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)}, 0.2)
            end
            Update()
            local btn = Instance.new("TextButton") btn.Size = UDim2.new(1,0,1,0) btn.BackgroundTransparency = 1 btn.Text = "" btn.Parent = Row
            btn.MouseButton1Click:Connect(function() on = not on Update() if c.Callback then task.spawn(c.Callback, on) end end)
        end

        function TabObj:Slider(c)
            local min, max, val = c.Min or 0, c.Max or 100, c.Default or c.Min or 0
            local Row = Instance.new("Frame") Row.Size = UDim2.new(1, 0, 0, 58) Row.BackgroundColor3 = Theme.Element Row.Parent = Page Corner(Row, 8) Stroke(Row, Theme.Stroke, 1)

            local l = Instance.new("TextLabel") l.Size = UDim2.new(1, -70, 0, 16) l.Position = UDim2.new(0, 14, 0, 10) l.BackgroundTransparency = 1 l.Font = Enum.Font.GothamMedium l.TextSize = 13 l.TextColor3 = Theme.Text l.TextXAlignment = Enum.TextXAlignment.Left l.Text = c.Title or "Slider" l.Parent = Row
            local vL = Instance.new("TextLabel") vL.Size = UDim2.new(0, 40, 0, 16) vL.AnchorPoint = Vector2.new(1, 0) vL.Position = UDim2.new(1, -14, 0, 10) vL.BackgroundTransparency = 1 vL.Font = Enum.Font.GothamBold vL.TextSize = 12 vL.TextColor3 = Theme.TextDim vL.TextXAlignment = Enum.TextXAlignment.Right vL.Text = tostring(val) vL.Parent = Row

            local bg = Instance.new("Frame") bg.Size = UDim2.new(1, -28, 0, 6) bg.Position = UDim2.new(0, 14, 0, 38) bg.BackgroundColor3 = Theme.ToggleOff bg.Parent = Row Corner(bg, 3)
            local fill = Instance.new("Frame") fill.Size = UDim2.new((val - min) / math.max(max - min, 1), 0, 1, 0) fill.Parent = bg Corner(fill, 3) ApplyAccent(fill, "BackgroundColor3", Accent)

            local slide = false
            local function up(x)
                local pct = math.clamp((x - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1) val = math.floor(min + (max - min) * pct + 0.5) Tween(fill, {Size = UDim2.new(pct, 0, 1, 0)}, 0.1) vL.Text = tostring(val) if c.Callback then task.spawn(c.Callback, val) end
            end

            bg.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then slide = true up(i.Position.X) end end)
            UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then slide = false end end)
            UserInputService.InputChanged:Connect(function(i) if slide and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then up(i.Position.X) end end)
        end

        table.insert(WinObj._tabs, TabObj) if #WinObj._tabs == 1 then Select() end return TabObj
    end

    return WinObj
end

return NovaUI
