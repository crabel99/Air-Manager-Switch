--- This is the base structure of a switch in Air Manager
---@class Switch : table
---@field name string -- the switch's Air Manager Name
---@field id table -- the id returned when the switch is added
---@field fs_event table -- FS fs_event triggered by the switch
---@field fs_variable table -- FS variable controlled by the switch
---@field commandref table -- X-plane commandref
---@field var_type string -- the type of data for the switch, default is "Bool"
---@field n_pos integer -- number of switch positions, default is 1
---@field length integer -- length of switch actions, default is 2
---@field position integer|nil -- Switch position
Switch = {
    var_type = "Bool",
    n_pos = 1,
    length = 2
}

--- Constructor
---@return Switch
function Switch:new (object)
    local newObject = setmetatable (object or {}, self)
    self.__index = self

    return newObject
end

--- Determine the number of table entries
---@param Table table
---@return integer
function Switch:tableLength (Table)
    local count = 0
    for _ in pairs(Table) do count = count + 1 end

    return count
end

--- Check that a table has the correct size for the number of switch positions
---@param Table table
---@param length integer|nil
function Switch:tableLengthCheck (Table, length)

    if length == nil then length = self.length end

    if self:tableLength (Table) ~= length then
        error("Switch command/fs_event table is not of length "..length..".")
    end

end

--- Configure the class behavior based on the inputs
---@private
function Switch:setup ()
    -- configures the switch to be ON-OFF or POS1-POS2-NOT EITHER
    if self.n_pos == 1 | self.n_pos == 2 then
        self.length = self.n_pos + 1
    elseif self.n_pos > 2 then
        self.length = self.n_pos
    end

    self:tableLengthCheck (self.fs_event)
    self:tableLengthCheck (self.commandref)
end

--- Switch Callback
---@param position integer|nil
---@private
function Switch:callback (position)
    self.position = position

    for i = 1, self.length do

        if self.position == i - 1 then
            xpl_command (self.commandref[i])
            fsx_event (self.fs_event[i])
            fs2020_event (self.fs_event[i])
        end
    end

end

--- Add the switch
---@return table
function Switch:hw_switch_add ()
    local function callback (position) self:callback (position) end
    self.id = hw_switch_add (self.name, self.n_pos, callback)
    self.position = hw_switch_get_position(self.id)
    self:setup()

    -- force simulator condition to match the external configuration.
    timer_start (0, 1000, -1, function () self:callback(self.position) end)

    return self.id
end
