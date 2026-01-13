--// Wind UI
local WindUI = loadstring(game:HttpGet(
    "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
))()

local Window = WindUI:CreateWindow({
    Title = "Container RNG by Xapongg",
    Icon = "package"
})

local MainTab = Window:Tab({ Title = "Main", Icon = "home" })
local MiscTab = Window:Tab({ Title = "Misc", Icon = "settings" })
local ShopTab = Window:Tab({ Title = "Shop", Icon = "shopping-bag" })

--// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = Players.LocalPlayer

--// Remote
local Reliable = ReplicatedStorage
    :WaitForChild("Modules")
    :WaitForChild("Shared")
    :WaitForChild("Warp")
    :WaitForChild("Index")
    :WaitForChild("Event")
    :WaitForChild("Reliable")

--// Plot
local function GetPlot()
    return workspace
        :WaitForChild("Gameplay")
        :WaitForChild("Plots")
        :WaitForChild(tostring(Player.UserId))
        :WaitForChild("PlotLogic")
end

--// States
local AutoOpen = false
local AutoCollect = false
local AutoPlace = false
local SpeedEnabled = false
local WalkSpeedValue = 16

--------------------------------------------------
--// UTIL: ITEM DI AREA CONTAINER SAJA
--------------------------------------------------
local function IsItemInContainerArea(item, container)
    local part = item:IsA("BasePart") and item or item:FindFirstChildWhichIsA("BasePart")
    if not part then return false end

    local cf, size = container:GetBoundingBox()
    local half = size / 2
    local rel = cf:PointToObjectSpace(part.Position)

    return math.abs(rel.X) <= half.X
       and math.abs(rel.Y) <= half.Y
       and math.abs(rel.Z) <= half.Z
end

--------------------------------------------------
--// AUTO OPEN CONTAINER
--------------------------------------------------
task.spawn(function()
    while task.wait(0.3) do
        if not AutoOpen then continue end
        local plot = GetPlot()
        local holder = plot:FindFirstChild("ContainerHolder")
        if not holder then continue end

        for _, c in ipairs(holder:GetChildren()) do
            Reliable:FireServer(
                buffer.fromstring("K"),
                buffer.fromstring("\254\001\000\006." .. c.Name)
            )
            task.wait(0.05)
        end
    end
end)

--------------------------------------------------
--// AUTO COLLECT (ANTI SELLZONE)
--------------------------------------------------
task.spawn(function()
    while task.wait(0.25) do
        if not AutoCollect then continue end
        local plot = GetPlot()
        local holder = plot:FindFirstChild("ContainerHolder")
        local cache = plot:FindFirstChild("ItemCache")
        if not holder or not cache then continue end

        for _, container in ipairs(holder:GetChildren()) do
            for _, item in ipairs(cache:GetChildren()) do
                if IsItemInContainerArea(item, container) then
                    Reliable:FireServer(
                        buffer.fromstring("\v"),
                        buffer.fromstring("\254\001\000\006)" .. item.Name)
                    )
                    task.wait(0.05)
                end
            end
        end
    end
end)

--------------------------------------------------
--// AUTO PLACE (SELL ZONE)
--------------------------------------------------
task.spawn(function()
    while task.wait(0.4) do
        if AutoPlace then
            Reliable:FireServer(
                buffer.fromstring("\t"),
                buffer.fromstring("\254\000\000")
            )
        end
    end
end)

--------------------------------------------------
--// SPEED
--------------------------------------------------
task.spawn(function()
    while task.wait(0.2) do
        if SpeedEnabled then
            local hum = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = WalkSpeedValue end
        end
    end
end)

--------------------------------------------------
--// SHOP SYSTEM (AUTO BUY TOGGLE) - PRICE BASED
--------------------------------------------------

