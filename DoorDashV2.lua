---@diagnostic disable: unused-local
--Requirements
local antiaim_funcs = require "gamesense/antiaim_funcs"
local easing = require "gamesense/easing"
local vector = require("vector")
-- local variables for API functions. any changes to the line below will be lost on re-generation
local bit_band, client_camera_angles, client_color_log, client_create_interface, client_delay_call, client_exec, client_eye_position, client_key_state, client_log, client_random_int, client_scale_damage, client_screen_size, client_set_event_callback, client_trace_bullet, client_userid_to_entindex, database_read, database_write, entity_get_player_weapon, entity_get_players, entity_get_prop, entity_hitbox_position, entity_is_alive, entity_is_enemy, math_abs, math_atan2, require, error, globals_absoluteframetime, globals_curtime, globals_realtime, math_atan, math_cos, math_deg, math_floor, math_max, math_min, math_rad, math_sin, math_sqrt, print, renderer_circle_outline, renderer_gradient, renderer_measure_text, renderer_rectangle, renderer_text, renderer_triangle, string_find, string_gmatch, string_gsub, string_lower, table_insert, table_remove, ui_get, ui_new_checkbox, ui_new_color_picker, ui_new_hotkey, ui_new_multiselect, ui_reference, tostring, ui_is_menu_open, ui_mouse_position, ui_new_combobox, ui_new_slider, ui_set, ui_set_callback, ui_set_visible, tonumber, pcall = bit.band, client.camera_angles, client.color_log, client.create_interface, client.delay_call, client.exec, client.eye_position, client.key_state, client.log, client.random_int, client.scale_damage, client.screen_size, client.set_event_callback, client.trace_bullet, client.userid_to_entindex, database.read, database.write, entity.get_player_weapon, entity.get_players, entity.get_prop, entity.hitbox_position, entity.is_alive, entity.is_enemy, math.abs, math.atan2, require, error, globals.absoluteframetime, globals.curtime, globals.realtime, math.atan, math.cos, math.deg, math.floor, math.max, math.min, math.rad, math.sin, math.sqrt, print, renderer.circle_outline, renderer.gradient, renderer.measure_text, renderer.rectangle, renderer.text, renderer.triangle, string.find, string.gmatch, string.gsub, string.lower, table.insert, table.remove, ui.get, ui.new_checkbox, ui.new_color_picker, ui.new_hotkey, ui.new_multiselect, ui.reference, tostring, ui.is_menu_open, ui.mouse_position, ui.new_combobox, ui.new_slider, ui.set, ui.set_callback, ui.set_visible, tonumber, pcall
local ui_menu_position, ui_menu_size, math_pi, renderer_indicator, entity_is_dormant, client_set_clan_tag, client_trace_line, entity_get_all, entity_get_classname = ui.menu_position, ui.menu_size, math.pi, renderer.indicator, entity.is_dormant, client.set_clan_tag, client.trace_line, entity.get_all, entity.get_local_player
local entity_get_player_weapon, entity_get_local_player, entity_get_classname, entity_get_prop, entity_get_all, math_sqrt = entity.get_player_weapon, entity.get_local_player, entity.get_classname, entity.get_prop, entity.get_all, math.sqrt
local screen = {client.screen_size()}
local center = {screen[1]/2, screen[2]/2}
--Console Welcoming 
client.color_log(255, 255, 255,"d8888b.  .d88b.   .d88b.  d8888b. d8888b.  .d8b.  .d8888. db   db ")
client.color_log(255, 255, 255,"88  `8D .8P  Y8. .8P  Y8. 88  `8D 88  `8D d8' `8b 88'  YP 88   88 ")
client.color_log(255, 255, 255,"88   88 88    88 88    88 88oobY' 88   88 88ooo88 `8bo.   88ooo88 ")
client.color_log(255, 255, 255,"88   88 88    88 88    88 88`8b   88   88 88~~~88   `Y8b. 88~~~88 ")
client.color_log(255, 255, 255,"88  .8D `8b  d8' `8b  d8' 88 `88. 88  .8D 88   88 db   8D 88   88 ")
client.color_log(255, 255, 255,"Y8888D'  `Y88P'   `Y88P'  88   YD Y8888D' YP   YP `8888Y' YP   YP ")
client.color_log(255, 255, 255, "|--------------------------------------------------------|")
client.color_log(238, 75, 43,   "                    Welcome to DoorDash.Lua!  		       ")
client.color_log(238, 75, 43,   "                    Last Updated: 2/23/2022               ")
client.color_log(238, 75, 43,   "                    Debug Build                           ")
client.color_log(255, 255, 255, "|--------------------------------------------------------|") 
--Referencing
local reference = {
	Enabled = ui.reference("AA", "Anti-aimbot angles", "Enabled"),
	Pitch = ui.reference("AA", "Anti-aimbot angles", "Pitch"),
	YawBase = ui.reference("AA", "Anti-aimbot angles", "Yaw base"),
    Yaw = {ui.reference("AA", "Anti-aimbot angles", "Yaw")},
    YawJitter = {ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")},
    BodyYaw = {ui.reference("AA", "Anti-aimbot angles", "Body yaw")},
	FakeYawLimit = ui.reference("AA", "Anti-aimbot angles", "Fake Yaw limit"),
    FreestandingBodyYaw = ui.reference("AA", "Anti-aimbot angles", "Freestanding body Yaw"),
    Roll = ui.reference("AA", "Anti-aimbot angles", "Roll"),
	EdgeYaw = ui.reference("AA", "Anti-aimbot angles", "Edge Yaw"),
	Freestanding = ui.reference("AA", "Anti-aimbot angles", "Freestanding"),
	SlowMotion = { ui.reference("AA", "Other", "Slow motion") },
	LegMovement = ui.reference("AA", "Other", "Leg movement"),
    FL = ui.reference("AA", "Fake lag", "Limit"),
    FD = ui.reference("Rage", "Other", "Duck peek assist"),
    DT = {ui.reference("Rage", "Other", "Double Tap")},
    OSAA = {ui.reference("AA", "Other", "On shot anti-aim")},
    QuickPeek = {ui.reference("Rage", "Other", "Quick peek assist")},
    ProcessTicks = ui.reference("Misc", "Settings", "sv_maxusrcmdprocessticks")
}

--Menu
local menu = {
    Opening = ui.new_checkbox("AA", "Anti-aimbot angles", "Enable DoorDash.lua"),
    DoorDash1 = ui.new_label("AA", "Anti-aimbot angles", "+/-DoorDash.lua-/+"),
    ComboBox = ui.new_combobox("AA", "Anti-aimbot angles", "Settings", {"-", "Anti-Aim Settings", "Visual Settings", "Miscellaneous Settings"}),
    Label1 = ui.new_label("AA", "Anti-aimbot angles", "+++ AA Features +++"),
    Enable = ui.new_checkbox("AA", "Anti-aimbot angles", "Enable Anti-Aim"),
    AASelection = ui.new_combobox("AA", "Anti-aimbot angles", "AA Mode Selection", {"-", "Default", "Experimental", "Create Own Settings"}),
    RandomFakeOnSlowMotion = ui.new_checkbox("AA", "Anti-aimbot angles", "Random Fake Yaw Limit on Slow Motion"),
    LegitAA = ui.new_checkbox("AA", "Anti-aimbot angles", "Legit AA"),
    AvoidOverlap = ui.new_checkbox("AA", "Anti-aimbot angles", "Avoid Overlap"),
    KnifeRoundAA = ui.new_checkbox("AA", "Anti-aimbot angles", "Knife Round AA"),
    LegBreaker = ui.new_checkbox("AA", "Anti-aimbot angles", "Leg Breaker"),
    MenuRoll = ui.new_slider("AA", "Anti-aimbot angles", "Roll Angle", -50, 50, 0, true, "°"),
    CustomSettings = ui.new_combobox("AA", "Anti-aimbot angles", "Player States", {"-", "Moving", "In Air", "Standing", "Slow Walking"}),
    Label2 = ui.new_label("AA", "Anti-aimbot angles", "+++ Visual Features +++"),
    Indicators = ui.new_checkbox("AA", "Anti-aimbot angles", "DoorDash Indicators"),
    ColorLabel1 = ui.new_label("AA", "Anti-aimbot angles", "Main Color"),
    Color1 = ui.new_color_picker("AA", "Anti-aimbot angles", " ", 255, 255, 255, 255),
    ColorLabel2 = ui.new_label("AA", "Anti-aimbot angles", "Ascent Color"),
    Color2 = ui.new_color_picker("AA", "Anti-aimbot angles", " ", 255, 48, 8),
    ColorLabel3 = ui.new_label("AA", "Anti-aimbot angles", "PlayerStates Color"),
    Color3 = ui.new_color_picker("AA", "Anti-aimbot angles", " ", 255, 255, 255, 255),
    StaticLegs = ui.new_checkbox("AA", "Anti-aimbot angles", "Static Legs In Air"),
    NoPitch = ui.new_checkbox("AA", "Anti-aimbot angles", "0 Pitch on Land"),
    Label3 = ui.new_label("AA", "Anti-aimbot angles", "+++ Miscellaneous +++"),
    ClanTag = ui.new_checkbox("AA", "Anti-aimbot angles", "DoorDash Clantag"),
    IdealTickCheck = ui.new_checkbox("AA", "Anti-aimbot angles", "Ideal Tick"),
    IdealTick = ui.new_hotkey("AA", "Anti-aimbot angles", "Ideal Tick Key", true),
    DoubleTapFall = ui.new_combobox("AA", "Anti-aimbot angles", "Double Tap Fallback (WIP)", {"On Hotkey", "Toggle"}),
    QuickPeekFall = ui.new_combobox("AA", "Anti-aimbot angles", "Quick Peek Fallback (WIP)", {"On Hotkey", "Toggle"}),
    FreeStandOnKeyCheck = ui.new_checkbox("AA", "Anti-aimbot angles", "Freestand"),
    FreeStandOnKey = ui.new_hotkey("AA", "Anti-aimbot angles", "Freestand Key", true),
    EdgeYawOnKeyCheck = ui.new_checkbox("AA", "Anti-aimbot angles", "Edge Yaw"),
    EdgeYawOnKey = ui.new_hotkey("AA", "Anti-aimbot angles", "Edge Yaw Key", true),
}

--Anti-Aim
local x, y = entity.get_prop( entity.get_local_player(), "m_vecVelocity")
local speed = x ~= nil and math.floor(math.sqrt( x * x + y * y + 0.5 )) or 0
local in_air = entity.get_prop(entity.get_local_player(), "m_fFlags") == 256
local in_crouch = entity.get_prop(entity.get_local_player(), "m_fFlags") == 263

client.set_event_callback("setup_command", function ()
    x, y = entity.get_prop( entity.get_local_player(), "m_vecVelocity")
    speed = x ~= nil and math.floor(math.sqrt( x * x + y * y + 0.5 )) or 0
    in_air = entity.get_prop(entity.get_local_player(), "m_fFlags") == 256
    in_crouch = entity.get_prop(entity.get_local_player(), "m_fFlags") == 263
end)

--Blank Presets
client.set_event_callback("setup_command", function()
    if ui.get(menu.Enable) and ui.get(menu.AASelection) == "-" then
        ui.set(reference.Pitch, "Off")
        ui.set(reference.YawBase, "Local View")
        ui.set(reference.Yaw[1], "Off")
        ui.set(reference.Yaw[2], 0)
        ui.set(reference.YawJitter[1], "Off")
        ui.set(reference.YawJitter[2], 0)
        ui.set(reference.BodyYaw[1], "Off")
        ui.set(reference.BodyYaw[2], 0)
        ui.set(reference.FakeYawLimit, 60)
    end
end)

--Default Presets
client.set_event_callback("setup_command", function()
    if ui.get(menu.Enable) and ui.get(menu.AASelection) == "Default" then
    --Moving    
    if not in_air and not in_crouch and speed > 1 and speed <= 250 then
        ui.set(reference.Pitch, "Default")
        ui.set(reference.YawBase, "At targets")
		ui.set(reference.Yaw[1], "180")
        ui.set(reference.Yaw[2], 8)
        ui.set(reference.YawJitter[1], "Center")
        ui.set(reference.YawJitter[2], 48)
		ui.set(reference.BodyYaw[1], "Jitter")
        ui.set(reference.BodyYaw[2], 0)
		ui.set(reference.FakeYawLimit, 60)
    end
    --Standing
    if speed == 1 then
        ui.set(reference.Pitch, "Default")
        ui.set(reference.YawBase, "At targets")
		ui.set(reference.Yaw[1], "180")
        ui.set(reference.Yaw[2], 12)
        ui.set(reference.YawJitter[1], "Center")
        ui.set(reference.YawJitter[2], 50)
		ui.set(reference.BodyYaw[1], "Jitter")
        ui.set(reference.BodyYaw[2], 0)
		ui.set(reference.FakeYawLimit, 60)
    end
    --In Air
    if in_air then
        ui.set(reference.Pitch, "Default")
        ui.set(reference.YawBase, "At targets")
		ui.set(reference.Yaw[1], "180")
        ui.set(reference.Yaw[2], 4)
        ui.set(reference.YawJitter[1], "Center")
        ui.set(reference.YawJitter[2], 30)
		ui.set(reference.BodyYaw[1], "Jitter")
        ui.set(reference.BodyYaw[2], 0)
		ui.set(reference.FakeYawLimit, 60)
    end
    --SlowMotion       
    if ui.get(reference.SlowMotion[1]) and ui.get(reference.SlowMotion[2]) then
        ui.set(reference.Pitch, "Default")
        ui.set(reference.YawBase, "At targets")
		ui.set(reference.Yaw[1], "180")
        ui.set(reference.Yaw[2], 10)
        ui.set(reference.YawJitter[1], "Center")
        ui.set(reference.YawJitter[2], 0)
		ui.set(reference.BodyYaw[1], "Jitter")
        ui.set(reference.FakeYawLimit, 60)
        end
    end
end)

--Experimental Presets
client.set_event_callback("setup_command", function()
    if ui.get(menu.Enable) and ui.get(menu.AASelection) == "Experimental" then
    --Moving    
    if not in_air and not in_crouch and speed > 1 and speed <= 250 then
        ui.set(reference.Pitch, "Default")
        ui.set(reference.YawBase, "At targets")
		ui.set(reference.Yaw[1], "180")
        ui.set(reference.Yaw[2], -1)
        ui.set(reference.YawJitter[1], "Center")
        ui.set(reference.YawJitter[2], 0)
		ui.set(reference.BodyYaw[1], "Static")
        ui.set(reference.BodyYaw[2], -7)
		ui.set(reference.FakeYawLimit, 60)
    end
    --Standing
    if speed == 1 then
        ui.set(reference.Pitch, "Default")
        ui.set(reference.YawBase, "At targets")
		ui.set(reference.Yaw[1], "180")
        ui.set(reference.Yaw[2], 9)
        ui.set(reference.YawJitter[1], "Center")
        ui.set(reference.YawJitter[2], 0)
		ui.set(reference.BodyYaw[1], "Static")
        ui.set(reference.BodyYaw[2], 9)
		ui.set(reference.FakeYawLimit, 57)
    end
    --In Air
    if in_air then
        ui.set(reference.Pitch, "Down")
        ui.set(reference.YawBase, "At targets")
		ui.set(reference.Yaw[1], "180")
        ui.set(reference.Yaw[2], 0)
        ui.set(reference.YawJitter[1], "Center")
        ui.set(reference.YawJitter[2], 0)
		ui.set(reference.BodyYaw[1], "Jitter")
        ui.set(reference.BodyYaw[2], -180)
		ui.set(reference.FakeYawLimit, 47)
    end
    --SlowMotion       
    if ui.get(reference.SlowMotion[1]) and ui.get(reference.SlowMotion[2]) then
        ui.set(reference.Pitch, "Default")
        ui.set(reference.YawBase, "At targets")
		ui.set(reference.Yaw[1], "180")
        ui.set(reference.Yaw[2], 10)
        ui.set(reference.YawJitter[1], "Center")
        ui.set(reference.YawJitter[2], 0)
		ui.set(reference.BodyYaw[1], "Jitter")
        ui.set(reference.FakeYawLimit, 60)
    end
end
end)

--Create Own Settings Presets
local Moving = {
    MovingLabel = ui.new_label("AA", "Anti-aimbot angles", "Moving"),
	Pitch = ui.new_combobox("AA", "Anti-aimbot angles", "Pitch", {"Off", "Default", "Up", "Down", "Minimal", "Random"}),
	YawBase = ui.new_combobox("AA", "Anti-aimbot angles", "Yaw Base", {"Local View", "At Targets"}),
	Yaw = ui.new_combobox("AA", "Anti-aimbot angles", "Yaw", {"Off", "180", "Spin", "Static", "180 Z", "Crosshair"}),
	YawSlider = ui.new_slider("AA", "Anti-aimbot angles", "\n", -180, 180, 0, true, "°"),
	YawJitter = ui.new_combobox("AA", "Anti-aimbot angles", "Yaw Jitter", {"Off", "Offset","Center","Random"}),
	YawJitterSlider = ui.new_slider("AA", "Anti-aimbot angles", "\n", -180, 180, 0, true, "°"),
	BodyYaw = ui.new_combobox("AA", "Anti-aimbot angles", "Body Yaw", {"Off", "Static", "Opposite","Jitter"}),
	BodyYawSlider = ui.new_slider("AA", "Anti-aimbot angles", "\n", -180, 180, 0, true, "°"),
	FakeYawLimitSlider = ui.new_slider("AA", "Anti-aimbot angles", "Fake Yaw Limit", 0, 60, 60, true, "°")
}

local Air = {
    AirLabel = ui.new_label("AA", "Anti-aimbot angles", "In Air"),
	Pitch = ui.new_combobox("AA", "Anti-aimbot angles", "Pitch", {"Off", "Default", "Up", "Down", "Minimal", "Random"}),
	YawBase = ui.new_combobox("AA", "Anti-aimbot angles", "Yaw Base", {"Local View", "At Targets"}),
	Yaw = ui.new_combobox("AA", "Anti-aimbot angles", "Yaw", {"Off", "180", "Spin", "Static", "180 Z", "Crosshair"}),
	YawSlider = ui.new_slider("AA", "Anti-aimbot angles", "\n", -180, 180, 0, true, "°"),
	YawJitter = ui.new_combobox("AA", "Anti-aimbot angles", "Yaw Jitter", {"Off", "Offset","Center","Random"}),
	YawJitterSlider = ui.new_slider("AA", "Anti-aimbot angles", "\n", -180, 180, 0, true, "°"),
	BodyYaw = ui.new_combobox("AA", "Anti-aimbot angles", "Body Yaw", {"Off", "Static", "Opposite","Jitter"}),
	BodyYawSlider = ui.new_slider("AA", "Anti-aimbot angles", "\n", -180, 180, 0, true, "°"),
	FakeYawLimitSlider = ui.new_slider("AA", "Anti-aimbot angles", "Fake Yaw Limit", 0, 60, 60, true, "°")
}

local Standing = {
    StandingLabel = ui.new_label("AA", "Anti-aimbot angles", "Standing"),
	Pitch = ui.new_combobox("AA", "Anti-aimbot angles", "Pitch", {"Off", "Default", "Up", "Down", "Minimal", "Random"}),
	YawBase = ui.new_combobox("AA", "Anti-aimbot angles", "Yaw Base", {"Local View", "At Targets"}),
	Yaw = ui.new_combobox("AA", "Anti-aimbot angles", "Yaw", {"Off", "180", "Spin", "Static", "180 Z", "Crosshair"}),
	YawSlider = ui.new_slider("AA", "Anti-aimbot angles", "\n", -180, 180, 0, true, "°"),
	YawJitter = ui.new_combobox("AA", "Anti-aimbot angles", "Yaw Jitter", {"Off", "Offset","Center","Random"}),
	YawJitterSlider = ui.new_slider("AA", "Anti-aimbot angles", "\n", -180, 180, 0, true, "°"),
	BodyYaw = ui.new_combobox("AA", "Anti-aimbot angles", "Body Yaw", {"Off", "Static", "Opposite","Jitter"}),
	BodyYawSlider = ui.new_slider("AA", "Anti-aimbot angles", "\n", -180, 180, 0, true, "°"),
	FakeYawLimitSlider = ui.new_slider("AA", "Anti-aimbot angles", "Fake Yaw Limit", 0, 60, 60, true, "°")
}

local Slowwalking = {
    SlowWalkLabel = ui.new_label("AA", "Anti-aimbot angles", "Slow Walk"),
	Pitch = ui.new_combobox("AA", "Anti-aimbot angles", "Pitch", {"Off", "Default", "Up", "Down", "Minimal", "Random"}),
	YawBase = ui.new_combobox("AA", "Anti-aimbot angles", "Yaw Base", {"Local View", "At Targets"}),
	Yaw = ui.new_combobox("AA", "Anti-aimbot angles", "Yaw", {"Off", "180", "Spin", "Static", "180 Z", "Crosshair"}),
	YawSlider = ui.new_slider("AA", "Anti-aimbot angles", "\n", -180, 180, 0, true, "°"),
	YawJitter = ui.new_combobox("AA", "Anti-aimbot angles", "Yaw Jitter", {"Off", "Offset","Center","Random"}),
	YawJitterSlider = ui.new_slider("AA", "Anti-aimbot angles", "\n", -180, 180, 0, true, "°"),
	BodyYaw = ui.new_combobox("AA", "Anti-aimbot angles", "Body Yaw", {"Off", "Static", "Opposite","Jitter"}),
	BodyYawSlider = ui.new_slider("AA", "Anti-aimbot angles", "\n", -180, 180, 0, true, "°"),
	FakeYawLimitSlider = ui.new_slider("AA", "Anti-aimbot angles", "Fake Yaw Limit", 0, 60, 60, true, "°")
}

client_set_event_callback("setup_command", function()
    if ui.get(menu.AASelection) == "Create Own Settings" then

    if not in_air and not in_crouch and speed > 1 and speed <= 250 then
		ui.set(reference.Yaw[1], ui.get(Moving.Yaw))
		ui.set(reference.Yaw[2], ui.get(Moving.YawSlider))
		ui.set(reference.YawJitter[1], ui.get(Moving.YawJitter))
		ui.set(reference.YawJitter[2], ui.get(Moving.YawJitterSlider))
		ui.set(reference.Pitch, ui.get(Moving.Pitch))
		ui.set(reference.BodyYaw[1], ui.get(Moving.BodyYaw))
        ui.set(reference.BodyYaw[2], ui.get(Moving.BodyYawSlider))
		ui.set(reference.YawBase, ui.get(Moving.YawBase))
		ui.set(reference.FakeYawLimit, ui.get(Moving.FakeYawLimitSlider))
	end

	if speed == 1 then
		ui.set(reference.Yaw[1], ui.get(Standing.Yaw))
		ui.set(reference.Yaw[2], ui.get(Standing.YawSlider))
		ui.set(reference.YawJitter[1], ui.get(Standing.YawJitter))
		ui.set(reference.YawJitter[2], ui.get(Standing.YawJitterSlider))
		ui.set(reference.Pitch, ui.get(Standing.Pitch))
		ui.set(reference.BodyYaw[1], ui.get(Standing.BodyYaw))
        ui.set(reference.BodyYaw[2], ui.get(Standing.BodyYawSlider))
		ui.set(reference.YawBase, ui.get(Standing.YawBase))
		ui.set(reference.FakeYawLimit, ui.get(Standing.FakeYawLimitSlider))
	end

	if in_air then
		ui.set(reference.Yaw[1], ui.get(Air.Yaw))
		ui.set(reference.Yaw[2], ui.get(Air.YawSlider))
		ui.set(reference.YawJitter[1], ui.get(Air.YawJitter))
		ui.set(reference.YawJitter[2], ui.get(Air.YawJitterSlider))
		ui.set(reference.Pitch, ui.get(Air.Pitch))
		ui.set(reference.BodyYaw[1], ui.get(Air.BodyYaw))
        ui.set(reference.BodyYaw[2], ui.get(Air.BodyYawSlider))
		ui.set(reference.YawBase, ui.get(Air.YawBase))
		ui.set(reference.FakeYawLimit, ui.get(Air.FakeYawLimitSlider))
	end
	
	if ui.get(reference.SlowMotion[1]) and ui.get(reference.SlowMotion[2]) then
		ui.set(reference.Yaw[1], ui.get(Slowwalking.Yaw))
		ui.set(reference.Yaw[2], ui.get(Slowwalking.YawSlider))
		ui.set(reference.YawJitter[1], ui.get(Slowwalking.YawJitter))
		ui.set(reference.YawJitter[2], ui.get(Slowwalking.YawJitterSlider))
		ui.set(reference.Pitch, ui.get(Slowwalking.Pitch))
		ui.set(reference.BodyYaw[1], ui.get(Slowwalking.BodyYaw))
        ui.set(reference.BodyYaw[2], ui.get(Slowwalking.BodyYawSlider))
		ui.set(reference.YawBase, ui.get(Slowwalking.YawBase))
		ui.set(reference.FakeYawLimit, ui.get(Slowwalking.FakeYawLimitSlider))
	end
end
end)

--Random Fake On SlowMotion
local function RandomFake()
    if ui.get(menu.RandomFakeOnSlowMotion) then
	    if ui.get(reference.SlowMotion and reference.SlowMotion[2]) then
		    ui.set(reference.FakeYawLimit, client.random_int(15,60))
        end
	end
end

--Legit AA
client.set_event_callback("setup_command",function(e)
    local weaponn = entity.get_player_weapon()
    if ui.get(menu.LegitAA) then
        if weaponn ~= nil and entity.get_classname(weaponn) == "CC4" then
            if e.in_attack == 1 then
                e.in_attack = 0 
                e.in_use = 1
            end
        else
            if e.chokedcommands == 0 then
                e.in_use = 0
            end
        end
    end
end)

--Avoid Overlap
client.set_event_callback("setup_command", function(c)
    if ui.get(menu.AvoidOverlap)then
    if c.chokedcommands ~= 0 then
        return
    end

    if antiaim_funcs.get_overlap() > 0.615 then
        ui.set(reference.BodyYaw[1], "Static")
        ui.set(reference.BodyYaw[1], "Opposite", antiaim_funcs.get_desync(1) > 0 and -180 or 180)
    end
end
end)

--Knife Round AA
local function TurnOffAA()
	if ui.get(menu.KnifeRoundAA) then
		ui.set(reference.Enabled, false)
	else
		ui.set(reference.Enabled, true)
	end
end

client.set_event_callback("player_chat", function(info)
    if not ui.get(menu.KnifeRoundAA) then return end
    if string.find(string.lower(info.text), "knife!") then
        TurnOffAA()
    elseif string.find(string.lower(info.text), "knife.") then --"knife."" for Unmatched.gg cuz they're weird and retards
        TurnOffAA()
    end       
end)

client.set_event_callback("round_end", function (info)
    local TurnOnAA = ui.get(menu.KnifeRoundAA)
    if TurnOnAA then
		ui.set(reference.Enabled, true)
    end
end)

--Leg Breaker
local LegMovement = {
    [1] = "Off",
    [2] = "Always slide",
    [3] = "Never slide"
}

local function LegBreaker()
    if ui.get(menu.LegBreaker) then
        ui.set(reference.LegMovement, LegMovement[client_random_int(1,3)])
        ui.set_visible(reference.LegMovement, false)
	else
        ui.set(reference.LegMovement, "Off")
        ui.set_visible(reference.LegMovement, true)
	end
end

--Roll Angle
local function Roll()
    ui.set(reference.Roll, ui.get(menu.MenuRoll))
end

--Indicators
local function Indicators()
    local alpha = math_sin(math_abs((math.pi * -1) + (globals_curtime() * 1.5) % (math.pi * 2))) * 255
    local charged = 0
    local charged2 = 0
    local eased = easing.sine_in(charged, 0, 1, 1)
    local color = {255 * eased}
    local eased2 = easing.sine_in(charged2, 0, 1, 1)
    local color2 = {255 * eased2}
    local CLR1 = {ui.get(menu.Color1)}
    local CLR2 = {ui.get(menu.Color2)}
    local CLR3 = {ui.get(menu.Color3)}
    if ui.get(menu.Indicators)then
    if entity.get_local_player() == nil or not entity.is_alive(entity.get_local_player()) then return end
        --Base Indicators
        renderer.text(center[1], center[2] + 40, CLR1[1], CLR1[2], CLR1[3], alpha, "-c", nil, "DOORDASH  ALPHA") --Alpha given to Trusted Users and Staff, Beta given to Trusted Users, Live always available.
        renderer.text(center[1], center[2] + 50, CLR2[1], CLR2[2], CLR2[3], alpha, "-c", nil, "METHODS")
        --PlayerStates Indicators
        if not in_air and not in_crouch and speed > 1 and speed <= 250 then
            renderer.text(center[1], center[2] + 60,  CLR3[1], CLR3[2], CLR3[3], CLR3[4], "-c", nil, "MOVING")
        elseif speed <= 1 and not in_crouch then
            renderer.text(center[1], center[2] + 60,  CLR3[1], CLR3[2], CLR3[3], CLR3[4], "-c", nil, "STANDING")
        elseif in_air then
            renderer.text(center[1], center[2] + 60,  CLR3[1], CLR3[2], CLR3[3], CLR3[4], "-c", nil, "IN-AIR")
        elseif in_crouch then
            renderer.text(center[1], center[2] + 60,  CLR3[1], CLR3[2], CLR3[3], CLR3[4], "-c", nil, "CROUCH")
        elseif ui.get(reference.SlowMotion[1]) and ui.get(reference.SlowMotion[2]) then
            renderer.text(center[1], center[2] + 60,  CLR3[1], CLR3[2], CLR3[3], CLR3[4], "-c", nil, "SLOW-MO")
        elseif entity.is_dormant(ent) and entity_is_alive then
            renderer.text(center[1], center[2] + 60,  CLR3[1], CLR3[2], CLR3[3], CLR3[4], "-c", nil, "DORMANT")
        end
    end
end

--Old Animations And Static Legs
local ground_ticks, end_time = 1, 0

client.set_event_callback("pre_render", function()

    if ui.get(menu.StaticLegs) then
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 6)
    end
   
    if entity.is_alive(entity.get_local_player()) then
   
    if ui.get(menu.NoPitch) then
        local on_ground = bit.band(entity.get_prop(entity.get_local_player(), "m_fFlags"), 1)

        if on_ground == 1 then
            ground_ticks = ground_ticks + 1
        else
            ground_ticks = 0
            end_time = globals.curtime() + 1
        end
   
        if ground_ticks > ui.get(reference.FL)+1 and end_time > globals.curtime() then
            entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0.5, 12)
        end
    end
