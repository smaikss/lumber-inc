-- ==================== Oaklands Helper V6.1 - Anti-Detection ====================
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local autoTreeTeleport = false
local clickTeleportPlayer = true
local freecamActive = false
local debugMode = false
local freecamPart = nil
local targetTreePos = nil

-- ==================== TELEPORTS ====================
local savedTeleports = {
    {Name = "🌲 Tree Zone 1", Position = Vector3.new(-867.1, 134.5, -1000.9)},
    {Name = "💰 Sell Zone", Position = Vector3.new(-153.9, 23.0, -0.8)}
}

-- ==================== ALLOWED FOLDERS ====================
local AllowedTreeFolders = {"LooseItems", "LooseTree", "Logs", "Trees", "Tree", "Birch", "Forest", "Map"}

-- ==================== GUI ====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RobloxGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999999
ScreenGui.Parent = game:GetService("CoreGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 460, 0, 520)
Frame.Position = UDim2.new(0.5, -230, 0.5, -260)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

-- Dragging
local dragging = false
local dragStart, startPos
Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,50)
Title.BackgroundColor3 = Color3.fromRGB(15,15,15)
Title.Text = "🌲 Cheat menu  V6.1"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextScaled = true
Title.Parent = Frame

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 100, 0, 30)
CloseBtn.Position = UDim2.new(1, -110, 0, 10)
CloseBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
CloseBtn.Text = "❌ Close"
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.TextScaled = true
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Frame

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    print("🌲 Cheat menu V6.1 Closed")
end)

-- ==================== POSITION HUD ====================
local PosFrame = Instance.new("Frame")
PosFrame.Size = UDim2.new(0, 240, 0, 50)
PosFrame.Position = UDim2.new(0, 10, 0, 10)
PosFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
PosFrame.BorderSizePixel = 2
PosFrame.BorderColor3 = Color3.fromRGB(0, 170, 255)
PosFrame.Parent = ScreenGui

local PosLabel = Instance.new("TextLabel")
PosLabel.Size = UDim2.new(1,0,1,0)
PosLabel.BackgroundTransparency = 1
PosLabel.TextColor3 = Color3.new(1,1,1)
PosLabel.TextScaled = true
PosLabel.Font = Enum.Font.Code
PosLabel.Text = "Position: Waiting..."
PosLabel.Parent = PosFrame

RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local pos = LocalPlayer.Character.HumanoidRootPart.Position
        PosLabel.Text = string.format("X: %.1f   Y: %.1f   Z: %.1f", pos.X, pos.Y, pos.Z)
    end
end)

local TabButtons = Instance.new("Frame")
TabButtons.Size = UDim2.new(1,0,0,40)
TabButtons.Position = UDim2.new(0,0,0,50)
TabButtons.BackgroundTransparency = 1
TabButtons.Parent = Frame

local function CreateTabBtn(text, pos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.33,-5,1,0)
    btn.Position = UDim2.new(pos,0,0,0)
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.Parent = TabButtons
    return btn
end

local FarmTabBtn = CreateTabBtn("Farm", 0)
local TeleportTabBtn = CreateTabBtn("Teleport", 0.33)
local SettingsTabBtn = CreateTabBtn("Settings", 0.66)

local Scrolling = Instance.new("ScrollingFrame")
Scrolling.Size = UDim2.new(1,-20,1,-110)
Scrolling.Position = UDim2.new(0,10,0,100)
Scrolling.BackgroundTransparency = 1
Scrolling.ScrollBarThickness = 6
Scrolling.Parent = Frame

local UIList = Instance.new("UIListLayout")
UIList.Padding = UDim.new(0,8)
UIList.Parent = Scrolling

local function ClearScroll()
    for _,v in pairs(Scrolling:GetChildren()) do
        if v:IsA("GuiObject") and v.Name ~= "UIListLayout" then v:Destroy() end
    end
end

