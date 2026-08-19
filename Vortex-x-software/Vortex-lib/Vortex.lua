local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")

local LocalPlayer = Players.LocalPlayer

-- Obtener contenedor seguro de interfaz
local ParentGui = (gethui and gethui()) or (cloneref and cloneref(CoreGui)) or CoreGui

-- Limpieza de interfaces previas VXS (Se removió "ScreenGui" para evitar borrar contenedores del sistema)
for _, name in ipairs({"VXSHub", "NotificationFrame", "VXSToggle"}) do
    local oldGui = ParentGui:FindFirstChild(name)
    if oldGui then
        oldGui:Destroy()
    end
end

-- Prevención de AFK
LocalPlayer.Idled:Connect(function()
    local VirtualUser = game:GetService("VirtualUser")
    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

-- Paleta de colores VXS
local Colors = {
    Background = Color3.fromRGB(12, 12, 15),
    DarkSecondary = Color3.fromRGB(18, 18, 22),
    Sidebar = Color3.fromRGB(15, 15, 18),
    AccentPrimary = Color3.fromRGB(138, 43, 226),
    AccentSecondary = Color3.fromRGB(100, 30, 200),
    TextPrimary = Color3.fromRGB(252, 252, 255),
    TextMuted = Color3.fromRGB(160, 160, 175),
    TextDark = Color3.fromRGB(80, 80, 95),
    ItemBg = Color3.fromRGB(22, 22, 28)
}

-- Función para permitir arrastrar la ventana
local function MakeDraggable(dragHandle, frameToMove)
    local dragging, dragInput, dragStart, startPos
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frameToMove.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frameToMove.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Botón flotante para alternar visibilidad
local ToggleGui = Instance.new("ScreenGui")
ToggleGui.Name = "VXSToggle"
ToggleGui.Parent = ParentGui
ToggleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local OutlineButton = Instance.new("Frame")
OutlineButton.Name = "OutlineButton"
OutlineButton.Size = UDim2.new(0, 44, 0, 44)
OutlineButton.Position = UDim2.new(0, 10, 0, 10)
OutlineButton.BackgroundColor3 = Colors.Background
OutlineButton.Parent = ToggleGui

local UICornerBtn = Instance.new("UICorner")
UICornerBtn.CornerRadius = UDim.new(0, 10)
UICornerBtn.Parent = OutlineButton

local ImageButton = Instance.new("ImageButton")
ImageButton.Size = UDim2.new(1, -12, 1, -12)
ImageButton.Position = UDim2.new(0.5, 0, 0.5, 0)
ImageButton.AnchorPoint = Vector2.new(0.5, 0.5)
ImageButton.BackgroundTransparency = 1
ImageButton.Image = "rbxassetid://102268449481061"
ImageButton.ImageColor3 = Colors.TextPrimary
ImageButton.Parent = OutlineButton

ImageButton.MouseButton1Click:Connect(function()
    local mainGui = ParentGui:FindFirstChild("VXSHub")
    if mainGui then
        mainGui.Enabled = not mainGui.Enabled
    end
end)

-- Sistema de Notificaciones
local NotificationFrame = Instance.new("ScreenGui")
NotificationFrame.Name = "NotificationFrame"
NotificationFrame.Parent = ParentGui
NotificationFrame.ZIndexBehavior = Enum.ZIndexBehavior.Global

local Library = {}

function Library:Notify(config)
    config = typeof(config) == "table" and config or {}
    local title = config.Title or "Notificación"
    local desc = config.Desc or ""
    local duration = config.Duration or 3

    local NotifShadow = Instance.new("Frame")
    NotifShadow.Size = UDim2.new(0, 280, 0, 60)
    NotifShadow.Position = UDim2.new(1, 300, 1, -20)
    NotifShadow.AnchorPoint = Vector2.new(1, 1)
    NotifShadow.BackgroundColor3 = Colors.Background
    NotifShadow.Parent = NotificationFrame

    local NotifCorner = Instance.new("UICorner")
    NotifCorner.CornerRadius = UDim.new(0, 10)
    NotifCorner.Parent = NotifShadow

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -20, 0, 20)
    TitleLabel.Position = UDim2.new(0, 10, 0, 8)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Colors.TextPrimary
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = NotifShadow

    local DescLabel = Instance.new("TextLabel")
    DescLabel.Size = UDim2.new(1, -20, 0, 25)
    DescLabel.Position = UDim2.new(0, 10, 0, 28)
    DescLabel.BackgroundTransparency = 1
    DescLabel.Font = Enum.Font.Gotham
    DescLabel.Text = desc
    DescLabel.TextColor3 = Colors.TextMuted
    DescLabel.TextSize = 12
    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescLabel.TextWrapped = true
    DescLabel.Parent = NotifShadow

    TweenService:Create(NotifShadow, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -20, 1, -20)
    }):Play()

    task.delay(duration, function()
        if NotifShadow and NotifShadow.Parent then
            local tw = TweenService:Create(NotifShadow, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = UDim2.new(1, 300, 1, -20)
            })
            tw:Play()
            tw.Completed:Connect(function() NotifShadow:Destroy() end)
        end
    end)
