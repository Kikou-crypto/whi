--[[
    Wild Horse Islands - Horse Tracker
    Interface v2.0 - Améliorée
    Détection de race + Event
]]

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ============================================
-- CONFIGURATION
-- ============================================

local Config = {
    Theme = "Dark",
    AccentColor = Color3.fromRGB(88, 101, 242),
    BackgroundColor = Color3.fromRGB(30, 31, 34),
    SecondaryColor = Color3.fromRGB(40, 41, 46),
    TextColor = Color3.fromRGB(220, 221, 225),
    SubTextColor = Color3.fromRGB(150, 151, 155),
    SuccessColor = Color3.fromRGB(87, 242, 135),
    WarningColor = Color3.fromRGB(254, 231, 92),
    DangerColor = Color3.fromRGB(237, 66, 69),
    EventColor = Color3.fromRGB(255, 105, 180),
    
    ThumbnailSize = Vector2.new(120, 100),
    MinWindowSize = UDim2.new(0, 500, 0, 400),
    MaxWindowSize = UDim2.new(0, 1200, 0, 900),
}

-- ============================================
-- BASE DE DONNÉES DES RACES
-- ============================================

local BreedDatabase = {
    -- Draft (traits)
    ["Clydesdale"] = {
        category = "Draft",
        size = "Large",
        feathers = true,
        bodyScale = Vector3.new(1.15, 1.15, 1.15),
        distinguishingFeatures = {"long feathers", "broad chest", "high leg action"},
        rarity = "Common"
    },
    ["Shire"] = {
        category = "Draft",
        size = "Large",
        feathers = true,
        bodyScale = Vector3.new(1.2, 1.2, 1.2),
        distinguishingFeatures = {"massive build", "feathered legs", "broad hooves"},
        rarity = "Rare"
    },
    ["Belgian"] = {
        category = "Draft",
        size = "Large",
        feathers = true,
        bodyScale = Vector3.new(1.1, 1.1, 1.1),
        distinguishingFeatures = {"compact muscular", "flaxen mane", "sorrel coat"},
        rarity = "Common"
    },
    ["Percheron"] = {
        category = "Draft",
        size = "Large",
        feathers = true,
        bodyScale = Vector3.new(1.12, 1.12, 1.12),
        distinguishingFeatures = {"grey or black", "clean head", "powerful hindquarters"},
        rarity = "Uncommon"
    },
    
    -- Light (sang léger)
    ["Arabian"] = {
        category = "Light",
        size = "Medium",
        feathers = false,
        bodyScale = Vector3.new(0.9, 0.9, 0.9),
        distinguishingFeatures = {"dished face", "high tail carriage", "refined head"},
        rarity = "Rare"
    },
    ["Thoroughbred"] = {
        category = "Light",
        size = "Medium",
        feathers = false,
        bodyScale = Vector3.new(1.0, 1.0, 1.0),
        distinguishingFeatures = {"deep chest", "long legs", "lean build"},
        rarity = "Common"
    },
    ["Quarter Horse"] = {
        category = "Light",
        size = "Medium",
        feathers = false,
        bodyScale = Vector3.new(1.0, 1.0, 1.0),
        distinguishingFeatures = {"muscular hindquarters", "short back", "stocky build"},
        rarity = "Common"
    },
    
    -- Ponies
    ["Shetland Pony"] = {
        category = "Pony",
        size = "Small",
        feathers = false,
        bodyScale = Vector3.new(0.7, 0.7, 0.7),
        distinguishingFeatures = {"small stature", "thick mane", "round belly"},
        rarity = "Common"
    },
    ["Welsh Pony"] = {
        category = "Pony",
        size = "Small",
        feathers = false,
        bodyScale = Vector3.new(0.75, 0.75, 0.75),
        distinguishingFeatures = {"refined head", "slightly larger than shetland"},
        rarity = "Uncommon"
    },
    ["Icelandic"] = {
        category = "Pony",
        size = "Small",
        feathers = false,
        bodyScale = Vector3.new(0.8, 0.8, 0.8),
        distinguishingFeatures = {"thick double coat", "sturdy build", "mane and tail thick"},
        rarity = "Uncommon"
    },
    
    -- Gaited
    ["Tennessee Walker"] = {
        category = "Gaited",
        size = "Medium",
        feathers = false,
        bodyScale = Vector3.new(1.05, 1.05, 1.05),
        distinguishingFeatures = {"long neck", "smooth gait", "flashy movement"},
        rarity = "Uncommon"
    },
    ["Missouri Fox Trotter"] = {
        category = "Gaited",
        size = "Medium",
        feathers = false,
        bodyScale = Vector3.new(1.0, 1.0, 1.0),
        distinguishingFeatures = {"stocky but agile", "unique trot"},
        rarity = "Uncommon"
    },
    
    -- Warmbloods
    ["Hanoverian"] = {
        category = "Warmblood",
        size = "Medium",
        feathers = false,
        bodyScale = Vector3.new(1.05, 1.05, 1.05),
        distinguishingFeatures = {"athletic build", "strong topline"},
        rarity = "Uncommon"
    },
    ["Dutch Warmblood"] = {
        category = "Warmblood",
        size = "Medium",
        feathers = false,
        bodyScale = Vector3.new(1.05, 1.05, 1.05),
        distinguishingFeatures = {"elegant", "powerful jump"},
        rarity = "Uncommon"
    },
    
    -- Iberian
    ["Andalusian"] = {
        category = "Iberian",
        size = "Medium",
        feathers = false,
        bodyScale = Vector3.new(1.0, 1.0, 1.0),
        distinguishingFeatures = {"arched neck", "flowing mane", "compact muscular"},
        rarity = "Rare"
    },
    ["Lipizzan"] = {
        category = "Iberian",
        size = "Medium",
        feathers = false,
        bodyScale = Vector3.new(0.95, 0.95, 0.95),
        distinguishingFeatures = {"grey coat", "classical build"},
        rarity = "Rare"
    },
    
    -- Color breeds
    ["Appaloosa"] = {
        category = "Color",
        size = "Medium",
        feathers = false,
        bodyScale = Vector3.new(1.0, 1.0, 1.0),
        distinguishingFeatures = {"spotted coat", "mottled skin", "striped hooves"},
        rarity = "Uncommon"
    },
    ["Paint Horse"] = {
        category = "Color",
        size = "Medium",
        feathers = false,
        bodyScale = Vector3.new(1.0, 1.0, 1.0),
        distinguishingFeatures = {"tobiano pattern", "two-tone patches"},
        rarity = "Common"
    },
    ["Friesian"] = {
        category = "Color",
        size = "Medium",
        feathers = true,
        bodyScale = Vector3.new(1.05, 1.05, 1.05),
        distinguishingFeatures = {"all black", "long wavy mane", "feathered legs"},
        rarity = "Rare"
    },
    
    -- Autres
    ["Mustang"] = {
        category = "Wild",
        size = "Medium",
        feathers = false,
        bodyScale = Vector3.new(0.95, 0.95, 0.95),
        distinguishingFeatures = {"hardy build", "primitive markings"},
        rarity = "Common"
    },
    ["Gypsy Vanner"] = {
        category = "Draft",
        size = "Medium-Large",
        feathers = true,
        bodyScale = Vector3.new(1.05, 1.05, 1.05),
        distinguishingFeatures = {"piebald/skewbald", "abundant feathers", "abundant mane"},
        rarity = "Rare"
    },
    ["Haflinger"] = {
        category = "Pony",
        size = "Small-Medium",
        feathers = false,
        bodyScale = Vector3.new(0.85, 0.85, 0.85),
        distinguishingFeatures = {"chestnut with flaxen", "sturdy pony build"},
        rarity = "Uncommon"
    },
    ["Fjord"] = {
        category = "Pony",
        size = "Small",
        feathers = false,
        bodyScale = Vector3.new(0.8, 0.8, 0.8),
        distinguishingFeatures = {"dun coat", "creamy mane with dark center", "upright mane"},
        rarity = "Uncommon"
    },
    ["Morgan"] = {
        category = "Light",
        size = "Medium",
        feathers = false,
        bodyScale = Vector3.new(0.95, 0.95, 0.95),
        distinguishingFeatures = {"arched neck", "compact", "expressive"},
        rarity = "Uncommon"
    },
    ["Connemara"] = {
        category = "Pony",
        size = "Small-Medium",
        feathers = false,
        bodyScale = Vector3.new(0.85, 0.85, 0.85),
        distinguishingFeatures = {"grey common", "athletic pony"},
        rarity = "Uncommon"
    },
    ["Standardbred"] = {
        category = "Light",
        size = "Medium",
        feathers = false,
        bodyScale = Vector3.new(1.0, 1.0, 1.0),
        distinguishingFeatures = {"harness racing build", "long stride"},
        rarity = "Common"
    },
    ["Saddlebred"] = {
        category = "Gaited",
        size = "Medium",
        feathers = false,
        bodyScale = Vector3.new(1.0, 1.0, 1.0),
        distinguishingFeatures = {"high stepping", "long neck", "proud carriage"},
        rarity = "Uncommon"
    },
    ["Miniature Horse"] = {
        category = "Pony",
        size = "Tiny",
        feathers = false,
        bodyScale = Vector3.new(0.5, 0.5, 0.5),
        distinguishingFeatures = {"very small", "miniature proportions"},
        rarity = "Rare"
    },
}

