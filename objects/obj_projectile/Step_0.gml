if (image_index > 6) { instance_destroy() }
if (image_index == 1) image_speed = 0;
range--;
if (range <= 0) speed = lerp(speed, 0, 0.1);
if (speed <= 4) image_speed = 1;