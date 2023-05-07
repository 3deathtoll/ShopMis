extends RefCounted

class_name Maplewick

func open_shop(duration: int):
	Game.data.time.add_min(duration*60)
	var n = randi_range(1 * duration, 4 * duration)
	var items = Item.choose_n_from(Game.data.showcased_items.values(), n)
	var gain = 0
	for item in items:
		Game.data.showcased_items.remove(item, item.qty)
		gain += item.qty * item.get_sell_price()
	Game.gain_money(gain)
	Game.change_passage("End")

func draw_water():
	Game.gain_item(Item.new("Water", 1, 1))
