local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local afkConns = {}
local afkRunning = true

do
	local VirtualUser = game:GetService("VirtualUser")

	local function silenceIdle()
		local ok, list = pcall(function()
			return getconnections(LocalPlayer.Idled)
		end)

		if not ok or type(list) ~= "table" then
			return
		end

		for _, connection in ipairs(list) do
			pcall(function()
				connection:Disable()
			end)
		end
	end

	local function nudge()
		pcall(function()
			VirtualUser:CaptureController()
			VirtualUser:ClickButton2(Vector3.new())
		end)
	end

	silenceIdle()

	afkConns[#afkConns + 1] = LocalPlayer.Idled:Connect(nudge)

	task.spawn(function()
		while afkRunning do
			task.wait(60)

			if not afkRunning or not LocalPlayer.Parent then
				break
			end

			silenceIdle()
			nudge()
		end
	end)
end

local function resolveGuiRoot()
	local ok, hidden = pcall(function()
		return gethui()
	end)
	if ok and typeof(hidden) == "Instance" then
		return hidden
	end

	local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
	if playerGui then
		return playerGui
	end

	return LocalPlayer:WaitForChild("PlayerGui", 10) or CoreGui
end

local GuiRoot = resolveGuiRoot()

for _, container in ipairs({ GuiRoot, CoreGui }) do
	for _, name in ipairs({ "UniverseESPGui", "UniverseCrystalEsp" }) do
		pcall(function()
			local existing = container:FindFirstChild(name)
			if existing then
				existing:Destroy()
			end
		end)
	end
end

local function findRemote(name)
	local folder = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:WaitForChild("Remotes", 10)
	if not folder then
		return nil
	end
	return folder:FindFirstChild(name) or folder:WaitForChild(name, 5)
end

local SellRequest = findRemote("SellRequest")
local GoHome = findRemote("GoHome")
local HoldComplete = findRemote("CrystalHoldComplete")
local ToggleFavorite = findRemote("ToggleFavorite")

local ESP = {
	font = Enum.Font.GothamBold,
	sweep = 0.5,
	budget = 0.005,
	offset = Vector3.new(0, 3, 0),
	width = 250,
	height = 66,
	text = 16,
	ttl = 5,
}

pcall(function()
	ESP.font = Enum.Font.LuckiestGuy
end)

local PLAYER = {
	offset = Vector3.new(0, -8, 0),
	width = 220,
	height = 44,
	text = 15,
}

local PACE = {
	boost = 35,
	normal = 16,
	stats = 0.25,
	distance = 0.05,
}

local TP = {
	offset = Vector3.new(0, 4.5, 0),
	hold = 0.35,
	clear = {
		Vector3.new(0, 0, 0),
		Vector3.new(0, 3, 0),
		Vector3.new(0, 7, 0),
		Vector3.new(5, 3, 0),
		Vector3.new(-5, 3, 0),
		Vector3.new(0, 3, 5),
		Vector3.new(0, 3, -5),
		Vector3.new(0, 12, 0),
		Vector3.new(9, 6, 0),
		Vector3.new(-9, 6, 0),
		Vector3.new(0, 6, 9),
		Vector3.new(0, 6, -9),
		Vector3.new(0, 20, 0),
	},
}

local PICK = {
	aimRange = 5000,
	aimDot = 0.995,
	range = 13,
	cooldown = 0.04,
	restore = 0.2,
	burst = 8,
	retry = 0.15,
	forget = 5,
	pad = 4,
	instantRadius = 60,
	instantTick = 0.25,
}

local COLORS = {
	money = Color3.fromRGB(60, 255, 90),
	default = Color3.fromRGB(0, 225, 255),
	extra = Color3.fromRGB(255, 255, 255),
	player = Color3.fromRGB(255, 40, 140),
	stroke = Color3.fromRGB(0, 0, 0),
	hexDistance = "00E5FF",
	hexLuck = "FFC400",
}

local TIER_NAMES = { "Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic" }

local LUCK = {
	rarity = { 1, 1.6, 2.6, 4.2, 7, 12 },
	base = 0.00045,
	exponent = 0.5,
	cap = 500,
	bomb = 3,
	blood = 4,
}

local MUTATION_LUCK = {
	Verdant = 15,
	Voltaic = 20,
	Gilded = 18,
	Onyx = 28,
	Terminus = 40,
	Frost = 1.4,
	Fire = 1.4,
	Thunder = 1.5,
	Starfall = 1.3,
	Aurora = 2.2,
	Radioactive = 2,
	Poison = 1.5,
	Wet = 1,
}

local WATCHED_ATTRIBUTES = {
	"Value",
	"Collected",
	"WeightKg",
	"Tier",
	"TierName",
	"CrystalName",
	"Mutation",
	"ExtraMutations",
}

local SUFFIXES = { "", "k", "M", "B", "T", "Qa" }
local PARSE_MULTIPLIERS = { k = 1e3, m = 1e6, b = 1e9, t = 1e12, qa = 1e15 }
local CONTAINER_NAMES = { "DroppedCrystals", "Crystals" }

-- Configuración y Carga de WindUI
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

WindUI:Notify({ Title = "Vortex x Software", Content = "Iniciando sesion... Por favor espera.", Duration = 3 })
task.wait(3)
WindUI:Notify({ Title = "Vortex x Software", Content = "Acceso Concedido, " .. LocalPlayer.Name .. "! Cargando interfaz...", Duration = 2 })
task.wait(2)

WindUI:AddTheme({
    Name = "VortexCrimsonSolid",
    Accent = WindUI:Gradient({ ["0"] = { Color = Color3.fromRGB(150, 0, 30), Transparency = 0 }, ["100"] = { Color = Color3.fromRGB(255, 30, 80), Transparency = 0 } }, { Rotation = 45 }),
    Background = Color3.fromRGB(12, 12, 12), BackgroundTransparency = 0, Outline = Color3.fromRGB(255, 30, 80),
    Text = Color3.fromRGB(245, 245, 245), Placeholder = Color3.fromRGB(150, 150, 150), Button = Color3.fromRGB(210, 15, 60),
    Icon = Color3.fromRGB(255, 50, 90), Hover = Color3.fromRGB(255, 255, 255),
    WindowBackground = WindUI:Gradient({ ["0"] = { Color = Color3.fromRGB(16, 16, 16), Transparency = 0 }, ["100"] = { Color = Color3.fromRGB(10, 10, 10), Transparency = 0 } }, { Rotation = 45 }),
    WindowShadow = Color3.fromRGB(255, 30, 80), DialogBackground = Color3.fromRGB(22, 22, 22), DialogBackgroundTransparency = 0,
    DialogTitle = Color3.fromRGB(255, 255, 255), DialogContent = Color3.fromRGB(220, 220, 220), DialogIcon = Color3.fromRGB(255, 50, 90),
    WindowTopbarButtonIcon = Color3.fromRGB(255, 255, 255), WindowTopbarTitle = Color3.fromRGB(255, 255, 255),
    WindowTopbarAuthor = Color3.fromRGB(180, 180, 180), WindowTopbarIcon = Color3.fromRGB(255, 50, 90),
    TabBackground = Color3.fromRGB(20, 20, 20), TabTitle = Color3.fromRGB(240, 240, 240), TabIcon = Color3.fromRGB(255, 50, 90),
    ElementBackground = Color3.fromRGB(22, 22, 22), ElementTitle = Color3.fromRGB(255, 255, 255), ElementDesc = Color3.fromRGB(170, 170, 170),
    ElementIcon = Color3.fromRGB(255, 50, 90), PopupBackground = Color3.fromRGB(22, 22, 22), PopupBackgroundTransparency = 0,
    PopupTitle = Color3.fromRGB(255, 255, 255), PopupContent = Color3.fromRGB(200, 200, 200), PopupIcon = Color3.fromRGB(255, 50, 90),
    Toggle = WindUI:Gradient({ ["0"] = { Color = Color3.fromRGB(150, 0, 30), Transparency = 0 }, ["100"] = { Color = Color3.fromRGB(255, 30, 80), Transparency = 0 } }, { Rotation = 90 }),
    ToggleBar = Color3.fromRGB(30, 30, 30), Checkbox = Color3.fromRGB(30, 30, 30), CheckboxIcon = Color3.fromRGB(255, 255, 255),
    Slider = WindUI:Gradient({ ["0"] = { Color = Color3.fromRGB(150, 0, 30), Transparency = 0 }, ["100"] = { Color = Color3.fromRGB(255, 30, 80), Transparency = 0 } }, { Rotation = 0 }),
    SliderThumb = Color3.fromRGB(255, 255, 255)
})
WindUI:SetTheme("VortexCrimsonSolid")

local Window = WindUI:CreateWindow({
    Title = "Vortex x Software [MINE A MOUNTAIN]",
    Icon = "rbxassetid://80571845178865",
    IconSize = 35,
    Author = "by ISRAEL CC",
    Folder = "VortexXSoftwareMineAMountain",
    Resizable = false,
    HideSearchBar = true,
    Transparent = false,
    Theme = "VortexCrimsonSolid",
    User = { Enabled = true, Anonymous = false }
})

Window:EditOpenButton({
    Title = "VXS",
    Icon = "rbxassetid://80571845178865",
    CornerRadius = UDim.new(1, 0),
    StrokeThickness = 2,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 0, 30)),
        ColorSequenceKeypoint.new(0.4, Color3.fromRGB(230, 0, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 50, 90))
    }),
    OnlyMobile = true,
    Enabled = true,
    Draggable = true
})

Window:Tag({ Title = "v3.3.44", Icon = "github", Color = Color3.fromRGB(230, 0, 50) })
Window:SetToggleKey(Enum.KeyCode.RightAlt)

local Tabs = {
	Crystals = Window:Tab({ Title = "Crystals", Icon = "gem" }),
	Players = Window:Tab({ Title = "Players", Icon = "users" }),
	Boulders = Window:Tab({ Title = "Boulders", Icon = "mountain" }),
	Teleports = Window:Tab({ Title = "Teleports", Icon = "crosshair" }),
	Farming = Window:Tab({ Title = "Farming", Icon = "pickaxe" }),
	Movement = Window:Tab({ Title = "Movement", Icon = "zap" }),
	Settings = Window:Tab({ Title = "Settings", Icon = "settings" }),
}

local EspHolder = Instance.new("Folder")
EspHolder.Name = "UniverseCrystalEsp"
EspHolder.Parent = GuiRoot

local registry = {}
local registryCount = 0
local candidates = {}
local dirty = {}
local espCache = {}
local espCount = 0
local containerConns = {}
local playerCache = {}

