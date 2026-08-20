local Player = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Character
local Humanoid
local connections = {}

local currentTheme = "Discord"

local THEMES = {
	Discord = {
		FrameBG = Color3.fromRGB(54, 57, 63),
		TextPrimary = Color3.fromRGB(255, 255, 255),
		TextSecondary = Color3.fromRGB(180, 180, 180),
		ButtonTP = Color3.fromRGB(88, 101, 242),
		ButtonRefresh = Color3.fromRGB(67, 181, 129),
		ButtonClose = Color3.fromRGB(237, 66, 69),
		ButtonTheme = Color3.fromRGB(250, 166, 26),
		ButtonIsland = Color3.fromRGB(114, 137, 218),
		WarningBG_Wild = Color3.fromRGB(67, 181, 129),
		WarningBG_Other = Color3.fromRGB(255, 69, 0),
		WarningText = Color3.fromRGB(255, 255, 255),
		EventColor = Color3.fromRGB(235, 130, 255),
		DragBarBG = Color3.fromRGB(40, 42, 46),
		CornerRadius = UDim.new(0, 8),
		ButtonCorner = UDim.new(0, 6),
		StrokeColor = Color3.fromRGB(40, 42, 46),
		StrokeThickness = 1,
		StrokeTransparency = 0
	},

	Western = {
		FrameBG = Color3.fromRGB(206, 160, 109),
		TextPrimary = Color3.fromRGB(255, 255, 255),
		TextSecondary = Color3.fromRGB(255, 255, 255),
		ButtonTP = Color3.fromRGB(143, 109, 74),
		ButtonRefresh = Color3.fromRGB(143, 109, 74),
		ButtonClose = Color3.fromRGB(255, 0, 0),
		ButtonTheme = Color3.fromRGB(143, 109, 74),
		ButtonIsland = Color3.fromRGB(120, 90, 60),
		WarningBG_Wild = Color3.fromRGB(50, 150, 50),
		WarningBG_Other = Color3.fromRGB(165, 42, 42),
		WarningText = Color3.fromRGB(255, 255, 255),
		EventColor = Color3.fromRGB(186, 85, 211),
		DragBarBG = Color3.fromRGB(155, 119, 81),
		CornerRadius = UDim.new(0, 15),
		ButtonCorner = UDim.new(0, 10),
		StrokeColor = Color3.fromRGB(155, 119, 81),
		StrokeThickness = 1,
		StrokeTransparency = 0
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

local function isEventBreed(breed)
	if not breed then return false end
	local lower = breed:lower()
	if EVENT_BREEDS[lower] then return true end
	if lower:find("event") then return true end
	return false
end

local function safeConnect(signal, func)
	local conn = signal:Connect(func)
	table.insert(connections, conn)
	return conn
end

local function setupCharacter(char)
	Character = char
	Humanoid = char:WaitForChild("Humanoid")
end

setupCharacter(Player.Character or Player.CharacterAdded:Wait())
safeConnect(Player.CharacterAdded, setupCharacter)

local GUI = Instance.new("ScreenGui")
GUI.Name = "TeleportGUI"
GUI.ResetOnSpawn = false
GUI.Parent = Player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Name = "TPFrame"
Frame.Size = UDim2.new(0, 250, 0, 340)
Frame.Position = UDim2.new(0.5, -125, 0.5, -170)
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.BorderSizePixel = 0
Frame.ClipsDescendants = true
Frame.Parent = GUI

local FrameCorner = Instance.new("UICorner")
FrameCorner.Parent = Frame

local FrameStroke = Instance.new("UIStroke")
FrameStroke.Parent = Frame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -36, 0, 22)
TitleLabel.Position = UDim2.new(0, 8, 0, 4)
TitleLabel.Text = "TP Horse"
TitleLabel.Font = Enum.Font.SourceSansSemibold
TitleLabel.TextSize = 16
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = Frame

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 22, 0, 22)
CloseButton.Position = UDim2.new(1, -28, 0, 4)
CloseButton.Text = "X"
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 14
CloseButton.AutoButtonColor = false
CloseButton.Parent = Frame

local IslandLabel = Instance.new("TextLabel")
IslandLabel.Size = UDim2.new(1, -16, 0, 14)
IslandLabel.Position = UDim2.new(0, 8, 0, 28)
IslandLabel.Text = "Île : Recherche..."
IslandLabel.Font = Enum.Font.SourceSans
IslandLabel.TextSize = 11
IslandLabel.BackgroundTransparency = 1
IslandLabel.TextXAlignment = Enum.TextXAlignment.Left
IslandLabel.Parent = Frame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -16, 0, 48)
StatusLabel.Position = UDim2.new(0, 8, 0, 44)
StatusLabel.Font = Enum.Font.SourceSans
StatusLabel.TextSize = 12
StatusLabel.TextWrapped = true
StatusLabel.TextYAlignment = Enum.TextYAlignment.Top
StatusLabel.BackgroundTransparency = 1
StatusLabel.Parent = Frame

