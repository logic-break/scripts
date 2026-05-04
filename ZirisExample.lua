local Ziris = loadstring(game:HttpGet('https://raw.githubusercontent.com/logic-break/scripts/refs/heads/main/Ziris.lua'))()

local Window = Ziris:CreateWindow({
    Title = "Ziris Example"
})

Ziris:Notify("System", "Script loaded!", 5)

local MainTab = Window:CreateTab("Main")

MainTab:AddLabel("fight settigns")

MainTab:AddButton("Kill all", function()
    Ziris:Notify("Action", "Command sent!", 2)
end)

MainTab:AddToggleButton("Aimbot", false, function(state)
    if state then
        Ziris:Notify("Aimbot", "Disabled", 2)
    else
        Ziris:Notify("Aimbot", "Enabled", 2)
    end
end)

local PlayerTab = Window:CreateTab("Player")

PlayerTab:AddLabel("player physics")

PlayerTab:AddSlider("Walkspeed", 16, 250, 16, function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)

PlayerTab:AddSlider("Jumppower", 50, 300, 50, function(value)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
end)

local MiscTab = Window:CreateTab("Misc")

MiscTab:AddButton("Delete GUI", function()
    game:GetService("CoreGui").ZirisUI:Destroy()
end)
