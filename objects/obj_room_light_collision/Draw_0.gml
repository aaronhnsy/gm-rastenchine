if (LIGHTING_DEBUG == true) and (light != undefined) { 
	draw_self()
	draw_set_halign(fa_center)
	draw_set_valign(fa_middle)
	draw_text(x, y, string(self.id))	
	draw_text(x, y + 15, string(self))	
}
