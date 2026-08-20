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
		WarningBG_Wild = Color3.fromRGB(67, 181, 129),
		WarningBG_Other = Color3.fromRGB(255, 69, 0),
		WarningText = Color3.fromRGB(255, 255, 255),
		EventColor = Color3.fromRGB(235, 130, 255),
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
		WarningBG_Wild = Color3.fromRGB(50, 150, 50),
		WarningBG_Other = Color3.fromRGB(165, 42, 42),
		WarningText = Color3.fromRGB(255, 255, 255),
		EventColor = Color3.fromRGB(186, 85, 211),
		CornerRadius = UDim.new(0, 15),
		ButtonCorner = UDim.new(0, 10),
		StrokeColor = Color3.fromRGB(155, 119, 81),
		StrokeThickness = 1,
		StrokeTransparency = 0
	}
}

-- Liste des breeds "event" connus (motifs spéciaux, pas les couleurs de base)
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

	if EVENT_BREEDS[lower] then
		return true
	end

	-- fallback: si le nom contient "event" ça compte aussi (pour les events futurs)
	if lower:find("event") then
		return true
	end

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
Frame.Size = UDim2.new(0, 340, 0, 300)
Frame.Position = UDim2.new(0.5, -170, 0.5, -150)
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.BorderSizePixel = 0
Frame.Parent = GUI

local FrameCorner = Instance.new("UICorner")
FrameCorner.Parent = Frame

local FrameStroke = Instance.new("UIStroke")
FrameStroke.Parent = Frame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -50, 0, 35)
TitleLabel.Position = UDim2.new(0, 12, 0, 5)
TitleLabel.Text = "TP Horse"
TitleLabel.Font = Enum.Font.SourceSansSemibold
TitleLabel.TextSize = 20
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = Frame

local IslandLabel = Instance.new("TextLabel")
IslandLabel.Size = UDim2.new(1, -20, 0, 20)
IslandLabel.Position = UDim2.new(0, 10, 0, 40)
IslandLabel.Text = "Île : Recherche..."
IslandLabel.Font = Enum.Font.SourceSans
IslandLabel.TextSize = 14
IslandLabel.BackgroundTransparency = 1
IslandLabel.TextXAlignment = Enum.TextXAlignment.Left
IslandLabel.Parent = Frame

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 28, 0, 28)
CloseButton.Position = UDim2.new(1, -35, 0, 6)
CloseButton.Text = "X"
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 18
CloseButton.AutoButtonColor = false
CloseButton.Parent = Frame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -20, 0, 70)
StatusLabel.Position = UDim2.new(0, 10, 0, 65)
StatusLabel.Font = Enum.Font.SourceSans
StatusLabel.TextSize = 16
StatusLabel.TextWrapped = true
StatusLabel.TextYAlignment = Enum.TextYAlignment.Top
StatusLabel.BackgroundTransparency = 1
StatusLabel.Parent = Frame

local WarningLabel = Instance.new("TextLabel")
WarningLabel.Size = UDim2.new(1, -20, 0, 30)
WarningLabel.Position = UDim2.new(0, 10, 0, 105)
WarningLabel.Text = "..."
WarningLabel.Font = Enum.Font.SourceSansSemibold
WarningLabel.TextSize = 15
WarningLabel.BackgroundColor3 = THEMES.Discord.WarningBG_Other
WarningLabel.BorderSizePixel = 0
WarningLabel.Visible = false
WarningLabel.Parent = Frame

local WarningCorner = Instance.new("UICorner")
WarningCorner.CornerRadius = UDim.new(0, 5)
WarningCorner.Parent = WarningLabel

local WarningStroke = Instance.new("UIStroke")
WarningStroke.Parent = WarningLabel

local TeleportButton = Instance.new("TextButton")
TeleportButton.Size = UDim2.new(0, 95, 0, 40)
TeleportButton.Position = UDim2.new(0, 10, 1, -50)
TeleportButton.Text = "TP"
TeleportButton.Font = Enum.Font.SourceSansSemibold
TeleportButton.TextSize = 18
TeleportButton.AutoButtonColor = false
TeleportButton.Parent = Frame

local RefreshButton = Instance.new("TextButton")
RefreshButton.Size = UDim2.new(0, 95, 0, 40)
RefreshButton.Position = UDim2.new(0, 115, 1, -50)
RefreshButton.Text = "Busca"
RefreshButton.Font = Enum.Font.SourceSansSemibold
RefreshButton.TextSize = 18
RefreshButton.AutoButtonColor = false
RefreshButton.Parent = Frame

local ThemeButton = Instance.new("TextButton")
ThemeButton.Size = UDim2.new(0, 95, 0, 40)
ThemeButton.Position = UDim2.new(1, -105, 1, -50)
ThemeButton.Text = "Tema"
ThemeButton.Font = Enum.Font.SourceSansSemibold
ThemeButton.TextSize = 18
ThemeButton.AutoButtonColor = false
ThemeButton.Parent = Frame

