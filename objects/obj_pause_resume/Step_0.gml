if (instance_exists(obj_pause_menu))
{
    if (obj_pause_menu.menu_open)
    {
        visible = true;

        image_xscale = lerp(image_xscale, target_scale, 0.2);
        image_yscale = lerp(image_yscale, target_scale, 0.2);

        if (abs(image_xscale - target_scale) < 0.01)
        {
            image_xscale = target_scale;
            image_yscale = target_scale;
        }
    }
    else
    {
        visible = false;
        image_index = 0;

        image_xscale = 0.7;
        image_yscale = 0.7;
    }
}