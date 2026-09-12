--[[
  Vortex X Sage · Music (solo custom)
  Añade canciones por rbxassetid, favoritos, compartir
]]

local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

if _G.MusicTesterCleanup then
	pcall(_G.MusicTesterCleanup)
	_G.MusicTesterCleanup = nil
end

local LIB_URL = "https://raw.githubusercontent.com/Israel-Vortex/vortex-x-scripts/refs/heads/main/Music/Sega/VortexHub/Sega-Vortex/lib.lua"
local ICONS_URL = "https://raw.githubusercontent.com/Footagesus/Icons/main/Main-v2.lua"
local ICON_PACK = "sfsymbols"
local SAVE_DIR = "VortexXSage/music"
local FAV_FILE = SAVE_DIR .. "/favorites.json"
local CUSTOM_FILE = SAVE_DIR .. "/custom_tracks.json"

local C = {
	card = Color3.fromRGB(18, 18, 22),
	card2 = Color3.fromRGB(26, 26, 32),
	line = Color3.fromRGB(55, 48, 28),
	gold = Color3.fromRGB(255, 200, 55),
	gold2 = Color3.fromRGB(220, 160, 35),
	goldDim = Color3.fromRGB(90, 70, 25),
	text = Color3.fromRGB(250, 250, 252),
	muted = Color3.fromRGB(140, 140, 155),
	white = Color3.fromRGB(255, 255, 255),
	black = Color3.fromRGB(12, 10, 6),
}

local function bootstrapFetch(url)
	for _, getter in ipairs({ game.HttpGetAsync, game.HttpGet }) do
		local ok, res = pcall(getter, game, url)
		if ok and type(res) == "string" and res ~= "" then return res end
	end
	local ok, res = pcall(function() return HttpService:GetAsync(url) end)
	return ok and res or nil
end

local Lib
do
	local src = bootstrapFetch(LIB_URL)
	if src then
		local ok, mod = pcall(function() return loadstring(src)() end)
		if ok and type(mod) == "table" then Lib = mod end
	end
end
if not Lib then
	warn("[Vortex Music] No se pudo cargar UI lib")
	return
end

local create, corner, padding = Lib.create, Lib.corner, Lib.padding
local createIcon = Lib.icons.createIcon
Lib.icons.configure(ICONS_URL, ICON_PACK)

local function stroke(parent, color, th, tr)
	local s = Instance.new("UIStroke")
	s.Color = color or C.line
	s.Thickness = th or 1
	s.Transparency = tr or 0.3
	s.Parent = parent
	return s
end

local function grad(parent, c0, c1, rot)
	local g = Instance.new("UIGradient")
	g.Color = ColorSequence.new(c0, c1)
	g.Rotation = rot or 90
	g.Parent = parent
	return g
end

local function ensureSaveFolder()
	if not (makefolder and isfolder) then return end
	if not isfolder("VortexXSage") then pcall(makefolder, "VortexXSage") end
	if not isfolder(SAVE_DIR) then pcall(makefolder, SAVE_DIR) end
end

-- ===== solo custom =====
local customTracks = {}
local favorites = {}
local trackById = {}

local function rebuildIndex()
	table.clear(trackById)
	for _, t in ipairs(customTracks) do
		trackById[t.id] = t
	end
end

local function loadCustom()
	if not (readfile and isfile and isfile(CUSTOM_FILE)) then return end
	local ok, data = pcall(function() return HttpService:JSONDecode(readfile(CUSTOM_FILE)) end)
	if ok and type(data) == "table" then customTracks = data end
	rebuildIndex()
end

local function saveCustom()
	if writefile then
		ensureSaveFolder()
		pcall(writefile, CUSTOM_FILE, HttpService:JSONEncode(customTracks))
	end
end

local function loadFav()
	if not (readfile and isfile and isfile(FAV_FILE)) then return end
	local ok, data = pcall(function() return HttpService:JSONDecode(readfile(FAV_FILE)) end)
	if ok and type(data) == "table" then favorites = data end
end

local function saveFav()
	if writefile then
		ensureSaveFolder()
		pcall(writefile, FAV_FILE, HttpService:JSONEncode(favorites))
	end
end

local function isFavorite(id)
	return table.find(favorites, id) ~= nil
end

local function toggleFavorite(id)
	local at = table.find(favorites, id)
	if at then table.remove(favorites, at) else table.insert(favorites, id) end
	saveFav()
