func scan_directory(path):
    var directory = Directory.new()
	if directory.open(path) == OK:
		directory.list_dir_begin()
		var file_name = directory.get_next()
		while file_name != "":
			# useless faction for the level
			if file_name == ".":
				pass
			elif directory.current_is_dir():
				print("encountered folder ", file_name)
            else:
                print("encountered file", file_name)

			file_name = directory.get_next()
	else:
		print("directory on path does not exist")