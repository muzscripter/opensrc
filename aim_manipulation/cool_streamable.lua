local toggleKey = Enum.KeyCode.R
local maxDistance = 500

local highlightSize = Vector3.new(2, 2, 2)
local highlightTransparency = 0.5
local highlightColor = Color3.new(0, 1, 0)


local fovTheta = math.rad(45)


local function findClosestPlayerToMouse()
  
    local mousePosition = game:GetService("UserInputService"):GetMouseLocation()


    local ray = Workspace.CurrentCamera:ScreenPointToRay(mousePosition.X, mousePosition.Y)
    local targetPosition =
        ray.Origin +
        ray.Direction * ((Workspace.CurrentCamera.CFrame.p - ray.Origin).Magnitude / ray.Direction.Magnitude)

  
    local closestPlayer, closestDistance
    for _, player in ipairs(game.Players:GetPlayers()) do
        local distance = (targetPosition - player.Character.HumanoidRootPart.Position).Magnitude
        if distance < maxDistance then
            if not closestDistance or distance < closestDistance then
                closestPlayer = player
                closestDistance = distance
            end
        end
    end
    return closestPlayer
end

local function highlightTargetPlayer(player)
    local part = Instance.new("Part")
    part.Size = highlightSize
    part.Transparency = highlightTransparency
    part.Color = highlightColor
    part.Anchored = true
    part.CanCollide = false
    part.TopSurface = Enum.SurfaceType.Smooth
    part.BottomSurface = Enum.SurfaceType.Smooth
    part.Parent = player.Character.HumanoidRootPart


    local attachment = Instance.new("Attachment")
    attachment.Parent = part

 
    local trail = Instance.new("Trail")
    trail.Name = "HighlightTrail"
    trail.Attachment0 = player.Character.HumanoidRootPart.Attachment
    trail.Attachment1 = attachment
    trail.Lifetime = 0.25
    trail.Color = highlightColor
    trail.Transparency =
        NumberSequence.new(
        {
            NumberSequenceKeypoint.new(0, highlightTransparency),
            NumberSequenceKeypoint.new(1, 1)
        }
    )
    trail.Parent = part
end


local function removeTargetHighlight(player)
  
    local trail = player.Character.HumanoidRootPart:FindFirstChild("HighlightTrail")
    if trail then
       
        trail:Destroy()
        trail.Parent:Destroy()
    end
end


local function aimlockOnTargetPlayer(player)

    local lookVector = (player.Character.HumanoidRootPart.Position - Workspace.CurrentCamera.CFrame.p).Unit
    local orientation = CFrame.new(Workspace.CurrentCamera.CFrame.p, player.Character.HumanoidRootPart.Position)

   
    Workspace.CurrentCamera.CFrame = orientation
    Workspace.CurrentCamera.Focus = CFrame.new(player.Character.HumanoidRootPart.Position)
    Workspace.CurrentCamera.Focus = Workspace.CurrentCamera.Focus - lookVector * 10
end

local function angleDifference(vectorA, vectorB)
    local dot = vectorA:Dot(vectorB)
    return math.acos(dot)
end


local function isTargetInFOV(player)
    local lookVector = (player.Character.HumanoidRootPart.Position - Workspace.CurrentCamera.CFrame.p).Unit
    local cameraLookVector = Workspace.CurrentCamera.CFrame.LookVector
    return angleDifference(lookVector, cameraLookVector) < fovTheta / 2
end


local isActive = false
local targetPlayer = nil


game:GetService("UserInputService").InputBegan:Connect(
    function(input, gameProcessedEvent)
        if input.KeyCode == toggleKey then

            isActive = not isActive

            if targetPlayer then
                removeTargetHighlight(targetPlayer)
                targetPlayer = nil
            end
        end
    end
)

while true do
   
    if isActive then
        targetPlayer = findClosestPlayerToMouse()

        if targetPlayer then
            aimlockOnTargetPlayer(targetPlayer)
            highlightTargetPlayer(targetPlayer)
        end
    else
    
        if targetPlayer then
            removeTargetHighlight(targetPlayer)
            targetPlayer = nil
        end
    end

    -- Spin the FOV circle based on the camera angle.
    local cameraAngle =
        math.atan2(Workspace.CurrentCamera.CFrame.LookVector.Z, Workspace.CurrentCamera.CFrame.LookVector.X)
    local circleAngle = cameraAngle + fovTheta / 2
    local circlePosition =
        Workspace.CurrentCamera.CFrame.p + Vector3.new(math.cos(circleAngle), 0, math.sin(circleAngle)) * maxDistance
    local circleNormal = (Workspace.CurrentCamera.CFrame.p - circlePosition).Unit
    local circleOrientation = CFrame.new(circlePosition, circlePosition + circleNormal)
    local detectedParts =
        Workspace:FindPartsInRegion3WithIgnoreList(
        Region3.new(
            circlePosition - Vector3.new(maxDistance, maxDistance, maxDistance),
            circlePosition + Vector3.new(maxDistance, maxDistance, maxDistance)
        ),
        {},
        {Workspace.CurrentCamera}
    )
    local detectedPlayers = {}
    for _, part in ipairs(detectedParts) do
        local humanoid = part.Parent:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.Parent ~= game.Players.LocalPlayer.Character and isTargetInFOV(humanoid.Parent) then
            table.insert(detectedPlayers, humanoid.Parent)
        end
    end
    local circle = Instance.new("Part")
    circle.Name = "FOVCircle"
    circle.Shape = Enum.PartType.Cylinder
    circle.Size = Vector3.new(maxDistance, 0.1, maxDistance)
    circle.Anchored = true
    circle.CanCollide = false
    circle.TopSurface = Enum.SurfaceType.Smooth
    circle.BottomSurface = Enum.SurfaceType.Smooth
    circle.Material = Enum.Material.Neon
    circle.Color = Color3.new(1, 1, 1)
    circle.Transparency = 0.75
    circle.Orientation = Vector3.new(90, 0, 0)
    circle.CFrame = circleOrientation
    for _, player in ipairs(detectedPlayers) do
        local highlight = Instance.new("SelectionBox")
        highlight.Name = "FOVHighlight"
        highlight.Adornee = player.Character
        highlight.Color3 = Color3.new(0, 1, 0)
        highlight.LineThickness = 0.1
        highlight.Parent = circle
    end
  
    circle.Parent = Workspace.CurrentCamera

    for _, obj in ipairs(circle:GetChildren()) do
        if obj:IsA("SelectionBox") and obj.Adornee then
            if not table.find(detectedPlayers, obj.Adornee) then
                obj:Destroy()
            end
        end
    end

    wait()
end
