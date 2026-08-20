-- HORSE FINDER GUI
-- Pour ton propre jeu Roblox
-- LocalScript dans StarterPlayerScripts

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local MIN_SIZE = Vector2.new(420, 450)
local MAX_SIZE = Vector2.new(800, 700)

local horses = {}
local selectedHorse = nil
local currentFilter = "All"

local gui = Instance.new("ScreenGui")
gui.Name = "HorseFinder"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = PlayerGui

--------------------------------------------------
-- MAIN
--------------------------------------------------

local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(500,500)
Main.Position = UDim2.new(0.5,-250,0.5,-250)
Main.BackgroundColor3 = Color3.fromRGB(25,27,32)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = gui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0,14)
Corner.Parent = Main

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(70,75,90)
Stroke.Thickness = 1
Stroke.Parent = Main

--------------------------------------------------
-- HEADER
--------------------------------------------------

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1,0,0,52)
Header.BackgroundColor3 = Color3.fromRGB(35,38,45)
Header.BorderSizePixel = 0
Header.Parent = Main

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0,14)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,-100,1,0)
Title.Position = UDim2.fromOffset(15,0)
Title.BackgroundTransparency = 1
Title.Text = "Horse Finder"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 19
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(32,32)
Close.Position = UDim2.new(1,-42,0,10)
Close.Text = "×"
Close.TextSize = 22
Close.Font = Enum.Font.GothamBold
Close.TextColor3 = Color3.new(1,1,1)
Close.BackgroundColor3 = Color3.fromRGB(210,65,65)
Close.BorderSizePixel = 0
Close.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0,8)
CloseCorner.Parent = Close

--------------------------------------------------
-- SEARCH
--------------------------------------------------

local Search = Instance.new("TextBox")
Search.Size = UDim2.new(1,-30,0,34)
Search.Position = UDim2.fromOffset(15,62)
Search.PlaceholderText = "Rechercher une race ou un coat..."
Search.Text = ""
Search.ClearTextOnFocus = false
Search.Font = Enum.Font.Gotham
Search.TextSize = 13
Search.TextColor3 = Color3.new(1,1,1)
Search.PlaceholderColor3 = Color3.fromRGB(145,145,150)
Search.BackgroundColor3 = Color3.fromRGB(42,45,52)
Search.BorderSizePixel = 0
Search.Parent = Main

local SearchCorner = Instance.new("UICorner")
SearchCorner.CornerRadius = UDim.new(0,8)
SearchCorner.Parent = Search

--------------------------------------------------
-- FILTERS
--------------------------------------------------

local FilterAll = Instance.new("TextButton")
FilterAll.Size = UDim2.fromOffset(75,29)
FilterAll.Position = UDim2.fromOffset(15,105)
FilterAll.Text = "Tous"
FilterAll.Font = Enum.Font.GothamSemibold
FilterAll.TextSize = 12
FilterAll.TextColor3 = Color3.new(1,1,1)
FilterAll.BackgroundColor3 = Color3.fromRGB(88,101,242)
FilterAll.BorderSizePixel = 0
FilterAll.Parent = Main

local FilterEvent = Instance.new("TextButton")
FilterEvent.Size = UDim2.fromOffset(75,29)
FilterEvent.Position = UDim2.fromOffset(96,105)
FilterEvent.Text = "Events"
FilterEvent.Font = Enum.Font.GothamSemibold
FilterEvent.TextSize = 12
FilterEvent.TextColor3 = Color3.new(1,1,1)
FilterEvent.BackgroundColor3 = Color3.fromRGB(55,58,66)
FilterEvent.BorderSizePixel = 0
FilterEvent.Parent = Main

local Refresh = Instance.new("TextButton")
Refresh.Size = UDim2.fromOffset(75,29)
Refresh.Position = UDim2.fromOffset(177,105)
Refresh.Text = "Refresh"
Refresh.Font = Enum.Font.GothamSemibold
Refresh.TextSize = 12
Refresh.TextColor3 = Color3.new(1,1,1)
Refresh.BackgroundColor3 = Color3.fromRGB(55,58,66)
Refresh.BorderSizePixel = 0
Refresh.Parent = Main

