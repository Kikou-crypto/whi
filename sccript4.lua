local Player = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")

local Character
local Humanoid
local connections = {}

local currentTheme = "Discord"
local espEnabled = true
local currentTab = "Chevaux"
local desiredWalkSpeed = 16

local SPEED_MIN, SPEED_MAX = 8, 120

local THEMES = {
	Discord = {
		FrameBG = Color3.fromRGB(35, 37, 41),
		HeaderBG = Color3.fromRGB(47, 49, 54),
		RowBG = Color3.fromRGB(47, 49, 54),
		TabActive = Color3.fromRGB(250, 166, 26),
		TabInactive = Color3.fromRGB(150, 150, 150),
		TextPrimary = Color3.fromRGB(255, 255, 255),
		TextSecondary = Color3.fromRGB(170, 170, 170),
		ButtonMain = Color3.fromRGB(60, 63, 70),
		ButtonAccent = Color3.fromRGB(88, 101, 242),
		ButtonClose = Color3.fromRGB(237, 66, 69),
		WarningBG_Wild = Color3.fromRGB(67, 181, 129),
		WarningBG_Other = Color3.fromRGB(255, 69, 0),
		EventColor = Color3.fromRGB(235, 130, 255),
		StrokeColor = Color3.fromRGB(20, 21, 24),
	},
	Western = {
		FrameBG = Color3.fromRGB(60, 45, 30),
		HeaderBG = Color3.fromRGB(80, 60, 40),
		RowBG = Color3.fromRGB(80, 60, 40),
		TabActive = Color3.fromRGB(230, 150, 60),
		TabInactive = Color3.fromRGB(200, 180, 160),
		TextPrimary = Color3.fromRGB(255, 255, 255),
		TextSecondary = Color3.fromRGB(220, 210, 200),
		ButtonMain = Color3.fromRGB(100, 75, 50),
		ButtonAccent = Color3.fromRGB(143, 109, 74),
		ButtonClose = Color3.fromRGB(200, 60, 60),
		WarningBG_Wild = Color3.fromRGB(50, 150, 50),
		WarningBG_Other = Color3.fromRGB(165, 42, 42),
		EventColor = Color3.fromRGB(186, 85, 211),
		StrokeColor = Color3.fromRGB(40, 30, 20),
	}
}

local EVENT_BREEDS = {
	["summer event 2022"] = true,
	["autumn event 2022"] = true,
	["valentine's day event 2022"] = true,
	["easter event 2022"] = true,
	["halloween event 2022"] = true,
	["valentine's day event 2026"] = true,
}

local function isEventModel(model, breed)
	if breed then
		local lower = breed:lower()
		if EVENT_BREEDS[lower] or lower:find("event") then
			return true
		end
	end

	for _, tag in ipairs(CollectionService:GetTags(model)) do
		if tag:lower():find("event") then
			return true
		end
	end

	for name, value in pairs(model:GetAttributes()) do
		if typeof(value) == "boolean" and value == true then
			local n = name:lower()
			if n:find("event") or n:find("special") or n:find("limited") then
				return true
			end
		end
	end

	for _, d in ipairs(model:GetDescendants()) do
		if d:IsA("BoolValue") and d.Value == true then
			local n = d.Name:lower()
			if n:find("event") or n:find("special") or n:find("limited") then
				return true
			end
		end
	end

	return false
end

local function getHorseColor(model)
	local bestPart, bestVolume = nil, 0

	for _, d in ipairs(model:GetDescendants()) do
		if d:IsA("BasePart") and d.Transparency < 1 and d.Name ~= "HumanoidRootPart" then
			local vol = d.Size.X * d.Size.Y * d.Size.Z
			if vol > bestVolume then
				bestVolume = vol
				bestPart = d
			end
		end
	end

	if bestPart then
		return bestPart.Color
	end

	return Color3.fromRGB(200, 200, 200)
end

local function debugHorse(model)
	print("========== DEBUG CHEVAL : " .. model.Name .. " ==========")

	print("-- Attributs --")
	for name, value in pairs(model:GetAttributes()) do
		print(name, "=", tostring(value))
	end

	print("-- Tags CollectionService --")
	for _, tag in ipairs(CollectionService:GetTags(model)) do
		print(tag)
	end

	print("-- Values imbriquées --")
	for _, d in ipairs(model:GetDescendants()) do
		if d:IsA("StringValue") or d:IsA("BoolValue") or d:IsA("NumberValue") then
			print(d.ClassName, d.Name, "=", tostring(d.Value))
		end
	end

	print("========== FIN DEBUG (regarde F9 > Client Logs) ==========")
end

local function safeConnect(signal, func)
	local conn = signal:Connect(func)
	table.insert(connections, conn)
	return conn
end

local function setupCharacter(char)
	Character = char
	Humanoid = char:WaitForChild("Humanoid")
	Humanoid.WalkSpeed = desiredWalkSpeed
end

setupCharacter(Player.Character or Player.CharacterAdded:Wait())
safeConnect(Player.CharacterAdded, setupCharacter)

local GUI = Instance.new("ScreenGui")
GUI.Name = "TeleportGUI"
GUI.ResetOnSpawn = false
GUI.Parent = Player:WaitForChild("PlayerGui")

