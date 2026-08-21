--========================================================--
--      PRISMATIC HALTER AUTO - VERSION 300 HALTERS
--      Pour TON PROPRE JEU / Roblox Studio
--========================================================--

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local Running = false

--========================================================--
-- CONFIGURATION
--========================================================--

local CONFIG = {

    -- 1 Halter = 1 Gem + 2 Leather
    GEM_PER_HALTER = 1,
    LEATHER_PER_HALTER = 2,

    -- Quantité disponible/achetée
    PRISMATIC_GEMS = 300,
    LEATHER = 600,

    -- Calcul automatique :
    -- 300 Gems / 1 Gem = 300 Halters
    HALTERS_PER_CYCLE = 300,

    CLICK_DELAY = 0.35,
    CRAFT_DELAY = 0.7,
    UI_TIMEOUT = 5,

    LOOP = true,

    -- F8 = ON/OFF
    TOGGLE_KEY = Enum.KeyCode.F8,
}


--========================================================--
-- NORMALISATION DU TEXTE
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
-- RECHERCHE DANS PLAYERGUI
--========================================================--

local function findExact(text, timeout)

    text = normalize(text)
    timeout = timeout or CONFIG.UI_TIMEOUT

    local startTime = os.clock()

    while os.clock() - startTime < timeout do

        for _, obj in ipairs(PlayerGui:GetDescendants()) do

            if obj:IsA("GuiObject") and obj.Visible then

                if getText(obj) == text then
                    return obj
                end

            end
        end

        task.wait(0.1)
    end

    return nil
end


local function findContains(text, timeout)

    text = normalize(text)
    timeout = timeout or CONFIG.UI_TIMEOUT

    local startTime = os.clock()

    while os.clock() - startTime < timeout do

        for _, obj in ipairs(PlayerGui:GetDescendants()) do

            if obj:IsA("GuiObject") and obj.Visible then

                local objectText = getText(obj)

                if string.find(objectText, text, 1, true) then
                    return obj
                end

            end
        end

        task.wait(0.1)
    end

    return nil
end


--========================================================--
-- CLICK
--========================================================--

local function activate(obj)

    if not obj then
        return false
    end

    if obj:IsA("GuiButton") then

        print("[AUTO] CLICK ->", getText(obj))

        obj:Activate()

        task.wait(CONFIG.CLICK_DELAY)

        return true
    end

    warn("[AUTO] Objet trouvé mais ce n'est pas un bouton")

    return false
end


local function clickExact(text)

    local obj = findExact(text)

    if not obj then

        warn("[AUTO] Bouton introuvable :", text)

        return false
    end

    return activate(obj)
end


local function clickContains(text)

    local obj = findContains(text)

    if not obj then

        warn("[AUTO] Bouton contenant '" .. text .. "' introuvable")

        return false
    end

    return activate(obj)
end


--========================================================--
-- TEXTBOX DE QUANTITÉ CHEZ LARRY
--========================================================--

local function findQuantityBox()

    local boxes = {}

    for _, obj in ipairs(PlayerGui:GetDescendants()) do

        if obj:IsA("TextBox") and obj.Visible then
            table.insert(boxes, obj)
        end

    end

    -- Si une seule TextBox est visible
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

        warn("[AUTO] TextBox de quantité introuvable")

        return false
    end

    print("[AUTO] QUANTITÉ ->", amount)

    box:CaptureFocus()

    box.Text = tostring(amount)

    task.wait(0.15)

    box:ReleaseFocus()

    task.wait(0.3)

    return true
end


--========================================================--
-- ACHETER UN OBJET CHEZ LARRY
--========================================================--

local function buyItem(itemName, amount)

    print("")
    print("------------------------------------------")
    print("[AUTO] ACHAT :", amount, "x", itemName)
    print("------------------------------------------")


    -- Bouton Buy
    if not clickExact("Buy") then
        return false
    end

    task.wait(0.5)


    -- Sélection de l'objet
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


    -- Validation de l'achat
    if not clickExact("Buy") then

        warn("[AUTO] Bouton Buy de validation introuvable")

        return false
    end

    task.wait(1)

    print("[AUTO] ACHAT TERMINÉ")

    return true
end


--========================================================--
-- CRAFT D'UN SEUL HALTER
--========================================================--

