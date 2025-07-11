local EspFruit = {}
EspFruit.__index = EspFruit

function EspFruit.new()
    local self = setmetatable({}, EspFruit)
    self.isActive = false
    self.notificationSent = false
    self.fruitModel = nil
    return self
end

function EspFruit:findFruit()
    for _, child in pairs(game.Workspace:GetChildren()) do
        if child.Name == "Fruit" and child:IsA("Model") then
            self.fruitModel = child
            return self
        end
    end
    return self
end

function EspFruit:sendNotification()
    if not self.notificationSent then
        local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nebula-Softworks/Luna-Interface-Suite/refs/heads/master/source.lua", true))()
        Luna:Notification({
            Title = "Fruit Spawned",
            Icon = "radar",
            ImageSource = "Material",
            Content = "Uma fruta aleatória foi localizada. Use a toggle \"Esp Fruit\" para ativar o farm!"
        })
        self.notificationSent = true
    end
    return self
end

function EspFruit:checkFruit()
    self:findFruit()
    if self.fruitModel then
        self:sendNotification()
    end
    return self
end

function EspFruit:enable()
    self.isActive = true
    return self
end

function EspFruit:disable()
    self.isActive = false
    return self
end

function EspFruit:initialize()
    self:checkFruit()
    return self
end

return EspFruit.new():initialize()
