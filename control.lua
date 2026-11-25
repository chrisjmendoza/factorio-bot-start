local items = {
	{"power-armor-mk2", 1},
	{"construction-robot", 50},
}

local armor = {
	{"fission-reactor-equipment"},
	{"fission-reactor-equipment"},
	{"personal-roboport-mk2-equipment"},
	{"personal-roboport-mk2-equipment"},
	{"fission-reactor-equipment"},
	{"fission-reactor-equipment"},
	{"personal-roboport-mk2-equipment"},
	{"personal-roboport-mk2-equipment"},
	{"battery-mk2-equipment"},
	{"battery-mk2-equipment"},
	{"energy-shield-mk2-equipment"},
	{"energy-shield-mk2-equipment"},
	{"energy-shield-mk2-equipment"},
	{"energy-shield-mk2-equipment"},
}

local function give_starting_loadout(player)
	for i, v in pairs(items) do
		player.insert{name = v[1], count = v[2]}
	end

	local armor_inventory = player.get_inventory(defines.inventory.character_armor)
	if not (armor_inventory and armor_inventory[1] and armor_inventory[1].valid_for_read) then
		return
	end

	local grid = armor_inventory[1].grid
	if not grid then
		return
	end

	for i, v in pairs(armor) do
		grid.put({name = v[1]})
	end
end

-- Starting robot speed: the summed bonus of the first N "worker-robots-speed"
-- technologies, read from the game's own prototypes, added to each player
-- force's modifier. storage remembers what was added, so changing the setting
-- (or loading an older save) adjusts by the difference and never double-counts.
local function speed_bonus(level)
	local total = 0
	for i = 1, level do
		local tech = prototypes.technology["worker-robots-speed-" .. i]
		if tech then
			for _, effect in pairs(tech.effects) do
				if effect.type == "worker-robot-speed" then total = total + effect.modifier end
			end
		end
	end
	return total
end

local function apply_robot_speed()
	storage.speed_applied = storage.speed_applied or {}
	local want = speed_bonus(settings.global["botstart-robot-speed-level"].value)
	for _, force in pairs(game.forces) do
		if force.name ~= "enemy" and force.name ~= "neutral" then
			local had = storage.speed_applied[force.name] or 0
			if want ~= had then
				force.worker_robots_speed_modifier = force.worker_robots_speed_modifier + (want - had)
				storage.speed_applied[force.name] = want
			end
		end
	end
end

script.on_init(apply_robot_speed)
script.on_configuration_changed(apply_robot_speed)
script.on_event(defines.events.on_force_created, apply_robot_speed)
script.on_event(defines.events.on_runtime_mod_setting_changed, function(event)
	if event.setting == "botstart-robot-speed-level" then apply_robot_speed() end
end)

script.on_event(defines.events.on_player_created, function(event)
	local player = game.players[event.player_index]

	if (player.controller_type == defines.controllers.character) then
		give_starting_loadout(player)
	end
end)

script.on_event(defines.events.on_cutscene_cancelled, function(event)
	local player = game.players[event.player_index]

	if player.character then
		give_starting_loadout(player)
	end
end)
