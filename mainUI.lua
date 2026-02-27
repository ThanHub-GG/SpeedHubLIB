local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Mouse = game:GetService("Players").LocalPlayer:GetMouse()

local ThanHubLib = {}

function ThanHubLib:SetTransparency(state)
    local targetTransparency = state and 0.5 or 0 
    
    local framesToChange = {
        MainFrame,
        TopBar,
        Sidebar
    }

    for _, frame in pairs(framesToChange) do
        TweenService:Create(frame, TweenInfo.new(0.5), {BackgroundTransparency = targetTransparency}):Play()
    end
    
    for _, tab in pairs(Container:GetChildren()) do
        if tab:IsA("ScrollingFrame") then
            for _, sec in pairs(tab:GetChildren()) do
                if sec:IsA("Frame") then
                    TweenService:Create(sec, TweenInfo.new(0.5), {BackgroundTransparency = state and 0.3 or 0}):Play()
                end
            end
        end
    end
end

local notificationCount = 0

function ThanHubLib:Notification(title, text, duration)
    local NotifyGui = game:GetService("CoreGui"):FindFirstChild("ThanHubNotifications") or Instance.new("ScreenGui", game:GetService("CoreGui"))
    NotifyGui.Name = "ThanHubNotifications"

    notificationCount = notificationCount + 1
    
    local NotifFrame = Instance.new("Frame")
    NotifFrame.Size = UDim2.new(0, 260, 0, 75)
    -- Posisi Y dinamis berdasarkan jumlah notifikasi yang aktif
    local yPos = -100 - (notificationCount - 1) * 85
    NotifFrame.Position = UDim2.new(1, 20, 1, yPos) 
    NotifFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    NotifFrame.Parent = NotifyGui
    
    Instance.new("UICorner", NotifFrame)
    local Stroke = Instance.new("UIStroke", NotifFrame)
    Stroke.Color = Color3.fromRGB(0, 255, 204)

    local Ttitle = Instance.new("TextLabel", NotifFrame)
    Ttitle.Text = " " .. title:upper()
    Ttitle.Size = UDim2.new(1, -10, 0, 25)
    Ttitle.Position = UDim2.new(0, 10, 0, 8)
    Ttitle.TextColor3 = Color3.fromRGB(0, 255, 204)
    Ttitle.Font = Enum.Font.GothamBold
    Ttitle.TextSize = 14
    Ttitle.BackgroundTransparency = 1
    Ttitle.TextXAlignment = Enum.TextXAlignment.Left

    local Tdesc = Instance.new("TextLabel", NotifFrame)
    Tdesc.Text = text
    Tdesc.Size = UDim2.new(1, -20, 0, 35)
    Tdesc.Position = UDim2.new(0, 12, 0, 30)
    Tdesc.TextColor3 = Color3.fromRGB(200, 200, 200)
    Tdesc.Font = Enum.Font.GothamMedium
    Tdesc.TextSize = 12
    Tdesc.BackgroundTransparency = 1
    Tdesc.TextWrapped = true
    Tdesc.TextXAlignment = Enum.TextXAlignment.Left

    -- Animasi Masuk
    TweenService:Create(NotifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {Position = UDim2.new(1, -270, 1, yPos)}):Play()

    task.delay(duration or 3, function()
        local out = TweenService:Create(NotifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {Position = UDim2.new(1, 20, 1, yPos)})
        out:Play()
        out.Completed:Connect(function() 
            NotifFrame:Destroy() 
            notificationCount = notificationCount - 1
        end)
    end)
end

function ThanHubLib:CreateWindow(yourTitle, yourDesc, titleList)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ThanHub_Elite_V6_1"
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling 

    local OverlayLayer = Instance.new("Frame")
    OverlayLayer.Name = "OverlayLayer"
    OverlayLayer.Size = UDim2.new(1, 0, 1, 0)
    OverlayLayer.BackgroundTransparency = 1
    OverlayLayer.ZIndex = 999
    OverlayLayer.Active = false 
    OverlayLayer.Parent = ScreenGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 550, 0, 380) 
    MainFrame.Position = UDim2.new(0.5, -275, 0.5, -190)
    MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true 
    MainFrame.Parent = ScreenGui

    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
    local MainStroke = Instance.new("UIStroke", MainFrame)
    MainStroke.Color = Color3.fromRGB(35, 35, 35)
    MainStroke.Thickness = 2

    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 60)
    TopBar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    TopBar.BorderSizePixel = 0
    TopBar.ZIndex = 5
    TopBar.Parent = MainFrame
    Instance.new("UICorner", TopBar)

    local Logo = Instance.new("ImageLabel")
    Logo.Name = "Logo"
    Logo.Size = UDim2.new(0, 40, 0, 40)
    Logo.Position = UDim2.new(0, 15, 0.5, -20) 
    Logo.BackgroundTransparency = 1
    Logo.Image = "rbxassetid://85779221265543"
    Logo.Parent = TopBar

local UIActive = true
    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Enum.KeyCode.RightControl then -- Tombol R-Control
            UIActive = not UIActive
            ScreenGui.Enabled = UIActive
            
            ThanHubLib:Notification("System", UIActive and "UI Visible" or "UI Hidden", 1.5)
        end
    end)

local Watermark = Instance.new("TextLabel")
    Watermark.Name = "Watermark"
    Watermark.Parent = TopBar
    Watermark.Size = UDim2.new(0, 200, 0, 20)
    
    Watermark.AnchorPoint = Vector2.new(0.5, 0.5)
    Watermark.Position = UDim2.new(0.7, 0, 0.55, 0) 
    
    Watermark.BackgroundTransparency = 1
    Watermark.TextColor3 = Color3.fromRGB(0, 255, 204)
    Watermark.Font = Enum.Font.Code
    Watermark.TextSize = 10
    Watermark.TextXAlignment = Enum.TextXAlignment.Center
    Watermark.ZIndex = 5

    local TextStroke = Instance.new("UIStroke", Watermark)
    TextStroke.Thickness = 0.5
    TextStroke.Transparency = 0.5

    game:GetService("RunService").RenderStepped:Connect(function()
        local fps = math.floor(1 / game:GetService("RunService").RenderStepped:Wait())
        local pingRaw = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
        local ping = string.match(pingRaw, "%d+") or "0"
        
        Watermark.Text = fps .. " FPS  •  " .. ping .. " MS"
    end)

