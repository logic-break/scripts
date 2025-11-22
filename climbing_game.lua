local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Точки для телепортации (ваши координаты)
local startpos_win = CFrame.new(-4202, 171, -1933)
local endpos_win = CFrame.new(-5332, 1248, -2553)

-- Ключевые переменные
local FarmingKey = Enum.KeyCode.F -- Клавиша-тогл
local IsFarming = false -- Флаг состояния (true = фарм включен, false = фарм выключен)
local Connection = nil -- Переменная для хранения соединения RunService

-- Инициализация персонажа
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")

-- === ФУНКЦИЯ ЗАПУСКА ИЛИ ОСТАНОВКИ ФАРМА ===
local function ToggleFarming()
    -- Инвертируем состояние: если true, станет false, и наоборот.
    IsFarming = not IsFarming

    if IsFarming then
        -- === ЗАПУСК ФАРМА ===
        print("Фарм активирован (Клавиша F: ВКЛ)")

        -- Используем RunService.Heartbeat для быстрого и стабильного цикла
        Connection = RunService.Heartbeat:Connect(function()
            -- Если состояние изменилось на false во время цикла, выходим
            if not IsFarming then
                Connection:Disconnect()
                Connection = nil
                return
            end

            -- Шаг 1: Телепорт в первую точку
            HRP.CFrame = startpos_win
            wait(0.1) -- Задержка 
            
            if not IsFarming then return end

            -- Шаг 2: Телепорт во вторую точку
            HRP.CFrame = endpos_win
            wait(0.1) -- Задержка
        end)
    else
        -- === ОСТАНОВКА ФАРМА ===
        print("Фарм остановлен (Клавиша F: ВЫКЛ)")

        -- Отключаем соединение RunService, чтобы остановить цикл
        if Connection then
            Connection:Disconnect()
            Connection = nil
        end
    end
end

-- === ОБРАБОТКА ВВОДА ПОЛЬЗОВАТЕЛЯ (Только InputBegan) ===
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    -- Проверяем, что это наша клавиша F и что ввод не обработан самой игрой
    if input.KeyCode == FarmingKey and not gameProcessedEvent then
        ToggleFarming()
    end
end)
print("Script activated!!! press F to enable/disable farm")
