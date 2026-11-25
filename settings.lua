data:extend({
	{
		-- Worker robot speed the bots arrive with, as if this many levels of
		-- "Worker robot speed" were already researched. Research stacks on top.
		type = "int-setting",
		name = "botstart-robot-speed-level",
		setting_type = "runtime-global",
		default_value = 5,
		minimum_value = 0,
		maximum_value = 5,
		order = "a",
	},
})
