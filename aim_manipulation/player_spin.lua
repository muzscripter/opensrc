
local player = game.Players.LocalPlayer
local humanoid = player.Character:WaitForChild("Humanoid")

local spinTime = 2 -- number of seconds to spin
local spinSpeed = 180 -- degrees per second to spin

local startTime = tick()

while tick() < startTime + spinTime do
    local delta = math.clamp((tick() - startTime) / spinTime, 0, 1) 
    humanoid.RootPart.CFrame = humanoid.RootPart.CFrame * CFrame.Angles(0, math.rad(spinSpeed * delta), 0) 
    wait()
end

humanoid.WalkSpeed = 16 -- reset the character's walkspeed