local WarningLabel = Instance.new("TextLabel")
WarningLabel.Size = UDim2.new(1, -16, 0, 20)
WarningLabel.Position = UDim2.new(0, 8, 0, 94)
WarningLabel.Text = "..."
WarningLabel.Font = Enum.Font.SourceSansSemibold
WarningLabel.TextSize = 12
WarningLabel.BackgroundColor3 = THEMES.Discord.WarningBG_Other
WarningLabel.BorderSizePixel = 0
WarningLabel.Visible = false
WarningLabel.Parent = Frame

local WarningCorner = Instance.new("UICorner")
WarningCorner.CornerRadius = UDim.new(0, 5)
WarningCorner.Parent = WarningLabel

local WarningStroke = Instance.new("UIStroke")
WarningStroke.Parent = WarningLabel

local HorseList = Instance.new("ScrollingFrame")
HorseList.Name = "HorseList"
HorseList.Position = UDim2.new(0, 8, 0, 118)
HorseList.Size = UDim2.new(1, -16, 1, -216)
HorseList.BackgroundTransparency = 0.2
HorseList.BorderSizePixel = 0
HorseList.ScrollBarThickness = 5
HorseList.Parent = Frame

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 3)
ListLayout.Parent = HorseList

local TeleportButton = Instance.new("TextButton")
TeleportButton.Size = UDim2.new(0.5, -10, 0, 30)
TeleportButton.Position = UDim2.new(0, 8, 1, -88)
TeleportButton.Text = "TP"
TeleportButton.Font = Enum.Font.SourceSansSemibold
TeleportButton.TextSize = 14
TeleportButton.AutoButtonColor = false
TeleportButton.Parent = Frame

local RefreshButton = Instance.new("TextButton")
RefreshButton.Size = UDim2.new(0.5, -10, 0, 30)
RefreshButton.Position = UDim2.new(0.5, 2, 1, -88)
RefreshButton.Text = "Busca"
RefreshButton.Font = Enum.Font.SourceSansSemibold
RefreshButton.TextSize = 14
RefreshButton.AutoButtonColor = false
RefreshButton.Parent = Frame

local ThemeButton = Instance.new("TextButton")
ThemeButton.Size = UDim2.new(0.5, -10, 0, 30)
ThemeButton.Position = UDim2.new(0, 8, 1, -52)
ThemeButton.Text = "Tema"
ThemeButton.Font = Enum.Font.SourceSansSemibold
ThemeButton.TextSize = 14
ThemeButton.AutoButtonColor = false
ThemeButton.Parent = Frame

local IslandButton = Instance.new("TextButton")
IslandButton.Size = UDim2.new(0.5, -10, 0, 30)
IslandButton.Position = UDim2.new(0.5, 2, 1, -52)
IslandButton.Text = "Île →"
IslandButton.Font = Enum.Font.SourceSansSemibold
IslandButton.TextSize = 14
IslandButton.AutoButtonColor = false
IslandButton.Parent = Frame

local TeleportCorner = Instance.new("UICorner")
TeleportCorner.Parent = TeleportButton
local RefreshCorner = Instance.new("UICorner")
RefreshCorner.Parent = RefreshButton
local ThemeCorner = Instance.new("UICorner")
ThemeCorner.Parent = ThemeButton
local IslandCorner = Instance.new("UICorner")
IslandCorner.Parent = IslandButton
local CloseCorner = Instance.new("UICorner")
CloseCorner.Parent = CloseButton

local TeleportStroke = Instance.new("UIStroke")
TeleportStroke.Parent = TeleportButton
local RefreshStroke = Instance.new("UIStroke")
RefreshStroke.Parent = RefreshButton
local ThemeStroke = Instance.new("UIStroke")
ThemeStroke.Parent = ThemeButton
local IslandStroke = Instance.new("UIStroke")
IslandStroke.Parent = IslandButton
local CloseStroke = Instance.new("UIStroke")
CloseStroke.Parent = CloseButton

-- Barre de drag en bas de la fenêtre
local DragBar = Instance.new("TextButton")
DragBar.Name = "DragBar"
DragBar.Text = "≡"
DragBar.TextSize = 12
DragBar.Font = Enum.Font.SourceSansBold
DragBar.AutoButtonColor = false
DragBar.Size = UDim2.new(1, 0, 0, 14)
DragBar.Position = UDim2.new(0, 0, 1, -14)
DragBar.Parent = Frame

-- Poignée de redimensionnement (coin bas droit, par dessus la drag bar)
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

local MIN_SIZE = Vector2.new(230, 300)
local MAX_SIZE = Vector2.new(650, 650)

local validModels = {}
local currentModelIndex = 1

local islandList = {}
local currentIslandIdx = 0

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

