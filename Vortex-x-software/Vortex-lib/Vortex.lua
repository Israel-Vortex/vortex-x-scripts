local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")

local LocalPlayer = Players.LocalPlayer

-- Limpieza de interfaces previas
for _, name in ipairs({"VXSHub", "ScreenGui", "NotificationFrame", "VXSHubToggle"}) do
    local oldGui = CoreGui:FindFirstChild(name)
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

-- Paleta de colores
local Colors = {
    Background = Color3.fromRGB(5, 5, 5),
    DarkSecondary = Color3.fromRGB(15, 15, 18),
    AccentPrimary = Color3.fromRGB(138, 43, 226),
    AccentSecondary = Color3.fromRGB(100, 30, 200),
    TextPrimary = Color3.fromRGB(252, 252, 255),
    TextMuted = Color3.fromRGB(160, 160, 175),
    TextDark = Color3.fromRGB(80, 80, 95)
}

-- Carga de módulos de iconos
pcall(function()
    local iconsScript = game:HttpGet("https://storage.relzhub.com/modules/icons.lua")
    loadstring(iconsScript)()
end)

-- Configuración de archivos
local placeName = string.gsub(MarketplaceService:GetProductInfo(game.PlaceId).Name, "[\\/:%*%?\"<>| ]", "")
local configPath = "VXSHUB/Library/" .. placeName .. "-" .. LocalPlayer.Name .. ".json"

local function ensureFolders()
    if not isfolder("VXSHUB") then makefolder("VXSHUB") end
    if not isfolder("VXSHUB/Library/") then makefolder("VXSHUB/Library/") end
end

getgenv().LoadConfig = function()
    ensureFolders()
    if not isfile(configPath) then
        writefile(configPath, HttpService:JSONEncode({
            LoadAnimation = true,
            SaveSettings = true,
            TranslateLanguage = "English",
            AutoTranslate = false
        }))
    end
end

getgenv().SaveConfig = function()
    ensureFolders()
    writefile(configPath, HttpService:JSONEncode({
        LoadAnimation = true,
        SaveSettings = true,
        TranslateLanguage = "English",
        AutoTranslate = false
    }))
end

ensureFolders()
if not isfile(configPath) then
    getgenv().SaveConfig()
end

-- Botón flotante para alternar la visibilidad
local ToggleGui = Instance.new("ScreenGui")
ToggleGui.Name = "VXSHubToggle"
ToggleGui.Parent = CoreGui
ToggleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local OutlineButton = Instance.new("Frame")
OutlineButton.Name = "OutlineButton"
OutlineButton.Size = UDim2.new(0, 44, 0, 44)
OutlineButton.Position = UDim2.new(0, 10, 0, 10)
OutlineButton.BackgroundColor3 = Colors.Background
OutlineButton.BackgroundTransparency = 0.05
OutlineButton.Parent = ToggleGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = OutlineButton

local ImageButton = Instance.new("ImageButton")
ImageButton.Size = UDim2.new(1, -16, 1, -16)
ImageButton.Position = UDim2.new(0.5, 0, 0.5, 0)
ImageButton.AnchorPoint = Vector2.new(0.5, 0.5)
ImageButton.BackgroundTransparency = 1
ImageButton.Image = "rbxassetid://102268449481061"
ImageButton.ImageColor3 = Colors.TextPrimary
ImageButton.AutoButtonColor = false
ImageButton.ScaleType = Enum.ScaleType.Fit
ImageButton.Parent = OutlineButton

local UICorner_2 = Instance.new("UICorner")
UICorner_2.CornerRadius = UDim.new(0, 10)
UICorner_2.Parent = ImageButton

ImageButton.MouseButton1Down:Connect(function()
    TweenService:Create(OutlineButton, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0,
        BackgroundColor3 = Colors.DarkSecondary
    }):Play()
end)

ImageButton.MouseButton1Up:Connect(function()
    TweenService:Create(OutlineButton, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.05,
        BackgroundColor3 = Colors.Background
    }):Play()
end)

ImageButton.MouseButton1Click:Connect(function()
    local mainGui = CoreGui:FindFirstChild("VXSHub")
    if mainGui then
        mainGui.Enabled = not mainGui.Enabled
    end
end)

-- Sistema de Notificaciones
local NotificationFrame = Instance.new("ScreenGui")
NotificationFrame.Name = "NotificationFrame"
NotificationFrame.Parent = CoreGui
NotificationFrame.ZIndexBehavior = Enum.ZIndexBehavior.Global

