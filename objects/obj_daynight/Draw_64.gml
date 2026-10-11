/// obj_daynight - Draw GUI

// =====================================
// 낮 / 밤 점진적 어둠 효과
// =====================================

var max_darkness = 0.5;
var darkness = 0;

if (is_day)
{
    var progress = 1 - (day_timer / day_length);
    progress = clamp(progress, 0, 1);

    if (progress >= 0.7)
    {
        darkness = max_darkness * ((progress - 0.7) / 0.3);
    }
}
else
{
    var progress = 1 - (day_timer / night_length);
    progress = clamp(progress, 0, 1);

    if (progress < 0.7)
    {
        darkness = max_darkness;
    }
    else
    {
        darkness = max_darkness
                 * (1 - (progress - 0.7) / 0.3);
    }
}

// =====================================
// 화면 어둠 Surface
// =====================================

var gw = display_get_gui_width();
var gh = display_get_gui_height();

if (darkness > 0)
{
    var surf = surface_create(gw, gh);

    surface_set_target(surf);

    draw_clear_alpha(c_black, 0);

    // 화면 전체 어둠
    draw_set_color(c_black);
    draw_set_alpha(darkness);
    draw_rectangle(0, 0, gw, gh, false);

    draw_set_alpha(1);

    // =====================================
    // 모닥불 주변 밝히기
    // =====================================

    var cam = view_camera[0];

    var cx = camera_get_view_x(cam);
    var cy = camera_get_view_y(cam);

    var cw = camera_get_view_width(cam);
    var ch = camera_get_view_height(cam);

    gpu_set_blendmode_ext(bm_zero, bm_inv_src_alpha);

    with (obj_campfire)
    {
        var sx = (x - cx) * gw / cw;
        var sy = (y - cy) * gh / ch;

        var radius = light_radius * gw / cw;

        // 부드러운 원형 조명
        for (var i = 10; i >= 1; i--)
        {
            var r = radius * i / 10;

            draw_set_color(c_white);
            draw_set_alpha(0.25);

            draw_circle(sx, sy, r, false);
        }
    }

    gpu_set_blendmode(bm_normal);

    draw_set_alpha(1);

    surface_reset_target();

    // 어둠 Surface 표시
    draw_surface(surf, 0, 0);

    surface_free(surf);
}

draw_set_alpha(1);
draw_set_color(c_white);