-- ICONE REDUITE

local MinimizedIcon = Instance.new("TextButton")
MinimizedIcon.Name = "MinimizedIcon"
MinimizedIcon.Size = UDim2.new(0, 48, 0, 48)
MinimizedIcon.Position = UDim2.new(0, 20, 0, 100)
MinimizedIcon.Text = "🐴"
MinimizedIcon.TextSize = 22
MinimizedIcon.AutoButtonColor = false
MinimizedIcon.Visible = false
MinimizedIcon.ZIndex = 20
MinimizedIcon.Parent = GUI

local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(1, 0)
IconCorner.Parent = MinimizedIcon

local IconStroke = Instance.new("UIStroke")
IconStroke.Thickness = 2
IconStroke.Parent = MinimizedIcon

-- FRAME PRINCIPALE

local Frame = Instance.new("Frame")
Frame.Name = "TPFrame"
Frame.Size = UDim2.new(0, 290, 0, 430)
Frame.Position = UDim2.new(0.5, -145, 0.5, -215)
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.BorderSizePixel = 0
Frame.ClipsDescendants = true
Frame.Parent = GUI

local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0, 10)
FrameCorner.Parent = Frame

local FrameStroke = Instance.new("UIStroke")
FrameStroke.Parent = Frame

-- HEADER

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 34)
Header.BorderSizePixel = 0
Header.Parent = Frame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -70, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.Text = "TP Horse"
TitleLabel.Font = Enum.Font.SourceSansSemibold
TitleLabel.TextSize = 17
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = Header

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 26, 0, 26)
MinimizeButton.Position = UDim2.new(1, -62, 0, 4)
MinimizeButton.Text = "—"
MinimizeButton.Font = Enum.Font.SourceSansBold
MinimizeButton.TextSize = 16
MinimizeButton.AutoButtonColor = false
MinimizeButton.Parent = Header

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 26, 0, 26)
CloseButton.Position = UDim2.new(1, -32, 0, 4)
CloseButton.Text = "X"
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 16
CloseButton.AutoButtonColor = false
CloseButton.Parent = Header

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinimizeButton
local MinStroke = Instance.new("UIStroke")
MinStroke.Parent = MinimizeButton

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton
local CloseStroke = Instance.new("UIStroke")
CloseStroke.Parent = CloseButton

-- TABS

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, 0, 0, 30)
TabBar.Position = UDim2.new(0, 0, 0, 34)
TabBar.BackgroundTransparency = 1
TabBar.Parent = Frame

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Parent = TabBar

local function createTabButton(name)
	local btn = Instance.new("TextButton")
	btn.Name = name .. "Tab"
	btn.Size = UDim2.new(1/3, 0, 1, 0)
	btn.Text = name
	btn.Font = Enum.Font.SourceSansSemibold
	btn.TextSize = 14
	btn.AutoButtonColor = false
	btn.BackgroundTransparency = 1
	btn.Parent = TabBar

	local underline = Instance.new("Frame")
	underline.Name = "Underline"
	underline.Size = UDim2.new(1, -20, 0, 2)
	underline.Position = UDim2.new(0, 10, 1, -2)
	underline.BorderSizePixel = 0
	underline.Parent = btn

	return btn
end

local TabChevauxBtn = createTabButton("Chevaux")
local TabIlesBtn = createTabButton("Îles")
local TabOptionsBtn = createTabButton("Options")

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, 0, 1, -64)
ContentArea.Position = UDim2.new(0, 0, 0, 64)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = Frame

-- === TAB CHEVAUX ===

local TabChevaux = Instance.new("Frame")
TabChevaux.Size = UDim2.new(1, 0, 1, 0)
TabChevaux.BackgroundTransparency = 1
TabChevaux.Parent = ContentArea

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -70, 0, 34)
StatusLabel.Position = UDim2.new(0, 8, 0, 4)
StatusLabel.Font = Enum.Font.SourceSans
StatusLabel.TextSize = 12
StatusLabel.TextWrapped = true
StatusLabel.TextYAlignment = Enum.TextYAlignment.Top
StatusLabel.BackgroundTransparency = 1
StatusLabel.Parent = TabChevaux

-- switch ESP (pill toggle)

local ESPSwitchLabel = Instance.new("TextLabel")
ESPSwitchLabel.Size = UDim2.new(0, 56, 0, 12)
ESPSwitchLabel.Position = UDim2.new(1, -62, 0, 2)
ESPSwitchLabel.Text = "Révéler"
ESPSwitchLabel.Font = Enum.Font.SourceSans
ESPSwitchLabel.TextSize = 10
ESPSwitchLabel.BackgroundTransparency = 1
ESPSwitchLabel.Parent = TabChevaux

local ESPSwitch = Instance.new("TextButton")
ESPSwitch.Size = UDim2.new(0, 40, 0, 20)
ESPSwitch.Position = UDim2.new(1, -54, 0, 16)
ESPSwitch.Text = ""
ESPSwitch.AutoButtonColor = false
ESPSwitch.Parent = TabChevaux

