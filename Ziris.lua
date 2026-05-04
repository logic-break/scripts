local CoreGui = game:GetService('CoreGui')
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local ProtectGui = protectgui or (syn and syn.protect_gui) or function(gui) end

local Ziris = {}
Ziris.__index = Ziris

-- Utility: Rounded Corners
local function AddCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 6)
    corner.Parent = parent
    return corner
end

-- Utility: Smooth Animations
local function PlayTween(obj, info, goal)
    local tween = TweenService:Create(obj, info, goal)
    tween:Play()
    return tween
end

-- Global Notification System
local NotifyGui = Instance.new("ScreenGui")
ProtectGui(NotifyGui)
NotifyGui.Name = "ZirisNotifications"
NotifyGui.Parent = CoreGui

local NotifyHolder = Instance.new("Frame")
NotifyHolder.Size = UDim2.new(0, 250, 1, 0)
NotifyHolder.Position = UDim2.new(1, -260, 0, 10)
NotifyHolder.BackgroundTransparency = 1
NotifyHolder.Parent = NotifyGui

local NotifyList = Instance.new("UIListLayout")
NotifyList.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifyList.Padding = UDim.new(0, 10)
NotifyList.Parent = NotifyHolder

function Ziris:Notify(title, text, duration)
    local duration = duration or 5
    local Notification = Instance.new("Frame")
    Notification.Size = UDim2.new(1, 0, 0, 0) -- Starts invisible
    Notification.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Notification.ClipsDescendants = true
    Notification.Parent = NotifyHolder
    AddCorner(Notification)
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -10, 0, 20)
    TitleLabel.Position = UDim2.new(0, 10, 0, 5)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.TextColor3 = Color3.fromRGB(65, 105, 225)
    TitleLabel.TextSize = 14
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = title
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Notification

    local DescLabel = Instance.new("TextLabel")
    DescLabel.Size = UDim2.new(1, -20, 1, -25)
    DescLabel.Position = UDim2.new(0, 10, 0, 25)
    DescLabel.BackgroundTransparency = 1
    DescLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    DescLabel.TextSize = 13
    DescLabel.Font = Enum.Font.Gotham
    DescLabel.Text = text
    DescLabel.TextWrapped = true
    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescLabel.TextYAlignment = Enum.TextYAlignment.Top
    DescLabel.Parent = Notification

    -- Animate in
    PlayTween(Notification, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Size = UDim2.new(1, 0, 0, 70)})
    
    task.delay(duration, function()
        PlayTween(Notification, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Size = UDim2.new(1, 0, 0, 0)})
        task.wait(0.4)
        Notification:Destroy()
    end)
end

