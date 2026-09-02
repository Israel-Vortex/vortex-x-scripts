local iData = {}
local unpackValues = unpack or table.unpack
iData.value1 = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

-- ===== VORTEX WINDUI BOOT =====
local WindUI = iData.value1
local LocalPlayer = game:GetService("Players").LocalPlayer

pcall(function()
    WindUI:Notify({ Title = "Vortex x Software", Content = "Iniciando sesion... Por favor espera.", Duration = 3 })
end)
task.wait(3)
pcall(function()
    WindUI:Notify({ Title = "Vortex x Software", Content = "Acceso Concedido, " .. LocalPlayer.Name .. "! Cargando interfaz...", Duration = 2 })
end)
task.wait(2)

pcall(function()
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
end)
-- ===== END VORTEX BOOT =====


iData.value2 = game:GetService("Players")
iData.value3 = game:GetService("RunService")
iData.value4 = game:GetService("TweenService")
iData.value5 = game:GetService("TeleportService")
iData.value6 = game:GetService("ReplicatedStorage")
iData.value7 = game:GetService("Workspace")
iData.value8 = game:GetService("HttpService")

local UserInputService = game:GetService("UserInputService")

iData.value9 = iData.value2.LocalPlayer
iData.value10 = {}
iData.value11 = {}
iData.value12 = {}
iData.value13 = {}
iData.value10.Rarities = {
	"Common",
	"Uncommon",
	"Rare",
	"Epic",
	"Legendary",
	"Mythic",
	"Cosmic",
	"Secret",
	"Divine",
	"Eternal",
}
iData.value14 = {
	AutoSteal = false,
	FarmMethod = "Speed",
	AntiTrap = true,
	AreaFocus = {},
	RarityFilter = {},
	SecretPriority = true,
	AutoHop = false,
	MaxHops = 15,
	HopDelay = 20,
	HopCount = 0,
	AutoHatch = false,
	HatchOnce = false,
	EggESP = false,
	FpsBoost = false,
	AutoEquipBest = false,
	AutoClaim = false,
	ClaimInterval = 20,
	AutoUpgrade = false,
	UpgradeInterval = 30,
	AutoTreadmill = false,
	AutoUpgradeTreadmill = false,
	AntiCheat = false,
	HumReady = false,
	Unloaded = false,
}
iData.value15 = {}
iData.value16 = {}
function iData.value17()
	return not iData.value14.Unloaded
end
function iData.value18(title, content, durationFlag)
	local capturedContent = content
	local capturedDurationFlag = durationFlag
	pcall(function()
		local notifyResult = iData.value1
		local secondaryTitle = title
		local content = capturedContent
		local Notify = notifyResult.Notify
		local duration = capturedDurationFlag or 4

		Notify(notifyResult, {
			Title = secondaryTitle,
			Content = content,
			Duration = duration,
		})
	end)
end
iData.value11.hostGui = type(gethui) == "function" and gethui() or game:GetService("CoreGui")
iData.value11.warnLayer = nil
local function handler(argument)
	local thread = task.spawn(function()
		xpcall(argument, function(err)
			warn("[Shard] " .. tostring(err) .. "\n" .. debug.traceback())
		end)
	end)

	iData.value15[#iData.value15 + 1] = thread

	return thread
end
iData.value19 = nil
function iData.value19()
	if iData.value11.warnLayer and iData.value11.warnLayer.Parent then
		return iData.value11.warnLayer
	end

	return pcall(function()
		local ScreenGui = Instance.new("ScreenGui")

		ScreenGui.Name = "ShardWarn"
		ScreenGui.ResetOnSpawn = false
		ScreenGui.IgnoreGuiInset = true
		ScreenGui.DisplayOrder = 9999
		ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		ScreenGui.Parent = iData.value11.hostGui
		iData.value11.warnLayer = ScreenGui
	end) and iData.value11.warnLayer or nil
end
function iData.value20(text, optionFlag)
	local parent = iData.value19()

	if not parent then
		return
	end

	local option = optionFlag or 4

	pcall(function()
		local Frame = Instance.new("Frame")

		Frame.AnchorPoint = Vector2.new(1, 1)
		Frame.Position = UDim2.new(1, 20, 1, -22)
		Frame.Size = UDim2.fromOffset(232, 54)
		Frame.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
		Frame.BorderSizePixel = 0
		Frame.Parent = parent

		local UICorner = Instance.new("UICorner")

		UICorner.CornerRadius = UDim.new(0, 10)
		UICorner.Parent = Frame

		local UIStroke = Instance.new("UIStroke")

		UIStroke.Thickness = 1
		UIStroke.Color = Color3.fromRGB(238, 168, 62)
		UIStroke.Transparency = 0.35
		UIStroke.Parent = Frame

		local frame = Instance.new("Frame")

		frame.Size = UDim2.new(0, 3, 1, -16)
		frame.Position = UDim2.new(0, 8, 0, 8)
		frame.BackgroundColor3 = Color3.fromRGB(238, 168, 62)
		frame.BorderSizePixel = 0
		frame.Parent = Frame

		local uiCorner = Instance.new("UICorner")

		uiCorner.CornerRadius = UDim.new(1, 0)
		uiCorner.Parent = frame

		local TextLabel = Instance.new("TextLabel")

		TextLabel.BackgroundTransparency = 1
		TextLabel.Position = UDim2.new(0, 20, 0, 9)
		TextLabel.Size = UDim2.new(1, -30, 0, 16)
		TextLabel.Font = Enum.Font.GothamBold
		TextLabel.TextSize = 12
		TextLabel.TextColor3 = Color3.fromRGB(238, 168, 62)
		TextLabel.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel.Text = "Warning"
		TextLabel.Parent = Frame

		local textLabel = Instance.new("TextLabel")

		textLabel.BackgroundTransparency = 1
		textLabel.Position = UDim2.new(0, 20, 0, 27)
		textLabel.Size = UDim2.new(1, -30, 0, 18)
		textLabel.Font = Enum.Font.Gotham
		textLabel.TextSize = 12
		textLabel.TextColor3 = Color3.fromRGB(206, 206, 212)
		textLabel.TextXAlignment = Enum.TextXAlignment.Left
		textLabel.TextTruncate = Enum.TextTruncate.AtEnd
		textLabel.Text = text
		textLabel.Parent = Frame
		iData.value4
			:Create(Frame, TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				Position = UDim2.new(1, -18, 1, -22),
			})
			:Play()
		task.delay(option, function()
			local create =
				iData.value4:Create(Frame, TweenInfo.new(0.24, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
					Position = UDim2.new(1, 260, 1, -22),
				})

			create:Play()
			create.Completed:Wait()
			Frame:Destroy()
		end)
	end)
