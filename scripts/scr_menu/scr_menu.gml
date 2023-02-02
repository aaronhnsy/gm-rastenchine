#macro MENU_START_X 20
#macro PAGE_START_Y 20
#macro SUB_PAGE_START_Y 100
#macro ELEMENT_PADDING 20
#macro ELEMENT_MARGIN 5
#macro ELEMENT_FONT_TUNING 2

function render_page() {
	
	draw_set_font(fnt_menu)
	draw_set_halign(fa_left)
	draw_set_valign(fa_middle)
	
	var ELEMENT_HEIGHT = string_height("HEIGHT") + ELEMENT_PADDING
	
	#region Pages
	var page = pages[selected_page]
	var page_x = MENU_START_X
	for (var i = 0; i < array_length(page); i++) {
		var element = page[i]
		var text = element[0]
		var element_width = string_width(text) + ELEMENT_PADDING
		array_push(
			instances, 
			instance_create_layer(
				page_x, 
				PAGE_START_Y,
				"Instances",
				obj_element,
				{
					WIDTH: element_width,
					HEIGHT: ELEMENT_HEIGHT,
					TEXT: text,
					SELECTED: (selected_sub_page == undefined ? false : (selected_sub_page + 1) == i),
					ACTION: element[1],
					FUNCTION: element[2],
					ARG_0: element[3],
					ARG_1: element[4]
				}
			)
		)
		page_x += element_width + ELEMENT_MARGIN
	}
	#endregion

	#region Sub Pages
	if (selected_sub_page != undefined) {
		var sub_page = sub_pages[selected_sub_page]
		var element_width = array_max(array_map(sub_page, function(element) {return string_width(element[@ 0]) + ELEMENT_PADDING}))
		for (var i = 0; i < array_length(sub_page); i++) {
			var element = sub_page[i]
			var text = element[0]
			array_push(
				instances, 
				instance_create_layer(
					MENU_START_X, 
					SUB_PAGE_START_Y + ((ELEMENT_HEIGHT + ELEMENT_MARGIN) * i),
					"Instances", 
					obj_element,
					{
						WIDTH: element_width,
						HEIGHT: ELEMENT_HEIGHT,
						TEXT: text,
						SELECTED: false,
						ACTION: element[1],
						FUNCTION: element[2],
						ARG_0: element[3],
						ARG_1: element[4]
					}
				)
			)
		}
	}
	#endregion
}

function change_page(page, sub_page) {
	with (obj_menu) {
		selected_page = page
		selected_sub_page = sub_page
		array_map_ext(instances, function(element) {instance_destroy(element)})
		array_resize(instances, 0)
		render_page()
	}
}
