--- Adds additional actions to Switch class to simulate a Bendix Switch
---@class SwitchMagneto : Switch
SwitchMagneto = Switch:new ()

function SwitchMagneto:callback (position)
    Switch.callback (self, position)

    if self.position == 3 then
        xpl_command ('sim/starters/engage_starter_1', 0)
    elseif self.position == 4 then
        xpl_command ('sim/starters/engage_starter_1', 1)
    end

end
