--// Wind UI
local WindUI = loadstring(game:HttpGet(
    "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
))()

local Window = WindUI:CreateWindow({
    Title = "Pickaxe Simulator",
    Icon = "package", -- lucide icon
    Author = "Xapongg",
    Folder = "PickaxeSimulator",

    -- ↓ This all is Optional. You can remove it.
    Size = UDim2.fromOffset(580, 460),
    MinSize = Vector2.new(560, 350),
    MaxSize = Vector2.new(850, 560),
    Transparent = true,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 200,
    BackgroundImageTransparency = 0.42,--// Wind UI
local WindUI = loadstring(game:HttpGet(
    "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
))()

local Window = WindUI:CreateWindow({
    Title = "Pickaxe Simulator",
    Icon = "package", -- lucide icon
    Author = "Xapongg",
    Folder = "PickaxeSimulator",

    -- ↓ This all is Optional. You can remove it.
    Size = UDim2.fromOffset(580, 460),
    MinSize = Vector2.new(560, 350),
    MaxSize = Vector2.new(850, 560),
    Transparent = true,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 200,
    BackgroundImageTransparency = 0.42,
    HideSearchBar = true,
    ScrollBarEnabled = false,

    -- ↓ Optional. You can remove it.
    --[[ You can set 'rbxassetid://' or video to Background.
        'rbxassetid://':
            Background = "rbxassetid://", -- rbxassetid
        Video:
            Background = "video:YOUR-RAW-LINK-TO-VIDEO.webm", -- video 
    --]]

    -- ↓ Optional. You can remove it.
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            print("clicked")
        end,
    },
})

Window:EditOpenButton({
    Title = "Pickaxe Sim",
    Icon = "package",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2,
    Color = ColorSequence.new( -- gradient
        Color3.fromHex("FF0F7B"), 
        Color3.fromHex("F89B29")
    ),
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
})

--------------------------------------------------
--// SERVICES
--------------------------------------------------
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remote = ReplicatedStorage
    :WaitForChild("Paper")
    :WaitForChild("Remotes")
    :WaitForChild("__remotefunction")

--------------------------------------------------
--// TAB
--------------------------------------------------
local MainTab = Window:Tab({Title = "Main", Icon = "home" })

--------------------------------------------------
--// STATES
--------------------------------------------------
local AutoBuy = false
local AutoClaimTime = false
local AutoRoll = false
local AutoChest = false
local AutoEventUpgrade = false
local SelectedUpgrades = {}
local AutoCraft = false
local SelectedDice = {}

--------------------------------------------------
--// FUNCTIONS
--------------------------------------------------
local function Buy(slot)
    pcall(function()
        Remote:InvokeServer("Buy Event Merchant", slot)
    end)
end

local function ClaimTimeReward()
    pcall(function()
        Remote:InvokeServer("Claim Time Reward")
    end)
end

local function Roll()
    pcall(function()
        Remote:InvokeServer("Roll")
    end)
end

local function ClaimDiceChest()
    pcall(function()
        Remote:InvokeServer("Claim Chest", "DiceChest")
    end)
end

local function EventUpgrade(name)
    pcall(function()
        Remote:InvokeServer("Event Upgrade", name)
    end)
end

local function CraftDice(diceName)
    pcall(function()
        Remote:InvokeServer("Craft Dice", diceName)
    end)
end



--------------------------------------------------
--// TOGGLE AUTO BUY
--------------------------------------------------
MainTab:Toggle({
    Title = "Auto Buy Event Merchant",
    Desc = "Auto beli Slot 1 - 3",
    Default = false,
    Callback = function(state)
        AutoBuy = state
        if state then
            task.spawn(function()
                while AutoBuy do
                    Buy("Slot1")
                    task.wait(0.3)
                    Buy("Slot2")
                    task.wait(0.3)
                    Buy("Slot3")
                    task.wait(1)
                end
            end)
        end
    end
})

--------------------------------------------------
--// TOGGLE AUTO CLAIM TIME REWARD
--------------------------------------------------
MainTab:Toggle({
    Title = "Auto Claim Time Reward",
    Desc = "Auto claim reward waktu tersedia",
    Default = false,
    Callback = function(state)
        AutoClaimTime = state
        if state then
            task.spawn(function()
                while AutoClaimTime do
                    ClaimTimeReward()
                    task.wait(30)
                end
            end)
        end
    end
})

--------------------------------------------------
--// TOGGLE AUTO ROLL
--------------------------------------------------
MainTab:Toggle({
    Title = "Auto Roll",
    Desc = "Auto roll terus",
    Default = false,
    Callback = function(state)
        AutoRoll = state
        if state then
            task.spawn(function()
                while AutoRoll do
                    Roll()
                    task.wait(0.25)
                end
            end)
        end
    end
})

--------------------------------------------------
--// TOGGLE AUTO CLAIM DICE CHEST
--------------------------------------------------
MainTab:Toggle({
    Title = "Auto Claim Dice Chest",
    Desc = "Auto claim Dice Chest",
    Default = false,
    Callback = function(state)
        AutoChest = state
        if state then
            task.spawn(function()
                while AutoChest do
                    ClaimDiceChest()
                    task.wait(10)
                end
            end)
        end
    end
})

--------------------------------------------------
--// DROPDOWN AND TOGGLE AUTO UPGRADE
--------------------------------------------------
MainTab:Dropdown({
    Title = "Event Upgrades",
    Desc = "Pilih upgrade event",
    Values = {
        "Auto Rolls",
        "More Clovers",
        "Lucky Rolls",
        "Speedy Rolls",
        "Lucky Secret Rolls",
        "Faster Event Merchant",
        "Better Event Stocks",
    },
    Value = { "Auto Rolls" }, -- default selected
    Multi = true,
    AllowNone = true,
    Callback = function(option)
        SelectedUpgrades = option
    end
})


MainTab:Toggle({
    Title = "Auto Event Upgrade",
    Desc = "Auto upgrade sesuai pilihan",
    Default = false,
    Callback = function(state)
        AutoEventUpgrade = state
        if state then
            task.spawn(function()
                while AutoEventUpgrade do
                    for _, upgrade in ipairs(SelectedUpgrades) do
                        EventUpgrade(upgrade)
                        task.wait(0.15) -- delay aman
                    end
                    task.wait(0.3)
                end
            end)
        end
    end
})

--------------------------------------------------
--// DROPDOWN AND TOGGLE AUTO CRAFT
--------------------------------------------------
MainTab:Dropdown({
    Title = "Craft Dice Selection",
    Desc = "Pilih dice yang mau di-craft",
    Values = {
        "Speed Dice",
        "Matrix Dice",
        "Golden Dice",
        "Rainbow Dice",
        "Magic Dice",
        "Ice Dice",
        "Ruby Dice",
        "Fire Dice",
        "Galaxy Dice",
    },
    Value = {},
    Multi = true,
    AllowNone = true,
    Callback = function(option)
        SelectedDice = option
    end
})

MainTab:Toggle({
    Title = "Auto Craft Dice",
    Desc = "Auto craft dice terpilih",
    Default = false,
    Callback = function(state)
        AutoCraft = state
        if state then
            task.spawn(function()
                while AutoCraft do
                    for _, dice in ipairs(SelectedDice) do
                        if not AutoCraft then break end
                        CraftDice(dice)
                        task.wait(0.15)
                    end
                    task.wait(0.3)
                end
            end)
        end
    end
})

    HideSearchBar = true,
    ScrollBarEnabled = false,

    -- ↓ Optional. You can remove it.
    --[[ You can set 'rbxassetid://' or video to Background.
        'rbxassetid://':
            Background = "rbxassetid://", -- rbxassetid
        Video:
            Background = "video:YOUR-RAW-LINK-TO-VIDEO.webm", -- video 
    --]]

    -- ↓ Optional. You can remove it.
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            print("clicked")
        end,
    },
})

