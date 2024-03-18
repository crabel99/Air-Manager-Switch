-- Do not copy this line if copying this file directly into logic.lua
local Switch = require "Switch"

--- The ToggleSwitch provides a container to simplify the integration of FS
--- toggle switches and X-plane two position switches into Air Manager.
--- This uses FS TOGGLE events and the corresponding X-plane commandrefs.
---@class ToggleSwitch : Switch
---@field private state boolean
---@field private fs_available boolean
---@field private xp_available boolean
---@field private xp_toggle boolean
local ToggleSwitch = Switch:new ()

-- Flight Simulator X/2020 Toggle Switch update
---@param state boolean
---@private
function ToggleSwitch:new_data (state)
    self.state = state

    if (self.state == false and self.position == 1) or
       (self.state == true and self.position == 0) then
        fsx_event (self.fs_event)
        fs2020_event (self.fs_event)
    end

end

--- Configure the class behavior based on the inputs
---@private
function ToggleSwitch:setup ()
    self.length = 2
    self.fs_available = next(self.fs_variable) ~= nil
    self.xp_available = next(self.commandref) ~= nil

    if self.xp_available then
        self.xp_toggle = self:tableLength(self.commandref) == 1
    end

    if self.fs_available then
        self.fs_toggle = self:tableLength(self.fs_variable) == 1 and
                         self:tableLength(self.fs_event) ~= 2
    end

    if self.fs_available then
        self:tableLengthCheck(self.fs_variable, 1)
        self:tableLengthCheck(self.fs_event, 1)
        local function new_data (state) self:new_data (state) end
        fsx_variable_subscribe (self.fs_variable[1], self.var_type, new_data)
        fs2020_variable_subscribe (self.fs_variable[1], self.var_type, new_data)
    end

end

--- Switch Callback
---@param position integer|nil
---@private
function ToggleSwitch:callback (position)

    self.position = position

    if self.xp_available then

        if self.xp_toggle then

            if self.position == 0 then
                xpl_command (self.commandref[1], 0)
            elseif self.position == 1 then
                xpl_command (self.commandref[1], 1)
            end

        else

            if self.position == 0 then
                xpl_command (self.commandref[1])
            elseif self.position == 1 then
                xpl_command (self.commandref[2])
            end

        end

    end

    if self.fs_available then
        request_callback (function () self:new_data (self.state) end)
    end
end

-- Do not copy this line if copying this file directly into logic.lua
return ToggleSwitch