for _,button in ipairs({FilterAll,FilterEvent,Refresh}) do
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0,7)
	c.Parent = button
end

--------------------------------------------------
-- LIST
--------------------------------------------------

local List = Instance.new("ScrollingFrame")
List.Name = "HorseList"
List.Size = UDim2.new(0.56,-18,1,-175)
List.Position = UDim2.fromOffset(15,145)
List.BackgroundColor3 = Color3.fromRGB(30,32,38)
List.BorderSizePixel = 0
List.ScrollBarThickness = 5
List.AutomaticCanvasSize = Enum.AutomaticSize.Y
List.CanvasSize = UDim2.new()
List.Parent = Main

local ListCorner = Instance.new("UICorner")
ListCorner.CornerRadius = UDim.new(0,9)
ListCorner.Parent = List

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0,6)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = List

local Padding = Instance.new("UIPadding")
Padding.PaddingTop = UDim.new(0,6)
Padding.PaddingBottom = UDim.new(0,6)
Padding.PaddingLeft = UDim.new(0,6)
Padding.PaddingRight = UDim.new(0,6)
Padding.Parent = List

--------------------------------------------------
-- DETAILS
--------------------------------------------------

local Details = Instance.new("Frame")
Details.Size = UDim2.new(0.44,-22,1,-175)
Details.Position = UDim2.new(0.56,7,0,145)
Details.BackgroundColor3 = Color3.fromRGB(35,38,45)
Details.BorderSizePixel = 0
Details.Parent = Main

local DetailsCorner = Instance.new("UICorner")
DetailsCorner.CornerRadius = UDim.new(0,9)
DetailsCorner.Parent = Details

local Preview = Instance.new("ViewportFrame")
Preview.Size = UDim2.new(1,-16,0,125)
Preview.Position = UDim2.fromOffset(8,8)
Preview.BackgroundColor3 = Color3.fromRGB(20,22,26)
Preview.BorderSizePixel = 0
Preview.Parent = Details

local PreviewCorner = Instance.new("UICorner")
PreviewCorner.CornerRadius = UDim.new(0,8)
PreviewCorner.Parent = Preview

local BreedLabel = Instance.new("TextLabel")
BreedLabel.Size = UDim2.new(1,-16,0,25)
BreedLabel.Position = UDim2.fromOffset(8,140)
BreedLabel.BackgroundTransparency = 1
BreedLabel.Text = "Aucun cheval"
BreedLabel.TextColor3 = Color3.new(1,1,1)
BreedLabel.Font = Enum.Font.GothamBold
BreedLabel.TextSize = 14
BreedLabel.TextXAlignment = Enum.TextXAlignment.Left
BreedLabel.Parent = Details

local CoatLabel = Instance.new("TextLabel")
CoatLabel.Size = UDim2.new(1,-16,0,20)
CoatLabel.Position = UDim2.fromOffset(8,165)
CoatLabel.BackgroundTransparency = 1
CoatLabel.Text = "Coat : inconnu"
CoatLabel.TextColor3 = Color3.fromRGB(180,180,185)
CoatLabel.Font = Enum.Font.Gotham
CoatLabel.TextSize = 11
CoatLabel.TextXAlignment = Enum.TextXAlignment.Left
CoatLabel.Parent = Details

local EventLabel = Instance.new("TextLabel")
EventLabel.Size = UDim2.new(1,-16,0,25)
EventLabel.Position = UDim2.fromOffset(8,190)
EventLabel.Text = "NORMAL"
EventLabel.TextColor3 = Color3.new(1,1,1)
EventLabel.Font = Enum.Font.GothamBold
EventLabel.TextSize = 10
EventLabel.BackgroundColor3 = Color3.fromRGB(65,68,78)
EventLabel.Parent = Details