function Ziris:CreateWindow(options)
    local Window = { Tabs = {}, CurrentTab = nil }
    local TitleText = options.Title or "Ziris Menu"
    
    local ScreenGui = Instance.new('ScreenGui')
    ProtectGui(ScreenGui)
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    ScreenGui.Parent = CoreGui
    ScreenGui.Name = "ZirisUI"

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 450, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -225, 0.5, -175)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    AddCorner(MainFrame)
    
    -- Fade In Animation
    MainFrame.BackgroundTransparency = 1
    PlayTween(MainFrame, TweenInfo.new(0.5), {BackgroundTransparency = 0})

    local Topbar = Instance.new("Frame")
    Topbar.Size = UDim2.new(1, 0, 0, 35)
    Topbar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Topbar.Parent = MainFrame
    AddCorner(Topbar)
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -60, 1, 0)
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 16
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = TitleText
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Topbar

    -- Close Button (X)
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 35, 0, 35)
    CloseBtn.Position = UDim2.new(1, -35, 0, 0)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
    CloseBtn.TextSize = 18
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Parent = Topbar
    
    CloseBtn.MouseButton1Click:Connect(function()
        PlayTween(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 450, 0, 0)})
        task.wait(0.3)
        ScreenGui:Destroy()
    end)

    -- Dragging
    local dragging, dragInput, dragStart, startPos
    Topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local TabSelector = Instance.new("ScrollingFrame")
    TabSelector.Size = UDim2.new(0, 120, 1, -45)
    TabSelector.Position = UDim2.new(0, 10, 0, 40)
    TabSelector.BackgroundTransparency = 1
    TabSelector.ScrollBarThickness = 0
    TabSelector.Parent = MainFrame
    
    local TabSelectorLayout = Instance.new("UIListLayout")
    TabSelectorLayout.Padding = UDim.new(0, 5)
    TabSelectorLayout.Parent = TabSelector

    local ContentContainer = Instance.new("Frame")
    ContentContainer.Size = UDim2.new(1, -140, 1, -45)
    ContentContainer.Position = UDim2.new(0, 135, 0, 40)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = MainFrame

    function Window:CreateTab(tabName)
        local Tab = { ElementCount = 0 }
        
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 30)
        TabBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabBtn.Font = Enum.Font.Gotham
        TabBtn.TextSize = 14
        TabBtn.Text = tabName
        TabBtn.Parent = TabSelector
        AddCorner(TabBtn)

        local Container = Instance.new("ScrollingFrame")
        Container.Size = UDim2.new(1, 0, 1, 0)
        Container.BackgroundTransparency = 1
        Container.ScrollBarThickness = 4
        Container.Visible = false
        Container.Parent = ContentContainer

        local UIListLayout = Instance.new("UIListLayout")
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.Padding = UDim.new(0, 8)
        UIListLayout.Parent = Container

        local function SetOrder(element)
            Tab.ElementCount = Tab.ElementCount + 1
            element.LayoutOrder = Tab.ElementCount
        end

        UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Container.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
        end)

        TabBtn.MouseButton1Click:Connect(function()
            for _, t in pairs(Window.Tabs) do
                t.Container.Visible = false
                PlayTween(t.Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)})
            end
            Container.Visible = true
            PlayTween(TabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(65, 105, 225)})
        end)

        Tab.Container = Container
        Tab.Button = TabBtn
        table.insert(Window.Tabs, Tab)

        if #Window.Tabs == 1 then
            Container.Visible = true
            TabBtn.BackgroundColor3 = Color3.fromRGB(65, 105, 225)
        end

        -- Element: Button
        function Tab:AddButton(text, callback)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, -10, 0, 35)
            Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Btn.Font = Enum.Font.Gotham
            Btn.TextSize = 14
            Btn.Text = text
            Btn.Parent = self.Container
            AddCorner(Btn)
            SetOrder(Btn)
            
            Btn.MouseButton1Click:Connect(function()
                PlayTween(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(80, 80, 80)})
                task.wait(0.1)
                PlayTween(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)})
                if callback then callback() end
            end)
        end

        -- Element: Toggle (Visual Switch)
        function Tab:AddToggleButton(text, default, callback)
            local state = default or false
            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, -10, 0, 35)
            Frame.BackgroundTransparency = 1
            Frame.Parent = self.Container
            SetOrder(Frame)

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -50, 1, 0)
            Label.BackgroundTransparency = 1
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Text = text
            Label.Parent = Frame

            local SwitchBG = Instance.new("TextButton")
            SwitchBG.Size = UDim2.new(0, 40, 0, 20)
            SwitchBG.Position = UDim2.new(1, -45, 0.5, -10)
            SwitchBG.BackgroundColor3 = state and Color3.fromRGB(65, 105, 225) or Color3.fromRGB(60, 60, 60)
            SwitchBG.Text = ""
            SwitchBG.Parent = Frame
            AddCorner(SwitchBG, 10)

            local Circle = Instance.new("Frame")
            Circle.Size = UDim2.new(0, 16, 0, 16)
            Circle.Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Circle.Parent = SwitchBG
            AddCorner(Circle, 8)

            SwitchBG.MouseButton1Click:Connect(function()
                state = not state
                local goalPos = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                local goalColor = state and Color3.fromRGB(65, 105, 225) or Color3.fromRGB(60, 60, 60)
                
                PlayTween(Circle, TweenInfo.new(0.2), {Position = goalPos})
                PlayTween(SwitchBG, TweenInfo.new(0.2), {BackgroundColor3 = goalColor})
                if callback then callback(state) end
            end)
        end

        -- Element: Slider
        function Tab:AddSlider(text, min, max, default, callback)
            local value = default or min
            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, -10, 0, 50)
            Frame.BackgroundTransparency = 1
            Frame.Parent = self.Container
            SetOrder(Frame)

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -50, 0, 20)
            Label.BackgroundTransparency = 1
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Text = text
            Label.Parent = Frame

            local Track = Instance.new("TextButton")
            Track.Size = UDim2.new(1, 0, 0, 8)
            Track.Position = UDim2.new(0, 0, 0, 30)
            Track.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            Track.Text = ""
            Track.Parent = Frame
            AddCorner(Track, 4)

            local Fill = Instance.new("Frame")
            Fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
            Fill.BackgroundColor3 = Color3.fromRGB(65, 105, 225)
            Fill.Parent = Track
            AddCorner(Fill, 4)

            local function Update(input)
                local percent = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                value = math.floor(min + (max - min) * percent)
                PlayTween(Fill, TweenInfo.new(0.1), {Size = UDim2.new(percent, 0, 1, 0)})
                if callback then callback(value) end
            end

            local sliding = false
            Track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = true Update(input) end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then Update(input) end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end
            end)
        end

        -- Element: Label
        function Tab:AddLabel(text)
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -10, 0, 25)
            Label.BackgroundTransparency = 1
            Label.TextColor3 = Color3.fromRGB(180, 180, 180)
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 13
            Label.Text = text
            Label.Parent = self.Container
            SetOrder(Label)
        end

        return Tab
    end

    return Window
end

return Ziris
