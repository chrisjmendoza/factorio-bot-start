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