local ESPSwitchCorner = Instance.new("UICorner")
ESPSwitchCorner.CornerRadius = UDim.new(1, 0)
ESPSwitchCorner.Parent = ESPSwitch

local ESPKnob = Instance.new("Frame")
ESPKnob.Size = UDim2.new(0, 16, 0, 16)
ESPKnob.Position = UDim2.new(1, -18, 0.5, -8)
ESPKnob.Parent = ESPSwitch

local ESPKnobCorner = Instance.new("UICorner")
ESPKnobCorner.CornerRadius = UDim.new(1, 0)
ESPKnobCorner.Parent = ESPKnob

local WarningLabel = Instance.new("TextLabel")
WarningLabel.Size = UDim2.new(1, -16, 0, 20)
WarningLabel.Position = UDim2.new(0, 8, 0, 40)
WarningLabel.Text = "..."
WarningLabel.Font = Enum.Font.SourceSansSemibold
WarningLabel.TextSize = 12
WarningLabel.BorderSizePixel = 0
WarningLabel.Visible = false
WarningLabel.Parent = TabChevaux

local WarningCorner = Instance.new("UICorner")
WarningCorner.CornerRadius = UDim.new(0, 5)
WarningCorner.Parent = WarningLabel

local HorseList = Instance.new("ScrollingFrame")
HorseList.Name = "HorseList"
HorseList.Position = UDim2.new(0, 8, 0, 64)
HorseList.Size = UDim2.new(1, -16, 1, -108)
HorseList.BackgroundTransparency = 0.2
HorseList.BorderSizePixel = 0
HorseList.ScrollBarThickness = 5
HorseList.Parent = TabChevaux

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 3)
ListLayout.Parent = HorseList

local TeleportButton = Instance.new("TextButton")
TeleportButton.Size = UDim2.new(0.33, -8, 0, 30)
TeleportButton.Position = UDim2.new(0, 8, 1, -40)
TeleportButton.Text = "TP"
TeleportButton.Font = Enum.Font.SourceSansSemibold
TeleportButton.TextSize = 13
TeleportButton.AutoButtonColor = false
TeleportButton.Parent = TabChevaux

local RefreshButton = Instance.new("TextButton")
RefreshButton.Size = UDim2.new(0.33, -8, 0, 30)
RefreshButton.Position = UDim2.new(0.335, 0, 1, -40)
RefreshButton.Text = "Busca"
RefreshButton.Font = Enum.Font.SourceSansSemibold
RefreshButton.TextSize = 13
RefreshButton.AutoButtonColor = false
RefreshButton.Parent = TabChevaux

local DebugButton = Instance.new("TextButton")
DebugButton.Size = UDim2.new(0.33, -8, 0, 30)
DebugButton.Position = UDim2.new(0.67, 0, 1, -40)
DebugButton.Text = "Debug"
DebugButton.Font = Enum.Font.SourceSansSemibold
DebugButton.TextSize = 13
DebugButton.AutoButtonColor = false
DebugButton.Parent = TabChevaux

for _, b in ipairs({TeleportButton, RefreshButton, DebugButton}) do
	local c = Instance.new("UICorner")
	c.Parent = b
	local s = Instance.new("UIStroke")
	s.Parent = b
end

-- === TAB ILES ===

local TabIles = Instance.new("Frame")
TabIles.Size = UDim2.new(1, 0, 1, 0)
TabIles.BackgroundTransparency = 1
TabIles.Visible = false
TabIles.Parent = ContentArea

local IslandLabel = Instance.new("TextLabel")
IslandLabel.Size = UDim2.new(1, -16, 0, 20)
IslandLabel.Position = UDim2.new(0, 8, 0, 10)
IslandLabel.Text = "Île : Recherche..."
IslandLabel.Font = Enum.Font.SourceSans
IslandLabel.TextSize = 13
IslandLabel.BackgroundTransparency = 1
IslandLabel.TextXAlignment = Enum.TextXAlignment.Left
IslandLabel.Parent = TabIles

local IslandsScroll = Instance.new("ScrollingFrame")
IslandsScroll.Position = UDim2.new(0, 8, 0, 40)
IslandsScroll.Size = UDim2.new(1, -16, 1, -90)
IslandsScroll.BackgroundTransparency = 0.2
IslandsScroll.BorderSizePixel = 0
IslandsScroll.ScrollBarThickness = 5
IslandsScroll.Parent = TabIles

local IslandsLayout = Instance.new("UIListLayout")
IslandsLayout.Padding = UDim.new(0, 3)
IslandsLayout.Parent = IslandsScroll

local IslandNextButton = Instance.new("TextButton")
IslandNextButton.Size = UDim2.new(1, -16, 0, 32)
IslandNextButton.Position = UDim2.new(0, 8, 1, -42)
IslandNextButton.Text = "Île suivante →"
IslandNextButton.Font = Enum.Font.SourceSansSemibold
IslandNextButton.TextSize = 14
IslandNextButton.AutoButtonColor = false
IslandNextButton.Parent = TabIles

local IslandNextCorner = Instance.new("UICorner")
IslandNextCorner.Parent = IslandNextButton
local IslandNextStroke = Instance.new("UIStroke")
IslandNextStroke.Parent = IslandNextButton