local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Position = UDim2.new(0, 65, 0, 10) 
    Title.Size = UDim2.new(0.5, 0, 0, 25)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.RichText = true
    Title.Parent = TopBar

    local titles = titleList or {yourTitle or "THANHUB UI"}
    Title.Text = "" 

    task.spawn(function()
        local index = 1
        while Title.Parent do
            local currentText = titles[index]
            
            for i = 1, #currentText do
                Title.Text = string.sub(currentText, 1, i) .. "|"
                task.wait(0.08)
            end
            
            Title.Text = currentText .. " "
            task.wait(2.5)
            
            for i = #currentText, 0, -1 do
                Title.Text = string.sub(currentText, 1, i) .. "|"
                task.wait(0.04)
            end
            
            task.wait(0.3)
            index = index + 1
            if index > #titles then index = 1 end
        end
    end)

    local Description = Instance.new("TextLabel")
    Description.Text = yourDesc or "Elite Script Interface"
    Description.Size = UDim2.new(0.5, 0, 0, 15)
    Description.Position = UDim2.new(0, 65, 0, 32)
    Description.BackgroundTransparency = 1
    Description.TextColor3 = Color3.fromRGB(150, 150, 150)
    Description.TextSize = 12
    Description.Font = Enum.Font.GothamMedium
    Description.TextXAlignment = Enum.TextXAlignment.Left
    Description.Parent = TopBar

    local Btns = Instance.new("Frame")
    Btns.Size = UDim2.new(0, 80, 0, 60) 
    Btns.Position = UDim2.new(1, -90, 0, 0)
    Btns.BackgroundTransparency = 1
    Btns.ZIndex = 10 
    Btns.Parent = TopBar

    local function CreateTopBtn(text, hoverColor, pos, callback)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 30, 0, 30) 
        b.Position = UDim2.new(0, pos, 0.5, -15)
        b.BackgroundTransparency = 1 
        b.Text = text
        b.TextColor3 = Color3.fromRGB(200, 200, 200)
        b.Font = Enum.Font.GothamBold
        b.TextSize = 25 
        b.Parent = Btns
        
        b.MouseEnter:Connect(function() TweenService:Create(b, TweenInfo.new(0.2), {TextColor3 = hoverColor}):Play() end)
        b.MouseLeave:Connect(function() TweenService:Create(b, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(200, 200, 200)}):Play() end)
        b.MouseButton1Click:Connect(callback)
    end

    CreateTopBtn("-", Color3.fromRGB(230, 160, 50), 0, function()
        local isMin = MainFrame.Size.Y.Offset < 100
        local targetSize = isMin and UDim2.new(0, 550, 0, 380) or UDim2.new(0, 550, 0, 60)
        TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Size = targetSize}):Play()
    end)

