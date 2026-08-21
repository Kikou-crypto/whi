--========================================================--
--       PRISMATIC HALTER AUTO - VERSION 300
--       TEST POUR TON PROPRE JEU ROBLOX
--========================================================--

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local Running = false

--========================================================--
-- CONFIG
--========================================================--

local CONFIG = {

    -- 1 Halter Prismatic =
    -- 1 Prismatic Gem
    -- 2 Leather

    PRISMATIC_GEMS = 300,
    LEATHER = 600,

    HALTERS_PER_CYCLE = 300,

    CLICK_DELAY = 0.30,
    CRAFT_DELAY = 0.70,
    UI_TIMEOUT = 5,

    LOOP = true,

    TOGGLE_KEY = Enum.KeyCode.F8,
}


--========================================================--
-- NORMALISATION
--========================================================--

local function normalize(text)

    if not text then
        return ""
    end

    text = tostring(text)

    text = string.gsub(text, "%s+", " ")
    text = string.gsub(text, "^%s*(.-)%s*$", "%1")

    return string.lower(text)
end


local function getText(obj)

    if obj:IsA("TextButton")
        or obj:IsA("TextLabel")
        or obj:IsA("TextBox") then

        return normalize(obj.Text)
    end

    return ""
end


--========================================================--
-- TROUVER UN VRAI BOUTON
--========================================================--

local function findButtonExact(text, timeout)

    text = normalize(text)
    timeout = timeout or CONFIG.UI_TIMEOUT

    local startTime = os.clock()

    while os.clock() - startTime < timeout do

        for _, obj in ipairs(PlayerGui:GetDescendants()) do

            if obj:IsA("GuiButton")
                and obj.Visible
                and getText(obj) == text then

                return obj
            end
        end

        task.wait(0.1)
    end

    return nil
end


local function findButtonContains(text, timeout)

    text = normalize(text)
    timeout = timeout or CONFIG.UI_TIMEOUT

    local startTime = os.clock()

    while os.clock() - startTime < timeout do

        for _, obj in ipairs(PlayerGui:GetDescendants()) do

            if obj:IsA("GuiButton")
                and obj.Visible then

                local buttonText = getText(obj)

                if string.find(buttonText, text, 1, true) then
                    return obj
                end
            end
        end

        task.wait(0.1)
    end

    return nil
end


--========================================================--
-- CLIQUER
--========================================================--

local function activate(obj)

    if not obj then
        return false
    end

    if not obj:IsA("GuiButton") then
        return false
    end

    print("[AUTO] CLICK ->", getText(obj))

    obj:Activate()

    task.wait(CONFIG.CLICK_DELAY)

    return true
end


local function clickExact(text)

    local button = findButtonExact(text)

    if not button then

        warn("[AUTO] Bouton introuvable :", text)

        return false
    end

    return activate(button)
end


local function clickContains(text)

    local button = findButtonContains(text)

    if not button then

        warn("[AUTO] Bouton introuvable :", text)

        return false
    end

    return activate(button)
end


--========================================================--
-- TEXTBOX LARRY
--========================================================--

local function findQuantityBox()

    local boxes = {}

    for _, obj in ipairs(PlayerGui:GetDescendants()) do

        if obj:IsA("TextBox")
            and obj.Visible then

            table.insert(boxes, obj)
        end
    end


    -- Une seule TextBox visible
    if #boxes == 1 then
        return boxes[1]
    end


    -- Chercher celle qui contient déjà un nombre
    for _, box in ipairs(boxes) do

        if tonumber(box.Text) ~= nil then
            return box
        end
    end


    return nil
end


local function setQuantity(amount)

    local box = findQuantityBox()

    if not box then

        warn("[AUTO] TextBox quantité introuvable")

        return false
    end


    print("[AUTO] QUANTITÉ ->", amount)


    box:CaptureFocus()

    box.Text = tostring(amount)

    task.wait(0.15)

    box:ReleaseFocus()

    task.wait(0.30)


    return true
end