end end)

--ClanTag
local duration = 50
local clantags = {
    " ",
    "D",
    "Do",
    "Doo",
    "Door",
    "DoorD",
    "DoorDa",
    "DoorDas",
    "DoorDash",
    "DoorDash.Lua",
    "DoorDash",
    "DoorDash.Lua",
    "DoorDash",
    "DoorDas",
    "DoorDa",
    "DoorD",
    "Door",
    "Doo",
    "Do",   
    "D",
    " "
}

local clantag_prev
local function ClanTag()
    if ui.get(menu.ClanTag)then
        local cur = math.floor(globals.tickcount() / duration) % #clantags
        local clantag = clantags[cur+1]

        if clantag ~= clantag_prev then
          clantag_prev = clantag
          client.set_clan_tag(clantag)
        end
	end
end

--Ideal Tick
local function IdealTick()
    if ui.get(menu.IdealTick) and ui.get(reference.DT[1]) and ui.get(reference.DT[2]) then
        ui.set(reference.FL, 1)
    elseif not ui.get(menu.IdealTick) then
        ui.set(reference.FL, 14)
    end
end

--Freestanding On Key
local function FreeStand()
    if ui.get(menu.FreeStandOnKey) and ui.get(menu.FreeStandOnKeyCheck) then
        ui.set(reference.Freestanding, {"Default"})
    end
    if not ui.get(menu.FreeStandOnKey) then
        ui.set(reference.Freestanding, {})
    end
