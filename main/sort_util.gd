extends Node

const SORT_BY_RECENT = 0
const SORT_BY_NAME = 0
const SORT_BY_LEVEL = 0
const SORT_BY_COST = 0

func sort_callable(sort_by):
	if sort_by == SORT_BY_RECENT:
		return func (a, b): sort_by_recent(a, b)
	if sort_by == SORT_BY_NAME:
		return func (a, b): sort_by_name(a, b)
	if sort_by == SORT_BY_LEVEL:
		return func (a, b): sort_by_level(a, b)
	if sort_by == SORT_BY_COST:
		return func (a, b): sort_by_cost(a, b)

func sort_by_recent(item1: Item, item2: Item):
	return Item.get_item_pos(item1) > Item.get_item_pos(item2)

func sort_by_name(item1: Item, item2: Item):
	return item1.name < item2.name

func sort_by_level(item1: Item, item2: Item):
	return item1.level > item2.level

func sort_by_cost(item1: Item, item2: Item):
	return item1.get_sell_price() < item2.get_sell_price()