end

loadCustom()
loadFav()

local shareWithOthers = false
local currentTrackId = ""
local currentIndex = 1
local broadcastSounds = {}

local sound = create("Sound", {
	Name = "VortexMusicSound",
	Volume = 0.55,
	Looped = false,
	RollOffMode = Enum.RollOffMode.InverseTapered,
	RollOffMinDistance = 5,
	RollOffMaxDistance = 100,
	EmitterSize = 12,
	Parent = SoundService,
})

local function clearBroadcastSounds()
	for _, s in ipairs(broadcastSounds) do
		pcall(function() s:Stop() s:Destroy() end)
	end
	table.clear(broadcastSounds)
end

local function getCharParts()
	local char = player.Character
	if not char then return {} end
	local parts = {}
	for _, name in ipairs({ "HumanoidRootPart", "Head", "UpperTorso", "Torso" }) do
		local p = char:FindFirstChild(name)
		if p and p:IsA("BasePart") then table.insert(parts, p) end
	end
	return parts
end

local function playOnCharacter(assetId, vol)
	clearBroadcastSounds()
	local sid = "rbxassetid://" .. tostring(assetId):gsub("%D", "")
	for _, part in ipairs(getCharParts()) do
		local ok, s = pcall(function()
			local ns = Instance.new("Sound")
			ns.Name = "VXShare_" .. part.Name
			ns.SoundId = sid
			ns.Volume = vol or 1.2
			ns.RollOffMaxDistance = 120
			ns.EmitterSize = 15
			ns.Parent = part
			ns:Play()
			return ns
		end)
		if ok and s then table.insert(broadcastSounds, s) end
	end
end

local function playOnTools(assetId)
	local sid = "rbxassetid://" .. tostring(assetId):gsub("%D", "")
	local containers = {}
	if player.Character then table.insert(containers, player.Character) end
	local bp = player:FindFirstChildOfClass("Backpack")
	if bp then table.insert(containers, bp) end
	for _, container in ipairs(containers) do
		for _, tool in ipairs(container:GetChildren()) do
			if tool:IsA("Tool") then
				for _, d in ipairs(tool:GetDescendants()) do
					if d:IsA("Sound") then
						pcall(function()
							d.SoundId = sid
							d.Volume = math.max(d.Volume, 1)
							d:Play()
						end)
					end
				end
			end
		end
	end
end

local remoteCache = nil
local function fireMusicRemotes(assetId)
	if not remoteCache then
		remoteCache = {}
		local keys = { "music", "boom", "radio", "song", "audio", "sound", "play" }
		for _, root in ipairs({ game:GetService("ReplicatedStorage"), game:GetService("ReplicatedFirst") }) do
			for _, obj in ipairs(root:GetDescendants()) do
				if obj:IsA("RemoteEvent") or obj:IsA("UnreliableRemoteEvent") then
					local n = string.lower(obj.Name)
					for _, k in ipairs(keys) do
						if string.find(n, k, 1, true) then
							table.insert(remoteCache, obj)
							break
						end
					end
				end
			end
		end
	end
	local idStr = tostring(assetId):gsub("%D", "")
	local idNum = tonumber(idStr) or 0
	for _, remote in ipairs(remoteCache) do
		pcall(function() remote:FireServer(idStr) end)
		pcall(function() remote:FireServer(idNum) end)
		pcall(function() remote:FireServer("Play", idStr) end)
		pcall(function() remote:FireServer({ SoundId = "rbxassetid://" .. idStr }) end)
	end
end

local function applySoundParent()
	if shareWithOthers then
		local char = player.Character
		local p = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head") or char)
		sound.Parent = p or SoundService
		sound.Volume = math.max(sound.Volume, 0.9)
		sound.RollOffMaxDistance = 120
	else
		sound.Parent = SoundService
		clearBroadcastSounds()
	end
end

local function broadcastNow()
	if not shareWithOthers then return end
	local assetId = (currentTrackId or ""):gsub("%D", "")
	if assetId == "" then return end
	applySoundParent()
	playOnCharacter(assetId, 1.2)
	playOnTools(assetId)
	task.spawn(function() fireMusicRemotes(assetId) end)
end

player.CharacterAdded:Connect(function()
	task.wait(0.35)
	if shareWithOthers then applySoundParent() broadcastNow() end
end)