CreateTopBtn("×", Color3.fromRGB(230, 60, 60), 40, function()
    if MainFrame:FindFirstChild("ConfirmPopup") then return end
    
    local InternalOverlay = Instance.new("TextButton")
    InternalOverlay.Name = "ConfirmPopup"
    InternalOverlay.Size = UDim2.new(1, 0, 1, 0)
    InternalOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    InternalOverlay.BackgroundTransparency = 1 
    InternalOverlay.Text = ""
    InternalOverlay.AutoButtonColor = false
    InternalOverlay.ZIndex = 100
    InternalOverlay.Parent = MainFrame
    Instance.new("UICorner", InternalOverlay).CornerRadius = UDim.new(0, 10)

    local ConfirmFrame = Instance.new("Frame")
    ConfirmFrame.Name = "Main"
    local TargetSize = UDim2.new(0, 280, 0, 150)
    local TargetPos = UDim2.new(0.5, -140, 0.5, -75)
    
    ConfirmFrame.Size = UDim2.new(0, 0, 0, 0)
    ConfirmFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    ConfirmFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    ConfirmFrame.BorderSizePixel = 0
    ConfirmFrame.ClipsDescendants = true
    ConfirmFrame.ZIndex = 101
    ConfirmFrame.Parent = InternalOverlay
    Instance.new("UICorner", ConfirmFrame)
    
    local Stroke = Instance.new("UIStroke", ConfirmFrame)
    Stroke.Color = Color3.fromRGB(0, 255, 204)
    Stroke.Thickness = 2
    Stroke.Transparency = 1 -- Mulai dari transparan
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local Msg = Instance.new("TextLabel")
    Msg.Size = UDim2.new(1, -20, 0, 70)
    Msg.Position = UDim2.new(0, 10, 0, 15)
    Msg.BackgroundTransparency = 1
    Msg.Text = "CLOSE UI?\n<font size='11' color='rgb(150,150,150)'>Semua progres aktif akan berhenti.</font>"
    Msg.RichText = true
    Msg.TextColor3 = Color3.fromRGB(255, 255, 255)
    Msg.Font = Enum.Font.GothamBold
    Msg.TextSize = 16
    Msg.TextTransparency = 1 -- Mulai dari transparan
    Msg.ZIndex = 102
    Msg.Parent = ConfirmFrame

    local BtnContainer = Instance.new("Frame")
    BtnContainer.Size = UDim2.new(1, -30, 0, 35)
    BtnContainer.Position = UDim2.new(0, 15, 1, -50)
    BtnContainer.BackgroundTransparency = 1
    BtnContainer.ZIndex = 102
    BtnContainer.Parent = ConfirmFrame

    local function CreateChoice(text, color, pos, callback)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0.47, 0, 1, 0)
        b.Position = pos
        b.BackgroundColor3 = color
        b.Text = text
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.Font = Enum.Font.GothamBold
        b.TextSize = 13
        b.TextTransparency = 1
        b.BackgroundTransparency = 1
        b.ZIndex = 103
        b.Parent = BtnContainer
        Instance.new("UICorner", b)
        
        -- Hover Effect
        b.MouseEnter:Connect(function()
            TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = color:Lerp(Color3.fromRGB(255,255,255), 0.1)}):Play()
        end)
        b.MouseLeave:Connect(function()
            TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = color}):Play()
        end)

        b.MouseButton1Click:Connect(callback)
        return b
    end

    local confirmBtn = CreateChoice("CONFIRM", Color3.fromRGB(180, 50, 50), UDim2.new(0, 0, 0, 0), function()
        local outTime = 0.4
        local outInfo = TweenInfo.new(outTime, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        
        TweenService:Create(InternalOverlay, outInfo, {BackgroundTransparency = 1}):Play()
        
        local mainTween = TweenService:Create(MainFrame, TweenInfo.new(outTime + 0.1, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 50),
            BackgroundTransparency = 1
        })
        
        for _, v in pairs(MainFrame:GetDescendants()) do
            pcall(function()
                if v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("TextBox") then
                    TweenService:Create(v, TweenInfo.new(outTime), {TextTransparency = 1}):Play()
                end
                if v:IsA("ImageLabel") then
                    TweenService:Create(v, TweenInfo.new(outTime), {ImageTransparency = 1}):Play()
                end
                if v:IsA("Frame") or v:IsA("ScrollingFrame") then
                    TweenService:Create(v, TweenInfo.new(outTime), {BackgroundTransparency = 1}):Play()
                end
                if v:IsA("UIStroke") then
                    TweenService:Create(v, TweenInfo.new(outTime), {Transparency = 1}):Play()
                end
            end)
        end
        
        mainTween:Play()
        mainTween.Completed:Connect(function()
            ScreenGui:Destroy()
            if ThanHubLib.Notification then ThanHubLib:Notification("System", "Script Terminated", 2) end
        end)
    end)

    local cancelBtn = CreateChoice("CANCEL", Color3.fromRGB(30, 30, 30), UDim2.new(0.53, 0, 0, 0), function()
        
        ConfirmFrame:ClearAllChildren()
        
        TweenService:Create(InternalOverlay, TweenInfo.new(0.25), {BackgroundTransparency = 1}):Play()
        
        local closeTween = TweenService:Create(ConfirmFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        })
        
        closeTween:Play()
        
        closeTween.Completed:Connect(function()
            InternalOverlay:Destroy()
        end)
    end)

    -- [[ ANIMASI OPEN POPUP ]] --
    -- 1. Tampilkan Overlay Hitam pelan-pelan (0.4 opacity)
    TweenService:Create(InternalOverlay, TweenInfo.new(0.35), {BackgroundTransparency = 0.5}):Play()
    
    -- 2. Animasi Frame Muncul (Membesar dari tengah)
    -- Gunakan EasingStyle.Back untuk efek "Pop" yang membal sedikit
    local openTween = TweenService:Create(ConfirmFrame, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = TargetSize,
        Position = TargetPos
    })
    openTween:Play()
    
    -- 3. Munculkan Isi (Teks, Tombol, Stroke) setelah Frame hampir selesai membesar
    task.delay(0.25, function()
        TweenService:Create(Msg, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
        TweenService:Create(Stroke, TweenInfo.new(0.3), {Transparency = 0}):Play()
        
        -- Munculkan Tombol dengan sedikit jeda antara Confirm dan Cancel biar dinamis
        local btnInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        TweenService:Create(confirmBtn, btnInfo, {TextTransparency = 0, BackgroundTransparency = 0}):Play()
        task.wait(0.05)
        TweenService:Create(cancelBtn, btnInfo, {TextTransparency = 0, BackgroundTransparency = 0}):Play()
    end)
end)

    -- [[ DRAG LOGIC ]] --
    local dragInput, dragStart, startPos
    local dragging = false
    local targetPos = MainFrame.Position

    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
        MainFrame.Position = MainFrame.Position:Lerp(targetPos, 0.12)
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    local Sidebar = Instance.new("ScrollingFrame")
    Sidebar.Size = UDim2.new(0, 150, 1, -75)
    Sidebar.Position = UDim2.new(0, 10, 0, 70)
    Sidebar.BackgroundTransparency = 1
    Sidebar.ScrollBarThickness = 0
    Sidebar.Parent = MainFrame
    local SideLayout = Instance.new("UIListLayout", Sidebar)
    SideLayout.Padding = UDim.new(0, 5)

    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -180, 1, -75)
    Container.Position = UDim2.new(0, 170, 0, 70)
    Container.BackgroundTransparency = 1
    Container.Parent = MainFrame

-- [[ SEARCH BAR LOGIC ]] --
    local SearchFrame = Instance.new("Frame")
    SearchFrame.Size = UDim2.new(0, 130, 0, 30)
    SearchFrame.Position = UDim2.new(0, 10, 0, 70)
    SearchFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    SearchFrame.Parent = MainFrame
    Instance.new("UICorner", SearchFrame).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", SearchFrame).Color = Color3.fromRGB(35, 35, 35)

    local SearchInput = Instance.new("TextBox")
    SearchInput.Size = UDim2.new(1, -10, 1, 0)
    SearchInput.Position = UDim2.new(0, 10, 0, 0)
    SearchInput.BackgroundTransparency = 1
    SearchInput.Text = ""
    SearchInput.PlaceholderText = "Search Tab..."
    SearchInput.PlaceholderColor3 = Color3.fromRGB(80, 80, 80)
    SearchInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    SearchInput.Font = Enum.Font.Gotham
    SearchInput.TextSize = 12
    SearchInput.TextXAlignment = Enum.TextXAlignment.Left
    SearchInput.Parent = SearchFrame

    -- Fungsi Filter
    SearchInput:GetPropertyChangedSignal("Text"):Connect(function()
        local query = SearchInput.Text:lower()
        for _, btn in pairs(Sidebar:GetChildren()) do
            if btn:IsA("TextButton") then
                if string.find(btn.Text:lower(), query) then
                    btn.Visible = true
                else
                    btn.Visible = false
                end
            end
        end
    end)

    -- Sesuaikan posisi Sidebar agar tidak menabrak Searchbar
    Sidebar.Position = UDim2.new(0, 10, 0, 110)
    Sidebar.Size = UDim2.new(0, 150, 1, -120)


