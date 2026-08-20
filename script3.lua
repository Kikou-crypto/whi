-- HORSE AUTO CAPTURE
-- CLIENT TEST
-- Structure supposée :
-- workspace.Horses
-- chaque cheval = Model avec Humanoid + HumanoidRootPart
-- Lassos = Tools dans Backpack

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer

local HORSE_FOLDER = workspace:WaitForChild("Horses")

local RUNNING = false
local HEIGHT = 3
local CHECK_DELAY = 0.15
local CLICK_DELAY = 0.18

--------------------------------------------------
-- LASSOS
--------------------------------------------------

local LASSOS = {
	["Lasso"] = 1,
	["Wooden Lasso"] = 3,
	["Stone Lasso"] = 2,
	["Tin Lasso"] = 3,
	["Copper Lasso"] = 4,
	["Bronze Lasso"] = 5,
	["Iron Lasso"] = 6,
	["Silver Lasso"] = 7,
	["Clear Quartz Lasso"] = 7,
	["Gold Lasso"] = 8,
	["Ruby Lasso"] = 10,
	["Diamond Lasso"] = 12,
	["Sapphire Lasso"] = 14,
	["Topaz Lasso"] = 16,
	["Emerald Lasso"] = 19,
	["Amethyst Lasso"] = 20,
	["Obsidian Lasso"] = 22,
	["Moonstone Lasso"] = 24,
	["Prismatic Lasso"] = 30,
	["Perfect Lasso"] = math.huge
}

--------------------------------------------------
-- IGNORER LES ECURIES / PNJ
--------------------------------------------------

local BAD_NAMES = {
	"stable",
	"stables",
	"shop",
	"store",
	"seller",
	"vendor",
	"npc",
	"merchant",
	"stablehorse",
	"sale",
	"forsale"
}

local function isBadParent(model)

	local current = model

	while current and current ~= workspace do

		local name = current.Name:lower()

		for _,bad in ipairs(BAD_NAMES) do
			if name:find(bad,1,true) then
				return true
			end
		end

		current = current.Parent

	end

	return false
end

--------------------------------------------------
-- VERIFIER CHEVAL
--------------------------------------------------

local function isHorse(model)

	if not model:IsA("Model") then
		return false
	end

	if isBadParent(model) then
		return false
	end

	local humanoid = model:FindFirstChildOfClass("Humanoid")
	local root = model:FindFirstChild("HumanoidRootPart")

	if not humanoid or not root then
		return false
	end

	-- évite les PNJ humains
	local name = model.Name:lower()

	if name:find("npc",1,true)
		or name:find("merchant",1,true)
		or name:find("shop",1,true) then
		return false
	end

	-- attributs éventuels
	if model:GetAttribute("Wild") == false then
		return false
	end

	if model:GetAttribute("IsWild") == false then
		return false
	end

	if model:GetAttribute("Capturable") == false then
		return false
	end

	if model:GetAttribute("ForSale") == true then
		return false
	end

	return true
end

--------------------------------------------------
-- TROUVER LES CHEVAUX
--------------------------------------------------

local function getHorses()

	local result = {}

	for _,obj in ipairs(HORSE_FOLDER:GetDescendants()) do

		if isHorse(obj) then

			local root = obj:FindFirstChild("HumanoidRootPart")

			if root then
				table.insert(result,{
					Model = obj,
					Root = root
				})
			end

		end

	end

	return result
end

--------------------------------------------------
-- DISTANCE
--------------------------------------------------

local function getClosestHorse()

	local character = Player.Character

	if not character then
		return nil
	end

	local playerRoot =
		character:FindFirstChild("HumanoidRootPart")

	if not playerRoot then
		return nil
	end

	local closest = nil
	local distance = math.huge

	for _,horse in ipairs(getHorses()) do

		if horse.Root
			and horse.Root.Parent
			and horse.Model.Parent then

			local d =
				(playerRoot.Position - horse.Root.Position).Magnitude

			if d < distance then
				distance = d
				closest = horse
			end

		end

	end

	return closest
end

--------------------------------------------------
-- MEILLEUR LASSO
--------------------------------------------------

local function getBestLasso()

	local character = Player.Character

	if not character then
		return nil,0
	end

	local backpack = Player:FindFirstChild("Backpack")

	local bestTool = nil
	local bestStrength = -1

	local function check(container)

		if not container then
			return
		end

		for _,tool in ipairs(container:GetChildren()) do

			if tool:IsA("Tool") then

				local strength = LASSOS[tool.Name]

				if strength and strength > bestStrength then

					bestStrength = strength
					bestTool = tool

				end

			end

		end

	end

	check(backpack)
	check(character)

	return bestTool,bestStrength
end

--------------------------------------------------
-- EQUIP
--------------------------------------------------

local function equipLasso()

	local character = Player.Character

	if not character then
		return nil
	end

	local humanoid =
		character:FindFirstChildOfClass("Humanoid")

	if not humanoid then
		return nil
	end

	local tool,strength = getBestLasso()

	if not tool then
		warn("Aucun lasso trouvé")
		return nil
	end

	if tool.Parent ~= character then
		humanoid:EquipTool(tool)
		task.wait(0.2)
	end

	return tool,strength
end

--------------------------------------------------
-- TELEPORT AU CHEVAL
--------------------------------------------------

local function moveAboveHorse(horse)

	local character = Player.Character

	if not character then
		return false
	end

	local root =
		character:FindFirstChild("HumanoidRootPart")

	if not root then
		return false
	end

	if not horse
		or not horse.Root
		or not horse.Root.Parent then
		return false
	end

	root.CFrame =
		CFrame.new(
			horse.Root.Position + Vector3.new(0,HEIGHT,0)
		)

	return true
end

--------------------------------------------------
-- UTILISER LE LASSO
--------------------------------------------------

local function useLasso(tool)

	if not tool then
		return
	end

	if tool.Parent ~= Player.Character then
		return
	end

	-- fonctionnement standard d'un Tool Roblox
	pcall(function()
		tool:Activate()
	end)

end

--------------------------------------------------
-- CAPTURE
--------------------------------------------------

local function captureHorse(horse)

	if not horse
		or not horse.Model
		or not horse.Model.Parent then
		return
	end

	local tool = equipLasso()

	if not tool then
		return
	end

	moveAboveHorse(horse)

	task.wait(0.15)

	-- On continue jusqu'à disparition du cheval
	while RUNNING
		and horse.Model
		and horse.Model.Parent do

		-- repositionnement léger si nécessaire
		if horse.Root
			and horse.Root.Parent then

			moveAboveHorse(horse)

		end

		useLasso(tool)

		task.wait(CLICK_DELAY)

	end

end

--------------------------------------------------
-- BOUCLE
--------------------------------------------------

local function startAutoCapture()

	if RUNNING then
		return
	end

	RUNNING = true

	while RUNNING do

		local horse = getClosestHorse()

		if horse then

			captureHorse(horse)

			task.wait(0.25)

		else

			task.wait(CHECK_DELAY)

		end

	end

end

--------------------------------------------------
-- STOP
--------------------------------------------------

local function stopAutoCapture()

	RUNNING = false

end

--------------------------------------------------
-- TOUCHE F6
--------------------------------------------------

UserInputService.InputBegan:Connect(function(input,gpe)

	if gpe then
		return
	end

	if input.KeyCode == Enum.KeyCode.F6 then

		if RUNNING then
			stopAutoCapture()
			print("AUTO CAPTURE OFF")
		else
			task.spawn(startAutoCapture)
			print("AUTO CAPTURE ON")
		end

	end

end)

print("Horse Auto Capture chargé")
print("F6 = ON / OFF")