-- ===== UI =====
local screenGui = create("ScreenGui", {
	Name = "VortexMusicGui",
	ResetOnSpawn = false,
	IgnoreGuiInset = true,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	Parent = playerGui,
})

local floatBtn = create("ImageButton", {
	AnchorPoint = Vector2.new(1, 1),
	Position = UDim2.new(1, -12, 1, -12),
	Size = UDim2.fromOffset(40, 40),
	BackgroundColor3 = C.gold,
	AutoButtonColor = false,
	Visible = false,
	Parent = screenGui,
})
corner(floatBtn, 12)
stroke(floatBtn, C.white, 1, 0.65)
grad(floatBtn, C.gold, C.gold2, 135)
createIcon(floatBtn, 16, C.black).set("musicNote", "♪")

local CARD_W, CARD_H = 288, 112
local root = create("Frame", {
	Name = "PlayerCard",
	Size = UDim2.fromOffset(CARD_W, CARD_H),
	Position = UDim2.new(0.5, -CARD_W / 2, 1, -(CARD_H + 14)),
	BackgroundColor3 = C.card,
	BorderSizePixel = 0,
	Active = true,
	Parent = screenGui,
})
corner(root, 16)
stroke(root, C.line, 1, 0.3)
grad(root, Color3.fromRGB(22, 20, 16), Color3.fromRGB(12, 12, 14), 160)

local header = create("Frame", {
	Size = UDim2.new(1, -14, 0, 34),
	Position = UDim2.new(0, 7, 0, 6),
	BackgroundTransparency = 1,
	Parent = root,
})

local badge = create("Frame", {
	Size = UDim2.fromOffset(30, 30),
	BackgroundColor3 = C.gold,
	Parent = header,
})
corner(badge, 8)
grad(badge, C.gold, C.gold2, 45)
createIcon(badge, 13, C.black).set("musicNote", "♪")

local nowPlaying = create("TextLabel", {
	Size = UDim2.new(1, -90, 0, 14),
	Position = UDim2.new(0, 36, 0, 2),
	BackgroundTransparency = 1,
	Text = "Sin canción",
	TextColor3 = C.text,
	TextXAlignment = Enum.TextXAlignment.Left,
	Font = Enum.Font.GothamBold,
	TextSize = 12,
	TextTruncate = Enum.TextTruncate.AtEnd,
	Parent = header,
})

local nowArtist = create("TextLabel", {
	Size = UDim2.new(1, -90, 0, 12),
	Position = UDim2.new(0, 36, 0, 17),
	BackgroundTransparency = 1,
	Text = "Añade un ID en Mi música",
	TextColor3 = C.muted,
	TextXAlignment = Enum.TextXAlignment.Left,
	Font = Enum.Font.Gotham,
	TextSize = 10,
	TextTruncate = Enum.TextTruncate.AtEnd,
	Parent = header,
})

local hideBtn = create("TextButton", {
	AnchorPoint = Vector2.new(1, 0),
	Position = UDim2.new(1, 0, 0, 2),
	Size = UDim2.fromOffset(26, 26),
	BackgroundColor3 = C.card2,
	Text = "—",
	TextColor3 = C.muted,
	Font = Enum.Font.GothamBold,
	TextSize = 14,
	AutoButtonColor = false,
	Parent = header,
})
corner(hideBtn, 8)

hideBtn.MouseButton1Click:Connect(function()
	root.Visible = false
	floatBtn.Visible = true
end)
Lib.makeDraggable(floatBtn, floatBtn, function()
	root.Visible = true
	floatBtn.Visible = false
end)
Lib.makeDraggable(root, root)

