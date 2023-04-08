local Notification = {}
Notification.__index = Notification

function Notification.new(title, text, icon, duration)
    local self = setmetatable({}, Notification)
    self.Title = title
    self.Text = text
    self.Icon = icon
    self.Duration = duration or 5
    return self
end

function Notification:Show()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = self.Title,
        Text = self.Text,
        Icon = self.Icon,
        Duration = self.Duration
    })
end

local NotificationManager = {}
NotificationManager.__index = NotificationManager

function NotificationManager.new()
    local self = setmetatable({}, NotificationManager)
    self.Notifications = {}
    return self
end

function NotificationManager:AddNotification(notification)
    table.insert(self.Notifications, notification)
end

function NotificationManager:ShowNotifications()
    for _, notification in pairs(self.Notifications) do
        notification:Show()
    end
end

return Notification, NotificationManager