local TeleportCorner = Instance.new("UICorner")
TeleportCorner.Parent = TeleportButton

local RefreshCorner = Instance.new("UICorner")
RefreshCorner.Parent = RefreshButton

local ThemeCorner = Instance.new("UICorner")
ThemeCorner.Parent = ThemeButton

local CloseCorner = Instance.new("UICorner")
CloseCorner.Parent = CloseButton

local TeleportStroke = Instance.new("UIStroke")
TeleportStroke.Parent = TeleportButton

local RefreshStroke = Instance.new("UIStroke")
RefreshStroke.Parent = RefreshButton

local ThemeStroke = Instance.new("UIStroke")
ThemeStroke.Parent = ThemeButton

local CloseStroke = Instance.new("UIStroke")
CloseStroke.Parent = CloseButton

-- Poignée de redimensionnement (coin bas droit)
local ResizeHandle = Instance.new("TextButton")
ResizeHandle.Name = "ResizeHandle"
ResizeHandle.Size = UDim2.new(0, 20, 0, 20)
ResizeHandle.Position = UDim2.new(1, -20, 1, -20)
ResizeHandle.Text = "◢"
ResizeHandle.TextSize = 16
ResizeHandle.Font = Enum.Font.SourceSansBold
ResizeHandle.BackgroundTransparency = 1
ResizeHandle.TextColor3 = Color3.fromRGB(200, 200, 200)
ResizeHandle.AutoButtonColor = false
ResizeHandle.ZIndex = 10
ResizeHandle.Parent = Frame

local MIN_SIZE = Vector2.new(280, 260)
local MAX_SIZE = Vector2.new(700, 700)

local validModels = {}
local currentModelIndex = 1

local function getHorseBreed(model)

	local attributeNames = {
		"Breed",
		"HorseBreed",
		"BreedName",
		"HorseName",
		"Species",
		"Type"
	}

	for _, attributeName in ipairs(attributeNames) do
		local value = model:GetAttribute(attributeName)

		if value ~= nil then
			if typeof(value) == "string" and value ~= "" then
				return value
			end
		end
	end

	for _, descendant in ipairs(model:GetDescendants()) do

		if descendant:IsA("StringValue") then

			local name = descendant.Name:lower()

			if name == "breed"
				or name == "horsebreed"
				or name == "breedname"
				or name == "horsename"
				or name == "species"
				or name == "type" then

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

	TeleportButton.TextColor3 = theme.TextPrimary
	RefreshButton.TextColor3 = theme.TextPrimary
	ThemeButton.TextColor3 = theme.TextPrimary
	CloseButton.TextColor3 = theme.TextPrimary

	TeleportCorner.CornerRadius = theme.ButtonCorner
	RefreshCorner.CornerRadius = theme.ButtonCorner
	ThemeCorner.CornerRadius = theme.ButtonCorner
	CloseCorner.CornerRadius = theme.ButtonCorner

	TeleportStroke.Color = theme.StrokeColor
	RefreshStroke.Color = theme.StrokeColor
	ThemeStroke.Color = theme.StrokeColor
	CloseStroke.Color = theme.StrokeColor

	currentTheme = themeName
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

			local captureProgress =
				descendant:FindFirstChild("CaptureProgress", true)

			local isWild = captureProgress ~= nil

			local breed = getHorseBreed(descendant)
			local isEvent = isEventBreed(breed)

			local highlight = Instance.new("Highlight")
			highlight.Name = "TeleportHighlight"

			if isEvent then
				highlight.FillColor = theme.EventColor
			else
				highlight.FillColor =
					isWild and theme.WarningBG_Wild or theme.ButtonTP
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

	for _, horse in ipairs(wildHorses) do
		table.insert(allHorses, horse)
	end

	for _, horse in ipairs(otherHorses) do
		table.insert(allHorses, horse)
	end

	return allHorses, islandContainer.Name
end

local lastStatusCheck = 0
local STATUS_INTERVAL = 0.25

