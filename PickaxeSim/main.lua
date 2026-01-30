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