local espActive = false
local playerEspActive = false
local speedActive = false
local speedHooked
local speedConn
local minValue = 2000000
local valueFilter = true
local espScale = 0.7
local playerScale = 0.6
local boulderScale = 0.6
local rootPart
local lastReport = 0
local tpState
local sweepAccumulator = math.huge
local statsDirty = true

local statsAccumulator = 0
local distanceAccumulator = math.huge
local lastPickup = 0
local autoPickupActive = false
local autoFarmActive = false
local autoSellActive = false
local lastBagWarn = 0
local instantPromptActive = false
local instantPatched = {}
local instantAccumulator = math.huge

local function reportError(context, err)
	local now = os.clock()
	if now - lastReport < 5 then
		return
	end
	lastReport = now
	warn(string.format("[Mine a Mountain] %s: %s", context, tostring(err)))
end

local function formatShort(n, prefix)
	n = tonumber(n) or 0
	prefix = prefix or ""

	local sign = n < 0 and "-" or ""
	n = math.abs(n)

	if n < 1000 then
		return string.format("%s%s%d", sign, prefix, math.floor(n + 0.5))
	end

	local index = 0
	while n >= 1000 and index < #SUFFIXES - 1 do
		n /= 1000
		index += 1
	end

	return string.format("%s%s%.2f%s", sign, prefix, n, SUFFIXES[index + 1])
end

local function formatWeight(kg)
	kg = tonumber(kg) or 0
	if kg >= 1000 then
		return formatShort(kg) .. "kg"
	end
	return string.format("%.1fkg", kg)
end

local function formatDistance(studs)
	studs = tonumber(studs) or 0
	if studs >= 1000 then
		return string.format("%.1fkm", studs / 1000)
	end
	return string.format("%dm", math.floor(studs + 0.5))
end

local function formatLuck(score)
	local pct = (tonumber(score) or 0) * 100

	if pct <= 0 then
		return "+0%"
	end
	if pct < 1 then
		return string.format("+%.2f%%", pct)
	end
	if pct < 10 then
		return string.format("+%.1f%%", pct)
	end
	return string.format("+%.0f%%", pct)
end

local function parseValue(text)
	if type(text) ~= "string" then
		return nil
	end

	local cleaned = text:lower():gsub("[%s,%$_]", "")
	if cleaned == "" then
		return 0
	end

	local number, suffix = cleaned:match("^(%d*%.?%d+)(%a*)$")
	if not number then
		return nil
	end

	local base = tonumber(number)
	if not base then
		return nil
	end

	if suffix == "" then
		return base
	end

	local multiplier = PARSE_MULTIPLIERS[suffix]
	if not multiplier then
		return nil
	end

	return base * multiplier
end

local function bindCharacter(character)
	if not character then
		rootPart = nil
		return
	end
	rootPart = character:FindFirstChild("HumanoidRootPart")
end

bindCharacter(LocalPlayer.Character)

local characterConn = LocalPlayer.CharacterAdded:Connect(function(character)
	rootPart = nil
	tpState = nil

	local waiter
	waiter = character.ChildAdded:Connect(function(child)
		if child.Name == "HumanoidRootPart" then
			rootPart = child
			waiter:Disconnect()
		end
	end)

	bindCharacter(character)
	if rootPart then
		waiter:Disconnect()
	end
end)

local function getRoot()
	if rootPart and rootPart.Parent then
		return rootPart
	end
	bindCharacter(LocalPlayer.Character)
	return rootPart
end

local function getAttr(inst, name)
	local ok, value = pcall(inst.GetAttribute, inst, name)
	if ok then
		return value
	end
	return nil
end

local function crystalValue(inst)
	return tonumber(getAttr(inst, "Value")) or 0
end

local function crystalWeight(inst)
	return tonumber(getAttr(inst, "WeightKg")) or 0
end

local function crystalTier(inst)
	return tonumber(getAttr(inst, "Tier")) or 0
end

local function crystalRarity(inst)
	local name = getAttr(inst, "TierName")
	if type(name) == "string" and name ~= "" then
		return name
	end
	return TIER_NAMES[crystalTier(inst)] or "Unknown"
end

local function crystalName(inst)
	local name = getAttr(inst, "CrystalName")
	if type(name) == "string" and name ~= "" then
		return name
	end
	return inst.Name
end

local function crystalColor(inst)
	local r = tonumber(getAttr(inst, "TierColorR"))
	local g = tonumber(getAttr(inst, "TierColorG"))
	local b = tonumber(getAttr(inst, "TierColorB"))
	if r and g and b then
		return Color3.fromRGB(r, g, b)
	end
	return COLORS.default
end

local function mutationLuck(name)
	if type(name) ~= "string" or name == "" then
		return 1
	end
	return MUTATION_LUCK[name] or 1
end

local function combinedLuckMult(inst)
	local mutation = getAttr(inst, "Mutation")
	local roll = tonumber(getAttr(inst, "MutationLuckRoll"))
	local multiplier = (roll and roll > 0) and roll or mutationLuck(mutation)

	local extra = getAttr(inst, "ExtraMutations")
	if type(extra) == "string" and extra ~= "" then
		for name in string.gmatch(extra, "[^,]+") do
			if name ~= "" then
				multiplier *= mutationLuck(name)
			end
		end
	end

	if getAttr(inst, "IsBloodCrystal") == true then
		multiplier *= LUCK.blood
	end

	if getAttr(inst, "AdminMutation") == "Radioactive" and mutation ~= "Radioactive" then
		local hasRadioactive = type(extra) == "string" and extra:find("Radioactive", 1, true) ~= nil
		if not hasRadioactive then
			multiplier *= mutationLuck("Radioactive")
		end
	end

	return multiplier
end

local function computeLuck(inst)
	local tier = crystalTier(inst)
	if tier <= 0 then
		return 0
	end

	local weight = math.max(0, crystalWeight(inst))
	local base = (LUCK.rarity[tier] or LUCK.rarity[1]) * math.min(weight, LUCK.cap) ^ LUCK.exponent * LUCK.base

	if getAttr(inst, "BombCrystal") == true then
		base *= LUCK.bomb
	end

	return base * combinedLuckMult(inst)
end

local function luckLabel(inst)
	local hover = inst:FindFirstChild("CrystalHover")
	if not hover then
		return nil
	end

	local label = hover:FindFirstChild("LuckBoost")
	if not label or not label:IsA("TextLabel") then
		return nil
	end

	return label
end

local function luckLabelText(inst)
	local label = luckLabel(inst)
	if not label then
		return nil
	end
	return label.Text
end

local function crystalLuck(inst)
	local text = luckLabelText(inst)
	if type(text) == "string" then
		local pct = tonumber(text:match("([%d%.]+)%s*%%"))
		if pct and pct > 0 then
			return pct / 100
		end
	end
	return computeLuck(inst)
end

local function meetsFilter(inst, value)
	if not valueFilter then
		return true
	end

	return (value or crystalValue(inst)) >= minValue
end

local function ownsGamepass(name)
	local folder = LocalPlayer:FindFirstChild("GamepassesOwned")
	if not folder then
		return false
	end

	local flag = folder:FindFirstChild(name)
	return flag ~= nil and flag:IsA("BoolValue") and flag.Value == true
end

local function realStat(name)
	local data = LocalPlayer:FindFirstChild("PlayerData")
	local stats = data and data:FindFirstChild("RealStats")
	local entry = stats and stats:FindFirstChild(name)
	if not entry then
		return nil
	end
	return tonumber(entry.Value)
end

local function hasActiveRune(keyword)
	local data = LocalPlayer:FindFirstChild("PlayerData")
	local plot = data and data:FindFirstChild("PlotData")
	local runes = plot and plot:FindFirstChild("Runes")
	if not runes then
		return false
	end

	for _, child in ipairs(runes:GetChildren()) do
		local runeName = child:GetAttribute("RuneName")
		if type(runeName) == "string" and runeName:find(keyword, 1, true) then
			if (tonumber(child:GetAttribute("Remaining")) or 0) > 0 then
				return true
			end
		end
	end

	return false
end

local function backpackCapacity()
	if LocalPlayer:GetAttribute("InfBackpack") == true then
		return math.huge
	end

	local base = realStat("CarryWeight") or 10
	if ownsGamepass("CarryKgPlus4") then
		base *= 4
	end

	local total = base + (realStat("CarryWeightBonus") or 0)

	if hasActiveRune("Weight") then
		return total * 2
	end

	return total
end

local function backpackWeight()
	local total = 0

	local function scan(container)
		if not container then
			return
		end
		for _, child in ipairs(container:GetChildren()) do
			if child:IsA("Tool") and getAttr(child, "Tier") ~= nil then
				local kg = tonumber(getAttr(child, "WeightKg"))
				if kg then
					total += kg
				end
			end
		end
	end

	scan(LocalPlayer:FindFirstChildOfClass("Backpack"))
	scan(LocalPlayer.Character)

	return total
end

local function backpackHalfFull()
	local capacity = backpackCapacity()
	if capacity == math.huge then
		return false
	end
	local used = backpackWeight()
	return used >= (capacity * 0.5)
end

local function backpackFree()
	local capacity = backpackCapacity()
	if capacity == math.huge then
		return math.huge
	end
	return capacity - backpackWeight()
end

local function looksLikeCrystal(inst)
	if not inst:IsA("BasePart") then
		return false
	end
	return inst.Name:find("Crystal", 1, true) ~= nil
end

local crystalFlags = setmetatable({}, { __mode = "k" })

local function isCrystal(inst)
	local cached = crystalFlags[inst]
	if cached ~= nil then
		return cached
	end

	local result = false

	if inst:IsA("BasePart") and getAttr(inst, "Value") ~= nil then
		result = getAttr(inst, "CrystalName") ~= nil or inst.Name:find("Crystal", 1, true) ~= nil
	end

	crystalFlags[inst] = result

	return result
end

local containerList = {}
local containerClock = 0