local EventCorner = Instance.new("UICorner")
EventCorner.CornerRadius = UDim.new(0,6)
EventCorner.Parent = EventLabel

--------------------------------------------------
-- ISLAND TELEPORT
--------------------------------------------------

local IslandTeleport = Instance.new("TextButton")
IslandTeleport.Size = UDim2.new(1,-16,0,35)
IslandTeleport.Position = UDim2.new(0,8,1,-112)
IslandTeleport.Text = "TELEPORTER A L'ILE SUIVANTE"
IslandTeleport.Font = Enum.Font.GothamBold
IslandTeleport.TextSize = 10
IslandTeleport.TextColor3 = Color3.new(1,1,1)
IslandTeleport.BackgroundColor3 = Color3.fromRGB(55,58,66)
IslandTeleport.BorderSizePixel = 0
IslandTeleport.Parent = Details

local IslandCorner = Instance.new("UICorner")
IslandCorner.CornerRadius = UDim.new(0,8)
IslandCorner.Parent = IslandTeleport

local islandIndex = 1

local function getIslands()

	local folder = workspace:FindFirstChild("Islands")

	if not folder then
		return {}
	end

	local result = {}

	for _,island in ipairs(folder:GetChildren()) do

		if island:IsA("Model") or island:IsA("Folder") then

			local part = island:FindFirstChildWhichIsA(
				"BasePart",
				true
			)

			if part then

				table.insert(result,{
					Object = island,
					Part = part
				})

			end

		end

	end

	table.sort(result,function(a,b)
		return a.Object.Name < b.Object.Name
	end)

	return result

end

IslandTeleport.MouseButton1Click:Connect(function()

	local character = Player.Character

	if not character then
		return
	end

	local islands = getIslands()

	if #islands == 0 then

		IslandTeleport.Text = "AUCUNE ILE TROUVEE"

		task.wait(1.5)

		IslandTeleport.Text = "TELEPORTER A L'ILE SUIVANTE"

		return

	end

	if islandIndex > #islands then
		islandIndex = 1
	end

	local island = islands[islandIndex]

	character:PivotTo(
		CFrame.new(
			island.Part.Position + Vector3.new(0,6,0)
		)
	)

	IslandTeleport.Text = island.Object.Name

	islandIndex += 1

	task.wait(1)

	IslandTeleport.Text = "TELEPORTER A L'ILE SUIVANTE"

end)

--------------------------------------------------
-- HORSE TELEPORT
--------------------------------------------------

local Teleport = Instance.new("TextButton")
Teleport.Size = UDim2.new(1,-16,0,35)
Teleport.Position = UDim2.new(0,8,1,-70)
Teleport.Text = "TELEPORTER AU CHEVAL"
Teleport.Font = Enum.Font.GothamBold
Teleport.TextSize = 10
Teleport.TextColor3 = Color3.new(1,1,1)
Teleport.BackgroundColor3 = Color3.fromRGB(88,101,242)
Teleport.BorderSizePixel = 0
Teleport.Parent = Details

local TeleportCorner = Instance.new("UICorner")
TeleportCorner.CornerRadius = UDim.new(0,8)
TeleportCorner.Parent = Teleport

--------------------------------------------------
-- DATA
--------------------------------------------------

local function getString(model,names)

	for _,name in ipairs(names) do

		local value = model:GetAttribute(name)

		if value ~= nil then
			return tostring(value)
		end

	end

	for _,obj in ipairs(model:GetDescendants()) do

		if obj:IsA("StringValue") then

			for _,name in ipairs(names) do

				if obj.Name:lower() == name:lower() then
					return obj.Value
				end

			end

		end

	end

	return "Inconnu"

end

local function getEvent(model)

	for _,name in ipairs({
		"IsEvent",
		"Event",
		"EventHorse",
		"Limited",
		"IsLimited"
	}) do

		local value = model:GetAttribute(name)

		if typeof(value) == "boolean" and value then
			return true
		end

	end

	for _,obj in ipairs(model:GetDescendants()) do

		if obj:IsA("BoolValue") then

			local n = obj.Name:lower()

			if (n:find("event") or n:find("limited"))
				and obj.Value == true then

				return true

			end

		end

	end

	return false