end

--Edge Yaw On Key
local function EdgeYaw()
    if ui.get(menu.EdgeYawOnKey) and ui.get(menu.EdgeYawOnKeyCheck) then
        ui.set(reference.EdgeYaw, true)
    end
    if not ui.get(menu.EdgeYawOnKey) then
        ui.set(reference.EdgeYaw, false)
    end
end

--GUI Removals
local function SetTableVisibility(table, state)
    for i = 1, #table do
        ui.set_visible(table[i], state)
    end
end

client.set_event_callback("paint_ui", function()
    SetTableVisibility({menu.Label1, menu.Enable, menu.AASelection, menu.LegitAA, menu.AvoidOverlap, menu.KnifeRoundAA, menu.LegBreaker, menu.MenuRoll, menu.CustomSettings, menu.Label2, menu.Indicators, menu.StaticLegs, menu.NoPitch, menu.Label3, menu.ClanTag, menu.IdealTick, menu.FreeStandOnKey, menu.EdgeYawOnKey, menu.DoubleTapFall, menu.QuickPeekFall}, (menu.ComboBox) == "-")
    SetTableVisibility({menu.Label1, menu.Enable, menu.AASelection, menu.RandomFakeOnSlowMotion, menu.LegitAA, menu.AvoidOverlap, menu.KnifeRoundAA, menu.LegBreaker, menu.MenuRoll, menu.CustomSettings}, ui.get(menu.ComboBox) == "Anti-Aim Settings")
    SetTableVisibility({menu.Label2, menu.Indicators, menu.StaticLegs, menu.NoPitch}, ui.get(menu.ComboBox) == "Visual Settings")
    SetTableVisibility({menu.Label3, menu.ClanTag, menu.IdealTickCheck, menu.IdealTick, menu.FreeStandOnKey, menu.FreeStandOnKeyCheck, menu.EdgeYawOnKey, menu.EdgeYawOnKeyCheck, menu.DoubleTapFall, menu.QuickPeekFall}, ui.get(menu.ComboBox) == "Miscellaneous Settings")
    SetTableVisibility({Standing.Yaw, Standing.YawSlider, Standing.YawJitter, Standing.YawJitterSlider, Standing.Pitch, Standing.BodyYaw, Standing.YawBase, Standing.FakeYawLimitSlider, Standing.BodyYawSlider, Standing.StandingLabel}, ui.get(menu.CustomSettings) == "Standing")
    SetTableVisibility({Moving.Yaw, Moving.YawSlider, Moving.YawJitter, Moving.YawJitterSlider, Moving.Pitch, Moving.BodyYaw, Moving.YawBase, Moving.FakeYawLimitSlider, Moving.BodyYawSlider, Moving.MovingLabel}, ui.get(menu.CustomSettings) == "Moving")
    SetTableVisibility({Air.Yaw,Air.YawSlider, Air.YawJitter, Air.YawJitterSlider, Air.Pitch, Air.BodyYaw, Air.YawBase, Air.FakeYawLimitSlider, Air.BodyYawSlider, Air.AirLabel}, ui.get(menu.CustomSettings) == "In Air")
    SetTableVisibility({Slowwalking.Yaw, Slowwalking.YawSlider, Slowwalking.YawJitter, Slowwalking.YawJitterSlider, Slowwalking.Pitch, Slowwalking.BodyYaw, Slowwalking.YawBase, Slowwalking.FakeYawLimitSlider, Slowwalking.BodyYawSlider, Slowwalking.SlowWalkLabel}, ui.get(menu.CustomSettings) == "Slow Walking")
    if ui.get(menu.Indicators) and ui.get(menu.ComboBox) == "Visual Settings" then
        SetTableVisibility({menu.ColorLabel1, menu.Color1, menu.ColorLabel2, menu.Color2, menu.ColorLabel3, menu.Color3}, true)
    else
        SetTableVisibility({menu.ColorLabel1, menu.Color1, menu.ColorLabel2, menu.Color2, menu.ColorLabel3, menu.Color3}, false)
    end
    if ui.get(menu.Opening) then
        SetTableVisibility({reference.Enabled, reference.Pitch, reference.YawBase, reference.Yaw[1], reference.Yaw[2], reference.YawJitter[1], reference.YawJitter[2], reference.BodyYaw[1], reference.BodyYaw[2], reference.FakeYawLimit, reference.FreestandingBodyYaw, reference.EdgeYaw, reference.Freestanding, reference.Roll, reference.ProcessTicks}, false)
        SetTableVisibility({menu.DoorDash1, menu.ComboBox}, true)
    else
        SetTableVisibility({reference.Enabled, reference.Pitch, reference.YawBase, reference.Yaw[1], reference.Yaw[2], reference.YawJitter[1], reference.YawJitter[2], reference.BodyYaw[1], reference.BodyYaw[2], reference.FakeYawLimit, reference.FreestandingBodyYaw, reference.EdgeYaw, reference.Freestanding, reference.Roll, reference.ProcessTicks}, true)
        SetTableVisibility({menu.DoorDash1, menu.ComboBox}, false)
    end
    if not (ui.get(menu.AASelection) == "Create Own Settings") or not ui.get(menu.Enable) then
        SetTableVisibility({menu.CustomSettings}, false)
        ui.set(menu.CustomSettings, "-")
    end
    if not ui.get(menu.IdealTickCheck) then
        SetTableVisibility({menu.DoubleTapFall, menu.QuickPeekFall}, false)
    end
    if not ui.get(menu.Enable) then
        SetTableVisibility({menu.AASelection}, false)
    end
end)

