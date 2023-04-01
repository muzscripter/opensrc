local toggleKey = Enum.KeyCode.R


local highlightSize = Vector3.new(2, 2, 2)
local highlightTransparency = 0.5
local highlightColor = Color3.new(0, 1, 0)

local maxDistance = 500

local fovTheta = math.rad(45)


local function highlightPart(part)

    local highlight = Drawing.new("Sphere")
    highlight.Position = part.Position
    highlight.Radius = 4
    highlight.Filled = false
    highlight.NumSides = 25
    highlight.Color = highlightColor
    highlight.Transparency = highlightTransparency
    highlight.Thickness = 1
    highlight.Visible = true
    
    local shakePower = 0
    
    spawn(function()
        while highlight.Visible do 
          wait()
          
          local newOffset = Vector2.new(math.random(-shakePower, shakePower), math.random(-shakePower, shakePower))
          highlight.Position = Vector2.new(part.Position.X, part.Position.Y) + newOffset
          shakePower = shakePower + 1
        end
    end)
    
    return highlight
end


local function removeHighlight(highlight)

    highlight:Remove()
end


local function aimAtTarget(player)
    local targetPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not targetPart then return end
    
    local targetCFrame = targetPart.CFrame
    local camCFrame = Workspace.CurrentCamera.CFrame
    
  
    local randomOffset = CFrame.fromEulerAnglesXYZ(math.rad(math.random(-50,50)), math.rad(math.random(-50,50)), 0)
    targetCFrame = targetCFrame:ToWorldSpace(randomOffset)
    

    local distance = (camCFrame.p - targetCFrame.p).Magnitude
    local newCamCFrame = CFrame.new(camCFrame.p, targetCFrame.p)
    

    newCamCFrame = newCamCFrame:Lerp(camCFrame, 0.1) -- you can adjust the lerping factor
    
    -- apply more shaking the closer the camera is to the player
    local shake = math.max(0, math.min(15, (500 - distance) / 25))
    newCamCFrame = newCamCFrame * CFrame.fromEulerAnglesXYZ(math.rad(math.random(-shake, shake)), math.rad(math.random(-shake, shake)), 0)
    
    Workspace.CurrentCamera.CFrame = newCamCFrame
    
    return targetPart
end

-- Define a function to check if the target player is within the FOV.
local function isTargetInFOV(player)
    local lookVector = (player.Character.HumanoidRootPart.Position - Workspace.CurrentCamera.CFrame.p).Unit
    local cameraLookVector = Workspace.CurrentCamera.CFrame.LookVector
    return angleDifference(lookVector, cameraLookVector) < fovTheta / 2
end

-- Define the active flag and target player.
local isActive = false
local targetPlayer = nil

-- Connect the aimlock function to a UserInputService event.
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessedEvent)
    if input.KeyCode == toggleKey then
        -- Toggle the aimlock.
        isActive = not isActive

        -- Remove the highlight from the previous target player, if any.
        if targetPlayer then
            removeHighlight(targetPlayer.Highlight)
            targetPlayer = nil
        end
    end
end)

while true do
   
    if isActive then
        
        local closestPlayer, closestDistance
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player.Character then
                local distance = (player.Character.HumanoidRootPart.Position - Workspace.CurrentCamera.CFrame.p).Magnitude
                if distance < maxDistance and isTargetInFOV(player) then
                    if not closestDistance or distance < closestDistance then
                        closestPlayer = player
                        closestDistance = distance
                    end
                end
            end
        end
 
      
        if closestPlayer then 
            targetPlayer = {}
            targetPlayer.Player = closestPlayer
            targetPlayer.Highlight = highlightPart(targetPlayer.Player.Character.HumanoidRootPart)
            
            aimAtTarget(targetPlayer.Player)
        end
    else
        
        if targetPlayer then
            removeHighlight(targetPlayer.Highlight)
            targetPlayer = nil
        end
    end

    wait()
end
