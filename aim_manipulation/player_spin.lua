local player = game.Players.LocalPlayer
local humanoid = player.Character:WaitForChild("Humanoid")

humanoid.AutoRotate = false

local spinTime = 2 -- number of seconds to spin
local spinSpeed = 10 -- degrees per second to spin

for i = 1, spinTime * spinSpeed do
    humanoid.RootPart.CFrame *= CFrame.Angles(0, math.rad(spinSpeed), 0) 
    wait()
end

humanoid.WalkSpeed = 16 -- reset the character's walkspeed
humanoid.AutoRotate = true -- reset automatic rotation
