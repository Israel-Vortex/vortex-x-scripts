--[[
    KiraUI - Library (estilo visual Kira Hub)
    Uso:
      local KiraUI = loadstring(game:HttpGet("TU_LINK"))()
      -- o pegar este archivo completo y:
      local KiraUI = loadstring(readfile("KiraUI.lua"))()

      local Window = KiraUI:CreateWindow({
          Title = "Mi Hub",
          SubTitle = "by yo",
          Theme = "Dark", -- o "Light"
          ToggleKey = Enum.KeyCode.RightShift,
      })

      local Tab = Window:Tab({ Title = "Main", Icon = "home" })
      Tab:Section({ Title = "Farm" })
      Tab:Toggle({ Title = "Auto Farm", Default = false, Callback = function(v) print(v) end })
      Tab:Slider({ Title = "Speed", Min = 1, Max = 100, Default = 16, Callback = print })
      Tab:Dropdown({ Title = "Mode", Values = {"A","B"}, Default = "A", Callback = print })
      Tab:Button({ Title = "Click", Callback = function() KiraUI:Notify({Title="OK", Content="Hola", Duration=2}) end })
]]

local KiraUI = {}
KiraUI.__index = KiraUI
KiraUI.Version = "1.0.0"

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- ==================== THEMES (Kira palette) ====================
local Themes = {
    Dark = {
        bg = Color3.fromRGB(12, 11, 10),
        rail = Color3.fromRGB(16, 15, 14),
        card = Color3.fromRGB(32, 30, 27),
        lift = Color3.fromRGB(42, 39, 35),
        fill = Color3.fromRGB(48, 44, 39),
        line = Color3.fromRGB(58, 53, 46),
        text = Color3.fromRGB(246, 242, 234),
        dim = Color3.fromRGB(168, 158, 144),
        mute = Color3.fromRGB(110, 102, 92),
        accent = Color3.fromRGB(214, 168, 108),
        accentDeep = Color3.fromRGB(92, 68, 36),
        accentHover = Color3.fromRGB(228, 186, 128),
        ink = Color3.fromRGB(22, 18, 14),
        ok = Color3.fromRGB(138, 166, 128),
        danger = Color3.fromRGB(200, 90, 80),
    },
    Light = {
        bg = Color3.fromRGB(232, 226, 218),
        rail = Color3.fromRGB(232, 226, 218),
        card = Color3.fromRGB(252, 250, 246),
        lift = Color3.fromRGB(242, 236, 228),
        fill = Color3.fromRGB(224, 218, 208),
        line = Color3.fromRGB(204, 196, 184),
        text = Color3.fromRGB(28, 24, 20),
        dim = Color3.fromRGB(92, 84, 74),
        mute = Color3.fromRGB(128, 120, 108),
        accent = Color3.fromRGB(168, 114, 56),
        accentDeep = Color3.fromRGB(120, 80, 38),
        accentHover = Color3.fromRGB(186, 132, 70),
        ink = Color3.fromRGB(252, 250, 246),
        ok = Color3.fromRGB(64, 118, 82),
        danger = Color3.fromRGB(180, 70, 60),
    },
}

local Fonts = {
    title = Enum.Font.GothamBold,
    mid = Enum.Font.GothamMedium,
    body = Enum.Font.Gotham,
    mono = Enum.Font.RobotoMono,
}

-- Lucide-style icon ids (subset)
local Icons = {
    home = "rbxassetid://10734557759",
    settings = "rbxassetid://10734950309",
    cog = "rbxassetid://10734950309",
    eye = "rbxassetid://10723346959",
    sword = "rbxassetid://10734975692",
    user = "rbxassetid://10747373176",
    info = "rbxassetid://10723415903",
    star = "rbxassetid://10734966248",
    zap = "rbxassetid://10723427441",
    shield = "rbxassetid://10734951847",
    map = "rbxassetid://10734886004",
    egg = "rbxassetid://10723383912",
    rocket = "rbxassetid://10734953436",
    layers = "rbxassetid://10734897250",
    out = "rbxassetid://10734886391",
    menu = "rbxassetid://10734887784",
    x = "rbxassetid://10747384394",
    minus = "rbxassetid://10734891440",
    maximize = "rbxassetid://10734896206",
    grid = "rbxassetid://10734885666",
    ["circle-dot"] = "rbxassetid://10723390785",
}