-- progress
local progressWrap = create("Frame", {
	Size = UDim2.new(1, -14, 0, 14),
	Position = UDim2.new(0, 7, 0, 42),
	BackgroundTransparency = 1,
	Parent = root,
})
local timeLeft = create("TextLabel", {
	Size = UDim2.fromOffset(28, 10),
	BackgroundTransparency = 1,
	Text = "0:00",
	TextColor3 = C.muted,
	Font = Enum.Font.Gotham,
	TextSize = 9,
	Parent = progressWrap,
})
local timeRight = create("TextLabel", {
	AnchorPoint = Vector2.new(1, 0),
	Size = UDim2.fromOffset(28, 10),
	Position = UDim2.new(1, 0, 0, 0),
	BackgroundTransparency = 1,
	Text = "0:00",
	TextColor3 = C.muted,
	Font = Enum.Font.Gotham,
	TextSize = 9,
	TextXAlignment = Enum.TextXAlignment.Right,
	Parent = progressWrap,
})
local progressTrack = create("Frame", {
	Size = UDim2.new(1, 0, 0, 4),
	Position = UDim2.new(0, 0, 0, 11),
	BackgroundColor3 = C.card2,
	Parent = progressWrap,
})
corner(progressTrack, 4)
local progressFill = create("Frame", {
	Size = UDim2.new(0, 0, 1, 0),
	BackgroundColor3 = C.gold,
	Parent = progressTrack,
})
corner(progressFill, 4)
local progressKnob = create("Frame", {
	Size = UDim2.fromOffset(10, 10),
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.new(0, 0, 0.5, 0),
	BackgroundColor3 = C.white,
	ZIndex = 3,
	Parent = progressTrack,
})
corner(progressKnob, 5)
local seekHit = create("TextButton", {
	Size = UDim2.new(1, 0, 0, 22),
	Position = UDim2.new(0, 0, 0.5, -11),
	BackgroundTransparency = 1,
	Text = "",
	Parent = progressTrack,
})

local function fmtTime(sec)
	sec = math.max(0, math.floor(sec or 0))
	return string.format("%d:%02d", math.floor(sec / 60), sec % 60)
end
local function setProgress(rel)
	rel = math.clamp(rel, 0, 1)
	progressFill.Size = UDim2.new(rel, 0, 1, 0)
	progressKnob.Position = UDim2.new(rel, 0, 0.5, 0)
end
local isSeeking = Lib.makeSlider(seekHit, function(pos)
	local rel = math.clamp((pos.X - progressTrack.AbsolutePosition.X) / math.max(1, progressTrack.AbsoluteSize.X), 0, 1)
	setProgress(rel)
	if sound.TimeLength > 0 then sound.TimePosition = rel * sound.TimeLength end
end)
Lib.track(RunService.RenderStepped:Connect(function()
	if not isSeeking() and sound.TimeLength > 0 then
		setProgress(sound.TimePosition / sound.TimeLength)
		timeLeft.Text = fmtTime(sound.TimePosition)
		timeRight.Text = fmtTime(sound.TimeLength)
	end
end))

-- controls
local controls = create("Frame", {
	Size = UDim2.new(1, -14, 0, 36),
	Position = UDim2.new(0, 7, 1, -40),
	BackgroundTransparency = 1,
	Parent = root,
})
create("UIListLayout", {
	FillDirection = Enum.FillDirection.Horizontal,
	HorizontalAlignment = Enum.HorizontalAlignment.Center,
	VerticalAlignment = Enum.VerticalAlignment.Center,
	Padding = UDim.new(0, 6),
	SortOrder = Enum.SortOrder.LayoutOrder,
	Parent = controls,
})

local function roundBtn(size, order, bg)
	local b = create("ImageButton", {
		Size = UDim2.fromOffset(size, size),
		BackgroundColor3 = bg or C.card2,
		AutoButtonColor = false,
		LayoutOrder = order,
		Parent = controls,
	})
	corner(b, size / 2.5)
	return b
end

local menuBtn = roundBtn(28, 1, C.card2)
stroke(menuBtn, C.line, 1, 0.4)
for i = 0, 2 do
	local line = create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.fromOffset(11, 1.5),
		Position = UDim2.new(0.5, 0, 0.5, (i - 1) * 4),
		BackgroundColor3 = C.gold,
		BorderSizePixel = 0,
		Parent = menuBtn,
	})
	corner(line, 1)
end

local prevBtn = roundBtn(28, 2, C.card2)
stroke(prevBtn, C.line, 1, 0.4)
createIcon(prevBtn, 12, C.text).set("backwardEndFill", "⏮")

local playBtn = roundBtn(32, 3, C.gold)
stroke(playBtn, C.white, 1, 0.6)
grad(playBtn, C.gold, C.gold2, 135)
local playIcon = createIcon(playBtn, 14, C.black, 12)

local nextBtn = roundBtn(28, 4, C.card2)
stroke(nextBtn, C.line, 1, 0.4)
createIcon(nextBtn, 12, C.text).set("forwardEndFill", "⏭")

