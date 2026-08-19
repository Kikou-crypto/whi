local Player = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Character
local Humanoid
local connections = {} -- para guardar todos os Connects

-- Armazena o tema atual (começa com o tema Discord)
local currentTheme = "Discord"

-- Tabela de Configuração dos Temas
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
		CornerRadius = UDim.new(0, 15),
		ButtonCorner = UDim.new(0, 10),
		StrokeColor = Color3.fromRGB(155, 119, 81),
		StrokeThickness = 1,
		StrokeTransparency = 0
	}
}

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
local Frame = Instance.new("Frame")
local TitleLabel = Instance.new("TextLabel")
local IslandLabel = Instance.new("TextLabel")
local StatusLabel = Instance.new("TextLabel")
local WarningLabel = Instance.new("TextLabel")
local TeleportButton = Instance.new("TextButton")
local RefreshButton = Instance.new("TextButton")
local ThemeButton = Instance.new("TextButton")
local CloseButton = Instance.new("TextButton")

local FrameCorner = Instance.new("UICorner")
local TeleportCorner = Instance.new("UICorner")
local RefreshCorner = Instance.new("UICorner")
local ThemeCorner = Instance.new("UICorner")
local CloseCorner = Instance.new("UICorner")
local WarningCorner = Instance.new("UICorner")

local FrameStroke = Instance.new("UIStroke")
local TeleportStroke = Instance.new("UIStroke")
local RefreshStroke = Instance.new("UIStroke")
local ThemeStroke = Instance.new("UIStroke")
local CloseStroke = Instance.new("UIStroke")
local WarningStroke = Instance.new("UIStroke")

FrameCorner.Parent = Frame
TeleportCorner.Parent = TeleportButton
RefreshCorner.Parent = RefreshButton
ThemeCorner.Parent = ThemeButton
CloseCorner.Parent = CloseButton
WarningCorner.Parent = WarningLabel

FrameStroke.Parent = Frame
TeleportStroke.Parent = TeleportButton
RefreshStroke.Parent = RefreshButton
ThemeStroke.Parent = ThemeButton
CloseStroke.Parent = CloseButton
WarningStroke.Parent = WarningLabel

GUI.Name = "TeleportGUI"
GUI.Parent = Player:WaitForChild("PlayerGui")
GUI.ResetOnSpawn = false

Frame.Name = "TPFrame"
Frame.Size = UDim2.new(0, 320, 0, 240)
Frame.Position = UDim2.new(0.5, -160, 0.5, -120)
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.BorderSizePixel = 0
Frame.Parent = GUI

TitleLabel.Size = UDim2.new(1, -40, 0, 30)
TitleLabel.Position = UDim2.new(0, 10, 0, 5)
TitleLabel.Text = "TP Horse"
TitleLabel.Font = Enum.Font.SourceSansSemibold
TitleLabel.TextSize = 20
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = Frame

IslandLabel.Name = "IslandLabel"
IslandLabel.Size = UDim2.new(1, -40, 0, 20)
IslandLabel.Position = UDim2.new(0, 10, 0, 35)
IslandLabel.Text = "Ilha: Buscando..."
IslandLabel.Font = Enum.Font.SourceSans
IslandLabel.TextSize = 14
IslandLabel.BackgroundTransparency = 1
IslandLabel.TextXAlignment = Enum.TextXAlignment.Left
IslandLabel.Parent = Frame

CloseButton.Size = UDim2.new(0, 28, 0, 28)
CloseButton.Position = UDim2.new(1, -35, 0, 6)
CloseButton.Text = "X"
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 18
CloseButton.AutoButtonColor = false
CloseButton.Parent = Frame

StatusLabel.Size = UDim2.new(1, -20, 0.3, 0)
StatusLabel.Position = UDim2.new(0, 10, 0.25, 0)
StatusLabel.Font = Enum.Font.SourceSans
StatusLabel.TextSize = 16
StatusLabel.TextWrapped = true
StatusLabel.TextYAlignment = Enum.TextYAlignment.Top
StatusLabel.BackgroundTransparency = 1
StatusLabel.Parent = Frame