-- ============================================
-- BASE DE DONNÉES DES EVENTS
-- ============================================

local EventDatabase = {
    -- Halloween
    ["Nightmare"] = {event = "Halloween", year = "2022", rarity = "Legendary"},
    ["Zomb Horse"] = {event = "Halloween", year = "2022", rarity = "Legendary"},
    ["Headless Horse"] = {event = "Halloween", year = "2023", rarity = "Legendary"},
    ["Pumpkin Horse"] = {event = "Halloween", year = "2023", rarity = "Epic"},
    ["Wraith Horse"] = {event = "Halloween", year = "2024", rarity = "Legendary"},
    
    -- Christmas
    ["Reindeer Horse"] = {event = "Christmas", year = "2022", rarity = "Legendary"},
    ["Frost Horse"] = {event = "Christmas", year = "2022", rarity = "Epic"},
    ["North Star"] = {event = "Christmas", year = "2023", rarity = "Legendary"},
    ["Ice Crystal Horse"] = {event = "Christmas", year = "2023", rarity = "Epic"},
    ["Aurora Horse"] = {event = "Christmas", year = "2024", rarity = "Legendary"},
    
    -- Easter
    ["Bunny Horse"] = {event = "Easter", year = "2022", rarity = "Epic"},
    ["Egg Hunt Horse"] = {event = "Easter", year = "2023", rarity = "Epic"},
    ["Spring Bloom Horse"] = {event = "Easter", year = "2024", rarity = "Epic"},
    
    -- Valentine
    ["Cupid Horse"] = {event = "Valentine", year = "2022", rarity = "Epic"},
    ["Heart Horse"] = {event = "Valentine", year = "2023", rarity = "Epic"},
    ["Rose Horse"] = {event = "Valentine", year = "2024", rarity = "Epic"},
    
    -- Summer
    ["Tropical Horse"] = {event = "Summer", year = "2022", rarity = "Epic"},
    ["Beach Horse"] = {event = "Summer", year = "2023", rarity = "Epic"},
    ["Sunset Horse"] = {event = "Summer", year = "2024", rarity = "Epic"},
    
    -- St. Patrick's
    ["Lucky Horse"] = {event = "St. Patrick", year = "2022", rarity = "Epic"},
    ["Rainbow Horse"] = {event = "St. Patrick", year = "2023", rarity = "Legendary"},
    ["Clover Horse"] = {event = "St. Patrick", year = "2024", rarity = "Epic"},
    
    -- Autres events
    ["Unicorn"] = {event = "Special", year = "2022", rarity = "Mythic"},
    ["Pegasus"] = {event = "Special", year = "2022", rarity = "Mythic"},
    ["Alicorn"] = {event = "Special", year = "2023", rarity = "Mythic"},
    ["Dragon Horse"] = {event = "Special", year = "2023", rarity = "Mythic"},
    ["Phoenix Horse"] = {event = "Special", year = "2024", rarity = "Mythic"},
}

-- ============================================
-- FONCTIONS DE DÉTECTION
-- ============================================

local HorseDetector = {}

function HorseDetector:AnalyzeBodyProportions(model)
    -- Analyse les proportions du corps pour déterminer la catégorie
    local bodyParts = {}
    local totalSize = Vector3.new(0, 0, 0)
    local partCount = 0
    
    for _, part in pairs(model:GetDescendants()) do
        if part:IsA("BasePart") then
            table.insert(bodyParts, part)
            totalSize = totalSize + part.Size
            partCount = partCount
