--== LOAD ORION LIB ==
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

--== SERVICES ==
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

--== REMOTES ==
local DropRemote = ReplicatedStorage:WaitForChild("WalletRemotes"):WaitForChild("DropCash")
local ToolShopEvent = ReplicatedStorage:WaitForChild("ToolShopEvent")

--== WINDOW SETUP ==
local Window = OrionLib:MakeWindow({
    Name = "Near.cc",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "NearccSettings"
})

--== MAIN TAB ==
local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Auto Claim Ikan Toggle
local autoClaim = false
MainTab:AddToggle({
    Name = "Auto Claim Ikan",
    Default = false,
    Callback = function(Value)
        autoClaim = Value
        if autoClaim then
            OrionLib:MakeNotification({
                Name = "Auto Claim Aktif",
                Content = "Memulai auto claim ikan...",
                Time = 4
            })
            coroutine.wrap(function()
                while autoClaim do
                    task.wait(0.5)
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("Basic Rod") and char["Basic Rod"]:FindFirstChild("MiniGame") then
                        char["Basic Rod"].MiniGame:FireServer("Complete")
                    end
                end
            end)()
        end
    end
})

-- Auto Drop Uang
local jumlahDrop = 0
MainTab:AddTextbox({
    Name = "Jumlah Uang Drop",
    Default = "100",
    TextDisappear = false,
    Callback = function(Value)
        jumlahDrop = tonumber(Value) or 0
    end
})

local dropRunning = false
MainTab:AddToggle({
    Name = "Auto Drop",
    Default = false,
    Callback = function(Value)
        dropRunning = Value
        if dropRunning then
            coroutine.wrap(function()
                while dropRunning do
                    if jumlahDrop > 0 then
                        DropRemote:FireServer(jumlahDrop)
                    end
                    task.wait(0.5)
                end
            end)()
        end
    end
})

-- Rejoin Button
MainTab:AddButton({
    Name = "Rejoin Server",
    Callback = function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end
})

--== MONEY TAB ==
local MoneyTab = Window:MakeTab({
    Name = "Money",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Exploit Uang
local jumlahExploit = 0
MoneyTab:AddTextbox({
    Name = "Jumlah Uang (Exploit)",
    Default = "1000000",
    TextDisappear = false,
    Callback = function(Value)
        jumlahExploit = tonumber(Value) or 0
    end
})

MoneyTab:AddButton({
    Name = "Exploit Uang",
    Callback = function()
        if jumlahExploit ~= 0 then
            ToolShopEvent:FireServer("Purchase", "Wallet", -math.abs(jumlahExploit))
        end
    end
})
