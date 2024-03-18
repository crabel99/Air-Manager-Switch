-- Do not copy this line if copying this file directly into logic.lua
local Switch = require "Switch"

--- Adds additional actions to Switch class to simulate a Bendix Switch
---@class MagnetoSwitch : Switch
local MagnetoSwitch = Switch:new ()

function MagnetoSwitch:callback (position)
    Switch.callback (self, position)

    if self.position == 3 then
        xpl_command ('sim/starters/engage_starter_1', 0)
    elseif self.position == 4 then
        xpl_command ('sim/starters/engage_starter_1', 1)
    end

end

-- Do not copy this line if copying this file directly into logic.lua
return MagnetoSwitch