--Anti Stupid Shit
client.set_event_callback("setup_command", function()
    if not ui.get(menu.Opening)then
        ui.set(menu.Enable,false)
        ui.set(menu.ComboBox, "-")
        ui.set(menu.AvoidOverlap,false)
        ui.set(menu.KnifeRoundAA,false)
        ui.set(menu.LegBreaker,false)
        ui.set(menu.Indicators,false)
        ui.set(menu.StaticLegs,false)
        ui.set(menu.NoPitch,false)
        ui.set(menu.ClanTag,false)
        ui.set(reference.Pitch, "Off")
        ui.set(reference.YawBase, "Local View")
        ui.set(reference.Yaw[1], "Off")
        ui.set(reference.Yaw[2], 0)
        ui.set(reference.YawJitter[1], "Off")
        ui.set(reference.YawJitter[2], 0)
        ui.set(reference.BodyYaw[1], "Off")
        ui.set(reference.BodyYaw[2], 0)
        ui.set(reference.FakeYawLimit, 60)
    end
end)

client.set_event_callback("setup_command", function()
    if not ui.get(menu.Enable)then
        ui.set(reference.Pitch, "Off")
        ui.set(reference.YawBase, "Local View")
        ui.set(reference.Yaw[1], "Off")
        ui.set(reference.Yaw[2], 0)
        ui.set(reference.YawJitter[1], "Off")
        ui.set(reference.YawJitter[2], 0)
        ui.set(reference.BodyYaw[1], "Off")
        ui.set(reference.BodyYaw[2], 0)
        ui.set(reference.FakeYawLimit, 60)
    end
end)

