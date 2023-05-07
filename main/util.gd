extends Node

class_name Util

const TOLERANCE = 1e-6

const KEYS = [
	KEY_1, KEY_2, KEY_3, KEY_4, KEY_5,
	KEY_Q, KEY_W, KEY_E, KEY_R, KEY_T,
	KEY_A, KEY_S, KEY_D, KEY_F, KEY_G,
]

const SORTED_KEYS = [
	KEY_1, KEY_2, KEY_3, KEY_4, KEY_5,
	KEY_A, KEY_D, KEY_E, KEY_F, KEY_G,
	KEY_Q, KEY_R, KEY_S, KEY_T, KEY_W,
]

const REV_KEYS = [ # inverse of sorted KEYS
	0, 1, 2, 3, 4,
	10, 12, 7, 13, 14,
	5, 8, 11, 9, 6
]

static func rev_key(code):
	var i = SORTED_KEYS.bsearch(code)
	if i < len(SORTED_KEYS) and SORTED_KEYS[i] == code:
		return REV_KEYS[i]
	return -1

class LevelMath extends RefCounted:
	var w = {}

	func add_level(level: int, qty:=1):
		if w.has(level):
			w[level] += qty
		else:
			w[level] = qty

	func get_result_level():
		var n = len(w)
		if n == 1:
			return w.keys()[0]
		var min_x = INF
		var max_x = 0
		var sum_x = 0.0
		var sum_y = 0.0
		var sum_xy = 0.0
		var sum_x2 = 0.0
		for x in w:
			if x < min_x:
				min_x = x
			if x > max_x:
				max_x = x
			var y = w[x]
			sum_x += x
			sum_y += y
			sum_x2 += x*x
			sum_xy += x*y
		var m = (n * sum_xy - sum_x * sum_y) / (n * sum_x2 - sum_x * sum_x)
		var c = (sum_y - m * sum_x) / n
		var ps = []
		for x in range(min_x, max_x + 1):
			ps.push_back(m * x + c)
		return min_x + Util.weighted_random(ps)


static func weighted_random(weights: Array):
	var sum = 0.0
	for weight in weights:
		sum += weight
	var rngesus = sum * randf()
	var i = 0
	for weight in weights:
		rngesus -= weight
		if rngesus < 0:
			return i
		i += 1
	return len(weights) - 1