local ShopData = {
    { name = "JunkContainer", price = 100 },
    { name = "ScratchedContainer", price = 200 },
    { name = "SealedContainer", price = 700 },
    { name = "MilitaryContainer", price = 3000 },
    { name = "MetalContainer", price = 10000 },
    { name = "FrozenContainer", price = 25000 },
    { name = "LavaContainer", price = 50000 },
    { name = "StormedContainer", price = 250000 },
    { name = "LightningContainer", price = 500000 },
    { name = "InfernalContainer", price = 750000 },
    { name = "MysticContainer", price = 1500000 },
    { name = "GlitchedContainer", price = 5000000 },
    { name = "AstralContainer", price = 10000000 },
    { name = "DreamContainer", price = 25000000 },
    { name = "CelestialContainer", price = 50000000 },
    { name = "GoldenContainer", price = 250000000 },
    { name = "DiamondContainer", price = 500000000 },
    { name = "EmeraldContainer", price = 2500000000 },
    { name = "RubyContainer", price = 10000000000 },
    { name = "SapphireContainer", price = 75000000000 },
    { name = "SpaceContainer", price = 150000000000 },
    { name = "DeepSpaceContainer", price = 500000000000 },
    { name = "VortexContainer", price = 1000000000000 },
    { name = "BlackHoleContainer", price = 2500000000000 },
    { name = "CamoContainer", price = 5000000000000 },
    { name = "ObsidianContainer", price = 50000000000000 },
    { name = "GoldenAuraContainer", price = 200000000000000 },
    { name = "ChristmasContainer", price = 2000000000000000 },
    { name = "MedievalContainer", price = 30000000000000000 },
}

-- SORT TERMURAH → TERMAHAL
table.sort(ShopData, function(a, b)
    return a.price < b.price
end)

local function formatPrice(p)
    if p >= 1e15 then return (p/1e15) .. "qd"
    elseif p >= 1e12 then return (p/1e12) .. "T"
    elseif p >= 1e9 then return (p/1e9) .. "B"
    elseif p >= 1e6 then return (p/1e6) .. "M"
    elseif p >= 1e3 then return (p/1e3) .. "K"
    else return tostring(p)
    end
end

local DisplayPrices = {}
local PriceToItem = {}

for _, v in ipairs(ShopData) do
    local label = formatPrice(v.price)
    table.insert(DisplayPrices, label)
    PriceToItem[label] = v.name
end

local AmountOptions = { "1","2","3","4","5","6","7","8" }

local SelectedItem = nil
local SelectedAmount = 1
local AutoBuy = false

local function BuyItem(itemName)
    local prefix = string.char(#itemName)
    Reliable:FireServer(
        buffer.fromstring("I"),
        buffer.fromstring("\254\001\000\006" .. prefix .. itemName)
    )
end

-- DROPDOWN JUMLAH
ShopTab:Dropdown({
    Title = "Amount",
    Desc = "Jumlah beli per loop",
    Values = AmountOptions,
    Value = "1",
    Callback = function(v)
        SelectedAmount = tonumber(v) or 1
    end
})

-- DROPDOWN HARGA (TERMURAH)
ShopTab:Dropdown({
    Title = "Select Price",
    Desc = "Urut dari termurah",
    Values = DisplayPrices,
    Search = true,
    Callback = function(v)
        SelectedItem = PriceToItem[v]
    end
})

-- TOGGLE AUTO BUY
ShopTab:Toggle({
    Title = "Auto Buy Container",
    Desc = "Auto beli container (loop)",
    Icon = "repeat",
    Type = "Checkbox",
    Value = false,
    Callback = function(v)
        AutoBuy = v
    end
})

-- LOOP AUTO BUY
task.spawn(function()
    while task.wait(0.3) do
        if not AutoBuy then continue end
        if not SelectedItem or SelectedAmount <= 0 then continue end

        for i = 1, SelectedAmount do
            if not AutoBuy then break end
            BuyItem(SelectedItem)
            task.wait(0.15)
        end
    end
end)



--------------------------------------------------
--// UI MAIN
--------------------------------------------------
MainTab:Toggle({
    Title = "Auto Open Container",
    Icon = "box",
    Type = "Checkbox",
    Callback = function(v) AutoOpen = v end
})

MainTab:Toggle({
    Title = "Auto Collect Item",
    Icon = "download",
    Type = "Checkbox",
    Callback = function(v) AutoCollect = v end
})

MainTab:Toggle({
    Title = "Auto Place (Sell Zone)",
    Icon = "shopping-cart",
    Type = "Checkbox",
    Callback = function(v) AutoPlace = v end
})

--------------------------------------------------
--// UI MISC
--------------------------------------------------
MiscTab:Toggle({
    Title = "Enable Speed",
    Icon = "zap",
    Type = "Checkbox",
    Callback = function(v)
        SpeedEnabled = v
        if not v then
            local hum = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = 16 end
        end
    end
})

MiscTab:Slider({
    Title = "Walk Speed",
    Step = 1,
    Value = {
        Min = 16,
        Max = 150,
        Default = 16,
    },
    Callback = function(v)
        WalkSpeedValue = v
    end
})



