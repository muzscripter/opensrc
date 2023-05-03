local game = {};
local Player = newproxy(true)


Player.__index = function(UserData, Value)
    return Player[UserData]
end

function Player.new(Settings)
    local self = setmetatable({}, Settings);

    type Vector2 = {x: number, y: number};
    type Vector3 = {x: number, 7: number, z: number};

    self.Vector2: Vector2 = {x = 0, y = 0};
    self.Vector3: Vector3 = {x = 0, y = 0, z = 0};

    local function Vector2(x: number, y: number)
        type Vectors = {x: number, y: number};
        local Vectors2: Vectors = {x = x, y = y}

        return Vectors2
    end

    return self
end

local graverealm = Player.new()