local heartBtn = roundBtn(28, 5, C.card2)
stroke(heartBtn, C.line, 1, 0.4)
local heartIcon = createIcon(heartBtn, 12, C.white)
heartIcon.set("heart", "♡")

local shareBtn = roundBtn(28, 6, C.card2)
stroke(shareBtn, C.line, 1, 0.4)
local shareIcon = createIcon(shareBtn, 11, C.muted)
shareIcon.set("speakerWave2Fill", "📡")

-- volume
local volBar = create("Frame", {
	Size = UDim2.fromOffset(28, CARD_H),
	Position = UDim2.new(1, 5, 0, 0),
	BackgroundColor3 = C.card,
	Parent = root,
})
corner(volBar, 14)
stroke(volBar, C.line, 1, 0.35)
local volTrack = create("Frame", {
	AnchorPoint = Vector2.new(0.5, 0),
	Position = UDim2.new(0.5, 0, 0, 10),
	Size = UDim2.new(0, 4, 1, -40),
	BackgroundColor3 = C.card2,
	Parent = volBar,
})
corner(volTrack, 3)
local volFill = create("Frame", {
	AnchorPoint = Vector2.new(0.5, 1),
	Position = UDim2.new(0.5, 0, 1, 0),
	Size = UDim2.new(1, 0, sound.Volume, 0),
	BackgroundColor3 = C.gold,
	Parent = volTrack,
})
corner(volFill, 3)
local volKnob = create("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.new(0.5, 0, 1 - sound.Volume, 0),
	Size = UDim2.fromOffset(9, 9),
	BackgroundColor3 = C.white,
	ZIndex = 2,
	Parent = volTrack,
})
corner(volKnob, 5)
local volHit = create("TextButton", {
	AnchorPoint = Vector2.new(0.5, 0),
	Position = UDim2.new(0.5, 0, 0, 8),
	Size = UDim2.new(1, 0, 1, -36),
	BackgroundTransparency = 1,
	Text = "",
	Parent = volBar,
})
local muteBtn = create("ImageButton", {
	AnchorPoint = Vector2.new(0.5, 1),
	Position = UDim2.new(0.5, 0, 1, -6),
	Size = UDim2.fromOffset(20, 20),
	BackgroundColor3 = C.card2,
	AutoButtonColor = false,
	Parent = volBar,
})
corner(muteBtn, 6)
local muteIcon = createIcon(muteBtn, 11, C.muted, 10)

local function updateMuteIcon()
	local muted = sound.Volume <= 0.001
	muteIcon.set(muted and "speakerSlashFill" or "speakerWave2Fill", muted and "×" or "♪")
	muteIcon.tint(muted and C.gold or C.muted)
end
local function applyVolume(rel)
	rel = math.clamp(rel, 0, 1)
	sound.Volume = rel
	volFill.Size = UDim2.new(1, 0, rel, 0)
	volKnob.Position = UDim2.new(0.5, 0, 1 - rel, 0)
	updateMuteIcon()
end
Lib.makeSlider(volHit, function(pos)
	applyVolume(1 - (pos.Y - volTrack.AbsolutePosition.Y) / math.max(1, volTrack.AbsoluteSize.Y))
end)
local lastVolume = sound.Volume
muteBtn.MouseButton1Click:Connect(function()
	if sound.Volume > 0.001 then
		lastVolume = sound.Volume
		applyVolume(0)
	else
		applyVolume(lastVolume > 0.05 and lastVolume or 0.55)
	end
end)
updateMuteIcon()

-- ===== PANEL: solo Mis canciones / Favoritas =====
local PANEL_H = 250
local panel = create("Frame", {
	Size = UDim2.new(1, 33, 0, PANEL_H),
	Position = UDim2.new(0, 0, 0, -(PANEL_H + 8)),
	BackgroundColor3 = C.card,
	BorderSizePixel = 0,
	Visible = false,
	Parent = root,
})
corner(panel, 16)
stroke(panel, C.line, 1, 0.3)
padding(panel, 8, 8, 8, 8)

create("Frame", {
	AnchorPoint = Vector2.new(0.5, 0),
	Position = UDim2.new(0.5, 0, 0, 2),
	Size = UDim2.fromOffset(28, 3),
	BackgroundColor3 = C.goldDim,
	Parent = panel,
})

