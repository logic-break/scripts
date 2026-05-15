local Ziris = loadstring(game:HttpGet('https://raw.githubusercontent.com/logic-break/scripts/refs/heads/main/Ziris.lua'))()

-- Создаем главное окно
local Window = Ziris:CreateWindow({
    Title = "Ziris"
})

local MainTab = Window:CreateTab("Main")

MainTab:AddLabel("--- Basic Controls ---")

MainTab:AddButton("Click Me!", function()
    Ziris:Notify("Success", "Button was clicked!", 3)
end)

MainTab:AddToggleButton("Aimbot", false, function(state)
    print("Aimbot is now:", state)
end)

MainTab:AddCheckbox("Show ESP", true, function(state)
    print("ESP state:", state)
end)

MainTab:AddTextInput("Target Player", "Enter name here...", function(text)
    print("User typed:", text)
end)

local SettingsTab = Window:CreateTab("Settings")

SettingsTab:AddSlider("WalkSpeed", 16, 100, 16, function(value)
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
end)

SettingsTab:AddDropdown("Teleport To", {"Spawn", "Shop", "Arena", "VIP Area"}, function(selected)
    print("Teleporting to:", selected)
    Ziris:Notify("Teleport", "Going to " .. selected, 3)
end)

SettingsTab:AddRadioButton("Hitbox Target", {"Head", "Torso", "Random"}, function(selected)
    print("Hitbox changed to:", selected)
end)

local myProgress = SettingsTab:AddProgressBar("Loading Level", 0)

SettingsTab:AddButton("Test Progress Bar", function()
    task.spawn(function()
        for i = 0, 100, 10 do
            myProgress:Update(i)
            task.wait(0.1)
        end
        Ziris:Notify("Done", "Progress reached 100%!", 3)
        task.wait(1)
        myProgress:Update(0)
    end)
end)

local MiscTab = Window:CreateTab("Misc")

MiscTab:AddButton("Destroy GUI", function()
    Window:Destroy()
end)