-- ==================== FREECAM ====================
local function ToggleFreecam()
    freecamActive = not freecamActive
    if freecamActive then
        local camPos = Camera.CFrame
        freecamPart = Instance.new("Part")
        freecamPart.Size = Vector3.new(1,1,1)
        freecamPart.Transparency = 1
        freecamPart.CanCollide = false
        freecamPart.Anchored = true
        freecamPart.CFrame = camPos
        freecamPart.Parent = Workspace
        Camera.CameraSubject = freecamPart
    else
        if freecamPart then freecamPart:Destroy() freecamPart = nil end
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            Camera.CameraSubject = LocalPlayer.Character.Humanoid
        end
    end
end

RunService.RenderStepped:Connect(function()
    if freecamActive and freecamPart then
        local speed = 2.5
        local moveDir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.E) then moveDir += Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.Q) then moveDir -= Vector3.new(0,1,0) end
        freecamPart.CFrame += moveDir * speed * 0.016
    end
end)

-- ==================== TELEPORT FUNCTION ====================
local function TeleportTree(part, finalPos)
    if not part or not part:IsA("BasePart") then return end
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    task.spawn(function()
        pcall(function()
            local wasAnchored = part.Anchored
            part.Anchored = false
            part.CFrame = hrp.CFrame * CFrame.new(0, 0, -6.5)
            task.wait(0.08 + math.random(1,5)/100)

            local targetCFrame = CFrame.new(finalPos + Vector3.new(math.random(-3,3), 12 + math.random(0,6), math.random(-3,3)))

            for i = 1, 16 do
                part.AssemblyLinearVelocity = Vector3.new(math.random(-10,10), math.random(-5,15), math.random(-10,10))
                part.AssemblyAngularVelocity = Vector3.new(math.random(-8,8), math.random(-8,8), math.random(-8,8))
                part.CFrame = targetCFrame
                if i % 4 == 0 then
                    task.wait(0.025 + math.random(2,8)/100)
                else
                    RunService.Heartbeat:Wait()
                end
            end

            part.AssemblyLinearVelocity = Vector3.zero
            part.AssemblyAngularVelocity = Vector3.zero
            part.CFrame = targetCFrame
            task.wait(0.12)
            if wasAnchored then part.Anchored = true end
        end)
    end)
end

local function IsTree(target)
    if not target or not target:IsA("BasePart") then return false end
    local current = target.Parent
    while current and current ~= Workspace do
        if table.find(AllowedTreeFolders, current.Name) then return true end
        current = current.Parent
    end
    local n = target.Name:lower()
    if n:find("birch") or n:find("branch") or n == "trunk" or n == "log" then return true end
    return false
end

-- ==================== INPUT ====================
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end

    if input.KeyCode == Enum.KeyCode.F and clickTeleportPlayer then
        local mouse = LocalPlayer:GetMouse()
        if mouse.Hit and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0,3,0))
        end
    end

    if debugMode and input.UserInputType == Enum.UserInputType.MouseButton1 then
        local mouse = LocalPlayer:GetMouse()
        if mouse.Target then print("Clicked: " .. mouse.Target.Name .. " | Parent: " .. mouse.Target.Parent.Name) end
    end

    if input.UserInputType == Enum.UserInputType.MouseButton1 and autoTreeTeleport then
        task.wait(math.random(70,190)/1000)
        local finalPos = targetTreePos
        if not finalPos then finalPos = savedTeleports[2].Position end -- Sell Zone

        local mouse = LocalPlayer:GetMouse()
        if mouse.Target and finalPos and IsTree(mouse.Target) then
            TeleportTree(mouse.Target, finalPos)
        end
    end
end)

