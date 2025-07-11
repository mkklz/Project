local EspFruit = {}
EspFruit.__index = EspFruit

function EspFruit.new()
    local self = setmetatable({}, EspFruit)
    self.fruitFound = false
    self.notificationSent = false
    return self
end

function EspFruit:searchFruit()
    local workspace = game:GetService("Workspace")
    local fruitModel = workspace:FindFirstChild("Fruit")
    
    if fruitModel and not self.notificationSent then
        self:sendNotification()
        self.fruitFound = true
        self.notificationSent = true
    end
    
    return self
end

function EspFruit:sendNotification()
    local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nebula-Softworks/Luna-Interface-Suite/refs/heads/master/source.lua", true))()
    
    Luna:Notification({
        Title = "Fruit Spawned",
        Icon = "casino",
        ImageSource = "Material",
        Content = "Uma fruta aleatória foi localizada. Use a toggle 'Esp Fruit' para ativar o farm!",
        Duration = 3
    })
    
    return self
end

function EspFruit:initialize()
    self:searchFruit()
    return self
end

return EspFruit.new():initialize()
