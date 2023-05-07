extends RefCounted

class_name Clock

var day: int
var hrs: int
var min: int

func _init(day, hrs, min):
	self.day = day
	self.hrs = hrs
	self.min = min

func add_min(minutes):
	min += minutes
	while min >= 60:
		min-=60
		hrs+=1
	while hrs >= 24:
		hrs-=24
		day+=1

func add_hrs(hours, minutes):
	hrs += hours
	min += minutes
	while min >= 60:
		min-=60
		hrs+=1
	while hrs >= 24:
		hrs-=24
		day+=1

func add_time(time):
	hrs += time.hrs
	min += time.min
	day += time.day
	while min >= 60:
		min-=60
		hrs+=1
	while hrs >= 24:
		hrs-=24
		day+=1


func _to_string():
	var ret = "Day " + String.num_int64(day) + " "
	if hrs < 10:
		ret += "0"
	ret += String.num_int64(hrs) + ":"
	if min < 10:
		ret += "0"
	ret += String.num_int64(min)
	return ret
