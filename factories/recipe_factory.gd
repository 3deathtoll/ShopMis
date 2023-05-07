extends RefCounted

class_name RecipeFactory

static func init():
	var recipe
	recipe = Recipe.new("Healing Draught", 20)
	recipe.add_ingredient("Troll Blood", "", 1)
	recipe.add_ingredient("Water", "", 1)
	Game.recipes[recipe.title] = recipe
	recipe = Recipe.new("Bronze Ingot", 20)
	recipe.add_ingredient("Copper Ore", "", 1)
	recipe.add_ingredient("Tin Ore", "", 1)
	Game.recipes[recipe.title] = recipe