--Shut Down GUI
local function on_shutdown()
    SetTableVisibility({reference.Enabled, reference.Pitch, reference.YawBase, reference.Yaw[1], reference.Yaw[2], reference.YawJitter[1], reference.YawJitter[2], reference.BodyYaw[1], reference.BodyYaw[2], reference.FakeYawLimit, reference.FreestandingBodyYaw, reference.EdgeYaw, reference.Freestanding, reference.Roll, reference.ProcessTicks}, true)
    ui.set(reference.Pitch, "Off")
    ui.set(reference.YawBase, "Local View")
    ui.set(reference.Yaw[1], "Off")
    ui.set(reference.Yaw[2], 0)
    ui.set(reference.YawJitter[1], "Off")
    ui.set(reference.YawJitter[2], 0)
    ui.set(reference.BodyYaw[1], "Off")
    ui.set(reference.BodyYaw[2], 0)
    ui.set(reference.FakeYawLimit, 60)
end

--CallBacks
client.set_event_callback("setup_command", RandomFake)
client.set_event_callback("run_command", LegBreaker)
client.set_event_callback("paint", Indicators)
client.set_event_callback("paint", IdealTick)
client.set_event_callback("shutdown", on_shutdown)
client.set_event_callback("run_command", EdgeYaw)
client.set_event_callback("run_command", FreeStand)
client.set_event_callback("setup_command", Roll)
client.set_event_callback("paint", ClanTag)

--End Of Lua!