-- === TAB OPTIONS ===

local TabOptions = Instance.new("Frame")
TabOptions.Size = UDim2.new(1, 0, 1, 0)
TabOptions.BackgroundTransparency = 1
TabOptions.Visible = false
TabOptions.Parent = ContentArea

local ThemeButton = Instance.new("TextButton")
ThemeButton.Size = UDim2.new(1, -16, 0, 32)
ThemeButton.Position = UDim2.new(0, 8, 0, 10)
ThemeButton.Text = "Changer thème"
ThemeButton.Font = Enum.Font.SourceSansSemibold
ThemeButton.TextSize = 14
ThemeButton.AutoButtonColor = false
ThemeButton.Parent = TabOptions

local ThemeCorner = Instance.new("UICorner")
ThemeCorner.Parent = ThemeButton
local ThemeStroke = Instance.new("UIStroke")
ThemeStroke.Parent = ThemeButton

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(1, -16, 0, 18)
SpeedLabel.Position = UDim2.new(0, 8, 0, 54)
SpeedLabel.Text = "Vitesse : " .. desiredWalkSpeed
SpeedLabel.Font = Enum.Font.SourceSansSemibold
SpeedLabel.TextSize = 13
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = TabOptions

local SpeedTrack = Instance.new("TextButton")
SpeedTrack.Size = UDim2.new(1, -16, 0, 14)
SpeedTrack.Position = UDim2.new(0, 8, 0, 76)
SpeedTrack.Text = ""
SpeedTrack.AutoButtonColor = false
SpeedTrack.Parent = TabOptions

local SpeedTrackCorner = Instance.new("UICorner")
SpeedTrackCorner.CornerRadius = UDim.new(1, 0)
SpeedTrackCorner.Parent = SpeedTrack

local SpeedFill = Instance.new("Frame")
SpeedFill.Size = UDim2.new((desiredWalkSpeed - SPEED_MIN) / (SPEED_MAX - SPEED_MIN), 0, 1, 0)
SpeedFill.BorderSizePixel = 0
SpeedFill.Parent = SpeedTrack

local SpeedFillCorner = Instance.new("UICorner")
SpeedFillCorner.CornerRadius = UDim.new(1, 0)
SpeedFillCorner.Parent = SpeedFill

local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, -16, 0, 160)
InfoLabel.Position = UDim2.new(0, 8, 0, 100)
InfoLabel.Text = "Z = TP vers le cheval sélectionné\nX = Refresh\nC = Thème\nV = Île suivante\n\nSélectionne un cheval dans la liste (rond à gauche) puis appuie sur TP.\nLe halo autour d'un cheval prend sa vraie couleur.\nDebug affiche les attributs du cheval sélectionné dans la console (F9)."
InfoLabel.Font = Enum.Font.SourceSans
InfoLabel.TextSize = 12
InfoLabel.TextWrapped = true
InfoLabel.TextYAlignment = Enum.TextYAlignment.Top
InfoLabel.BackgroundTransparency = 1
InfoLabel.Parent = TabOptions

-- DRAG BAR + RESIZE

local DragBar = Instance.new("TextButton")
DragBar.Name = "DragBar"
DragBar.Text = "≡"
DragBar.TextSize = 12
DragBar.Font = Enum.Font.SourceSansBold
DragBar.AutoButtonColor = false
DragBar.Size = UDim2.new(1, 0, 0, 14)
DragBar.Position = UDim2.new(0, 0, 1, -14)
DragBar.Parent = Frame

local ResizeHandle = Instance.new("TextButton")
ResizeHandle.Name = "ResizeHandle"
ResizeHandle.Size = UDim2.new(0, 14, 0, 14)
ResizeHandle.Position = UDim2.new(1, -14, 1, -14)
ResizeHandle.Text = "◢"
ResizeHandle.TextSize = 12
ResizeHandle.Font = Enum.Font.SourceSansBold
ResizeHandle.BackgroundTransparency = 1
ResizeHandle.TextColor3 = Color3.fromRGB(220, 220, 220)
ResizeHandle.AutoButtonColor = false
ResizeHandle.ZIndex = 10
ResizeHandle.Parent = Frame

local MIN_SIZE = Vector2.new(260, 380)
local MAX_SIZE = Vector2.new(700, 750)

local validModels = {}
local currentModelIndex = 1
local islandList = {}
local currentIslandIdx = 0
local radioRefs = {}

local function getHorseBreed(model)

	local attributeNames = { "Breed", "HorseBreed", "BreedName", "HorseName", "Species", "Type" }

	for _, attributeName in ipairs(attributeNames) do
		local value = model:GetAttribute(attributeName)
		if value ~= nil and typeof(value) == "string" and value ~= "" then
			return value
		end
	end

	for _, descendant in ipairs(model:GetDescendants()) do
		if descendant:IsA("StringValue") then
			local name = descendant.Name:lower()
			if name == "breed" or name == "horsebreed" or name == "breedname"
				or name == "horsename" or name == "species" or name == "type" then
				if descendant.Value ~= "" then
					return descendant.Value
				end
			end
		end
	end

	for _, descendant in ipairs(model:GetDescendants()) do
		for _, attributeName in ipairs(attributeNames) do
			local value = descendant:GetAttribute(attributeName)
			if value ~= nil and typeof(value) == "string" and value ~= "" then
				return value
			end
		end
	end

	return "Race inconnue"