WarningLabel.Name = "WarningLabel"
WarningLabel.Size = UDim2.new(1, -20, 0, 30)
WarningLabel.Position = UDim2.new(0, 10, 0.55, 0)
WarningLabel.Text = "..."
WarningLabel.Font = Enum.Font.SourceSansSemibold
WarningLabel.TextSize = 16
WarningLabel.TextColor3 = THEMES.Discord.WarningText
WarningLabel.BackgroundColor3 = THEMES.Discord.WarningBG_Other
WarningLabel.BorderSizePixel = 0
WarningLabel.Visible = false
WarningLabel.Parent = Frame
WarningCorner.CornerRadius = UDim.new(0, 5)

TeleportButton.Size = UDim2.new(0, 93, 0, 40)
TeleportButton.Position = UDim2.new(0, 10, 0.78, 0)
TeleportButton.Text = "TP"
TeleportButton.Font = Enum.Font.SourceSansSemibold
TeleportButton.TextSize = 18
TeleportButton.AutoButtonColor = false
TeleportButton.Parent = Frame

RefreshButton.Size = UDim2.new(0, 93, 0, 40)
RefreshButton.Position = UDim2.new(0, 114, 0.78, 0)
RefreshButton.Text = "Busca"
RefreshButton.Font = Enum.Font.SourceSansSemibold
RefreshButton.TextSize = 18
RefreshButton.AutoButtonColor = false
RefreshButton.Parent = Frame

ThemeButton.Size = UDim2.new(0, 93, 0, 40)
ThemeButton.Position = UDim2.new(1, -103, 0.78, 0)
ThemeButton.Text = "Tema"
ThemeButton.Font = Enum.Font.SourceSansSemibold
ThemeButton.TextSize = 18
ThemeButton.AutoButtonColor = false
ThemeButton.Parent = Frame

GUI.Enabled = false

local function applyTheme(themeName)
	local theme = THEMES[themeName]
	if not theme then return end

	Frame.BackgroundColor3 = theme.FrameBG
	FrameCorner.CornerRadius = theme.CornerRadius
	FrameStroke.Color = theme.StrokeColor
	FrameStroke.Thickness = theme.StrokeThickness
	FrameStroke.Transparency = theme.StrokeTransparency

	TitleLabel.TextColor3 = theme.TextPrimary
	StatusLabel.TextColor3 = theme.TextPrimary
	IslandLabel.TextColor3 = theme.TextSecondary

	WarningLabel.TextColor3 = theme.WarningText
	WarningStroke.Color = theme.StrokeColor
	WarningStroke.Thickness = theme.StrokeThickness
	WarningStroke.Transparency = theme.StrokeTransparency

	TeleportButton.BackgroundColor3 = theme.ButtonTP
	RefreshButton.BackgroundColor3 = theme.ButtonRefresh
	CloseButton.BackgroundColor3 = theme.ButtonClose
	ThemeButton.BackgroundColor3 = theme.ButtonTheme

	TeleportButton.TextColor3 = theme.TextPrimary
	RefreshButton.TextColor3 = theme.TextPrimary
	ThemeButton.TextColor3 = theme.TextPrimary
	CloseButton.TextColor3 = theme.TextPrimary

	local bCorner = theme.ButtonCorner
	TeleportCorner.CornerRadius = bCorner
	RefreshCorner.CornerRadius = bCorner
	ThemeCorner.CornerRadius = bCorner
	CloseCorner.CornerRadius = bCorner

	local bStrokeColor = theme.StrokeColor
	local bStrokeThickness = theme.StrokeThickness
	local bStrokeTransparency = theme.StrokeTransparency
	TeleportStroke.Color = bStrokeColor
	TeleportStroke.Thickness = bStrokeThickness
	TeleportStroke.Transparency = bStrokeTransparency
	RefreshStroke.Color = bStrokeColor
	RefreshStroke.Thickness = bStrokeThickness
	RefreshStroke.Transparency = bStrokeTransparency
	ThemeStroke.Color = bStrokeColor
	ThemeStroke.Thickness = bStrokeThickness
	ThemeStroke.Transparency = bStrokeTransparency
	CloseStroke.Color = bStrokeColor
	CloseStroke.Thickness = bStrokeThickness
	CloseStroke.Transparency = bStrokeTransparency

	currentTheme = themeName