local function rebuildContainers()
	table.clear(containerList)

	local seen = {}

	local function push(container)
		if not container or seen[container] then
			return
		end
		seen[container] = true
		containerList[#containerList + 1] = container
	end

	push(Workspace)

	for _, name in ipairs(CONTAINER_NAMES) do
		push(Workspace:FindFirstChild(name))
	end

	local things = Workspace:FindFirstChild("Things")
	if things then
		for _, name in ipairs(CONTAINER_NAMES) do
			push(things:FindFirstChild(name))
		end
	end
end

local function eachContainer(fn)
	local now = os.clock()
	local stale = #containerList == 0 or now - containerClock >= 1

	if not stale then
		for _, container in ipairs(containerList) do
			if not container.Parent and container ~= Workspace then
				stale = true
				break
			end
		end
	end

	if stale then
		containerClock = now
		rebuildContainers()
	end

	for _, container in ipairs(containerList) do
		fn(container)
	end
end

local function newLabel(name, parent, order, total, color, rich, maxText)
	local label = Instance.new("TextLabel")
	label.Name = name
	label.BackgroundTransparency = 1
	label.BorderSizePixel = 0
	label.Size = UDim2.new(1, 0, 1 / total, 0)
	label.Position = UDim2.new(0, 0, order / total, 0)
	label.Font = ESP.font
	label.TextScaled = true
	label.TextTransparency = 0
	label.TextStrokeTransparency = 0
	label.TextStrokeColor3 = COLORS.stroke
	label.TextColor3 = color
	label.RichText = rich == true
	label.Text = ""
	label.Parent = parent

	local constraint = Instance.new("UITextSizeConstraint")
	constraint.MaxTextSize = maxText
	constraint.Parent = label

	return label, constraint
end

local function crystalGuiSize()
	return UDim2.fromOffset(ESP.width * espScale, ESP.height * espScale)
end

local function crystalTextSize()
	return math.max(6, math.floor(ESP.text * espScale + 0.5))
end

local function playerGuiSize()
	return UDim2.fromOffset(PLAYER.width * playerScale, PLAYER.height * playerScale)
end

local function playerTextSize()
	return math.max(6, math.floor(PLAYER.text * playerScale + 0.5))
end

local function createEntry(inst)
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "UniverseEsp"
	billboard.Adornee = inst
	billboard.AlwaysOnTop = true
	billboard.ResetOnSpawn = false
	billboard.LightInfluence = 0
	billboard.Size = crystalGuiSize()
	billboard.StudsOffsetWorldSpace = ESP.offset
	billboard.MaxDistance = math.huge
	billboard.Parent = EspHolder

	local textSize = crystalTextSize()
	local rarity, rarityConstraint = newLabel("Rarity", billboard, 0, 3, COLORS.default, false, textSize)
	local info, infoConstraint = newLabel("Info", billboard, 1, 3, COLORS.money, false, textSize)
	local extra, extraConstraint = newLabel("Extra", billboard, 2, 3, COLORS.extra, true, textSize)

	return {
		gui = billboard,
		rarity = rarity,
		info = info,
		extra = extra,
		constraints = { rarityConstraint, infoConstraint, extraConstraint },
		signature = false,
		luckText = "+0%",
		distanceText = false,
	}
end

local function destroyEntry(inst, entry)
	entry = entry or espCache[inst]
	if not entry then
		return
	end

	if entry.gui then
		entry.gui:Destroy()
	end

	espCache[inst] = nil
	espCount -= 1
	statsDirty = true
end

local function applyEspScale()
	local size = crystalGuiSize()
	local textSize = crystalTextSize()

	for _, entry in pairs(espCache) do
		if entry.gui then
			entry.gui.Size = size
		end
		for _, constraint in ipairs(entry.constraints) do
			constraint.MaxTextSize = textSize
		end
	end
end

local function applyPlayerScale()
	local size = playerGuiSize()
	local textSize = playerTextSize()

	for _, entry in pairs(playerCache) do
		if entry.gui then
			entry.gui.Size = size
		end
		for _, constraint in ipairs(entry.constraints) do
			constraint.MaxTextSize = textSize
		end
	end
end

local function applyExtra(entry, distanceText)
	entry.distanceText = distanceText
	entry.extra.Text = string.format(
		'<font color="#%s">%s</font>  \u{2022}  <font color="#%s">%s</font>',
		COLORS.hexDistance,
		distanceText,
		COLORS.hexLuck,
		entry.luckText
	)
end

local function buildTitle(inst)
	local rarity = crystalRarity(inst)
	local name = crystalName(inst)
	local mutation = getAttr(inst, "Mutation")

	if type(mutation) == "string" and mutation ~= "" then
		return string.format("[%s] %s (%s)", rarity, name, mutation)
	end
	return string.format("[%s] %s", rarity, name)
end

local function applyDetails(inst, entry, origin)
	local title = buildTitle(inst)
	local color = crystalColor(inst)
	local money = formatShort(crystalValue(inst), "$")
	local weight = formatWeight(crystalWeight(inst))

	local luckOk, luck = pcall(crystalLuck, inst)
	entry.luckText = formatLuck(luckOk and luck or 0)

	entry.rarity.Text = title
	entry.rarity.TextColor3 = color
	entry.info.Text = string.format("%s  \u{2022}  %s", money, weight)

	local distanceText = "--"
	if origin then
		distanceText = formatDistance((inst.Position - origin).Magnitude)
	end

	applyExtra(entry, distanceText)
end

local function crystalSignature(inst)
	return table.concat({
		tostring(getAttr(inst, "Tier")),
		tostring(getAttr(inst, "TierName")),
		tostring(getAttr(inst, "CrystalName")),
		tostring(getAttr(inst, "Value")),
		tostring(getAttr(inst, "WeightKg")),
		tostring(getAttr(inst, "Mutation")),
		tostring(getAttr(inst, "ExtraMutations")),
		tostring(luckLabelText(inst)),
	}, "|")
end

local function markDirty(inst)
	dirty[inst] = true
end

local function untrackCrystal(inst)
	local conns = registry[inst]
	if not conns then
		return
	end

	for _, connection in ipairs(conns) do
		connection:Disconnect()
	end

	registry[inst] = nil
	registryCount -= 1
	dirty[inst] = nil
	candidates[inst] = nil
	statsDirty = true

	destroyEntry(inst)
end

local function trackCrystal(inst)
	if registry[inst] then
		return
	end

	local conns = {}
	registry[inst] = conns
	registryCount += 1
	statsDirty = true

	local ok = pcall(function()
		conns[#conns + 1] = inst.Destroying:Connect(function()
			untrackCrystal(inst)
		end)

		conns[#conns + 1] = inst.AncestryChanged:Connect(function()
			if not inst:IsDescendantOf(Workspace) then
				untrackCrystal(inst)
			end
		end)

		for _, name in ipairs(WATCHED_ATTRIBUTES) do
			conns[#conns + 1] = inst:GetAttributeChangedSignal(name):Connect(function()
				markDirty(inst)
			end)
		end

		local label = luckLabel(inst)
		if label then
			conns[#conns + 1] = label:GetPropertyChangedSignal("Text"):Connect(function()
				markDirty(inst)
			end)
		end
	end)

	if not ok then
		untrackCrystal(inst)
		return
	end

	markDirty(inst)
end

local function syncCrystal(inst)
	dirty[inst] = nil

	if not registry[inst] then
		return
	end

	if not inst.Parent then
		untrackCrystal(inst)
		return
	end

	local entry = espCache[inst]
	local hidden = not espActive or getAttr(inst, "Collected") == true

	if not hidden then
		hidden = not meetsFilter(inst)
	end

	if hidden then
		if entry then
			destroyEntry(inst, entry)
		end
		return
	end

	if not entry then
		local built, result = pcall(createEntry, inst)
		if not built then
			reportError("billboard", result)
			return
		end

		entry = result
		espCache[inst] = entry
		espCount += 1
		statsDirty = true
	end

	local signature = crystalSignature(inst)
	if signature == entry.signature then
		return
	end

	local root = getRoot()
	local ok, err = pcall(applyDetails, inst, entry, root and root.Position or nil)
	if ok then
		entry.signature = signature
	else
		reportError("details", err)
	end
end

local sweepSeen = {}

local function sweep()
	local seen = sweepSeen
	table.clear(seen)

	eachContainer(function(container)
		for _, child in ipairs(container:GetChildren()) do
			if not seen[child] and isCrystal(child) then
				seen[child] = true
				if not registry[child] then
					trackCrystal(child)
				end
			end
		end
	end)

	local stale
	for inst in pairs(registry) do
		if not seen[inst] then
			stale = stale or {}
			stale[#stale + 1] = inst
		end
	end

	if stale then
		for _, inst in ipairs(stale) do
			untrackCrystal(inst)
		end
	end
end

local lastDistanceOrigin

local function updateDistances()
	local root = getRoot()
	if not root then
		return
	end

	local origin = root.Position

	if lastDistanceOrigin and (origin - lastDistanceOrigin).Magnitude < 1 then
		return
	end

	lastDistanceOrigin = origin

	for inst, entry in pairs(espCache) do
		if inst.Parent then
			local text = formatDistance((inst.Position - origin).Magnitude)
			if text ~= entry.distanceText then
				applyExtra(entry, text)
			end
		end
	end
end

local function clearEsp()
	for inst, entry in pairs(espCache) do
		destroyEntry(inst, entry)
	end
	espCache = {}
	espCount = 0
	statsDirty = true
end

local function clearRegistry()
	local all
	for inst in pairs(registry) do
		all = all or {}
		all[#all + 1] = inst
	end

	if all then
		for _, inst in ipairs(all) do
			untrackCrystal(inst)
		end
	end

	clearEsp()

	registry = {}
	candidates = {}
	dirty = {}
	registryCount = 0
	statsDirty = true
end

local function requestRefresh()
	for inst in pairs(registry) do
		dirty[inst] = true
	end
	sweepAccumulator = math.huge
end

local function trackingEnabled()
	return espActive
end

local function onContainerChild(child)
	if looksLikeCrystal(child) then
		candidates[child] = os.clock() + ESP.ttl
	end
end

local function watchContainers()
	for container, connection in pairs(containerConns) do
		if not container:IsDescendantOf(game) then
			connection:Disconnect()
			containerConns[container] = nil
		end
	end

	eachContainer(function(container)
		if containerConns[container] then
			return
		end
		containerConns[container] = container.ChildAdded:Connect(onContainerChild)
	end)
end

local function unwatchContainers()
	for container, connection in pairs(containerConns) do
		connection:Disconnect()
		containerConns[container] = nil
	end
end

local function updateTracking()
	if trackingEnabled() then
		sweepAccumulator = math.huge
		watchContainers()
		requestRefresh()
	else
		unwatchContainers()
		clearRegistry()
	end
end

local StatsLabel

local espConn = RunService.Heartbeat:Connect(function(deltaTime)
	if statsDirty and StatsLabel then
		statsDirty = false
		StatsLabel:SetDesc(string.format("Tracking: %d  |  Shown: %d", registryCount, espCount))
	end

	if not trackingEnabled() then
		return
	end

	local now = os.clock()

	for inst, expiry in pairs(candidates) do
		if not inst.Parent then
			candidates[inst] = nil
		elseif isCrystal(inst) then
			candidates[inst] = nil
			trackCrystal(inst)
		elseif now > expiry then
			candidates[inst] = nil
		end
	end

	local deadline = now + ESP.budget
	if next(dirty) ~= nil then
		for inst in pairs(dirty) do
			local ok, err = pcall(syncCrystal, inst)
			if not ok then
				dirty[inst] = nil
				reportError("sync", err)
			end
			if os.clock() > deadline then
				break
			end
		end
	end

	sweepAccumulator += deltaTime
	if sweepAccumulator >= ESP.sweep then
		sweepAccumulator = 0
		local ok, err = pcall(function()
			watchContainers()
			sweep()
		end)
		if not ok then
			reportError("sweep", err)
		end
	end

	distanceAccumulator += deltaTime
	if distanceAccumulator >= PACE.distance then
		distanceAccumulator = 0
		local ok, err = pcall(updateDistances)
		if not ok then
			reportError("distance", err)
		end
	end
end)

local function destroyPlayerEntry(player)
	local entry = playerCache[player]
	if not entry then
		return
	end

	if entry.gui then
		entry.gui:Destroy()
	end

	playerCache[player] = nil
end

local function createPlayerEntry(player)
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "UniversePlayerEsp"
	billboard.AlwaysOnTop = true
	billboard.ResetOnSpawn = false
	billboard.LightInfluence = 0
	billboard.Size = playerGuiSize()
	billboard.StudsOffsetWorldSpace = PLAYER.offset
	billboard.MaxDistance = math.huge
	billboard.Parent = EspHolder

	local textSize = playerTextSize()
	local nameLabel, nameConstraint = newLabel("Name", billboard, 0, 2, COLORS.player, false, textSize)
	local distanceLabel, distanceConstraint = newLabel("Distance", billboard, 1, 2, COLORS.extra, false, textSize)

	nameLabel.Text = player.DisplayName

	return {
		gui = billboard,
		name = nameLabel,
		distance = distanceLabel,
		constraints = { nameConstraint, distanceConstraint },
		nameText = player.DisplayName,
		distanceText = false,
	}
end

local function clearPlayerEsp()
	for player in pairs(playerCache) do
		destroyPlayerEntry(player)
	end
	playerCache = {}
end

local function updatePlayerEsp()
	if not playerEspActive then
		return
	end

	local root = getRoot()
	local origin = root and root.Position or nil

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			local character = player.Character
			local target = character and character:FindFirstChild("HumanoidRootPart")

			if target then
				local entry = playerCache[player]
				if not entry then
					local built, result = pcall(createPlayerEntry, player)
					if built then
						entry = result
						playerCache[player] = entry
					else
						reportError("player", result)
					end
				end

				if entry then
					if entry.gui.Adornee ~= target then
						entry.gui.Adornee = target
					end

					if entry.nameText ~= player.DisplayName then
						entry.nameText = player.DisplayName
						entry.name.Text = player.DisplayName
					end

					local text = origin and formatDistance((target.Position - origin).Magnitude) or "--"
					if text ~= entry.distanceText then
						entry.distanceText = text
						entry.distance.Text = text
					end
				end
			else
				destroyPlayerEntry(player)
			end
		end
	end

	local gone
	for player in pairs(playerCache) do
		if player == LocalPlayer or not player.Parent then
			gone = gone or {}
			gone[#gone + 1] = player
		end
	end

	if gone then
		for _, player in ipairs(gone) do
			destroyPlayerEntry(player)
		end
	end
end

local streamMark = 0
local streamSpot

local function requestStream(position)
	if typeof(position) ~= "Vector3" then
		return
	end

	local now = os.clock()

	if streamSpot and now - streamMark < 0.3 and (streamSpot - position).Magnitude < 32 then
		return
	end

	streamMark = now
	streamSpot = position

	task.spawn(function()
		pcall(function()
			LocalPlayer:RequestStreamAroundAsync(position, 1)
		end)
	end)
end

local function applyPivot(cframe)
	local character = LocalPlayer.Character
	if not character then
		return false
	end

	requestStream(cframe.Position)

	local root = getRoot()
	if not root then
		return false
	end

	local moved = pcall(function()
		character:PivotTo(cframe)
	end)

	if not moved then
		moved = pcall(function()
			root.CFrame = cframe
		end)
	end

	if not moved then
		return false
	end

	pcall(function()
		root.AssemblyLinearVelocity = Vector3.zero
		root.AssemblyAngularVelocity = Vector3.zero
	end)

	return true
end

local function findClearGoal(position, ignore)
	local params = OverlapParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = ignore
	params.MaxParts = 1

	for _, offset in ipairs(TP.clear) do
		local candidate = position + offset
		local ok, hits = pcall(function()
			return Workspace:GetPartBoundsInRadius(candidate, 2.5, params)
		end)

		if ok and #hits == 0 then
			return candidate
		end
	end

	return position + TP.clear[#TP.clear]
end

local function finishTeleport()
	if not tpState then
		return
	end

	local root = getRoot()
	if root then
		pcall(function()
			root.AssemblyLinearVelocity = Vector3.zero
			root.AssemblyAngularVelocity = Vector3.zero
		end)
	end

	local character = LocalPlayer.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		pcall(function()
			humanoid.PlatformStand = false
			humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
			humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
			humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
			humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
		end)
	end

	tpState = nil
end

local function teleportTo(target)
	local position
	if typeof(target) == "Vector3" then
		position = target
	elseif typeof(target) == "Instance" and target.Parent then
		position = target.Position
	end

	if not position then
		return false
	end

	local character = LocalPlayer.Character
	if not character then
		return false
	end

	local root = getRoot()
	if not root then
		return false
	end

	finishTeleport()

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		pcall(function()
			if humanoid.SeatPart or humanoid.Sit then
				humanoid.Sit = false
			end
			humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
			humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
		end)
	end

	local ignore = { character }
	if typeof(target) == "Instance" then
		ignore[#ignore + 1] = target
	end

	local goalFrame = CFrame.new(findClearGoal(position + TP.offset, ignore))

	if not applyPivot(goalFrame) then
		return false
	end

	tpState = {
		goal = goalFrame,
		holdUntil = os.clock() + TP.hold,
	}

	return true
end

local pendingActions = {}
local promptRestores = {}
local claimed = {}

local function schedule(delay, fn)
	pendingActions[#pendingActions + 1] = { at = os.clock() + delay, fn = fn }
end

local promptCache = setmetatable({}, { __mode = "k" })

local function crystalPrompt(inst)
	local cached = promptCache[inst]
	if cached and cached.Parent then
		return cached
	end

	local ok, prompt = pcall(inst.FindFirstChildOfClass, inst, "ProximityPrompt")

	if not (ok and prompt) then
		ok, prompt = pcall(inst.FindFirstChildWhichIsA, inst, "ProximityPrompt", true)
	end

	if ok and prompt then
		promptCache[inst] = prompt
		return prompt
	end

	promptCache[inst] = nil

	return nil
end

local function surfaceDistance(part, origin)
	local ok, distance = pcall(function()
		local point = part.CFrame:PointToObjectSpace(origin)
		local half = part.Size * 0.5
		local clamped = Vector3.new(
			math.clamp(point.X, -half.X, half.X),
			math.clamp(point.Y, -half.Y, half.Y),
			math.clamp(point.Z, -half.Z, half.Z)
		)
		return (point - clamped).Magnitude
	end)

	if ok and distance then
		return distance
	end

	return (part.Position - origin).Magnitude
end

local function firePrompt(prompt)
	if not promptRestores[prompt] then
		promptRestores[prompt] = {
			hold = prompt.HoldDuration,
			sight = prompt.RequiresLineOfSight,
			enabled = prompt.Enabled,
			range = prompt.MaxActivationDistance,
		}
	end

	pcall(function()
		prompt.HoldDuration = 0
		prompt.RequiresLineOfSight = false
		prompt.Enabled = true
		prompt.MaxActivationDistance = 1000
	end)

	local fired = false

	if typeof(fireproximityprompt) == "function" then
		fired = pcall(fireproximityprompt, prompt, 1)
		if not fired then
			fired = pcall(fireproximityprompt, prompt)
		end
	end

	if not fired then
		fired = pcall(function()
			prompt:InputHoldBegin()
			prompt:InputHoldEnd()
		end)
	end

	schedule(PICK.restore, function()
		local saved = promptRestores[prompt]
		if not saved then
			return
		end

		promptRestores[prompt] = nil

		if prompt.Parent then
			prompt.HoldDuration = saved.hold
			prompt.RequiresLineOfSight = saved.sight
			prompt.Enabled = saved.enabled
			prompt.MaxActivationDistance = saved.range
		end
	end)

	return fired
end

local pickupParams = OverlapParams.new()
pickupParams.FilterType = Enum.RaycastFilterType.Exclude

pcall(function()
	pickupParams.MaxParts = 300
	pickupParams.RespectCanCollide = false
end)

local pickupFound = {}
local pickupSeen = {}

local function pickupCandidates(free, origin)
	local found = pickupFound
	local seen = pickupSeen
	table.clear(found)
	table.clear(seen)
	local now = os.clock()

	local function consider(child)
		if not child or seen[child] then
			return
		end
		seen[child] = true

		if not child.Parent or not isCrystal(child) or getAttr(child, "Collected") == true then
			return
		end

		local claim = claimed[child]
		if claim and now - claim < PICK.retry then
			return
		end

		local value = crystalValue(child)
		if not meetsFilter(child, value) then
			return
		end

		local weight = crystalWeight(child)
		if weight > free then
			return
		end

		local distance = surfaceDistance(child, origin)
		if distance > PICK.range then
			return
		end

		found[#found + 1] = {
			inst = child,
			prompt = crystalPrompt(child),
			value = value,
			weight = weight,
			distance = distance,
		}
	end

	pickupParams.FilterDescendantsInstances = { LocalPlayer.Character or LocalPlayer }

	local ok, hits = pcall(function()
		return Workspace:GetPartBoundsInRadius(origin, PICK.range + PICK.pad, pickupParams)
	end)

	if ok and hits then
		for _, part in ipairs(hits) do
			consider(part)
		end
	end

	eachContainer(function(container)
		for _, child in ipairs(container:GetChildren()) do
			if child:IsA("BasePart") then
				consider(child)
			elseif child:IsA("Model") then
				for _, inner in ipairs(child:GetChildren()) do
					consider(inner)
				end
			end
		end
	end)

	for inst in pairs(registry) do
		consider(inst)
	end

	table.sort(found, function(a, b)
		if a.value == b.value then
			return a.distance < b.distance
		end
		return a.value > b.value
	end)

	return found
end

local function grabCrystal(inst, prompt)
	local sent = false

	if HoldComplete then
		sent = pcall(function()
			HoldComplete:FireServer(inst)
		end)
	end

	if not prompt then
		prompt = crystalPrompt(inst)
	end

	if prompt and prompt.Parent and firePrompt(prompt) then
		sent = true
	end

	if not sent and typeof(fireclickdetector) == "function" then
		local ok, detector = pcall(inst.FindFirstChildWhichIsA, inst, "ClickDetector", true)
		if ok and detector then
			sent = pcall(fireclickdetector, detector, 0)
		end
	end

	return sent
end

local function instantPromptPatch(prompt)
	if instantPatched[prompt] or promptRestores[prompt] then
		return
	end

	instantPatched[prompt] = {
		hold = prompt.HoldDuration,
		sight = prompt.RequiresLineOfSight,
		enabled = prompt.Enabled,
	}

	pcall(function()
		prompt.HoldDuration = 0
		prompt.RequiresLineOfSight = false
		prompt.Enabled = true
	end)
end

local function restoreInstantPrompts()
	for prompt, saved in pairs(instantPatched) do
		if prompt.Parent then
			pcall(function()
				prompt.HoldDuration = saved.hold
				prompt.RequiresLineOfSight = saved.sight
				prompt.Enabled = saved.enabled
			end)
		end
	end

	table.clear(instantPatched)
end

local function nearbyCrystalParts(origin, radius)
	pickupParams.FilterDescendantsInstances = { LocalPlayer.Character or LocalPlayer }

	local ok, hits = pcall(function()
		return Workspace:GetPartBoundsInRadius(origin, radius, pickupParams)
	end)

	if ok and hits then
		return hits
	end

	return nil
end

local function refreshInstantPrompts()
	local root = getRoot()
	if not root then
		return
	end

	for prompt in pairs(instantPatched) do
		if not prompt.Parent then
			instantPatched[prompt] = nil
		end
	end

	local hits = nearbyCrystalParts(root.Position, PICK.instantRadius)
	if not hits then
		return
	end

	for _, part in ipairs(hits) do
		if isCrystal(part) and getAttr(part, "Collected") ~= true then
			local prompt = crystalPrompt(part)
			if prompt then
				instantPromptPatch(prompt)
			end
		end
	end
end

local function setInstantPrompt(value)
	instantPromptActive = value
	instantAccumulator = math.huge

	if not value then
		restoreInstantPrompts()
	end
end

local function fireRemote(remote, ...)
	if not remote then
		return false
	end

	local args = table.pack(...)
	local ok = pcall(function()
		remote:FireServer(table.unpack(args, 1, args.n))
	end)

	return ok
end

local function unfavoriteAll()
	local cleared = 0

	local function scan(container)
		if not container then
			return
		end

		for _, child in ipairs(container:GetChildren()) do
			if child:IsA("Tool") and child:GetAttribute("Favorited") == true then
				pcall(function()
					child:SetAttribute("Favorited", false)
				end)
				fireRemote(ToggleFavorite, child, false)
				cleared += 1
			end
		end
	end

	scan(LocalPlayer:FindFirstChildOfClass("Backpack"))
	scan(LocalPlayer.Character)

	return cleared
end

local function mountainSpot()
	local centerX = Workspace:GetAttribute("MountainCenterX")
	local centerZ = Workspace:GetAttribute("MountainCenterZ")

	if typeof(centerX) == "number" and typeof(centerZ) == "number" then
		local base = Workspace:GetAttribute("MountainBaseY")
		local peak = Workspace:GetAttribute("MountainPeakY")
		local height = 700

		if typeof(base) == "number" and typeof(peak) == "number" then
			height = base + (peak - base) * 0.55
		end

		return Vector3.new(centerX, height, centerZ)
	end

	local things = Workspace:FindFirstChild("Things")
	local zones = things and things:FindFirstChild("MountainZones")

	if zones then
		for _, child in ipairs(zones:GetChildren()) do
			if child:IsA("BasePart") and child.Name == "MountainZone" then
				return child.Position
			end
		end
	end

	return nil
end

local sellClock = 0

local function doSell()
	local now = os.clock()
	if now - sellClock < 1.5 then
		return false
	end

	sellClock = now

	unfavoriteAll()
	fireRemote(GoHome, "sell")

	schedule(0.6, function()
		unfavoriteAll()
		fireRemote(SellRequest, "all")
	end)

	return true
end

local function pickupStep()
	local now = os.clock()
	if now - lastPickup < PICK.cooldown then
		return
	end

	local root = getRoot()
	if not root then
		return
	end

	local free = backpackFree()
	if free <= 0 or backpackHalfFull() then
		if autoSellActive then
			doSell()
			return
		end
		if free <= 0 and now - lastBagWarn >= 8 then
			lastBagWarn = now
			notify("Mochila llena o al 50% de capacidad", 2, "alert-circle")
		end
		return
	end

	for inst, stamp in pairs(claimed) do
		if now - stamp >= PICK.forget or not inst.Parent then
			claimed[inst] = nil
		end
	end

	local candidates = pickupCandidates(free, root.Position)
	if #candidates == 0 then
		requestStream(root.Position)
		return
	end

	local budget = free
	local grabs = 0

	for _, entry in ipairs(candidates) do
		if grabs >= PICK.burst then
			break
		end

		if entry.weight <= budget then
			claimed[entry.inst] = now

			if grabCrystal(entry.inst, entry.prompt) then
				budget -= entry.weight
				grabs += 1
			end
		end
	end

	if grabs > 0 then
		lastPickup = now
	end
end

local BackpackLabel

local function updateBackpackLabel()
	if not BackpackLabel then
		return
	end

	local capacity = backpackCapacity()
	local used = backpackWeight()

	if capacity == math.huge then
		BackpackLabel:SetDesc(string.format("Mochila: %.1f / ∞ kg", used))
		return
	end

	local free = math.max(0, capacity - used)
	BackpackLabel:SetDesc(string.format("Mochila: %.1f / %.1f kg (Libre: %.1f kg)", used, capacity, free))
end

local function enforceSpeed(humanoid)
	if not humanoid or humanoid.WalkSpeed == PACE.boost then
		return
	end

	pcall(function()
		humanoid.WalkSpeed = PACE.boost
	end)
end

local function watchSpeed(humanoid)
	if speedHooked == humanoid then
		return
	end

	if speedConn then
		speedConn:Disconnect()
		speedConn = nil
	end

	speedHooked = humanoid
	if not humanoid then
		return
	end

	local ok, connection = pcall(function()
		return humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
			if speedActive then
				enforceSpeed(humanoid)
			end
		end)
	end)

	if ok then
		speedConn = connection
	end
end

local function setSpeedBoost(value)
	speedActive = value

	local character = LocalPlayer.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")

	if value then
		watchSpeed(humanoid)
		enforceSpeed(humanoid)
		return
	end

	watchSpeed(nil)

	if humanoid then
		pcall(function()
			humanoid.WalkSpeed = PACE.normal
		end)
	end
end

local autoFarmState = {
	targetCrystal = nil,
	stage = "idle",
	timer = 0,
}

local function autoFarmStep(deltaTime)
	if not autoFarmActive or tpState then
		return
	end

	local root = getRoot()
	if not root then
		return
	end

	local free = backpackFree()
	if free <= 0 or backpackHalfFull() then
		if autoSellActive then
			doSell()
		end
		return
	end

	local now = os.clock()

	if autoFarmState.targetCrystal and (not autoFarmState.targetCrystal.Parent or getAttr(autoFarmState.targetCrystal, "Collected") == true) then
		autoFarmState.targetCrystal = nil
		autoFarmState.stage = "idle"
	end

	if not autoFarmState.targetCrystal then
		local best, bestScore = nil, -math.huge
		eachContainer(function(container)
			for _, child in ipairs(container:GetChildren()) do
				if isCrystal(child) and getAttr(child, "Collected") ~= true then
					local val = crystalValue(child)
					if meetsFilter(child, val) and crystalWeight(child) <= free then
						local dist = (child.Position - root.Position).Magnitude
						local score = val - (dist * 10)
						if score > bestScore then
							bestScore = score
							best = child
						end
					end
				end
			end
		end)

		if best then
			autoFarmState.targetCrystal = best
			autoFarmState.stage = "teleporting"
		else
			return
		end
	end

	local inst = autoFarmState.targetCrystal
	if not inst then
		return
	end

	if autoFarmState.stage == "teleporting" then
		teleportTo(inst.Position)
		autoFarmState.stage = "grabbing"
		autoFarmState.timer = now + 0.3
	elseif autoFarmState.stage == "grabbing" then
		if now >= autoFarmState.timer then
			grabCrystal(inst)
			autoFarmState.stage = "waiting"
			autoFarmState.timer = now + 0.4
		end
	elseif autoFarmState.stage == "waiting" then
		if not inst.Parent or getAttr(inst, "Collected") == true or now >= autoFarmState.timer then
			autoFarmState.targetCrystal = nil
			autoFarmState.stage = "idle"
		end
	end
end

local schedulerConn = RunService.Heartbeat:Connect(function(deltaTime)
	if tpState then
		local ok, err = pcall(function()
			if not applyPivot(tpState.goal) then
				finishTeleport()
				return
			end

			if os.clock() >= tpState.holdUntil then
				finishTeleport()
			end
		end)

		if not ok then
			finishTeleport()
			reportError("teleport", err)
		end
	end

	if autoPickupActive then
		local ok, err = pcall(pickupStep)
		if not ok then
			reportError("pickup", err)
		end
	end

	if autoFarmActive then
		local ok, err = pcall(function()
			autoFarmStep(deltaTime)
		end)
		if not ok then
			reportError("autofarm", err)
		end
	end

	if instantPromptActive then
		instantAccumulator += deltaTime
		if instantAccumulator >= PICK.instantTick then
			instantAccumulator = 0
			local ok, err = pcall(refreshInstantPrompts)
			if not ok then
				reportError("instant", err)
			end
		end
	end

	if speedActive then
		local body = LocalPlayer.Character
		local mover = body and body:FindFirstChildOfClass("Humanoid")
		if mover then
			watchSpeed(mover)
			enforceSpeed(mover)
		end
	end

	if playerEspActive then
		local ok, err = pcall(updatePlayerEsp)
		if not ok then
			reportError("playerEsp", err)
		end
	end

	statsAccumulator += deltaTime
	if statsAccumulator >= PACE.stats then
		statsAccumulator = 0
		local ok, err = pcall(updateBackpackLabel)
		if not ok then
			reportError("backpack", err)
		end
	end

	if #pendingActions == 0 then
		return
	end

	local now = os.clock()
	for index = #pendingActions, 1, -1 do
		local job = pendingActions[index]
		if now >= job.at then
			table.remove(pendingActions, index)
			local ok, err = pcall(job.fn)
			if not ok then
				reportError("action", err)
			end
		end
	end
end)

local function sortedByScore(scoreFn)
	local scored = {}
	local seen = {}

	local function consider(inst)
		if seen[inst] or not inst.Parent then
			return
		end

		if getAttr(inst, "Collected") == true then
			return
		end

		seen[inst] = true

		local ok, score = pcall(scoreFn, inst)
		scored[#scored + 1] = { inst = inst, score = ok and score or 0 }
	end

	for inst in pairs(registry) do
		consider(inst)
	end

	eachContainer(function(container)
		for _, child in ipairs(container:GetChildren()) do
			if isCrystal(child) then
				consider(child)
			end
		end
	end)

	table.sort(scored, function(a, b)
		return a.score > b.score
	end)

	return scored
end

local Mountain = {}
local mountainConn

local aimParams = RaycastParams.new()
aimParams.FilterType = Enum.RaycastFilterType.Exclude
aimParams.IgnoreWater = true

local function getAimedCrystal()
	local unitRay = Mouse.UnitRay
	local origin = unitRay.Origin
	local direction = unitRay.Direction.Unit

	local character = LocalPlayer.Character
	aimParams.FilterDescendantsInstances = character and { character } or {}

	local hit = Workspace:Raycast(origin, direction * PICK.aimRange, aimParams)
	if hit and hit.Instance and (registry[hit.Instance] or isCrystal(hit.Instance)) then
		return hit.Instance
	end

	local best, bestDot
	local seen = {}

	local function consider(inst)
		if seen[inst] or not inst.Parent then
			return
		end

		seen[inst] = true

		local offset = (inst.Position + ESP.offset) - origin
		local magnitude = offset.Magnitude
		if magnitude > 0 then
			local dot = direction:Dot(offset / magnitude)
			if not bestDot or dot > bestDot then
				bestDot = dot
				best = inst
			end
		end
	end

	for inst in pairs(espCache) do
		consider(inst)
	end

	eachContainer(function(container)
		for _, child in ipairs(container:GetChildren()) do
			if isCrystal(child) then
				consider(child)
			end
		end
	end)

	if best and bestDot and bestDot >= PICK.aimDot then
		return best
	end
	return nil
end

local function aimTeleport()
	if not espActive then
		notify("Primero activa Crystal ESP", 3, "alert-circle")
		return
	end

	local inst = getAimedCrystal()
	if not inst then
		notify("Ningún cristal en la mira", 2, "x-circle")
		return
	end

	if teleportTo(inst) then
		notify(string.format("TP -> %s", crystalName(inst)), 2, "map-pin")
	else
		notify("Error al teletransportarse", 2, "x-circle")
	end
end

local function tpToRank(scoreFn, rank, formatter)
	local entry = sortedByScore(scoreFn)[rank]
	if not entry or entry.score <= 0 then
		notify(string.format("Sin cristal para el #%d", rank), 3, "alert-circle")
		return
	end

	if teleportTo(entry.inst) then
		notify(string.format("TP #%d %s (%s)", rank, crystalName(entry.inst), formatter(entry.inst, entry.score)), 3, "map-pin")
	else
		notify("Error al teletransportarse", 3, "x-circle")
	end
end

do
	local function install()
		local BOULDER_INFO = {
			Mossite = {
				rarity = "Common",
				pickaxe = "Titanium Spike",
				crystals = "8-11",
				runes = "Luck / Haste",
				color = Color3.fromRGB(150, 220, 120),
			},
			Voltite = {
				rarity = "Uncommon",
				pickaxe = "Celestial Apex",
				crystals = "10-14",
				runes = "Storm / Weight",
				color = Color3.fromRGB(110, 190, 240),
			},
			Gildrite = {
				rarity = "Rare",
				pickaxe = "Eclipse Fang",
				crystals = "11-15",
				runes = "Fortune / Detonation",
				color = Color3.fromRGB(255, 200, 60),
			},
			Rimeveil = {
				rarity = "Epic",
				pickaxe = "Voidreign",
				crystals = "13-18",
				runes = "Preservation / Warmth",
				color = Color3.fromRGB(170, 100, 255),
			},
			Nocturnite = {
				rarity = "Legendary",
				pickaxe = "The Terminus",
				crystals = "16-22",
				runes = "Excavator / Colossus",
				color = Color3.fromRGB(255, 80, 180),
			},
		}

		local BOULDER_OFFSET = Vector3.new(0, 7, 0)
		local BOULDER_WIDTH = 300
		local BOULDER_HEIGHT = 78
		local BOULDER_STEP = 0.4

		local GRAB_RANGE = 20
		local GRAB_STEP = 0.15
		local GRAB_LIMIT = 4
		local GRAB_RETRY = 0.2

		local boulderEsp = false
		local autoGrab = false

		local boulderCache = {}
		local grabbed = {}

		local boulderClock = 0
		local grabClock = 0

		local scanParams = OverlapParams.new()
		scanParams.FilterType = Enum.RaycastFilterType.Exclude

		local function textSize()
			return math.max(6, math.floor(ESP.text * boulderScale + 0.5))
		end

		local function anchorPart(inst)
			if inst:IsA("BasePart") then
				return inst
			end
			if inst:IsA("Model") then
				return inst.PrimaryPart or inst:FindFirstChildWhichIsA("BasePart")
			end
			return nil
		end

		local function createCard(anchor, offset, colors, width, height)
			local billboard = Instance.new("BillboardGui")
			billboard.Name = "UniverseMountainEsp"
			billboard.Adornee = anchor
			billboard.AlwaysOnTop = true
			billboard.ResetOnSpawn = false
			billboard.LightInfluence = 0
			billboard.Size = UDim2.fromOffset(width * boulderScale, height * boulderScale)
			billboard.StudsOffsetWorldSpace = offset
			billboard.MaxDistance = math.huge
			billboard.Parent = EspHolder

			local total = #colors
			local size = textSize()
			local labels = {}
			local constraints = {}

			for index, color in ipairs(colors) do
				local label, constraint = newLabel("Line" .. index, billboard, index - 1, total, color, false, size)
				labels[index] = label
				constraints[index] = constraint
			end

			return {
				gui = billboard,
				labels = labels,
				constraints = constraints,
				width = width,
				height = height,
				text = {},
			}
		end

		local function scaleCard(entry)
			entry.gui.Size = UDim2.fromOffset(entry.width * boulderScale, entry.height * boulderScale)

			local size = textSize()
			for _, constraint in ipairs(entry.constraints) do
				constraint.MaxTextSize = size
			end
		end

		local function setLine(entry, index, text)
			if entry.text[index] == text then
				return
			end
			entry.text[index] = text
			entry.labels[index].Text = text
		end

		local function dropCard(cache, key)
			local entry = cache[key]
			if not entry then
				return
			end

			if entry.gui then
				entry.gui:Destroy()
			end
			cache[key] = nil
		end

		local function clearCache(cache)
			for key in pairs(cache) do
				dropCard(cache, key)
			end
		end

		local function boulderKind(inst)
			for kind in pairs(BOULDER_INFO) do
				if inst.Name:find(kind, 1, true) then
					return kind
				end
			end
			return nil
		end

		local function boulderRoots()
			local roots = {}

			local decorations = Workspace:FindFirstChild("MountainDecorations")
			local folder = decorations and decorations:FindFirstChild("Boulders")
			if folder then
				roots[#roots + 1] = folder
			end

			local test = Workspace:FindFirstChild("BoulderTest")
			if test then
				roots[#roots + 1] = test
			end

			return roots
		end

		local function eachBoulder(fn)
			for _, container in ipairs(boulderRoots()) do
				for _, child in ipairs(container:GetChildren()) do
					local kind = boulderKind(child)
					if kind then
						fn(child, kind)
					end
				end
			end
		end

		local function isRune(inst)
			if getAttr(inst, "RuneId") ~= nil then
				return true
			end
			if getAttr(inst, "IsRune") == true then
				return true
			end
			if getAttr(inst, "RuneName") ~= nil then
				return true
			end
			return inst.Name:find(" Rune", 1, true) ~= nil
		end

		local function runeTitle(inst)
			local id = getAttr(inst, "RuneId") or getAttr(inst, "RuneName")
			if type(id) == "string" and id ~= "" then
				if id:find("Rune", 1, true) then
					return id
				end
				return id .. " Rune"
			end
			return inst.Name
		end

		local function eachRune(origin, radius, fn)
			local seen = {}

			local function offer(owner, part)
				if not owner or seen[owner] then
					return
				end

				local anchor = part or anchorPart(owner)
				if not anchor or not anchor.Parent then
					return
				end

				if (anchor.Position - origin).Magnitude > radius then
					return
				end

				seen[owner] = true
				fn(owner, anchor)
			end

			local function scanFolder(container)
				if not container then
					return
				end

				for _, child in ipairs(container:GetChildren()) do
					if isRune(child) then
						offer(child, anchorPart(child))
					end
				end
			end

			scanFolder(Workspace)
			scanFolder(Workspace:FindFirstChild("Things"))
			scanFolder(Workspace:FindFirstChild("DroppedCrystals"))

			local character = LocalPlayer.Character
			scanParams.FilterDescendantsInstances = character and { character } or {}

			local ok, parts = pcall(function()
				return Workspace:GetPartBoundsInRadius(origin, radius, scanParams)
			end)

			if not ok or not parts then
				return
			end

			for _, part in ipairs(parts) do
				if isRune(part) then
					offer(part, part)
				else
					local parent = part.Parent
					if parent and parent ~= Workspace and isRune(parent) then
						offer(parent, anchorPart(parent) or part)
					end
				end
			end
		end

		local function syncBoulders()
			local root = getRoot()
			local origin = root and root.Position or nil
			local seen = {}

			eachBoulder(function(model, kind)
				local anchor = anchorPart(model)
				if not anchor then
					return
				end

				seen[model] = true
				local info = BOULDER_INFO[kind]
				local entry = boulderCache[model]

				if entry and not entry.gui.Parent then
					dropCard(boulderCache, model)
					entry = nil
				end

				if not entry then
					entry = createCard(
						anchor,
						BOULDER_OFFSET,
						{ info.color, COLORS.extra, COLORS.money },
						BOULDER_WIDTH,
						BOULDER_HEIGHT
					)
					boulderCache[model] = entry
				end

				if entry.gui.Adornee ~= anchor then
					entry.gui.Adornee = anchor
				end

				scaleCard(entry)
				setLine(entry, 1, string.format("[%s] %s", info.rarity, kind))
				setLine(entry, 2, string.format("%s  \u{2022}  %s crystals", info.pickaxe, info.crystals))

				local distance = origin and formatDistance((anchor.Position - origin).Magnitude) or "--"
				setLine(entry, 3, string.format("%s  \u{2022}  %s", info.runes, distance))
			end)

			local stale
			for model in pairs(boulderCache) do
				if not seen[model] then
					stale = stale or {}
					stale[#stale + 1] = model
				end
			end

			if stale then
				for _, model in ipairs(stale) do
					dropCard(boulderCache, model)
				end
			end
		end

		local function grabRunes(radius)
			local root = getRoot()
			if not root then
				return 0
			end

			local now = os.clock()
			local fired = 0

			for prompt, stamp in pairs(grabbed) do
				if now - stamp > 5 or not prompt.Parent then
					grabbed[prompt] = nil
				end
			end

			eachRune(root.Position, radius or GRAB_RANGE, function(owner, part)
				if fired >= GRAB_LIMIT then
					return
				end

				local prompt = owner:FindFirstChildOfClass("ProximityPrompt")
				if not prompt then
					prompt = crystalPrompt(owner)
				end
				if not prompt and part ~= owner then
					prompt = crystalPrompt(part)
				end

				if not prompt or not prompt.Parent then
					return
				end

				local last = grabbed[prompt]
				if last and now - last < GRAB_RETRY then
					return
				end

				grabbed[prompt] = now

				if firePrompt(prompt) then
					fired += 1
					notify(string.format("Runa obtenida: %s", runeTitle(owner)), 2, "zap")
				end
			end)

			return fired
		end

		function Mountain.applyScale()
			for _, entry in pairs(boulderCache) do
				scaleCard(entry)
			end
		end

		function Mountain.boulderList()
			local list = {}

			for _, kind in ipairs({ "Mossite", "Voltite", "Gildrite", "Rimeveil", "Nocturnite" }) do
				local info = BOULDER_INFO[kind]
				list[#list + 1] = string.format("%s  \u{2022}  %s", kind, info.pickaxe)
			end

			return list
		end

		function Mountain.setBoulderEsp(value)
			boulderEsp = value
			if value then
				boulderClock = math.huge
			else
				clearCache(boulderCache)
			end
		end

		function Mountain.setAutoGrab(value)
			autoGrab = value
			if value then
				grabClock = math.huge
			else
				table.clear(grabbed)
			end
		end

		function Mountain.grabRange()
			return GRAB_RANGE
		end

		function Mountain.grabNear(radius)
			local ok, fired = pcall(grabRunes, radius)

			if not ok then
				reportError("runeGrab", fired)
				return 0
			end

			return fired or 0
		end

		function Mountain.runesNear(radius)
			local root = getRoot()
			if not root then
				return 0
			end

			local count = 0

			eachRune(root.Position, radius or GRAB_RANGE, function()
				count += 1
			end)

			return count
		end

		function Mountain.shutdown()
			boulderEsp = false
			autoGrab = false

			clearCache(boulderCache)
			table.clear(grabbed)
		end

		mountainConn = RunService.Heartbeat:Connect(function(deltaTime)
			if boulderEsp then
				boulderClock += deltaTime
				if boulderClock >= BOULDER_STEP then
					boulderClock = 0
					local ok, err = pcall(syncBoulders)
					if not ok then
						reportError("boulder", err)
					end
				end
			end

			if autoGrab then
				grabClock += deltaTime
				if grabClock >= GRAB_STEP then
					grabClock = 0
					local ok, err = pcall(grabRunes)
					if not ok then
						reportError("runeGrab", err)
					end
				end
			end
		end)
	end

	install()
end

local Move = {}

do
	local function install()
		local FLY_KEYS = {
			{ key = Enum.KeyCode.W, axis = "look", sign = 1 },
			{ key = Enum.KeyCode.S, axis = "look", sign = -1 },
			{ key = Enum.KeyCode.D, axis = "right", sign = 1 },
			{ key = Enum.KeyCode.A, axis = "right", sign = -1 },
			{ key = Enum.KeyCode.Space, axis = "up", sign = 1 },
			{ key = Enum.KeyCode.LeftControl, axis = "up", sign = -1 },
		}

		local flyActive = false
		local noclipActive = false
		local jumpActive = false
		local flySpeed = 100

		local velocity
		local gyro
		local flyConn
		local noclipConn
		local jumpConn
		local collisions = {}

		local function humanoidOf()
			local character = LocalPlayer.Character
			return character and character:FindFirstChildOfClass("Humanoid")
		end

		local function dropMovers()
			if velocity then
				pcall(function()
					velocity:Destroy()
				end)
				velocity = nil
			end

			if gyro then
				pcall(function()
					gyro:Destroy()
				end)
				gyro = nil
			end
		end

		local function attach(root)
			dropMovers()

			local ok = pcall(function()
				local body = Instance.new("BodyVelocity")
				body.Name = "UniverseFlyVelocity"
				body.MaxForce = Vector3.new(9e9, 9e9, 9e9)
				body.P = 9e4
				body.Velocity = Vector3.zero
				body.Parent = root
				velocity = body

				local spin = Instance.new("BodyGyro")
				spin.Name = "UniverseFlyGyro"
				spin.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
				spin.P = 9e4
				spin.D = 500
				spin.CFrame = root.CFrame
				spin.Parent = root
				gyro = spin
			end)

			if not ok then
				dropMovers()
			end

			return ok
		end

		local function flyStep()
			if tpState then
				return
			end

			local root = getRoot()
			if not root then
				return
			end

			if not velocity or velocity.Parent ~= root then
				if not attach(root) then
					return
				end
			end

			local camera = Workspace.CurrentCamera
			if not camera then
				return
			end

			local humanoid = humanoidOf()
			if humanoid and not humanoid.PlatformStand then
				humanoid.PlatformStand = true
			end

			local frame = camera.CFrame
			local direction = Vector3.zero

			if not UserInputService:GetFocusedTextBox() then
				for _, entry in ipairs(FLY_KEYS) do
					if UserInputService:IsKeyDown(entry.key) then
						if entry.axis == "look" then
							direction += frame.LookVector * entry.sign
						elseif entry.axis == "right" then
							direction += frame.RightVector * entry.sign
						else
							direction += Vector3.yAxis * entry.sign
						end
					end
				end
			end

			if direction.Magnitude > 0.1 then
				velocity.Velocity = direction.Unit * flySpeed
			else
				velocity.Velocity = Vector3.zero
			end

			local flat = Vector3.new(frame.LookVector.X, 0, frame.LookVector.Z)
			if flat.Magnitude > 0.05 then
				gyro.CFrame = CFrame.new(root.Position, root.Position + flat)
			end
		end

		local function noclipStep()
			local character = LocalPlayer.Character
			if not character then
				return
			end

			for _, part in ipairs(character:GetDescendants()) do
				if part:IsA("BasePart") and part.CanCollide then
					if collisions[part] == nil then
						collisions[part] = true
					end

					part.CanCollide = false
				end
			end
		end

		function Move.setFly(value)
			flyActive = value

			if value then
				local root = getRoot()
				if root then
					attach(root)
				end

				if not flyConn then
					flyConn = RunService.Heartbeat:Connect(function()
						if not flyActive then
							return
						end

						local ok, err = pcall(flyStep)
						if not ok then
							reportError("fly", err)
						end
					end)
				end

				return
			end

			if flyConn then
				flyConn:Disconnect()
				flyConn = nil
			end

			dropMovers()

			local humanoid = humanoidOf()
			if humanoid then
				pcall(function()
					humanoid.PlatformStand = false
					humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
				end)
			end
		end

		function Move.setFlySpeed(value)
			flySpeed = math.clamp(value, 10, 500)
		end

		function Move.setNoclip(value)
			noclipActive = value

			if value then
				if not noclipConn then
					noclipConn = RunService.Heartbeat:Connect(function()
						if not noclipActive then
							return
						end

						local ok, err = pcall(noclipStep)
						if not ok then
							reportError("noclip", err)
						end
					end)
				end

				return
			end

			if noclipConn then
				noclipConn:Disconnect()
				noclipConn = nil
			end

			for part, state in pairs(collisions) do
				if part.Parent then
					pcall(function()
						part.CanCollide = state
					end)
				end
			end

			table.clear(collisions)
		end

		function Move.setInfJump(value)
			jumpActive = value

			if value then
				if not jumpConn then
					jumpConn = UserInputService.JumpRequest:Connect(function()
						if not jumpActive then
							return
						end

						local humanoid = humanoidOf()
						if humanoid then
							pcall(function()
								humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
							end)
						end
					end)
				end

				return
			end

			if jumpConn then
				jumpConn:Disconnect()
				jumpConn = nil
			end
		end

		function Move.shutdown()
			Move.setFly(false)
			Move.setNoclip(false)
			Move.setInfJump(false)
			Move.glideStop()
		end
	end

	install()
end

do
	local function install()
		local GLIDE_SPEED = 350
		local AIM_RATE = 9
		local SNAP_GAP = 0.35
		local RESPONSE = 200
		local STREAM_GAP = 0.5
		local HOLD_FORCE = 1e7
		local HOLD_TORQUE = 1e7

		local attachment
		local mover
		local aligner
		local cursor
		local facing
		local goalFrame
		local aimSpot
		local streamClock = 0
		local glideConn
		local running = false

		local function humanoidOf()
			local character = LocalPlayer.Character
			return character and character:FindFirstChildOfClass("Humanoid")
		end

		local function detach()
			if mover then
				pcall(function()
					mover:Destroy()
				end)
				mover = nil
			end

			if aligner then
				pcall(function()
					aligner:Destroy()
				end)
				aligner = nil
			end

			if attachment then
				pcall(function()
					attachment:Destroy()
				end)
				attachment = nil
			end
		end

		local function attach(root)
			detach()

			local ok = pcall(function()
				local point = Instance.new("Attachment")
				point.Name = "UniverseGlidePoint"
				point.Parent = root

				local position = Instance.new("AlignPosition")
				position.Name = "UniverseGlidePosition"
				position.Mode = Enum.PositionAlignmentMode.OneAttachment
				position.Attachment0 = point
				position.RigidityEnabled = false
				position.ApplyAtCenterOfMass = true
				position.ReactionForceEnabled = false
				position.MaxForce = HOLD_FORCE
				position.MaxVelocity = math.huge
				position.Responsiveness = RESPONSE
				position.Position = root.Position
				position.Parent = root

				local orientation = Instance.new("AlignOrientation")
				orientation.Name = "UniverseGlideOrientation"
				orientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
				orientation.Attachment0 = point
				orientation.RigidityEnabled = false
				orientation.ReactionTorqueEnabled = false
				orientation.MaxTorque = HOLD_TORQUE
				orientation.MaxAngularVelocity = math.huge
				orientation.Responsiveness = RESPONSE
				orientation.CFrame = root.CFrame.Rotation
				orientation.Parent = root

				attachment = point
				mover = position
				aligner = orientation
			end)

			if not ok then
				detach()
			end

			return ok
		end

		local function step(deltaTime)
			if not goalFrame then
				return
			end

			local root = getRoot()
			if not root then
				return
			end

			if not mover or mover.Parent ~= root or not aligner or aligner.Parent ~= root then
				if not attach(root) then
					return
				end

				cursor = root.Position
				facing = root.CFrame.Rotation
			end

			local humanoid = humanoidOf()
			if humanoid and not humanoid.PlatformStand then
				pcall(function()
					humanoid.PlatformStand = true
				end)
			end

			cursor = cursor or root.Position
			facing = facing or root.CFrame.Rotation

			local delta = goalFrame.Position - cursor
			local span = GLIDE_SPEED * deltaTime

			if delta.Magnitude <= math.max(span, SNAP_GAP) then
				cursor = goalFrame.Position
			else
				cursor += delta.Unit * span
			end

			streamClock += deltaTime
			if streamClock >= STREAM_GAP then
				streamClock = 0
				requestStream(goalFrame.Position)
			end

			local look = goalFrame.Rotation

			if aimSpot then
				local gap = aimSpot - cursor
				if gap.Magnitude > 0.1 then
					look = CFrame.lookAt(cursor, aimSpot).Rotation
				end
			end

			facing = facing:Lerp(look, 1 - math.exp(-AIM_RATE * deltaTime))

			mover.Position = cursor
			aligner.CFrame = facing
		end

		function Move.glide(goal, aim)
			if typeof(goal) ~= "CFrame" then
				return false
			end

			goalFrame = goal
			aimSpot = typeof(aim) == "Vector3" and aim or nil

			if not running then
				running = true

				local root = getRoot()
				if root then
					cursor = root.Position
					facing = root.CFrame.Rotation
					attach(root)
				end
			end

			if not glideConn then
				glideConn = RunService.Heartbeat:Connect(function(deltaTime)
					if not running then
						return
					end

					local ok, err = pcall(step, deltaTime)
					if not ok then
						reportError("glide", err)
					end
				end)
			end

			return true
		end

		function Move.glideStop()
			running = false
			goalFrame = nil
			aimSpot = nil
			cursor = nil
			facing = nil
			streamClock = 0

			if glideConn then
				glideConn:Disconnect()
				glideConn = nil
			end

			detach()

			local root = getRoot()
			if root then
				pcall(function()
					root.AssemblyLinearVelocity = Vector3.zero
					root.AssemblyAngularVelocity = Vector3.zero
				end)
			end

			local humanoid = humanoidOf()
			if humanoid then
				pcall(function()
					humanoid.PlatformStand = false
					humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
				end)
			end
		end
	end

	install()
end

-- ==================== CONSTRUCCIÓN DE INTERFAZ EN WINDUI ====================

-- TAB 1: CRYSTALS
Tabs.Crystals:Section({ Title = "Opciones de ESP para Cristales" })

Tabs.Crystals:Toggle({
	Title = "Activar ESP de Cristales",
	Value = false,
	Callback = function(value)
		espActive = value
		if not value then
			clearEsp()
		end
		updateTracking()
	end,
})

Tabs.Crystals:Slider({
	Title = "Tamaño del ESP",
	Step = 1,
	Value = { Min = 40, Max = 250, Default = 70 },
	Callback = function(value)
		espScale = value / 100
		applyEspScale()
	end,
})

local function setMinValue(text)
	local parsed = parseValue(text)
	if not parsed then
		return
	end

	minValue = math.max(parsed, 0)
	valueFilter = minValue > 0
	requestRefresh()
end

Tabs.Crystals:Input({
	Title = "Filtro de Valor Mínimo",
	Value = "2m",
	Placeholder = "Ej: 500k, 2m, 1.5b",
	Callback = setMinValue,
})

StatsLabel = Tabs.Crystals:Paragraph({
	Title = "Estado del Rastreador",
	Desc = "Tracking: 0  |  Shown: 0",
})

-- TAB 2: PLAYERS
Tabs.Players:Section({ Title = "Opciones de ESP para Jugadores" })

Tabs.Players:Toggle({
	Title = "Activar ESP de Jugadores",
	Value = false,
	Callback = function(value)
		playerEspActive = value
		if not value then
			clearPlayerEsp()
		end
	end,
})

Tabs.Players:Slider({
	Title = "Tamaño del ESP de Jugadores",
	Step = 1,
	Value = { Min = 40, Max = 250, Default = 60 },
	Callback = function(value)
		playerScale = value / 100
		applyPlayerScale()
	end,
})

-- TAB 3: BOULDERS
Tabs.Boulders:Section({ Title = "Montaña y Piedras (Boulders)" })

Tabs.Boulders:Toggle({
	Title = "Activar ESP de Boulders",
	Value = false,
	Callback = function(value)
		Mountain.setBoulderEsp(value)
	end,
})

Tabs.Boulders:Slider({
	Title = "Tamaño del ESP de Boulders",
	Step = 1,
	Value = { Min = 40, Max = 250, Default = 60 },
	Callback = function(value)
		boulderScale = value / 100
		Mountain.applyScale()
	end,
})

Tabs.Boulders:Toggle({
	Title = "Auto Agarrar Runas Cercanas",
	Value = false,
	Callback = function(value)
		Mountain.setAutoGrab(value)
	end,
})

Tabs.Boulders:Button({
	Title = "Agarrar Runas Cercanas Ahora",
	Callback = function()
		local count = Mountain.grabNear(30)
		notify("Runas recolectadas: " .. tostring(count), 3, "zap")
	end,
})

-- TAB 4: TELEPORTS
Tabs.Teleports:Section({ Title = "Acciones de Teletransporte" })

Tabs.Teleports:Button({
	Title = "TP al Cristal en Mira",
	Desc = "Teletransporta al cristal donde esté apuntando el mouse",
	Callback = function()
		aimTeleport()
	end,
})

Tabs.Teleports:Button({
	Title = "TP al Mejor Cristal (#1 Valor)",
	Callback = function()
		tpToRank(crystalValue, 1, function(inst, score)
			return formatShort(score, "$")
		end)
	end,
})

Tabs.Teleports:Button({
	Title = "TP al Cristal #2 en Valor",
	Callback = function()
		tpToRank(crystalValue, 2, function(inst, score)
			return formatShort(score, "$")
		end)
	end,
})

Tabs.Teleports:Button({
	Title = "TP al Cristal #3 en Valor",
	Callback = function()
		tpToRank(crystalValue, 3, function(inst, score)
			return formatShort(score, "$")
		end)
	end,
})

Tabs.Teleports:Button({
	Title = "TP al Cristal con Mayor Suerte",
	Callback = function()
		tpToRank(crystalLuck, 1, function(inst, score)
			return formatLuck(score)
		end)
	end,
})

Tabs.Teleports:Button({
	Title = "TP a la Zona de Montaña",
	Callback = function()
		local spot = mountainSpot()
		if spot then
			teleportTo(spot)
			notify("Teletransportado a la montaña", 3, "map-pin")
		else
			notify("No se encontró la zona de montaña", 3, "alert-circle")
		end
	end,
})

-- TAB 5: FARMING
Tabs.Farming:Section({ Title = "Configuración de Autorecolección" })

Tabs.Farming:Toggle({
	Title = "Auto Recoger Cristales (Auto Pickup)",
	Value = false,
	Callback = function(value)
		autoPickupActive = value
	end,
})

Tabs.Farming:Toggle({
	Title = "Interacción Instantánea (Instant Prompts)",
	Value = false,
	Callback = function(value)
		setInstantPrompt(value)
	end,
})

Tabs.Farming:Toggle({
	Title = "Auto Farm Automático (TP + Recoger)",
	Value = false,
	Callback = function(value)
		autoFarmActive = value
	end,
})

Tabs.Farming:Toggle({
	Title = "Auto Vender (al 50% / Mochila Llena)",
	Value = false,
	Callback = function(value)
		autoSellActive = value
	end,
})

Tabs.Farming:Section({ Title = "Acciones Manuales" })

Tabs.Farming:Button({
	Title = "Vender Todo Ahora",
	Callback = function()
		doSell()
		notify("Venta ejecutada", 3, "dollar-sign")
	end,
})

Tabs.Farming:Button({
	Title = "Desfavoritar Todos los Items",
	Callback = function()
		local count = unfavoriteAll()
		notify("Items desfavoritados: " .. tostring(count), 3, "star")
	end,
})

BackpackLabel = Tabs.Farming:Paragraph({
	Title = "Estado de Mochila",
	Desc = "Mochila: 0 / 10 kg",
})

-- TAB 6: MOVEMENT
Tabs.Movement:Section({ Title = "Ajustes de Movimiento" })

Tabs.Movement:Toggle({
	Title = "Aumento de Velocidad (Speed Boost)",
	Value = false,
	Callback = function(value)
		setSpeedBoost(value)
	end,
})

Tabs.Movement:Toggle({
	Title = "Volar (Fly)",
	Value = false,
	Callback = function(value)
		Move.setFly(value)
	end,
})

Tabs.Movement:Slider({
	Title = "Velocidad de Vuelo",
	Step = 5,
	Value = { Min = 20, Max = 300, Default = 100 },
	Callback = function(value)
		Move.setFlySpeed(value)
	end,
})

Tabs.Movement:Toggle({
	Title = "Atravesar Paredes (Noclip)",
	Value = false,
	Callback = function(value)
		Move.setNoclip(value)
	end,
})

Tabs.Movement:Toggle({
	Title = "Salto Infinito",
	Value = false,
	Callback = function(value)
		Move.setInfJump(value)
	end,
})

-- TAB 7: SETTINGS
Tabs.Settings:Section({ Title = "Control del Script" })

Tabs.Settings:Button({
	Title = "Descargar / Cerrar Script",
	Callback = function()
		afkRunning = false
		for _, conn in ipairs(afkConns) do
			pcall(function() conn:Disconnect() end)
		end
		if espConn then espConn:Disconnect() end
		if schedulerConn then schedulerConn:Disconnect() end
		if characterConn then characterConn:Disconnect() end
		if mountainConn then mountainConn:Disconnect() end

		clearRegistry()
		clearPlayerEsp()
		Mountain.shutdown()
		Move.shutdown()
		setSpeedBoost(false)
		setInstantPrompt(false)

		pcall(function() EspHolder:Destroy() end)
		pcall(function() Window:Destroy() end)

		notify("Script descargado correctamente", 3, "check")
	end,
})

Tabs.Settings:Paragraph({
	Title = "Universe Script - Mine a Mountain",
	Desc = "Script completamente funcional y optimizado con WindUI.",
})
