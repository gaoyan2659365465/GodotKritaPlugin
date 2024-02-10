@tool
extends EditorPlugin

var image_plugin : KirtaImportPlugin

func _enter_tree():
	image_plugin = KirtaImportPlugin.new()
	add_import_plugin(image_plugin)

func _exit_tree():
	remove_import_plugin(image_plugin)
	image_plugin = null

class KirtaImportPlugin extends EditorImportPlugin:
	func _get_importer_name():
		return "my.krita.plugin"
		
	func _get_visible_name():
		return "Krita"

	func _get_recognized_extensions():
		return ["kra"]

	func _get_save_extension():
		return "tres"

	func _get_resource_type():
		return "PortableCompressedTexture2D"

	func _get_preset_count():
		return 1

	func _get_preset_name(preset_index):
		return "Default"

	func _get_priority():
		return 1
		
	func _get_import_order():
		return 0
	
	func _get_option_visibility(path: String, option_name: StringName, options: Dictionary):
		return true
	
	func _get_import_options(path, preset_index):
		return [{"name": "my_option", "default_value": false}]
	
	func read_zip_file(path,file_name):
		var reader := ZIPReader.new()
		var err := reader.open(path)
		if err != OK:
			return PackedByteArray()
		var res := reader.read_file(file_name)
		reader.close()
		return res

	func _import(source_file, save_path, options, platform_variants, gen_files):
		var filename = save_path + "." + _get_save_extension()
		var krita_res = PortableCompressedTexture2D.new()
		
		var img_data = self.read_zip_file(source_file,"mergedimage.png")
		var img = Image.new()
		var err = img.load_png_from_buffer(img_data)
		krita_res.create_from_image(img,PortableCompressedTexture2D.COMPRESSION_MODE_LOSSLESS)
		var err_0 = ResourceSaver.save(krita_res, filename)
		return err_0