end

local validModels = {}
local currentModelIndex = 1

local function findValidModels()
	local islandsFolder = workspace:FindFirstChild("Islands")
	if not islandsFolder then
		warn("Pasta 'Islands' não encontrada no Workspace")
		return {}, "Erro: Islands Missing"
	end

	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("Highlight") and obj.Name == "TeleportHighlight" then
			obj:Destroy()
		end
	end

	local playerIslandFolder = Character and Character.Parent
	local islandContainer = nil

	while playerIslandFolder and playerIslandFolder ~= islandsFolder and playerIslandFolder ~= workspace do
		if playerIslandFolder.Parent == islandsFolder then
			islandContainer = playerIslandFolder
			break
		end
		playerIslandFolder = playerIslandFolder.Parent
	end

	if not islandContainer then
		warn("Ilha do jogador não identificada dentro da pasta 'Islands'.")
		return {}, "Erro: Não na Ilha"
	end

	local islandName = islandContainer.Name
	local wildHorses = {}
	local otherHorses = {}

	local currentThemeColors = THEMES[currentTheme]

	for _, descendant in ipairs(islandContainer:GetDescendants()) do
		if descendant:IsA("Model")
			and descendant:FindFirstChildOfClass("Humanoid")
			and descendant:FindFirstChild("HumanoidRootPart")
			and descendant.Name:match("^%b{}$") then

			local rootPart = descendant:FindFirstChild("HumanoidRootPart")
			local hasCaptureProgress = false
			for _, element in ipairs(descendant:GetDescendants()) do
				if element.Name == "CaptureProgress" then
					hasCaptureProgress = true
					break
				end
			end

			local highlight = Instance.new("Highlight")
			highlight.Name = "TeleportHighlight"
			highlight.FillColor = hasCaptureProgress and currentThemeColors.WarningBG_Wild or currentThemeColors.ButtonTP
			highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
			highlight.FillTransparency = 0.5
			highlight.OutlineTransparency = 0
			highlight.Adornee = descendant
			highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
			highlight.Parent = descendant

			local horseData = {
				Model = descendant,
				RootPart = rootPart,
				IsWild = hasCaptureProgress
			}

			if horseData.IsWild then
				table.insert(wildHorses, horseData)
			else
				table.insert(otherHorses, horseData)
			end
		end
	end

	table.sort(wildHorses, function(a, b)
		return a.Model.Name < b.Model.Name
	end)
	table.sort(otherHorses, function(a, b)
		return a.Model.Name < b.Model.Name
	end)

	local allHorses = {}
	for _, horse in ipairs(wildHorses) do
		table.insert(allHorses, horse)
	end
	for _, horse in ipairs(otherHorses) do
		table.insert(allHorses, horse)
	end

	return allHorses, islandName
end

local function checkCurrentModelStatus()
	if GUI.Enabled == false or #validModels == 0 or currentModelIndex > #validModels then
		WarningLabel.Visible = false
		return
	end

	local theme = THEMES[currentTheme]
	local modelInfo = validModels[currentModelIndex]
	local currentModel = modelInfo.Model

	local isWildNow = false
	for _, element in ipairs(currentModel:GetDescendants()) do
		if element.Name == "CaptureProgress" then
			isWildNow = true
			break
		end
	end

	modelInfo.IsWild = isWildNow

	if isWildNow then
		WarningLabel.Text = "É CAVALO SELVAGEM (LIVE)"
		WarningLabel.BackgroundColor3 = theme.WarningBG_Wild
		WarningLabel.Visible = true
	else
		WarningLabel.Text = "NÃO É CAVALO SELVAGEM (LIVE)"
		WarningLabel.BackgroundColor3 = theme.WarningBG_Other
		WarningLabel.Visible = true
	end