local function CreateSection(parent, name, layer, defaultOpen)
    local Sec = {}
    local IsOpen = (defaultOpen == nil and true or defaultOpen)
    local ElementCount = 0
    
    local SecFrame = Instance.new("Frame")
    SecFrame.Size = UDim2.new(1, -5, 0, IsOpen and 40 or 40) -- Akan diupdate oleh Layout
    SecFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    SecFrame.ClipsDescendants = true
    SecFrame.Parent = parent
    Instance.new("UICorner", SecFrame)
    
    local TitleBtn = Instance.new("TextButton")
    TitleBtn.Size = UDim2.new(1, 0, 0, 40)
    TitleBtn.BackgroundTransparency = 1
    TitleBtn.Text = "     " .. name:upper()
    TitleBtn.TextColor3 = Color3.fromRGB(0, 255, 204)
    TitleBtn.Font = Enum.Font.GothamBold
    TitleBtn.TextSize = 12
    TitleBtn.TextXAlignment = Enum.TextXAlignment.Left
    TitleBtn.Parent = SecFrame

    -- [[ ICON PANAH ]] --
    local Arrow = Instance.new("TextLabel")
    Arrow.Name = "Arrow"
    Arrow.Size = UDim2.new(0, 40, 0, 40)
    Arrow.Position = UDim2.new(1, -40, 0, 0)
    Arrow.BackgroundTransparency = 1
    Arrow.Text = "v" -- Kamu bisa ganti jadi "keyboard_arrow_down" jika pakai custom font
    Arrow.TextColor3 = Color3.fromRGB(0, 255, 204)
    Arrow.TextSize = 14
    Arrow.Font = Enum.Font.GothamBold
    Arrow.Rotation = IsOpen and 0 or -90 -- Posisi awal panah
    Arrow.Parent = TitleBtn

    local Content = Instance.new("Frame")
    Content.Size = UDim2.new(1, 0, 0, 0)
    Content.Position = UDim2.new(0, 0, 0, 45)
    Content.BackgroundTransparency = 1
    Content.Parent = SecFrame
    
    local Layout = Instance.new("UIListLayout", Content)
    Layout.Padding = UDim.new(0, 8)
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Layout.SortOrder = Enum.SortOrder.LayoutOrder

    -- Otomatis update ukuran jika isi di dalamnya bertambah
    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        if IsOpen then 
            SecFrame.Size = UDim2.new(1, -5, 0, Layout.AbsoluteContentSize.Y + 60) 
        end
    end)

    TitleBtn.MouseButton1Click:Connect(function()
        IsOpen = not IsOpen
        
        -- Animasi Ukuran Section
        TweenService:Create(SecFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
            Size = IsOpen and UDim2.new(1, -5, 0, Layout.AbsoluteContentSize.Y + 60) or UDim2.new(1, -5, 0, 40)
        }):Play()

        -- Animasi Rotasi Panah
        TweenService:Create(Arrow, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
            Rotation = IsOpen and 0 or -90
        }):Play()
    end)

        function Sec:AddLabel(text)
            ElementCount = ElementCount + 1
            local lab = Instance.new("TextLabel")
            lab.Size = UDim2.new(0.94, 0, 0, 20)
            lab.BackgroundTransparency = 1
            lab.Text = "—  " .. text .. "  —"
            lab.TextColor3 = Color3.fromRGB(100, 100, 100)
            lab.Font = Enum.Font.GothamBold
            lab.TextSize = 10
            lab.LayoutOrder = ElementCount
            lab.Parent = Content
        end

        function Sec:AddToggle(text, def, cb)
            ElementCount = ElementCount + 1
            local state = def
            local t = Instance.new("TextButton")
            t.Size = UDim2.new(0.94, 0, 0, 38)
            t.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            t.Text = "      " .. text
            t.TextColor3 = Color3.fromRGB(230, 230, 230)
            t.Font = Enum.Font.GothamMedium
            t.TextSize = 12
            t.TextXAlignment = Enum.TextXAlignment.Left
            t.LayoutOrder = ElementCount
            t.Parent = Content
            Instance.new("UICorner", t)
            
            local Track = Instance.new("Frame")
            Track.Size = UDim2.new(0, 38, 0, 18)
            Track.Position = UDim2.new(1, -45, 0.5, -9)
            Track.BackgroundColor3 = state and Color3.fromRGB(0, 255, 204) or Color3.fromRGB(40, 40, 40)
            Track.Parent = t
            Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)
            
            local Knob = Instance.new("Frame")
            Knob.Size = UDim2.new(0, 14, 0, 14)
            Knob.Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
            Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Knob.Parent = Track
            Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)
            
            t.MouseButton1Click:Connect(function()
                state = not state
                TweenService:Create(Track, TweenInfo.new(0.2), {BackgroundColor3 = state and Color3.fromRGB(0, 255, 204) or Color3.fromRGB(40, 40, 40)}):Play()
                TweenService:Create(Knob, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)}):Play()
                cb(state)
            end)
        end

        function Sec:AddButton(text, cb)
            ElementCount = ElementCount + 1
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(0.94, 0, 0, 32)
            b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            b.Text = text
            b.TextSize = 12
            b.TextColor3 = Color3.fromRGB(255, 255, 255)
            b.Font = Enum.Font.GothamBold
            b.LayoutOrder = ElementCount
            b.Parent = Content
            Instance.new("UICorner", b)
            b.MouseButton1Click:Connect(cb)
        end

        function Sec:AddSlider(text, min, max, default, callback)
            ElementCount = ElementCount + 1
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Size = UDim2.new(0.94, 0, 0, 45)
            SliderFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            SliderFrame.LayoutOrder = ElementCount
            SliderFrame.Parent = Content
            Instance.new("UICorner", SliderFrame)
            
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -20, 0, 20)
            Label.Position = UDim2.new(0, 10, 0, 5)
            Label.BackgroundTransparency = 1
            Label.Text = text .. " : " .. default
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.Font = Enum.Font.GothamBold
            Label.TextSize = 12
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = SliderFrame
            
            local Bar = Instance.new("TextButton")
            Bar.Size = UDim2.new(1, -20, 0, 4)
            Bar.Position = UDim2.new(0, 10, 0, 32)
            Bar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            Bar.Text = ""
            Bar.Parent = SliderFrame
            Instance.new("UICorner", Bar)
            
            local Fill = Instance.new("Frame")
            Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            Fill.BackgroundColor3 = Color3.fromRGB(0, 255, 204)
            Fill.Parent = Bar
            Instance.new("UICorner", Fill)
            
            local function Update()
                local Perc = math.clamp((Mouse.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                local Val = math.floor(min + (max - min) * Perc)
                Fill.Size = UDim2.new(Perc, 0, 1, 0)
                Label.Text = text .. " : " .. Val
                callback(Val)
            end
            
            Bar.MouseButton1Down:Connect(function()
                local Move = UserInputService.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement then Update() end
                end)
                local Up; Up = UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then Move:Disconnect() Up:Disconnect() end
                end)
                Update()
            end)
        end

