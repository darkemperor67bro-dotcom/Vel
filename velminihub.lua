-- Vel:_) | MINI MOBILE HUB
-- Teleport + Anti Knockback
-- For your own Roblox experience

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("VelMiniHub")
if old then old:Destroy() end

local enabled = false
local kbPercent = 0.3
local minimized = false

local Areas = {
    {"Start Area", Vector3.new(551.5861,70.8673,-363.4180)},
    {"Jungle", Vector3.new(1188.2562,68.6294,-405.4576)},
    {"Snow", Vector3.new(1492.2930,70.5775,-309.1434)},
    {"Volcano", Vector3.new(1881.9749,71.0376,-409.1512)},
    {"Abyssal Ocean", Vector3.new(2293.2988,69.7399,-324.7036)},
    {"Prehistoric", Vector3.new(2814.6426,69.8019,-397.7296)},
    {"Cosmic", Vector3.new(3404.1248,70.0276,-324.4342)}
}

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "VelMiniHub"
gui.ResetOnSpawn = false
gui.DisplayOrder = 100
gui.Parent = playerGui

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(220, 320)
main.Position = UDim2.new(0.5,-110,0.5,-160)
main.BackgroundColor3 = Color3.fromRGB(23,24,38)
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Parent = gui

Instance.new("UICorner",main).CornerRadius = UDim.new(0,10)

local outline = Instance.new("UIStroke",main)
outline.Color = Color3.fromRGB(120,95,255)
outline.Thickness = 1

-- Header
local header = Instance.new("Frame",main)
header.Size = UDim2.new(1,0,0,32)
header.BackgroundColor3 = Color3.fromRGB(42,38,68)
header.BorderSizePixel = 0
header.Active = true

local title = Instance.new("TextLabel",header)
title.Size = UDim2.new(1,-65,1,0)
title.Position = UDim2.fromOffset(8,0)
title.BackgroundTransparency = 1
title.Text = "Vel:_) | MINI HUB"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 12
title.TextXAlignment = Enum.TextXAlignment.Left

local function button(parent,text,size,pos,color)
    local b = Instance.new("TextButton")
    b.Parent = parent
    b.Size = size
    b.Position = pos
    b.BackgroundColor3 = color or Color3.fromRGB(47,48,72)
    b.Text = text
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamSemibold
    b.TextSize = 11
    b.BorderSizePixel = 0
    Instance.new("UICorner",b).CornerRadius = UDim.new(0,6)
    return b
end

local mini = button(header,"_",UDim2.fromOffset(24,23),
    UDim2.new(1,-54,0,4),Color3.fromRGB(80,72,125))

local close = button(header,"X",UDim2.fromOffset(24,23),
    UDim2.new(1,-27,0,4),Color3.fromRGB(155,50,65))

-- Scroll content
local content = Instance.new("ScrollingFrame",main)
content.Position = UDim2.fromOffset(7,38)
content.Size = UDim2.new(1,-14,1,-44)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ScrollBarThickness = 3
content.AutomaticCanvasSize = Enum.AutomaticSize.Y
content.CanvasSize = UDim2.new(0,0,0,0)

local layout = Instance.new("UIListLayout",content)
layout.Padding = UDim.new(0,5)
layout.SortOrder = Enum.SortOrder.LayoutOrder

local function section(text,order)
    local label = Instance.new("TextLabel",content)
    label.LayoutOrder = order
    label.Size = UDim2.new(1,0,0,20)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(175,155,255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
end

local status = Instance.new("TextLabel",content)
status.LayoutOrder = 1
status.Size = UDim2.new(1,0,0,20)
status.BackgroundTransparency = 1
status.Text = "Ready"
status.TextColor3 = Color3.fromRGB(210,210,225)
status.Font = Enum.Font.Gotham
status.TextSize = 10
status.TextTruncate = Enum.TextTruncate.AtEnd

-- Anti Knockback controls
section("ANTI KNOCKBACK",2)

local toggle = button(content,"ANTI KB: OFF",
    UDim2.new(1,0,0,30),UDim2.new(),
    Color3.fromRGB(150,45,55))
toggle.LayoutOrder = 3

local percent = Instance.new("TextLabel",content)
percent.LayoutOrder = 4
percent.Size = UDim2.new(1,0,0,18)
percent.BackgroundTransparency = 1
percent.TextColor3 = Color3.new(1,1,1)
percent.Font = Enum.Font.Gotham
percent.TextSize = 11
percent.Text = "Knockback: 30%"

local slider = Instance.new("TextButton",content)
slider.LayoutOrder = 5
slider.Size = UDim2.new(1,0,0,20)
slider.BackgroundColor3 = Color3.fromRGB(55,55,75)
slider.Text = "Tap to change percentage"
slider.TextColor3 = Color3.new(1,1,1)
slider.TextSize = 10
Instance.new("UICorner",slider).CornerRadius = UDim.new(0,5)

toggle.Activated:Connect(function()
    enabled = not enabled
    toggle.Text = enabled and "ANTI KB: ON" or "ANTI KB: OFF"
    toggle.BackgroundColor3 = enabled
        and Color3.fromRGB(35,140,70)
        or Color3.fromRGB(150,45,55)
    status.Text = enabled and "Anti KB enabled" or "Anti KB disabled"
end)

-- Tap to cycle percentage in 10% steps
slider.Activated:Connect(function()
    kbPercent = kbPercent + 0.1
    if kbPercent > 1 then kbPercent = 0 end
    percent.Text = "Knockback: "..math.floor(kbPercent*100).."%"
end)

-- Character physics handler
local function setupCharacter(character)
    local root = character:WaitForChild("HumanoidRootPart",5)
    if not root then return end

    local function handle(obj)
        if not enabled then return end

        if obj:IsA("BodyVelocity") then
            obj.Velocity = obj.Velocity * kbPercent
        elseif obj:IsA("LinearVelocity") then
            obj.VectorVelocity = obj.VectorVelocity * kbPercent
        elseif obj:IsA("VectorForce") then
            obj.Force = obj.Force * kbPercent
        end
    end

    for _,obj in ipairs(root:GetChildren()) do
        handle(obj)
    end

    root.ChildAdded:Connect(handle)
end

if player.Character then
    task.spawn(setupCharacter,player.Character)
end
player.CharacterAdded:Connect(setupCharacter)

-- Teleport buttons
section("TELEPORT AREAS",6)

for i,area in ipairs(Areas) do
    local b = button(content,area[1],
        UDim2.new(1,0,0,29),UDim2.new(),
        Color3.fromRGB(43,45,68))
    b.LayoutOrder = 6+i

    b.Activated:Connect(function()
        local character = player.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")

        if not root then
            status.Text = "Character not ready"
            return
        end

        root.CFrame = CFrame.new(area[2])
        status.Text = "Selected: "..area[1]
    end)
end

-- Minimize
mini.Activated:Connect(function()
    minimized = not minimized
    content.Visible = not minimized
    main.Size = minimized
        and UDim2.fromOffset(170,32)
        or UDim2.fromOffset(220,320)
    mini.Text = minimized and "+" or "_"
end)

-- Close
close.Activated:Connect(function()
    gui:Destroy()
end)

-- Drag with touch or mouse
local dragging = false
local dragStart
local startPosition
local activeInput

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPosition = main.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseMovement then
        activeInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input == activeInput then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)