end

local function updateGUIStatus()
	if #validModels == 0 then
		StatusLabel.Text = "Nenhum cavalo encontrado com nome entre { }"
		WarningLabel.Visible = false
		return
	end

	local modelInfo = validModels[currentModelIndex]
	local pos = modelInfo.RootPart.Position

	StatusLabel.Text = string.format("Cavalo %d de %d:\n%s\nPosição: %.1f, %.1f, %.1f",
		currentModelIndex,
		#validModels,
		modelInfo.Model.Name,
		pos.X, pos.Y, pos.Z)

	checkCurrentModelStatus() 
end

local function createHorseList()
	local old = Frame:FindFirstChild("HorseList")
	if old then
		old:Destroy()
	end

	local list = Instance.new("ScrollingFrame")
	list.Name = "HorseList"
	list.Size = UDim2.new(1, -20, 0, 100)
	list.Position = UDim2.new(0, 10, 0, 115)
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
			(Character.HumanoidRootPart.Position - horse.RootPart.Position).Magnitude
		)

		local status = horse.IsWild and "SAUVAGE" or "DOMESTIQUE"

		button.Text = string.format(
			"%d  %s  |  %dm  |  %s",
			index,
			horse.Model.Name,
			distance,
			status
		)

		button.Parent = list

		button.MouseButton1Click:Connect(function()
			currentModelIndex = index
			updateGUIStatus()
		end)
	end
end

local function toggleTheme()
	if currentTheme == "Discord" then
		applyTheme("Western")
	else
		applyTheme("Discord")
	end
	checkCurrentModelStatus()
end

local function teleportToNextModel()
	if GUI.Enabled == false or #validModels == 0 then return end

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

local function refreshHorseList()
	local islandName
	if GUI.Enabled == false then return end

	validModels, islandName = findValidModels()
	currentModelIndex = 1

	if islandName and islandName:sub(1, 4) == "Erro" then
		IslandLabel.Text = "Ilha: Falha na identificação"
	else
		IslandLabel.Text = "Ilha: " .. (islandName or "Desconhecida")
	end

	updateGUIStatus()
	createHorseList()
end

local function cleanup()
	if GUI then
		GUI.Enabled = false
	end

	for _, conn in pairs(connections) do
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

	if GUI then
		GUI:Destroy()
	end
end

safeConnect(TeleportButton.MouseButton1Click, teleportToNextModel)
safeConnect(RefreshButton.MouseButton1Click, refreshHorseList)
safeConnect(ThemeButton.MouseButton1Click, toggleTheme)
safeConnect(CloseButton.MouseButton1Click, cleanup)

safeConnect(UIS.InputBegan, function(input, gameProcessed)
	if gameProcessed or GUI.Enabled == false then return end

	if input.KeyCode == Enum.KeyCode.Z then
		teleportToNextModel()
	elseif input.KeyCode == Enum.KeyCode.X then
		refreshHorseList()
	elseif input.KeyCode == Enum.KeyCode.C then
		toggleTheme()
	end
end)

local dragInput, mousePos, framePos

safeConnect(Frame.InputBegan, function(input)
	if GUI.Enabled == false then return end

	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragInput = input
		mousePos = UIS:GetMouseLocation()
		framePos = Frame.Position

		safeConnect(input.Changed, function()
			if dragInput and dragInput.UserInputState == Enum.UserInputState.End then
				dragInput = nil
			end
		end)
	end
end)

safeConnect(RunService.Heartbeat, function()
	if dragInput and GUI.Enabled then
		local delta = UIS:GetMouseLocation() - mousePos
		Frame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
	end
end)

safeConnect(RunService.Heartbeat, checkCurrentModelStatus)

if not Character then
	Player.CharacterAdded:Wait()
	Character = Player.Character
end

applyTheme(currentTheme)

GUI.Enabled = true

refreshHorseList()