local function getIcon(name)
    if not name then return nil end
    if typeof(name) == "string" and name:find("rbxassetid://") then return name end
    return Icons[tostring(name):lower()] or Icons.home
end

local function tween(obj, props, t)
    local ti = TweenInfo.new(t or 0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    local tw = TweenService:Create(obj, ti, props)
    tw:Play()
    return tw
end

local function corner(parent, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = parent
    return c
end

local function stroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or Color3.fromRGB(58, 53, 46)
    s.Thickness = thickness or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

local function padding(parent, t, r, b, l)
    local p = Instance.new("UIPadding")
    p.PaddingTop = UDim.new(0, t or 0)
    p.PaddingRight = UDim.new(0, r or 0)
    p.PaddingBottom = UDim.new(0, b or 0)
    p.PaddingLeft = UDim.new(0, l or 0)
    p.Parent = parent
    return p
end

local function protectGui(gui)
    pcall(function()
        if gethui then
            gui.Parent = gethui()
        elseif syn and syn.protect_gui then
            syn.protect_gui(gui)
            gui.Parent = CoreGui
        else
            gui.Parent = CoreGui
        end
    end)
    if not gui.Parent then
        gui.Parent = PlayerGui
    end
end

-- ==================== NOTIFY ====================
local notifyHost
local function ensureNotifyHost()
    if notifyHost and notifyHost.Parent then return notifyHost end
    local sg = Instance.new("ScreenGui")
    sg.Name = "KiraUI_Notify_" .. tostring(math.random(1000, 9999))
    sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder = 999
    protectGui(sg)
    local holder = Instance.new("Frame")
    holder.Name = "Holder"
    holder.AnchorPoint = Vector2.new(1, 0)
    holder.Position = UDim2.new(1, -16, 0, 16)
    holder.Size = UDim2.new(0, 280, 1, -32)
    holder.BackgroundTransparency = 1
    holder.Parent = sg
    local list = Instance.new("UIListLayout")
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Padding = UDim.new(0, 8)
    list.HorizontalAlignment = Enum.HorizontalAlignment.Right
    list.Parent = holder
    notifyHost = holder
    return holder
end

function KiraUI:Notify(opts)
    opts = opts or {}
    local theme = Themes.Dark
    local host = ensureNotifyHost()
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 0)
    card.BackgroundColor3 = theme.card
    card.BorderSizePixel = 0
    card.ClipsDescendants = true
    card.Parent = host
    corner(card, 10)
    stroke(card, theme.line, 1)

    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 3, 1, 0)
    accentBar.BackgroundColor3 = theme.accent
    accentBar.BorderSizePixel = 0
    accentBar.Parent = card

    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, 14, 0, 10)
    title.Size = UDim2.new(1, -24, 0, 18)
    title.Font = Fonts.title
    title.TextSize = 14
    title.TextColor3 = theme.text
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Text = tostring(opts.Title or "Notify")
    title.Parent = card

    local body = Instance.new("TextLabel")
    body.BackgroundTransparency = 1
    body.Position = UDim2.new(0, 14, 0, 30)
    body.Size = UDim2.new(1, -24, 0, 28)
    body.Font = Fonts.body
    body.TextSize = 12
    body.TextColor3 = theme.dim
    body.TextXAlignment = Enum.TextXAlignment.Left
    body.TextYAlignment = Enum.TextYAlignment.Top
    body.TextWrapped = true
    body.Text = tostring(opts.Content or "")
    body.Parent = card

    tween(card, { Size = UDim2.new(1, 0, 0, 64) }, 0.25)
    task.delay(opts.Duration or 3, function()
        if card and card.Parent then
            local tw = tween(card, { Size = UDim2.new(1, 0, 0, 0) }, 0.2)
            tw.Completed:Wait()
            card:Destroy()
        end
    end)
