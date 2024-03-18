
# Switch Class for Air Manager

Sim Innovations [Air Manager](https://www.siminnovations.com/air-manager/) provides users with a powerful tool to interface with various flight simulators.
While Air Manager is powerful and extremely useful, it does not provide all of the necessary behaviors that are needed particularly for external switch characteristics.
The `Switch` class provides an implementation of a traditional object oriented code in `Lua` to create a simple object (`Lua` table) that provides the properties that we want.
This class can easily be extended to other simulators, but as of this moment it only supports X-Plane, Microsoft Flight Simulator X and 2020.

## Description

The `Switch` class contains the necessary methods and variables to support basic sanity checks of the class inputs during construction, forced alignment of the flight simulator's internal switch state to the controlling external peripheral's switch, and an extensible method of customization while preserving basic class functions.

### Methods

Method | Return | Description
---|---|---
`new ()` | `Switch` | Class constructor called when initializing a new instance
`tableLength (Table: table)` | `integer` | Returns the length of a table
`tableLengthCheck (Table: table, length: integer\|nil)` | `nil` | Checks the length of a command table is appropriate for the number os switch positions
`setup ()` | `nil` | Does the sanity checks of the table during instantiation 
`callback (position: integer)` | `nil` | The set of actions performed whenever the switch position changes.
`hw_switch_add ()` | `table` | Executes Air Manager's `hw_switch_add ()` creating the switch and starting the timer that forces the simulator's switch position to match the position of the external switch

### Variables
Name | type | Description
---|---|---
`name` |`string` | the switch's Air Manager Name
`id` | `table` | the id returned when the switch is added
`fs_event` | `table` | [FS events](https://docs.flightsimulator.com/html/Programming_Tools/Event_IDs/Event_IDs.htm) triggered by the switch
`fs_variable` | `table` | [FS variables](https://docs.flightsimulator.com/html/Programming_Tools/SimVars/Simulation_Variables.htm) controlled by the switch
 commandref | `table` | X-plane [`commandref`'s](https://siminnovations.com/wiki/index.php?title=Xplane_commandrefs) executed by the switch
`var_type` | `string` | the type of data for the switch, default is "Bool"
`n_pos` | `integer` | number of switch positions, default is 1
`length` | `integer` | length of switch actions, default is 2
`position` | `integer\|nil` | Switch position

## Usage

As of this writing the `Switch` class is not able to be loaded into Air Manager. For this reason you will have to copy the contents of `lib/Switch.lua` into the top of your `logic.lua`.
An additional class named `lib/ToggleSwitch.lua` is also provided this is a subclass of `Switch` with the necessary functions to make a toggle switch in the simulator act as a two position switch. [Perhaps not the best class name...]
An example `logic.lua` is also given showing how this code code be used in practice.

Note: Air Manager has [disabled `require ()`](https://cr4o13.github.io/the-lua-environment-in-air-manager.html) due to the unavailability of the `package` library.

### Simple Switch
```lua
-- Beacon Lights
local beacon_light = Switch:new {
    name = "Beacon switch",
    fs_event = {
        "BEACON_LIGHTS_OFF",
        "BEACON_LIGHTS_ON"},
    commandref = {
        "sim/lights/beacon_lights_off",
        "sim/lights/beacon_lights_on"}
}
beacon_light:hw_switch_add ()
```

### Creating a Switch SubClass

```lua
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
```

Note, the `Switch.callback (self, position)` executes the super class's callback preserving all of the normal functionality of that callback method.
The `MagnetoSwitch` class example would be used in the code by,
```lua
-- Magnetos
local magnetos = MagnetoSwitch:new {
    name = "Bendix magneto switch",
    n_pos = 5,
    fs_event = {
        "MAGNETO_OFF",   -- 0 position
        "MAGNETO_RIGHT", -- 1 position
        "MAGNETO_LEFT",  -- 2 position
        "MAGNETO_BOTH",  -- 3 position
        "MAGNETO_START"  -- 4 position
    },
    commandref = {
        "sim/magnetos/magnetos_off_1",   -- 0 position
        "sim/magnetos/magnetos_right_1", -- 1 position
        "sim/magnetos/magnetos_left_1",  -- 2 position
        "sim/magnetos/magnetos_both_1",  -- 3 position
        "sim/magnetos/magnetos_both_1"   -- 4 position
    }
}
magnetos:hw_switch_add ()
```

### `ToggleSwitch`
A good example of when a toggle switch is required is the fuel boost pump.

```lua
-- Fuel Boost Pump
local fuel_boost_pump = ToggleSwitch:new {
    name = "Fuel boost pump switch",
    fs_event = {"TOGGLE_ELECT_FUEL_PUMP1"},
    fs_variable = {"GENERAL ENG FUEL PUMP SWITCH:1"},
    commandref = {"sim/fuel/fuel_pump_1_off", "sim/fuel/fuel_pump_1_on"}
}
fuel_boost_pump:hw_switch_add ()
```

---
Copyright: © (2024) [Virtual Aviation of Minnesota](https://virtualaviationmn.com)<br>
License: [MIT](./LICENSE.md)<br>
Author: Cal Abel