end

function Library:Window(options)
    options = typeof(options) == "table" and options or {}
    local size = options.Size or Vector2.new(580, 380)

    local VXSHubGui = Instance.new("ScreenGui")
    VXSHubGui.Name = "VXSHub"
    VXSHubGui.IgnoreGuiInset = true
    VXSHubGui.DisplayOrder = 999
    VXSHubGui.Parent = ParentGui

    local OutlineMain = Instance.new("Frame")
    OutlineMain.Name = "OutlineMain"
    OutlineMain.AnchorPoint = Vector2.new(0.5, 0.5)
    OutlineMain.Position = UDim2.new(0.5, 0, 0.5, 0)
    OutlineMain.Size = UDim2.new(0, size.X, 0, size.Y)
    OutlineMain.BackgroundColor3 = Colors.Background
    OutlineMain.ClipsDescendants = true
    OutlineMain.Parent = VXSHubGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = OutlineMain

    -- Barra superior
    local Top = Instance.new("Frame")
    Top.Name = "Top"
    Top.Size = UDim2.new(1, 0, 0, 40)
    Top.BackgroundColor3 = Colors.DarkSecondary
    Top.Parent = OutlineMain

    MakeDraggable(Top, OutlineMain)

    local TopTitle = Instance.new("TextLabel")
    TopTitle.Size = UDim2.new(1, -50, 1, 0)
    TopTitle.Position = UDim2.new(0, 15, 0, 0)
    TopTitle.BackgroundTransparency = 1
    TopTitle.Font = Enum.Font.GothamBold
    TopTitle.Text = options.Title or "Vortex | x System"
    TopTitle.TextColor3 = Colors.TextPrimary
    TopTitle.TextSize = 14
    TopTitle.TextXAlignment = Enum.TextXAlignment.Left
    TopTitle.Parent = Top

    local CloseWindowBtn = Instance.new("TextButton")
    CloseWindowBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseWindowBtn.Position = UDim2.new(1, -35, 0.5, 0)
    CloseWindowBtn.AnchorPoint = Vector2.new(0, 0.5)
    CloseWindowBtn.BackgroundTransparency = 1
    CloseWindowBtn.Font = Enum.Font.GothamBold
    CloseWindowBtn.Text = "X"
    CloseWindowBtn.TextColor3 = Colors.TextMuted
    CloseWindowBtn.TextSize = 14
    CloseWindowBtn.Parent = Top

    CloseWindowBtn.MouseButton1Click:Connect(function()
        VXSHubGui.Enabled = not VXSHubGui.Enabled
    end)

    -- Sidebar (Menú de pestañas)
    local SideBar = Instance.new("ScrollingFrame")
    SideBar.Name = "SideBar"
    SideBar.Size = UDim2.new(0, 150, 1, -40)
    SideBar.Position = UDim2.new(0, 0, 0, 40)
    SideBar.BackgroundColor3 = Colors.Sidebar
    SideBar.BorderSizePixel = 0
    SideBar.ScrollBarThickness = 2
    SideBar.Parent = OutlineMain

    local SideLayout = Instance.new("UIListLayout")
    SideLayout.Padding = UDim.new(0, 4)
    SideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    SideLayout.Parent = SideBar

    local SidePadding = Instance.new("UIPadding")
    SidePadding.PaddingTop = UDim.new(0, 6)
    SidePadding.Parent = SideBar

    -- Contenedor de contenido
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -150, 1, -40)
    ContentContainer.Position = UDim2.new(0, 150, 0, 40)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = OutlineMain

    local WindowObject = {}
    local FirstTab = true

    function WindowObject:Tab(tabOptions)
        tabOptions = typeof(tabOptions) == "table" and tabOptions or { Title = tostring(tabOptions) }
        local tabTitle = tabOptions.Title or "Tab"

        -- Botón de la pestaña
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(0.9, 0, 0, 32)
        TabBtn.BackgroundColor3 = Colors.DarkSecondary
        TabBtn.BackgroundTransparency = 0.5
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.Text = "  " .. tabTitle
        TabBtn.TextColor3 = Colors.TextMuted
        TabBtn.TextSize = 12
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        TabBtn.Parent = SideBar

        local TabBtnCorner = Instance.new("UICorner")
        TabBtnCorner.CornerRadius = UDim.new(0, 6)
        TabBtnCorner.Parent = TabBtn

        -- Pagina de la pestaña
        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Name = tabTitle .. "Page"
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.BackgroundTransparency = 1
        TabPage.Visible = false
        TabPage.ScrollBarThickness = 3
        TabPage.Parent = ContentContainer

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Padding = UDim.new(0, 6)
        PageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        PageLayout.Parent = TabPage

        local PagePadding = Instance.new("UIPadding")
        PagePadding.PaddingTop = UDim.new(0, 8)
        PagePadding.PaddingBottom = UDim.new(0, 8)
        PagePadding.Parent = TabPage

        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabPage.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 16)
        end)

        local function ActivateTab()
            for _, child in ipairs(ContentContainer:GetChildren()) do
                if child:IsA("ScrollingFrame") then child.Visible = false end
            end
            for _, btn in ipairs(SideBar:GetChildren()) do
                if btn:IsA("TextButton") then
                    btn.TextColor3 = Colors.TextMuted
                    btn.BackgroundTransparency = 0.5
                end
            end
            TabPage.Visible = true
            TabBtn.TextColor3 = Colors.TextPrimary
            TabBtn.BackgroundTransparency = 0
        end

        TabBtn.MouseButton1Click:Connect(ActivateTab)

        if FirstTab then
            FirstTab = false
            ActivateTab()
        end

        -- Métodos de componentes para cada Tab
        local TabObject = {}

        function TabObject:Button(btnCfg)
            btnCfg = typeof(btnCfg) == "table" and btnCfg or { Title = tostring(btnCfg) }
            local btnText = btnCfg.Title or btnCfg.Name or "Button"
            local callback = btnCfg.Callback or function() end

            local BtnFrame = Instance.new("TextButton")
            BtnFrame.Size = UDim2.new(0.94, 0, 0, 34)
            BtnFrame.BackgroundColor3 = Colors.ItemBg
            BtnFrame.Font = Enum.Font.GothamMedium
            BtnFrame.Text = btnText
            BtnFrame.TextColor3 = Colors.TextPrimary
            BtnFrame.TextSize = 12
            BtnFrame.Parent = TabPage

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 6)
            Corner.Parent = BtnFrame

            BtnFrame.MouseButton1Click:Connect(function()
                pcall(callback)
            end)
            return BtnFrame
        end

        function TabObject:Toggle(tglCfg)
            tglCfg = typeof(tglCfg) == "table" and tglCfg or { Title = tostring(tglCfg) }
            local title = tglCfg.Title or tglCfg.Name or "Toggle"
            local state = tglCfg.Default or false
            local callback = tglCfg.Callback or function() end

            local TglFrame = Instance.new("TextButton")
            TglFrame.Size = UDim2.new(0.94, 0, 0, 34)
            TglFrame.BackgroundColor3 = Colors.ItemBg
            TglFrame.Text = ""
            TglFrame.Parent = TabPage

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 6)
            Corner.Parent = TglFrame

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(0.7, 0, 1, 0)
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Font = Enum.Font.GothamMedium
            Label.Text = title
            Label.TextColor3 = Colors.TextPrimary
            Label.TextSize = 12
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = TglFrame

            local Indicator = Instance.new("Frame")
            Indicator.Size = UDim2.new(0, 18, 0, 18)
            Indicator.Position = UDim2.new(1, -28, 0.5, -9)
            Indicator.BackgroundColor3 = state and Colors.AccentPrimary or Colors.DarkSecondary
            Indicator.Parent = TglFrame

            local IndCorner = Instance.new("UICorner")
            IndCorner.CornerRadius = UDim.new(0, 4)
            IndCorner.Parent = Indicator

            TglFrame.MouseButton1Click:Connect(function()
                state = not state
                Indicator.BackgroundColor3 = state and Colors.AccentPrimary or Colors.DarkSecondary
                pcall(callback, state)
            end)
            return TglFrame
        end

        function TabObject:Slider(sldCfg)
            sldCfg = typeof(sldCfg) == "table" and sldCfg or {}
            local title = sldCfg.Title or "Slider"
            local min = sldCfg.Min or 0
            local max = sldCfg.Max or 100
            local def = sldCfg.Default or min
            local callback = sldCfg.Callback or function() end

            local SldFrame = Instance.new("Frame")
            SldFrame.Size = UDim2.new(0.94, 0, 0, 42)
            SldFrame.BackgroundColor3 = Colors.ItemBg
            SldFrame.Parent = TabPage

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 6)
            Corner.Parent = SldFrame

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(0.7, 0, 0, 20)
            Label.Position = UDim2.new(0, 10, 0, 4)
            Label.BackgroundTransparency = 1
            Label.Font = Enum.Font.GothamMedium
            Label.Text = title
            Label.TextColor3 = Colors.TextPrimary
            Label.TextSize = 12
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = SldFrame

            local ValLabel = Instance.new("TextLabel")
            ValLabel.Size = UDim2.new(0.2, 0, 0, 20)
            ValLabel.Position = UDim2.new(0.8, -10, 0, 4)
            ValLabel.BackgroundTransparency = 1
            ValLabel.Font = Enum.Font.GothamMedium
            ValLabel.Text = tostring(def)
            ValLabel.TextColor3 = Colors.TextMuted
            ValLabel.TextSize = 12
            ValLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValLabel.Parent = SldFrame

            local Bar = Instance.new("TextButton")
            Bar.Size = UDim2.new(0.92, 0, 0, 6)
            Bar.Position = UDim2.new(0.04, 0, 0, 28)
            Bar.BackgroundColor3 = Colors.DarkSecondary
            Bar.Text = ""
            Bar.Parent = SldFrame

            local Fill = Instance.new("Frame")
            Fill.Size = UDim2.new(math.clamp((def - min) / (max - min), 0, 1), 0, 1, 0)
            Fill.BackgroundColor3 = Colors.AccentPrimary
            Fill.BorderSizePixel = 0
            Fill.Parent = Bar

            local dragging = false
            local function update(input)
                local percent = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                local val = math.floor(min + (max - min) * percent)
                Fill.Size = UDim2.new(percent, 0, 1, 0)
                ValLabel.Text = tostring(val)
                pcall(callback, val)
            end

            Bar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    update(input)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    update(input)
                end
            end)
            return SldFrame
        end

        function TabObject:Dropdown(drpCfg)
            drpCfg = typeof(drpCfg) == "table" and drpCfg or {}
            local title = drpCfg.Title or "Dropdown"
            local list = drpCfg.Options or drpCfg.List or {}
            local callback = drpCfg.Callback or function() end

            local DrpFrame = Instance.new("Frame")
            DrpFrame.Size = UDim2.new(0.94, 0, 0, 34)
            DrpFrame.BackgroundColor3 = Colors.ItemBg
            DrpFrame.ClipsDescendants = true
            DrpFrame.Parent = TabPage

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 6)
            Corner.Parent = DrpFrame

            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, 0, 0, 34)
            Btn.BackgroundTransparency = 1
            Btn.Font = Enum.Font.GothamMedium
            Btn.Text = "  " .. title
            Btn.TextColor3 = Colors.TextPrimary
            Btn.TextSize = 12
            Btn.TextXAlignment = Enum.TextXAlignment.Left
            Btn.Parent = DrpFrame

            local open = false
            Btn.MouseButton1Click:Connect(function()
                open = not open
                DrpFrame.Size = open and UDim2.new(0.94, 0, 0, 34 + (#list * 26)) or UDim2.new(0.94, 0, 0, 34)
            end)

            for i, opt in ipairs(list) do
                local OptBtn = Instance.new("TextButton")
                OptBtn.Size = UDim2.new(0.9, 0, 0, 24)
                OptBtn.Position = UDim2.new(0.05, 0, 0, 34 + ((i - 1) * 26))
                OptBtn.BackgroundColor3 = Colors.DarkSecondary
                OptBtn.Font = Enum.Font.Gotham
                OptBtn.Text = tostring(opt)
                OptBtn.TextColor3 = Colors.TextMuted
                OptBtn.TextSize = 11
                OptBtn.Parent = DrpFrame

                local OptCorner = Instance.new("UICorner")
                OptCorner.CornerRadius = UDim.new(0, 4)
                OptCorner.Parent = OptBtn

                OptBtn.MouseButton1Click:Connect(function()
                    Btn.Text = "  " .. title .. ": " .. tostring(opt)
                    open = false
                    DrpFrame.Size = UDim2.new(0.94, 0, 0, 34)
                    pcall(callback, opt)
                end)
            end
            return DrpFrame
        end

        function TabObject:Section(secCfg)
            local title = typeof(secCfg) == "table" and (secCfg.Title or secCfg.Name) or tostring(secCfg)
            local SecLabel = Instance.new("TextLabel")
            SecLabel.Size = UDim2.new(0.94, 0, 0, 24)
            SecLabel.BackgroundTransparency = 1
            SecLabel.Font = Enum.Font.GothamBold
            SecLabel.Text = title
            SecLabel.TextColor3 = Colors.AccentPrimary
            SecLabel.TextSize = 12
            SecLabel.TextXAlignment = Enum.TextXAlignment.Left
            SecLabel.Parent = TabPage
            return SecLabel
        end

        function TabObject:Label(lblCfg)
            local title = typeof(lblCfg) == "table" and (lblCfg.Title or lblCfg.Text) or tostring(lblCfg)
            local Lbl = Instance.new("TextLabel")
            Lbl.Size = UDim2.new(0.94, 0, 0, 20)
            Lbl.BackgroundTransparency = 1
            Lbl.Font = Enum.Font.Gotham
            Lbl.Text = title
            Lbl.TextColor3 = Colors.TextMuted
            Lbl.TextSize = 11
            Lbl.TextXAlignment = Enum.TextXAlignment.Left
            Lbl.Parent = TabPage
            return Lbl
        end

        -- Alias de compatibilidad
        TabObject.AddButton = TabObject.Button
        TabObject.AddToggle = TabObject.Toggle
        TabObject.AddSlider = TabObject.Slider
        TabObject.AddDropdown = TabObject.Dropdown
        TabObject.AddSection = TabObject.Section
        TabObject.AddLabel = TabObject.Label

        return TabObject
    end

    return WindowObject
end

return Library