create("TextLabel", {
	Size = UDim2.new(1, 0, 0, 16),
	Position = UDim2.new(0, 0, 0, 8),
	BackgroundTransparency = 1,
	Text = "Mis canciones",
	TextColor3 = C.text,
	Font = Enum.Font.GothamBold,
	TextSize = 12,
	TextXAlignment = Enum.TextXAlignment.Left,
	Parent = panel,
})

local tabSongs = create("TextButton", {
	Size = UDim2.new(0.5, -3, 0, 26),
	Position = UDim2.new(0, 0, 0, 28),
	BackgroundColor3 = C.goldDim,
	Text = "Mis IDs",
	TextColor3 = C.gold,
	Font = Enum.Font.GothamBold,
	TextSize = 11,
	AutoButtonColor = false,
	Parent = panel,
})
corner(tabSongs, 8)

local tabFav = create("TextButton", {
	Size = UDim2.new(0.5, -3, 0, 26),
	Position = UDim2.new(0.5, 3, 0, 28),
	BackgroundColor3 = C.card2,
	Text = "Favoritas",
	TextColor3 = C.muted,
	Font = Enum.Font.GothamBold,
	TextSize = 11,
	AutoButtonColor = false,
	Parent = panel,
})
corner(tabFav, 8)

local nameBox = create("TextBox", {
	Position = UDim2.new(0, 0, 0, 58),
	Size = UDim2.new(0.42, -2, 0, 26),
	BackgroundColor3 = C.card2,
	TextColor3 = C.text,
	PlaceholderText = " Nombre",
	PlaceholderColor3 = C.muted,
	ClearTextOnFocus = false,
	Font = Enum.Font.Gotham,
	TextSize = 11,
	Text = "",
	TextXAlignment = Enum.TextXAlignment.Left,
	Parent = panel,
})
corner(nameBox, 7)

local idBox = create("TextBox", {
	Position = UDim2.new(0.42, 2, 0, 58),
	Size = UDim2.new(0.38, -2, 0, 26),
	BackgroundColor3 = C.card2,
	TextColor3 = C.text,
	PlaceholderText = " Asset ID",
	PlaceholderColor3 = C.muted,
	ClearTextOnFocus = false,
	Font = Enum.Font.Gotham,
	TextSize = 11,
	Text = "",
	TextXAlignment = Enum.TextXAlignment.Left,
	Parent = panel,
})
corner(idBox, 7)

local addBtn = create("TextButton", {
	Position = UDim2.new(0.80, 2, 0, 58),
	Size = UDim2.new(0.20, -2, 0, 26),
	BackgroundColor3 = C.gold,
	Text = "+",
	TextColor3 = C.black,
	Font = Enum.Font.GothamBold,
	TextSize = 16,
	AutoButtonColor = true,
	Parent = panel,
})
corner(addBtn, 7)

local searchBox = create("TextBox", {
	Position = UDim2.new(0, 0, 0, 88),
	Size = UDim2.new(1, 0, 0, 24),
	BackgroundColor3 = C.card2,
	TextColor3 = C.text,
	PlaceholderText = "  Buscar en mis canciones…",
	PlaceholderColor3 = C.muted,
	ClearTextOnFocus = false,
	Font = Enum.Font.Gotham,
	TextSize = 10,
	Text = "",
	TextXAlignment = Enum.TextXAlignment.Left,
	Parent = panel,
})
corner(searchBox, 7)

local listScroll = create("ScrollingFrame", {
	Position = UDim2.new(0, 0, 0, 118),
	Size = UDim2.new(1, 0, 1, -118),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ScrollBarThickness = 2,
	ScrollBarImageColor3 = C.gold2,
	CanvasSize = UDim2.new(0, 0, 0, 0),
	AutomaticCanvasSize = Enum.AutomaticSize.Y,
	Parent = panel,
})
create("UIListLayout", {
	Padding = UDim.new(0, 4),
	SortOrder = Enum.SortOrder.LayoutOrder,
	Parent = listScroll,
})

menuBtn.MouseButton1Click:Connect(function()
	panel.Visible = not panel.Visible
end)

-- player logic
local currentTab = "songs" -- songs | fav
local searchQuery = ""
local rebuildLists, highlightCurrent

