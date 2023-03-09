/// @desc Creates a light using variables

// Create a light from the instance variables
switch(Light_Type) {
	case "Point Light":
		light = light_create_point(x, y, Light_Shadow_Length, Light_Color, Light_Range, Light_Intensity);
		sprite_index = spr_demo_point_light;
		break;
		
	case "Spot Light":
		light = light_create_spot(x, y, Light_Shadow_Length, Light_Color, Light_Range, Light_Intensity, Light_Angle, Light_Direction);
		sprite_index = spr_demo_spot_light;
		break;
		
	case "Area Light":
		light = light_create_area(x, y, Light_Shadow_Length, Light_Color, Light_Range, Light_Intensity, Light_Width, Light_Direction);
		sprite_index = spr_demo_area_light;
		image_angle = Light_Direction;
		break;
		
	case "Directional Light":
		light = light_create_directional(x, y, Light_Shadow_Length, Light_Color, Light_Range, Light_Intensity, Light_Direction);
		sprite_index = spr_demo_directional_light;
		image_angle = Light_Direction;
		break;
		
	case "Line Light":
		light = light_create_line(x, y, Light_Shadow_Length, Light_Color, Light_Range, Light_Intensity, Light_Width, Light_Direction);
		sprite_index = spr_demo_line_light;
		image_angle = Light_Direction;
		break;
}

// Set LUTs
if(LUT_Intensity != noone) {
	light[| eLight.LutIntensity] = sprite_get_texture(LUT_Intensity, 0);
}

// Add the light to the world
light_add_to_world(light);