end

--------------------------------------------------
-- PREVIEW
--------------------------------------------------

local function createPreview(viewport,model)

	viewport:ClearAllChildren()

	local world = Instance.new("WorldModel")
	world.Parent = viewport

	local clone

	local ok = pcall(function()
		clone = model:Clone()
	end)

	if not ok or not clone then
		return
	end

	for _,obj in ipairs(clone:GetDescendants()) do

		if obj:IsA("Script")
			or obj:IsA("LocalScript")
			or obj:IsA("ModuleScript")
			or obj:IsA("Highlight") then

			obj:Destroy()

		end

	end

	clone.Parent = world

	local cf,size = clone:GetBoundingBox()
	local maxSize = math.max(size.X,size.Y,size.Z)

	local camera = Instance.new("Camera")

	camera.FieldOfView = 35

	camera.CFrame = CFrame.new(
		cf.Position + Vector3.new(
			maxSize * 1.5,
			maxSize * 0.7,
			maxSize * 1.5
		),
		cf.Position
	)

	camera.Parent = viewport
	viewport.CurrentCamera = camera

end

--------------------------------------------------
-- FIND HORSES
--------------------------------------------------

local function findHorses()

	horses = {}

	local folder = workspace:FindFirstChild("Horses")

	if not folder then
		folder = workspace:FindFirstChild("Islands")
	end

	if not folder then
		return
	end

	local character = Player.Character

	if not character then
		return
	end

	local root = character:FindFirstChild("HumanoidRootPart")

	if not root then
		return
	end

	for _,model in ipairs(folder:GetDescendants()) do

		if model:IsA("Model")
			and model:FindFirstChildOfClass("Humanoid")
			and model:FindFirstChild("HumanoidRootPart") then

			local horseRoot = model:FindFirstChild("HumanoidRootPart")

			local breed = getString(
				model,
				{"Breed","Race","BreedName","HorseBreed"}
			)

			local coat = getString(
				model,
				{"Coat","CoatName","HorseCoat"}
			)

			table.insert(horses,{
				Model = model,
				Root = horseRoot,
				Breed = breed,
				Coat = coat,
				Event = getEvent(model),
				Distance = math.floor(
					(root.Position-horseRoot.Position).Magnitude
				)
			})

		end

	end

	table.sort(horses,function(a,b)
		return a.Distance < b.Distance
	end)

end

--------------------------------------------------
-- SELECT
--------------------------------------------------

local function selectHorse(horse)

	selectedHorse = horse

	BreedLabel.Text = horse.Breed
	CoatLabel.Text = "Coat : "..horse.Coat

	if horse.Event then

		EventLabel.Text = "★ EVENT"
		EventLabel.BackgroundColor3 =
			Color3.fromRGB(170,75,210)

	else

		EventLabel.Text = "NORMAL"
		EventLabel.BackgroundColor3 =
			Color3.fromRGB(65,68,78)

	end

	createPreview(Preview,horse.Model)

end

--------------------------------------------------
-- LIST
--------------------------------------------------

