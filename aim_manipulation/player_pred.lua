local predictionValues = {0, 0.1, 0.2, 0.3}

local function calculatePredictedPoint(player, prediction)
    local targetPosition = player.Character.HumanoidRootPart.Position
    local targetVelocity = player.Character.HumanoidRootPart.Velocity
    local predictedPosition = targetPosition + targetVelocity * prediction
    return predictedPosition
end

local function findClosestPlayerToPredictedPoint(predictedPoint, maxDistance)
    local closestPlayer, closestDistance
    for _, player in ipairs(game.Players:GetPlayers()) do
        local distance = (predictedPoint - player.Character.HumanoidRootPart.Position).Magnitude
        if distance < maxDistance then
            if not closestDistance or distance < closestDistance then
                closestPlayer = player
                closestDistance = distance
            end
        end
    end
    return closestPlayer
end


local function aimlockWithPrediction()
    
    local closestPlayers = {}
    for _, prediction in ipairs(predictionValues) do
        local predictedPoint = calculatePredictedPoint(game.Players.LocalPlayer, prediction)
        local closestPlayer = findClosestPlayerToPredictedPoint(predictedPoint, 50)
        if closestPlayer then
            table.insert(closestPlayers, closestPlayer)
        end
    end
    

    local closestPlayer, closestDistance
    for _, player in ipairs(closestPlayers) do
        local distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
        if not closestDistance or distance < closestDistance then
            closestPlayer = player
            closestDistance = distance
        end
    end
    

    if closestPlayer then
        local lookVector = (closestPlayer.Character.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Unit
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.lookAt(game.Players.LocalPlayer.Character.HumanoidRootPart.Position + lookVector * 10, game.Players.LocalPlayer.Character.HumanoidRootPart.Position)
    end
end

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessedEvent)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        aimlockWithPrediction()
    end
end)
