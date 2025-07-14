local plrs = game:GetService("Players")
local rs = game:GetService("RunService")
local ws = game:GetService("Workspace")
local cam = workspace.CurrentCamera
local lp = plrs.LocalPlayer

local esp = {
    obj = {},
    con = {}
}

function esp:draw(tp, props)
    local d = Drawing.new(tp)
    for k, v in pairs(props) do d[k] = v end
    return d
end

function esp:rainbow(t)
    return Color3.new(
        math.sin(t * 2) * 0.5 + 0.5,
        math.sin(t * 2 + 2) * 0.5 + 0.5,
        math.sin(t * 2 + 4) * 0.5 + 0.5
    )
end

function esp:create()
    return {
        line = self:draw("Line", {Visible = false, Thickness = 2, Transparency = 0.8}),
        text = self:draw("Text", {Visible = false, Center = true, Outline = true, Size = 16, Font = 2})
    }
end

function esp:hide(data)
    data.line.Visible = false
    data.text.Visible = false
    return self
end

function esp:clean(tool)
    if self.obj[tool] then
        for _, v in pairs(self.obj[tool]) do v:Remove() end
        self.obj[tool] = nil
    end
    return self
end

function esp:getHRP()
    local char = lp.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

function esp:getToolPart(tool)
    for _, part in pairs(tool:GetChildren()) do
        if part:IsA("BasePart") then
            return part
        end
    end
    return nil
end

function esp:getTools()
    local tools = {}
    for _, child in pairs(ws:GetChildren()) do
        if child:IsA("Tool") then
            table.insert(tools, child)
        end
    end
    return tools
end

function esp:render()
    local now = tick()
    local hrp = self:getHRP()
    if not hrp then return self end
    
    local hrpScreen, hrpVis = cam:WorldToViewportPoint(hrp.Position)
    if not hrpVis then return self end
    
    local hrpPoint = Vector2.new(hrpScreen.X, hrpScreen.Y)
    local tools = self:getTools()
    
    for tool in pairs(self.obj) do
        local found = false
        for _, t in pairs(tools) do
            if t == tool then found = true break end
        end
        if not found then self:clean(tool) end
    end
    
    for _, tool in pairs(tools) do
        local part = self:getToolPart(tool)
        if part then
            local success, toolScreen, toolVis = pcall(function()
                return cam:WorldToViewportPoint(part.Position)
            end)
            
            if success and toolVis then
                local data = self.obj[tool] or self:create()
                self.obj[tool] = data
                
                local color = self:rainbow(now)
                local toolPoint = Vector2.new(toolScreen.X, toolScreen.Y)
                
                data.line.Visible = true
                data.line.From = hrpPoint
                data.line.To = toolPoint
                data.line.Color = color
                
                data.text.Visible = true
                data.text.Text = tool.Name
                data.text.Position = Vector2.new(toolScreen.X, toolScreen.Y - 20)
                data.text.Color = color
            else
                if self.obj[tool] then self:hide(self.obj[tool]) end
            end
        else
            if self.obj[tool] then self:hide(self.obj[tool]) end
        end
    end
    
    return self
end

function esp:connect()
    self.con.render = rs.RenderStepped:Connect(function() self:render() end)
    self.con.remove = ws.DescendantRemoving:Connect(function(desc)
        if desc:IsA("Tool") then self:clean(desc) end
    end)
    return self
end

function esp:disconnect()
    for _, con in pairs(self.con) do con:Disconnect() end
    for tool in pairs(self.obj) do self:clean(tool) end
    return self
end

function esp:init()
    return self:connect()
end

getgenv().ToolESP = esp:init()