end

local function setTab(tabName)
	currentTab = tabName

	TabChevaux.Visible = (tabName == "Chevaux")
	TabIles.Visible = (tabName == "Îles")
	TabOptions.Visible = (tabName == "Options")

	local theme = THEMES[currentTheme]

	for _, btn in ipairs({TabChevauxBtn, TabIlesBtn, TabOptionsBtn}) do
		local active = (btn.Name == tabName .. "Tab")
		btn.TextColor3 = active and theme.TabActive or theme.TabInactive
		btn.Underline.BackgroundColor3 = active and theme.TabActive or theme.HeaderBG
	end
end

local function applyTheme(themeName)

	local theme = THEMES[themeName]
	if not theme then return end

	Frame.BackgroundColor3 = theme.FrameBG
	FrameStroke.Color = theme.StrokeColor
	Header.BackgroundColor3 = theme.HeaderBG

	TitleLabel.TextColor3 = theme.TextPrimary
	StatusLabel.TextColor3 = theme.TextPrimary
	IslandLabel.TextColor3 = theme.TextSecondary
	InfoLabel.TextColor3 = theme.TextSecondary
	ESPSwitchLabel.TextColor3 = theme.TextSecondary
	SpeedLabel.TextColor3 = theme.TextPrimary

	WarningLabel.TextColor3 = theme.TextPrimary
	WarningStroke.Color = theme.StrokeColor

	for _, b in ipairs({TeleportButton, RefreshButton, DebugButton, ThemeButton, IslandNextButton, MinimizeButton, CloseButton}) do
		b.BackgroundColor3 = theme.ButtonMain
		b.TextColor3 = theme.TextPrimary
	end

	TeleportButton.BackgroundColor3 = theme.ButtonAccent
	IslandNextButton.BackgroundColor3 = theme.ButtonAccent
	CloseButton.BackgroundColor3 = theme.ButtonClose

	ESPSwitch.BackgroundColor3 = espEnabled and theme.ButtonAccent or theme.ButtonMain
	ESPKnob.BackgroundColor3 = theme.TextPrimary

	SpeedTrack.BackgroundColor3 = theme.ButtonMain
	SpeedFill.BackgroundColor3 = theme.ButtonAccent

	DragBar.BackgroundColor3 = theme.HeaderBG
	DragBar.TextColor3 = theme.TextSecondary

	MinimizedIcon.BackgroundColor3 = theme.ButtonAccent
	IconStroke.Color = theme.StrokeColor

	setTab(currentTab)

	currentTheme = themeName
end

local function refreshIslandList()
	islandList = {}
	local islandsFolder = workspace:FindFirstChild("Islands")
	if islandsFolder then
		for _, isl in ipairs(islandsFolder:GetChildren()) do
			table.insert(islandList, isl)
		end
	end

	for _, c in ipairs(IslandsScroll:GetChildren()) do
		if c:IsA("TextButton") then c:Destroy() end
	end

	IslandsScroll.CanvasSize = UDim2.new(0, 0, 0, #islandList * 27)

	for i, isl in ipairs(islandList) do
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, -6, 0, 24)
		btn.Text = i .. "  " .. isl.Name
		btn.TextSize = 12
		btn.Font = Enum.Font.SourceSans
		btn.Parent = IslandsScroll

		btn.MouseButton1Click:Connect(function()
			currentIslandIdx = i - 1
		end)
	end
end

local function getIslandAnchor(islandModel)
	if islandModel.PrimaryPart then
		return islandModel.PrimaryPart.Position
	end
	for _, d in ipairs(islandModel:GetDescendants()) do
		if d:IsA("BasePart") then
			return d.Position
		end
	end
	return nil
end

local function findValidModels()

	local islandsFolder = workspace:FindFirstChild("Islands")
	if not islandsFolder then
		return {}, "Erreur : Islands"
	end

	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("Highlight") and obj.Name == "TeleportHighlight" then
			obj:Destroy()
		end
	end

	local islandContainer
	local current = Character and Character.Parent

	while current and current ~= islandsFolder and current ~= workspace do
		if current.Parent == islandsFolder then
			islandContainer = current
			break
		end
		current = current.Parent
	end

	if not islandContainer then
		return {}, "Erreur : île inconnue"
	end

	local wildHorses = {}
	local otherHorses = {}
	local theme = THEMES[currentTheme]

	for _, descendant in ipairs(islandContainer:GetDescendants()) do

		if descendant:IsA("Model")
			and descendant:FindFirstChildOfClass("Humanoid")
			and descendant:FindFirstChild("HumanoidRootPart")
			and descendant.Name:match("^%b{}$") then

			local rootPart = descendant:FindFirstChild("HumanoidRootPart")
			local captureProgress = descendant:FindFirstChild("CaptureProgress", true)
			local isWild = captureProgress ~= nil
			local breed = getHorseBreed(descendant)
			local isEvent = isEventModel(descendant, breed)
			local mainColor = getHorseColor(descendant)

			if espEnabled then
				local highlight = Instance.new("Highlight")
				highlight.Name = "TeleportHighlight"
				highlight.FillColor = mainColor
				highlight.OutlineColor = isEvent and theme.EventColor
					or (isWild and theme.WarningBG_Wild or Color3.fromRGB(255, 255, 255))
				highlight.FillTransparency = 0.45
				highlight.OutlineTransparency = 0
				highlight.Adornee = descendant
				highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				highlight.Parent = descendant
			end

			local horseData = {
				Model = descendant,
				RootPart = rootPart,
				IsWild = isWild,
				Breed = breed,
				IsEvent = isEvent,
				Color = mainColor
			}

			if isWild then
				table.insert(wildHorses, horseData)
			else
				table.insert(otherHorses, horseData)
			end
		end
	end

	local allHorses = {}
	for _, horse in ipairs(wildHorses) do table.insert(allHorses, horse) end
	for _, horse in ipairs(otherHorses) do table.insert(allHorses, horse) end

	return allHorses, islandContainer.Name