local Library = {}

function Library:Notify(config)
    config = typeof(config) == "table" and config or {}
    local title = config.Title or "Notificación"
    local desc = config.Desc or ""
    local icon = config.Icon
    local duration = config.Duration or 3

    local NotifShadow = Instance.new("Frame")
    NotifShadow.Name = "NotifShadow"
    NotifShadow.Size = UDim2.new(0, 320, 0, 65)
    NotifShadow.Position = UDim2.new(1, 400, 1, -20)
    NotifShadow.AnchorPoint = Vector2.new(1, 1)
    NotifShadow.BackgroundColor3 = Colors.Background
    NotifShadow.BackgroundTransparency = 0.05
    NotifShadow.ClipsDescendants = true
    NotifShadow.Parent = NotificationFrame

    local NotifCorner = Instance.new("UICorner")
    NotifCorner.CornerRadius = UDim.new(0, 12)
    NotifCorner.Parent = NotifShadow

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -80, 0, 20)
    TitleLabel.Position = UDim2.new(0, 15, 0, 12)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Font = Enum.Font.GothamMedium
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Colors.TextPrimary
    TitleLabel.TextSize = 15
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = NotifShadow

    local DescLabel = Instance.new("TextLabel")
    DescLabel.Size = UDim2.new(1, -40, 0, 20)
    DescLabel.Position = UDim2.new(0, 15, 0, 32)
    DescLabel.BackgroundTransparency = 1
    DescLabel.Font = Enum.Font.GothamMedium
    DescLabel.Text = desc
    DescLabel.TextColor3 = Colors.TextMuted
    DescLabel.TextSize = 13
    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescLabel.TextWrapped = true
    DescLabel.Parent = NotifShadow

    TweenService:Create(NotifShadow, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -20, 1, -20)
    }):Play()

    task.delay(duration, function()
        if NotifShadow then
            local tween = TweenService:Create(NotifShadow, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = UDim2.new(1, 400, NotifShadow.Position.Y.Scale, NotifShadow.Position.Y.Offset)
            })
            tween:Play()
            tween.Completed:Connect(function() NotifShadow:Destroy() end)
        end
    end)
end