function Sec:AddParagraph(title, text)
            ElementCount = ElementCount + 1
            local ParaFrame = Instance.new("Frame")
            ParaFrame.Size = UDim2.new(0.94, 0, 0, 0) -- Tinggi akan dihitung otomatis
            ParaFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            ParaFrame.LayoutOrder = ElementCount
            ParaFrame.Parent = Content
            Instance.new("UICorner", ParaFrame)

            local ParaTitle = Instance.new("TextLabel")
            ParaTitle.Size = UDim2.new(1, -20, 0, 25)
            ParaTitle.Position = UDim2.new(0, 10, 0, 5)
            ParaTitle.BackgroundTransparency = 1
            ParaTitle.Text = title:upper()
            ParaTitle.TextColor3 = Color3.fromRGB(0, 255, 204)
            ParaTitle.Font = Enum.Font.GothamBold
            ParaTitle.TextSize = 11
            ParaTitle.TextXAlignment = Enum.TextXAlignment.Left
            ParaTitle.Parent = ParaFrame

            local ParaText = Instance.new("TextLabel")
            ParaText.Size = UDim2.new(1, -20, 0, 0)
            ParaText.Position = UDim2.new(0, 10, 0, 25)
            ParaText.BackgroundTransparency = 1
            ParaText.Text = text
            ParaText.TextColor3 = Color3.fromRGB(180, 180, 180)
            ParaText.Font = Enum.Font.GothamMedium
            ParaText.TextSize = 12
            ParaText.TextWrapped = true -- Teks otomatis ke bawah
            ParaText.TextXAlignment = Enum.TextXAlignment.Left
            ParaText.TextYAlignment = Enum.TextYAlignment.Top
            ParaText.Parent = ParaFrame

            -- Otomatis menghitung tinggi Frame berdasarkan panjang teks
            local function UpdateSize()
                local textSize = game:GetService("TextService"):GetTextSize(
                    ParaText.Text, 
                    ParaText.TextSize, 
                    ParaText.Font, 
                    Vector2.new(ParaText.AbsoluteSize.X, 10000)
                )
                ParaText.Size = UDim2.new(1, -20, 0, textSize.Y + 5)
                ParaFrame.Size = UDim2.new(0.94, 0, 0, textSize.Y + 40)
            end

            -- Tunggu frame render sebentar lalu update ukuran
            task.spawn(function()
                task.wait()
                UpdateSize()
            end)

            -- Jika text berubah manual nanti
            ParaText:GetPropertyChangedSignal("Text"):Connect(UpdateSize)
        end

