--[[
    VortexUI / NovaUI Engine v10.0 (WindUI Edition)
    - Full WindUI Aesthetic & Dynamic Layout Fixes
    - Custom Wallpaper / Background Image Support
    - Anti-Overlap Text & Control Containers
    - Universal Icon Engine (AssetID + Lucide Icons)
    - Components: Button, Toggle, Slider, Dropdown, Input, Section
]]

local NovaUI = {}
NovaUI.__index = NovaUI

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local IsMobile = UserInputService.TouchEnabled

-- ==================== ICON ENGINE ====================
local IconLib
pcall(function()
    IconLib = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Footagesus/Icons/main/Main-v2.lua"))()
    if IconLib and IconLib.SetIconsType then IconLib.SetIconsType("lucide") end
end)

local function ApplyIcon(imageObj, iconData, defaultColor)
    if not iconData or iconData == "" then 
        imageObj.Image = ""
        return false 
    end
    
    local strData = tostring(iconData)
    if type(iconData) == "number" or strData:match("^%d+$") then
        imageObj.Image = "rbxassetid://" .. strData
        if defaultColor then imageObj.ImageColor3 = defaultColor end
        return true
    elseif strData:find("rbxassetid://") or strData:find("http") then
        imageObj.Image = strData
        if defaultColor then imageObj.ImageColor3 = defaultColor end
        return true
    end

    if IconLib then
        local ok, data = pcall(function() return IconLib.GetIcon(strData) or IconLib.Icon(strData) end)
        if ok and data then
            if typeof(data) == "string" then
                imageObj.Image = data
            elseif typeof(data) == "table" then
                imageObj.Image = data[1] or data.Image
                local meta = data[2] or data
                imageObj.ImageRectSize = meta.ImageRectSize or Vector2.new(0,0)
                imageObj.ImageRectOffset = meta.ImageRectOffset or Vector2.new(0,0)
            end
            if defaultColor then imageObj.ImageColor3 = defaultColor end
            return true
        end
    end

    imageObj.Image = ""
    return false
end

-- ==================== UTILS ====================
local function HexToColor3(hex)
    if typeof(hex) == "Color3" then return hex end
    hex = tostring(hex):gsub("#", "")
    return Color3.fromRGB(tonumber(hex:sub(1, 2), 16) or 255, tonumber(hex:sub(3, 4), 16) or 255, tonumber(hex:sub(5, 6), 16) or 255)
end

local function Tween(obj, props, t, style, dir)
    local info = TweenInfo.new(t or 0.2, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out)
    local tw = TweenService:Create(obj, info, props)
    tw:Play()
    return tw
end

local function Corner(p, r)
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, r or 8) c.Parent = p return c
end

local function Stroke(p, color, th, trans)
    local s = Instance.new("UIStroke") 
    s.Color = color or Color3.fromRGB(255,255,255) 
    s.Thickness = th or 1 
    s.Transparency = trans or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border 
    s.Parent = p 
    return s
end

local function ApplyAccent(element, prop, accentData)
    for _, v in pairs(element:GetChildren()) do if v:IsA("UIGradient") then v:Destroy() end end
    if typeof(accentData) == "table" then
        element[prop] = Color3.fromRGB(255, 255, 255)
        local grad = Instance.new("UIGradient")
        grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, HexToColor3(accentData[1])),
            ColorSequenceKeypoint.new(1, HexToColor3(accentData[2] or accentData[1]))
        })
        grad.Parent = element
    else
        element[prop] = accentData
    end
end