function Library:Window(options)
    options = typeof(options) == "table" and options or {}
    local size = options.Size or Vector2.new(550, 380)
    
    local VXSHubGui = Instance.new("ScreenGui")
    VXSHubGui.Name = "VXSHub"
    VXSHubGui.IgnoreGuiInset = true
    VXSHubGui.DisplayOrder = 999
    VXSHubGui.Parent = CoreGui

    local OutlineMain = Instance.new("Frame")
    OutlineMain.Name = "OutlineMain"
    OutlineMain.AnchorPoint = Vector2.new(0.5, 0.5)
    OutlineMain.Position = UDim2.new(0.5, 0, 0.5, 0)
    OutlineMain.Size = UDim2.new(0, size.X, 0, size.Y)
    OutlineMain.BackgroundColor3 = Colors.Background
    OutlineMain.ClipsDescendants = true
    OutlineMain.Parent = VXSHubGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = OutlineMain

    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.new(1, 0, 1, 0)
    Main.BackgroundColor3 = Colors.Background
    Main.Parent = OutlineMain

    local MainCorner2 = Instance.new("UICorner")
    MainCorner2.CornerRadius = UDim.new(0, 10)
    MainCorner2.Parent = Main

    -- Barra superior (Top bar)
    local Top = Instance.new("Frame")
    Top.Name = "Top"
    Top.Size = UDim2.new(1, 0, 0, 48)
    Top.BackgroundColor3 = Colors.DarkSecondary
    Top.BorderSizePixel = 0
    Top.Parent = Main

    local TopTitle = Instance.new("TextLabel")
    TopTitle.Size = UDim2.new(0.5, 0, 0, 20)
    TopTitle.Position = UDim2.new(0, 15, 0, 8)
    TopTitle.BackgroundTransparency = 1
    TopTitle.Font = Enum.Font.GothamBold
    TopTitle.Text = options.Title or "VXS HUB"
    TopTitle.TextColor3 = Colors.TextPrimary
    TopTitle.TextSize = 15
    TopTitle.TextXAlignment = Enum.TextXAlignment.Left
    TopTitle.Parent = Top

    local TopSubTitle = Instance.new("TextLabel")
    TopSubTitle.Size = UDim2.new(0.5, 0, 0, 15)
    TopSubTitle.Position = UDim2.new(0, 15, 0, 26)
    TopSubTitle.BackgroundTransparency = 1
    TopSubTitle.Font = Enum.Font.GothamMedium
    TopSubTitle.Text = options.SubTitle or ""
    TopSubTitle.TextColor3 = Colors.TextMuted
    TopSubTitle.TextSize = 12
    TopSubTitle.TextXAlignment = Enum.TextXAlignment.Left
    TopSubTitle.Parent = Top

    local CloseWindowBtn = Instance.new("ImageButton")
    CloseWindowBtn.Size = UDim2.new(0, 28, 0, 28)
    CloseWindowBtn.Position = UDim2.new(1, -12, 0.5, 0)
    CloseWindowBtn.AnchorPoint = Vector2.new(1, 0.5)
    CloseWindowBtn.BackgroundTransparency = 1
    CloseWindowBtn.Image = "rbxassetid://10747384394"
    CloseWindowBtn.ImageColor3 = Colors.TextPrimary
    CloseWindowBtn.Parent = Top

    CloseWindowBtn.MouseButton1Click:Connect(function()
        VXSHubGui.Enabled = not VXSHubGui.Enabled
    end)

    -- Barra Lateral (Sidebar)
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 140, 1, -48)
    Sidebar.Position = UDim2.new(0, 0, 0, 48)
    Sidebar.BackgroundColor3 = Colors.DarkSecondary
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = Main

    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.Padding = UDim.new(0, 5)
    SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarLayout.Parent = Sidebar

    local SidebarPadding = Instance.new("UIPadding")
    SidebarPadding.PaddingTop = UDim.new(0, 10)
    SidebarPadding.Parent = Sidebar

    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -140, 1, -48)
    ContentContainer.Position = UDim2.new(0, 140, 0, 48)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = Main

    local WindowConfig = {}
    local CurrentTab = nil

    -- FUNCIÓN PARA CREAR PESTAÑAS (TABS)
    function WindowConfig:MakeTab(tabOptions)
        tabOptions = typeof(tabOptions) == "table" and tabOptions or {Name = tabOptions}
        local tabName = tabOptions.Name or "Tab"

        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName .. "Tab"
        TabButton.Size = UDim2.new(1, -20, 0, 32)
        TabButton.BackgroundColor3 = Colors.Background
        TabButton.BackgroundTransparency = 1 
        TabButton.Text = tabName
        TabButton.TextColor3 = Colors.TextMuted
        TabButton.Font = Enum.Font.GothamMedium
        TabButton.TextSize = 14
        TabButton.Parent = Sidebar

        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 6)
        TabCorner.Parent = TabButton

        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Name = tabName .. "Page"
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.BackgroundTransparency = 1
        TabPage.ScrollBarThickness = 2
        TabPage.ScrollBarImageColor3 = Colors.AccentPrimary
        TabPage.Visible = false
        TabPage.Parent = ContentContainer

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Padding = UDim.new(0, 8)
        PageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Parent = TabPage

        local PagePadding = Instance.new("UIPadding")
        PagePadding.PaddingTop = UDim.new(0, 10)
        PagePadding.PaddingBottom = UDim.new(0, 10)
        PagePadding.Parent = TabPage

        -- Lógica de selección de pestaña
        TabButton.MouseButton1Click:Connect(function()
            if CurrentTab then
                CurrentTab.Button.BackgroundTransparency = 1
                CurrentTab.Button.TextColor3 = Colors.TextMuted
                CurrentTab.Page.Visible = false
            end
            CurrentTab = {Button = TabButton, Page = TabPage}
            TabButton.BackgroundTransparency = 0
            TabButton.TextColor3 = Colors.TextPrimary
            TabPage.Visible = true
        end)

        -- Activar la primera pestaña por defecto
        if not CurrentTab then
            CurrentTab = {Button = TabButton, Page = TabPage}
            TabButton.BackgroundTransparency = 0
            TabButton.TextColor3 = Colors.TextPrimary
            TabPage.Visible = true
        end

        -- Retornar tabla para añadir botones, toggles, etc. a esta pestaña
        local TabElements = {}
        
        function TabElements:AddButton(btnOptions)
            -- Aquí irá la lógica de tus botones internos
            print("Botón añadido:", btnOptions.Name)
        end

        return TabElements
    end

    return WindowConfig
end

return Library
