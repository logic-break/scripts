local CoreGui = game:GetService('CoreGui')
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local ProtectGui = protectgui or (syn and syn.protect_gui) or function(gui) end

local Ziris = {}
Ziris.__index = Ziris

-- Utility: Rounded Corners
local function AddCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 12)
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
    Notification.Size = UDim2.new(1, 0, 0, 0)
    Notification.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Notification.ClipsDescendants = true
    Notification.Parent = NotifyHolder
    AddCorner(Notification, 14)
    
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
    
    -- Функция уничтожения окна
    function Window:Destroy()
        ScreenGui:Destroy()
    end

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 500, 0, 380) -- Чуть увеличил окно для новых элементов
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -190)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    AddCorner(MainFrame, 16)
    
    MainFrame.BackgroundTransparency = 1
    PlayTween(MainFrame, TweenInfo.new(0.5), {BackgroundTransparency = 0})

    local Topbar = Instance.new("Frame")
    Topbar.Size = UDim2.new(1, 0, 0, 40)
    Topbar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Topbar.Parent = MainFrame
    AddCorner(Topbar, 16)
    
    -- Прячем нижние углы топбара, чтобы скругление было только сверху
    local TopbarHide = Instance.new("Frame")
    TopbarHide.Size = UDim2.new(1, 0, 0, 10)
    TopbarHide.Position = UDim2.new(0, 0, 1, -10)
    TopbarHide.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TopbarHide.BorderSizePixel = 0
    TopbarHide.Parent = Topbar
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -60, 1, 0)
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 16
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = TitleText
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Topbar

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 40, 0, 40)
    CloseBtn.Position = UDim2.new(1, -40, 0, 0)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
    CloseBtn.TextSize = 18
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Parent = Topbar
    
    CloseBtn.MouseButton1Click:Connect(function()
        PlayTween(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 500, 0, 0)})
        task.wait(0.3)
        Window:Destroy()
    end)

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
    TabSelector.Size = UDim2.new(0, 130, 1, -55)
    TabSelector.Position = UDim2.new(0, 10, 0, 50)
    TabSelector.BackgroundTransparency = 1
    TabSelector.ScrollBarThickness = 0
    TabSelector.Parent = MainFrame
    
    local TabSelectorLayout = Instance.new("UIListLayout")
    TabSelectorLayout.Padding = UDim.new(0, 8)
    TabSelectorLayout.Parent = TabSelector

    local ContentContainer = Instance.new("Frame")
    ContentContainer.Size = UDim2.new(1, -160, 1, -55)
    ContentContainer.Position = UDim2.new(0, 150, 0, 50)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = MainFrame

    function Window:CreateTab(tabName)
        local Tab = { ElementCount = 0 }
        
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 35)
        TabBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabBtn.Font = Enum.Font.GothamBold
        TabBtn.TextSize = 14
        TabBtn.Text = tabName
        TabBtn.Parent = TabSelector
        AddCorner(TabBtn, 10)

        local Container = Instance.new("ScrollingFrame")
        Container.Size = UDim2.new(1, 0, 1, 0)
        Container.BackgroundTransparency = 1
        Container.ScrollBarThickness = 2
        Container.Visible = false
        Container.Parent = ContentContainer

        local UIListLayout = Instance.new("UIListLayout")
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.Padding = UDim.new(0, 10)
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
                PlayTween(t.Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 45), TextColor3 = Color3.fromRGB(200, 200, 200)})
            end
            Container.Visible = true
            PlayTween(TabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(65, 105, 225), TextColor3 = Color3.fromRGB(255, 255, 255)})
        end)

        Tab.Container = Container
        Tab.Button = TabBtn
        table.insert(Window.Tabs, Tab)

        if #Window.Tabs == 1 then
            Container.Visible = true
            TabBtn.BackgroundColor3 = Color3.fromRGB(65, 105, 225)
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end

        -- Element: Button
        function Tab:AddButton(text, callback)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, -10, 0, 40)
            Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Btn.Font = Enum.Font.Gotham
            Btn.TextSize = 14
            Btn.Text = text
            Btn.Parent = self.Container
            AddCorner(Btn, 10)
            SetOrder(Btn)
            
            Btn.MouseButton1Click:Connect(function()
                PlayTween(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(80, 80, 80)})
                task.wait(0.1)
                PlayTween(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)})
                if callback then callback() end
            end)
        end

        -- Element: Toggle
        function Tab:AddToggleButton(text, default, callback)
            local state = default or false
            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, -10, 0, 40)
            Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            Frame.Parent = self.Container
            AddCorner(Frame, 10)
            SetOrder(Frame)

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -60, 1, 0)
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.BackgroundTransparency = 1
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Text = text
            Label.Parent = Frame

            local SwitchBG = Instance.new("TextButton")
            SwitchBG.Size = UDim2.new(0, 44, 0, 22)
            SwitchBG.Position = UDim2.new(1, -54, 0.5, -11)
            SwitchBG.BackgroundColor3 = state and Color3.fromRGB(65, 105, 225) or Color3.fromRGB(60, 60, 60)
            SwitchBG.Text = ""
            SwitchBG.Parent = Frame
            AddCorner(SwitchBG, 12)

            local Circle = Instance.new("Frame")
            Circle.Size = UDim2.new(0, 18, 0, 18)
            Circle.Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
            Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Circle.Parent = SwitchBG
            AddCorner(Circle, 10)

            SwitchBG.MouseButton1Click:Connect(function()
                state = not state
                local goalPos = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
                local goalColor = state and Color3.fromRGB(65, 105, 225) or Color3.fromRGB(60, 60, 60)
                PlayTween(Circle, TweenInfo.new(0.2), {Position = goalPos})
                PlayTween(SwitchBG, TweenInfo.new(0.2), {BackgroundColor3 = goalColor})
                if callback then callback(state) end
            end)
        end

        -- Element: Checkbox (Альтернатива Toggle, квадратный стиль)
        function Tab:AddCheckbox(text, default, callback)
            local state = default or false
            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, -10, 0, 40)
            Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            Frame.Parent = self.Container
            AddCorner(Frame, 10)
            SetOrder(Frame)

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -50, 1, 0)
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.BackgroundTransparency = 1
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Text = text
            Label.Parent = Frame

            local CheckBox = Instance.new("TextButton")
            CheckBox.Size = UDim2.new(0, 24, 0, 24)
            CheckBox.Position = UDim2.new(1, -34, 0.5, -12)
            CheckBox.BackgroundColor3 = state and Color3.fromRGB(65, 105, 225) or Color3.fromRGB(60, 60, 60)
            CheckBox.Text = state and "✓" or ""
            CheckBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            CheckBox.Font = Enum.Font.GothamBold
            CheckBox.TextSize = 16
            CheckBox.Parent = Frame
            AddCorner(CheckBox, 6)

            CheckBox.MouseButton1Click:Connect(function()
                state = not state
                local goalColor = state and Color3.fromRGB(65, 105, 225) or Color3.fromRGB(60, 60, 60)
                PlayTween(CheckBox, TweenInfo.new(0.2), {BackgroundColor3 = goalColor})
                CheckBox.Text = state and "✓" or ""
                if callback then callback(state) end
            end)
        end

        -- Element: Slider
        function Tab:AddSlider(text, min, max, default, callback)
            local value = default or min
            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, -10, 0, 55)
            Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            Frame.Parent = self.Container
            AddCorner(Frame, 10)
            SetOrder(Frame)

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -50, 0, 25)
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.BackgroundTransparency = 1
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Text = text
            Label.Parent = Frame
            
            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Size = UDim2.new(0, 40, 0, 25)
            ValueLabel.Position = UDim2.new(1, -50, 0, 0)
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.TextColor3 = Color3.fromRGB(65, 105, 225)
            ValueLabel.Font = Enum.Font.GothamBold
            ValueLabel.TextSize = 14
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.Text = tostring(value)
            ValueLabel.Parent = Frame

            local Track = Instance.new("TextButton")
            Track.Size = UDim2.new(1, -20, 0, 10)
            Track.Position = UDim2.new(0, 10, 0, 32)
            Track.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            Track.Text = ""
            Track.Parent = Frame
            AddCorner(Track, 5)

            local Fill = Instance.new("Frame")
            Fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
            Fill.BackgroundColor3 = Color3.fromRGB(65, 105, 225)
            Fill.Parent = Track
            AddCorner(Fill, 5)

            local function Update(input)
                local percent = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                value = math.floor(min + (max - min) * percent)
                ValueLabel.Text = tostring(value)
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
            Label.Size = UDim2.new(1, -10, 0, 30)
            Label.BackgroundTransparency = 1
            Label.TextColor3 = Color3.fromRGB(180, 180, 180)
            Label.Font = Enum.Font.GothamBold
            Label.TextSize = 13
            Label.Text = text
            Label.Parent = self.Container
            SetOrder(Label)
        end
        
        -- Element: TextInput
        function Tab:AddTextInput(text, placeholder, callback)
            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, -10, 0, 45)
            Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            Frame.Parent = self.Container
            AddCorner(Frame, 10)
            SetOrder(Frame)

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(0, 120, 1, 0)
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.BackgroundTransparency = 1
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Text = text
            Label.Parent = Frame

            local TextBox = Instance.new("TextBox")
            TextBox.Size = UDim2.new(1, -140, 0, 30)
            TextBox.Position = UDim2.new(0, 130, 0.5, -15)
            TextBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextBox.PlaceholderText = placeholder or ""
            TextBox.Font = Enum.Font.Gotham
            TextBox.TextSize = 13
            TextBox.Text = ""
            TextBox.ClearTextOnFocus = false
            TextBox.Parent = Frame
            AddCorner(TextBox, 8)

            TextBox.FocusLost:Connect(function()
                if callback then callback(TextBox.Text) end
            end)
        end

        -- Element: Progress Bar
        function Tab:AddProgressBar(text, defaultPercent)
            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, -10, 0, 50)
            Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            Frame.Parent = self.Container
            AddCorner(Frame, 10)
            SetOrder(Frame)

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -20, 0, 20)
            Label.Position = UDim2.new(0, 10, 0, 5)
            Label.BackgroundTransparency = 1
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Text = text
            Label.Parent = Frame

            local Track = Instance.new("Frame")
            Track.Size = UDim2.new(1, -20, 0, 12)
            Track.Position = UDim2.new(0, 10, 0, 28)
            Track.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            Track.Parent = Frame
            AddCorner(Track, 6)

            local Fill = Instance.new("Frame")
            Fill.Size = UDim2.new((defaultPercent or 0) / 100, 0, 1, 0)
            Fill.BackgroundColor3 = Color3.fromRGB(65, 105, 225)
            Fill.Parent = Track
            AddCorner(Fill, 6)
            
            local ProgressObj = {}
            function ProgressObj:Update(percent)
                local clamped = math.clamp(percent, 0, 100)
                PlayTween(Fill, TweenInfo.new(0.2), {Size = UDim2.new(clamped / 100, 0, 1, 0)})
            end
            
            return ProgressObj
        end
        
        -- Element: Dropdown
        function Tab:AddDropdown(text, list, callback)
            local dropOpen = false
            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, -10, 0, 40)
            Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            Frame.ClipsDescendants = true
            Frame.Parent = self.Container
            AddCorner(Frame, 10)
            SetOrder(Frame)

            local DropBtn = Instance.new("TextButton")
            DropBtn.Size = UDim2.new(1, 0, 0, 40)
            DropBtn.BackgroundTransparency = 1
            DropBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            DropBtn.Font = Enum.Font.Gotham
            DropBtn.TextSize = 14
            DropBtn.Text = "  " .. text .. " : Select"
            DropBtn.TextXAlignment = Enum.TextXAlignment.Left
            DropBtn.Parent = Frame
            
            local Arrow = Instance.new("TextLabel")
            Arrow.Size = UDim2.new(0, 30, 0, 40)
            Arrow.Position = UDim2.new(1, -30, 0, 0)
            Arrow.BackgroundTransparency = 1
            Arrow.TextColor3 = Color3.fromRGB(255, 255, 255)
            Arrow.Font = Enum.Font.GothamBold
            Arrow.TextSize = 14
            Arrow.Text = "+"
            Arrow.Parent = DropBtn

            local OptionsContainer = Instance.new("Frame")
            OptionsContainer.Size = UDim2.new(1, -20, 0, 0)
            OptionsContainer.Position = UDim2.new(0, 10, 0, 40)
            OptionsContainer.BackgroundTransparency = 1
            OptionsContainer.Parent = Frame
            
            local ListLayout = Instance.new("UIListLayout")
            ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ListLayout.Padding = UDim.new(0, 4)
            ListLayout.Parent = OptionsContainer

            local function refreshSize()
                if dropOpen then
                    local h = ListLayout.AbsoluteContentSize.Y + 10
                    PlayTween(Frame, TweenInfo.new(0.2), {Size = UDim2.new(1, -10, 0, 40 + h)})
                else
                    PlayTween(Frame, TweenInfo.new(0.2), {Size = UDim2.new(1, -10, 0, 40)})
                end
            end

            DropBtn.MouseButton1Click:Connect(function()
                dropOpen = not dropOpen
                Arrow.Text = dropOpen and "-" or "+"
                refreshSize()
            end)

            for i, option in pairs(list) do
                local OptBtn = Instance.new("TextButton")
                OptBtn.Size = UDim2.new(1, 0, 0, 30)
                OptBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                OptBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
                OptBtn.Font = Enum.Font.Gotham
                OptBtn.TextSize = 13
                OptBtn.Text = option
                OptBtn.Parent = OptionsContainer
                AddCorner(OptBtn, 6)

                OptBtn.MouseButton1Click:Connect(function()
                    DropBtn.Text = "  " .. text .. " : " .. option
                    dropOpen = false
                    Arrow.Text = "+"
                    refreshSize()
                    if callback then callback(option) end
                end)
            end
        end

        -- Element: Radio Button
        function Tab:AddRadioButton(text, options, callback)
            local Frame = Instance.new("Frame")
            Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            Frame.Parent = self.Container
            AddCorner(Frame, 10)
            SetOrder(Frame)
            
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -20, 0, 30)
            Label.Position = UDim2.new(0, 10, 0, 5)
            Label.BackgroundTransparency = 1
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.Font = Enum.Font.GothamBold
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Text = text
            Label.Parent = Frame
            
            local YOffset = 35
            local buttons = {}
            
            for i, opt in pairs(options) do
                local OptFrame = Instance.new("Frame")
                OptFrame.Size = UDim2.new(1, -20, 0, 26)
                OptFrame.Position = UDim2.new(0, 10, 0, YOffset)
                OptFrame.BackgroundTransparency = 1
                OptFrame.Parent = Frame
                
                local RadioBtn = Instance.new("TextButton")
                RadioBtn.Size = UDim2.new(0, 16, 0, 16)
                RadioBtn.Position = UDim2.new(0, 0, 0.5, -8)
                RadioBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                RadioBtn.Text = ""
                RadioBtn.Parent = OptFrame
                AddCorner(RadioBtn, 16) -- Делаем его круглым
                
                local Inner = Instance.new("Frame")
                Inner.Size = UDim2.new(0, 8, 0, 8)
                Inner.Position = UDim2.new(0.5, -4, 0.5, -4)
                Inner.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Inner.BackgroundTransparency = 1
                Inner.Parent = RadioBtn
                AddCorner(Inner, 8)
                
                local OptLabel = Instance.new("TextLabel")
                OptLabel.Size = UDim2.new(1, -25, 1, 0)
                OptLabel.Position = UDim2.new(0, 25, 0, 0)
                OptLabel.BackgroundTransparency = 1
                OptLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                OptLabel.Font = Enum.Font.Gotham
                OptLabel.TextSize = 13
                OptLabel.TextXAlignment = Enum.TextXAlignment.Left
                OptLabel.Text = opt
                OptLabel.Parent = OptFrame
                
                table.insert(buttons, {Btn = RadioBtn, Inner = Inner, Value = opt})
                
                RadioBtn.MouseButton1Click:Connect(function()
                    for _, b in pairs(buttons) do
                        PlayTween(b.Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)})
                        PlayTween(b.Inner, TweenInfo.new(0.2), {BackgroundTransparency = 1})
                    end
                    PlayTween(RadioBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(65, 105, 225)})
                    PlayTween(Inner, TweenInfo.new(0.2), {BackgroundTransparency = 0})
                    if callback then callback(opt) end
                end)
                
                YOffset = YOffset + 30
            end
            
            Frame.Size = UDim2.new(1, -10, 0, YOffset + 10)
        end

        return Tab
    end

    return Window
end

return Ziris
