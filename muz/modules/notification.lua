print([[DIVIDER =======================================]])

if not game:GetService('CoreGui'):FindFirstChild('NotiCache') then
    local Folder = Instance.new('Folder', game:GetService('CoreGui'))
    Folder.Name = 'NotiCache'
end

for i,v in pairs(game:GetService('CoreGui').NotiCache:GetChildren()) do
    if v:IsA("ScreenGui") then
        v:Destroy()
    end
end

local TweenService = game:GetService("TweenService")

local Notify = {}
Notify.__index = Notify

Notify.Positions = {}

function Notify.new(Settings)
    local self = setmetatable({}, Notify)
    
    self.gui = Instance.new("ScreenGui")
    self.gui.Name = "Notification"
    self.gui.Parent = game:GetService('CoreGui').NotiCache

    self.frame = Instance.new("Frame")
    self.frame.BackgroundColor3 = Color3.new(0.552941, 0.701960, 1)
    self.frame.BackgroundTransparency = 0.15000000596046448
    self.frame.Position = UDim2.new(1, -260, 0.0200031605, 0)
    self.frame.Size = UDim2.new(0, 252, 0, 60)
    self.frame.Visible = true
    self.frame.Parent = self.gui

    self.uicorner = Instance.new("UICorner")
    self.uicorner.Parent = self.frame

    self.imageLabel = Instance.new("ImageLabel")
    self.imageLabel.Image = Settings.Image or "rbxassetid://1316045217"
    self.imageLabel.BackgroundColor3 = Color3.new(1, 1, 1)
    self.imageLabel.Position = UDim2.new(0.0558268577, 0, 0.200000003, 0)
    self.imageLabel.Size = UDim2.new(0, 35, 0, 35)
    self.imageLabel.Visible = true
    self.imageLabel.Parent = self.frame

    self.uicorner_2 = Instance.new("UICorner")
    self.uicorner_2.CornerRadius = UDim.new(1, 0)
    self.uicorner_2.Parent = self.imageLabel

    self.name = Instance.new("TextLabel")
    self.name.Font = Enum.Font.SourceSansBold
    self.name.Text = Settings.Title or 'Xolium'
    self.name.TextColor3 = Color3.new(1, 1, 1)
    self.name.TextScaled = true
    self.name.TextSize = 14
    self.name.TextWrapped = true
    self.name.TextXAlignment = Enum.TextXAlignment.Left
    self.name.BackgroundColor3 = Color3.new(1, 1, 1)
    self.name.BackgroundTransparency = 1
    self.name.Position = UDim2.new(0.238282233, 0, 0.200000003, 0)
    self.name.Size = UDim2.new(0, 130, 0, 15)
    self.name.Visible = true
    self.name.Name = "Name"
    self.name.Parent = self.frame

    self.shadowHolder = Instance.new("Frame")
    self.shadowHolder.BackgroundTransparency = 1
    self.shadowHolder.Size = UDim2.new(1, 0, 1, 0)
    self.shadowHolder.Visible = true
    self.shadowHolder.ZIndex = 0
    self.shadowHolder.Name = "shadowHolder"
    self.shadowHolder.Parent = self.frame

    self.ambientShadow = Instance.new("ImageLabel")
    self.ambientShadow.Image = "rbxassetid://1316045217"
    self.ambientShadow.ImageColor3 = Color3.new(0, 0, 0)
    self.ambientShadow.ImageTransparency = 0.8799999952316284
    self.ambientShadow.ScaleType = Enum.ScaleType.Slice
    self.ambientShadow.SliceCenter = Rect.new(10, 10, 118, 118)
    self.ambientShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    self.ambientShadow.BackgroundTransparency = 1
    self.ambientShadow.Position = UDim2.new(0.5, 0, 0.5, 6)
    self.ambientShadow.Size = UDim2.new(1, 10, 1, 10)
    self.ambientShadow.Visible = true
    self.ambientShadow.ZIndex = 0
    self.ambientShadow.Name = "ambientShadow"
    self.ambientShadow.Parent = self.shadowHolder

    self.message = Instance.new("TextLabel")
    self.message.Font = Enum.Font.SourceSans
    self.message.Text = Settings.Message or 'This notification had no message.'
    self.message.TextColor3 = Color3.new(1, 1, 1)
    self.message.TextScaled = true
    self.message.TextSize = 14
    self.message.TextWrapped = true
    self.message.TextXAlignment = Enum.TextXAlignment.Left
    self.message.BackgroundColor3 = Color3.new(1, 1, 1)
    self.message.BackgroundTransparency = 1
    self.message.Position = UDim2.new(0.238282233, 0, 0.533333361, 0)
    self.message.Size = UDim2.new(0, 130, 0, 15)
    self.message.Visible = true
    self.message.Name = "Message"
    self.message.Parent = self.frame

    local notificationCount = #Notify.Positions
    local offsetY = 70 * notificationCount
    self.frame.Position = UDim2.new(1, -260, 0.0200031605, offsetY)
    
    return self
end

function Notify:Send()
    table.insert(Notify.Positions, self)

    local Info = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local TweenIn = TweenService:Create(self.frame, Info, {Position = UDim2.new(1, -260, 0.0252631605, 0)})
    TweenIn:Play()

    local Duration = self.Duration or 3

    wait(Duration)

    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local TweenOut = TweenService:Create(self.frame, tweenInfo, {BackgroundTransparency = 1})
    local TweenOut2 = TweenService:Create(self.frame, Info, {Position = UDim2.new(1, -260, -0.0252631605, 0)})
    TweenOut:Play()
    TweenOut2:Play()
    TweenOut.Completed:Connect(function()
        self.gui.Enabled = false
    end)

    table.remove(Notify.Positions, table.find(Notify.Positions, self))
end