function Sec:AddDropdown(text, options, callback) 
    ElementCount = ElementCount + 1
    local IsOpen = false
    local DropBtn = Instance.new("TextButton")
    DropBtn.Size = UDim2.new(0.94, 0, 0, 40)
    DropBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    DropBtn.Text = text .. " : [Choose]"
    DropBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    DropBtn.Font = Enum.Font.GothamBold
    DropBtn.TextSize = 12
    DropBtn.LayoutOrder = ElementCount
    DropBtn.Parent = Content
    Instance.new("UICorner", DropBtn)

    -- POPUP FRAME
    local PopUp = Instance.new("Frame")
    PopUp.Size = UDim2.new(1, 0, 0, 160) -- Ukuran lebih tinggi karena ada Search Bar
    PopUp.Position = UDim2.new(0, 0, 0, 45)
    PopUp.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    PopUp.ZIndex = 500
    PopUp.Visible = false
    PopUp.Parent = DropBtn
    Instance.new("UICorner", PopUp)
    Instance.new("UIStroke", PopUp).Color = Color3.fromRGB(0, 255, 204)

    -- SEARCH BAR (Di dalam Dropdown)
    local DropSearchFrame = Instance.new("Frame")
    DropSearchFrame.Size = UDim2.new(1, -14, 0, 28)
    DropSearchFrame.Position = UDim2.new(0, 7, 0, 7)
    DropSearchFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    DropSearchFrame.ZIndex = 501
    DropSearchFrame.Parent = PopUp
    Instance.new("UICorner", DropSearchFrame).CornerRadius = UDim.new(0, 4)

    local DropSearch = Instance.new("TextBox")
    DropSearch.Size = UDim2.new(1, -10, 1, 0)
    DropSearch.Position = UDim2.new(0, 5, 0, 0)
    DropSearch.BackgroundTransparency = 1
    DropSearch.Text = ""
    DropSearch.PlaceholderText = "Cari pilihan..."
    DropSearch.PlaceholderColor3 = Color3.fromRGB(80, 80, 80)
    DropSearch.TextColor3 = Color3.fromRGB(255, 255, 255)
    DropSearch.TextSize = 11
    DropSearch.Font = Enum.Font.Gotham
    DropSearch.ZIndex = 502
    DropSearch.Parent = DropSearchFrame

    -- SCROLLING FRAME
    local ItemScroll = Instance.new("ScrollingFrame")
    ItemScroll.Size = UDim2.new(1, 0, 1, -45) -- Sisakan ruang untuk Search Bar
    ItemScroll.Position = UDim2.new(0, 0, 0, 40)
    ItemScroll.BackgroundTransparency = 1
    ItemScroll.ScrollBarThickness = 2
    ItemScroll.ZIndex = 501
    ItemScroll.Parent = PopUp
    
    local ItemList = Instance.new("UIListLayout", ItemScroll)
    ItemList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    ItemList.Padding = UDim.new(0, 5)

    DropSearch:GetPropertyChangedSignal("Text"):Connect(function()
        local query = DropSearch.Text:lower()
        for _, obj in pairs(ItemScroll:GetChildren()) do
            if obj:IsA("TextButton") then
                obj.Visible = string.find(obj.Text:lower(), query) ~= nil
            end
        end
    end)

    DropBtn.MouseButton1Click:Connect(function()
        IsOpen = not IsOpen
        PopUp.Visible = IsOpen
        DropBtn.ZIndex = IsOpen and 10 or 1 
        SecFrame.ClipsDescendants = not IsOpen 
        if IsOpen then DropSearch:CaptureFocus() end -- Langsung ketik saat buka
    end)

    -- INSERT OPTIONS
    for _, opt in pairs(options) do
        local o = Instance.new("TextButton")
        o.Size = UDim2.new(0.92, 0, 0, 28)
        o.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        o.Text = opt
        o.TextColor3 = Color3.fromRGB(255, 255, 255)
        o.Font = Enum.Font.GothamBold
        o.ZIndex = 502
        o.Parent = ItemScroll
        Instance.new("UICorner", o)
        
        o.MouseButton1Click:Connect(function()
            DropBtn.Text = text .. " : " .. opt
            callback(opt)
            IsOpen = false
            PopUp.Visible = false
            DropBtn.ZIndex = 1
            SecFrame.ClipsDescendants = true
            DropSearch.Text = "" -- Reset search saat dipilih
        end)
    end
    ItemScroll.CanvasSize = UDim2.new(0, 0, 0, ItemList.AbsoluteContentSize.Y + 10)
end

function Sec:AddInput(text, placeholder, callback)
            ElementCount = ElementCount + 1
            local InputFrame = Instance.new("Frame")
            InputFrame.Size = UDim2.new(0.94, 0, 0, 45)
            InputFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            InputFrame.LayoutOrder = ElementCount
            InputFrame.Parent = Content
            Instance.new("UICorner", InputFrame)

            local InputTitle = Instance.new("TextLabel")
            InputTitle.Size = UDim2.new(1, -20, 0, 20)
            InputTitle.Position = UDim2.new(0, 10, 0, 5)
            InputTitle.BackgroundTransparency = 1
            InputTitle.Text = text
            InputTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
            InputTitle.Font = Enum.Font.GothamBold
            InputTitle.TextSize = 11
            InputTitle.TextXAlignment = Enum.TextXAlignment.Left
            InputTitle.Parent = InputFrame

            local InputBoxFrame = Instance.new("Frame")
            InputBoxFrame.Size = UDim2.new(1, -20, 0, 22)
            InputBoxFrame.Position = UDim2.new(0, 10, 0, 23)
            InputBoxFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            InputBoxFrame.Parent = InputFrame
            Instance.new("UICorner", InputBoxFrame).CornerRadius = UDim.new(0, 4)
            local Stroke = Instance.new("UIStroke", InputBoxFrame)
            Stroke.Color = Color3.fromRGB(40, 40, 40)
            Stroke.Thickness = 1

            local TextBox = Instance.new("TextBox")
            TextBox.Size = UDim2.new(1, -10, 1, 0)
            TextBox.Position = UDim2.new(0, 5, 0, 0)
            TextBox.BackgroundTransparency = 1
            TextBox.Text = ""
            TextBox.PlaceholderText = placeholder or "Ketik di sini..."
            TextBox.PlaceholderColor3 = Color3.fromRGB(80, 80, 80)
            TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextBox.Font = Enum.Font.GothamMedium
            TextBox.TextSize = 12
            TextBox.TextXAlignment = Enum.TextXAlignment.Left
            TextBox.Parent = InputBoxFrame

            -- Animasi saat kotak diklik (Focus)
            TextBox.Focused:Connect(function()
                TweenService:Create(Stroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(0, 255, 204)}):Play()
            end)

            TextBox.FocusLost:Connect(function(enterPressed)
                TweenService:Create(Stroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(40, 40, 40)}):Play()
                -- Jalankan callback saat user tekan Enter
                if enterPressed then
                    callback(TextBox.Text)
                end
            end)
        end