local function craftOneHalter()

    -- IMPORTANT :
    -- On recommence complètement à chaque Halter.

    print("[AUTO] Nouveau Halter")


    -- 1. Cliquer Halter
    if not clickContains("Halter") then

        warn("[AUTO] Halter introuvable")

        return false
    end

    task.wait(0.3)


    -- 2. Select Rarity
    if not clickContains("Select Rarity") then

        warn("[AUTO] Select Rarity introuvable")

        return false
    end

    task.wait(0.3)


    -- 3. Prismatic
    if not clickExact("Prismatic") then

        warn("[AUTO] Prismatic introuvable")

        return false
    end

    task.wait(0.3)


    -- 4. Craft
    if not clickExact("Craft") then

        warn("[AUTO] Craft introuvable")

        return false
    end


    -- Attendre que le jeu termine le craft
    task.wait(CONFIG.CRAFT_DELAY)

    return true
end


--========================================================--
-- CRAFT DES 300 HALTERS
--========================================================--

local function craftAllHalters()

    local amount = CONFIG.HALTERS_PER_CYCLE

    print("")
    print("==========================================")
    print("[AUTO] CRAFT :", amount, "HALTERS")
    print("==========================================")
    print("")


    for i = 1, amount do

        -- Permet d'arrêter avec F8
        if not Running then

            print("[AUTO] Arrêt demandé.")

            return false
        end


        print(
            "[AUTO] HALTER",
            i,
            "/",
            amount
        )


        local success = craftOneHalter()

        if not success then

            warn(
                "[AUTO] Échec au Halter",
                i,
                "/",
                amount
            )

            return false
        end


        -- Petite pause
        task.wait(0.2)
    end


    print("")
    print("==========================================")
    print("[AUTO] 300 HALTERS CRAFTÉS")
    print("==========================================")
    print("")

    return true
end


--========================================================--
-- VENTE DES HALTERS
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

    task.wait(0.7)


    -- Sélection du Halter
    local halter = findContains("halter")

    if not halter then

        warn("[AUTO] Halter introuvable dans le menu Sell")

        return false
    end


    print("[AUTO] Sélection du Halter")

    if not activate(halter) then
        return false
    end

    task.wait(0.5)


    -- Done
    if not clickExact("Done") then

        warn("[AUTO] Done introuvable")

        return false
    end

    task.wait(1)


    print("[AUTO] VENTE TERMINÉE")

    return true
end


--========================================================--
-- CYCLE COMPLET
--========================================================--

local function runCycle()

    print("")
    print("")
    print("##########################################")
    print("#           NOUVEAU CYCLE               #")
    print("##########################################")
    print("")


    --====================================================--
    -- 300 PRISMATIC GEMS
    --====================================================--

    if not buyItem(
        "Prismatic Gem",
        CONFIG.PRISMATIC_GEMS
    ) then

        warn("[AUTO] Achat des Gems échoué")

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

        warn("[AUTO] Achat du Leather échoué")

        return false
    end


    task.wait(1)


    --====================================================--
    -- OUVRIR CRAFTING
    --====================================================--

    print("[AUTO] Ouverture du Crafting")

    if not clickExact("Craft") then

        warn("[AUTO] Menu Crafting introuvable")

        return false
    end

    task.wait(1)


    --====================================================--
    -- 300 HALTERS
    --====================================================--

    if not craftAllHalters() then

        warn("[AUTO] Craft des Halters échoué")

        return false
    end


    task.wait(1)


    --====================================================--
    -- VENDRE
    --====================================================--

    if not sellHalters() then

        warn("[AUTO] Vente échouée")

        return false
    end


    print("")
    print("##########################################")
    print("#          CYCLE TERMINÉ                #")
    print("##########################################")
    print("")


    return true
end


--========================================================--
-- START
--========================================================--

local function start()

    if Running then

        print("[AUTO] Déjà activé.")

        return
    end


    Running = true


    print("")
    print("==========================================")
    print("     PRISMATIC HALTER AUTO ACTIVÉ")
    print("==========================================")
    print("")
    print("300 Gems")
    print("600 Leather")
    print("300 Halters")
    print("1 Gem + 2 Leather / Halter")
    print("")


    task.spawn(function()

        while Running do

            local success = runCycle()


            if not success then

                warn("")
                warn("[AUTO] ERREUR - AUTOMATISATION ARRÊTÉE")
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
    print("[AUTO] ARRÊTÉ")
    print("")
end


--========================================================--
-- F8 ON / OFF
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
-- FIN
--========================================================--

print("")
print("==========================================")
print("  PRISMATIC HALTER AUTO CHARGÉ")
print("==========================================")
print("")
print("F8 = ON / OFF")
print("")
print("1 Halter = 1 Prismatic Gem + 2 Leather")
print("300 Gems + 600 Leather = 300 Halters")
print("")
print("Craft de CHAQUE Halter :")
print("Halter")
print("-> Select Rarity")
print("-> Prismatic")
print("-> Craft")
print("")
print("Puis vente des Halters.")
print("==========================================")
