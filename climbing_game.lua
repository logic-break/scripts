local startpos_win = CFrame.new(-4202, 171, -1933)
local endpos_win = CFrame.new(-5332, 1248, -2553)

-- Инициализация персонажа
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")

-- Переменная для контроля состояния фарма (останавливаем цикл, если тогл выключен)
local FarmingActive = false

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    -- ... (остальные настройки окна Rayfield) ...
    Name = "Farm Hub",
    Icon = 0,
    LoadingTitle = "Climbing game ",
    LoadingSubtitle = "by logic-break",
    ShowText = "Rayfield",
    Theme = "Default",
    ToggleUIKeybind = "K",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = {
       Enabled = true,
       FolderName = nil,
       FileName = "Shit Hub"
    },
    Discord = {
       Enabled = false,
       Invite = "noinvitelink",
       RememberJoins = true
    },
    KeySystem = false,
    KeySettings = {
       Title = "Untitled",
       Subtitle = "Key System",
       Note = "No method of obtaining the key is provided",
       FileName = "Key",
       SaveKey = true,
       GrabKeyFromSite = false,
       Key = {"Hello"}
    }
})

local Tab = Window:CreateTab("Main", 4483362458)

local Toggle = Tab:CreateToggle({
    Name = "Farm Winter Apricity",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
        -- Переменная Value — это состояние тогла (true/false)

        FarmingActive = Value -- Обновляем наш локальный контроллер

        if FarmingActive then
            -- Если тогл включен, запускаем цикл в отдельном потоке (coroutine)
            spawn(function()
                while FarmingActive do
                    -- Телепортация в первую точку
                    HRP.CFrame = startpos_win
                    wait(0.1) -- Задержка
                    
                    -- Проверка, не был ли тогл выключен во время wait
                    if not FarmingActive then break end

                    -- Телепортация во вторую точку
                    HRP.CFrame = endpos_win
                    wait(0.1) -- Задержка

                    -- Проверка, не был ли тогл выключен во время wait
                    if not FarmingActive then break end
                end
            end)
        end
        
        -- Если тогл выключен (FarmingActive = false), цикл просто завершится
        -- после следующего оператора wait(0.1)
    end,
})