Window:EditOpenButton({
    Title = "Pickaxe Sim",
    Icon = "package",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2,
    Color = ColorSequence.new( -- gradient
        Color3.fromHex("FF0F7B"), 
        Color3.fromHex("F89B29")
    ),
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
})

--------------------------------------------------
--// SERVICES
--------------------------------------------------
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remote = ReplicatedStorage
    :WaitForChild("Paper")
    :WaitForChild("Remotes")
    :WaitForChild("__remotefunction")

--------------------------------------------------
--// TAB
--------------------------------------------------
local MainTab = Window:Tab({
    Title = "Main",
    Icon = "home"
})

--------------------------------------------------
--// STATES
--------------------------------------------------
local AutoBuy = false
local AutoClaimTime = false
local AutoRoll = false
local AutoChest = false

--------------------------------------------------
--// FUNCTIONS
--------------------------------------------------
local function Buy(slot)
    pcall(function()
        Remote:InvokeServer("Buy Event Merchant", slot)
    end)
end

local function ClaimTimeReward()
    pcall(function()
        Remote:InvokeServer("Claim Time Reward")
    end)
end

local function Roll()
    pcall(function()
        Remote:InvokeServer("Roll")
    end)
end

local function ClaimDiceChest()
    pcall(function()
        Remote:InvokeServer("Claim Chest", "DiceChest")
    end)
end

--------------------------------------------------
--// TOGGLE AUTO BUY
--------------------------------------------------
MainTab:Toggle({
    Title = "Auto Buy Event Merchant",
    Desc = "Auto beli Slot 1 - 3",
    Default = false,
    Callback = function(state)
        AutoBuy = state
        if state then
            task.spawn(function()
                while AutoBuy do
                    Buy("Slot1")
                    task.wait(0.3)
                    Buy("Slot2")
                    task.wait(0.3)
                    Buy("Slot3")
                    task.wait(1)
                end
            end)
        end
    end
})

--------------------------------------------------
--// TOGGLE AUTO CLAIM TIME REWARD
--------------------------------------------------
MainTab:Toggle({
    Title = "Auto Claim Time Reward",
    Desc = "Auto claim reward waktu tersedia",
    Default = false,
    Callback = function(state)
        AutoClaimTime = state
        if state then
            task.spawn(function()
                while AutoClaimTime do
                    ClaimTimeReward()
                    task.wait(30)
                end
            end)
        end
    end
})

--------------------------------------------------
--// TOGGLE AUTO ROLL
--------------------------------------------------
MainTab:Toggle({
    Title = "Auto Roll",
    Desc = "Auto roll terus",
    Default = false,
    Callback = function(state)
        AutoRoll = state
        if state then
            task.spawn(function()
                while AutoRoll do
                    Roll()
                    task.wait(0.25)
                end
            end)
        end
    end
})

--------------------------------------------------
--// TOGGLE AUTO CLAIM DICE CHEST
--------------------------------------------------
MainTab:Toggle({
    Title = "Auto Claim Dice Chest",
    Desc = "Auto claim Dice Chest",
    Default = false,
    Callback = function(state)
        AutoChest = state
        if state then
            task.spawn(function()
                while AutoChest do
                    ClaimDiceChest()
                    task.wait(10)
                end
            end)
        end
    end
})