-- ==================== MAIN WINDOW ====================
function NovaUI:CreateWindow(cfg)
    cfg = cfg or {}
    local Theme = cfg.Theme or {}
    local Accent = Theme.Accent or { "#0091FF", "#00D4FF" }
    local openCfg = cfg.OpenButton or { Enabled = false }
    
    local NormalSize = IsMobile and UDim2.new(0.92, 0, 0, 390) or UDim2.new(0, 680, 0, 450)
    local MaxSize = UDim2.new(0.95, 0, 0.9, 0)
    local SidebarWidth = 190
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VortexUI_WindEngine"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = PlayerGui

    -- Main Container
    local Main = Instance.new("Frame")
    Main.Size = NormalSize
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.BackgroundColor3 = Theme.Background or Color3.fromRGB(14, 14, 18)
    Main.BackgroundTransparency = cfg.Transparency or 0.1
    Main.ClipsDescendants = true
    Main.Parent = ScreenGui
    Corner(Main, 12) 
    Stroke(Main, Theme.Stroke or Color3.fromRGB(45,45,60), 1, 0.3)

    -- Custom Background Wallpaper (WindUI Feature)
    local BgImage = Instance.new("ImageLabel")
    BgImage.Name = "CustomWallpaper"
    BgImage.Size = UDim2.new(1, 0, 1, 0)
    BgImage.BackgroundTransparency = 1
    BgImage.ScaleType = Enum.ScaleType.Crop
    BgImage.ImageTransparency = cfg.ImageTransparency or 0.35
    BgImage.ZIndex = 0
    BgImage.Parent = Main

    if cfg.BackgroundImage then
        local imgStr = tostring(cfg.BackgroundImage)
        if type(cfg.BackgroundImage) == "number" or imgStr:match("^%d+$") then
            BgImage.Image = "rbxassetid://" .. imgStr
        else
            BgImage.Image = imgStr
        end
    end

    -- Header / TitleBar
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 46)
    TitleBar.BackgroundTransparency = 0.5
    TitleBar.BackgroundColor3 = Theme.TitleBar or Color3.fromRGB(14, 14, 18)
    TitleBar.BorderSizePixel = 0
    TitleBar.ZIndex = 2
    TitleBar.Parent = Main

    local WinIcon = Instance.new("ImageLabel")
    WinIcon.BackgroundTransparency = 1
    WinIcon.Position = UDim2.new(0, 16, 0.5, -10)
    WinIcon.Size = UDim2.new(0, 20, 0, 20)
    WinIcon.Parent = TitleBar
    ApplyIcon(WinIcon, cfg.Icon or "layout", Theme.Text or Color3.fromRGB(250,250,255))

    local TitleLbl = Instance.new("TextLabel")
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Position = UDim2.new(0, 44, 0, 0)
    TitleLbl.Size = UDim2.new(1, -160, 1, 0)
    TitleLbl.Font = Enum.Font.GothamBold
    TitleLbl.TextSize = 13
    TitleLbl.TextColor3 = Theme.Text or Color3.fromRGB(250,250,255)
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    TitleLbl.TextTruncate = Enum.TextTruncate.AtEnd
    TitleLbl.Text = (cfg.Title or "Vortex System") .. (cfg.SubTitle and ("  <font color='#8C8C9B'>|  " .. cfg.SubTitle .. "</font>") or "")
    TitleLbl.RichText = true
    TitleLbl.Parent = TitleBar

    -- Controls Holder (Minus, Max, Close)
    local ControlsHolder = Instance.new("Frame")
    ControlsHolder.Size = UDim2.new(0, 100, 1, 0)
    ControlsHolder.Position = UDim2.new(1, -105, 0, 0)
    ControlsHolder.BackgroundTransparency = 1
    ControlsHolder.ZIndex = 3
    ControlsHolder.Parent = TitleBar

    local cLayout = Instance.new("UIListLayout")
    cLayout.FillDirection = Enum.FillDirection.Horizontal
    cLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    cLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    cLayout.Padding = UDim.new(0, 6)
    cLayout.Parent = ControlsHolder

    local function HelperControlBtn(iconName, hoverColor)
        local btn = Instance.new("ImageButton")
        btn.Size = UDim2.new(0, 26, 0, 26)
        btn.BackgroundColor3 = Theme.Element or Color3.fromRGB(26, 26, 36)
        btn.BackgroundTransparency = 0.2
        btn.AutoButtonColor = false
        btn.Parent = ControlsHolder
        Corner(btn, 6)

        local ico = Instance.new("ImageLabel")
        ico.BackgroundTransparency = 1
        ico.Size = UDim2.new(0, 14, 0, 14)
        ico.AnchorPoint = Vector2.new(0.5, 0.5)
        ico.Position = UDim2.new(0.5, 0, 0.5, 0)
        ico.Parent = btn
        ApplyIcon(ico, iconName, Theme.TextDim or Color3.fromRGB(140,140,160))

        btn.MouseEnter:Connect(function() 
            Tween(btn, {BackgroundColor3 = hoverColor or Theme.ElementHover or Color3.fromRGB(40,40,55)}, 0.15) 
            Tween(ico, {ImageColor3 = Color3.fromRGB(255,255,255)}, 0.15) 
        end)
        btn.MouseLeave:Connect(function() 
            Tween(btn, {BackgroundColor3 = Theme.Element or Color3.fromRGB(26, 26, 36)}, 0.15) 
            Tween(ico, {ImageColor3 = Theme.TextDim or Color3.fromRGB(140,140,160)}, 0.15) 
        end)
        return btn
    end

    local MinBtn = HelperControlBtn("minus")
    local MaxBtn = HelperControlBtn("square")
    local CloseBtn = HelperControlBtn("x", Color3.fromRGB(220, 50, 60))

    -- Body & Navigation
    local Body = Instance.new("Frame")
    Body.Size = UDim2.new(1, 0, 1, -46)
    Body.Position = UDim2.new(0, 0, 0, 46)
    Body.BackgroundTransparency = 1
    Body.ZIndex = 2
    Body.Parent = Main

    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, SidebarWidth, 1, 0)
    Sidebar.BackgroundColor3 = Theme.Sidebar or Color3.fromRGB(18, 18, 24)
    Sidebar.BackgroundTransparency = 0.4
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = Body

    local sep = Instance.new("Frame")
    sep.Size = UDim2.new(0, 1, 1, 0)
    sep.Position = UDim2.new(1, 0, 0, 0)
    sep.AnchorPoint = Vector2.new(1, 0)
    sep.BackgroundColor3 = Theme.Stroke or Color3.fromRGB(45,45,60)
    sep.BackgroundTransparency = 0.5
    sep.BorderSizePixel = 0
    sep.Parent = Sidebar

    local TabList = Instance.new("ScrollingFrame")
    TabList.Size = UDim2.new(1, -16, 1, -20)
    TabList.Position = UDim2.new(0, 8, 0, 10)
    TabList.BackgroundTransparency = 1
    TabList.ScrollBarThickness = 0
    TabList.Parent = Sidebar
    local tl = Instance.new("UIListLayout") tl.Padding = UDim.new(0, 4) tl.Parent = TabList

    local Content = Instance.new("Frame")
    Content.Size = UDim2.new(1, -(SidebarWidth + 24), 1, -24)
    Content.Position = UDim2.new(0, SidebarWidth + 12, 0, 12)
    Content.BackgroundTransparency = 1
    Content.Parent = Body

    -- Drag Logic
    local drag, dStart, pStart
    TitleBar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = true dStart = i.Position pStart = Main.Position end end)
    TitleBar.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = false end end)
    UserInputService.InputChanged:Connect(function(i) if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local d = i.Position - dStart Main.Position = UDim2.new(pStart.X.Scale, pStart.X.Offset + d.X, pStart.Y.Scale, pStart.Y.Offset + d.Y) end end)

    -- Window Controls Logic
    local OpenBtn
    local isMaximized = false
    local function ShowUI() Main.Visible = true if OpenBtn then OpenBtn.Visible = false end end
    local function HideUI() Main.Visible = false if OpenBtn then OpenBtn.Visible = true end end

    if openCfg.Enabled then
        OpenBtn = Instance.new("ImageButton")
        OpenBtn.Name = "VortexOpenBtn"
        OpenBtn.Size = UDim2.new(0, 46, 0, 46)
        OpenBtn.Position = UDim2.new(0, 20, 1, -66)
        OpenBtn.BackgroundColor3 = Theme.Background or Color3.fromRGB(14,14,18)
        OpenBtn.Visible = false
        OpenBtn.Parent = ScreenGui
        Corner(OpenBtn, 12)
        local s = Stroke(OpenBtn, Color3.fromRGB(255,255,255), 1.5)
        ApplyAccent(s, "Color", openCfg.BorderGradient or Accent)

        local openIco = Instance.new("ImageLabel")
        openIco.Size = UDim2.new(0, 24, 0, 24)
        openIco.AnchorPoint = Vector2.new(0.5, 0.5)
        openIco.Position = UDim2.new(0.5, 0, 0.5, 0)
        openIco.BackgroundTransparency = 1
        openIco.Parent = OpenBtn
        ApplyIcon(openIco, openCfg.Icon or cfg.Icon or "layout", Color3.fromRGB(250,250,255))

        OpenBtn.MouseButton1Click:Connect(ShowUI)
    end

    MinBtn.MouseButton1Click:Connect(HideUI)
    MaxBtn.MouseButton1Click:Connect(function()
        isMaximized = not isMaximized
        Tween(Main, { Size = isMaximized and MaxSize or NormalSize }, 0.25)
    end)
    CloseBtn.MouseButton1Click:Connect(function()
        Tween(Main, { Size = UDim2.new(0,0,0,0) }, 0.2).Completed:Connect(function() ScreenGui:Destroy() end)
    end)

    local WinObj = { _tabs = {}, MainFrame = Main, BgImage = BgImage }

    function WinObj:SetBackgroundImage(imageId, transparency)
        if not imageId or imageId == "" then BgImage.Image = "" return end
        local imgStr = tostring(imageId)
        BgImage.Image = (type(imageId) == "number" or imgStr:match("^%d+$")) and ("rbxassetid://" .. imgStr) or imgStr
        if transparency then BgImage.ImageTransparency = transparency end
    end

    -- ==================== TABS ====================
    function WinObj:Tab(opt)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 36)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = ""
        TabBtn.Parent = TabList Corner(TabBtn, 8)

        local Indicator = Instance.new("Frame")
        Indicator.Size = UDim2.new(0, 3, 0, 0)
        Indicator.Position = UDim2.new(0, 0, 0.5, 0)
        Indicator.AnchorPoint = Vector2.new(0, 0.5)
        Indicator.Parent = TabBtn Corner(Indicator, 4)
        ApplyAccent(Indicator, "BackgroundColor3", Accent)

        local Layout = Instance.new("UIListLayout")
        Layout.FillDirection = Enum.FillDirection.Horizontal
        Layout.VerticalAlignment = Enum.VerticalAlignment.Center
        Layout.Padding = UDim.new(0, 10)
        Layout.Parent = TabBtn

        local Pad = Instance.new("UIPadding") Pad.PaddingLeft = UDim.new(0, 10) Pad.Parent = TabBtn

        local Ico = Instance.new("ImageLabel")
        Ico.Size = UDim2.new(0, 18, 0, 18)
        Ico.BackgroundTransparency = 1
        Ico.Parent = TabBtn ApplyIcon(Ico, opt.Icon, Theme.TextDim or Color3.fromRGB(140,140,160))

        local Txt = Instance.new("TextLabel")
        Txt.Size = UDim2.new(1, -28, 1, 0)
        Txt.BackgroundTransparency = 1
        Txt.Font = Enum.Font.GothamMedium
        Txt.TextSize = 13
        Txt.TextColor3 = Theme.TextDim or Color3.fromRGB(140,140,160)
        Txt.TextXAlignment = Enum.TextXAlignment.Left
        Txt.TextTruncate = Enum.TextTruncate.AtEnd
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
                t.Page.Visible = false 
                Tween(t.Btn, {BackgroundTransparency = 1}, 0.2) 
                Tween(t.Txt, {TextColor3 = Theme.TextDim or Color3.fromRGB(140,140,160)}, 0.2) 
                Tween(t.Ico, {ImageColor3 = Theme.TextDim or Color3.fromRGB(140,140,160)}, 0.2) 
                Tween(t.Ind, {Size = UDim2.new(0, 3, 0, 0)}, 0.2)
            end
            Page.Visible = true 
            Tween(TabBtn, {BackgroundTransparency = 0, BackgroundColor3 = Theme.ElementHover or Color3.fromRGB(30,30,42)}, 0.2) 
            Tween(Indicator, {Size = UDim2.new(0, 3, 0, 18)}, 0.2)
            local activeColor = typeof(Accent) == "table" and Color3.fromRGB(255,255,255) or Accent
            Tween(Txt, {TextColor3 = activeColor}, 0.2) 
            Tween(Ico, {ImageColor3 = activeColor}, 0.2)
        end

        TabBtn.MouseButton1Click:Connect(Select)
        local TabObj = { Btn = TabBtn, Page = Page, Txt = Txt, Ico = Ico, Ind = Indicator }

        -- Helper Function for WindUI Styled Container Cards
        local function CreateCard(c, rightWidgetWidth)
            local hasDesc = c.Desc and c.Desc ~= ""
            local h = hasDesc and 54 or 44

            local Row = Instance.new("Frame")
            Row.Size = UDim2.new(1, 0, 0, h)
            Row.BackgroundColor3 = Theme.Element or Color3.fromRGB(24, 24, 32)
            Row.BackgroundTransparency = 0.2
            Row.ClipsDescendants = true
            Row.Parent = Page
            Corner(Row, 8)
            Stroke(Row, Theme.Stroke or Color3.fromRGB(45,45,60), 1, 0.4)

            -- Text Container (Left side)
            local TextFrame = Instance.new("Frame")
            TextFrame.Size = UDim2.new(1, -(rightWidgetWidth + 28), 1, 0)
            TextFrame.Position = UDim2.new(0, 14, 0, 0)
            TextFrame.BackgroundTransparency = 1
            TextFrame.Parent = Row

            local TitleLabel = Instance.new("TextLabel")
            TitleLabel.Size = UDim2.new(1, 0, 0, hasDesc and 22 or h)
            TitleLabel.Position = UDim2.new(0, 0, 0, hasDesc and 8 or 0)
            TitleLabel.BackgroundTransparency = 1
            TitleLabel.Font = Enum.Font.GothamMedium
            TitleLabel.TextSize = 13
            TitleLabel.TextColor3 = Theme.Text or Color3.fromRGB(250,250,255)
            TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
            TitleLabel.TextTruncate = Enum.TextTruncate.AtEnd
            TitleLabel.Text = c.Title or "Option"
            TitleLabel.Parent = TextFrame

            if hasDesc then
                local DescLabel = Instance.new("TextLabel")
                DescLabel.Size = UDim2.new(1, 0, 0, 16)
                DescLabel.Position = UDim2.new(0, 0, 0, 28)
                DescLabel.BackgroundTransparency = 1
                DescLabel.Font = Enum.Font.Gotham
                DescLabel.TextSize = 11
                DescLabel.TextColor3 = Theme.TextDim or Color3.fromRGB(140,140,160)
                DescLabel.TextXAlignment = Enum.TextXAlignment.Left
                DescLabel.TextTruncate = Enum.TextTruncate.AtEnd
                DescLabel.Text = c.Desc
                DescLabel.Parent = TextFrame
            end

            -- Right Control Container (Right Side - Guarantees NO OVERLAP)
            local RightContainer = Instance.new("Frame")
            RightContainer.Size = UDim2.new(0, rightWidgetWidth, 1, 0)
            RightContainer.Position = UDim2.new(1, -14, 0, 0)
            RightContainer.AnchorPoint = Vector2.new(1, 0)
            RightContainer.BackgroundTransparency = 1
            RightContainer.Parent = Row

            return Row, RightContainer
        end

        -- ==================== ELEMENTS ====================
        function TabObj:Section(c)
            local sec = Instance.new("Frame")
            sec.Size = UDim2.new(1, 0, 0, 26)
            sec.BackgroundTransparency = 1
            sec.Parent = Page

            local l = Instance.new("TextLabel") 
            l.Size = UDim2.new(1, 0, 1, 0) 
            l.BackgroundTransparency = 1 
            l.Font = Enum.Font.GothamBold 
            l.TextSize = 11 
            l.TextColor3 = Theme.TextDim or Color3.fromRGB(140,140,160) 
            l.TextXAlignment = Enum.TextXAlignment.Left 
            l.Text = string.upper(c.Title or "SECTION") 
            l.Parent = sec
        end

        function TabObj:Button(c)
            local Row, Right = CreateCard(c, 24)

            local arrow = Instance.new("ImageLabel")
            arrow.Size = UDim2.new(0, 16, 0, 16)
            arrow.AnchorPoint = Vector2.new(1, 0.5)
            arrow.Position = UDim2.new(1, 0, 0.5, 0)
            arrow.BackgroundTransparency = 1
            arrow.Parent = Right
            ApplyIcon(arrow, "chevron-right", Theme.TextDim or Color3.fromRGB(140,140,160))

            local click = Instance.new("TextButton") click.Size = UDim2.new(1,0,1,0) click.BackgroundTransparency = 1 click.Text = "" click.Parent = Row
            click.MouseButton1Click:Connect(function()
                Tween(Row, {BackgroundColor3 = Theme.ElementHover or Color3.fromRGB(40,40,55)}, 0.1)
                task.wait(0.1)
                Tween(Row, {BackgroundColor3 = Theme.Element or Color3.fromRGB(24, 24, 32)}, 0.15)
                if c.Callback then task.spawn(c.Callback) end
            end)
        end

        function TabObj:Toggle(c)
            local on = c.Value or false
            local Row, Right = CreateCard(c, 44)

            local bg = Instance.new("Frame")
            bg.Size = UDim2.new(0, 42, 0, 22)
            bg.AnchorPoint = Vector2.new(1, 0.5)
            bg.Position = UDim2.new(1, 0, 0.5, 0)
            bg.BackgroundColor3 = Theme.ToggleOff or Color3.fromRGB(45,45,58)
            bg.Parent = Right
            Corner(bg, 11)

            local knob = Instance.new("Frame")
            knob.Size = UDim2.new(0, 16, 0, 16)
            knob.Position = on and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
            knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
            knob.Parent = bg
            Corner(knob, 8)

            local function Update()
                if on then 
                    ApplyAccent(bg, "BackgroundColor3", Accent) 
                else 
                    for _, v in pairs(bg:GetChildren()) do if v:IsA("UIGradient") then v:Destroy() end end 
                    bg.BackgroundColor3 = Theme.ToggleOff or Color3.fromRGB(45,45,58) 
                end
                Tween(knob, {Position = on and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)}, 0.2)
            end
            Update()

            local click = Instance.new("TextButton") click.Size = UDim2.new(1,0,1,0) click.BackgroundTransparency = 1 click.Text = "" click.Parent = Row
            click.MouseButton1Click:Connect(function() on = not on Update() if c.Callback then task.spawn(c.Callback, on) end end)
        end

        function TabObj:Slider(c)
            local min, max, val = c.Min or 0, c.Max or 100, c.Default or c.Min or 0
            local Row, Right = CreateCard(c, 150)

            local vL = Instance.new("TextLabel") 
            vL.Size = UDim2.new(1, 0, 0, 16) 
            vL.Position = UDim2.new(0, 0, 0, 6)
            vL.BackgroundTransparency = 1 
            vL.Font = Enum.Font.GothamBold 
            vL.TextSize = 11 
            vL.TextColor3 = Theme.TextDim or Color3.fromRGB(140,140,160) 
            vL.TextXAlignment = Enum.TextXAlignment.Right 
            vL.Text = tostring(val) 
            vL.Parent = Right

            local track = Instance.new("Frame") 
            track.Size = UDim2.new(1, 0, 0, 6) 
            track.Position = UDim2.new(0, 0, 1, -14) 
            track.BackgroundColor3 = Theme.ToggleOff or Color3.fromRGB(45,45,58) 
            track.Parent = Right Corner(track, 3)

            local fill = Instance.new("Frame") 
            fill.Size = UDim2.new((val - min) / math.max(max - min, 1), 0, 1, 0) 
            fill.Parent = track Corner(fill, 3) ApplyAccent(fill, "BackgroundColor3", Accent)

            local slide = false
            local function up(x)
                local pct = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1) 
                val = math.floor(min + (max - min) * pct + 0.5) 
                Tween(fill, {Size = UDim2.new(pct, 0, 1, 0)}, 0.05) 
                vL.Text = tostring(val) 
                if c.Callback then task.spawn(c.Callback, val) end
            end

            track.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then slide = true up(i.Position.X) end end)
            UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then slide = false end end)
            UserInputService.InputChanged:Connect(function(i) if slide and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then up(i.Position.X) end end)
        end

        function TabObj:Input(c)
            local Row, Right = CreateCard(c, 130)

            local boxBg = Instance.new("Frame")
            boxBg.Size = UDim2.new(1, 0, 0, 28)
            boxBg.AnchorPoint = Vector2.new(1, 0.5)
            boxBg.Position = UDim2.new(1, 0, 0.5, 0)
            boxBg.BackgroundColor3 = Theme.Background or Color3.fromRGB(15,15,20)
            boxBg.Parent = Right Corner(boxBg, 6)
            Stroke(boxBg, Theme.Stroke or Color3.fromRGB(45,45,60), 1, 0.5)

            local box = Instance.new("TextBox")
            box.Size = UDim2.new(1, -12, 1, 0)
            box.Position = UDim2.new(0, 6, 0, 0)
            box.BackgroundTransparency = 1
            box.Font = Enum.Font.Gotham
            box.TextSize = 12
            box.TextColor3 = Theme.Text or Color3.fromRGB(250,250,255)
            box.PlaceholderColor3 = Theme.TextDim or Color3.fromRGB(100,100,120)
            box.PlaceholderText = c.Placeholder or "Escribe aquí..."
            box.Text = c.Default or ""
            box.ClearTextOnFocus = false
            box.Parent = boxBg

            box.FocusLost:Connect(function(enter)
                if c.Callback then task.spawn(c.Callback, box.Text, enter) end
            end)
        end

        function TabObj:Dropdown(c)
            local options = c.Options or {}
            local selected = c.Default or options[1] or "Ninguno"
            local isOpen = false

            local Row, Right = CreateCard(c, 130)

            local dropBtn = Instance.new("Frame")
            dropBtn.Size = UDim2.new(1, 0, 0, 28)
            dropBtn.AnchorPoint = Vector2.new(1, 0.5)
            dropBtn.Position = UDim2.new(1, 0, 0.5, 0)
            dropBtn.BackgroundColor3 = Theme.Background or Color3.fromRGB(15,15,20)
            dropBtn.Parent = Right Corner(dropBtn, 6)
            Stroke(dropBtn, Theme.Stroke or Color3.fromRGB(45,45,60), 1, 0.5)

            local dropTxt = Instance.new("TextLabel")
            dropTxt.Size = UDim2.new(1, -24, 1, 0)
            dropTxt.Position = UDim2.new(0, 8, 0, 0)
            dropTxt.BackgroundTransparency = 1
            dropTxt.Font = Enum.Font.Gotham
            dropTxt.TextSize = 12
            dropTxt.TextColor3 = Theme.Text or Color3.fromRGB(250,250,255)
            dropTxt.TextXAlignment = Enum.TextXAlignment.Left
            dropTxt.TextTruncate = Enum.TextTruncate.AtEnd
            dropTxt.Text = selected
            dropTxt.Parent = dropBtn

            local dropIco = Instance.new("ImageLabel")
            dropIco.Size = UDim2.new(0, 14, 0, 14)
            dropIco.AnchorPoint = Vector2.new(1, 0.5)
            dropIco.Position = UDim2.new(1, -6, 0.5, 0)
            dropIco.BackgroundTransparency = 1
            dropIco.Parent = dropBtn
            ApplyIcon(dropIco, "chevron-down", Theme.TextDim or Color3.fromRGB(140,140,160))

            local click = Instance.new("TextButton") click.Size = UDim2.new(1,0,1,0) click.BackgroundTransparency = 1 click.Text = "" click.Parent = dropBtn

            click.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                Tween(dropIco, {Rotation = isOpen and 180 or 0}, 0.2)
                -- Expansión dinámica opcional o ejecución del callback
                if c.Callback then task.spawn(c.Callback, selected) end
            end)
        end

        table.insert(WinObj._tabs, TabObj) 
        if #WinObj._tabs == 1 then Select() end 
        return TabObj
    end

    return WinObj
end

return NovaUI