-- ==================== TABS (ПОВНІ) ====================
local function ShowFarm()
    ClearScroll()
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(1,0,0,60)
    ToggleBtn.BackgroundColor3 = autoTreeTeleport and Color3.fromRGB(0,170,0) or Color3.fromRGB(170,0,0)
    ToggleBtn.Text = autoTreeTeleport and "🟢 Auto Tree Teleport: ON" or "🔴 Auto Tree Teleport: OFF"
    ToggleBtn.TextColor3 = Color3.new(1,1,1)
    ToggleBtn.TextScaled = true
    ToggleBtn.Parent = Scrolling
    ToggleBtn.MouseButton1Click:Connect(function()
        autoTreeTeleport = not autoTreeTeleport
        ShowFarm()
    end)

    local SaveBtn = Instance.new("TextButton")
    SaveBtn.Size = UDim2.new(1,0,0,50)
    SaveBtn.BackgroundColor3 = Color3.fromRGB(0,120,255)
    SaveBtn.Text = "🎯 Save Current Sell Position"
    SaveBtn.TextColor3 = Color3.new(1,1,1)
    SaveBtn.TextScaled = true
    SaveBtn.Parent = Scrolling
    SaveBtn.MouseButton1Click:Connect(function()
        if freecamActive then
            targetTreePos = Camera.CFrame.Position
        elseif LocalPlayer.Character and LocalPlayer.Character.PrimaryPart then
            targetTreePos = LocalPlayer.Character.PrimaryPart.Position
        end
    end)
end

local function ShowTeleports()
    ClearScroll()
    for _, loc in ipairs(savedTeleports) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1,0,0,50)
        btn.BackgroundColor3 = Color3.fromRGB(45,45,50)
        btn.Text = "🚀 " .. loc.Name
        btn.TextColor3 = Color3.new(1,1,1)
        btn.TextScaled = true
        btn.Parent = Scrolling
        btn.MouseButton1Click:Connect(function()
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = CFrame.new(loc.Position + Vector3.new(0,5,0))
            end
        end)
    end
end

local function ShowSettings()
    ClearScroll()
    local TpBtn = Instance.new("TextButton")
    TpBtn.Size = UDim2.new(1,0,0,60)
    TpBtn.BackgroundColor3 = clickTeleportPlayer and Color3.fromRGB(0,170,0) or Color3.fromRGB(170,0,0)
    TpBtn.Text = clickTeleportPlayer and "🟢 Click TP (F Key): ON" or "🔴 Click TP (F Key): OFF"
    TpBtn.TextColor3 = Color3.new(1,1,1)
    TpBtn.TextScaled = true
    TpBtn.Parent = Scrolling
    TpBtn.MouseButton1Click:Connect(function()
        clickTeleportPlayer = not clickTeleportPlayer
        ShowSettings()
    end)

    local CamBtn = Instance.new("TextButton")
    CamBtn.Size = UDim2.new(1,0,0,60)
    CamBtn.BackgroundColor3 = freecamActive and Color3.fromRGB(0,170,0) or Color3.fromRGB(60,60,60)
    CamBtn.Text = freecamActive and "🎥 Freecam: ON" or "🎥 Freecam: OFF"
    CamBtn.TextColor3 = Color3.new(1,1,1)
    CamBtn.TextScaled = true
    CamBtn.Parent = Scrolling
    CamBtn.MouseButton1Click:Connect(function()
        ToggleFreecam()
        ShowSettings()
    end)

    local DebugBtn = Instance.new("TextButton")
    DebugBtn.Size = UDim2.new(1,0,0,60)
    DebugBtn.BackgroundColor3 = debugMode and Color3.fromRGB(0,170,0) or Color3.fromRGB(170,100,0)
    DebugBtn.Text = debugMode and "🐞 Debug Mode: ON" or "🐞 Debug Mode: OFF"
    DebugBtn.TextColor3 = Color3.new(1,1,1)
    DebugBtn.TextScaled = true
    DebugBtn.Parent = Scrolling
    DebugBtn.MouseButton1Click:Connect(function()
        debugMode = not debugMode
        ShowSettings()
        print("Debug Mode: " .. (debugMode and "ENABLED" or "DISABLED"))
    end)
end

-- Connections
FarmTabBtn.MouseButton1Click:Connect(ShowFarm)
TeleportTabBtn.MouseButton1Click:Connect(ShowTeleports)
SettingsTabBtn.MouseButton1Click:Connect(ShowSettings)

ShowFarm()
print("🌲  Helper V6.1 Loaded | Tree Zone 1 + Sell Zone + Position HUD")