local function refreshHeart()
	local fav = isFavorite(currentTrackId)
	heartIcon.set(fav and "heartFill" or "heart", fav and "♥" or "♡")
	heartIcon.tint(fav and C.gold or C.white)
end

local function setPlayGlyph()
	playIcon.set(sound.IsPlaying and "pauseFill" or "playFill", sound.IsPlaying and "❚❚" or "▶")
end

local function setCurrent(id)
	currentTrackId = id
	local t = trackById[id]
	nowPlaying.Text = t and t.name or (id ~= "" and id or "Sin canción")
	nowArtist.Text = t and (t.artist or "Custom") or "Añade un ID en Mi música"
	refreshHeart()
	highlightCurrent()
end

local function loadAndPlay()
	local assetId = currentTrackId:gsub("%D", "")
	if assetId == "" then return end
	sound:Stop()
	sound.SoundId = "rbxassetid://" .. assetId
	applySoundParent()
	pcall(sound.Play, sound)
	if shareWithOthers then broadcastNow() end
	setPlayGlyph()
end

local function playId(id)
	for i, t in ipairs(customTracks) do
		if t.id == id then currentIndex = i break end
	end
	setCurrent(id)
	loadAndPlay()
end

local function playStep(offset)
	if #customTracks == 0 then return end
	currentIndex = (currentIndex + offset - 1) % #customTracks + 1
	setCurrent(customTracks[currentIndex].id)
	loadAndPlay()
end

local function togglePlay()
	if sound.IsPlaying then
		sound:Pause()
	elseif sound.SoundId ~= "" and sound.TimePosition > 0 then
		sound:Resume()
	else
		loadAndPlay()
	end
	setPlayGlyph()
end

prevBtn.MouseButton1Click:Connect(function() playStep(-1) end)
nextBtn.MouseButton1Click:Connect(function() playStep(1) end)
playBtn.MouseButton1Click:Connect(togglePlay)
sound.Ended:Connect(function() playStep(1) end)

heartBtn.MouseButton1Click:Connect(function()
	if currentTrackId == "" then return end
	toggleFavorite(currentTrackId)
	refreshHeart()
	rebuildLists()
end)

local function refreshShareBtn()
	if shareWithOthers then
		shareBtn.BackgroundColor3 = C.goldDim
		shareIcon.tint(C.gold)
	else
		shareBtn.BackgroundColor3 = C.card2
		shareIcon.tint(C.muted)
	end
end
shareBtn.MouseButton1Click:Connect(function()
	shareWithOthers = not shareWithOthers
	applySoundParent()
	refreshShareBtn()
	if shareWithOthers then broadcastNow() end
end)
refreshShareBtn()

addBtn.MouseButton1Click:Connect(function()
	local id = (idBox.Text or ""):gsub("%D", "")
	local name = (nameBox.Text or ""):gsub("^%s+", ""):gsub("%s+$", "")
	if id == "" then return end
	if name == "" then name = "ID " .. id end
	for _, t in ipairs(customTracks) do
		if t.id == id then
			t.name = name
			saveCustom()
			rebuildIndex()
			rebuildLists()
			playId(id)
			return
		end
	end
	table.insert(customTracks, { id = id, name = name, artist = "Custom", genre = "Custom" })
	saveCustom()
	rebuildIndex()
	rebuildLists()
	idBox.Text = ""
	nameBox.Text = ""
	playId(id)
end)

local rowsById = {}