--========================================================--
-- ACHAT LARRY
--========================================================--

local function buyItem(itemName, amount)

    print("")
    print("------------------------------------------")
    print("[AUTO] ACHAT :", amount, "x", itemName)
    print("------------------------------------------")


    -- Buy
    if not clickExact("Buy") then
        return false
    end

    task.wait(0.5)


    -- Objet
    if not clickContains(itemName) then

        warn("[AUTO] Objet introuvable :", itemName)

        return false
    end

    task.wait(0.5)


    -- Quantité
    if not setQuantity(amount) then
        return false
    end

    task.wait(0.3)


    -- Validation
    if not clickExact("Buy") then

        warn("[AUTO] Validation Buy introuvable")

        return false
    end


    task.wait(1)


    print("[AUTO] ACHAT TERMINÉ :", itemName)

    return true
end


--========================================================--
-- CRAFT D'UN HALTER
--========================================================--

local function craftOneHalter()

    print("[AUTO] Nouveau Halter")


    -- HALTER
    if not clickContains("Halter") then

        warn("[AUTO] Halter introuvable")

        return false
    end

    task.wait(0.3)


    -- SELECT RARITY
    if not clickContains("Select Rarity") then

        warn("[AUTO] Select Rarity introuvable")

        return false
    end

    task.wait(0.3)


    -- PRISMATIC
    if not clickExact("Prismatic") then

        warn("[AUTO] Prismatic introuvable")

        return false
    end

    task.wait(0.3)


    -- CRAFT
    if not clickExact("Craft") then

        warn("[AUTO] Craft introuvable")

        return false
    end


    -- Attendre la fin du craft
    task.wait(CONFIG.CRAFT_DELAY)


    return true
end


--========================================================--
-- CRAFT DES 300 HALTERS
--========================================================--

local function craftAllHalters()

    local total = CONFIG.HALTERS_PER_CYCLE


    print("")
    print("==========================================")
    print("[AUTO] CRAFT DE", total, "HALTERS")
    print("==========================================")
    print("")


    for i = 1, total do

        if not Running then

            print("[AUTO] Arrêt demandé.")

            return false
        end


        print(
            "[AUTO] HALTER",
            i,
            "/",
            total
        )


        local success = craftOneHalter()


        if not success then

            warn(
                "[AUTO] ÉCHEC DU CRAFT :",
                i,
                "/",
                total
            )

            return false
        end


        task.wait(0.20)
    end


    print("")
    print("==========================================")
    print("[AUTO] 300 HALTERS CRAFTÉS")
    print("==========================================")
    print("")


    return true
end


--========================================================--
-- TROUVER LES BOUTONS HALTER POUR LA VENTE
--========================================================--

local function getVisibleHalterButtons()

    local buttons = {}


    for _, obj in ipairs(PlayerGui:GetDescendants()) do

        if obj:IsA("GuiButton")
            and obj.Visible then

            local text = getText(obj)

            if string.find(text, "halter", 1, true) then

                table.insert(buttons, obj)
            end
        end
    end


    return buttons
end


--========================================================--
-- VENTE
--========================================================--

local function sellHalters()

    print("")
    print("==========================================")
    print("[AUTO] VENTE DES HALTERS")
    print("==========================================")
    print("")


    -- Larry -> Sell
    if not clickExact("Sell") then

        warn("[AUTO] Sell introuvable")

        return false
    end


    task.wait(0.8)


    --====================================================--
    -- TROUVER LES HALTERS DANS LE MENU DE VENTE
    --====================================================--

    local halterButtons = getVisibleHalterButtons()


    if #halterButtons == 0 then

        warn("[AUTO] Aucun bouton Halter trouvé dans Sell")

        return false
    end


    print(
        "[AUTO] Boutons Halter trouvés :",
        #halterButtons
    )


    --====================================================--
    -- SÉLECTION
    --====================================================--

    for _, button in ipairs(halterButtons) do

        if not Running then
            return false
        end


        print(
            "[AUTO] Sélection :",
            getText(button)
        )


        activate(button)

        task.wait(0.20)
    end


    task.wait(0.5)


    --====================================================--
    -- DONE
    --====================================================--

    if not clickExact("Done") then

        warn("[AUTO] Done introuvable")

        return false
    end


    task.wait(1)


    print("[AUTO] HALTERS VENDUS")


    return true