local function rebuildList()

	for _,child in ipairs(List:GetChildren()) do

		if child:IsA("Frame") then
			child:Destroy()
		end

	end

	local search = Search.Text:lower()

	for _,horse in ipairs(horses) do

		local allowed = true

		if currentFilter == "Event"
			and not horse.Event then

			allowed = false

		end

		local searchText =
			(horse.Breed.." "..horse.Coat):lower()

		if search ~= ""
			and not searchText:find(search,1,true) then

			allowed = false

		end

		if allowed then

			local Row = Instance.new("Frame")

			Row.Size = UDim2.new(1,-4,0,82)
			Row.BackgroundColor3 =
				Color3.fromRGB(43,46,54)

			Row.BorderSizePixel = 0
			Row.Parent = List

			local RowCorner = Instance.new("UICorner")
			RowCorner.CornerRadius = UDim.new(0,8)
			RowCorner.Parent = Row

			local VP = Instance.new("ViewportFrame")

			VP.Size = UDim2.fromOffset(68,68)
			VP.Position = UDim2.fromOffset(6,7)
			VP.BackgroundColor3 =
				Color3.fromRGB(25,27,32)

			VP.BorderSizePixel = 0
			VP.Parent = Row

			local VPCorner = Instance.new("UICorner")
			VPCorner.CornerRadius = UDim.new(0,7)
			VPCorner.Parent = VP

			createPreview(VP,horse.Model)

			local Name = Instance.new("TextLabel")

			Name.Size = UDim2.new(1,-85,0,20)
			Name.Position = UDim2.fromOffset(82,9)
			Name.BackgroundTransparency = 1
			Name.Text = horse.Breed
			Name.TextColor3 = Color3.new(1,1,1)
			Name.Font = Enum.Font.GothamBold
			Name.TextSize = 12
			Name.TextXAlignment =
				Enum.TextXAlignment.Left
			Name.Parent = Row

			local Coat = Instance.new("TextLabel")

			Coat.Size = UDim2.new(1,-85,0,18)
			Coat.Position = UDim2.fromOffset(82,30)
			Coat.BackgroundTransparency = 1
			Coat.Text = horse.Coat
			Coat.TextColor3 =
				Color3.fromRGB(170,170,180)

			Coat.Font = Enum.Font.Gotham
			Coat.TextSize = 10
			Coat.TextXAlignment =
				Enum.TextXAlignment.Left
			Coat.Parent = Row

			local Distance = Instance.new("TextLabel")

			Distance.Size = UDim2.new(1,-85,0,17)
			Distance.Position = UDim2.fromOffset(82,49)
			Distance.BackgroundTransparency = 1
			Distance.Text = horse.Distance.."m"
			Distance.TextColor3 =
				Color3.fromRGB(140,145,155)

			Distance.Font = Enum.Font.Gotham
			Distance.TextSize = 9
			Distance.TextXAlignment =
				Enum.TextXAlignment.Left
			Distance.Parent = Row

			local Select = Instance.new("TextButton")

			Select.Size = UDim2.fromOffset(65,21)
			Select.Position = UDim2.new(1,-72,1,-28)
			Select.Text = "Choisir"
			Select.Font = Enum.Font.GothamBold
			Select.TextSize = 9
			Select.TextColor3 = Color3.new(1,1,1)

			Select.BackgroundColor3 =
				horse.Event
				and Color3.fromRGB(170,75,210)
				or Color3.fromRGB(88,101,242)

			Select.BorderSizePixel = 0
			Select.Parent = Row

			local SelectCorner = Instance.new("UICorner")
			SelectCorner.CornerRadius = UDim.new(0,6)
			SelectCorner.Parent = Select

			Select.MouseButton1Click:Connect(function()
				selectHorse(horse)
			end)

		end

	end

end

--------------------------------------------------
-- HORSE TELEPORT
--------------------------------------------------

Teleport.MouseButton1Click:Connect(function()

	if not selectedHorse then
		return
	end

	local character = Player.Character

	if not character then
		return
	end

	if selectedHorse.Root
		and selectedHorse.Root.Parent then

		character:PivotTo(
			CFrame.new(
				selectedHorse.Root.Position
				+ Vector3.new(0,4,0)
			)
		)

	end

end)

--------------------------------------------------
-- FILTERS
--------------------------------------------------

FilterAll.MouseButton1Click:Connect(function()

	currentFilter = "All"

	FilterAll.BackgroundColor3 =
		Color3.fromRGB(88,101,242)

	FilterEvent.BackgroundColor3 =
		Color3.fromRGB(55,58,66)

	rebuildList()

end)

