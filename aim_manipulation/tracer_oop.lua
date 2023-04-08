local client = game.Players.LocalPlayer
local camera = game:GetService('Workspace').CurrentCamera
local players = game:GetService('Players')

local esp_cache = ({})

local function Draw(obj, props)
    local obj_drawing = Drawing.new(obj)

    for i,v in pairs(props) do
        obj_drawing[i] = v
    end

    return obj_drawing
end

function draw_tracer(obj, state)
    local drawings = {}
    drawings.__index = drawings
    
    drawings.Tracer = Draw('Line', {Transparency = 1, Color = Color3.new(193,202,222), Thickness = 1, Visible = false})
    drawings.Text = Draw('Text', {Transparency = 1, Color = Color3.new(0,0,0), Visible = false, Center = true, Outline = true, Font = 2, Size = 12})
    drawings.Text2 = Draw('Text', {Transparency = 1, Color = Color3.new(0,0,0), Visible = false, Center = true, Outline = true, Font = 2, Size = 14})
    local State = state 
    
    local Tracer_Connection
    Tracer_Connection = game:GetService('RunService').RenderStepped:Connect(function()
        if (obj.Character and obj.Character:WaitForChild('HumanoidRootPart') and obj.Character:WaitForChild('Humanoid')) then
            if (obj.Character.Humanoid.Health > 0) then


                local posmag = (client.Character.HumanoidRootPart.Position - obj.Character.HumanoidRootPart.Position).magnitude
                local pos, onscreen = camera:worldToViewportPoint(obj.Character.HumanoidRootPart.Position)
                
                drawings.Text.Position = Vector2.new(pos.X, pos.Y)
                drawings.Text.Text = '[ Name : ' .. obj.Name .. ' ]'
                
                drawings.Tracer.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
                drawings.Tracer.To = Vector2.new(pos.X, pos.Y)
                    
                if onscreen then
                    
                    drawings.Text.Visible = state
                    drawings.Tracer.Visible = state
                else
                    drawings.Text.Visible = false
                    drawings.Tracer.Visible = false
                end
                else
                drawings.Text.Visible = false
                drawings.Tracer.Visible = false
            end
        end
    end)
    
    local tracer_proxy = {}
    
    function tracer_proxy:state(bool)
        State = bool
    end
    
    function tracer_proxy:remove()
        for i,v in pairs(drawings) do
            v:Remove()
        end
        
        if Tracer_Connection then
            Tracer_Connection:Disconnect()
        end
    end
    
    return tracer_proxy
end

for i,v in pairs(players:GetPlayers()) do
    if v ~= client then
        esp_cache[v.Name] = draw_tracer(v, true)
    end
end

game:GetService('Players').PlayerAdded:Connect(function(Player)
    if Player ~= client then
        if not esp_cache[v.Name] then
            esp_cache[v.Name] = draw_tracer(v, true)
        end
    end
end)

game:GetService('Players').PlayerRemoving:Connect(function(Player)
    if table.find(esp_cache, v.Name) then
        esp_cache[v.Name]:remove()
    end
end)
