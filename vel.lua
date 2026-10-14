
--[[
    Vel:_) | AREA TELEPORTER
    7 Locations | Draggable | Minimize | Close
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Remove previous GUI
local oldGui = playerGui:FindFirstChild("VelAreaTeleporter")
if oldGui then
    oldGui:Destroy()
end

-- TELEPORT LOCATIONS
local Areas = {
    {
        Name = "Start Area (Back Home)",
        Position = Vector3.new(
            551.5861206054688,
            70.8673324584961,
            -363.41796875
        )
    },
    {
        Name = "Area 1",
        Position = Vector3.new(
            1188.2562255859375,
            68.62942504882812,
            -405.45758056640625
        )
    },
    {
        Name = "Area 2",
        Position = Vector3.new(
            1492.29296875,
            70.5775146484375,
            -309.14337158203125
        )
    },
    {
        Name = "Area 3",
        Position = Vector3.new(
            1881.974853515625,
            71.03762817382812,
            -409.1511535644531
        )
    },
    {
        Name = "Area 4",
        Position = Vector3.new(
            2293.298828125,
            69.73991394042969,
            -324.7036437988281
        )
    },
    {
        Name = "Area 5",
        Position = Vector3.new(
            2814.642578125,
            69.80186462402344,
            -397.7296447753906
        )
    },
    {
        Name = "Area 6",
        Position = Vector3.new(
            3404.124755859375,
            70.02764129638672,
            -324.4342041015625
        )
    }
}

-- CREATE GUI
local gui = Instance.new("ScreenGui")
gui.Name = "VelAreaTeleporter"
gui.ResetOnSpawn = false
gui.DisplayOrder = 100
gui.Parent = playerGui

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(270, 290)
main.Position = UDim2.new(0.5, -110, 0.5, -145)
main.BackgroundColor3 = Color3.fromRGB(23, 24, 37)
main.BorderSizePixel = 0
main.Active = true
main.ClipsDescendants = true
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = main

local outline = Instance.new("UIStroke")
outline.Color = Color3.fromRGB(105, 105, 255)
outline.Thickness = 1.5
outline.Parent = main

-- HEADER
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 36)
header.BackgroundColor3 = Color3.fromRGB(38, 39, 59)
header.BorderSizePixel = 0
header.Active = true
header.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -105, 1, 0)
title.Position = UDim2.fromOffset(12, 0)
title.BackgroundTransparency = 1
title.Text = "Vel:_) | TELEPORT"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 14
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local function createButton(parent, text, size, position, color)
    local button = Instance.new("TextButton")
    button.Size = size
    button.Position = position
    button.BackgroundColor3 = color or Color3.fromRGB(48, 51, 78)
    button.Text = text
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextSize = 12
    button.Font = Enum.Font.GothamSemibold
    button.BorderSizePixel = 0
    button.AutoButtonColor = true
    button.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 7)
    corner.Parent = button

    return button
end

local minimizeButton = createButton(
    header, "_",
    UDim2.fromOffset(28, 27),
    UDim2.new(1, -65, 0, 8),
    Color3.fromRGB(75, 78, 115)
)

local closeButton = createButton(
    header, "X",
    UDim2.fromOffset(28, 27),
    UDim2.new(1, -32, 0, 8),
    Color3.fromRGB(175, 55, 65)
)

-- BUTTON LIST
local list = Instance.new("ScrollingFrame")
list.Name = "AreaList"
list.Position = UDim2.fromOffset(10, 51)
list.Size = UDim2.new(1, -20, 1, -91)
list.BackgroundTransparency = 1
list.BorderSizePixel = 0
list.ScrollBarThickness = 4
list.ScrollBarImageColor3 = Color3.fromRGB(110, 115, 255)
list.AutomaticCanvasSize = Enum.AutomaticSize.Y
list.CanvasSize = UDim2.new(0, 0, 0, 0)
list.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 7)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = list

local status = Instance.new("TextLabel")
status.Name = "Status"
status.Position = UDim2.new(1, -4, 0, 36)
status.Size = UDim2.new(1, -4, 0, 30)
status.BackgroundTransparency = 1
status.Text = "Ready | Select an area"
status.TextColor3 = Color3.fromRGB(180, 185, 210)
status.Font = Enum.Font.Gotham
status.TextSize = 11
status.TextTruncate = Enum.TextTruncate.AtEnd
status.Parent = main

-- TELEPORT BUTTONS
for index, area in ipairs(Areas) do
    local button = createButton(
        list,
        area.Name,
        UDim2.new(1, -4, 0, 36),
        UDim2.new(),
        Color3.fromRGB(43, 46, 70)
    )

    button.LayoutOrder = index

    button.Activated:Connect(function()
        local character = player.Character
        local root = character
            and character:FindFirstChild("HumanoidRootPart")

        if not root then
            status.Text = "Character not ready"
            return
        end

        -- Client-side teleport attempt
        root.CFrame = CFrame.new(area.Position)
        status.Text = "Selected: " .. area.Name
    end)
end

-- MINIMIZE / RESTORE
local minimized = false

minimizeButton.Activated:Connect(function()
    minimized = not minimized

    list.Visible = not minimized
    status.Visible = not minimized

    main.Size = minimized
        and UDim2.fromOffset(220, 36)
        or UDim2.fromOffset(220, 290)

    minimizeButton.Text = minimized and "+" or "_"
end)

-- CLOSE
closeButton.Activated:Connect(function()
    gui:Destroy()
end)

-- DRAG WITH MOUSE OR TOUCH
local dragging = false
local dragStart
local startPosition
local activeInput

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

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
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        activeInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
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