end
local function secondaryHandler(argument)
	iData.value16[#iData.value16 + 1] = argument

	return argument
end
function iData.value21()
	local Character = iData.value9.Character

	return Character and Character:FindFirstChild("HumanoidRootPart") or nil
end
function iData.value22()
	local Character = iData.value9.Character

	return Character and Character:FindFirstChildWhichIsA("Humanoid") or nil
end
function iData.value23()
	local value22Result = iData.value22()

	return iData.value21() ~= nil and (value22Result ~= nil and value22Result.Health > 0)
end
iData.value10.HUM_COPY = {
	"RigType",
	"HipHeight",
	"JumpPower",
	"JumpHeight",
	"UseJumpPower",
	"AutoRotate",
	"MaxSlopeAngle",
	"DisplayDistanceType",
	"NameDisplayDistance",
	"HealthDisplayDistance",
	"AutomaticScalingEnabled",
	"BreakJointsOnDeath",
	"RequiresNeck",
	"EvaluateStateMachine",
}
local function createAutoStealHumanoid()
	local Character = iData.value9.Character
	local walkSpeedData = Character and Character:FindFirstChildWhichIsA("Humanoid")
	if not Character or not walkSpeedData then
		return false
	end
	local data = {}
	for _, item in ipairs(iData.value10.HUM_COPY) do
		local capturedV = item
		local ok, result = pcall(function()
			return walkSpeedData[capturedV]
		end)

		if ok then
			data[capturedV] = result
		end
	end
	local WalkSpeed = walkSpeedData.WalkSpeed
	pcall(function()
		walkSpeedData:Destroy()
	end)
	iData.value3.Heartbeat:Wait()
	local Humanoid = Instance.new("Humanoid")
	for key, item in pairs(data) do
		local capturedKey = key
		local capturedItem = item

		pcall(function()
			Humanoid[capturedKey] = capturedItem
		end)
	end
	Humanoid.Parent = Character
	iData.value3.Heartbeat:Wait()
	if Character ~= Humanoid.Parent then
		return false
	end
	Humanoid.WalkSpeed = WalkSpeed
	pcall(function()
		Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
	end)
	local CurrentCamera = iData.value7.CurrentCamera
	if CurrentCamera then
		pcall(function()
			CurrentCamera.CameraSubject = Humanoid
		end)
	end
	iData.value14.HumReady = true

	return true
end
iData.value24 = iData.value6:FindFirstChild("Packages")
iData.value24 = iData.value24 and iData.value24:FindFirstChild("Networking") or nil
iData.value25 = {
	EggSnapshot = "RF/EggWorld/AskFieldEggSnapshot",
	EggCarry = "RF/EggWorld/AskFieldEggCarry",
	EggPlace = "RF/EggWorld/AskPlaceEgg",
	EggDrop = "RF/EggWorld/AskFieldEggDrop",
	EggLive = "RF/EggWorld/AskLiveSnapshot",
	EggRarityShow = "RF/EggWorld/AskFieldEggRarityShows",
	Hatch = "RF/EggWorld/AskHatch",
	HatchFinish = "RF/EggWorld/AskFinishHatch",
	SkipGrowth = "RF/EggWorld/AskSkipGrowth",
	PlotState = "RF/Homestead/AskState",
	BaseTierRaise = "RE/Homestead/AskBaseTierRaise",
	NearbyBuy = "RE/Homestead/AskNearbyPurchase",
	Collect = "RF/AwayEarnings/AskCollect",
	PendingCheck = "RF/AwayEarnings/PendingCheck",
	CodexAll = "RF/Codex/AskRedeemAll",
	WearBest = "RF/Haul/WearBest",
	SatchelSale = "RF/Haul/OfferFullSatchelSale",
	SellEveryPet = "RE/PetSatchel/SellEveryPet",
	SellPet = "RE/PetSatchel/SellPet",
	PetSnapshot = "RF/PenRoster/AskLiveSnapshot",
	PetSale = "RF/PenRoster/AskSale",
	PetWear = "RF/PenRoster/AskWear",
	PetDoff = "RF/PenRoster/AskDoff",
	TreadRaise = "RF/Treadmill/AskTierRaise",
	TreadRender = "RF/Treadmill/AskRenderSnapshot",
	WearTool = "RF/EggWorld/AskWearTool",
	DoffTool = "RF/EggWorld/AskDoffTool",
	RigWipe = "RE/RigSync/AskRigWipe",
}
iData.value26 = nil
function iData.value26(argument)
	local firstChild = iData.value24

	if firstChild then
		firstChild = iData.value24:FindFirstChild(argument)
	end

	return firstChild or nil
end
function iData.value27(argument, ...)
	local okFlag = iData.value26(argument)

	if not okFlag then
		return nil
	end

	if okFlag:IsA("RemoteFunction") then
		local ok, result = pcall(okFlag.InvokeServer, okFlag, ...)

		return ok and result or nil
	end

	return pcall(okFlag.FireServer, okFlag, ...) or nil
end
function iData.value28()
	local childNames = {}

	if iData.value24 then
		for _, child in ipairs(iData.value24:GetChildren()) do
			if child:IsA("RemoteFunction") or child:IsA("RemoteEvent") then
				childNames[#childNames + 1] = child.Name
			end
		end
	end

	table.sort(childNames)

	return childNames
end
local value29Option = fireproximityprompt or syn and syn.fireproximityprompt
iData.value29 = nil
iData.value29 = value29Option
function iData.value30(holdDurationFlag)
	if not iData.value29 or (not holdDurationFlag or not holdDurationFlag.Enabled) then
		return false
	end

	pcall(function()
		holdDurationFlag.HoldDuration = 0
	end)

	return pcall(iData.value29, holdDurationFlag)
end
function iData.value31(instance)
	local secondaryInput = iData.value21()
	local alternateInput = instance and instance.Parent
	if not secondaryInput or not alternateInput then
		return false
	end
	local Position
	if alternateInput:IsA("BasePart") then
		Position = alternateInput.Position
	elseif alternateInput:IsA("Model") then
		local ok, result = pcall(function()
			return alternateInput:GetPivot()
		end)

		Position = ok and result.Position or nil
	elseif alternateInput:IsA("Attachment") then
		Position = alternateInput.WorldPosition
	end
	if not Position then
		return false
	end
	local number = instance.MaxActivationDistance > 0 and instance.MaxActivationDistance or 12

	return (secondaryInput.Position - Position).Magnitude <= number + 4
end
function iData.value32(getDescendantsFlag, secondaryData)
	local data = {}

	if not getDescendantsFlag then
		return data
	end

	local GetDescendants = getDescendantsFlag.GetDescendants

	for _, item in ipairs(GetDescendants(getDescendantsFlag)) do
		if item:IsA("ProximityPrompt") and item.Enabled then
			local lower = (item.Name .. " " .. item.ActionText .. " " .. item.ObjectText):lower()

			if item.Parent then
				lower ..= " " .. item.Parent.Name:lower()
			end

			for _, searchableText in ipairs(secondaryData) do
				if lower:find(searchableText, 1, true) then
					data[#data + 1] = item

					break
				end
			end
		end
	end

	return data
end
iData.value11.uidShape = {}
function iData.value33(argument, uid)
	local secondaryResult = iData.value11.uidShape[argument]

	if secondaryResult ~= 2 then
		local value27Result = iData.value27(argument, {
			Uid = uid,
		})

		if value27Result ~= nil and value27Result ~= false then
			iData.value11.uidShape[argument] = 1

			return true
		end

		if secondaryResult == 1 then
			return false
		end
	end

	local value27Result = iData.value27(argument, uid)

	if value27Result ~= nil and value27Result ~= false then
		iData.value11.uidShape[argument] = 2

		return true
	end

	return false
end
iData.value10.rarityLadder = {}
for i, item in ipairs(iData.value10.Rarities) do
	iData.value10.rarityLadder[item] = i
end
function iData.value34(argument)
	if type(argument) ~= "string" then
		return 0
	end

	return iData.value10.rarityLadder[argument] or 0
end
iData.value13.areaLabel = {}
iData.value13.areaRarity = {}
iData.value13.areaTierName = {}
iData.value13.areaByLabel = {}
iData.value13.areaOrder = {}
function iData.value35(areaOrder, optionFlag, flag, quaternaryArgument)
	if not areaOrder or iData.value13.areaLabel[areaOrder] then
		return
	end

	local option = optionFlag or areaOrder

	iData.value13.areaLabel[areaOrder] = option
	iData.value13.areaRarity[areaOrder] = flag or 0
	iData.value13.areaTierName[areaOrder] = quaternaryArgument
	iData.value13.areaByLabel[option] = areaOrder
	iData.value13.areaOrder[#iData.value13.areaOrder + 1] = areaOrder
end
function iData.value36()
	table.sort(iData.value13.areaOrder, function(argument, secondaryArgument)
		local optionFlag = iData.value13.areaRarity[argument]
		local areaRarityResult = iData.value13
		local option = optionFlag or 0
		local secondaryOption = areaRarityResult.areaRarity[secondaryArgument] or 0

		if option == secondaryOption then
			return tostring(iData.value13.areaLabel[argument]) < tostring(iData.value13.areaLabel[secondaryArgument])
		end

		return option < secondaryOption
	end)
end
function iData.value37()
	local data = {}

	for _, item in ipairs(iData.value13.areaOrder) do
		data[#data + 1] = iData.value13.areaLabel[item]
	end

	return data
end
local Data = iData.value6:FindFirstChild("Data")

iData.value38 = Data and Data:FindFirstChild("Areas")

local ok, result = pcall(function()
	return iData.value38 and require(iData.value38)
end)
local data = ok and (type(result) == "table" and (result.Directory or result)) or nil
if type(data) == "table" then
	for k, item in pairs(data) do
		local secondaryK = k

		if type(secondaryK) == "string" and type(item) == "table" then
			local number = 0
			local option
			if type(item.Rarity) == "table" then
				number = tonumber(item.Rarity.RarityNumber) or 0
				option = item.Rarity.DisplayName or item.Rarity._id
			end
			iData.value35(secondaryK, item.DisplayName or (item.Name or secondaryK), number, option)
		end
	end
end
if #iData.value13.areaOrder == 0 then
	local getChildrenCondition = iData.value7:FindFirstChild("Areas") or iData.value7:FindFirstChild("Islands")

	if getChildrenCondition then
		local number = 0
		local GetChildren = getChildrenCondition.GetChildren

		for _, item in ipairs(GetChildren(getChildrenCondition)) do
			number += 1
			iData.value35(item.Name, item.Name, number, nil)
		end
	end
end
iData.value36()
function iData.value39(data)
	local vData = {}
	local number = 0

	if type(data) == "table" then
		for _, item in ipairs(data) do
			if type(item) == "string" and item ~= "" then
				vData[item] = true
				number += 1
			end
		end
	end

	return vData, number
end
local areaWantedResult = iData.value13
local areaWantedCountResult = iData.value13
areaWantedResult.areaWanted = {}
areaWantedCountResult.areaWantedCount = 0
local rarityWantedResult = iData.value13
local rarityWantedCountResult = iData.value13
rarityWantedResult.rarityWanted = {}
rarityWantedCountResult.rarityWantedCount = 0
function iData.value40()
	local data = iData.value39(iData.value14.AreaFocus)
	local areaWanted = {}
	local areaWantedCount = 0

	for k in pairs(data) do
		local secondaryK = k

		areaWanted[iData.value13.areaByLabel[secondaryK] or secondaryK] = true
		areaWantedCount += 1
	end

	local areaWantedResult = iData.value13
	local areaWantedCountResult = iData.value13

	areaWantedResult.areaWanted = areaWanted
	areaWantedCountResult.areaWantedCount = areaWantedCount
end
iData.value41 = nil
function iData.value42()
	local rarityWantedResult = iData.value13
	local rarityWantedCountResult = iData.value13
	local rarityWanted, rarityWantedCount = iData.value39(iData.value14.RarityFilter)

	rarityWantedResult.rarityWanted = rarityWanted
	rarityWantedCountResult.rarityWantedCount = rarityWantedCount
end
iData.value41 = {}
function iData.value43(argument, secondaryArgument)
	local flag = iData.value41[argument]

	if not flag then
		return
	end

	if pcall(function()
		flag:SetValue(secondaryArgument)
	end) then
		return
	end

	pcall(function()
		flag:Set(secondaryArgument)
	end)
end
function iData.value44(argument, secondaryArgument)
	local flag = iData.value41[argument]

	if not flag then
		return
	end

	if pcall(function()
		flag:Refresh(secondaryArgument)
	end) then
		return
	end

	pcall(function()
		flag:SetValues(secondaryArgument)
	end)
end
iData.value11.slotsCache = nil
iData.value45 = nil
function iData.value45()
	if iData.value11.slotsCache and iData.value11.slotsCache.Parent then
		return iData.value11.slotsCache
	end

	iData.value11.slotsCache = iData.value7:FindFirstChild("AreaEggSlotsClient")

	return iData.value11.slotsCache
end
iData.value46 = nil
function iData.value46(argument)
	local firstChild = iData.value45()

	if firstChild then
		firstChild = firstChild:FindFirstChild(argument)
	end

	return firstChild or nil
end
function iData.value47(argument)
	local hitboxContainer = iData.value46(argument)

	if not hitboxContainer then
		return nil
	end

	return hitboxContainer.PrimaryPart
		or (hitboxContainer:FindFirstChild("Hitbox") or hitboxContainer:FindFirstChildWhichIsA("BasePart"))
end
function iData.value48(mutationsArgument)
	if mutationsArgument.BaseMutation then
		return true
	end

	return type(mutationsArgument.Mutations) == "table" and next(mutationsArgument.Mutations) ~= nil
end
iData.value11.eggList = {}
iData.value11.eggListAt = 0
iData.value11.triedUids = {}
iData.value11.failUids = {}
iData.value11.areaDirty = false
function iData.value49(secondaryFlag)
	if not secondaryFlag and tick() - iData.value11.eggListAt < 1.5 then
		return iData.value11.eggList
	end
	local dataFlag = iData.value27(iData.value25.EggSnapshot)
	local iteratorData = dataFlag and dataFlag.Records
	if type(iteratorData) ~= "table" then
		return iData.value11.eggList
	end
	local eggList = {}
	local iterator, state, control = pairs(iteratorData)
	local flag
	while true do
		local uidResult

		control, uidResult = iterator(state, control)

		if not control then
			break
		end

		if not (uidResult.State == "Slot" and uidResult.Uid) then
			continue
		end

		local condition = iData.value47(uidResult.Uid)
		local Position

		if condition then
			Position = condition.Position
		else
			local secondaryInput = uidResult.BoundsCFrame or uidResult.BottomCFrame

			Position = secondaryInput and secondaryInput.Position or nil
		end

		if not Position then
			continue
		end

		local AreaId = uidResult.AreaId

		if AreaId and not iData.value13.areaLabel[AreaId] then
			local callback = iData.value35
			local sum = #iData.value13.areaOrder + 1
			local option = uidResult.Rarity or (uidResult.RarityName or (uidResult.Tier or uidResult.RarityId))

			if type(option) == "table" then
				option = option.DisplayName or (option._id or (option.Name or option.Id))
			end

			callback(AreaId, AreaId, sum, type(option) == "string" and option or nil)
			iData.value11.areaDirty = true
		end

		local areaIdOption = uidResult.Rarity or (uidResult.RarityName or (uidResult.Tier or uidResult.RarityId))

		if type(areaIdOption) == "table" then
			areaIdOption = areaIdOption.DisplayName or (areaIdOption._id or (areaIdOption.Name or areaIdOption.Id))
		end

		local areaId = type(areaIdOption) == "string" and areaIdOption or nil

		if iData.value34(areaId) == 0 then
			areaId = nil
		end

		if not areaId then
			repeat
				if not flag and AreaId then
					areaId = iData.value13.areaTierName[AreaId]

					if not areaId then
						flag = true
					end
				else
					flag = false

					local areaIdOption = uidResult.Rarity
						or (uidResult.RarityName or (uidResult.Tier or uidResult.RarityId))

					if type(areaIdOption) == "table" then
						areaIdOption = areaIdOption.DisplayName
							or (areaIdOption._id or (areaIdOption.Name or areaIdOption.Id))
					end

					areaId = type(areaIdOption) == "string" and areaIdOption or nil
				end
			until not flag
		end

		local sum = #eggList + 1
		local Uid = uidResult.Uid
		local label = AreaId and iData.value13.areaLabel[AreaId] or "Unknown"
		local tier = AreaId and iData.value13.areaRarity[AreaId] or 0
		local rank = iData.value34(areaId)
		local mutated = iData.value48(uidResult)
		local size = uidResult.BoundsSize and uidResult.BoundsSize.Magnitude or 3

		eggList[sum] = {
			uid = Uid,
			area = AreaId,
			label = label,
			pos = Position,
			tier = tier,
			rarity = areaId,
			rank = rank,
			mutated = mutated,
			size = size,
		}
	end
	if iData.value11.areaDirty then
		iData.value11.areaDirty = false
		iData.value36()
		iData.value40()
		iData.value44("AreaFocus", iData.value37())
	end
	iData.value11.eggList = eggList
	iData.value11.eggListAt = tick()
	local uidData = {}
	for i = 1, #eggList do
		uidData[eggList[i].uid] = true
	end
	local timestamp = tick()
	for k, item in pairs(iData.value11.triedUids) do
		local secondaryK = k

		if not uidData[secondaryK] and timestamp - item > 300 then
			iData.value11.triedUids[secondaryK] = nil
			iData.value11.failUids[secondaryK] = nil
		end
	end

	return eggList
end
function iData.value50(uidArgument)
	local uid = iData.value11.triedUids[uidArgument.uid]

	if uid then
		local option = iData.value11.failUids[uidArgument.uid] or 0
		local number = 6

		if option >= 4 then
			number = 600
		elseif option == 3 then
			number = 120
		elseif option == 2 then
			number = 45
		elseif option == 1 then
			number = 18
		end

		if number > tick() - uid then
			return false
		end
	end

	if uidArgument.rank >= (iData.value10.rarityLadder.Secret or 8) then
		return true
	end

	if iData.value13.areaWantedCount > 0 and not iData.value13.areaWanted[uidArgument.area] then
		return false
	end

	if iData.value13.rarityWantedCount > 0 and not iData.value13.rarityWanted[uidArgument.rarity] then
		return false
	end

	return true
end
local function handleFlag()
	local secondaryInput = iData.value21()
	if not secondaryInput then
		return nil
	end
	iData.value49(false)
	local Position = secondaryInput.Position
	local alternateI
	local flagNumber
	for i = 1, #iData.value11.eggList do
		local secondaryI = iData.value11.eggList[i]

		if iData.value50(secondaryI) then
			local Magnitude = (secondaryI.pos - Position).Magnitude
			local differenceNumber = secondaryI.tier > 0 and secondaryI.tier or secondaryI.rank
			local difference = secondaryI.rank * 1000000000000
				+ differenceNumber * 100000000
				+ (not secondaryI.mutated and 0 or 1000000)
				- math.min(Magnitude, 100000)

			if not flagNumber or flagNumber < difference then
				flagNumber = difference
				alternateI = secondaryI
			end
		end
	end

	return alternateI
end
iData.value11.travelling = false
iData.value11.travelToken = 0
local function updateInstanceProperties(capturedInput, updateInstancePropertiesCondition)
	pcall(function()
		capturedInput.AssemblyLinearVelocity = Vector3.zero
		capturedInput.AssemblyAngularVelocity = Vector3.zero
	end)

	if updateInstancePropertiesCondition then
		pcall(function()
			updateInstancePropertiesCondition:ChangeState(Enum.HumanoidStateType.Physics)
		end)
	end
end
function iData.value51()
	local assemblyLinearVelocityCondition = iData.value21()
	local condition = iData.value22()

	if assemblyLinearVelocityCondition then
		pcall(function()
			assemblyLinearVelocityCondition.AssemblyLinearVelocity = Vector3.zero
			assemblyLinearVelocityCondition.AssemblyAngularVelocity = Vector3.zero
		end)
	end

	if condition then
		pcall(function()
			condition:ChangeState(Enum.HumanoidStateType.GettingUp)
		end)
		pcall(function()
			condition:ChangeState(Enum.HumanoidStateType.Landed)
		end)
	end
end
iData.value10.TRAP_RADIUS = 16
iData.value10.TRAP_WORDS = {
	"trap",
	"cage",
	"snare",
}
iData.value11.trapList = {}
iData.value11.trapModels = {}
iData.value11.trapAt = 0
function iData.value52()
	local trapModels = {}
	local trapList = {}
	local debris = iData.value7:FindFirstChild("__DEBRIS")

	for _, item in ipairs({
		debris,
		iData.value7,
	}) do
		if item then
			for _, child in ipairs(item:GetChildren()) do
				if
					(function(unplacePromptContainer)
						if not unplacePromptContainer:IsA("Model") then
							return false
						end

						if unplacePromptContainer:FindFirstChild("UnplacePrompt") then
							return true
						end

						local lower = unplacePromptContainer.Name:lower()

						for _, searchableText in ipairs(iData.value10.TRAP_WORDS) do
							if lower:find(searchableText, 1, true) then
								return true
							end
						end

						return false
					end)(child)
				then
					local condition = (function(state)
						local capturedState = state
						local success, positionResult = pcall(function()
							return capturedState:GetPivot()
						end)
						if success and positionResult then
							return positionResult.Position
						end
						local BasePart = capturedState:FindFirstChildWhichIsA("BasePart")

						return BasePart and BasePart.Position or nil
					end)(child)

					if condition then
						trapList[#trapList + 1] = condition
						trapModels[#trapModels + 1] = child

						if iData.value14.AntiTrap then
							(function(argument)
								for _, descendant in ipairs(argument:GetDescendants()) do
									local capturedDescendant = descendant

									if capturedDescendant:IsA("BasePart") then
										pcall(function()
											capturedDescendant.CanTouch = false
										end)
										pcall(function()
											capturedDescendant.CanCollide = false
										end)
									end
								end
							end)(child)
						end
					end
				end
			end
		end
	end

	iData.value11.trapList = trapList
	iData.value11.trapModels = trapModels
	iData.value11.trapAt = tick()

	return trapList
end
function iData.value53()
	if tick() - iData.value11.trapAt > 2 then
		iData.value52()
	end

	return iData.value11.trapList
end
function iData.value54(differenceNumber, secondaryDifferenceNumber, numberFlag)
	if not iData.value14.AntiTrap then
		return false
	end

	local data = iData.value53()
	local productNumber = numberFlag or iData.value10.TRAP_RADIUS
	local product = productNumber * productNumber

	for i = 1, #data do
		local vector = data[i]
		local difference = vector.X - differenceNumber
		local number = vector.Z - secondaryDifferenceNumber

		if product > difference * difference + number * number then
			return true
		end
	end

	return false
end
function iData.value55()
	local Character = iData.value9.Character
	if not Character then
		return
	end
	for index, item in ipairs(Character:GetDescendants()) do
		local capturedItem = item

		if capturedItem:IsA("BasePart") then
			if capturedItem.Anchored then
				pcall(function()
					capturedItem.Anchored = false
				end)
			end
		elseif capturedItem:IsA("WeldConstraint") or capturedItem:IsA("Weld") then
			pcall(function()
				local conditionFlag = capturedItem.Part0
				local flag = capturedItem.Part1
				local secondaryConditionFlag = conditionFlag and not conditionFlag:IsDescendantOf(Character)

				if not secondaryConditionFlag then
					if flag then
						flag = not flag:IsDescendantOf(Character)
					end

					secondaryConditionFlag = flag
				end

				if secondaryConditionFlag then
					capturedItem:Destroy()
				end
			end)
		end
	end
	local condition = iData.value22()
	if condition then
		pcall(function()
			condition:ChangeState(Enum.HumanoidStateType.GettingUp)
		end)
		pcall(function()
			condition:ChangeState(Enum.HumanoidStateType.Physics)
		end)
	end
end
iData.value11.groundParams = RaycastParams.new()
iData.value11.groundParams.FilterType = Enum.RaycastFilterType.Exclude
iData.value11.groundParams.IgnoreWater = true
function iData.value56()
	local data = {}

	if iData.value9.Character then
		data[#data + 1] = iData.value9.Character
	end

	for _, player in ipairs(iData.value2:GetPlayers()) do
		if player ~= iData.value9 and player.Character then
			data[#data + 1] = player.Character
		end
	end

	local condition = iData.value45()

	if condition then
		data[#data + 1] = condition
	end

	for _, item in ipairs(iData.value11.trapModels) do
		if item.Parent then
			data[#data + 1] = item
		end
	end

	return data
end
function iData.value57()
	iData.value11.groundParams.FilterDescendantsInstances = iData.value56()
end
iData.value10.PROBE_LOW = 7
iData.value10.PROBE_HIGH = 160
iData.value10.PROBE_DOWN = 420
iData.value10.STEP_MAX = 6
iData.value10.TRAVEL_SPEED = 1000
local function alternateHandler(parent)
	for _ = 1, 6 do
		if not parent or parent == iData.value7 then
			return false
		end

		if
			parent:IsA("Model") and parent:FindFirstChildWhichIsA("Humanoid")
			or parent:FindFirstChildWhichIsA("AnimationController")
		then
			return true
		end

		parent = parent.Parent
	end

	return false
end
iData.value58 = nil
function iData.value58(argument, secondaryArgument, differenceNumber, raycastResultNumber)
	local difference = differenceNumber

	for _ = 1, 4 do
		local raycastResult = iData.value7:Raycast(
			Vector3.new(argument, difference, secondaryArgument),
			Vector3.new(0, -(difference - (differenceNumber - raycastResultNumber)), 0),
			iData.value11.groundParams
		)

		if not raycastResult then
			return nil
		end

		if not alternateHandler(raycastResult.Instance) then
			return raycastResult.Position.Y
		end

		difference = raycastResult.Position.Y - 0.6

		if difference <= differenceNumber - raycastResultNumber then
			return nil
		end
	end

	return nil
end
function iData.value59(argument, secondaryArgument, flagNumber)
	local condition = iData.value58(
		argument,
		secondaryArgument,
		flagNumber + iData.value10.PROBE_LOW,
		iData.value10.PROBE_LOW + iData.value10.PROBE_DOWN
	)

	if condition then
		return condition
	end

	local flag = iData.value58(
		argument,
		secondaryArgument,
		flagNumber + iData.value10.PROBE_HIGH,
		iData.value10.PROBE_HIGH + iData.value10.PROBE_DOWN
	)

	if flag and flag > flagNumber + iData.value10.PROBE_LOW then
		return flag
	end

	return nil
end
function iData.value60()
	local instance = iData.value21()
	local condition = iData.value22()
	local number = instance and instance.Size.Y * 0.5 or 1
	local numberResult = 2

	if condition then
		local success, successResult = pcall(function()
			return condition.HipHeight
		end)

		if success then
			success = type(successResult) == "number" and successResult > 0
		end

		if success then
			numberResult = successResult
		end
	end

	return number + numberResult
end
iData.value11.PathService = game:GetService("PathfindingService")
iData.value10.ROUTE_SAMPLE = 14
iData.value10.ROUTE_DROP = 26
iData.value61 = nil
function iData.value61(secondaryVector, alternateVector, secondaryNumber)
	local vector = Vector3.new(alternateVector.X - secondaryVector.X, 0, alternateVector.Z - secondaryVector.Z)
	local Magnitude = vector.Magnitude

	if Magnitude < 1 then
		return true, secondaryNumber
	end

	local Unit = vector.Unit
	local number = math.ceil(Magnitude / iData.value10.ROUTE_SAMPLE)
	local flag = false
	local sumNumber = 0

	while true do
		sumNumber += 1

		if (not flag or not (number <= sumNumber)) and (flag or not (sumNumber <= number)) then
			break
		end

		local sum = secondaryVector + Unit * math.min(Magnitude, sumNumber * iData.value10.ROUTE_SAMPLE)

		if iData.value54(sum.X, sum.Z) then
			return false, secondaryNumber
		end

		local value59Result = iData.value59(sum.X, sum.Z, secondaryNumber)

		if not value59Result or math.abs(value59Result - secondaryNumber) > iData.value10.ROUTE_DROP then
			return false, secondaryNumber
		end

		secondaryNumber = value59Result
	end

	return true, secondaryNumber
end
function iData.value62(vector, flagData)
	local flag = iData.value59(vector.X, vector.Z, vector.Y)

	if not flag then
		return false
	end

	for i = 1, #flagData do
		local secondaryI = i
		local value61Result, t13Result = iData.value61(vector, flagData[secondaryI], flag)
		flag = t13Result
		if not value61Result then
			return false
		end
		vector = flagData[secondaryI]
	end

	return true
end
local hubCacheResult = iData.value11
local hubTriedResult = iData.value11
hubCacheResult.hubCache = nil
hubTriedResult.hubTried = false
iData.value63 = nil
function iData.value63(iteratorFlag, secondaryArgument)
	if not iteratorFlag then
		return nil
	end
	local zero = Vector3.zero
	local number = 0
	local iterator, state, control = ipairs(iteratorFlag:GetDescendants())
	local flag
	repeat
		local secondaryInput

		repeat
			control, secondaryInput = iterator(state, control)

			if not control then
				flag = true
			end

			if flag then
				break
			end
		until secondaryInput:IsA("BasePart")

		if flag then
			break
		end

		zero += secondaryInput.Position
		number += 1
	until secondaryArgument <= number
	flag = false
	if number == 0 then
		return nil
	end

	return zero / number
end
function iData.value64()
	if iData.value11.hubCache or iData.value11.hubTried then
		return iData.value11.hubCache
	end

	iData.value11.hubTried = true

	local quotient = iData.value63(iData.value7:FindFirstChild("Stands"), 60)

	if not quotient then
		local Plots = iData.value7:FindFirstChild("Plots")

		if Plots then
			local zero = Vector3.zero
			local quotientNumber = 0
			local GetChildren = Plots.GetChildren

			for _, item in ipairs(GetChildren(Plots)) do
				if item:IsA("Model") then
					local success, positionResult = pcall(function()
						return item:GetPivot()
					end)

					if success and positionResult then
						zero += positionResult.Position
						quotientNumber += 1
					end
				end
			end

			if quotientNumber > 0 then
				quotient = zero / quotientNumber
			end
		end
	end

	if quotient then
		local hubCacheCondition = iData.value59(quotient.X, quotient.Z, quotient.Y)
			or iData.value59(quotient.X, quotient.Z, quotient.Y + 200)

		if hubCacheCondition then
			iData.value11.hubCache = Vector3.new(quotient.X, hubCacheCondition, quotient.Z)
		end
	end

	return iData.value11.hubCache
end
function iData.value65(iData)
	local vectorData = {}

	for i = 1, #iData do
		local vector = iData[i]
		local secondaryVector = vectorData[#vectorData]

		if
			not secondaryVector
			or Vector3.new(vector.X - secondaryVector.X, 0, vector.Z - secondaryVector.Z).Magnitude > 3
		then
			vectorData[#vectorData + 1] = vector
		end
	end

	if #vectorData < 3 then
		return vectorData
	end

	local data = {}

	for i = 2, #vectorData - 1 do
		local secondaryI = i
		local vector = Vector3.new(
			vectorData[secondaryI].X - vectorData[secondaryI - 1].X,
			0,
			vectorData[secondaryI].Z - vectorData[secondaryI - 1].Z
		)
		local secondaryVector = Vector3.new(
			vectorData[secondaryI + 1].X - vectorData[secondaryI].X,
			0,
			vectorData[secondaryI + 1].Z - vectorData[secondaryI].Z
		)
		local isMagnitude = vector.Magnitude > 0.1

		if isMagnitude then
			isMagnitude = secondaryVector.Magnitude > 0.1

			if isMagnitude then
				isMagnitude = vector.Unit:Dot(secondaryVector.Unit) < 0.995
			end
		end

		if isMagnitude then
			data[#data + 1] = vectorData[secondaryI]
		end
	end

	data[#data + 1] = vectorData[#vectorData]

	return data
end
local function updateTravelStep(updateTravelStepNumber, vector)
	local success, updateTravelStepResult = pcall(function()
		return iData.value11.PathService:CreatePath({
			AgentRadius = 3,
			AgentHeight = 6,
			AgentCanJump = true,
			AgentCanClimb = false,
			WaypointSpacing = 24,
		})
	end)
	local capturedResult = updateTravelStepResult
	if not success or not capturedResult then
		return nil
	end
	local secondarySuccess = pcall(function()
		capturedResult:ComputeAsync(updateTravelStepNumber, vector)
	end)
	iData.value11.travelStep = tick()
	local Status
	local Waypoints
	pcall(function()
		Status = capturedResult.Status
	end)
	if secondarySuccess and Status == Enum.PathStatus.Success then
		pcall(function()
			Waypoints = capturedResult:GetWaypoints()
		end)
	end
	pcall(function()
		capturedResult:Destroy()
	end)
	if type(Waypoints) ~= "table" or #Waypoints < 2 then
		return nil
	end
	local updateTravelStepData = {}
	for i = 2, #Waypoints do
		updateTravelStepData[#updateTravelStepData + 1] = Waypoints[i].Position
	end
	updateTravelStepData[#updateTravelStepData] = vector

	return iData.value65(updateTravelStepData)
end
iData.value10.SIDE_OFFSETS = {
	30,
	-30,
	70,
	-70,
	140,
	-140,
	240,
	-240,
}
iData.value10.STRAIGHT_MAX = 60
iData.value66 = nil
function iData.value66(secondaryVector, secondaryArgument, alternateVector)
	if iData.value62(secondaryVector, {
		alternateVector,
		secondaryArgument,
	}) then
		return {
			alternateVector,
			secondaryArgument,
		}
	end

	local vector = Vector3.new(alternateVector.X - secondaryVector.X, 0, alternateVector.Z - secondaryVector.Z)

	if vector.Magnitude > 1 then
		local sumNumber = Vector3.new(-vector.Unit.Z, 0, vector.Unit.X)

		for i = 1, #iData.value10.SIDE_OFFSETS do
			local sum = alternateVector + sumNumber * iData.value10.SIDE_OFFSETS[i]
			local vector34Flag = iData.value59(sum.X, sum.Z, alternateVector.Y)

			if not vector34Flag then
				continue
			end

			local secondaryResult = Vector3.new(sum.X, vector34Flag, sum.Z)

			if iData.value62(secondaryVector, {
				secondaryResult,
				secondaryArgument,
			}) then
				return {
					secondaryResult,
					secondaryArgument,
				}
			end
		end
	end

	return nil
end
function iData.value67(secondaryVector, alternateVector)
	local isValue10StraightMax = Vector3.new(
		alternateVector.X - secondaryVector.X,
		0,
		alternateVector.Z - secondaryVector.Z
	).Magnitude <= iData.value10.STRAIGHT_MAX

	if isValue10StraightMax then
		isValue10StraightMax = iData.value62(secondaryVector, { alternateVector })
	end

	if isValue10StraightMax then
		return { alternateVector }
	end

	local condition = iData.value64()

	if condition then
		local value66Result = iData.value66(secondaryVector, alternateVector, condition)

		if value66Result then
			return value66Result
		end
	end

	local vector = Vector3.new(alternateVector.X - secondaryVector.X, 0, alternateVector.Z - secondaryVector.Z)

	if vector.Magnitude > 1 then
		local Unit = vector.Unit
		local sumNumber = Vector3.new(-Unit.Z, 0, Unit.X)
		local sum = secondaryVector + vector * 0.5

		for i = 1, #iData.value10.SIDE_OFFSETS do
			local vector = sum + sumNumber * iData.value10.SIDE_OFFSETS[i]
			local vector36Flag = iData.value59(vector.X, vector.Z, sum.Y)

			if not vector36Flag then
				continue
			end

			local secondaryResult = Vector3.new(vector.X, vector36Flag, vector.Z)

			if iData.value62(secondaryVector, {
				secondaryResult,
				alternateVector,
			}) then
				return {
					secondaryResult,
					alternateVector,
				}
			end
		end
	end

	local flag = updateTravelStep(secondaryVector, alternateVector)

	if flag and #flag > 0 then
		return flag
	end

	if condition then
		return {
			condition,
			alternateVector,
		}
	end

	return { alternateVector }
end
function iData.value68(secondaryVector, secondaryFlag, callback, quaternaryArgument)
	local secondaryInput = iData.value21()

	if not secondaryInput then
		return false
	end

	local Position = secondaryInput.Position
	local vector = Vector3.new(secondaryVector.X - Position.X, 0, secondaryVector.Z - Position.Z)
	local Magnitude = vector.Magnitude

	if Magnitude <= 0.5 then
		return true
	end

	local Unit = vector.Unit
	local Rotation = CFrame.lookAt(Vector3.zero, Unit).Rotation
	local sumNumber = iData.value60()
	local sum = (iData.value59(Position.X, Position.Z, Position.Y - sumNumber) or Position.Y - sumNumber) + sumNumber
	local number = 0
	local position = Position
	local secondarySum = tick() + Magnitude / iData.value10.TRAVEL_SPEED + 10
	local flag = false
	local timestamp = tick()

	while iData.value17() and quaternaryArgument == iData.value11.travelToken and (not callback or callback()) do
		local dt = iData.value3.Heartbeat:Wait()
		iData.value11.travelStep = tick()
		local value21Result = iData.value21()
		local updateInstancePropertiesCondition = iData.value22()
		local capturedInput = value21Result
		if
			not capturedInput
			or (
				not capturedInput.Parent
				or (not updateInstancePropertiesCondition or updateInstancePropertiesCondition.Health <= 0)
			)
		then
			break
		end
		if (capturedInput.Position - position).Magnitude > 2 then
			position = capturedInput.Position
			timestamp = tick()
		elseif tick() - timestamp > 0.5 then
			timestamp = tick()
			iData.value55()
		end
		if secondarySum < tick() then
			break
		end
		local quotientNumber = math.min(iData.value10.TRAVEL_SPEED * math.min(dt, 0.1), Magnitude - number)
		local secondaryQuotientNumber = math.max(1, (math.ceil(quotientNumber / iData.value10.STEP_MAX)))
		local quotient = quotientNumber / secondaryQuotientNumber
		for _ = 1, secondaryQuotientNumber do
			number = math.min(Magnitude, number + quotient)

			local vector = Position + Unit * number
			local condition = iData.value59(vector.X, vector.Z, sum - sumNumber)

			if condition then
				sum += math.clamp(condition + sumNumber - sum, -iData.value10.STEP_MAX * 4, iData.value10.STEP_MAX * 4)
			end

			if Magnitude <= number then
				break
			end
		end
		local vector = Position + Unit * number
		pcall(function()
			capturedInput.CFrame = CFrame.new(vector.X, sum, vector.Z) * Rotation
		end)
		updateInstanceProperties(capturedInput, updateInstancePropertiesCondition)
		if number >= Magnitude - 0.01 then
			flag = true

			break
		end
	end

	if quaternaryArgument ~= iData.value11.travelToken then
		return false
	end

	if flag then
		return true
	end

	local alternateInput = iData.value21()

	if not alternateInput then
		return false
	end

	return Vector3.new(secondaryVector.X - alternateInput.Position.X, 0, secondaryVector.Z - alternateInput.Position.Z).Magnitude
		<= (secondaryFlag or 8)
end
iData.value10.TP_STEP = 45
iData.value10.TP_WAIT = 0.08
local function updateHatchCursor(secondaryVector, flag, hatchCursorCallback, quaternaryArgument)
	local updateInstancePropertiesFlag = iData.value21()

	if not updateInstancePropertiesFlag then
		return false
	end

	local Position = updateInstancePropertiesFlag.Position
	local vector = Vector3.new(secondaryVector.X - Position.X, 0, secondaryVector.Z - Position.Z)
	local Magnitude = vector.Magnitude

	if Magnitude <= 0.5 then
		return true
	end

	local Unit = vector.Unit
	local Rotation = CFrame.lookAt(Vector3.zero, Unit).Rotation
	local updateInstancePropertiesNumber = iData.value60()
	local sum = (
		iData.value59(Position.X, Position.Z, Position.Y - updateInstancePropertiesNumber)
		or Position.Y - updateInstancePropertiesNumber
	) + updateInstancePropertiesNumber
	local sumNumber = 0
	local updateHatchCursorNumber = math.ceil(Magnitude / iData.value10.TP_STEP)
	local position = Position
	local number = tick() + updateHatchCursorNumber * (iData.value10.TP_WAIT + 0.06) + 10
	local timestamp = tick()

	while
		iData.value17()
		and quaternaryArgument == iData.value11.travelToken
		and (not hatchCursorCallback or hatchCursorCallback())
	do
		local updateInstancePropertiesFlag = iData.value21()
		local updateInstancePropertiesCondition = iData.value22()
		local capturedInput = updateInstancePropertiesFlag

		if
			not capturedInput
			or (not capturedInput.Parent or (not updateInstancePropertiesCondition or updateInstancePropertiesCondition.Health <= 0))
			or number < tick()
		then
			break
		end

		if (capturedInput.Position - position).Magnitude > 2 then
			position = capturedInput.Position
			timestamp = tick()
		elseif tick() - timestamp > 0.5 then
			timestamp = tick()
			iData.value55()
		end

		sumNumber = math.min(Magnitude, sumNumber + iData.value10.TP_STEP)

		local vector = Position + Unit * sumNumber
		local updateHatchCursorNumber = iData.value59(vector.X, vector.Z, sum - updateInstancePropertiesNumber)

		if updateHatchCursorNumber then
			sum = updateHatchCursorNumber + updateInstancePropertiesNumber
		end

		pcall(function()
			capturedInput.CFrame = CFrame.new(vector.X, sum, vector.Z) * Rotation
		end)
		updateInstanceProperties(capturedInput, updateInstancePropertiesCondition)
		iData.value11.travelStep = tick()

		if sumNumber >= Magnitude - 0.01 then
			return true
		end

		task.wait(iData.value10.TP_WAIT)
	end

	if quaternaryArgument ~= iData.value11.travelToken then
		return false
	end

	local updateHatchCursorFlag = iData.value21()

	if not updateHatchCursorFlag then
		return false
	end

	return Vector3.new(
		secondaryVector.X - updateHatchCursorFlag.Position.X,
		0,
		secondaryVector.Z - updateHatchCursorFlag.Position.Z
	).Magnitude <= (flag or 8)
end
local function updateGoToTreadmill(vector, number, isUpdateHatchCursorValid)
	local updateHatchCursorFlag = iData.value21()

	if not updateHatchCursorFlag or not vector then
		return false
	end

	local updateHatchCursorNumber = number or 8

	if
		updateHatchCursorNumber
		>= Vector3.new(vector.X - updateHatchCursorFlag.Position.X, 0, vector.Z - updateHatchCursorFlag.Position.Z).Magnitude
	then
		return true
	end

	iData.value11.travelToken = iData.value11.travelToken + 1
	iData.value11.travelling = false
	iData.value57()
	iData.value52()

	local travelToken = iData.value11.travelToken

	iData.value11.travelStep = tick()
	iData.value11.travelling = true

	local hatchCursorCallback = iData.value14.FarmMethod == "TP Walk" and updateHatchCursor or iData.value68
	local updateHatchCursorData = iData.value67(updateHatchCursorFlag.Position, vector)
	local flag = true

	for i = 1, #updateHatchCursorData do
		if
			not hatchCursorCallback(
				updateHatchCursorData[i],
				i == #updateHatchCursorData and updateHatchCursorNumber or 4,
				isUpdateHatchCursorValid,
				travelToken
			)
		then
			flag = false

			break
		end
	end

	if travelToken ~= iData.value11.travelToken then
		return false
	end

	iData.value11.travelling = false
	iData.value51()

	local secondaryInput = iData.value21()

	if not secondaryInput then
		return false
	end

	return flag
		and Vector3.new(vector.X - secondaryInput.Position.X, 0, vector.Z - secondaryInput.Position.Z).Magnitude
			<= updateHatchCursorNumber + 6
end
iData.value11.travelStep = 0
secondaryHandler(iData.value3.Heartbeat:Connect(function()
	if iData.value11.travelling and tick() - iData.value11.travelStep > 6 then
		iData.value11.travelling = false
		iData.value51()
	end
end))
secondaryHandler(iData.value9.CharacterAdded:Connect(function()
	iData.value11.travelToken = iData.value11.travelToken + 1
	iData.value11.travelling = false
	iData.value11.travelStep = 0
	iData.value11.carryingUid = nil
	iData.value11.deliverFails = 0
	iData.value11.penCache = nil
end))

local debris = iData.value7:FindFirstChild("__DEBRIS")

if debris then
	secondaryHandler(debris.ChildAdded:Connect(function()
		task.delay(0.1, function()
			if iData.value17() and iData.value14.AntiTrap then
				pcall(iData.value52)
			end
		end)
	end))
end
handler(function()
	while iData.value17() do
		if iData.value14.AntiTrap then
			pcall(iData.value52)
		end

		task.wait(3)
	end
end)
iData.value11.voidBusy = false
function iData.value69(argument)
	if not iData.value23() then
		return false
	end

	local secondaryInput = iData.value21()

	return secondaryInput ~= nil and (secondaryInput.Parent ~= nil and argument < secondaryInput.Position.Y)
end
function iData.value70()
	if iData.value11.voidBusy then
		return false
	end

	local secondaryInput = iData.value21()

	if not secondaryInput then
		return false
	end

	iData.value11.voidBusy = true
	iData.value11.travelToken = iData.value11.travelToken + 1
	iData.value11.travelling = false

	local capturedResult = -500
	local success, successResult = pcall(function()
		return iData.value7.FallenPartsDestroyHeight
	end)

	if success then
		success = type(successResult) == "number"
	end

	if success then
		capturedResult = successResult
	end

	local sum = capturedResult + 60
	local Position = secondaryInput.Position
	local condition = iData.value22()

	if condition then
		pcall(function()
			condition:ChangeState(Enum.HumanoidStateType.Physics)
		end)
	end

	local number = tick() + 5

	while iData.value17() and number > tick() do
		local instance = iData.value21()

		if not instance or not instance.Parent then
			break
		end

		pcall(function()
			instance.CFrame = CFrame.new(Position.X, sum, Position.Z)
			instance.AssemblyLinearVelocity = Vector3.zero
			instance.AssemblyAngularVelocity = Vector3.zero
		end)
		iData.value3.Heartbeat:Wait()
	end

	local instance = iData.value21()

	if instance and instance.Parent then
		pcall(function()
			instance.CFrame = CFrame.new(Position.X, capturedResult - 250, Position.Z)
			instance.AssemblyLinearVelocity = Vector3.new(0, -280, 0)
		end)
	end

	local secondarySum = capturedResult + 200
	local alternateSum = tick() + 20
	local flag = false

	while iData.value17() and alternateSum > tick() do
		if iData.value69(secondarySum) then
			flag = true

			break
		end

		task.wait(0.2)
	end

	if not flag and iData.value17() then
		iData.value20("Using Fallback..", 5)
		iData.value27(iData.value25.RigWipe)

		local sum = tick() + 12

		while iData.value17() and sum > tick() do
			if iData.value69(secondarySum) then
				flag = true

				break
			end

			task.wait(0.2)
		end
	end

	iData.value11.voidBusy = false

	return flag
end
function iData.value71(argument)
	local Stands = iData.value7:FindFirstChild("Stands")
	local option = Stands and Stands:FindFirstChild("Prompts")
	local flag = option and option:FindFirstChild(argument)

	return flag and flag:FindFirstChildWhichIsA("ProximityPrompt") or nil
end
local function handleInput()
	local inputOption = iData.value71("SellAll") or iData.value71("Sell")
	local inputFlag = inputOption and inputOption.Parent

	if inputFlag and inputFlag:IsA("BasePart") then
		return inputFlag.CFrame * CFrame.new(0, 0, 3)
	end

	return nil
end
local cachedSlotResult = iData.value11
local cachedPlotResult = iData.value11
cachedSlotResult.cachedSlot = nil
cachedPlotResult.cachedPlot = nil
iData.value11.plotTried = 0
function iData.value72()
	if iData.value11.cachedPlot and iData.value11.cachedPlot.Parent then
		return iData.value11.cachedPlot
	end

	local Plots = iData.value7:FindFirstChild("Plots")

	if not Plots then
		return nil
	end

	if not iData.value11.cachedSlot then
		local value27Result = iData.value27(iData.value25.PlotState)

		if type(value27Result) == "table" then
			local data = value27Result.OwnersBySlot
				or (value27Result.SlotOwners or (value27Result.Owners or value27Result.Slots))

			if type(data) == "table" then
				for k, secondaryItem in pairs(data) do
					local item = secondaryItem

					if type(secondaryItem) == "table" then
						item = secondaryItem.UserId
							or (secondaryItem.OwnerUserId or (secondaryItem.Id or secondaryItem.Name))
					end

					if
						item == iData.value9.UserId
						or (item == tostring(iData.value9.UserId) or item == iData.value9.Name)
					then
						iData.value11.cachedSlot = k

						break
					end
				end
			end
		end
	end

	if iData.value11.cachedSlot then
		local cachedPlotResult = iData.value11
		local cachedPlotData = { tostring(iData.value11.cachedSlot) }

		cachedPlotResult.cachedPlot = Plots:FindFirstChild(unpackValues(cachedPlotData))

		if iData.value11.cachedPlot then
			return iData.value11.cachedPlot
		end
	end

	if tick() - iData.value11.plotTried < 10 then
		return nil
	end

	local plotTriedResult = iData.value11
	local GetChildren = Plots.GetChildren

	plotTriedResult.plotTried = tick()

	for _, cachedPlot in ipairs(GetChildren(Plots)) do
		for _, descendant in ipairs(cachedPlot:GetDescendants()) do
			local capturedDescendant = descendant

			if capturedDescendant:IsA("TextLabel") or capturedDescendant:IsA("TextButton") then
				local success, successResult = pcall(function()
					return capturedDescendant.Text
				end)

				if success then
					success = type(successResult) == "string"

					if success then
						success = #successResult > 0

						if success then
							success = successResult:find(iData.value9.Name, 1, true)
						end
					end
				end

				if success then
					iData.value11.cachedPlot = cachedPlot

					return cachedPlot
				end
			end
		end
	end

	return nil
end
local function isUpdateHatchCursorInputValid()
	local flag = iData.value72()

	if not flag then
		return nil
	end

	local success, secondaryResult = pcall(function()
		return flag:GetPivot()
	end)

	return success and secondaryResult or nil
end
iData.value11.penCache = nil
function iData.value73()
	if iData.value11.penCache then
		return iData.value11.penCache
	end

	local getDescendantsCondition = iData.value72()

	if getDescendantsCondition then
		local GetDescendants = getDescendantsCondition.GetDescendants

		for _, item in ipairs(GetDescendants(getDescendantsCondition)) do
			local capturedV = item

			if capturedV.Name:lower():find("pen", 1, true) then
				if capturedV:IsA("BasePart") then
					iData.value11.penCache = capturedV.CFrame

					return iData.value11.penCache
				end

				if capturedV:IsA("Model") then
					local success, penCacheResult = pcall(function()
						return capturedV:GetPivot()
					end)

					if success and penCacheResult then
						iData.value11.penCache = penCacheResult

						return iData.value11.penCache
					end
				end
			end
		end
	end

	local flag = iData.value72()
	local penCacheNumber

	if not flag then
		penCacheNumber = nil
	else
		local success, penCacheNumberResult = pcall(function()
			return flag:GetPivot()
		end)

		penCacheNumber = success and penCacheNumberResult or nil
	end

	if penCacheNumber then
		iData.value11.penCache = penCacheNumber * CFrame.new(0, 0, 15)

		return iData.value11.penCache
	end

	return nil
end
function iData.value74(alternatePlayer)
	local secondaryPlayer = alternatePlayer.OwnerUserId
		or (alternatePlayer.UserId or (alternatePlayer.PlayerId or alternatePlayer.Owner))

	if type(secondaryPlayer) == "table" then
		secondaryPlayer = secondaryPlayer.UserId or (secondaryPlayer.userId or secondaryPlayer.Id)
	end

	return secondaryPlayer
end
iData.value75 = nil
function iData.value75(argument)
	local value74Result = iData.value74(argument)

	if type(value74Result) == "number" then
		return value74Result == iData.value9.UserId
	end

	if type(value74Result) == "string" then
		return value74Result == tostring(iData.value9.UserId) or value74Result == iData.value9.Name
	end

	return nil
end
iData.value76 = nil
function iData.value76()
	local updateUidData = {}
	local data = {}
	local recordsData = iData.value27(iData.value25.EggLive)
	if type(recordsData) ~= "table" then
		return updateUidData
	end
	local function updateUid(secondaryUpdateUidData)
		for k, item in pairs(secondaryUpdateUidData) do
			local secondaryK = k

			if type(item) == "table" then
				local uid = item.Uid or (type(secondaryK) == "string" and secondaryK or nil)

				if uid and (not data[uid] and iData.value75(item) ~= false) then
					data[uid] = true

					if item.Uid == nil then
						item.Uid = uid
					end

					updateUidData[#updateUidData + 1] = item
				end
			end
		end
	end
	for key, item in pairs(recordsData) do
		if type(item) == "table" and (iData.value75(item) == true and type(item.Records) == "table") then
			updateUid(item.Records)
		end
	end
	if #updateUidData == 0 then
		for _, item in pairs(recordsData) do
			if type(item) == "table" and type(item.Records) == "table" then
				updateUid(item.Records)
			end
		end
	end
	if #updateUidData == 0 and type(recordsData.Records) == "table" then
		updateUid(recordsData.Records)
	end

	return updateUidData
end
function iData.value77()
	local lData = {
		l = {},
		w = {},
	}
	for index, item in ipairs(iData.value76()) do
		local Placement = item.Placement
		local l = Placement and Placement.LocalCFrame or (Placement.CFrame or Placement.WorldCFrame)

		if typeof(l) == "CFrame" then
			lData.l[#lData.l + 1] = l.Position
		elseif typeof(l) == "Vector3" then
			lData.l[#lData.l + 1] = l
		end
	end
	for _, child in ipairs(iData.value7:GetChildren()) do
		if child.Name == "PlacedEggRenders" then
			for _, item in ipairs(child:GetChildren()) do
				local capturedItem = item
				local success, wResult = pcall(function()
					if capturedItem:IsA("BasePart") then
						return capturedItem.Position
					end

					if capturedItem:IsA("Model") then
						return capturedItem:GetPivot().Position
					end

					return nil
				end)

				if success and wResult then
					lData.w[#lData.w + 1] = wResult
				end
			end
		end
	end

	return lData
end
iData.value11.originCache = nil
iData.value11.originAt = 0
local function updateData()
	if iData.value11.originCache and tick() - iData.value11.originAt < 15 then
		return iData.value11.originCache
	end

	local updateData = {}
	local updateDataCondition = iData.value72()

	if updateDataCondition then
		local success, cFrameResult = pcall(function()
			return updateDataCondition.PrimaryPart
		end)
		if success and cFrameResult then
			updateData[#updateData + 1] = cFrameResult.CFrame
		end
		local item
		local updateDataNumber = 0
		for index, secondaryItem in ipairs(updateDataCondition:GetChildren()) do
			if secondaryItem:IsA("BasePart") then
				local lower = secondaryItem.Name:lower()
				local updateDataCondition = lower:find("base", 1, true)

				if not updateDataCondition then
					updateDataCondition = lower:find("plate", 1, true)

					if not updateDataCondition then
						updateDataCondition = lower:find("pad", 1, true)
							or (
								lower:find("floor", 1, true)
								or (lower:find("ground", 1, true) or lower:find("origin", 1, true))
							)
					end
				end

				if updateDataCondition then
					local product = secondaryItem.Size.X * secondaryItem.Size.Z

					if updateDataNumber < product then
						item = secondaryItem
						updateDataNumber = product
					end
				end
			end
		end
		if item then
			updateData[#updateData + 1] = item.CFrame
		end
		local secondarySuccess, updateDataResult = pcall(function()
			return updateDataCondition:GetPivot()
		end)
		if secondarySuccess and updateDataResult then
			updateData[#updateData + 1] = updateDataResult
		end
	end

	if #updateData == 0 then
		updateData[1] = CFrame.new()
	end

	local originCache = {}

	for _, item in ipairs(updateData) do
		local updateDataFlag = true

		for _, secondaryItem in ipairs(originCache) do
			if (secondaryItem.Position - item.Position).Magnitude < 0.5 then
				updateDataFlag = false

				break
			end
		end

		if updateDataFlag then
			originCache[#originCache + 1] = item
		end
	end

	iData.value11.originCache = originCache
	iData.value11.originAt = tick()

	return originCache
end
iData.value10.RING8 = {
	{
		1,
		0,
	},
	{
		-1,
		0,
	},
	{
		0,
		1,
	},
	{
		0,
		-1,
	},
	{
		1,
		1,
	},
	{
		1,
		-1,
	},
	{
		-1,
		1,
	},
	{
		-1,
		-1,
	},
}
iData.value10.PLACE_PITCH = 6
iData.value10.PLACE_HALF = 24
iData.value10.EGG_CLEAR = 7
iData.value10.ZONE_HALF = 20
iData.value10.GRID_STEP = 4
iData.value11.claimedCells = {}
local function handleData()
	local dataNumber = updateData()[1]

	if not dataNumber then
		return {}
	end

	local w = iData.value77().w
	local sumData = {}
	local data = {}
	local product = iData.value10.EGG_CLEAR * iData.value10.EGG_CLEAR

	local function handleResult(differenceNumber, number)
		local dataNumber = 1e999

		for _, item in ipairs(w) do
			local difference = item.X - differenceNumber
			local resultNumber = item.Z - number
			local product = resultNumber * resultNumber
			local sum = difference * difference + product

			if sum < dataNumber then
				dataNumber = sum
			end
		end

		return dataNumber
	end

	local ZONE_HALF = iData.value10.ZONE_HALF
	local GRID_STEP = iData.value10.GRID_STEP
	local dataResult = -ZONE_HALF

	while dataResult <= ZONE_HALF do
		local secondaryDataResult = -ZONE_HALF

		while secondaryDataResult <= ZONE_HALF do
			(function(lx, lz)
				local vector = dataNumber * CFrame.new(lx, 0, lz)
				local dataText = math.floor(vector.X / 3) .. ":" .. math.floor(vector.Z / 3)

				if data[dataText] then
					return
				end

				local number = iData.value11.claimedCells[dataText]

				if number and tick() - number < 20 then
					return
				end

				local clrResult = handleResult(vector.X, vector.Z)

				if clrResult < product then
					return
				end

				local dataFlag = iData.value59(vector.X, vector.Z, dataNumber.Position.Y)

				if not dataFlag then
					return
				end

				data[dataText] = true

				local secondarySumData = sumData
				local sum = #sumData + 1
				local secondaryW = Vector3.new(vector.X, dataFlag, vector.Z)
				local clr = math.sqrt(clrResult)

				secondarySumData[sum] = {
					key = dataText,
					w = secondaryW,
					lx = lx,
					lz = lz,
					clr = clr,
				}
			end)(secondaryDataResult, dataResult)
			secondaryDataResult += GRID_STEP
		end

		dataResult += GRID_STEP
	end

	return sumData
end
function iData.value78()
	local Character = iData.value9.Character

	return Character ~= nil and Character:FindFirstChildWhichIsA("Tool") ~= nil
end
function iData.value79(argument)
	if iData.value78() then
		return true
	end

	for _ = 1, 8 do
		iData.value33(iData.value25.WearTool, argument)

		for _ = 1, 4 do
			iData.value3.Heartbeat:Wait()

			if iData.value78() then
				return true
			end
		end
	end

	return false
end
iData.value10.SHAPE_FILE = "ShardPlaceShape.txt"
iData.value11.placeOK = nil
iData.value11.placeWhy = ""
iData.value11.placeLog = {}
iData.value11.placeFails = 0
function iData.value80(displayValue, secondaryDisplayValue)
	iData.value11.placeLog[#iData.value11.placeLog + 1] = tostring(displayValue)
		.. " "
		.. tostring(secondaryDisplayValue)

	if #iData.value11.placeLog > 12 then
		table.remove(iData.value11.placeLog, 1)
	end
end
function iData.value81()
	if iData.value11.placeOK and type(writefile) == "function" then
		pcall(function()
			writefile(iData.value10.SHAPE_FILE, (tostring(iData.value11.placeOK.origin)))
		end)
	end
end
if type(isfile) == "function" and type(readfile) == "function" then
	local success, numberResult = pcall(function()
		if isfile(iData.value10.SHAPE_FILE) then
			return readfile(iData.value10.SHAPE_FILE)
		end

		return nil
	end)
	local placeOkNumber = success and tonumber(numberResult) or nil

	if placeOkNumber and placeOkNumber >= 1 then
		iData.value11.placeOK = {
			origin = math.floor(placeOkNumber),
		}
	end
end
local function sendEggPlace(uid, sendEggPlaceText, positionNumber)
	local positionFlag = updateData()[sendEggPlaceText]

	if not positionFlag then
		return false
	end

	local remoteFunction = iData.value26(iData.value25.EggPlace)

	if not remoteFunction or not remoteFunction:IsA("RemoteFunction") then
		return false
	end

	if not iData.value78() then
		return false
	end

	local Position = (positionFlag:Inverse() * positionNumber).Position
	local cFrame = CFrame.new(Position)
	local success, whyResult = pcall(function()
		return remoteFunction:InvokeServer({
			Uid = uid,
			LocalCFrame = cFrame,
		})
	end)

	if not success then
		if type(whyResult) == "string" and #whyResult > 0 then
			iData.value11.placeWhy = whyResult:sub(1, 140)
		end

		iData.value80("O" .. sendEggPlaceText, whyResult)

		return false
	end

	if type(whyResult) == "string" and #whyResult > 0 then
		iData.value11.placeWhy = whyResult:sub(1, 140)
		iData.value80("O" .. sendEggPlaceText, whyResult)
	elseif type(whyResult) == "table" then
		local placeWhyOption = whyResult.Error or (whyResult.Reason or (whyResult.Message or whyResult.Why))

		if type(placeWhyOption) == "string" and #placeWhyOption > 0 then
			iData.value11.placeWhy = placeWhyOption:sub(1, 140)
		end

		iData.value80("O" .. sendEggPlaceText, placeWhyOption or "table reply")
	else
		iData.value11.placeWhy = "server returned " .. tostring(whyResult)
		iData.value80("O" .. sendEggPlaceText, "returned " .. tostring(whyResult))
	end

	for _ = 1, 16 do
		if not iData.value78() then
			return true
		end

		iData.value3.Heartbeat:Wait()
	end

	return false
end
function iData.value82(uid, secondaryArgument)
	local cFrame = CFrame.new(secondaryArgument.w)
	local data = updateData()

	if iData.value11.placeOK and data[iData.value11.placeOK.origin] then
		return sendEggPlace(uid, iData.value11.placeOK.origin, cFrame)
	end

	for i = 1, #data do
		local secondaryI = i

		if sendEggPlace(uid, secondaryI, cFrame) then
			iData.value11.placeOK = {
				origin = secondaryI,
			}
			iData.value81()

			return true
		end

		task.wait(0.04)
	end

	return false
end
local function secondaryUpdateInstanceProperties(updateInstancePropertiesText, updateInstancePropertiesFlag)
	local updateInstancePropertiesOption = updateInstancePropertiesFlag or 18
	if not iData.value79(updateInstancePropertiesText) then
		iData.value11.placeWhy = "egg never reached the hand"

		return false, false
	end
	local updateInstancePropertiesCondition = iData.value9.Character
		and iData.value9.Character:FindFirstChildWhichIsA("Tool")
	if updateInstancePropertiesCondition then
		local UID = updateInstancePropertiesCondition:GetAttribute("UID")

		if UID == nil then
			for _, child in ipairs(updateInstancePropertiesCondition:GetChildren()) do
				if child:IsA("Model") then
					UID = child.Name:match("_(%w+)$")

					if UID then
						break
					end
				end
			end
		end

		if UID ~= nil then
			updateInstancePropertiesText = tostring(UID)
		end
	end
	if not iData.value11.placeOK then
		iData.value11.placeLog = {}
		iData.value11.placeWhy = ""
	end
	local updateInstancePropertiesData = handleData()
	local numberData = updateData()
	local updateInstancePropertiesNumber = numberData[1] and numberData[1].Position
		or (iData.value21() and iData.value21().Position or Vector3.zero)
	table.sort(updateInstancePropertiesData, function(updateInstancePropertiesArgument, secondaryArgument)
		return (updateInstancePropertiesArgument.w - updateInstancePropertiesNumber).Magnitude
			< (secondaryArgument.w - updateInstancePropertiesNumber).Magnitude
	end)
	local updateInstancePropertiesResult = #iData.value76()
	local number = 0
	for index, item in ipairs(updateInstancePropertiesData) do
		number += 1

		if iData.value82(updateInstancePropertiesText, item) then
			iData.value11.claimedCells[item.key] = tick()
			iData.value11.placeFails = 0

			return true
		end

		if not iData.value78() then
			iData.value11.placeFails = 0

			return true
		end

		if updateInstancePropertiesOption <= number then
			break
		end

		task.wait(0.04)
	end
	if not iData.value78() then
		iData.value11.placeFails = 0

		return true
	end
	if updateInstancePropertiesResult < #iData.value76() then
		iData.value11.placeFails = 0

		return true
	end
	iData.value11.placeFails = iData.value11.placeFails + 1
	if iData.value11.placeOK and iData.value11.placeFails >= 3 then
		iData.value11.placeOK = nil
		iData.value11.placeFails = 0
	end

	return false, #updateInstancePropertiesData == 0
end
function iData.value83(uid)
	if iData.value27(iData.value25.EggCarry, {
		Uid = uid,
	}) ~= true then
		return false
	end

	task.spawn(function()
		for _ = 1, 3 do
			if iData.value78() then
				return
			end

			iData.value33(iData.value25.WearTool, uid)
			task.wait(0.15)
		end
	end)

	return true
end
function iData.value84(argument)
	local flag = iData.value45()

	if not flag then
		return true
	end

	return flag:FindFirstChild(argument) ~= nil
end
iData.value10.GRAB_TOLERANCE = 8
local function isUpdateHatchCursorValid(vector, number)
	local secondaryInput = iData.value21()

	if not secondaryInput or not vector then
		return false
	end

	return (Vector3.new(secondaryInput.Position.X, 0, secondaryInput.Position.Z) - Vector3.new(vector.X, 0, vector.Z)).Magnitude
		<= (number or 12) + iData.value10.GRAB_TOLERANCE
end
iData.value11.carryingUid = nil
function iData.value85(posArgument)
	local condition = iData.value47(posArgument.uid)

	if condition then
		posArgument.pos = condition.Position
	end

	return posArgument.pos
end
function iData.value86()
	return iData.value17() and iData.value14.AutoSteal
end
function iData.value87()
	for _, child in ipairs(iData.value7:GetChildren()) do
		if child.Name == "SmartPromptPart" then
			local GetChildren = child.GetChildren

			for _, item in ipairs(GetChildren(child)) do
				if not (item:IsA("ProximityPrompt") and item.Enabled) then
					continue
				end

				local lower = (item.Name .. " " .. tostring(item.ActionText) .. " " .. tostring(item.ObjectText)):lower()

				if lower:find("place", 1, true) or (lower:find("plant", 1, true) or lower:find("drop", 1, true)) then
					return item
				end
			end
		end
	end

	return nil
end
iData.value11.deliverAt = 0
iData.value11.deliverFails = 0
iData.value11.dryRuns = 0
iData.value11.warnPlantAt = 0
iData.value11.hatchAll = nil
function iData.value88(updateInstancePropertiesText)
	local flag = iData.value72()
	local secondaryInput
	if not flag then
		secondaryInput = nil
	else
		local success, inputResult = pcall(function()
			return flag:GetPivot()
		end)

		secondaryInput = success and inputResult or nil
	end
	if secondaryInput and not isUpdateHatchCursorValid(secondaryInput.Position, 26) then
		updateGoToTreadmill(secondaryInput.Position, 14, iData.value86)
	end
	local alternateInput = iData.value73()
	if alternateInput and not isUpdateHatchCursorValid(alternateInput.Position, 12) then
		updateGoToTreadmill(alternateInput.Position, 8, iData.value86)
	end
	local condition, secondaryFlag = secondaryUpdateInstanceProperties(updateInstancePropertiesText)
	if condition then
		return true
	end
	if secondaryFlag and iData.value11.hatchAll then
		pcall(iData.value11.hatchAll, false)

		if secondaryUpdateInstanceProperties(updateInstancePropertiesText) then
			return true
		end
	end
	for _, item in ipairs({ iData.value87() }) do
		if iData.value31(item) and iData.value30(item) then
			for _ = 1, 12 do
				if not iData.value78() then
					return true
				end

				iData.value3.Heartbeat:Wait()
			end
		end
	end

	return false
end
handler(function()
	while iData.value17() do
		local number = 0.1

		if iData.value14.AutoSteal and iData.value23() then
			local success, secondaryResult = pcall(function()
				if iData.value11.carryingUid then
					if not iData.value78() and not iData.value84(iData.value11.carryingUid) then
						iData.value11.carryingUid = nil
						iData.value11.deliverFails = 0

						return
					end

					if tick() - iData.value11.deliverAt < 1 then
						return
					end

					iData.value11.deliverAt = tick()

					if iData.value88(iData.value11.carryingUid) then
						iData.value11.carryingUid = nil
						iData.value11.deliverFails = 0

						return
					end

					iData.value11.deliverFails = iData.value11.deliverFails + 1

					if iData.value11.deliverFails >= 4 then
						iData.value11.deliverFails = 0
						iData.value33(iData.value25.DoffTool, iData.value11.carryingUid)
						iData.value11.carryingUid = nil

						if tick() - iData.value11.warnPlantAt > 60 then
							iData.value11.warnPlantAt = tick()
							iData.value20(
								"Could not plant that egg"
									.. (#iData.value11.placeWhy > 0 and ": " .. iData.value11.placeWhy or "")
									.. ". Moving on to the next one.",
								6
							)
						end
					end

					return
				end

				if iData.value14.SecretPriority and iData.value11.carryingUid then
					iData.value49(false)

					for i = 1, #iData.value11.eggList do
						local secondaryI = iData.value11.eggList[i]

						if
							secondaryI.rank >= (iData.value10.rarityLadder.Secret or 8) and iData.value50(secondaryI)
						then
							local flag
							for j = 1, #iData.value11.eggList do
								local secondaryJ = j

								if iData.value11.eggList[secondaryJ].uid == iData.value11.carryingUid then
									flag = iData.value11.eggList[secondaryJ]

									break
								end
							end
							if not ((flag and flag.rank or 0) < secondaryI.rank) then
								break
							end
							pcall(function()
								iData.value33(iData.value25.DoffTool, iData.value11.carryingUid)
							end)
							iData.value11.carryingUid = nil
							iData.value11.deliverFails = 0
							iData.value11.travelToken = iData.value11.travelToken + 1
							iData.value11.travelling = false
							iData.value20("Secret egg spotted — switching targets!", 4)

							break
						end
					end
				end

				local uidFlag = handleFlag()

				if not uidFlag then
					iData.value11.dryRuns = iData.value11.dryRuns + 1
					iData.value49(true)
					number = math.min(0.6 + iData.value11.dryRuns * 0.4, 3)

					return
				end

				iData.value11.dryRuns = 0
				iData.value11.triedUids[uidFlag.uid] = tick()

				local secondaryNumber = math.max(9, uidFlag.size * 0.6 + 7)

				local function isValid()
					return iData.value86() and iData.value84(uidFlag.uid)
				end

				local vector = iData.value85(uidFlag)

				if not isUpdateHatchCursorValid(vector, secondaryNumber) then
					updateGoToTreadmill(vector, secondaryNumber, isValid)

					if not iData.value86() then
						return
					end

					local secondaryVector = iData.value85(uidFlag)

					if not isUpdateHatchCursorValid(secondaryVector, secondaryNumber) then
						updateGoToTreadmill(secondaryVector, secondaryNumber, isValid)

						if not iData.value86() then
							return
						end
					end
				end

				local condition = iData.value83(uidFlag.uid)

				if not condition then
					task.wait(0.1)
					condition = iData.value83(uidFlag.uid)
				end

				if condition then
					iData.value11.failUids[uidFlag.uid] = nil
					iData.value11.carryingUid = uidFlag.uid
					iData.value11.deliverAt = tick()
					iData.value11.deliverFails = 0

					if iData.value88(uidFlag.uid) then
						iData.value11.carryingUid = nil
					else
						iData.value11.deliverFails = 1
					end

					number = 0

					return
				end

				iData.value11.failUids[uidFlag.uid] = (iData.value11.failUids[uidFlag.uid] or 0) + 1
			end)

			if not success then
				warn("[Shard] steal: " .. tostring(secondaryResult))
				task.wait(0.5)
			end
		else
			number = 0.3
		end

		if number > 0 then
			task.wait(number)
		else
			iData.value3.Heartbeat:Wait()
		end
	end
end)

local moveKeysResult = iData.value10
local W = Enum.KeyCode.W
local w = Vector3.new(0, 0, -1)
local S = Enum.KeyCode.S
local s = Vector3.new(0, 0, 1)
local A = Enum.KeyCode.A
local a = Vector3.new(-1, 0, 0)
local D = Enum.KeyCode.D
local d = Vector3.new(1, 0, 0)

moveKeysResult.MOVE_KEYS = {
	[W] = w,
	[S] = s,
	[A] = a,
	[D] = d,
}
iData.value11.held = {}
secondaryHandler(UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then
		return
	end

	if iData.value10.MOVE_KEYS[input.KeyCode] then
		iData.value11.held[input.KeyCode] = true
	end
end))
secondaryHandler(UserInputService.InputEnded:Connect(function(input)
	if iData.value10.MOVE_KEYS[input.KeyCode] then
		iData.value11.held[input.KeyCode] = nil
	end
end))
secondaryHandler(unpackValues({
	UserInputService.JumpRequest:Connect(function()
		if not iData.value14.HumReady or iData.value11.travelling then
			return
		end

		local flag = iData.value22()

		if flag and flag.Health > 0 then
			pcall(function()
				flag:ChangeState(Enum.HumanoidStateType.Jumping)
			end)
		end
	end),
}))
iData.value89 = nil
function iData.value89()
	local CurrentCamera = iData.value7.CurrentCamera
	if not CurrentCamera then
		return Vector3.zero
	end
	local zero = Vector3.zero
	for key, item in pairs(iData.value10.MOVE_KEYS) do
		if iData.value11.held[key] then
			zero += item
		end
	end
	if zero.Magnitude < 0.01 then
		return Vector3.zero
	end
	local CurrentCameraCFrame = CurrentCamera.CFrame
	local difference = CurrentCameraCFrame.RightVector * zero.X - CurrentCameraCFrame.LookVector * zero.Z

	return Vector3.new(difference.X, 0, difference.Z)
end
handler(function()
	while iData.value17() do
		iData.value3.Heartbeat:Wait()

		if iData.value14.HumReady and (not iData.value11.travelling and not iData.value14.AutoTreadmill) then
			local flag = iData.value22()

			if flag and flag.Health > 0 then
				local vector = iData.value89()

				if vector.Magnitude > 0.01 then
					flag:Move(vector.Unit, false)
				end
			end
		end
	end
end)
secondaryHandler(iData.value9.CharacterAdded:Connect(function(character)
	iData.value14.HumReady = false
	iData.value11.carryingUid = nil
	iData.value11.travelToken = iData.value11.travelToken + 1
	iData.value11.travelling = false
	pcall(function()
		character:WaitForChild("HumanoidRootPart", 10)
	end)
	task.wait(0.7)

	if iData.value14.AutoSteal then
		if iData.value14.AntiCheat and (not iData.value14.HumReady and iData.value23()) then
			createAutoStealHumanoid()

			return
		end

		local _ = iData.value14.HumReady
	end
end))
iData.value11.hatchCursor = 0
local function hatchAll(updateHatchCursorCondition)
	if updateHatchCursorCondition then
		local updateHatchCursorFlag = isUpdateHatchCursorInputValid()

		if not updateHatchCursorFlag then
		elseif not isUpdateHatchCursorValid(updateHatchCursorFlag.Position, 20) then
			updateGoToTreadmill(updateHatchCursorFlag.Position, 12)
		end
	end

	local updateHatchCursorData = iData.value76()
	local updateHatchCursorNumber = #updateHatchCursorData

	if updateHatchCursorNumber == 0 then
		iData.value11.hatchCursor = 0
	else
		if updateHatchCursorNumber <= iData.value11.hatchCursor then
			iData.value11.hatchCursor = 0
		end

		local hatchCursorNumber = updateHatchCursorCondition and updateHatchCursorNumber
			or math.min(updateHatchCursorNumber, 12)
		local updateHatchCursorFlag = false
		local flagNumber = 0

		while true do
			flagNumber += 1

			if
				(not updateHatchCursorFlag or not (hatchCursorNumber <= flagNumber))
				and (updateHatchCursorFlag or not (flagNumber <= hatchCursorNumber))
			then
				break
			end

			local conditionFlag =
				updateHatchCursorData[(iData.value11.hatchCursor + flagNumber - 1) % updateHatchCursorNumber + 1]
			local updateHatchCursorCondition = conditionFlag and conditionFlag.Uid

			if updateHatchCursorCondition then
				iData.value33(iData.value25.SkipGrowth, updateHatchCursorCondition)
				iData.value33(iData.value25.Hatch, updateHatchCursorCondition)
				iData.value33(iData.value25.HatchFinish, updateHatchCursorCondition)
				task.wait(0.06)
			end
		end

		iData.value11.hatchCursor = (iData.value11.hatchCursor + hatchCursorNumber) % updateHatchCursorNumber
	end

	local number = 0

	if updateHatchCursorNumber > 0 then
		local secondaryUpdateHatchCursorNumber = #iData.value76()

		if secondaryUpdateHatchCursorNumber < updateHatchCursorNumber then
			number = updateHatchCursorNumber - secondaryUpdateHatchCursorNumber
		end
	end

	if number == 0 then
		for _, item in
			ipairs(iData.value32(iData.value72(), {
				"hatch",
				"open",
			}))
		do
			if iData.value31(item) and iData.value30(item) then
				number += 1
				task.wait(0.08)
			end
		end
	end

	return number
end
iData.value11.hatchAll = hatchAll
handler(function()
	while iData.value17() do
		if
			iData.value14.AutoHatch
			or iData.value14.HatchOnce and (iData.value23() and not iData.value11.travelling)
		then
			iData.value14.HatchOnce = false
			pcall(hatchAll, false)
		end

		task.wait(2)
	end
end)

local rarityColorResult = iData.value13
local common = Color3.fromRGB(190, 190, 190)
local uncommon = Color3.fromRGB(120, 220, 120)
local rare = Color3.fromRGB(90, 160, 255)
local epic = Color3.fromRGB(180, 110, 255)
local legendary = Color3.fromRGB(255, 200, 70)
local mythic = Color3.fromRGB(255, 110, 190)
local cosmic = Color3.fromRGB(130, 240, 255)
local secret = Color3.fromRGB(60, 60, 70)
local divine = Color3.fromRGB(255, 250, 200)
local eternal = Color3.fromRGB(255, 90, 90)

rarityColorResult.rarityColor = {
	Common = common,
	Uncommon = uncommon,
	Rare = rare,
	Epic = epic,
	Legendary = legendary,
	Mythic = mythic,
	Cosmic = cosmic,
	Secret = secret,
	Divine = divine,
	Eternal = eternal,
}
iData.value11.espFolder = nil
iData.value11.espTags = {}
iData.value90 = nil
function iData.value90()
	if iData.value11.espFolder and iData.value11.espFolder.Parent then
		return iData.value11.espFolder
	end

	iData.value11.espFolder = Instance.new("Folder")
	iData.value11.espFolder.Name = "ShardEggESP"
	iData.value11.espFolder.Parent = gethui and gethui() or game:GetService("CoreGui")

	return iData.value11.espFolder
end
function iData.value91()
	for key, item in pairs(iData.value11.espTags) do
		local capturedItem = item

		pcall(function()
			capturedItem:Destroy()
		end)
		iData.value11.espTags[key] = nil
	end
	if iData.value11.espFolder then
		pcall(function()
			iData.value11.espFolder:Destroy()
		end)
		iData.value11.espFolder = nil
	end
end
function iData.value92(uidArgument)
	local adornee = iData.value46(uidArgument.uid)
	local secondaryAdornee = iData.value47(uidArgument.uid)

	if not adornee or not secondaryAdornee then
		return nil
	end

	local fillColor = iData.value13.rarityColor[uidArgument.rarity] or Color3.fromRGB(255, 255, 255)
	local Folder = Instance.new("Folder")

	Folder.Name = uidArgument.uid

	local Highlight = Instance.new("Highlight")

	Highlight.Adornee = adornee
	Highlight.FillColor = fillColor
	Highlight.OutlineColor = uidArgument.mutated and Color3.fromRGB(255, 150, 60) or fillColor
	Highlight.FillTransparency = 0.62
	Highlight.OutlineTransparency = 0
	Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	Highlight.Parent = Folder

	local BillboardGui = Instance.new("BillboardGui")

	BillboardGui.Adornee = secondaryAdornee
	BillboardGui.Size = UDim2.fromOffset(190, 26)
	BillboardGui.StudsOffsetWorldSpace = Vector3.new(0, 3.2, 0)
	BillboardGui.AlwaysOnTop = true
	BillboardGui.MaxDistance = 100000
	BillboardGui.Parent = Folder

	local TextLabel = Instance.new("TextLabel")

	TextLabel.Size = UDim2.fromScale(1, 1)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Font = Enum.Font.GothamBold
	TextLabel.TextSize = 13
	TextLabel.TextColor3 = fillColor
	TextLabel.TextStrokeTransparency = 0.35
	TextLabel.Text = (uidArgument.rarity or (uidArgument.label or "Egg")) .. (not uidArgument.mutated and "" or "  MUT")
	TextLabel.Parent = BillboardGui
	Folder.Parent = iData.value90()

	return Folder
end
handler(function()
	while iData.value17() do
		if iData.value14.EggESP then
			pcall(function()
				local data = iData.value49(false)
				local uidData = {}
				for index, item in ipairs(data) do
					uidData[item.uid] = true

					local uid = iData.value11.espTags[item.uid]

					if not uid or (not uid.Parent or not iData.value46(item.uid)) then
						if uid then
							pcall(function()
								uid:Destroy()
							end)
						end

						iData.value11.espTags[item.uid] = iData.value92(item)
					end
				end
				for k, item in pairs(iData.value11.espTags) do
					local capturedV = item
					local secondaryK = k

					if not uidData[secondaryK] then
						pcall(function()
							capturedV:Destroy()
						end)
						iData.value11.espTags[secondaryK] = nil
					end
				end
			end)
		elseif next(iData.value11.espTags) then
			iData.value91()
		end

		task.wait(1.2)
	end
end)
iData.value11.Lighting = game:GetService("Lighting")
iData.value11.fpsSaved = nil
iData.value11.hiddenParts = {}
iData.value11.hiddenGuis = {}
iData.value11.killedFx = {}
function iData.value93(argument)
	for _, player in ipairs(iData.value2:GetPlayers()) do
		local Character = player.Character

		if Character and argument == Character or argument:IsDescendantOf(Character) then
			return true
		end
	end

	return false
end
local function additionalHandler(parent)
	for _ = 1, 8 do
		if not parent or parent == iData.value7 then
			return false
		end

		local lower = parent.Name:lower()

		if lower:find("pet") or lower:find("pen") then
			return true
		end

		parent = parent.Parent
	end

	return false
end
function iData.value94()
	local data = {}

	for _, child in ipairs(iData.value7:GetChildren()) do
		local lower = child.Name:lower()

		if lower:find("pet") or lower:find("pen") then
			data[#data + 1] = child
		end
	end

	local Plots = iData.value7:FindFirstChild("Plots")

	if Plots then
		data[#data + 1] = Plots
	end

	return data
end
function iData.value95(localValueTransparencyModifierArgument)
	if iData.value11.hiddenParts[localValueTransparencyModifierArgument] ~= nil then
		return
	end

	iData.value11.hiddenParts[localValueTransparencyModifierArgument] =
		localValueTransparencyModifierArgument.LocalTransparencyModifier
	pcall(function()
		localValueTransparencyModifierArgument.LocalTransparencyModifier = 1
	end)
end
function iData.value96(enabledArgument)
	if iData.value11.hiddenGuis[enabledArgument] ~= nil then
		return
	end

	iData.value11.hiddenGuis[enabledArgument] = enabledArgument.Enabled
	pcall(function()
		enabledArgument.Enabled = false
	end)
end
iData.value97 = nil
function iData.value97(enabledArgument)
	if iData.value11.killedFx[enabledArgument] ~= nil then
		return
	end

	local condition = enabledArgument:IsA("ParticleEmitter")

	if not condition then
		condition = enabledArgument:IsA("Trail")

		if not condition then
			condition = enabledArgument:IsA("Beam")

			if not condition then
				condition = enabledArgument:IsA("Smoke")

				if not condition then
					condition = enabledArgument:IsA("Fire")
						or (enabledArgument:IsA("Sparkles") or enabledArgument:IsA("PostEffect"))
				end
			end
		end
	end

	if condition then
		iData.value11.killedFx[enabledArgument] = enabledArgument.Enabled
		pcall(function()
			enabledArgument.Enabled = false
		end)
	end
end
function iData.value98(data)
	for i = 1, #data do
		local parent = data[i]

		iData.value97(parent)

		if not iData.value93(parent) and additionalHandler(parent) then
			if parent:IsA("BasePart") then
				iData.value95(parent)
			elseif parent:IsA("BillboardGui") then
				iData.value96(parent)
			end
		end
	end
end
function iData.value99()
	local Terrain = iData.value7:FindFirstChildWhichIsA("Terrain")

	if not iData.value11.fpsSaved then
		local fpsSavedResult = iData.value11
		local GlobalShadows = iData.value11.Lighting.GlobalShadows
		local EnvironmentDiffuseScale = iData.value11.Lighting.EnvironmentDiffuseScale
		local EnvironmentSpecularScale = iData.value11.Lighting.EnvironmentSpecularScale
		local FogEnd = iData.value11.Lighting.FogEnd

		fpsSavedResult.fpsSaved = {
			shadows = GlobalShadows,
			diffuse = EnvironmentDiffuseScale,
			specular = EnvironmentSpecularScale,
			fogEnd = FogEnd,
			terrain = Terrain,
		}
		pcall(function()
			iData.value11.fpsSaved.quality = settings().Rendering.QualityLevel
		end)

		if Terrain then
			iData.value11.fpsSaved.waveSize = Terrain.WaterWaveSize
			iData.value11.fpsSaved.waveSpeed = Terrain.WaterWaveSpeed
			iData.value11.fpsSaved.reflect = Terrain.WaterReflectance
		end
	end

	pcall(function()
		settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
	end)
	pcall(function()
		iData.value11.Lighting.GlobalShadows = false
	end)
	pcall(function()
		iData.value11.Lighting.EnvironmentDiffuseScale = 0
	end)
	pcall(function()
		iData.value11.Lighting.EnvironmentSpecularScale = 0
	end)
	pcall(function()
		iData.value11.Lighting.FogEnd = 100000
	end)

	if Terrain then
		pcall(function()
			Terrain.WaterWaveSize = 0
			Terrain.WaterWaveSpeed = 0
			Terrain.WaterReflectance = 0
		end)
	end

	for _, child in ipairs(iData.value11.Lighting:GetChildren()) do
		iData.value97(child)
	end

	iData.value98(iData.value7:GetDescendants())
end
function iData.value100()
	for key, item in pairs(iData.value11.hiddenParts) do
		local capturedKey = key
		local localValueTransparencyModifier = item

		pcall(function()
			capturedKey.LocalTransparencyModifier = localValueTransparencyModifier
		end)
		iData.value11.hiddenParts[capturedKey] = nil
	end
	for k, item in pairs(iData.value11.hiddenGuis) do
		local capturedV = item

		pcall(function()
			k.Enabled = capturedV
		end)
		iData.value11.hiddenGuis[k] = nil
	end
	for key, item in pairs(iData.value11.killedFx) do
		local capturedKey = key
		local enabled = item

		pcall(function()
			capturedKey.Enabled = enabled
		end)
		iData.value11.killedFx[capturedKey] = nil
	end
	if not iData.value11.fpsSaved then
		return
	end
	pcall(function()
		iData.value11.Lighting.GlobalShadows = iData.value11.fpsSaved.shadows
	end)
	pcall(function()
		iData.value11.Lighting.EnvironmentDiffuseScale = iData.value11.fpsSaved.diffuse
	end)
	pcall(function()
		iData.value11.Lighting.EnvironmentSpecularScale = iData.value11.fpsSaved.specular
	end)
	pcall(function()
		iData.value11.Lighting.FogEnd = iData.value11.fpsSaved.fogEnd
	end)
	if iData.value11.fpsSaved.quality then
		pcall(function()
			settings().Rendering.QualityLevel = iData.value11.fpsSaved.quality
		end)
	end
	local terrain = iData.value11.fpsSaved.terrain
	if terrain and iData.value11.fpsSaved.waveSize then
		pcall(function()
			terrain.WaterWaveSize = iData.value11.fpsSaved.waveSize
			terrain.WaterWaveSpeed = iData.value11.fpsSaved.waveSpeed
			terrain.WaterReflectance = iData.value11.fpsSaved.reflect
		end)
	end
	iData.value11.fpsSaved = nil
end
handler(function()
	while iData.value17() do
		task.wait(3)

		if iData.value14.FpsBoost then
			pcall(function()
				for _, item in ipairs(iData.value94()) do
					local GetDescendants = item.GetDescendants

					iData.value98(GetDescendants(item))
				end
			end)
		end
	end
end)
iData.value101 = nil
function iData.value101()
	local secondaryInput = handleInput()

	if not secondaryInput then
		return false
	end

	if isUpdateHatchCursorValid(secondaryInput.Position, 14) then
		return true
	end

	return updateGoToTreadmill(secondaryInput.Position, 8)
end
function iData.value102(condition)
	if condition then
		iData.value101()
	end

	local flag = iData.value71("SellAll")

	if not (not flag or not iData.value31(flag)) then
		iData.value30(flag)
	end

	iData.value27(iData.value25.SellEveryPet)
	iData.value27(iData.value25.SatchelSale)

	return "Sold every pet"
end
handler(function()
	while iData.value17() do
		if iData.value14.AutoEquipBest and iData.value23() then
			iData.value27(iData.value25.WearBest)
		end

		task.wait(6)
	end
end)
iData.value103 = nil
function iData.value103(condition)
	if condition then
		local secondaryInput = isUpdateHatchCursorInputValid()

		if not secondaryInput then
		elseif not isUpdateHatchCursorValid(secondaryInput.Position, 20) then
			updateGoToTreadmill(secondaryInput.Position, 12)
		end
	end

	local number = 0

	for _, item in
		ipairs(iData.value32(iData.value72(), {
			"claim",
			"collect",
			"coin",
			"cash",
		}))
	do
		if iData.value31(item) and iData.value30(item) then
			number += 1
			task.wait(0.06)
		end
	end

	if iData.value27(iData.value25.Collect) then
		number += 1
	end

	if iData.value27(iData.value25.CodexAll) then
		number += 1
	end

	return number
end
function iData.value104(condition)
	if condition then
		local secondaryInput = isUpdateHatchCursorInputValid()

		if not secondaryInput then
		elseif not isUpdateHatchCursorValid(secondaryInput.Position, 20) then
			updateGoToTreadmill(secondaryInput.Position, 12)
		end
	end

	local number = 0

	for _, item in
		ipairs(iData.value32(iData.value72(), {
			"upgrade",
			"buy",
			"purchase",
			"tier",
			"level",
		}))
	do
		if iData.value31(item) and iData.value30(item) then
			number += 1
			task.wait(0.06)
		end
	end

	if iData.value27(iData.value25.BaseTierRaise) then
		number += 1
	end

	if iData.value27(iData.value25.NearbyBuy) then
		number += 1
	end

	return number
end
handler(function()
	while iData.value17() do
		if iData.value14.AutoClaim and (iData.value23() and not iData.value11.travelling) then
			pcall(iData.value103, false)
		end

		task.wait((math.clamp(iData.value14.ClaimInterval, 5, 300)))
	end
end)
handler(function()
	while iData.value17() do
		if iData.value14.AutoUpgrade and (iData.value23() and not iData.value11.travelling) then
			pcall(iData.value104, false)
		end

		task.wait((math.clamp(iData.value14.UpgradeInterval, 5, 300)))
	end
end)
iData.value10.TREAD_AVOID = {
	"upgrade",
	"tier",
	"level",
	"board",
	"sign",
	"billboard",
	"gui",
	"shop",
	"buy",
	"display",
	"screen",
	"label",
	"text",
	"icon",
	"price",
	"cost",
	"info",
	"menu",
}
function iData.value105(argument)
	local lower = argument:lower()

	for i = 1, #iData.value10.TREAD_AVOID do
		if lower:find(iData.value10.TREAD_AVOID[i], 1, true) then
			return true
		end
	end

	return false
end
function iData.value106(instance, data)
	if not instance then
		return data
	end

	if
		instance:IsA("Model")
		or instance:IsA("BasePart")
			and (instance.Name:lower():find("treadmill", 1, true) and not iData.value105(instance.Name))
	then
		data[#data + 1] = instance
	end

	for _, descendant in ipairs(instance:GetDescendants()) do
		if
			descendant:IsA("Model")
			or descendant:IsA("BasePart")
				and (descendant.Name:lower():find("treadmill", 1, true) and not iData.value105(descendant.Name))
		then
			data[#data + 1] = descendant
		end
	end

	return data
end
function iData.value107(secondaryInput)
	if secondaryInput:IsA("BasePart") then
		return secondaryInput.Position
	end

	local success, positionResult = pcall(function()
		return secondaryInput:GetPivot()
	end)

	return success and (not not positionResult and positionResult.Position) or nil
end
iData.value11.treadCache = nil
local function updateTreadCache()
	if iData.value11.treadCache and iData.value11.treadCache.Parent then
		return iData.value11.treadCache
	end
	local updateTreadCacheData = {}
	iData.value106(iData.value72(), updateTreadCacheData)
	if #updateTreadCacheData == 0 then
		iData.value106(iData.value7:FindFirstChild("Treadmills"), updateTreadCacheData)
	end
	if #updateTreadCacheData == 0 then
		iData.value106(iData.value7:FindFirstChild("Stands"), updateTreadCacheData)
	end
	if #updateTreadCacheData == 0 then
		for _, child in ipairs(iData.value7:GetChildren()) do
			if child.Name:lower():find("tread", 1, true) then
				iData.value106(child, updateTreadCacheData)
			end
		end
	end
	if #updateTreadCacheData == 0 then
		return nil
	end
	local updateTreadCacheFlag = iData.value72()
	local position
	if not updateTreadCacheFlag then
		position = nil
	else
		local success, updateTreadCacheResult = pcall(function()
			return updateTreadCacheFlag:GetPivot()
		end)

		position = success and updateTreadCacheResult or nil
	end
	local secondaryInput = iData.value21()
	if position then
		position = position.Position
	end
	local updateTreadCacheNumber = position or secondaryInput and secondaryInput.Position
	local number
	local treadCache
	for i = 1, #updateTreadCacheData do
		local secondaryI = i
		local optionNumber = iData.value107(updateTreadCacheData[secondaryI])

		if optionNumber then
			local updateTreadCacheOption = updateTreadCacheNumber and (optionNumber - updateTreadCacheNumber).Magnitude
			local updateTreadCacheResult = updateTreadCacheData[secondaryI]
			local differenceNumber = updateTreadCacheOption or 0
			local difference = (not updateTreadCacheResult:IsA("Model") and 0 or 40) - differenceNumber

			if not number or number < difference then
				number = difference
				treadCache = updateTreadCacheData[secondaryI]
			end
		end
	end
	iData.value11.treadCache = treadCache

	return iData.value11.treadCache
end
local function handleCondition()
	local getDescendantsFlag = updateTreadCache()

	if not getDescendantsFlag then
		return nil
	end

	if getDescendantsFlag:IsA("Seat") or getDescendantsFlag:IsA("VehicleSeat") then
		return getDescendantsFlag
	end

	if getDescendantsFlag:IsA("BasePart") then
		return nil
	end

	local GetDescendants = getDescendantsFlag.GetDescendants

	for _, item in ipairs(GetDescendants(getDescendantsFlag)) do
		if item:IsA("Seat") or item:IsA("VehicleSeat") then
			return item
		end
	end

	return nil
end
iData.value10.BELT_HINTS = {
	"belt",
	"tread",
	"walk",
	"run",
	"platform",
	"floor",
	"deck",
	"pad",
}
iData.value108 = nil
function iData.value108()
	local getDescendantsFlag = updateTreadCache()
	if not getDescendantsFlag then
		return nil
	end
	if getDescendantsFlag:IsA("BasePart") then
		return getDescendantsFlag
	end
	local GetDescendants = getDescendantsFlag.GetDescendants
	local number
	local item
	for _, secondaryItem in ipairs(GetDescendants(getDescendantsFlag)) do
		if secondaryItem:IsA("BasePart") and not iData.value105(secondaryItem.Name) then
			local lower = secondaryItem.Name:lower()
			local sumNumber = 0

			for i = 1, #iData.value10.BELT_HINTS do
				if lower:find(iData.value10.BELT_HINTS[i], 1, true) then
					sumNumber = 100000

					break
				end
			end

			local sum = sumNumber + secondaryItem.Size.X * secondaryItem.Size.Z

			if not number or number < sum then
				number = sum
				item = secondaryItem
			end
		end
	end

	return item or getDescendantsFlag.PrimaryPart
end
function iData.value109()
	local condition = handleCondition()

	if condition then
		return condition.CFrame
	end

	local instance = iData.value108()

	return instance and instance.CFrame or nil
end
function iData.value110(flag)
	local value22Result = iData.value22()
	local instance = iData.value21()
	local capturedValue22Result = value22Result

	if not flag or (not capturedValue22Result or not instance) then
		return false
	end

	if capturedValue22Result.Sit then
		return true
	end

	for _, item in
		ipairs(iData.value32(updateTreadCache(), {
			"sit",
			"ride",
			"use",
			"start",
		}))
	do
		if not (iData.value31(item) and iData.value30(item)) then
			continue
		end

		task.wait(0.2)

		if capturedValue22Result.Sit then
			return true
		end
	end

	pcall(function()
		flag:Sit(capturedValue22Result)
	end)

	local cFrame = flag.CFrame * CFrame.new(0, 1.4, 0)

	for _ = 1, 24 do
		if capturedValue22Result.Sit then
			return true
		end

		pcall(function()
			instance.CFrame = cFrame
		end)
		iData.value3.Heartbeat:Wait()
	end

	return capturedValue22Result.Sit == true
end
iData.value111 = nil
function iData.value111()
	local number = 0

	if iData.value27(iData.value25.TreadRaise) then
		number += 1
	end

	local secondaryResult = updateTreadCache()

	for _, item in
		ipairs(iData.value32(secondaryResult, {
			"upgrade",
			"level",
			"tier",
			"buy",
		}))
	do
		if iData.value31(item) and iData.value30(item) then
			number += 1
			task.wait(0.06)
		end
	end

	return number
end
handler(function()
	local number = 0

	while iData.value17() do
		iData.value3.Heartbeat:Wait()

		if iData.value14.AutoTreadmill and (iData.value23() and not iData.value11.travelling) then
			local condition = handleCondition()
			local positionCondition = iData.value109()
			local secondaryInput = iData.value21()
			local option = positionCondition
			local conditionFlag = iData.value22()

			if positionCondition then
				option = secondaryInput and conditionFlag
			end

			if option then
				if
					Vector3.new(
							positionCondition.Position.X - secondaryInput.Position.X,
							0,
							positionCondition.Position.Z - secondaryInput.Position.Z
						).Magnitude
						> 12
					and not conditionFlag.Sit
				then
					updateGoToTreadmill(positionCondition.Position, 6, function()
						return iData.value17() and iData.value14.AutoTreadmill
					end)
				elseif condition then
					if not conditionFlag.Sit then
						iData.value110(condition)
					end

					if iData.value14.AutoUpgradeTreadmill and tick() - number > 4 then
						number = tick()
						pcall(iData.value111)
					end
				else
					local LookVector = positionCondition.LookVector

					if (secondaryInput.Position - positionCondition.Position):Dot(LookVector) > 6 then
						LookVector = -LookVector
					end

					pcall(function()
						conditionFlag.WalkSpeed = math.max(conditionFlag.WalkSpeed, 60)
					end)
					conditionFlag:Move(Vector3.new(LookVector.X, 0, LookVector.Z).Unit, false)

					if iData.value14.AutoUpgradeTreadmill and tick() - number > 4 then
						number = tick()
						pcall(iData.value111)
					end
				end
			end
		end
	end
end)
iData.value11.rawRequest = syn and syn.request or (http and http.request or (http_request or request))

function iData.value112(url)
	if type(iData.value11.rawRequest) == "function" then
		local success, bodyResult = pcall(iData.value11.rawRequest, {
			Url = url,
			Method = "GET",
		})

		if success then
			success = type(bodyResult) == "table" and type(bodyResult.Body) == "string"
		end

		if success then
			return bodyResult.Body
		end
	end

	local success, successResult = pcall(function()
		return game:HttpGet(url)
	end)

	if success then
		success = type(successResult) == "string"
	end

	if success then
		return successResult
	end

	return nil
end
iData.value10.HOP_FILE = "ShardHopCount.txt"
function iData.value113(shardHops)
	if writefile then
		pcall(writefile, iData.value10.HOP_FILE, (tostring(shardHops)))
	end

	if getgenv then
		getgenv().__shardHops = shardHops
	end
end
iData.value14.HopCount = (function()
	if isfile and (readfile and isfile(iData.value10.HOP_FILE)) then
		local success, result = pcall(readfile, iData.value10.HOP_FILE)
		if success then
			return tonumber(result) or 0
		end
	end

	return tonumber(getgenv and getgenv().__shardHops) or 0
end)()
iData.value11.visited = {}
iData.value11.hopping = false
function iData.value114()
	local games = "https://games.roblox.com/v1/games/"
		.. game.PlaceId
		.. "/servers/Public?sortOrder=Desc&excludeFullGames=true&limit=100"
	local flag = iData.value112(games)

	if not flag then
		return {}
	end

	local success, dataResult = pcall(function()
		return iData.value8:JSONDecode(flag)
	end)
	local condition = not success

	if not condition then
		condition = type(dataResult) ~= "table" or type(dataResult.data) ~= "table"
	end

	if condition then
		return {}
	end

	local data = {}

	for _, item in ipairs(dataResult.data) do
		local id = item.id

		if id then
			id = item.id ~= game.JobId
				and (not iData.value11.visited[item.id] and (item.playing or 0) < (item.maxPlayers or 30))
		end

		if id then
			data[#data + 1] = item.id
		end
	end

	for i = #data, 2, -1 do
		local randomResult = math.random(i)
		local secondaryI = data[randomResult]
		local alternateI = data[i]

		data[i] = secondaryI
		data[randomResult] = alternateI
	end

	return data
end
function iData.value115()
	if iData.value11.hopping then
		return false
	end

	iData.value11.hopping = true

	local data = iData.value114()

	for _, item in ipairs(data) do
		local capturedV = item

		iData.value11.visited[capturedV] = true
		iData.value14.HopCount = iData.value14.HopCount + 1
		iData.value113(iData.value14.HopCount)

		if pcall(function()
			iData.value5:TeleportToPlaceInstance(game.PlaceId, capturedV, iData.value9)
		end) then
			task.wait(6)
			iData.value11.hopping = false

			return true
		end
	end

	pcall(function()
		iData.value5:Teleport(game.PlaceId, iData.value9)
	end)
	iData.value11.hopping = false

	return #data > 0
end
handler(function()
	while iData.value17() do
		if iData.value14.AutoHop then
			if iData.value14.HopCount >= iData.value14.MaxHops then
				iData.value14.AutoHop = false
				iData.value43("AutoHop", false)
				iData.value18("Server Hop", "Hop limit reached.")
			else
				pcall(iData.value115)
			end
		end

		task.wait((math.clamp(iData.value14.HopDelay, 5, 300)))
	end
end)

function iData.value116()
	local RespawnLocation = iData.value9.RespawnLocation

	if RespawnLocation and RespawnLocation:IsA("BasePart") then
		return RespawnLocation.CFrame.Position + Vector3.new(0, 4, 0)
	end

	for _, descendant in ipairs(iData.value7:GetDescendants()) do
		if descendant:IsA("SpawnLocation") then
			return descendant.Position + Vector3.new(0, 4, 0)
		end
	end

	local flag = iData.value72()
	local secondaryInput

	if not flag then
		secondaryInput = nil
	else
		local success, inputResult = pcall(function()
			return flag:GetPivot()
		end)

		secondaryInput = success and inputResult or nil
	end

	return secondaryInput and secondaryInput.Position or nil
end
function iData.value117()
	iData.value14.Unloaded = true
	iData.value14.AutoSteal = false
	iData.value14.AutoHop = false
	iData.value14.AutoHatch = false
	iData.value14.EggESP = false
	iData.value14.AutoEquipBest = false
	iData.value14.AutoClaim = false
	iData.value14.AutoUpgrade = false
	iData.value14.AutoTreadmill = false
	iData.value14.AutoUpgradeTreadmill = false
	iData.value14.FpsBoost = false
	iData.value11.travelToken = iData.value11.travelToken + 1
	iData.value11.travelling = false
	iData.value100()
	iData.value91()
	if stealGui then
		pcall(function()
			stealGui:Destroy()
		end)
		stealGui = nil
		updateBtn = nil
	end
	for index, item in ipairs(iData.value16) do
		local capturedItem = item

		pcall(function()
			capturedItem:Disconnect()
		end)
	end
	for _, item in ipairs(iData.value15) do
		pcall(task.cancel, item)
	end
	iData.value51()
end
function iData.value118(secondaryData)
	local data = {}

	if type(secondaryData) == "table" then
		for k, item in pairs(secondaryData) do
			if item == true then
				data[#data + 1] = k
			elseif type(item) == "string" then
				data[#data + 1] = item
			end
		end

		return data
	end

	if type(secondaryData) == "string" then
		data[1] = secondaryData
	end

	return data
end
iData.value10.filterValues = {}
for _, secondaryFilterValues in ipairs(iData.value10.Rarities) do
	iData.value10.filterValues[#iData.value10.filterValues + 1] = secondaryFilterValues
end
local windowResult = iData.value12
local createWindowResult = iData.value1
local CreateWindow = createWindowResult.CreateWindow

windowResult.Window = CreateWindow(createWindowResult, {
    Title = "Vortex x Software [STEAL AN EGG]",
    Icon = "rbxassetid://80571845178865",
    IconSize = 35,
    Author = "by ISRAEL CC",
    Folder = "VortexXSoftwareStealAnEgg",
    Size = UDim2.fromOffset(580, 430),
    Resizable = false,
    HideSearchBar = true,
    Transparent = false,
    Theme = "VortexCrimsonSolid",
    SideBarWidth = 190,
    NewElements = true,
    User = { Enabled = true, Anonymous = false },
})

pcall(function()
    windowResult.Window:EditOpenButton({
        Title = "VXS",
        Icon = "rbxassetid://80571845178865",
        CornerRadius = UDim.new(1, 0),
        StrokeThickness = 2,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 0, 30)),
            ColorSequenceKeypoint.new(0.4, Color3.fromRGB(230, 0, 50)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 50, 90))
        }),
        OnlyMobile = false,
        Enabled = true,
        Draggable = true,
    })
end)

pcall(function()
    windowResult.Window:Tag({ Title = "v1.44", Icon = "github", Color = Color3.fromRGB(230, 0, 50) })
end)

pcall(function()
    windowResult.Window:SetToggleKey(Enum.KeyCode.RightAlt)
end)


local function secondaryPcall()
	for _, item in ipairs({
		"Open",
		"Maximize",
		"Unminimize",
		"Show",
	}) do
		local capturedV = item

		if pcall(function()
			iData.value12.Window[capturedV](iData.value12.Window)
		end) then
			return true
		end
	end

	return pcall(function()
		iData.value12.Window:Minimize(false)
	end)
end
secondaryHandler(UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode.RightAlt then
		secondaryPcall()
	end
end))
iData.value12.SecFarm = iData.value12.Window:Section({
	Title = "FARM",
	Opened = true,
})
iData.value12.SecPets = iData.value12.Window:Section({
	Title = "PETS",
	Opened = true,
})
iData.value12.SecUp = iData.value12.Window:Section({
	Title = "UPGRADES",
	Opened = true,
})
iData.value12.SecSet = iData.value12.Window:Section({
	Title = "SETTINGS",
	Opened = true,
})
iData.value12.TabSteal = iData.value12.SecFarm:Tab({
	Title = "Auto Steal",
	Icon = "zap",
})
iData.value12.TabStealFree = iData.value12.SecFarm:Tab({
	Title = "Auto Steal Free",
	Icon = "zap-off",
})
iData.value12.TabHop = iData.value12.SecFarm:Tab({
	Title = "Server Hop",
	Icon = "refresh-cw",
})
iData.value12.TabHatch = iData.value12.SecFarm:Tab({
	Title = "Hatch & ESP",
	Icon = "eye",
})
iData.value12.TabSell = iData.value12.SecPets:Tab({
	Title = "Equip & Sell",
	Icon = "coins",
})
iData.value12.TabVisualPet = iData.value12.SecPets:Tab({
	Title = "Visual Pets",
	Icon = "star",
})
iData.value12.TabClaim = iData.value12.SecUp:Tab({
	Title = "Claim & Upgrade",
	Icon = "arrow-up-circle",
})
iData.value12.TabTread = iData.value12.SecUp:Tab({
	Title = "Treadmill",
	Icon = "activity",
})
iData.value12.TabConfig = iData.value12.SecSet:Tab({
	Title = "Configuration",
	Icon = "settings",
})
iData.value119 = nil
iData.value119 = {
	AutoSteal = false,
	ManualBase = nil,
	SpeedChanger = false,
	SpeedValue = 60,
	HumReady = false,
	VoidUnstuck = false,
	AutoPutEggs = false,
	PutEggsDelay = 0.4,
	AreaFocus = {},
	RarityFilter = {},
}
iData.value120 = 45
iData.value121 = 0.08
iData.value122 = 8
iData.value123 = nil
iData.value124 = nil
iData.value125 = nil
iData.value126 = false
iData.value127 = nil
iData.value128 = {}
iData.value129 = {}
function iData.value130()
	local number = 0

	for _, item in ipairs(iData.value119.AreaFocus) do
		({})[iData.value13.areaByLabel[item] or item] = true
		number += 1
	end
end
function iData.value131()
	local number = 0

	for _, item in ipairs(iData.value119.RarityFilter) do
		({})[item] = true
		number += 1
	end
end
function iData.value132()
	local PlayerGui = iData.value9:FindFirstChild("PlayerGui")

	if not PlayerGui then
		return false
	end

	local flag = false

	local function handler(parent)
		while parent and parent ~= PlayerGui do
			if parent:IsA("GuiObject") and not parent.Visible then
				return false
			end

			parent = parent.Parent
		end

		return true
	end

	local secondaryFlag = false

	for _, descendant in ipairs(PlayerGui:GetDescendants()) do
		if descendant:IsA("TextButton") or descendant:IsA("TextLabel") then
			local descendantText = descendant.Text

			if descendantText:upper() == "RUN!!" and handler(descendant) then
				secondaryFlag = true
			end

			if descendantText:lower() == "drop" and handler(descendant) then
				flag = true
			end
		end

		if secondaryFlag and flag then
			return true
		end
	end

	return false
end
function iData.value133(vector, number)
	if not number then
		number = iData.value122
	end

	local secondaryInput = iData.value21()

	if
		number
		>= if secondaryInput
			then Vector3.new(vector.X - secondaryInput.Position.X, 0, vector.Z - secondaryInput.Position.Z).Magnitude
			else 0
	then
		return true
	end

	local sum = tick() + 30

	while iData.value17() and iData.value119.AutoSteal and not (sum < tick()) do
		local secondaryInput = iData.value21()
		local flag = iData.value22()
		if not secondaryInput or (not flag or flag.Health <= 0) then
			break
		end
		local alternateInput = iData.value21()
		local secondaryNumber = if alternateInput
			then Vector3.new(vector.X - alternateInput.Position.X, 0, vector.Z - alternateInput.Position.Z).Magnitude
			else 0
		if secondaryNumber <= number then
			return true
		end
		local new = Vector3.new
		local p122X = vector.X
		local Unit = new(p122X - secondaryInput.Position.X, 0, vector.Z - secondaryInput.Position.Z).Unit
		local vector310Number = math.min(iData.value120, secondaryNumber)
		local secondaryResult = Vector3.new(
			secondaryInput.Position.X + Unit.X * vector310Number,
			secondaryInput.Position.Y,
			secondaryInput.Position.Z + Unit.Z * vector310Number
		)
		pcall(function()
			secondaryInput.CFrame = CFrame.new(secondaryResult) * CFrame.Angles(0, math.atan2(-Unit.X, -Unit.Z), 0)
		end)
		task.wait(iData.value121)
	end

	local alternateInput = iData.value21()

	return (
		if alternateInput
			then Vector3.new(vector.X - alternateInput.Position.X, 0, vector.Z - alternateInput.Position.Z).Magnitude
			else 0
	) <= number + 4
end
function iData.value134()
	if iData.value119.ManualBase then
		return iData.value119.ManualBase
	end

	local flag = iData.value72()
	local secondaryInput

	if not flag then
		secondaryInput = nil
	else
		local success, inputResult = pcall(function()
			return flag:GetPivot()
		end)

		secondaryInput = success and inputResult or nil
	end

	return secondaryInput and secondaryInput.Position or nil
end
function iData.value135()
	local Character = iData.value9.Character
	local secondaryInput = Character and Character:FindFirstChild("HumanoidRootPart")

	if not secondaryInput then
		return
	end

	for _, descendant in ipairs(workspace:GetDescendants()) do
		local capturedDescendant = descendant

		if capturedDescendant:IsA("ProximityPrompt") then
			local Parent = capturedDescendant.Parent

			if Parent and Parent:IsA("BasePart") and (Parent.Position - secondaryInput.Position).Magnitude <= 50 then
				pcall(function()
					if fireproximityprompt then
						fireproximityprompt(capturedDescendant)
					end
				end)
			end
		end
	end
end
function iData.value136()
	if iData.value123 then
		iData.value123:Disconnect()
		iData.value123 = nil
	end
end
handler(function()
	while iData.value17() do
		iData.value3.Heartbeat:Wait()

		if iData.value119.SpeedChanger and iData.value119.HumReady then
			local walkSpeedFlag = iData.value22()

			if walkSpeedFlag and walkSpeedFlag.Health > 0 then
				pcall(function()
					if walkSpeedFlag.WalkSpeed ~= iData.value119.SpeedValue then
						walkSpeedFlag.WalkSpeed = iData.value119.SpeedValue
					end
				end)
			end
		end
	end
end)
handler(function()
	while iData.value17() do
		iData.value3.Heartbeat:Wait()

		if iData.value119.AutoSteal and iData.value23() and (iData.value132() and not iData.value126) then
			iData.value126 = true
			local success, result = pcall(function()
				local flag = iData.value134()

				if not flag then
					iData.value18("Auto Steal Free", "No base set! Walk to your pen and tap Set Base Here.")

					return
				end

				iData.value133(flag, iData.value122)

				for _ = 1, 2 do
					if pcall(secondaryUpdateInstanceProperties, iData.value127 or "") then
						break
					end

					task.wait(0.2)
				end

				for _, item in
					ipairs(iData.value32(iData.value72(), {
						"place",
						"drop",
						"put",
					}))
				do
					local vector = item.Parent and (item.Parent:IsA("BasePart") and item.Parent.Position)

					if isUpdateHatchCursorValid(vector, 12) and iData.value30(item) then
						task.wait(0.15)

						return
					end
				end
			end)
			if not success then
				warn("[ShardFree] " .. tostring(result))
			end
			task.delay(1.5, function()
				iData.value126 = false
			end)
		end
	end
end)
iData.value137 = nil
function iData.value137(autoSteal)
	iData.value119.AutoSteal = autoSteal

	if autoSteal then
		if not iData.value123 then
			iData.value3.Heartbeat:Connect(function()
				if iData.value119.AutoSteal then
					iData.value135()
				end
			end)
		end

		if not iData.value119.ManualBase then
			iData.value18("Auto Steal Free", "Tip: walk to your pen and tap Set Base Here first!")
		end
	else
		iData.value136()
	end

	if iData.value125 then
		iData.value125()
	end
end
function iData.value138()
	if iData.value124 and iData.value124.Parent then
		return
	end

	local ScreenGui = Instance.new("ScreenGui")

	ScreenGui.Name = "ShardStealFreeGui"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.IgnoreGuiInset = true
	ScreenGui.DisplayOrder = 999
	pcall(function()
		ScreenGui.Parent = iData.value11.hostGui
	end)

	if not ScreenGui.Parent then
		ScreenGui.Parent = iData.value9.PlayerGui
	end

	iData.value124 = ScreenGui

	local Frame = Instance.new("Frame")

	Frame.Size = UDim2.fromOffset(160, 72)
	Frame.Position = UDim2.new(0.5, -80, 0.14, 0)
	Frame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
	Frame.BorderSizePixel = 0
	Frame.Active = true
	Frame.Draggable = true
	Frame.Parent = ScreenGui
	Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)

	local UIStroke = Instance.new("UIStroke", Frame)

	UIStroke.Color = Color3.fromRGB(80, 80, 80)
	UIStroke.Thickness = 1

	local TextLabel = Instance.new("TextLabel")

	TextLabel.Size = UDim2.new(1, -20, 0, 22)
	TextLabel.Position = UDim2.new(0, 0, 0, 4)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Text = "Steal Free"
	TextLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	TextLabel.Font = Enum.Font.GothamBold
	TextLabel.TextSize = 12
	TextLabel.Parent = Frame

	local TextButton = Instance.new("TextButton")

	TextButton.Size = UDim2.fromOffset(18, 18)
	TextButton.Position = UDim2.new(1, -20, 0, 3)
	TextButton.BackgroundTransparency = 1
	TextButton.Text = "✕"
	TextButton.TextColor3 = Color3.fromRGB(160, 160, 160)
	TextButton.Font = Enum.Font.Gotham
	TextButton.TextSize = 12
	TextButton.BorderSizePixel = 0
	TextButton.Parent = Frame
	TextButton.MouseButton1Click:Connect(function()
		iData.value137(false)
		ScreenGui:Destroy()
		iData.value124 = nil
		iData.value125 = nil
	end)

	local parent = Instance.new("TextButton")

	parent.Size = UDim2.new(1, -20, 0, 30)
	parent.Position = UDim2.new(0, 10, 0, 32)
	parent.BackgroundColor3 = Color3.fromRGB(50, 180, 80)
	parent.Text = "Start"
	parent.TextColor3 = Color3.fromRGB(255, 255, 255)
	parent.Font = Enum.Font.GothamBold
	parent.TextSize = 14
	parent.BorderSizePixel = 0
	parent.Parent = Frame
	Instance.new("UICorner", parent).CornerRadius = UDim.new(0, 6)

	function iData.value125()
		local AutoSteal = iData.value119.AutoSteal

		parent.Text = not AutoSteal and "Start" or "Stop"
		parent.BackgroundColor3 = AutoSteal and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(50, 180, 80)
	end

	iData.value125()
	parent.MouseButton1Click:Connect(function()
		iData.value137(not iData.value119.AutoSteal)
	end)
end
iData.value12.TabStealFree:Section({
	Title = "Anti-Cheat Bypass",
})
iData.value12.TabStealFree:Toggle({
	Title = "Enable Anti-Cheat Bypass",
	Desc = "Replaces the Humanoid so WalkSpeed governor hits a dead object",
	Value = false,
	Callback = function(enableAntiCheatBypassCondition)
		iData.value119.HumReady = false

		if enableAntiCheatBypassCondition then
			task.spawn(function()
				local humReady = createAutoStealHumanoid()

				iData.value119.HumReady = humReady
				iData.value18("Anti-Cheat", not humReady and "Not ready." or "Bypass active.")
			end)

			return
		end

		iData.value18("Anti-Cheat", "Bypass disabled.")
	end,
})
iData.value12.TabStealFree:Toggle({
	Title = "Void Unstuck",
	Desc = "Ejects you from the treadmill when the bypass causes you to get stuck",
	Value = false,
	Callback = function(voidUnstuck)
		iData.value119.VoidUnstuck = voidUnstuck
	end,
})
iData.value12.TabStealFree:Toggle({
	Title = "Speed Changer",
	Desc = "Locks WalkSpeed every frame. Requires Bypass active.",
	Value = false,
	Callback = function(speedChanger)
		iData.value119.SpeedChanger = speedChanger

		if speedChanger and not iData.value119.HumReady then
			iData.value18("Speed", "Enable Anti-Cheat Bypass first!")

			return
		end

		if not speedChanger then
			local walkSpeedCondition = iData.value22()

			if walkSpeedCondition then
				pcall(function()
					walkSpeedCondition.WalkSpeed = 16
				end)
			end
		end
	end,
})
local TabStealFree = iData.value12.TabStealFree
local Slider = TabStealFree.Slider
local value = {
	Min = 16,
	Max = 500,
	Default = 60,
}
Slider(TabStealFree, {
	Title = "Walk Speed",
	Desc = "Requires Bypass active.",
	Step = 1,
	Value = value,
	Callback = function(walkSpeed)
		iData.value119.SpeedValue = walkSpeed

		if iData.value119.SpeedChanger then
			local walkSpeedCondition = iData.value22()

			if walkSpeedCondition then
				pcall(function()
					walkSpeedCondition.WalkSpeed = walkSpeed
				end)
			end
		end
	end,
})
iData.value12.TabStealFree:Section({
	Title = "Base Location",
})
iData.value12.TabStealFree:Button({
	Title = "Set Base Here",
	Desc = "Walk to your pen then tap this",
	Callback = function()
		local setBaseHereCondition = iData.value21()

		if setBaseHereCondition then
			iData.value119.ManualBase = setBaseHereCondition.Position
			iData.value18(
				"Base",
				string.format(
					"Pinned at (%.0f, %.0f, %.0f)",
					setBaseHereCondition.Position.X,
					setBaseHereCondition.Position.Y,
					setBaseHereCondition.Position.Z
				)
			)

			return
		end

		iData.value18("Base", "No root part found.")
	end,
})
iData.value12.TabStealFree:Button({
	Title = "Clear Base Pin",
	Callback = function()
		iData.value119.ManualBase = nil
		iData.value18("Base", "Cleared.")
	end,
})
iData.value12.TabStealFree:Section({
	Title = "Auto Steal Free",
})
iData.value12.TabStealFree:Toggle({
	Title = "Enable Auto Steal Free",
	Desc = "Detects when you grab an egg (RUN!! + Drop visible) → walk TPs to base",
	Value = false,
	Callback = function(enableAutoStealFreeCondition)
		if enableAutoStealFreeCondition then
			iData.value138()
			iData.value137(true)

			return
		end

		iData.value137(false)

		if iData.value124 then
			pcall(function()
				iData.value124:Destroy()
			end)
			iData.value124 = nil
		end
	end,
})
local tabStealFree = iData.value12.TabStealFree
local values = iData.value37()
tabStealFree:Dropdown({
	Title = "Focus Area",
	Desc = "Leave empty for all areas",
	Values = values,
	Value = {},
	Multi = true,
	AllowNone = true,
	Callback = function(focusAreaData)
		local areaFocus = {}

		if type(focusAreaData) == "table" then
			for k, item in pairs(focusAreaData) do
				if item == true then
					areaFocus[#areaFocus + 1] = k
				elseif type(item) == "string" then
					areaFocus[#areaFocus + 1] = item
				end
			end
		end

		iData.value119.AreaFocus = areaFocus
		iData.value130()
	end,
})
local secondaryTabStealFree = iData.value12.TabStealFree
local Dropdown = secondaryTabStealFree.Dropdown
local filterValues = iData.value10.filterValues
Dropdown(secondaryTabStealFree, {
	Title = "Egg Rarity Filter",
	Desc = "Leave empty for all rarities",
	Values = filterValues,
	Value = {},
	Multi = true,
	AllowNone = true,
	Callback = function(eggRarityFilterData)
		local rarityFilter = {}

		if type(eggRarityFilterData) == "table" then
			for k, item in pairs(eggRarityFilterData) do
				if item == true then
					rarityFilter[#rarityFilter + 1] = k
				elseif type(item) == "string" then
					rarityFilter[#rarityFilter + 1] = item
				end
			end
		end

		iData.value119.RarityFilter = rarityFilter
		iData.value131()
	end,
})
secondaryHandler(game:GetService("Players").PlayerRemoving:Connect(function(player)
	if player == iData.value9 then
		iData.value136()

		if iData.value124 then
			pcall(function()
				iData.value124:Destroy()
			end)
		end
	end
end))
iData.value12.TabSteal:Section({
	Title = "Auto Steal",
})
iData.value139 = nil
iData.value140 = nil
function iData.value141()
	if iData.value139 and iData.value139.Parent then
		return
	end

	local ScreenGui = Instance.new("ScreenGui")

	ScreenGui.Name = "ShardStealGui"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.IgnoreGuiInset = true
	ScreenGui.DisplayOrder = 999
	pcall(function()
		ScreenGui.Parent = iData.value11.hostGui
	end)

	if not ScreenGui.Parent then
		ScreenGui.Parent = iData.value9.PlayerGui
	end

	iData.value139 = ScreenGui

	local Frame = Instance.new("Frame")

	Frame.Size = UDim2.fromOffset(160, 72)
	Frame.Position = UDim2.new(0.5, -80, 0.05, 0)
	Frame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
	Frame.BorderSizePixel = 0
	Frame.Active = true
	Frame.Draggable = true
	Frame.Parent = ScreenGui
	Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)

	local UIStroke = Instance.new("UIStroke", Frame)

	UIStroke.Color = Color3.fromRGB(80, 80, 80)
	UIStroke.Thickness = 1

	local TextLabel = Instance.new("TextLabel")

	TextLabel.Size = UDim2.new(1, -20, 0, 22)
	TextLabel.Position = UDim2.new(0, 0, 0, 4)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Text = "Auto Steal"
	TextLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	TextLabel.Font = Enum.Font.GothamBold
	TextLabel.TextSize = 12
	TextLabel.Parent = Frame

	local TextButton = Instance.new("TextButton")

	TextButton.Size = UDim2.fromOffset(18, 18)
	TextButton.Position = UDim2.new(1, -20, 0, 3)
	TextButton.BackgroundTransparency = 1
	TextButton.Text = "✕"
	TextButton.TextColor3 = Color3.fromRGB(160, 160, 160)
	TextButton.Font = Enum.Font.Gotham
	TextButton.TextSize = 12
	TextButton.BorderSizePixel = 0
	TextButton.Parent = Frame
	TextButton.MouseButton1Click:Connect(function()
		iData.value14.AutoSteal = false
		iData.value43("AutoSteal", false)
		pcall(function()
			ScreenGui:Destroy()
		end)
		iData.value139 = nil
		iData.value140 = nil
	end)

	local parent = Instance.new("TextButton")

	parent.Size = UDim2.new(1, -20, 0, 30)
	parent.Position = UDim2.new(0, 10, 0, 32)
	parent.BackgroundColor3 = Color3.fromRGB(50, 180, 80)
	parent.Text = "Start"
	parent.TextColor3 = Color3.fromRGB(255, 255, 255)
	parent.Font = Enum.Font.GothamBold
	parent.TextSize = 14
	parent.BorderSizePixel = 0
	parent.Parent = Frame
	Instance.new("UICorner", parent).CornerRadius = UDim.new(0, 6)

	function iData.value140()
		local AutoSteal = iData.value14.AutoSteal
		local startButton = parent
		local autoSteal = AutoSteal

		if AutoSteal then
			autoSteal = "Stop"
		end

		startButton.Text = autoSteal or "Start"
		parent.BackgroundColor3 = AutoSteal and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(50, 180, 80)
	end

	iData.value140()
	parent.MouseButton1Click:Connect(function()
		local autoSteal = not iData.value14.AutoSteal

		iData.value14.AutoSteal = autoSteal
		iData.value43("AutoSteal", autoSteal)

		if autoSteal then
			iData.value14.AntiCheat = true
			task.spawn(function()
				if iData.value14.AntiCheat and (not iData.value14.HumReady and iData.value23()) then
					createAutoStealHumanoid()
				else
					local _ = iData.value14.HumReady
				end

				iData.value52()

				if iData.value14.FarmMethod == "TP Walk" then
					iData.value18(
						"Auto Steal",
						"Running the TP Walk route, "
							.. iData.value10.TP_STEP
							.. " studs every "
							.. iData.value10.TP_WAIT
							.. "s."
					)

					return
				end

				iData.value18("Auto Steal", "Running the ground route at " .. iData.value10.TRAVEL_SPEED .. " studs.")
			end)
		else
			iData.value11.travelToken = iData.value11.travelToken + 1
			iData.value11.travelling = false
			iData.value51()
			iData.value18("Auto Steal", "Stopped.")
		end

		iData.value140()
	end)
end
iData.value41.AutoSteal = iData.value12.TabSteal:Toggle({
	Title = "Enable Auto Steal",
	Desc = "Takes the rarest egg first, plants it on your base and goes straight back out",
	Value = false,
	Callback = function(autoSteal)
		iData.value14.AutoSteal = autoSteal

		if autoSteal then
			iData.value141()

			if iData.value140 then
				iData.value140()
			end

			iData.value14.AntiCheat = true
			task.spawn(function()
				if iData.value14.AntiCheat and (not iData.value14.HumReady and iData.value23()) then
					createAutoStealHumanoid()
				else
					local _ = iData.value14.HumReady
				end

				iData.value52()

				if iData.value14.FarmMethod == "TP Walk" then
					iData.value18(
						"Auto Steal",
						"Running the TP Walk route, "
							.. iData.value10.TP_STEP
							.. " studs every "
							.. iData.value10.TP_WAIT
							.. "s."
					)

					return
				end

				iData.value18("Auto Steal", "Running the ground route at " .. iData.value10.TRAVEL_SPEED .. " studs.")
			end)

			return
		end

		if iData.value140 then
			iData.value140()
		end

		if iData.value139 then
			pcall(function()
				iData.value139:Destroy()
			end)
			iData.value139 = nil
		end

		iData.value11.travelToken = iData.value11.travelToken + 1
		iData.value11.travelling = false
		iData.value51()
		iData.value18("Auto Steal", "Stopped.")
	end,
})
local TabSteal = iData.value12.TabSteal
local FarmMethod = iData.value14.FarmMethod
TabSteal:Dropdown({
	Title = "Farm Method",
	Desc = "Speed slides along the ground, TP Walk hops in place to place jumps",
	Values = {
		"Speed",
		"TP Walk",
	},
	Value = FarmMethod,
	Callback = function(farmMethodArgument)
		local farmMethod = iData.value118(farmMethodArgument)[1]

		if farmMethod == "Speed" or farmMethod == "TP Walk" then
			iData.value14.FarmMethod = farmMethod
			iData.value11.travelToken = iData.value11.travelToken + 1
			iData.value11.travelling = false
		end
	end,
})
iData.value12.TabSteal:Toggle({
	Title = "Secret Egg Priority",
	Desc = "Drops current egg and immediately targets any Secret, Divine or Eternal that spawns",
	Value = true,
	Callback = function(secretPriority)
		iData.value14.SecretPriority = secretPriority
	end,
})
iData.value41.AntiTrap = iData.value12.TabSteal:Toggle({
	Desc = "Routes around traps other players drop and breaks the hold if one closes on you",
	Value = true,
	Callback = function(antiTrap)
		iData.value14.AntiTrap = antiTrap
		task.spawn(function()
			iData.value52()

			if antiTrap then
				iData.value55()
			end
		end)
	end,
})
local areaFocusResult = iData.value41
local tabSteal = iData.value12.TabSteal
local dropdown = tabSteal.Dropdown
local secondaryValues = iData.value37()
local AreaFocus = iData.value14.AreaFocus
areaFocusResult.AreaFocus = dropdown(tabSteal, {
	Title = "Focus Area",
	Desc = "Pick as many areas as you want, leave it empty for every area",
	Values = secondaryValues,
	Value = AreaFocus,
	Multi = true,
	AllowNone = true,
	Callback = function(focusAreaArgument)
		iData.value14.AreaFocus = iData.value118(focusAreaArgument)
		iData.value40()
	end,
})
local secondaryTabSteal = iData.value12.TabSteal
local secondaryFilterValues = iData.value10.filterValues
local RarityFilter = iData.value14.RarityFilter
secondaryTabSteal:Dropdown({
	Title = "Egg Rarity Filter",
	Desc = "Pick as many rarities as you want, leave it empty for every rarity",
	Values = secondaryFilterValues,
	Value = RarityFilter,
	Multi = true,
	AllowNone = true,
	Callback = function(eggRarityFilterArgument)
		iData.value14.RarityFilter = iData.value118(eggRarityFilterArgument)
		iData.value42()
	end,
})
iData.value12.TabHop:Section({
	Title = "Server Hop",
})
iData.value41.AutoHop = iData.value12.TabHop:Toggle({
	Title = "Enable Auto Server Hop",
	Desc = "Rotates through public servers until the hop limit is spent",
	Value = false,
	Callback = function(autoHop)
		iData.value14.AutoHop = autoHop

		if autoHop then
			iData.value18("Server Hop", iData.value14.HopCount .. " of " .. iData.value14.MaxHops .. " hops used.")
		end
	end,
})
local TabHop = iData.value12.TabHop
local MaxHops = iData.value14.MaxHops
local secondaryValue = {
	Min = 1,
	Max = 100,
	Default = MaxHops,
}
TabHop:Slider({
	Title = "Max Hops",
	Desc = "Hops allowed before the toggle switches itself off",
	Step = 1,
	Value = secondaryValue,
	Callback = function(maxHops)
		iData.value14.MaxHops = maxHops
	end,
})
local tabHop = iData.value12.TabHop
local hopDelayResult = iData.value14
local slider = tabHop.Slider
local HopDelay = hopDelayResult.HopDelay
local alternateValue = {
	Min = 5,
	Max = 120,
	Default = HopDelay,
}
slider(tabHop, {
	Title = "Check Delay",
	Desc = "Seconds between hops",
	Step = 1,
	Value = alternateValue,
	Callback = function(hopDelay)
		iData.value14.HopDelay = hopDelay
	end,
})
iData.value12.TabHop:Button({
	Title = "Server Hop Now",
	Callback = function()
		task.spawn(function()
			iData.value18("Server Hop", not iData.value115() and "No open server answered." or "Teleporting.")
		end)
	end,
})
iData.value12.TabHop:Button({
	Title = "Recall to Spawn",
	Callback = function()
		task.spawn(function()
			local recallToSpawnCallback = iData.value18
			local vector = iData.value116()

			recallToSpawnCallback(
				"Recall",
				not (if vector then updateGoToTreadmill(vector, 8) else false) and "No spawn point found."
					or "Back at spawn."
			)
		end)
	end,
})
iData.value12.TabHatch:Section({
	Title = "Hatch & ESP",
})
iData.value41.AutoHatch = iData.value12.TabHatch:Toggle({
	Title = "Enable Auto Hatch",
	Desc = "Keeps your base empty so Auto Steal always has room to plant the next egg",
	Value = false,
	Callback = function(autoHatch)
		iData.value14.AutoHatch = autoHatch
	end,
})
iData.value12.TabHatch:Button({
	Title = "Hatch Once",
	Callback = function()
		task.spawn(function()
			iData.value18("Hatch", "Hatched " .. hatchAll(true) .. " eggs.")
		end)
	end,
})
iData.value41.EggESP = iData.value12.TabHatch:Toggle({
	Title = "Enable Egg ESP",
	Desc = "Outlines every field egg and labels its rarity, visible across the whole map",
	Value = false,
	Callback = function(eggEsp)
		iData.value14.EggESP = eggEsp

		if not eggEsp then
			iData.value91()
		end
	end,
})
iData.value41.FpsBoost = iData.value12.TabHatch:Toggle({
	Title = "FPS Boost",
	Desc = "Cheapest rendering settings and hides everybody's pets",
	Value = false,
	Callback = function(fpsBoost)
		iData.value14.FpsBoost = fpsBoost
		task.spawn(function()
			if fpsBoost then
				iData.value99()
				iData.value18("FPS Boost", "Effects off and pets hidden.")

				return
			end

			iData.value100()
			iData.value18("FPS Boost", "Everything restored.")
		end)
	end,
})
iData.value12.TabSell:Section({
	Title = "Equip & Sell",
})
iData.value12.TabSell:Toggle({
	Title = "Enable Auto Equip Best",
	Desc = "Keeps your strongest pets worn",
	Value = false,
	Callback = function(autoEquipBest)
		iData.value14.AutoEquipBest = autoEquipBest
	end,
})
iData.value12.TabSell:Button({
	Title = "Equip Best Now",
	Callback = function()
		iData.value18(
			"Pets",
			not iData.value27(iData.value25.WearBest) and "The server refused." or "Equipped the best pets."
		)
	end,
})
iData.value12.TabSell:Button({
	Title = "Sell Inventory Now",
	Callback = function()
		task.spawn(function()
			iData.value18("Pets", iData.value102(true))
		end)
	end,
})
iData.value12.TabClaim:Section({
	Title = "Claim & Upgrade",
})
iData.value12.TabClaim:Toggle({
	Title = "Enable Auto Claim",
	Desc = "Collects base earnings and finished quest rewards",
	Value = false,
	Callback = function(autoClaim)
		iData.value14.AutoClaim = autoClaim
	end,
})
local TabClaim = iData.value12.TabClaim
local secondarySlider = TabClaim.Slider
local ClaimInterval = iData.value14.ClaimInterval
local additionalValue = {
	Min = 5,
	Max = 300,
	Default = ClaimInterval,
}
secondarySlider(TabClaim, {
	Title = "Claim Interval",
	Desc = "Seconds between claims",
	Step = 1,
	Value = additionalValue,
	Callback = function(claimInterval)
		iData.value14.ClaimInterval = claimInterval
	end,
})
iData.value12.TabClaim:Button({
	Title = "Claim Now",
	Callback = function()
		task.spawn(function()
			iData.value18("Claim", "Fired " .. iData.value103(true) .. " claims.")
		end)
	end,
})
iData.value12.TabClaim:Toggle({
	Title = "Enable Auto Upgrade",
	Desc = "Raises the base tier and buys whatever upgrade is in reach",
	Value = false,
	Callback = function(autoUpgrade)
		iData.value14.AutoUpgrade = autoUpgrade
	end,
})
local tabClaim = iData.value12.TabClaim
local UpgradeInterval = iData.value14.UpgradeInterval
local fallbackValue = {
	Min = 5,
	Max = 300,
	Default = UpgradeInterval,
}
tabClaim:Slider({
	Title = "Upgrade Interval",
	Desc = "Seconds between upgrade attempts",
	Step = 1,
	Value = fallbackValue,
	Callback = function(upgradeInterval)
		iData.value14.UpgradeInterval = upgradeInterval
	end,
})
iData.value12.TabClaim:Button({
	Title = "Upgrade Now",
	Callback = function()
		task.spawn(function()
			iData.value18("Upgrade", "Fired " .. iData.value104(true) .. " upgrades.")
		end)
	end,
})
iData.value12.TabTread:Section({
	Title = "Treadmill",
})
iData.value12.TabTread:Toggle({
	Title = "Enable Auto Treadmill",
	Desc = "Sits on the treadmill itself, or walks the belt when it has no seat",
	Value = false,
	Callback = function(autoTreadmill)
		iData.value14.AutoTreadmill = autoTreadmill

		if autoTreadmill then
			autoTreadmill = not iData.value109()
		end

		if autoTreadmill then
			iData.value18("Treadmill", "No treadmill found on this server.")
		end
	end,
})
iData.value12.TabTread:Toggle({
	Title = "Auto-Upgrade Treadmill",
	Desc = "Raises the belt tier while you run on it",
	Value = false,
	Callback = function(autoUpgradeTreadmill)
		iData.value14.AutoUpgradeTreadmill = autoUpgradeTreadmill
	end,
})
iData.value12.TabTread:Button({
	Title = "Go to Treadmill",
	Callback = function()
		task.spawn(function()
			local goToTreadmillFlag = iData.value109()

			if not goToTreadmillFlag then
				iData.value18("Treadmill", "No treadmill found on this server.")

				return
			end

			local goToTreadmillResult = updateGoToTreadmill(goToTreadmillFlag.Position, 6)

			iData.value18("Treadmill", not goToTreadmillResult and "Could not reach it." or "Arrived.")
		end)
	end,
})
iData.value12.TabConfig:Section({
	Title = "Configuration",
})
iData.value12.TabConfig:Button({
	Title = "Show Window",
	Desc = "Also bound to Right Control",
	Callback = function()
		secondaryPcall()
	end,
})
iData.value12.TabConfig:Button({
	Title = "Drop to Void",
	Desc = "Holds five seconds in the void and waits for the respawn",
	Callback = function()
		task.spawn(function()
			if not iData.value70() then
				iData.value18("Drop to Void", "No respawn came back.", 6)
			end
		end)
	end,
})
iData.value12.TabConfig:Button({
	Title = "Copy Remote List",
	Desc = "Puts every networking endpoint this server exposes on your clipboard",
	Callback = function()
		local value28Result = iData.value28()
		local concatResult = table.concat(value28Result, "\n")

		if setclipboard then
			pcall(setclipboard, concatResult)
		end

		if writefile then
			pcall(writefile, "ShardRemotes.txt", concatResult)
		end

		iData.value18("Remotes", #value28Result .. " endpoints copied.")
	end,
})
iData.value12.TabConfig:Button({
	Title = "Copy Plot Dump",
	Desc = "Puts the live plot answer and the placement result on your clipboard",
	Callback = function()
		task.spawn(function()
			local dataCondition = iData.value72()
			local wData = handleData()
			local value77Result = iData.value77()
			local displayValue = iData.value27(iData.value25.EggLive)
			local capturedDisplayValue = displayValue
			local success, copyPlotDumpResult = pcall(function()
				return iData.value8:JSONEncode(capturedDisplayValue)
			end)
			local copyPlotDumpText = "AskLiveSnapshot: "
				.. (success and copyPlotDumpResult or tostring(capturedDisplayValue))
			local value27Result = iData.value27(iData.value25.PlotState)
			local capturedValue27Result = value27Result
			local secondarySuccess, dataResult = pcall(function()
				return iData.value8:JSONEncode(capturedValue27Result)
			end)
			local sumData = {
				copyPlotDumpText,
				"Homestead/AskState: " .. (secondarySuccess and dataResult or tostring(capturedValue27Result)),
				"records seen: " .. #iData.value76(),
				"plot: " .. (dataCondition and dataCondition:GetFullName() or "not found" .. " slot " .. tostring(
					iData.value11.cachedSlot
				)),
				"targets: " .. #wData .. "  used world " .. #value77Result.w,
				"place origin: " .. iData.value11.placeOK and iData.value11.placeOK.origin or "none",
				"place reason: " .. iData.value11.placeWhy,
				"place log: " .. (#iData.value11.placeLog > 0) and table.concat(iData.value11.placeLog, " | ")
					or "none",
				"holding: " .. tostring(iData.value78()),
				"carrying: " .. tostring(iData.value11.carryingUid),
				"method: " .. iData.value14.FarmMethod .. "  traps seen: " .. #iData.value11.trapList,
				"hub: " .. tostring(iData.value64() and iData.value64() or "not found"),
			}
			local inputData = updateData()
			local copyPlotDumpFlag
			local flag
			local secondaryCopyPlotDumpFlag
			local text
			for i = 1, #inputData do
				sumData[#sumData + 1] = "origin " .. i .. ": " .. tostring(inputData[i].Position)
			end
			local secondaryInput = iData.value21()
			if secondaryInput and inputData[1] then
				sumData[#sumData + 1] = "char: "
					.. tostring(secondaryInput.Position)
					.. "  to origin1: "
					.. string.format("%.1f", (secondaryInput.Position - inputData[1].Position).Magnitude)
			end
			if wData[1] then
				local w = wData[1].w

				sumData[#sumData + 1] = "target1 world: " .. tostring(w)

				for i = 1, #inputData do
					sumData[#sumData + 1] = "  target1 local O"
						.. i
						.. ": "
						.. tostring((inputData[i]:Inverse() * CFrame.new(w)).Position)
				end
			end
			local Character = iData.value9.Character
			local nameOption = Character and Character:FindFirstChildWhichIsA("Tool")
			repeat
				if copyPlotDumpFlag or not nameOption then
					copyPlotDumpFlag = false
					local textNumber = 0
					for index, item in ipairs(value77Result.w) do
						textNumber += 1

						if textNumber > 6 then
							break
						end

						local copyPlotDumpText = "egg" .. textNumber .. " world: " .. tostring(item)

						for i = 1, #inputData do
							copyPlotDumpText ..= "  L" .. i .. ": " .. tostring(
								(inputData[i]:Inverse() * CFrame.new(item)).Position
							)
						end

						sumData[#sumData + 1] = copyPlotDumpText
					end
					if dataCondition then
						local copyPlotDumpData = {}

						for _, child in ipairs(dataCondition:GetChildren()) do
							if child:IsA("BasePart") and #copyPlotDumpData < 14 then
								copyPlotDumpData[#copyPlotDumpData + 1] = child.Name
									.. "("
									.. string.format("%.0f", child.Size.X)
									.. "x"
									.. string.format("%.0f", child.Size.Z)
									.. ")"
							end
						end

						local success, nameResult = pcall(function()
							return dataCondition.PrimaryPart
						end)

						sumData[#sumData + 1] = "plot primary: "
							.. (success and (not not nameResult and nameResult.Name) or "none")
						sumData[#sumData + 1] = "plot parts: " .. table.concat(copyPlotDumpData, ", ")
					end
					local displayValueCondition = iData.value11.eggList[1]
					if displayValueCondition then
						local sum = #sumData + 1
						local capturedDisplayValueCondition = displayValueCondition
						local success, copyPlotDumpResult = pcall(function()
							return iData.value8:JSONEncode(capturedDisplayValueCondition)
						end)
						sumData[sum] = "field egg: "
							.. (success and copyPlotDumpResult or tostring(capturedDisplayValueCondition))
					end
					local secondaryInput = inputData[1]
					local copyPlotDumpResult
					local iterator, state, control = ipairs(iData.value7:GetChildren())
					local instance
					repeat
						control, instance = iterator(state, control)

						if not control then
							flag = true
						end

						if flag then
							break
						end
					until instance.Name == "PlacedEggRenders"
					if not flag then
						copyPlotDumpResult = instance
					end
					flag = false
					if secondaryInput and copyPlotDumpResult then
						local magnitude = 1e999
						local capturedItem
						for index, item in ipairs(copyPlotDumpResult:GetChildren()) do
							local secondaryCapturedItem = item
							local success, xResult = pcall(function()
								if secondaryCapturedItem:IsA("Model") then
									return secondaryCapturedItem:GetPivot()
								end

								if secondaryCapturedItem:IsA("BasePart") then
									return secondaryCapturedItem.CFrame
								end

								return nil
							end)

							if success and xResult then
								local Magnitude = (Vector3.new(xResult.X, 0, xResult.Z) - Vector3.new(
									secondaryInput.Position.X,
									0,
									secondaryInput.Position.Z
								)).Magnitude

								if Magnitude < magnitude then
									capturedItem = secondaryCapturedItem
									magnitude = Magnitude
								end
							end
						end
						if capturedItem then
							local productNumber = capturedItem:IsA("Model") and capturedItem:GetPivot()
								or capturedItem.CFrame
							local product = secondaryInput:Inverse() * productNumber
							local toEulerAnglesYxz, secondaryToEulerAnglesYxz, alternateToEulerAnglesYxz =
								product:ToEulerAnglesYXZ()

							sumData[#sumData + 1] = "render nearest: "
								.. capturedItem.Name
								.. " ("
								.. capturedItem.ClassName
								.. ") dist "
								.. string.format("%.1f", magnitude)
								.. "  local pos "
								.. tostring(product.Position)
								.. "  rot deg "
								.. string.format(
									"%.1f/%.1f/%.1f",
									math.deg(toEulerAnglesYxz),
									math.deg(secondaryToEulerAnglesYxz),
									(math.deg(alternateToEulerAnglesYxz))
								)

							local success, copyPlotDumpResult = pcall(function()
								return capturedItem:GetAttributes()
							end)

							if success then
								success = type(copyPlotDumpResult) == "table"
							end

							if success then
								local sum = #sumData + 1
								local capturedResult = copyPlotDumpResult
								local success, secondaryResult = pcall(function()
									return iData.value8:JSONEncode(capturedResult)
								end)
								sumData[sum] = "render attrs: "
									.. (success and secondaryResult or tostring(capturedResult))
							end

							local copyPlotDumpData = {}

							for _, descendant in ipairs(capturedItem:GetDescendants()) do
								if #copyPlotDumpData >= 12 then
									break
								end

								local copyPlotDumpText = ""

								pcall(function()
									if descendant.Value ~= nil then
										copyPlotDumpText = "=" .. tostring(descendant.Value)
									end
								end)
								copyPlotDumpData[#copyPlotDumpData + 1] = descendant.Name
									.. "("
									.. descendant.ClassName
									.. ")"
									.. copyPlotDumpText
							end

							sumData[#sumData + 1] = "render kids: " .. table.concat(copyPlotDumpData, ", ")
						end
					end
					if
						type(getgc) == "function"
						and (type(debug) == "table" and type(debug.getconstants) == "function")
					then
						local copyPlotDumpNumber = 0
						local number = 0
						local timestamp = tick()
						local capturedTimestamp = timestamp
						pcall(function()
							for _, item in ipairs(getgc(true)) do
								if copyPlotDumpNumber >= 3 then
									return
								end
								number += 1
								if number > 300000 or tick() - capturedTimestamp > 4 then
									return
								end
								if type(item) ~= "function" then
									continue
								end
								local success, copyPlotDumpResult = pcall(debug.getconstants, item)
								if success then
									success = type(copyPlotDumpResult) == "table"
								end
								if not success then
									continue
								end
								local copyPlotDumpFlag = false
								for index, item in ipairs(copyPlotDumpResult) do
									if item == "AskPlaceEgg" then
										copyPlotDumpFlag = true

										break
									end
								end
								if copyPlotDumpFlag then
									copyPlotDumpNumber += 1

									local copyPlotDumpData = {}

									for _, item in ipairs(copyPlotDumpResult) do
										if type(item) == "string" and #item < 40 then
											copyPlotDumpData[#copyPlotDumpData + 1] = item
										end
									end

									local copyPlotDumpText = "?"
									local success, sourceResult = pcall(function()
										return debug.getinfo(item)
									end)

									if success then
										success = type(sourceResult) == "table"
									end

									if success then
										copyPlotDumpText = tostring(
											sourceResult.short_src or (sourceResult.source or "?")
										) .. ":" .. tostring(
											sourceResult.linedefined or (sourceResult.currentline or "?")
										)
									end

									sumData[#sumData + 1] = "AskPlaceEgg caller "
										.. copyPlotDumpNumber
										.. " ["
										.. copyPlotDumpText
										.. "] consts: "
										.. table.concat(copyPlotDumpData, ",")
								end
							end
						end)
						if copyPlotDumpNumber == 0 then
							sumData[#sumData + 1] = "payload probe: no AskPlaceEgg caller found (scanned "
								.. number
								.. ")"
						end
					else
						sumData[#sumData + 1] = "payload probe: introspection API unavailable"
					end
					local concatResult = table.concat(sumData, "\n\n")
					if setclipboard then
						pcall(setclipboard, concatResult)
					end
					if writefile then
						pcall(writefile, "ShardPlot.txt", concatResult)
					end
					iData.value18("Plot Dump", "Copied. Also saved as ShardPlot.txt.", 6)

					return
				end

				local success, copyPlotDumpResult = pcall(function()
					return nameOption:GetAttributes()
				end)
				local sum = #sumData + 1
				local Name = nameOption.Name

				if "  attrs: " .. success then
					local capturedResult = copyPlotDumpResult
					local success, textResult = pcall(function()
						return iData.value8:JSONEncode(capturedResult)
					end)
					text = success and textResult or tostring(capturedResult)
					if text then
						secondaryCopyPlotDumpFlag = true
					end
				end

				if not secondaryCopyPlotDumpFlag then
					text = "?"
				end

				secondaryCopyPlotDumpFlag = false
				sumData[sum] = "held tool: " .. Name .. text

				local copyPlotDumpData = {}

				for _, descendant in ipairs(nameOption:GetDescendants()) do
					if #copyPlotDumpData >= 10 then
						break
					end

					local copyPlotDumpText = ""

					pcall(function()
						if descendant.Value ~= nil then
							copyPlotDumpText = "=" .. tostring(descendant.Value)
						end
					end)
					copyPlotDumpData[#copyPlotDumpData + 1] = descendant.Name
						.. "("
						.. descendant.ClassName
						.. ")"
						.. copyPlotDumpText
				end

				sumData[#sumData + 1] = "held tool kids: " .. table.concat(copyPlotDumpData, ", ")
				copyPlotDumpFlag = true
			until not copyPlotDumpFlag
		end)
	end,
})
iData.value12.TabConfig:Button({
	Title = "Copy Place Source",
	Desc = "Reads the game's own egg placement module so the exact call is known",
	Callback = function()
		task.spawn(function()
			local sumData = {}
			local copyPlaceSourceFlag = type(decompile) == "function"

			local function handleData(item)
				local copyPlaceSourceData = {}
				local success, dataResult = pcall(debug.getconstants, item)

				if success then
					success = type(dataResult) == "table"
				end

				if success then
					for _, item in ipairs(dataResult) do
						if type(item) == "string" and #item < 48 then
							copyPlaceSourceData[#copyPlaceSourceData + 1] = item
						end
					end
				end

				return copyPlaceSourceData
			end

			if copyPlaceSourceFlag then
				local copyPlaceSourceNumber = 0

				for _, descendant in ipairs(iData.value6:GetDescendants()) do
					if copyPlaceSourceNumber >= 4 then
						break
					end

					if descendant:IsA("ModuleScript") or descendant:IsA("LocalScript") then
						local lower = descendant.Name:lower()

						if lower:find("egg") or (lower:find("plac") or (lower:find("build") or lower:find("plot"))) then
							local success, copyPlaceSourceResult = pcall(decompile, descendant)

							if
								success
									and (type(copyPlaceSourceResult) == "string" and copyPlaceSourceResult:find(
										"PlantEgg",
										1,
										true
									))
								or copyPlaceSourceResult:find("AskPlaceEgg", 1, true)
							then
								copyPlaceSourceNumber += 1
								pcall(writefile, "ShardPlace_" .. descendant.Name .. ".txt", copyPlaceSourceResult)

								local sum = #sumData + 1
								local FullName = descendant:GetFullName()
								local textNumber = copyPlaceSourceResult:find("PlantEgg", 1, true)
								local copyPlaceSourceText = " ==\n"
									.. if not textNumber
										then nil
										else copyPlaceSourceResult:sub(
											math.max(1, textNumber - 1500),
											textNumber + 900
										)

								if not copyPlaceSourceText then
									local textNumber = copyPlaceSourceResult:find("AskPlaceEgg", 1, true)

									copyPlaceSourceText = (
										if not textNumber
											then nil
											else copyPlaceSourceResult:sub(
												math.max(1, textNumber - 1500),
												textNumber + 900
											)
									) or copyPlaceSourceResult:sub(1, 2200)
								end

								sumData[sum] = "== " .. FullName .. copyPlaceSourceText
							end
						end
					end
				end
			end

			if type(getgc) == "function" and (type(debug) == "table" and type(debug.getconstants) == "function") then
				local timestamp = tick()
				local copyPlaceSourceNumber = 0
				local number = 0
				local capturedTimestamp = timestamp
				pcall(function()
					local flag
					local secondaryCopyPlaceSourceFlag
					for _, item in ipairs(getgc(true)) do
						if copyPlaceSourceNumber >= 4 then
							return
						end

						number += 1

						if number > 400000 or tick() - capturedTimestamp > 5 then
							return
						end

						if type(item) == "function" then
							local copyPlaceSourceData = handleData(item)

							for _, item in ipairs(copyPlaceSourceData) do
								if item == "PlantEgg" then
									secondaryCopyPlaceSourceFlag = true
									flag = true
								end

								if flag then
									break
								end
							end

							if not flag then
								secondaryCopyPlaceSourceFlag = false
							end

							flag = false

							if secondaryCopyPlaceSourceFlag then
								copyPlaceSourceNumber += 1

								local copyPlaceSourceText = "?"
								local success, sourceResult = pcall(function()
									return debug.getinfo(item)
								end)

								if success then
									success = type(sourceResult) == "table"
								end

								if success then
									local tostringFunction = tostring
									local short_src = sourceResult.short_src

									if not short_src then
										short_src = sourceResult.source or "?"
									end

									copyPlaceSourceText = tostringFunction(short_src)
										.. ":"
										.. tostring(sourceResult.linedefined or "?")
								end

								sumData[#sumData + 1] = "PlantEgg caller "
									.. copyPlaceSourceNumber
									.. " ["
									.. copyPlaceSourceText
									.. "] consts: "
									.. table.concat(copyPlaceSourceData, ",")

								if type(debug.getprotos) == "function" then
									local success, copyPlaceSourceResult = pcall(debug.getprotos, item)

									if success then
										success = type(copyPlaceSourceResult) == "table"
									end

									if success then
										for _, item in ipairs(copyPlaceSourceResult) do
											sumData[#sumData + 1] = "  proto consts: "
												.. table.concat(handleData(item), ",")
										end
									end
								end

								if copyPlaceSourceFlag then
									local success, copyPlaceSourceResult = pcall(decompile, item)

									if success then
										success = type(copyPlaceSourceResult) == "string" and #copyPlaceSourceResult > 0
									end

									if success then
										sumData[#sumData + 1] = "  caller src:\n" .. copyPlaceSourceResult:sub(1, 1800)
									end
								end
							end
						end
					end
				end)
				if copyPlaceSourceNumber == 0 then
					sumData[#sumData + 1] = "no PlantEgg caller in getgc (scanned " .. number .. ")"
				end
			end

			local secondaryDescendant = iData.value6:FindFirstChild("Client")
					and iData.value6.Client:FindFirstChild("EggState")
				or nil

			if not secondaryDescendant then
				for _, descendant in ipairs(iData.value6:GetDescendants()) do
					if descendant.Name == "EggState" and descendant:IsA("ModuleScript") then
						secondaryDescendant = descendant

						break
					end
				end
			end

			if secondaryDescendant and copyPlaceSourceFlag then
				local success, copyPlaceSourceResult = pcall(decompile, secondaryDescendant)

				if success then
					success = type(copyPlaceSourceResult) == "string" and #copyPlaceSourceResult > 0
				end

				if success then
					pcall(writefile, "ShardEggState.txt", copyPlaceSourceResult)

					local sum = #sumData + 1
					local copyPlaceSourceNumber = copyPlaceSourceResult:find("AskPlaceEgg", 1, true)

					sumData[sum] = "== EggState ==\n"
							.. (
								if not copyPlaceSourceNumber
									then nil
									else copyPlaceSourceResult:sub(
										math.max(1, copyPlaceSourceNumber - 1500),
										copyPlaceSourceNumber + 900
									)
							)
						or copyPlaceSourceResult:sub(1, 1200)
				end
			end

			if #sumData == 0 then
				sumData[#sumData + 1] = "decompile + introspection unavailable on this executor"
			end

			local concatResult = table.concat(sumData, "\n\n")

			if setclipboard then
				pcall(setclipboard, concatResult)
			end

			if writefile then
				pcall(writefile, "ShardPlaceSrc.txt", concatResult)
			end

			iData.value18("Place Source", "Copied. Saved ShardPlaceSrc.txt + per-module files.", 6)
		end)
	end,
})
iData.value12.TabConfig:Button({
	Title = "Reset Hop Count",
	Desc = "Clears the stored hop total so Max Hops starts over",
	Callback = function()
		iData.value14.HopCount = 0
		iData.value113(0)
		iData.value18("Server Hop", "Hop count reset.")
	end,
})
iData.value12.TabConfig:Button({
	Title = "Rejoin Server",
	Callback = function()
		pcall(function()
			iData.value5:TeleportToPlaceInstance(game.PlaceId, game.JobId, iData.value9)
		end)
	end,
})
iData.value12.TabConfig:Button({
	Title = "Unload Script",
	Desc = "Stops every loop and closes the window",
	Callback = function()
		iData.value117()
		pcall(function()
			iData.value12.Window:Destroy()
		end)
	end,
})
iData.value142 = {
	spawned = {},
	orbitRadius = 4,
	orbitSpeed = 0.8,
	conn = nil,
	petNames = {},
	inputName = "",
}
iData.value143 = Instance.new("Folder")
iData.value143.Name = "ShardVisualPets"
iData.value143.Parent = iData.value7
function iData.value144()
	local nameData = {}
	local names = {}
	local function handler(item)
		if not item:IsA("Model") then
			return
		end

		local lower = item.Name:lower()

		if lower:find("humanoid") or lower:find("egg") then
			return
		end

		local flag = item:FindFirstChildWhichIsA("BasePart") ~= nil
		local option = item.Parent and item.Parent.Name:lower() or ""

		if
			(
				flag and option:find("pet")
				or (
					option:find("pen")
					or (
						option:find("render")
						or (option:find("slot") or item:FindFirstChildWhichIsA("AnimationController"))
					)
				)
			) and not nameData[item.Name]
		then
			nameData[item.Name] = true
			names[#names + 1] = item.Name
		end
	end
	for index, item in ipairs(iData.value94()) do
		local GetDescendants = item.GetDescendants

		for _, item in ipairs(GetDescendants(item)) do
			handler(item)
		end
	end
	for _, child in ipairs(iData.value7:GetChildren()) do
		for _, item in ipairs(child:GetChildren()) do
			handler(item)
		end
	end
	table.sort(names)
	iData.value142.petNames = names

	return names
end
function iData.value145(argument)
	local searchableText = argument:lower()
	for index, item in ipairs(iData.value94()) do
		for _, descendant in ipairs(item:GetDescendants()) do
			if
				descendant:IsA("Model")
				and descendant.Name:lower():find(searchableText, 1, true)
				and descendant:FindFirstChildWhichIsA("BasePart")
			then
				return descendant
			end
		end
	end
	for _, descendant in ipairs(iData.value7:GetDescendants()) do
		local flag = descendant:IsA("Model")

		if flag then
			flag = descendant.Name:lower():find(searchableText, 1, true)

			if flag then
				flag = not descendant:IsDescendantOf(iData.value143)
			end
		end

		if flag and descendant:FindFirstChildWhichIsA("BasePart") then
			return descendant
		end
	end

	return nil
end
function iData.value146(text)
	local cloneFlag = iData.value145(text)
	if not cloneFlag then
		iData.value18("Visual Pets", "Could not find a model named: " .. text, 4)

		return
	end
	local clone = cloneFlag:Clone()
	for index, item in ipairs(clone:GetDescendants()) do
		if item:IsA("Script") or (item:IsA("LocalScript") or item:IsA("ModuleScript")) then
			item:Destroy()
		end
	end
	for _, descendant in ipairs(clone:GetDescendants()) do
		if descendant:IsA("BasePart") then
			descendant.Anchored = true
			descendant.CanCollide = false
			descendant.CanTouch = false
			descendant.CastShadow = false
		end
	end
	clone.Name = "VP_" .. text
	clone.Parent = iData.value143
	local product = #iData.value142.spawned * (6.283185307179586 / math.max(1, #iData.value142.spawned + 1))
	iData.value142.spawned[#iData.value142.spawned + 1] = {
		model = clone,
		angle = product,
	}
	iData.value18("Visual Pets", "Spawned " .. text .. " (client only).", 3)
end
function iData.value147()
	for _, item in ipairs(iData.value142.spawned) do
		local capturedV = item

		pcall(function()
			capturedV.model:Destroy()
		end)
	end

	iData.value142.spawned = {}
end
function iData.value148()
	if #iData.value142.spawned == 0 then
		return
	end

	local removeResult = table.remove(iData.value142.spawned)

	pcall(function()
		removeResult.model:Destroy()
	end)
end
iData.value142.conn = iData.value3.Heartbeat:Connect(function(_)
	local secondaryInput = iData.value21()

	if not secondaryInput or #iData.value142.spawned == 0 then
		return
	end

	local timestamp = tick()
	local sum = secondaryInput.Position + Vector3.new(0, 1, 0)
	local sumNumber = #iData.value142.spawned

	for i, item in ipairs(iData.value142.spawned) do
		local capturedV = item
		local number = (i - 1) * (6.283185307179586 / sumNumber) + timestamp * iData.value142.orbitSpeed
		local product = math.cos(number) * iData.value142.orbitRadius
		local secondaryProduct = math.sin(number) * iData.value142.orbitRadius
		local secondarySum = sum + Vector3.new(product, 0, secondaryProduct)

		if capturedV.model.PrimaryPart or capturedV.model:FindFirstChildWhichIsA("BasePart") then
			pcall(function()
				capturedV.model:PivotTo(CFrame.new(secondarySum) * CFrame.Angles(0, number + 3.141592653589793, 0))
			end)
		end
	end
end)
secondaryHandler(iData.value142.conn)
iData.value12.TabVisualPet:Section({
	Title = "Visual Pets (Client Only)",
})
iData.value149 = iData.value12.TabVisualPet:Dropdown({
	Title = "Pet",
	Desc = "Pick from pets found in the world",
	Values = { "Scanning..." },
	Value = 1,
	Callback = function(inputNameFlag)
		local inputName = type(inputNameFlag) == "table" and next(inputNameFlag) or inputNameFlag

		if type(inputName) == "string" then
			iData.value142.inputName = inputName
		end
	end,
})
iData.value12.TabVisualPet:Button({
	Title = "Refresh Pet List",
	Desc = "Re-scans workspace for pet models",
	Callback = function()
		local value144Result = iData.value144()

		if #value144Result > 0 then
			pcall(function()
				iData.value149:Refresh(value144Result)
			end)
			pcall(function()
				iData.value149:SetValues(value144Result)
			end)
			iData.value18("Visual Pets", #value144Result .. " pets found.", 3)

			return
		end

		iData.value18("Visual Pets", "No pet models found yet — try after the game loads.", 4)
	end,
})
iData.value12.TabVisualPet:Input({
	Title = "Custom Name",
	Desc = "Type a pet name manually if it's not in the list",
	Placeholder = "e.g. Dragon",
	Callback = function(inputName)
		iData.value142.inputName = inputName
	end,
})
local TabVisualPet = iData.value12.TabVisualPet
local alternateSlider = TabVisualPet.Slider
local nestedValue = {
	Min = 2,
	Max = 20,
	Default = 4,
}
alternateSlider(TabVisualPet, {
	Title = "Orbit Radius",
	Desc = "How far pets orbit from you",
	Step = 1,
	Value = nestedValue,
	Callback = function(orbitRadius)
		iData.value142.orbitRadius = orbitRadius
	end,
})
local tabVisualPet = iData.value12.TabVisualPet
local additionalSlider = tabVisualPet.Slider
local innerValue = {
	Min = 0,
	Max = 10,
	Default = 1,
}
additionalSlider(tabVisualPet, {
	Title = "Orbit Speed",
	Desc = "How fast pets spin around you",
	Step = 1,
	Value = innerValue,
	Callback = function(orbitSpeedNumber)
		iData.value142.orbitSpeed = orbitSpeedNumber * 0.2
	end,
})
local secondaryTabVisualPet = iData.value12.TabVisualPet
local fromHex = Color3.fromHex
local Button = secondaryTabVisualPet.Button
local color = fromHex("#30FF6A")

Button(secondaryTabVisualPet, {
	Title = "Spawn Pet",
	Desc = "Clones the selected/typed pet around your character",
	Color = color,
	Callback = function()
		if iData.value142.inputName == "" then
			iData.value18("Visual Pets", "Select a pet from the list or type a custom name.", 4)

			return
		end

		iData.value146(iData.value142.inputName)
	end,
})
iData.value12.TabVisualPet:Button({
	Title = "Remove Last Pet",
	Callback = function()
		iData.value148()
	end,
})
local alternateTabVisualPet = iData.value12.TabVisualPet
local secondaryColor = Color3.fromHex("#FF4830")

alternateTabVisualPet:Button({
	Title = "Remove All Pets",
	Color = secondaryColor,
	Callback = function()
		iData.value147()
		iData.value18("Visual Pets", "All visual pets removed.", 3)
	end,
})
task.delay(3, function()
	local value144Result = iData.value144()

	if #value144Result > 0 then
		pcall(function()
			iData.value149:Refresh(value144Result)
		end)
		pcall(function()
			iData.value149:SetValues(value144Result)
		end)
	end
end)
pcall(function()
	iData.value12.Window:SelectTab(1)
end)
task.spawn(function()
	if not iData.value23() then
		iData.value9.CharacterAdded:Wait()
		task.wait(0.7)
	end

	iData.value49(true)

	if #iData.value13.areaOrder > 0 then
		iData.value36()
		iData.value40()
		iData.value44("AreaFocus", iData.value37())
	end
end)

if not iData.value24 then
	iData.value18("Vortex x Software", "Packages.Networking is missing, remote features are offline.", 8)

	return
end
iData.value18("Vortex x Software", "Loaded. " .. #iData.value13.areaOrder .. " areas, " .. #iData.value28() .. " endpoints.", 5)