local function checkCurrentModelStatus()

	if not GUI.Enabled
		or #validModels == 0
		or currentModelIndex > #validModels then

		WarningLabel.Visible = false
		return
	end

	local now = os.clock()

	if now - lastStatusCheck < STATUS_INTERVAL then
		return
	end

	lastStatusCheck = now

	local modelInfo = validModels[currentModelIndex]
	local currentModel = modelInfo.Model

	if not currentModel or not currentModel.Parent then
		return
	end

	local captureProgress =
		currentModel:FindFirstChild("CaptureProgress", true)

	local isWildNow = captureProgress ~= nil

	modelInfo.IsWild = isWildNow

	local theme = THEMES[currentTheme]

	if modelInfo.IsEvent then
		WarningLabel.Text = isWildNow and "CHEVAL EVENT (SAUVAGE)" or "CHEVAL EVENT (DOMESTIQUE)"
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

	if not modelInfo.RootPart then
		return
	end

	local pos = modelInfo.RootPart.Position

	StatusLabel.Text = string.format(
		"Cheval %d sur %d\nRace : %s (%s)\nPosition : %.1f %.1f %.1f",
		currentModelIndex,
		#validModels,
		modelInfo.Breed,
		modelInfo.IsEvent and "EVENT" or "Basique",
		pos.X,
		pos.Y,
		pos.Z
	)

	checkCurrentModelStatus()
end

local function createHorseList()

	local old = Frame:FindFirstChild("HorseList")

	if old then
		old:Destroy()
	end

	local list = Instance.new("ScrollingFrame")

	list.Name = "HorseList"
	list.Size = UDim2.new(1, -20, 1, -195)
	list.Position = UDim2.new(0, 10, 0, 145)
	list.BackgroundTransparency = 0.2
	list.BorderSizePixel = 0
	list.ScrollBarThickness = 6
	list.CanvasSize = UDim2.new(0, 0, 0, #validModels * 32)
	list.Parent = Frame

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 4)
	layout.Parent = list

	for index, horse in ipairs(validModels) do

		local button = Instance.new("TextButton")

		button.Size = UDim2.new(1, -8, 0, 28)

		local distance = math.floor(
			(Character.HumanoidRootPart.Position -
			horse.RootPart.Position).Magnitude
		)

		local status =
			horse.IsWild and "SAUVAGE" or "DOMESTIQUE"

		local eventTag = horse.IsEvent and " ★EVENT" or ""

		button.Text = string.format(
			"%d  %s  |  %dm  |  %s%s",
			index,
			horse.Breed,
			distance,
			status,
			eventTag
		)

		if horse.IsEvent then
			button.TextColor3 = THEMES[currentTheme].EventColor
		end

		button.Parent = list

		button.MouseButton1Click:Connect(function()

			currentModelIndex = index

			updateGUIStatus()

		end)
	end
end

local function refreshHorseList()

	if not GUI.Enabled then
		return
	end

	local islandName

	validModels, islandName = findValidModels()

	currentModelIndex = 1

	IslandLabel.Text =
		"Île : " .. (islandName or "Inconnue")

	updateGUIStatus()

	createHorseList()
end

local function teleportToNextModel()

	if not GUI.Enabled or #validModels == 0 then
		return
	end

	currentModelIndex += 1

	if currentModelIndex > #validModels then
		currentModelIndex = 1
	end

	local target = validModels[currentModelIndex]

	if target
		and target.Model
		and target.RootPart
		and Character then

		Character:PivotTo(
			CFrame.new(
				target.RootPart.Position +
				Vector3.new(0, 3, 0)
			)
		)

		updateGUIStatus()
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

		if obj:IsA("Highlight")
			and obj.Name == "TeleportHighlight" then

			obj:Destroy()
		end
	end

	GUI:Destroy()
end

-- DRAG SOURIS + TACTILE (déplacement)

local dragging = false
local dragStart
local startPosition

local function updateDrag(input)

	local delta = input.Position - dragStart

	Frame.Position = UDim2.new(
		startPosition.X.Scale,
		startPosition.X.Offset + delta.X,
		startPosition.Y.Scale,
		startPosition.Y.Offset + delta.Y
	)
end

safeConnect(TitleLabel.InputBegan, function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		dragging = true
		dragStart = input.Position
		startPosition = Frame.Position
	end
end)

safeConnect(UIS.InputChanged, function(input)

	if not dragging then
		return
	end

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

	if not resizing then
		return
	end

	if input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch then

		local delta = input.Position - resizeStart

		local newWidth = math.clamp(
			startSize.X.Offset + delta.X,
			MIN_SIZE.X,
			MAX_SIZE.X
		)

		local newHeight = math.clamp(
			startSize.Y.Offset + delta.Y,
			MIN_SIZE.Y,
			MAX_SIZE.Y
		)

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
safeConnect(CloseButton.MouseButton1Click, cleanup)

safeConnect(UIS.InputBegan, function(input, gameProcessed)

	if gameProcessed or not GUI.Enabled then
		return
	end

	if input.KeyCode == Enum.KeyCode.Z then
		teleportToNextModel()

	elseif input.KeyCode == Enum.KeyCode.X then
		refreshHorseList()

	elseif input.KeyCode == Enum.KeyCode.C then
		toggleTheme()
	end
end)

safeConnect(RunService.Heartbeat, checkCurrentModelStatus)

applyTheme(currentTheme)

GUI.Enabled = true

refreshHorseList()