local function makeRow(id, order)
	local t = trackById[id]
	local rowBtn = create("TextButton", {
		Size = UDim2.new(1, -2, 0, 34),
		BackgroundColor3 = C.card2,
		AutoButtonColor = true,
		Text = "",
		LayoutOrder = order,
		Parent = listScroll,
	})
	corner(rowBtn, 8)

	create("TextLabel", {
		Size = UDim2.new(1, -70, 0, 14),
		Position = UDim2.new(0, 10, 0, 3),
		BackgroundTransparency = 1,
		Text = t and t.name or id,
		TextColor3 = C.text,
		TextXAlignment = Enum.TextXAlignment.Left,
		Font = Enum.Font.GothamMedium,
		TextSize = 11,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = rowBtn,
	})
	local sub = create("TextLabel", {
		Size = UDim2.new(1, -70, 0, 12),
		Position = UDim2.new(0, 10, 0, 17),
		BackgroundTransparency = 1,
		Text = "ID " .. id,
		TextColor3 = C.muted,
		TextXAlignment = Enum.TextXAlignment.Left,
		Font = Enum.Font.Gotham,
		TextSize = 9,
		Parent = rowBtn,
	})
	local mark = create("TextLabel", {
		Size = UDim2.fromOffset(20, 34),
		Position = UDim2.new(1, -44, 0, 0),
		BackgroundTransparency = 1,
		Text = isFavorite(id) and "♥" or "",
		TextColor3 = C.gold,
		Font = Enum.Font.GothamBold,
		TextSize = 11,
		Parent = rowBtn,
	})
	local del = create("TextButton", {
		Size = UDim2.fromOffset(22, 22),
		Position = UDim2.new(1, -26, 0.5, -11),
		BackgroundColor3 = Color3.fromRGB(50, 30, 30),
		Text = "×",
		TextColor3 = Color3.fromRGB(255, 140, 140),
		Font = Enum.Font.GothamBold,
		TextSize = 12,
		AutoButtonColor = true,
		Parent = rowBtn,
	})
	corner(del, 6)
	del.MouseButton1Click:Connect(function()
		for i, tr in ipairs(customTracks) do
			if tr.id == id then
				table.remove(customTracks, i)
				break
			end
		end
		local at = table.find(favorites, id)
		if at then table.remove(favorites, at) saveFav() end
		saveCustom()
		rebuildIndex()
		if currentTrackId == id then
			sound:Stop()
			currentTrackId = ""
			setCurrent("")
		end
		rebuildLists()
	end)

	rowsById[id] = { button = rowBtn, sub = sub, mark = mark }
	rowBtn.MouseButton1Click:Connect(function()
		playId(id)
		panel.Visible = false
	end)
end

rebuildLists = function()
	table.clear(rowsById)
	for _, child in ipairs(listScroll:GetChildren()) do
		if not child:IsA("UIListLayout") then child:Destroy() end
	end
	local count = 0
	local source = {}
	if currentTab == "fav" then
		for _, id in ipairs(favorites) do
			if trackById[id] then table.insert(source, trackById[id]) end
		end
	else
		source = customTracks
	end
	for _, t in ipairs(source) do
		local ok = true
		if searchQuery ~= "" then
			local hay = ((t.name or "") .. " " .. (t.id or "")):lower()
			if not hay:find(searchQuery, 1, true) then ok = false end
		end
		if ok then
			count = count + 1
			makeRow(t.id, count)
		end
	end
	if count == 0 then
		create("TextLabel", {
			Size = UDim2.new(1, 0, 0, 40),
			BackgroundTransparency = 1,
			Text = currentTab == "fav" and "Sin favoritas.\nToca ♥ al reproducir." or "Aún no hay canciones.\nPon nombre + Asset ID y +",
			TextColor3 = C.muted,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextWrapped = true,
			Font = Enum.Font.Gotham,
			TextSize = 10,
			Parent = listScroll,
		})
	end
	highlightCurrent()
end

highlightCurrent = function()
	for id, r in pairs(rowsById) do
		local sel = id == currentTrackId
		r.button.BackgroundColor3 = sel and Color3.fromRGB(40, 34, 18) or C.card2
		r.sub.TextColor3 = sel and C.gold or C.muted
	end
end

local function setTab(tab)
	currentTab = tab
	tabSongs.BackgroundColor3 = tab == "songs" and C.goldDim or C.card2
	tabSongs.TextColor3 = tab == "songs" and C.gold or C.muted
	tabFav.BackgroundColor3 = tab == "fav" and C.goldDim or C.card2
	tabFav.TextColor3 = tab == "fav" and C.gold or C.muted
	rebuildLists()
end

tabSongs.MouseButton1Click:Connect(function() setTab("songs") end)
tabFav.MouseButton1Click:Connect(function() setTab("fav") end)
searchBox:GetPropertyChangedSignal("Text"):Connect(function()
	searchQuery = searchBox.Text:lower()
	rebuildLists()
end)

setTab("songs")
if #customTracks > 0 then
	setCurrent(customTracks[1].id)
end
setPlayGlyph()

_G.MusicTesterCleanup = function()
	pcall(Lib.cleanup)
	clearBroadcastSounds()
	pcall(function() sound:Destroy() end)
	pcall(function() screenGui:Destroy() end)
end

print("[Vortex X Sage] Music · solo custom IDs")