FilterEvent.MouseButton1Click:Connect(function()

	currentFilter = "Event"

	FilterEvent.BackgroundColor3 =
		Color3.fromRGB(170,75,210)

	FilterAll.BackgroundColor3 =
		Color3.fromRGB(55,58,66)

	rebuildList()

end)

Search:GetPropertyChangedSignal("Text"):Connect(
	rebuildList
)

Refresh.MouseButton1Click:Connect(function()

	findHorses()
	rebuildList()

end)

--------------------------------------------------
-- DRAG BAR
--------------------------------------------------

local DragBar = Instance.new("TextButton")

DragBar.Size = UDim2.new(1,-12,0,14)
DragBar.Position = UDim2.new(0,6,1,-14)
DragBar.Text = "≡  DRAG"
DragBar.TextSize = 9
DragBar.Font = Enum.Font.GothamBold
DragBar.TextColor3 =
	Color3.fromRGB(150,155,165)

DragBar.BackgroundColor3 =
	Color3.fromRGB(35,38,45)

DragBar.BorderSizePixel = 0
DragBar.Parent = Main

local dragging = false
local dragStart
local startPosition

DragBar.InputBegan:Connect(function(input)

	if input.UserInputType ==
		Enum.UserInputType.MouseButton1
		or input.UserInputType ==
		Enum.UserInputType.Touch then

		dragging = true
		dragStart = input.Position
		startPosition = Main.Position

	end

end)

UserInputService.InputChanged:Connect(function(input)

	if not dragging then
		return
	end

	if input.UserInputType ==
		Enum.UserInputType.MouseMovement
		or input.UserInputType ==
		Enum.UserInputType.Touch then

		local delta =
			input.Position - dragStart

		Main.Position = UDim2.new(
			startPosition.X.Scale,
			startPosition.X.Offset + delta.X,
			startPosition.Y.Scale,
			startPosition.Y.Offset + delta.Y
		)

	end

end)

UserInputService.InputEnded:Connect(function(input)

	if input.UserInputType ==
		Enum.UserInputType.MouseButton1
		or input.UserInputType ==
		Enum.UserInputType.Touch then

		dragging = false

	end

end)

--------------------------------------------------
-- RESIZE
--------------------------------------------------

local Resize = Instance.new("TextButton")

Resize.Size = UDim2.fromOffset(20,20)
Resize.Position = UDim2.new(1,-20,1,-20)
Resize.Text = "◢"
Resize.TextSize = 11
Resize.TextColor3 =
	Color3.fromRGB(170,175,185)

Resize.BackgroundTransparency = 1
Resize.BorderSizePixel = 0
Resize.Parent = Main

local resizing = false
local resizeStart
local startSize

Resize.InputBegan:Connect(function(input)

	if input.UserInputType ==
		Enum.UserInputType.MouseButton1
		or input.UserInputType ==
		Enum.UserInputType.Touch then

		resizing = true
		resizeStart = input.Position
		startSize = Main.AbsoluteSize

	end

end)

UserInputService.InputChanged:Connect(function(input)

	if not resizing then
		return
	end

	if input.UserInputType ==
		Enum.UserInputType.MouseMovement
		or input.UserInputType ==
		Enum.UserInputType.Touch then

		local delta =
			input.Position - resizeStart

		local width = math.clamp(
			startSize.X + delta.X,
			MIN_SIZE.X,
			MAX_SIZE.X
		)

		local height = math.clamp(
			startSize.Y + delta.Y,
			MIN_SIZE.Y,
			MAX_SIZE.Y
		)

		Main.Size =
			UDim2.fromOffset(width,height)

	end

end)

UserInputService.InputEnded:Connect(function(input)

	if input.UserInputType ==
		Enum.UserInputType.MouseButton1
		or input.UserInputType ==
		Enum.UserInputType.Touch then

		resizing = false

	end

end)

--------------------------------------------------
-- CLOSE
--------------------------------------------------

Close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

--------------------------------------------------
-- START
--------------------------------------------------

findHorses()
rebuildList()