end

local lastStatusCheck = 0
local STATUS_INTERVAL = 0.25

local function checkCurrentModelStatus()

	if not GUI.Enabled or #validModels == 0 or currentModelIndex > #validModels then
		WarningLabel.Visible = false
		return
	end

	local now = os.clock()
	if now - lastStatusCheck < STATUS_INTERVAL then return end
	lastStatusCheck = now

	local modelInfo = validModels[currentModelIndex]
	local currentModel = modelInfo.Model
	if not currentModel or not currentModel.Parent then return end

	local captureProgress = currentModel:FindFirstChild("CaptureProgress", true)
	local isWildNow = captureProgress ~= nil
	modelInfo.IsWild = isWildNow

	local theme = THEMES[currentTheme]

	if modelInfo.IsEvent then
		WarningLabel.Text = isWildNow and "EVENT (SAUVAGE)" or "EVENT (DOMESTIQUE)"
		WarningLabel.BackgroundColor3 = theme.EventColor
	elseif isWildNow then
		WarningLabel.Text = "CHEVAL SAUVAGE"
		WarningLabel.BackgroundColor3 = theme.WarningBG_Wild
	else
		WarningLabel.Text = "CHEVAL DOMESTIQUE"
		WarningLabel.BackgroundColor3 = theme.WarningBG_Other
	end

	WarningLabel.Visible = true
end

local function updateGUIStatus()

	if #validModels == 0 then
		StatusLabel.Text = "Aucun cheval trouvé"
		WarningLabel.Visible = false
		return
	end

	local modelInfo = validModels[currentModelIndex]
	if not modelInfo.RootPart then return end

	local pos = modelInfo.RootPart.Position

	StatusLabel.Text = string.format(
		"Sélection : %s (%s)\nPos : %.0f %.0f %.0f",
		modelInfo.Breed,
		modelInfo.IsEvent and "EVENT" or "Basique",
		pos.X, pos.Y, pos.Z
	)

	checkCurrentModelStatus()
end

local function updateRadios()
	local theme = THEMES[currentTheme]
	for index, radio in pairs(radioRefs) do
		if index == currentModelIndex then
			radio.BackgroundColor3 = theme.ButtonAccent
			radio.BackgroundTransparency = 0
		else
			radio.BackgroundColor3 = theme.ButtonMain
			radio.BackgroundTransparency = 0.5
		end
	end
end

local function buildThumbnail(viewport, model, fallbackColor)

	local ok = pcall(function()
		local worldModel = Instance.new("WorldModel")
		worldModel.Parent = viewport

		local clone = model:Clone()

		for _, d in ipairs(clone:GetDescendants()) do
			if d:IsA("Script") or d:IsA("LocalScript") or d:IsA("Humanoid") or d:IsA("Highlight") then
				d:Destroy()
			end
		end

		clone.Parent = worldModel

		local cf, size = clone:GetBoundingBox()
		local maxExtent = math.max(size.X, size.Y, size.Z, 1)
		local camDist = maxExtent * 1.7 + 2

		local camera = Instance.new("Camera")
		camera.FieldOfView = 45
		camera.CFrame = CFrame.new(
			cf.Position + Vector3.new(camDist * 0.6, camDist * 0.45, camDist * 0.6),
			cf.Position
		)
		camera.Parent = viewport
		viewport.CurrentCamera = camera
	end)

	if not ok then
		viewport.BackgroundColor3 = fallbackColor
		viewport.BackgroundTransparency = 0
	end
end