end

-- ==================== WINDOW ====================
function KiraUI:CreateWindow(opts)
    opts = opts or {}
    local themeName = opts.Theme or "Dark"
    local T = Themes[themeName] or Themes.Dark
    local titleText = opts.Title or "KiraUI"
    local subText = opts.SubTitle or opts.Author or ""
    local toggleKey = opts.ToggleKey or Enum.KeyCode.RightShift

    local winW = IsMobile and 360 or (opts.Width or 620)
    local winH = IsMobile and 420 or (opts.Height or 430)
    local railW = IsMobile and 72 or 152

    local screen = Instance.new("ScreenGui")
    screen.Name = "KiraUI_" .. HttpService:GenerateGUID(false):sub(1, 8)
    screen.ResetOnSpawn = false
    screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screen.DisplayOrder = 100
    protectGui(screen)

    local root = Instance.new("Frame")
    root.Name = "Root"
    root.AnchorPoint = Vector2.new(0.5, 0.5)
    root.Position = UDim2.fromScale(0.5, 0.5)
    root.Size = UDim2.fromOffset(0, 0)
    root.BackgroundColor3 = T.bg
    root.BorderSizePixel = 0
    root.ClipsDescendants = true
    root.Parent = screen
    corner(root, 14)
    stroke(root, T.line, 1)

    -- open animation
    tween(root, { Size = UDim2.fromOffset(winW, winH) }, 0.35)

    -- RAIL (sidebar)
    local rail = Instance.new("Frame")
    rail.Name = "Rail"
    rail.Size = UDim2.new(0, railW, 1, 0)
    rail.BackgroundColor3 = T.rail
    rail.BorderSizePixel = 0
    rail.Parent = root

    local railLine = Instance.new("Frame")
    railLine.Size = UDim2.new(0, 1, 1, 0)
    railLine.Position = UDim2.new(1, -1, 0, 0)
    railLine.BackgroundColor3 = T.line
    railLine.BorderSizePixel = 0
    railLine.Parent = rail

    local brand = Instance.new("TextLabel")
    brand.BackgroundTransparency = 1
    brand.Position = UDim2.new(0, 12, 0, 14)
    brand.Size = UDim2.new(1, -20, 0, 22)
    brand.Font = Fonts.title
    brand.TextSize = 16
    brand.TextColor3 = T.text
    brand.TextXAlignment = Enum.TextXAlignment.Left
    brand.Text = titleText
    brand.TextTruncate = Enum.TextTruncate.AtEnd
    brand.Parent = rail

    local brandSub = Instance.new("TextLabel")
    brandSub.BackgroundTransparency = 1
    brandSub.Position = UDim2.new(0, 12, 0, 34)
    brandSub.Size = UDim2.new(1, -20, 0, 16)
    brandSub.Font = Fonts.body
    brandSub.TextSize = 11
    brandSub.TextColor3 = T.mute
    brandSub.TextXAlignment = Enum.TextXAlignment.Left
    brandSub.Text = subText
    brandSub.Parent = rail

    local tabList = Instance.new("ScrollingFrame")
    tabList.Name = "Tabs"
    tabList.Position = UDim2.new(0, 8, 0, 64)
    tabList.Size = UDim2.new(1, -16, 1, -120)
    tabList.BackgroundTransparency = 1
    tabList.BorderSizePixel = 0
    tabList.ScrollBarThickness = 2
    tabList.ScrollBarImageColor3 = T.mute
    tabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tabList.Parent = rail
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 4)
    tabLayout.Parent = tabList

    local themeBtn = Instance.new("TextButton")
    themeBtn.Size = UDim2.new(1, -16, 0, 28)
    themeBtn.Position = UDim2.new(0, 8, 1, -40)
    themeBtn.BackgroundColor3 = T.fill
    themeBtn.BorderSizePixel = 0
    themeBtn.Font = Fonts.mid
    themeBtn.TextSize = 12
    themeBtn.TextColor3 = T.dim
    themeBtn.Text = "Theme: " .. themeName
    themeBtn.AutoButtonColor = false
    themeBtn.Parent = rail
    corner(themeBtn, 8)

    -- TOPBAR
    local top = Instance.new("Frame")
    top.Name = "Topbar"
    top.Position = UDim2.new(0, railW, 0, 0)
    top.Size = UDim2.new(1, -railW, 0, 44)
    top.BackgroundColor3 = T.bg
    top.BorderSizePixel = 0
    top.Parent = root

    local topLine = Instance.new("Frame")
    topLine.Size = UDim2.new(1, 0, 0, 1)
    topLine.Position = UDim2.new(0, 0, 1, -1)
    topLine.BackgroundColor3 = T.line
    topLine.BorderSizePixel = 0
    topLine.Parent = top

    local pageTitle = Instance.new("TextLabel")
    pageTitle.BackgroundTransparency = 1
    pageTitle.Position = UDim2.new(0, 16, 0, 0)
    pageTitle.Size = UDim2.new(1, -120, 1, 0)
    pageTitle.Font = Fonts.title
    pageTitle.TextSize = 15
    pageTitle.TextColor3 = T.text
    pageTitle.TextXAlignment = Enum.TextXAlignment.Left
    pageTitle.Text = "Home"
    pageTitle.Parent = top

    -- window controls (minimize / close style Kira)
    local controls = Instance.new("Frame")
    controls.AnchorPoint = Vector2.new(1, 0.5)
    controls.Position = UDim2.new(1, -10, 0.5, 0)
    controls.Size = UDim2.new(0, 64, 0, 28)
    controls.BackgroundTransparency = 1
    controls.Parent = top
    local cLayout = Instance.new("UIListLayout")
    cLayout.FillDirection = Enum.FillDirection.Horizontal
    cLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    cLayout.Padding = UDim.new(0, 6)
    cLayout.Parent = controls

    local function makeWinBtn(txt, color)
        local b = Instance.new("TextButton")
        b.Size = UDim2.fromOffset(28, 28)
        b.BackgroundColor3 = T.fill
        b.BorderSizePixel = 0
        b.Text = txt
        b.Font = Fonts.title
        b.TextSize = 14
        b.TextColor3 = color or T.dim
        b.AutoButtonColor = false
        b.Parent = controls
        corner(b, 8)
        b.MouseEnter:Connect(function() tween(b, { BackgroundColor3 = T.lift }, 0.15) end)
        b.MouseLeave:Connect(function() tween(b, { BackgroundColor3 = T.fill }, 0.15) end)
        return b
    end

    local minBtn = makeWinBtn("–")
    local closeBtn = makeWinBtn("×", T.danger)

    -- CONTENT
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Position = UDim2.new(0, railW, 0, 44)
    content.Size = UDim2.new(1, -railW, 1, -44)
    content.BackgroundColor3 = T.bg
    content.BorderSizePixel = 0
    content.ClipsDescendants = true
    content.Parent = root

    -- Open bubble (when minimized/closed)
    local bubble = Instance.new("TextButton")
    bubble.Name = "OpenBubble"
    bubble.AnchorPoint = Vector2.new(0, 1)
    bubble.Position = UDim2.new(0, 18, 1, -18)
    bubble.Size = UDim2.fromOffset(52, 52)
    bubble.BackgroundColor3 = T.card
    bubble.BorderSizePixel = 0
    bubble.Text = ""
    bubble.Visible = false
    bubble.AutoButtonColor = false
    bubble.Parent = screen
    corner(bubble, 14)
    stroke(bubble, T.accent, 1.5)
    local bubbleLbl = Instance.new("TextLabel")
    bubbleLbl.BackgroundTransparency = 1
    bubbleLbl.Size = UDim2.fromScale(1, 1)
    bubbleLbl.Font = Fonts.title
    bubbleLbl.TextSize = 14
    bubbleLbl.TextColor3 = T.accent
    bubbleLbl.Text = "K"
    bubbleLbl.Parent = bubble

    local visible = true
    local function setVisible(v)
        visible = v
        root.Visible = v
        bubble.Visible = not v
    end

    minBtn.MouseButton1Click:Connect(function() setVisible(false) end)
    closeBtn.MouseButton1Click:Connect(function() setVisible(false) end)
    bubble.MouseButton1Click:Connect(function() setVisible(true) end)

    -- Drag window
    do
        local dragging, startPos, startInput
        top.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                startPos = root.Position
                startInput = input.Position
            end
        end)
        top.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - startInput
                root.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end

    -- Drag bubble
    do
        local dragging, startPos, startInput
        bubble.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                startPos = bubble.Position
                startInput = input.Position
            end
        end)
        bubble.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - startInput
                bubble.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end

    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == toggleKey then
            setVisible(not visible)
        end
    end)

    -- Theme toggle
    themeBtn.MouseButton1Click:Connect(function()
        themeName = (themeName == "Dark") and "Light" or "Dark"
        T = Themes[themeName]
        themeBtn.Text = "Theme: " .. themeName
        -- soft refresh main surfaces
        root.BackgroundColor3 = T.bg
        rail.BackgroundColor3 = T.rail
        top.BackgroundColor3 = T.bg
        content.BackgroundColor3 = T.bg
        brand.TextColor3 = T.text
        brandSub.TextColor3 = T.mute
        pageTitle.TextColor3 = T.text
        themeBtn.BackgroundColor3 = T.fill
        themeBtn.TextColor3 = T.dim
        bubble.BackgroundColor3 = T.card
        bubbleLbl.TextColor3 = T.accent
        KiraUI:Notify({ Title = "Theme", Content = themeName, Duration = 1.5 })
    end)

    local WindowObj = {
        _tabs = {},
        _theme = function() return T end,
        Screen = screen,
        Root = root,
    }

    function WindowObj:SetToggleKey(key)
        toggleKey = key
    end

    function WindowObj:Destroy()
        screen:Destroy()
    end

    function WindowObj:Tab(tabOpts)
        tabOpts = tabOpts or {}
        local tabTitle = tabOpts.Title or "Tab"
        local iconName = tabOpts.Icon

        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(1, 0, 0, 36)
        tabBtn.BackgroundColor3 = T.rail
        tabBtn.BorderSizePixel = 0
        tabBtn.Text = ""
        tabBtn.AutoButtonColor = false
        tabBtn.Parent = tabList
        corner(tabBtn, 8)

        local icon = Instance.new("ImageLabel")
        icon.BackgroundTransparency = 1
        icon.Position = UDim2.new(0, 10, 0.5, -8)
        icon.Size = UDim2.fromOffset(16, 16)
        icon.Image = getIcon(iconName)
        icon.ImageColor3 = T.mute
        icon.Parent = tabBtn

        local lbl = Instance.new("TextLabel")
        lbl.BackgroundTransparency = 1
        lbl.Position = UDim2.new(0, 32, 0, 0)
        lbl.Size = UDim2.new(1, -40, 1, 0)
        lbl.Font = Fonts.mid
        lbl.TextSize = 13
        lbl.TextColor3 = T.dim
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Text = tabTitle
        lbl.Parent = tabBtn

        local page = Instance.new("ScrollingFrame")
        page.Name = tabTitle
        page.Size = UDim2.fromScale(1, 1)
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.ScrollBarThickness = 3
        page.ScrollBarImageColor3 = T.mute
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        page.Visible = false
        page.Parent = content
        padding(page, 12, 14, 16, 14)
        local pageLayout = Instance.new("UIListLayout")
        pageLayout.Padding = UDim.new(0, 8)
        pageLayout.Parent = page

        local TabObj = { _page = page }

        local function selectTab()
            for _, tb in ipairs(WindowObj._tabs) do
                tb._page.Visible = false
                tb._btn.BackgroundColor3 = T.rail
                tb._lbl.TextColor3 = T.dim
                tb._icon.ImageColor3 = T.mute
            end
            page.Visible = true
            tabBtn.BackgroundColor3 = T.fill
            lbl.TextColor3 = T.text
            icon.ImageColor3 = T.accent
            pageTitle.Text = tabTitle
        end

        tabBtn.MouseButton1Click:Connect(selectTab)
        TabObj._btn = tabBtn
        TabObj._lbl = lbl
        TabObj._icon = icon
        TabObj.Select = selectTab

        local function makeRow(height)
            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, 0, 0, height or 44)
            row.BackgroundColor3 = T.card
            row.BorderSizePixel = 0
            row.Parent = page
            corner(row, 10)
            return row
        end

        function TabObj:Section(sopts)
            sopts = sopts or {}
            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, 0, 0, 22)
            row.BackgroundTransparency = 1
            row.Parent = page
            local t = Instance.new("TextLabel")
            t.BackgroundTransparency = 1
            t.Size = UDim2.fromScale(1, 1)
            t.Font = Fonts.mid
            t.TextSize = 12
            t.TextColor3 = T.accent
            t.TextXAlignment = Enum.TextXAlignment.Left
            t.Text = string.upper(tostring(sopts.Title or "Section"))
            t.Parent = row
            return row
        end

        function TabObj:Toggle(topts)
            topts = topts or {}
            local state = topts.Default or topts.Value or false
            local row = makeRow(48)
            local t = Instance.new("TextLabel")
            t.BackgroundTransparency = 1
            t.Position = UDim2.new(0, 12, 0, 6)
            t.Size = UDim2.new(1, -70, 0, 18)
            t.Font = Fonts.mid
            t.TextSize = 13
            t.TextColor3 = T.text
            t.TextXAlignment = Enum.TextXAlignment.Left
            t.Text = tostring(topts.Title or "Toggle")
            t.Parent = row
            if topts.Desc then
                local d = Instance.new("TextLabel")
                d.BackgroundTransparency = 1
                d.Position = UDim2.new(0, 12, 0, 26)
                d.Size = UDim2.new(1, -70, 0, 16)
                d.Font = Fonts.body
                d.TextSize = 11
                d.TextColor3 = T.mute
                d.TextXAlignment = Enum.TextXAlignment.Left
                d.Text = tostring(topts.Desc)
                d.Parent = row
            end
            local track = Instance.new("Frame")
            track.AnchorPoint = Vector2.new(1, 0.5)
            track.Position = UDim2.new(1, -12, 0.5, 0)
            track.Size = UDim2.fromOffset(40, 22)
            track.BackgroundColor3 = state and T.accent or T.fill
            track.BorderSizePixel = 0
            track.Parent = row
            corner(track, 11)
            local knob = Instance.new("Frame")
            knob.Size = UDim2.fromOffset(18, 18)
            knob.Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
            knob.BackgroundColor3 = T.text
            knob.BorderSizePixel = 0
            knob.Parent = track
            corner(knob, 9)
            local hit = Instance.new("TextButton")
            hit.Size = UDim2.fromScale(1, 1)
            hit.BackgroundTransparency = 1
            hit.Text = ""
            hit.Parent = row
            local function set(v, fire)
                state = v and true or false
                tween(track, { BackgroundColor3 = state and T.accent or T.fill }, 0.15)
                tween(knob, { Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9) }, 0.15)
                if fire and topts.Callback then
                    task.spawn(topts.Callback, state)
                end
            end
            hit.MouseButton1Click:Connect(function() set(not state, true) end)
            return { SetValue = function(_, v) set(v, false) end, Set = function(_, v) set(v, false) end }
        end

        function TabObj:Button(bopts)
            bopts = bopts or {}
            local row = makeRow(40)
            row.BackgroundColor3 = T.fill
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.fromScale(1, 1)
            btn.BackgroundTransparency = 1
            btn.Font = Fonts.mid
            btn.TextSize = 13
            btn.TextColor3 = T.text
            btn.Text = tostring(bopts.Title or "Button")
            btn.AutoButtonColor = false
            btn.Parent = row
            btn.MouseEnter:Connect(function() tween(row, { BackgroundColor3 = T.lift }, 0.12) end)
            btn.MouseLeave:Connect(function() tween(row, { BackgroundColor3 = T.fill }, 0.12) end)
            btn.MouseButton1Click:Connect(function()
                if bopts.Callback then task.spawn(bopts.Callback) end
            end)
            return btn
        end

        function TabObj:Slider(sopts)
            sopts = sopts or {}
            local min = (sopts.Value and sopts.Value.Min) or sopts.Min or 0
            local max = (sopts.Value and sopts.Value.Max) or sopts.Max or 100
            local val = (sopts.Value and sopts.Value.Default) or sopts.Default or min
            local row = makeRow(56)
            local t = Instance.new("TextLabel")
            t.BackgroundTransparency = 1
            t.Position = UDim2.new(0, 12, 0, 6)
            t.Size = UDim2.new(0.7, 0, 0, 16)
            t.Font = Fonts.mid
            t.TextSize = 13
            t.TextColor3 = T.text
            t.TextXAlignment = Enum.TextXAlignment.Left
            t.Text = tostring(sopts.Title or "Slider")
            t.Parent = row
            local valLbl = Instance.new("TextLabel")
            valLbl.BackgroundTransparency = 1
            valLbl.Position = UDim2.new(0.7, 0, 0, 6)
            valLbl.Size = UDim2.new(0.3, -12, 0, 16)
            valLbl.Font = Fonts.mono
            valLbl.TextSize = 12
            valLbl.TextColor3 = T.accent
            valLbl.TextXAlignment = Enum.TextXAlignment.Right
            valLbl.Text = tostring(val)
            valLbl.Parent = row
            local bar = Instance.new("Frame")
            bar.Position = UDim2.new(0, 12, 0, 34)
            bar.Size = UDim2.new(1, -24, 0, 6)
            bar.BackgroundColor3 = T.fill
            bar.BorderSizePixel = 0
            bar.Parent = row
            corner(bar, 3)
            local fill = Instance.new("Frame")
            fill.Size = UDim2.new(math.clamp((val - min) / math.max(max - min, 1), 0, 1), 0, 1, 0)
            fill.BackgroundColor3 = T.accent
            fill.BorderSizePixel = 0
            fill.Parent = bar
            corner(fill, 3)
            local sliding = false
            local function setFromX(x)
                local rel = math.clamp((x - bar.AbsolutePosition.X) / math.max(bar.AbsoluteSize.X, 1), 0, 1)
                val = math.floor((min + (max - min) * rel) + 0.5)
                fill.Size = UDim2.new(rel, 0, 1, 0)
                valLbl.Text = tostring(val)
                if sopts.Callback then task.spawn(sopts.Callback, val) end
            end
            bar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = true
                    setFromX(input.Position.X)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = false
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    setFromX(input.Position.X)
                end
            end)
            return { Set = function(_, v) val = v; fill.Size = UDim2.new(math.clamp((val - min) / math.max(max - min, 1), 0, 1), 0, 1, 0); valLbl.Text = tostring(val) end }
        end

        function TabObj:Dropdown(dopts)
            dopts = dopts or {}
            local values = dopts.Values or { "A", "B" }
            local selected = dopts.Default or dopts.Value or values[1]
            local open = false
            local row = makeRow(44)
            local t = Instance.new("TextLabel")
            t.BackgroundTransparency = 1
            t.Position = UDim2.new(0, 12, 0, 0)
            t.Size = UDim2.new(0.45, 0, 1, 0)
            t.Font = Fonts.mid
            t.TextSize = 13
            t.TextColor3 = T.text
            t.TextXAlignment = Enum.TextXAlignment.Left
            t.Text = tostring(dopts.Title or "Dropdown")
            t.Parent = row
            local sel = Instance.new("TextLabel")
            sel.BackgroundTransparency = 1
            sel.Position = UDim2.new(0.45, 0, 0, 0)
            sel.Size = UDim2.new(0.55, -12, 1, 0)
            sel.Font = Fonts.body
            sel.TextSize = 12
            sel.TextColor3 = T.accent
            sel.TextXAlignment = Enum.TextXAlignment.Right
            sel.Text = tostring(selected) .. "  ▼"
            sel.Parent = row
            local hit = Instance.new("TextButton")
            hit.Size = UDim2.fromScale(1, 1)
            hit.BackgroundTransparency = 1
            hit.Text = ""
            hit.Parent = row
            local options = Instance.new("Frame")
            options.Size = UDim2.new(1, 0, 0, 0)
            options.BackgroundColor3 = T.lift
            options.BorderSizePixel = 0
            options.ClipsDescendants = true
            options.Visible = false
            options.Parent = page
            corner(options, 8)
            local oLayout = Instance.new("UIListLayout")
            oLayout.Parent = options
            for _, v in ipairs(values) do
                local ob = Instance.new("TextButton")
                ob.Size = UDim2.new(1, 0, 0, 30)
                ob.BackgroundTransparency = 1
                ob.Font = Fonts.body
                ob.TextSize = 12
                ob.TextColor3 = T.dim
                ob.Text = tostring(v)
                ob.Parent = options
                ob.MouseButton1Click:Connect(function()
                    selected = v
                    sel.Text = tostring(v) .. "  ▼"
                    open = false
                    options.Visible = false
                    options.Size = UDim2.new(1, 0, 0, 0)
                    row.Size = UDim2.new(1, 0, 0, 44)
                    if dopts.Callback then task.spawn(dopts.Callback, v) end
                end)
            end
            hit.MouseButton1Click:Connect(function()
                open = not open
                options.Visible = open
                local h = open and (#values * 30) or 0
                options.Size = UDim2.new(1, 0, 0, h)
            end)
            return { SetValues = function(_, list) end }
        end

        function TabObj:Paragraph(popts)
            popts = popts or {}
            local row = makeRow(popts.Desc and 48 or 32)
            local t = Instance.new("TextLabel")
            t.BackgroundTransparency = 1
            t.Position = UDim2.new(0, 12, 0, 6)
            t.Size = UDim2.new(1, -24, 0, 16)
            t.Font = Fonts.mid
            t.TextSize = 13
            t.TextColor3 = T.text
            t.TextXAlignment = Enum.TextXAlignment.Left
            t.Text = tostring(popts.Title or "")
            t.Parent = row
            if popts.Desc then
                local d = Instance.new("TextLabel")
                d.BackgroundTransparency = 1
                d.Position = UDim2.new(0, 12, 0, 24)
                d.Size = UDim2.new(1, -24, 0, 16)
                d.Font = Fonts.body
                d.TextSize = 11
                d.TextColor3 = T.mute
                d.TextXAlignment = Enum.TextXAlignment.Left
                d.Text = tostring(popts.Desc)
                d.Parent = row
            end
            return row
        end

        function TabObj:Input(iopts)
            iopts = iopts or {}
            local row = makeRow(44)
            local t = Instance.new("TextLabel")
            t.BackgroundTransparency = 1
            t.Position = UDim2.new(0, 12, 0, 0)
            t.Size = UDim2.new(0.4, 0, 1, 0)
            t.Font = Fonts.mid
            t.TextSize = 13
            t.TextColor3 = T.text
            t.TextXAlignment = Enum.TextXAlignment.Left
            t.Text = tostring(iopts.Title or "Input")
            t.Parent = row
            local box = Instance.new("TextBox")
            box.AnchorPoint = Vector2.new(1, 0.5)
            box.Position = UDim2.new(1, -12, 0.5, 0)
            box.Size = UDim2.new(0.5, 0, 0, 28)
            box.BackgroundColor3 = T.fill
            box.BorderSizePixel = 0
            box.Font = Fonts.body
            box.TextSize = 12
            box.TextColor3 = T.text
            box.PlaceholderText = tostring(iopts.Placeholder or "")
            box.PlaceholderColor3 = T.mute
            box.Text = tostring(iopts.Default or "")
            box.ClearTextOnFocus = false
            box.Parent = row
            corner(box, 8)
            box.FocusLost:Connect(function()
                if iopts.Callback then task.spawn(iopts.Callback, box.Text) end
            end)
            return box
        end

        table.insert(WindowObj._tabs, TabObj)
        if #WindowObj._tabs == 1 then selectTab() end
        return TabObj
    end

    return WindowObj
end

return KiraUI