local function applyTheme(themeName)

	local theme = THEMES[themeName]
	if not theme then return end

	Frame.BackgroundColor3 = theme.FrameBG
	FrameCorner.CornerRadius = theme.CornerRadius
	FrameStroke.Color = theme.StrokeColor
	FrameStroke.Thickness = theme.StrokeThickness

	TitleLabel.TextColor3 = theme.TextPrimary
	StatusLabel.TextColor3 = theme.TextPrimary
	IslandLabel.TextColor3 = theme.TextSecondary

	WarningLabel.TextColor3 = theme.WarningText
	WarningStroke.Color = theme.StrokeColor

	TeleportButton.BackgroundColor3 = theme.ButtonTP
	RefreshButton.BackgroundColor3 = theme.ButtonRefresh
	CloseButton.BackgroundColor3 = theme.ButtonClose
	ThemeButton.BackgroundColor3 = theme.ButtonTheme
	IslandButton.BackgroundColor3 = theme.ButtonIsland

	TeleportButton.TextColor3 = theme.TextPrimary
	RefreshButton.TextColor3 = theme.TextPrimary
	ThemeButton.TextColor3 = theme.TextPrimary
	IslandButton.TextColor3 = theme.TextPrimary
	CloseButton.TextColor3 = theme.TextPrimary

	TeleportCorner.CornerRadius = theme.ButtonCorner
	RefreshCorner.CornerRadius = theme.ButtonCorner
	ThemeCorner.CornerRadius = theme.ButtonCorner
	IslandCorner.CornerRadius = theme.ButtonCorner
	CloseCorner.CornerRadius = theme.ButtonCorner

	TeleportStroke.Color = theme.StrokeColor
	RefreshStroke.Color = theme.StrokeColor
	ThemeStroke.Color = theme.StrokeColor
	IslandStroke.Color = theme.StrokeColor
	CloseStroke.Color = theme.StrokeColor

	DragBar.BackgroundColor3 = theme.DragBarBG
	DragBar.TextColor3 = theme.TextSecondary

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
			local isEvent = isEventBreed(breed)

			local highlight = Instance.new("Highlight")
			highlight.Name = "TeleportHighlight"

			if isEvent then
				highlight.FillColor = theme.EventColor
			else
				highlight.FillColor = isWild and theme.WarningBG_Wild or theme.ButtonTP
			end

			highlight.OutlineColor = Color3.fromRGB(255,255,255)
			highlight.FillTransparency = 0.5
			highlight.OutlineTransparency = 0
			highlight.Adornee = descendant
			highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
			highlight.Parent = descendant

			local horseData = {
				Model = descendant,
				RootPart = rootPart,
				IsWild = isWild,
				Breed = breed,
				IsEvent = isEvent
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
		"%d/%d  %s (%s)\nPos : %.0f %.0f %.0f",
		currentModelIndex,
		#validModels,
		modelInfo.Breed,
		modelInfo.IsEvent and "EVENT" or "Basique",
		pos.X, pos.Y, pos.Z
	)

	checkCurrentModelStatus()
end

local function createHorseList()

	for _, child in ipairs(HorseList:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end

	HorseList.CanvasSize = UDim2.new(0, 0, 0, #validModels * 27)

	for index, horse in ipairs(validModels) do

		local button = Instance.new("TextButton")
		button.Size = UDim2.new(1, -6, 0, 24)
		button.TextSize = 11
		button.Font = Enum.Font.SourceSans

		local distance = math.floor(
			(Character.HumanoidRootPart.Position - horse.RootPart.Position).Magnitude
		)

		local status = horse.IsWild and "SAUV" or "DOM"
		local eventTag = horse.IsEvent and " ★" or ""

		button.Text = string.format("%d %s|%dm|%s%s", index, horse.Breed, distance, status, eventTag)

		if horse.IsEvent then
			button.TextColor3 = THEMES[currentTheme].EventColor
		end

		button.Parent = HorseList

		button.MouseButton1Click:Connect(function()
			currentModelIndex = index
			updateGUIStatus()
		end)
	end
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

local function teleportToNextModel()

	if not GUI.Enabled or #validModels == 0 then return end

	currentModelIndex += 1
	if currentModelIndex > #validModels then
		currentModelIndex = 1
	end

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

	if currentTheme == "Discord" then
		applyTheme("Western")
	else
		applyTheme("Discord")
	end

	checkCurrentModelStatus()
	createHorseList()
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

safeConnect(TitleLabel.InputBegan, function(input)
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
	if not resizing then return end
	if input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch then

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

safeConnect(TeleportButton.MouseButton1Click, teleportToNextModel)
safeConnect(RefreshButton.MouseButton1Click, refreshHorseList)
safeConnect(ThemeButton.MouseButton1Click, toggleTheme)
safeConnect(IslandButton.MouseButton1Click, teleportToNextIsland)
safeConnect(CloseButton.MouseButton1Click, cleanup)

safeConnect(UIS.InputBegan, function(input, gameProcessed)
	if gameProcessed or not GUI.Enabled then return end

	if input.KeyCode == Enum.KeyCode.Z then
		teleportToNextModel()
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
refreshIslandList()

GUI.Enabled = true

refreshHorseList()