function Sec:AddMultiDropdown(text, options, callback)
    ElementCount = ElementCount + 1
    local IsOpen = false
    local SelectedOptions = {} -- Tabel untuk menyimpan pilihan
    
    local DropBtn = Instance.new("TextButton")
    DropBtn.Size = UDim2.new(0.94, 0, 0, 40)
    DropBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    DropBtn.Text = text .. " : { ... }"
    DropBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    DropBtn.Font = Enum.Font.GothamBold
    DropBtn.TextSize = 12
    DropBtn.LayoutOrder = ElementCount
    DropBtn.Parent = Content
    Instance.new("UICorner", DropBtn)

    local PopUp = Instance.new("Frame")
    PopUp.Size = UDim2.new(1, 0, 0, 180) -- Lebih tinggi sedikit
    PopUp.Position = UDim2.new(0, 0, 0, 45)
    PopUp.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    PopUp.ZIndex = 500
    PopUp.Visible = false
    PopUp.Parent = DropBtn
    Instance.new("UICorner", PopUp)
    Instance.new("UIStroke", PopUp).Color = Color3.fromRGB(0, 255, 204)

    -- SEARCH BAR
    local DropSearchFrame = Instance.new("Frame")
    DropSearchFrame.Size = UDim2.new(1, -14, 0, 28)
    DropSearchFrame.Position = UDim2.new(0, 7, 0, 7)
    DropSearchFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    DropSearchFrame.ZIndex = 501
    DropSearchFrame.Parent = PopUp
    Instance.new("UICorner", DropSearchFrame).CornerRadius = UDim.new(0, 4)

    local DropSearch = Instance.new("TextBox")
    DropSearch.Size = UDim2.new(1, -10, 1, 0)
    DropSearch.Position = UDim2.new(0, 5, 0, 0)
    DropSearch.BackgroundTransparency = 1
    DropSearch.Text = ""
    DropSearch.PlaceholderText = "Cari & Pilih Banyak..."
    DropSearch.PlaceholderColor3 = Color3.fromRGB(80, 80, 80)
    DropSearch.TextColor3 = Color3.fromRGB(255, 255, 255)
    DropSearch.TextSize = 11
    DropSearch.Font = Enum.Font.Gotham
    DropSearch.ZIndex = 502
    DropSearch.Parent = DropSearchFrame

    local ItemScroll = Instance.new("ScrollingFrame")
    ItemScroll.Size = UDim2.new(1, 0, 1, -45)
    ItemScroll.Position = UDim2.new(0, 0, 0, 40)
    ItemScroll.BackgroundTransparency = 1
    ItemScroll.ScrollBarThickness = 2
    ItemScroll.ZIndex = 501
    ItemScroll.Parent = PopUp
    
    local ItemList = Instance.new("UIListLayout", ItemScroll)
    ItemList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    ItemList.Padding = UDim.new(0, 5)

    -- Update Label Utama
    local function UpdateLabel()
        if #SelectedOptions == 0 then
            DropBtn.Text = text .. " : [Pilih]"
        else
            DropBtn.Text = text .. " : (" .. #SelectedOptions .. ") Selected"
        end
    end

    -- Filter Search
    DropSearch:GetPropertyChangedSignal("Text"):Connect(function()
        local query = DropSearch.Text:lower()
        for _, obj in pairs(ItemScroll:GetChildren()) do
            if obj:IsA("TextButton") then
                obj.Visible = string.find(obj.Text:lower(), query) ~= nil
            end
        end
    end)

    DropBtn.MouseButton1Click:Connect(function()
        IsOpen = not IsOpen
        PopUp.Visible = IsOpen
        DropBtn.ZIndex = IsOpen and 10 or 1 
        SecFrame.ClipsDescendants = not IsOpen 
    end)

    -- INSERT OPTIONS
    for _, opt in pairs(options) do
        local isSelected = false
        local o = Instance.new("TextButton")
        o.Size = UDim2.new(0.92, 0, 0, 28)
        o.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        o.Text = opt
        o.TextColor3 = Color3.fromRGB(150, 150, 150)
        o.Font = Enum.Font.GothamBold
        o.ZIndex = 502
        o.Parent = ItemScroll
        Instance.new("UICorner", o)
        
        -- Indikator Pilihan (Bulatan kecil di samping)
        local Check = Instance.new("Frame")
        Check.Size = UDim2.new(0, 6, 0, 6)
        Check.Position = UDim2.new(0, 10, 0.5, -3)
        Check.BackgroundColor3 = Color3.fromRGB(0, 255, 204)
        Check.BackgroundTransparency = 1 -- Sembunyi jika tidak dipilih
        Check.ZIndex = 503
        Check.Parent = o
        Instance.new("UICorner", Check)

        o.MouseButton1Click:Connect(function()
            isSelected = not isSelected
            
            if isSelected then
                table.insert(SelectedOptions, opt)
                TweenService:Create(o, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(0, 255, 204), BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
                Check.BackgroundTransparency = 0
            else
                for i, v in pairs(SelectedOptions) do
                    if v == opt then table.remove(SelectedOptions, i) end
                end
                TweenService:Create(o, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(150, 150, 150), BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
                Check.BackgroundTransparency = 1
            end
            
            UpdateLabel()
            callback(SelectedOptions) -- Kirim tabel isi pilihan
        end)
    end
    ItemScroll.CanvasSize = UDim2.new(0, 0, 0, ItemList.AbsoluteContentSize.Y + 10)
end

        return Sec
    end

local function AddBackgroundEffects(parent)
    local BgGradient = Instance.new("UIGradient")
    BgGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 10, 10)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20, 25, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 10))
    })
    BgGradient.Parent = parent

    task.spawn(function()
        while task.wait() do
            BgGradient.Rotation = BgGradient.Rotation + 1
            if BgGradient.Rotation >= 360 then BgGradient.Rotation = 0 end
        end
    end)

    local ParticleContainer = Instance.new("Frame")
    ParticleContainer.Size = UDim2.new(1, 0, 1, 0)
    ParticleContainer.BackgroundTransparency = 1
    ParticleContainer.ClipsDescendants = true
    ParticleContainer.ZIndex = 0
    ParticleContainer.Parent = parent

    for i = 1, 20 do 
        local p = Instance.new("Frame")
        local size = math.random(2, 4)
        p.Size = UDim2.new(0, size, 0, size)
        p.BackgroundColor3 = Color3.fromRGB(0, 255, 204)
        p.BackgroundTransparency = 0.8
        p.Position = UDim2.new(math.random(), 0, math.random(), 0)
        p.Parent = ParticleContainer
        Instance.new("UICorner", p).CornerRadius = UDim.new(1, 0)

        task.spawn(function()
            while task.wait() do
                local targetPos = UDim2.new(math.random(), 0, math.random(), 0)
                local t = TweenService:Create(p, TweenInfo.new(math.random(5, 10), Enum.EasingStyle.Linear), {
                    Position = targetPos,
                    BackgroundTransparency = math.random(5, 9)/10
                })
                t:Play()
                t.Completed:Wait()
            end
        end)
    end
