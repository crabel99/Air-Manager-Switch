-- Replace these required lines if the code doesn't run with the contents of
-- the respective lib/NAME.lua file.
local Switch = require "Switch"
local ToggleSwitch = require "ToggleSwitch"
local MagnetoSwitch = require "MagnetoSwitch"


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


-- Fuel Boost Pump
local fuel_boost_pump = ToggleSwitch:new {
    name = "Fuel boost pump switch",
    fs_event = {"TOGGLE_ELECT_FUEL_PUMP1"},
    fs_variable = {"GENERAL ENG FUEL PUMP SWITCH:1"},
    commandref = {"sim/fuel/fuel_pump_1_off", "sim/fuel/fuel_pump_1_on"}
}
fuel_boost_pump:hw_switch_add ()

-- Magnetos
local magnetos = MagnetoSwitch:new {
    name = "Bendix magneto switch",
    n_pos = 5,
    fs_event = {
        "MAGNETO_OFF",   -- 0
        "MAGNETO_RIGHT", -- 1
        "MAGNETO_LEFT",  -- 2
        "MAGNETO_BOTH",  -- 3
        "MAGNETO_START"  -- 4
    },
    commandref = {
        "sim/magnetos/magnetos_off_1",   -- 0
        "sim/magnetos/magnetos_right_1", -- 1
        "sim/magnetos/magnetos_left_1",  -- 2
        "sim/magnetos/magnetos_both_1",  -- 3
        "sim/magnetos/magnetos_both_1"   -- 4
    }
}
magnetos:hw_switch_add ()
