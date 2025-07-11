local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nebula-Softworks/Luna-Interface-Suite/refs/heads/master/source.lua", true))()

local EspFruit = {}
EspFruit.__index = EspFruit

function EspFruit.new()
    local self = setmetatable({}, EspFruit)
    self.notificationSent = false
    self.connection = nil
    return self
end

function EspFruit:sendNotification()
    if not self.notificationSent then
        Luna:Notification({
            Title = "Fruit Spawned",
            Icon = "agriculture",
            ImageSource = "Material",
            Content = "Uma fruta aleatória foi localizada. Use a toggle 'Esp Fruit' para ativar o farm!"
        })
        self.notificationSent = true
    end
    return self
end

function EspFruit:checkForFruit()
    for _, child in pairs(workspace:GetChildren()) do
        if child.Name == "Fruit" and child:IsA("Model") then
            self:sendNotification()
            break
        end
    end
    return self
end

function EspFruit:startWatching()
    self.connection = workspace.ChildAdded:Connect(function(child)
        if child.Name == "Fruit" and child:IsA("Model") then
            self:sendNotification()
        end
    end)
    return self
end

function EspFruit:initialize()
    return self:checkForFruit():startWatching()
end

return EspFruit.new():initialize()
