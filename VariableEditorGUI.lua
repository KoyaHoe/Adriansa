local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local localPlayer = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VariableExplorer"
screenGui.ResetOnSpawn = false
screenGui.Parent = localPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 500, 0, 600)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -300)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "Editor de Variables del Juego"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Parent = mainFrame

local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(1, -20, 0, 30)
searchBox.Position = UDim2.new(0, 10, 0, 50)
searchBox.PlaceholderText = "Buscar variable por nombre o valor..."
searchBox.Font = Enum.Font.Gotham
title.TextSize = 14
searchBox.TextColor3 = Color3.new(1, 1, 1)
searchBox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
searchBox.Text = ""
searchBox.Parent = mainFrame
Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 4)

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -20, 1, -90)
scroll.Position = UDim2.new(0, 10, 0, 90)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.ScrollBarThickness = 6
scroll.BackgroundTransparency = 1
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 6)
layout.Parent = scroll

local variableFrames = {}

local function createVariableEditor(name, value, setter)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -4, 0, 36)
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    frame.Parent = scroll
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 4)
    frame.Name = name .. ":" .. tostring(value)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, -10, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Text = name
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextColor3 = Color3.new(1, 1, 1)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0.5, -20, 1, -8)
    box.Position = UDim2.new(0.5, 10, 0, 4)
    box.Text = tostring(value)
    box.Font = Enum.Font.Code
    box.TextSize = 14
    box.TextColor3 = Color3.new(1, 1, 1)
    box.BackgroundColor3 = Color3.fromRGB(70, 70, 80)
    box.Parent = frame
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)

    box.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local newValue = box.Text
            local success, err = pcall(function()
                setter(newValue)
            end)
            if not success then
                warn("[Editor de Variables] Error al asignar valor:", err)
            end
        end
    end)

    table.insert(variableFrames, frame)
end

local function scanAndEditVariables(folder)
    for _, child in pairs(folder:GetChildren()) do
        if child:IsA("NumberValue") or child:IsA("IntValue") or child:IsA("BoolValue") or child:IsA("StringValue") then
            createVariableEditor(child.Name, child.Value, function(newValue)
                if child:IsA("BoolValue") then
                    child.Value = newValue == "true"
                elseif child:IsA("StringValue") then
                    child.Value = newValue
                elseif tonumber(newValue) then
                    child.Value = tonumber(newValue)
                end
            end)
        elseif #child:GetChildren() > 0 then
            scanAndEditVariables(child)
        end
    end
end

local pathsToScan = {
    localPlayer:FindFirstChild("leaderstats"),
    localPlayer:FindFirstChild("PlayerGui"),
    localPlayer:FindFirstChild("Backpack"),
    localPlayer:FindFirstChild("PlayerScripts"),
    ReplicatedStorage:FindFirstChild("Remotes"),
    ReplicatedStorage:FindFirstChild("Modules")
}

for _, path in ipairs(pathsToScan) do
    if path then
        scanAndEditVariables(path)
    end
end

local editableVariables = {
    { name = "WalkSpeed", path = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid"), prop = "WalkSpeed" },
    { name = "JumpPower", path = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid"), prop = "JumpPower" },
    { name = "Gravity", path = Workspace, prop = "Gravity" },
}

for _, var in ipairs(editableVariables) do
    if var.path and var.path[var.prop] then
        createVariableEditor(var.name, var.path[var.prop], function(newValue)
            if tonumber(newValue) then
                var.path[var.prop] = tonumber(newValue)
            end
        end)
    end
end

searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local query = searchBox.Text:lower()
    for _, frame in ipairs(variableFrames) do
        local target = frame.Name:lower()
        frame.Visible = query == "" or target:find(query)
    end
end)

mainFrame.Active = true
mainFrame.Draggable = true

print("[Editor de Variables] GUI cargada.")
