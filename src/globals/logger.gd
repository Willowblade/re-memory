extends Node

var file = null

var levels = ["DEBUG", "INFO", "WARNING", "ERROR"]

var datetime_format_string = "{day}/{month}/{year}-{hour}:{minute}:{second}"

signal log_message(log_message)

func _ready():
	var log_folder = Directory.new()
	if not log_folder.file_exists("res://logs"):
		log_folder.make_dir("res://logs")
	
	file = File.new()
	if file.file_exists("res://logs/debug.log"):
		file.open("res://logs/debug.log", File.READ_WRITE)
		file.seek_end()
	else:
		file.open("res://logs/debug.log", File.WRITE)
		
func set_level(level: String):
	level = level.to_upper()
	if level == "DEBUG":
		levels = ["DEBUG", "INFO", "WARNING", "ERROR"]
	elif level == "INFO":
		levels = ["INFO", "WARNING", "ERROR"]
	elif level == "WARNING":
		levels = ["WARNING", "ERROR"]
	elif level == "ERROR":
		levels = ["ERROR"]
	else:
		error("Logger level {level} not supported by logger".format({"level": level}))

func make_log_message(level: String, message: String):
	if not level in levels:
		return
		
	var timestring = datetime_format_string.format(OS.get_datetime())

	var log_message_contents = {
		"time": timestring,
		"msecs": OS.get_ticks_msec(),
		"level": level,
		"message": message,
	}

	var log_message = "{time} - {msecs} - {level}: {message}".format(log_message_contents)
	
	file.store_line(log_message)
	print(log_message)

	emit_signal("log_message", log_message)
	
func debug(message: String):
	make_log_message("DEBUG", message)

func info(message: String):
	make_log_message("INFO", message)
	
func warning(message: String):
	make_log_message("WARNING", message)

func warn(message: String):
	make_log_message("WARNING", message)

func error(message: String):
	make_log_message("ERROR", message)
