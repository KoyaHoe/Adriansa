local Players = game:GetService("Players")
local player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ModernActionGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 500, 0, 350)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = mainFrame

local shadow = Instance.new("Frame")
shadow.Size = UDim2.new(1, 20, 1, 20)
shadow.Position = UDim2.new(0, -10, 0, -10)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.5
shadow.BorderSizePixel = 0
shadow.ZIndex = 0
shadow.Parent = mainFrame

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0, 300, 0, 40)
titleLabel.Position = UDim2.new(0, 50, 0, 0)
titleLabel.Text = "AdriansaGUI"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 24
titleLabel.Font = Enum.Font.GothamBold
titleLabel.BackgroundTransparency = 1
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local logoImage = Instance.new("ImageLabel")
logoImage.Size = UDim2.new(0, 40, 0, 40)
logoImage.Position = UDim2.new(0, 10, 0, 0)
logoImage.Image = "http://www.robloxs.com/asset/?id=10597893525"
logoImage.BackgroundTransparency = 1
logoImage.Parent = titleBar

local resetButton = Instance.new("TextButton")
resetButton.Size = UDim2.new(0, 200, 0, 50)
resetButton.Position = UDim2.new(0, 50, 0, 90)
resetButton.Text = "Reiniciar"
resetButton.BackgroundColor3 = Color3.fromRGB(255, 65, 65)
resetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
resetButton.Font = Enum.Font.GothamBold
resetButton.TextSize = 24
resetButton.Parent = mainFrame

local resetButtonCorner = Instance.new("UICorner")
resetButtonCorner.CornerRadius = UDim.new(0, 12)
resetButtonCorner.Parent = resetButton

local teleportButton = Instance.new("TextButton")
teleportButton.Size = UDim2.new(0, 200, 0, 50)
teleportButton.Position = UDim2.new(0, 50, 0, 160)
teleportButton.Text = "Teletransportar"
teleportButton.BackgroundColor3 = Color3.fromRGB(85, 170, 255)
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.Font = Enum.Font.GothamBold
teleportButton.TextSize = 24
teleportButton.Parent = mainFrame

local teleportButtonCorner = Instance.new("UICorner")
teleportButtonCorner.CornerRadius = UDim.new(0, 12)
teleportButtonCorner.Parent = teleportButton

local function resetCharacter()
	for i = 1, 4 do
		if player.Character and player.Character:FindFirstChild("Humanoid") then
			player.Character:BreakJoints()
		end
		wait(2.5)
	end
end

local function teleportCharacter()
	local character = player.Character or player.CharacterAdded:Wait()
	local rootPart = character:WaitForChild("HumanoidRootPart")
	rootPart.CFrame = CFrame.new(6.9, 34.1, 251.4)
	local targetPlayer = Players:FindFirstChild("ByAdriansa")
	if targetPlayer and targetPlayer.Character then
		targetPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(0.1, 34.2, 239.5)
	end
end

resetButton.MouseButton1Click:Connect(resetCharacter)
teleportButton.MouseButton1Click:Connect(teleportCharacter)

local notification = Instance.new("TextLabel")
notification.Size = UDim2.new(0, 400, 0, 50)
notification.Position = UDim2.new(0, 10, 0, 320)
notification.Text = "Haga clic en 'Ctrl' para volver a enseñar."
notification.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
notification.BackgroundTransparency = 0.7
notification.TextColor3 = Color3.fromRGB(255, 255, 255)
notification.Font = Enum.Font.GothamBold
notification.TextSize = 20
notification.Visible = false
notification.Parent = screenGui

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and (input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl) then
		if notification.Visible then
			mainFrame.Visible = true
			notification.Visible = false
		end
	end
end)

local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 40, 0, 40)
minimizeButton.Position = UDim2.new(1, -100, 0, 0)
minimizeButton.Text = "_"
minimizeButton.BackgroundTransparency = 1
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.TextSize = 24
minimizeButton.Parent = titleBar

minimizeButton.MouseEnter:Connect(function()
	minimizeButton.BackgroundTransparency = 0
	minimizeButton.BackgroundColor3 = Color3.fromRGB(255, 255, 100)
end)
minimizeButton.MouseLeave:Connect(function()
	minimizeButton.BackgroundTransparency = 1
end)

minimizeButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
	notification.Visible = true
end)

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -50, 0, 0)
closeButton.Text = "X"
closeButton.BackgroundTransparency = 1
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 24
closeButton.Parent = titleBar

closeButton.MouseEnter:Connect(function()
	closeButton.BackgroundTransparency = 0
	closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
end)
closeButton.MouseLeave:Connect(function()
	closeButton.BackgroundTransparency = 1
end)
closeButton.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)

local dragging = false
local dragStart, startPos

titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
	end
end)

titleBar.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

titleBar.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)
