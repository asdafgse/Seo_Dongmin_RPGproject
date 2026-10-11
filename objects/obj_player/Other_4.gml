/// obj_player - Room Start

if (variable_global_exists("portal_pending"))
{
    if (global.portal_pending)
    {
        x = global.portal_target_x;
        y = global.portal_target_y;

        global.portal_pending = false;
    }
}