end


--========================================================--
-- CYCLE COMPLET
--========================================================--

local function runCycle()

    print("")
    print("")
    print("##########################################")
    print("#             NOUVEAU CYCLE             #")
    print("##########################################")
    print("")


    --====================================================--
    -- 300 PRISMATIC GEMS
    --====================================================--

    if not buyItem(
        "Prismatic Gem",
        CONFIG.PRISMATIC_GEMS
    ) then

        warn("[AUTO] Échec achat Gems")

        return false
    end


    task.wait(1)


    --====================================================--
    -- 600 LEATHER
    --====================================================--

    if not buyItem(
        "Leather",
        CONFIG.LEATHER
    ) then

        warn("[AUTO] Échec achat Leather")

        return false
    end


    task.wait(1)


    --====================================================--
    -- OUVRIR CRAFTING
    --====================================================--

    print("[AUTO] Ouverture Crafting")


    if not clickExact("Craft") then

        warn("[AUTO] Menu Crafting introuvable")

        return false
    end


    task.wait(1)


    --====================================================--
    -- 300 CRAFTS
    --====================================================--

    if not craftAllHalters() then

        warn("[AUTO] Échec des crafts")

        return false
    end


    task.wait(1)


    --====================================================--
    -- SELL
    --====================================================--

    if not sellHalters() then

        warn("[AUTO] Échec de la vente")

        return false
    end


    print("")
    print("##########################################")
    print("#             CYCLE FINI                #")
    print("##########################################")
    print("")


    return true
end


--========================================================--
-- START
--========================================================--

local function start()

    if Running then

        print("[AUTO] Déjà actif.")

        return
    end


    Running = true


    print("")
    print("==========================================")
    print("       PRISMATIC HALTER AUTO ON")
    print("==========================================")
    print("")
    print("300 Prismatic Gems")
    print("600 Leather")
    print("300 Halters")
    print("")
    print("1 Gem + 2 Leather = 1 Halter")
    print("")
    print("F8 = STOP")
    print("")


    task.spawn(function()

        while Running do


            local success = runCycle()


            if not success then

                warn("")
                warn("==========================================")
                warn("[AUTO] ERREUR")
                warn("[AUTO] AUTOMATISATION ARRÊTÉE")
                warn("==========================================")
                warn("")


                Running = false

                break
            end


            if not CONFIG.LOOP then

                Running = false

                break
            end


            task.wait(1)
        end
    end)
end


--========================================================--
-- STOP
--========================================================--

local function stop()

    Running = false

    print("")
    print("==========================================")
    print("[AUTO] ARRÊTÉ")
    print("==========================================")
    print("")
end


--========================================================--
-- F8 ON/OFF
--========================================================--

UserInputService.InputBegan:Connect(function(
    input,
    gameProcessed
)

    if gameProcessed then
        return
    end


    if input.KeyCode == CONFIG.TOGGLE_KEY then

        if Running then
            stop()
        else
            start()
        end

    end
end)


--========================================================--
-- COMMANDES MANUELLES
--========================================================--

_G.HalterAutoStart = start
_G.HalterAutoStop = stop


--========================================================--
-- CHARGÉ
--========================================================--

print("")
print("==========================================")
print("     PRISMATIC HALTER AUTO CHARGÉ")
print("==========================================")
print("")
print("F8 = ON / OFF")
print("")
print("300 Gems")
print("600 Leather")
print("300 Halters")
print("")
print("Craft :")
print("Halter")
print("-> Select Rarity")
print("-> Prismatic")
print("-> Craft")
print("")
print("Puis Sell -> Halter(s) -> Done")
print("==========================================")