end

AddBackgroundEffects(MainFrame)

    local WindowFunctions = {}
    local TabCount = 0

function WindowFunctions:SetTransparency(state)
        local target = state and 0.35 or 0
        if MainFrame then
            TweenService:Create(MainFrame, TweenInfo.new(0.4), {BackgroundTransparency = target}):Play()
        end
        if TopBar then
            TweenService:Create(TopBar, TweenInfo.new(0.4), {BackgroundTransparency = target}):Play()
        end
    end

    function WindowFunctions:AddTab(name)
        TabCount = TabCount + 1
        local MyOrder = TabCount
        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 0
        Page.Parent = Container
        local PageLayout = Instance.new("UIListLayout", Page)
        PageLayout.Padding = UDim.new(0, 10)
        PageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, -10, 0, 38)
        TabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        TabBtn.Text = name
        TabBtn.TextColor3 = Color3.fromRGB(120, 120, 120)
        TabBtn.Font = Enum.Font.GothamBold
        TabBtn.LayoutOrder = MyOrder
        TabBtn.Parent = Sidebar
        Instance.new("UICorner", TabBtn)

        TabBtn.MouseButton1Click:Connect(function()
            OverlayLayer:ClearAllChildren()
            OverlayLayer.Active = false
            for _, p in pairs(Container:GetChildren()) do if p:IsA("ScrollingFrame") then p.Visible = false end end
            Page.Visible = true
            for _, b in pairs(Sidebar:GetChildren()) do if b:IsA("TextButton") then 
                TweenService:Create(b, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(120, 120, 120), BackgroundColor3 = Color3.fromRGB(20, 20, 20)}):Play()
            end end
            TweenService:Create(TabBtn, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(0, 255, 204), BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
        end)
        TabBtn.MouseEnter:Connect(function()
                TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 30), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            end)
        TabBtn.MouseLeave:Connect(function()
            if not Page.Visible then
                TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20, 20, 20), TextColor3 = Color3.fromRGB(120, 120, 120)}):Play()
            end
        end)
        if MyOrder == 1 then
            Page.Visible = true
            TabBtn.TextColor3 = Color3.fromRGB(0, 255, 204)
            TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        end

        local TabRes = {}
        function TabRes:AddSection(n, isOpen)
            return CreateSection(Page, n, OverlayLayer, isOpen)
        end
        return TabRes
    end

UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightControl then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)
    return WindowFunctions
end

-- local Window = ThanHubLib:CreateWindow("ThanHub Script", "Game : Unknown", {"Premium Version", "ThanHub | Best Script"}) -- yg didalam {} hanya optional saja
-- local Tab1 = Window:AddTab("Main")
-- local Tab2 = Window:AddTab("Misc")

-- local Sec1 = Tab1:AddSection("Farming", true)
-- local Sec = Tab2:AddSection("Misc Settings", true)

-- Sec1:AddLabel("Created By Than Ganteng")

-- Sec1:AddParagraph("Update Log V6.1", "1. Ditambahkan fitur Multi-Select Dropdown\n2. Penambahan Searchbar pada Sidebar\n3. Perbaikan bug pada sistem Drag UI\n4. Penambahan fitur Paragraph ini.")
-- Sec1:AddParagraph("Peringatan", "Gunakan script ini dengan bijak. Kami tidak bertanggung jawab atas sanksi yang diberikan oleh developer game.")

-- Sec1:AddToggle("Auto Click", false, function(state) 
--     print("Auto Click:", state) 
-- end)

-- Sec1:AddButton("Refresh Data", function()
--     ThanHubLib:Notification("Data Refreshed!", "ThanHub Refresh", 4)
-- end)

-- Sec1:AddDropdown("Pilih Senjata", {"Pedang", "Panah", "Gunting"}, function(selected) 
--     print("Senjata dipilih:", selected) 
-- end)

-- Sec1:AddMultiDropdown("Pilih Target", {"Player1", "Player2", "Player3"}, function(tablePilihan)
--     for _, v in pairs(tablePilihan) do
--         print("Target aktif: " .. v)
--     end
-- end)

-- Sec1:AddSlider("Speed", 1, 100, 50, function(value) 
--     print("Speed set to:", value) 
-- end)

-- Sec:AddInput("WalkSpeed", "Masukkan angka (16-500)", function(val)
--     local num = tonumber(val)
--     if num then
--         game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = num
--         print("Speed diubah ke: " .. num)
--     else
--         print("Mohon masukkan angka yang valid!")
--     end
-- end)

-- Sec:AddInput("Webhook URL", "Paste URL di sini...", function(text)
--     print("URL tersimpan: " .. text)
-- end)

-- Sec:AddToggle("Transparent Mode", false, function(state)
--     -- PANGGIL LEWAT WINDOW OBJECT
--     Window:SetTransparency(state)
-- end)
