--== SERVICE SETUP ==--
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local DropRemote = ReplicatedStorage:WaitForChild("WalletRemotes"):WaitForChild("DropCash")
local ToolShopEvent = ReplicatedStorage:WaitForChild("ToolShopEvent")

--== ORION GUI SETUP ==--
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

local Window = OrionLib:MakeWindow({
    Name = "Near.cc",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "NearConfig"
})

--== MAIN TAB ==--
local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local autoClaim = false
MainTab:AddToggle({
    Name = "Auto Claim Ikan",
    Default = false,
    Callback = function(state)
        autoClaim = state
        if autoClaim then
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

MainTab:AddButton({
    Name = "Rejoin",
    Callback = function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end
})

--== MONEY TAB ==--
local MoneyTab = Window:MakeTab({
    Name = "Money",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local jumlahUang = "0"

MoneyTab:AddTextbox({
    Name = "Jumlah Uang",
    Default = "100000",
    TextDisappear = false,
    Callback = function(value)
        jumlahUang = value
    end
})

MoneyTab:AddButton({
    Name = "Exploit Uang",
    Callback = function()
        local jumlah = tonumber(jumlahUang)
        if jumlah then
            ToolShopEvent:FireServer("Purchase", "Wallet", -math.abs(jumlah))
        end
    end
})

--== NOTIFIKASI ==--
OrionLib:MakeNotification({
    Name = "Near.cc",
    Content = "GUI berhasil dimuat!",
    Image = "rbxassetid://4483345998",
    Time = 4
})