local function createHorseList()

	for _, child in ipairs(HorseList:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end

	radioRefs = {}

	HorseList.CanvasSize = UDim2.new(0, 0, 0, #validModels * 40)

	local theme = THEMES[currentTheme]

	for index, horse in ipairs(validModels) do

		local row = Instance.new("TextButton")
		row.Size = UDim2.new(1, -4, 0, 37)
		row.Text = ""
		row.AutoButtonColor = false
		row.BackgroundColor3 = theme.RowBG
		row.BackgroundTransparency = 0.3
		row.Parent = HorseList

		local rowCorner = Instance.new("UICorner")
		rowCorner.CornerRadius = UDim.new(0, 6)
		rowCorner.Parent = row

		local radio = Instance.new("Frame")
		radio.Size = UDim2.new(0, 14, 0, 14)
		radio.Position = UDim2.new(0, 5, 0.5, -7)
		radio.Parent = row

		local radioCorner = Instance.new("UICorner")
		radioCorner.CornerRadius = UDim.new(1, 0)
		radioCorner.Parent = radio

		local radioStroke = Instance.new("UIStroke")
		radioStroke.Color = theme.StrokeColor
		radioStroke.Parent = radio

		radioRefs[index] = radio

		local viewport = Instance.new("ViewportFrame")
		viewport.Size = UDim2.new(0, 32, 0, 32)
		viewport.Position = UDim2.new(0, 24, 0.5, -16)
		viewport.BackgroundTransparency = 0.5
		viewport.Parent = row

		local vpCorner = Instance.new("UICorner")
		vpCorner.CornerRadius = UDim.new(0, 6)
		vpCorner.Parent = viewport

		buildThumbnail(viewport, horse.Model, horse.Color)

		local nameLabel = Instance.new("TextLabel")
		nameLabel.Size = UDim2.new(1, -66, 0, 16)
		nameLabel.Position = UDim2.new(0, 62, 0, 3)
		nameLabel.Text = horse.Breed .. (horse.IsEvent and " ★" or "")
		nameLabel.Font = Enum.Font.SourceSansSemibold
		nameLabel.TextSize = 12
		nameLabel.TextColor3 = horse.IsEvent and theme.EventColor or theme.TextPrimary
		nameLabel.TextXAlignment = Enum.TextXAlignment.Left
		nameLabel.BackgroundTransparency = 1
		nameLabel.Parent = row

		local distance = math.floor(
			(Character.HumanoidRootPart.Position - horse.RootPart.Position).Magnitude
		)

		local tagLabel = Instance.new("TextLabel")
		tagLabel.Size = UDim2.new(1, -66, 0, 14)
		tagLabel.Position = UDim2.new(0, 62, 0, 19)
		tagLabel.Text = distance .. "m | " .. (horse.IsWild and "Sauvage" or "Domestique")
		tagLabel.Font = Enum.Font.SourceSans
		tagLabel.TextSize = 10
		tagLabel.TextColor3 = theme.TextSecondary
		tagLabel.TextXAlignment = Enum.TextXAlignment.Left
		tagLabel.BackgroundTransparency = 1
		tagLabel.Parent = row

		row.MouseButton1Click:Connect(function()
			currentModelIndex = index
			updateRadios()
			updateGUIStatus()
		end)
	end

	updateRadios()
end

local function refreshHorseList()

	if not GUI.Enabled then return end

	local islandName
	validModels, islandName = findValidModels()
	currentModelIndex = 1

	IslandLabel.Text = "Île : " .. (islandName or "Inconnue")

	updateGUIStatus()
	createHorseList()
end

local function teleportToSelectedHorse()

	if not GUI.Enabled or #validModels == 0 then return end

	local target = validModels[currentModelIndex]

	if target and target.Model and target.RootPart and Character then
		Character:PivotTo(CFrame.new(target.RootPart.Position + Vector3.new(0, 3, 0)))
		updateGUIStatus()
	end
end

local function teleportToNextIsland()

	if #islandList == 0 then
		refreshIslandList()
	end

	if #islandList == 0 then
		IslandLabel.Text = "Île : aucune trouvée"
		return
	end

	currentIslandIdx = (currentIslandIdx % #islandList) + 1
	local isl = islandList[currentIslandIdx]
	local pos = getIslandAnchor(isl)

	if pos and Character then
		Character:PivotTo(CFrame.new(pos + Vector3.new(0, 10, 0)))
		task.wait(0.3)
		refreshHorseList()
	end
end

local function toggleTheme()
	applyTheme(currentTheme == "Discord" and "Western" or "Discord")
	checkCurrentModelStatus()
	createHorseList()
end

local function toggleESP()
	espEnabled = not espEnabled

	local theme = THEMES[currentTheme]
	ESPSwitch.BackgroundColor3 = espEnabled and theme.ButtonAccent or theme.ButtonMain
	ESPKnob.Position = espEnabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)

	if not espEnabled then
		for _, obj in ipairs(workspace:GetDescendants()) do
			if obj:IsA("Highlight") and obj.Name == "TeleportHighlight" then
				obj:Destroy()
			end
		end
	else
		refreshHorseList()
	end
end

local function updateSpeedFromInput(input)
	local relX = input.Position.X - SpeedTrack.AbsolutePosition.X
	local pct = math.clamp(relX / SpeedTrack.AbsoluteSize.X, 0, 1)
	local speed = math.floor(SPEED_MIN + (SPEED_MAX - SPEED_MIN) * pct)

	desiredWalkSpeed = speed
	SpeedFill.Size = UDim2.new(pct, 0, 1, 0)
	SpeedLabel.Text = "Vitesse : " .. speed

	if Humanoid then
		Humanoid.WalkSpeed = speed
	end
end

local function toggleMinimize()
	Frame.Visible = false
	MinimizedIcon.Visible = true
end

local function restoreFromIcon()
	Frame.Visible = true
	MinimizedIcon.Visible = false
end

local function cleanup()

	GUI.Enabled = false

	for _, conn in ipairs(connections) do
		if conn:IsConnected() then
			conn:Disconnect()
		end
	end

	connections = {}

	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("Highlight") and obj.Name == "TeleportHighlight" then
			obj:Destroy()
		end
	end

	GUI:Destroy()
end

-- DRAG (titre + barre du bas)

local dragging = false
local dragStart
local startPosition

local function beginDrag(input)
	dragging = true
	dragStart = input.Position
	startPosition = Frame.Position
end

local function updateDrag(input)
	local delta = input.Position - dragStart
	Frame.Position = UDim2.new(
		startPosition.X.Scale, startPosition.X.Offset + delta.X,
		startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
	)
end

safeConnect(Header.InputBegan, function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
		beginDrag(input)
	end
end)

safeConnect(DragBar.InputBegan, function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
		beginDrag(input)
	end
end)

safeConnect(UIS.InputChanged, function(input)
	if not dragging then return end
	if input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch then
		updateDrag(input)
	end
end)

safeConnect(UIS.InputEnded, function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

-- DRAG ICONE

local iconDragging = false
local iconDragStart
local iconStartPos

safeConnect(MinimizedIcon.InputBegan, function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
		iconDragging = true
		iconDragStart = input.Position
		iconStartPos = MinimizedIcon.Position
	end
end)

safeConnect(UIS.InputChanged, function(input)
	if not iconDragging then return end
	if input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch then
		local delta = input.Position - iconDragStart
		MinimizedIcon.Position = UDim2.new(
			iconStartPos.X.Scale, iconStartPos.X.Offset + delta.X,
			iconStartPos.Y.Scale, iconStartPos.Y.Offset + delta.Y
		)
	end
end)

safeConnect(UIS.InputEnded, function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
		iconDragging = false
	end
end)

-- REDIMENSIONNEMENT

local resizing = false
local resizeStart
local startSize

safeConnect(ResizeHandle.InputBegan, function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
		resizing = true
		resizeStart = input.Position
		startSize = Frame.Size
	end
end)

safeConnect(UIS.InputChanged, function(input)
	if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch) then

		local delta = input.Position - resizeStart
		local newWidth = math.clamp(startSize.X.Offset + delta.X, MIN_SIZE.X, MAX_SIZE.X)
		local newHeight = math.clamp(startSize.Y.Offset + delta.Y, MIN_SIZE.Y, MAX_SIZE.Y)
		Frame.Size = UDim2.new(0, newWidth, 0, newHeight)
	end
end)

safeConnect(UIS.InputEnded, function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
		resizing = false
	end
end)

-- SLIDER VITESSE

local speedDragging = false

safeConnect(SpeedTrack.InputBegan, function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
		speedDragging = true
		updateSpeedFromInput(input)
	end
end)

safeConnect(UIS.InputChanged, function(input)
	if speedDragging and (input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch) then
		updateSpeedFromInput(input)
	end
end)

safeConnect(UIS.InputEnded, function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
		speedDragging = false
	end
end)

safeConnect(TeleportButton.MouseButton1Click, teleportToSelectedHorse)
safeConnect(RefreshButton.MouseButton1Click, refreshHorseList)
safeConnect(ThemeButton.MouseButton1Click, toggleTheme)
safeConnect(IslandNextButton.MouseButton1Click, teleportToNextIsland)
safeConnect(ESPSwitch.MouseButton1Click, toggleESP)
safeConnect(CloseButton.MouseButton1Click, cleanup)
safeConnect(MinimizeButton.MouseButton1Click, toggleMinimize)
safeConnect(MinimizedIcon.MouseButton1Click, restoreFromIcon)

safeConnect(DebugButton.MouseButton1Click, function()
	if #validModels > 0 and validModels[currentModelIndex] then
		debugHorse(validModels[currentModelIndex].Model)
	end
end)

safeConnect(TabChevauxBtn.MouseButton1Click, function() setTab("Chevaux") end)
safeConnect(TabIlesBtn.MouseButton1Click, function() setTab("Îles") end)
safeConnect(TabOptionsBtn.MouseButton1Click, function() setTab("Options") end)

safeConnect(UIS.InputBegan, function(input, gameProcessed)
	if gameProcessed or not GUI.Enabled then return end

	if input.KeyCode == Enum.KeyCode.Z then
		teleportToSelectedHorse()
	elseif input.KeyCode == Enum.KeyCode.X then
		refreshHorseList()
	elseif input.KeyCode == Enum.KeyCode.C then
		toggleTheme()
	elseif input.KeyCode == Enum.KeyCode.V then
		teleportToNextIsland()
	end
end)

safeConnect(RunService.Heartbeat, checkCurrentModelStatus)

applyTheme(currentTheme)
setTab("Chevaux")
refreshIslandList()

GUI.Enabled = true

refreshHorseList()
