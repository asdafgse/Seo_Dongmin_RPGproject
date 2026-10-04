// =====================================================
// PAUSE MENU - DRAW GUI
// =====================================================

if (menu_open)
{
    var gui_w = display_get_gui_width();
    var gui_h = display_get_gui_height();

    var center_x = gui_w / 2;
    var center_y = gui_h / 2;


    // =================================================
    // 화면 어둡게
    // =================================================

    draw_set_alpha(0.6);
    draw_set_color(c_black);

    draw_rectangle(
        0,
        0,
        gui_w,
        gui_h,
        false
    );

    draw_set_alpha(1);


    // =================================================
    // 게시판
    // 0.30 = 게시판 최종 크기
    // =================================================

    draw_sprite_ext(
        spr_pause_board,
        0,
        center_x,
        center_y,
        0.55 * menu_scale,
        0.55 * menu_scale,
        0,
        c_white,
        1
    );


    // =================================================
    // 버튼 위치
    // =================================================

    var resume_x = center_x;
    var resume_y = center_y + 20;

    var exit_x = center_x;
    var exit_y = center_y + 85;


    // =================================================
    // RESUME 버튼
    // Frame 0 = 기본
    // Frame 1 = Hover
    // =================================================

    if (resume_scale > 0)
    {
        var resume_frame = 0;

        if (resume_hover)
        {
            resume_frame = 1;
        }

        draw_sprite_ext(
            spr_menu_button,
            resume_frame,
            resume_x,
            resume_y,
            resume_scale,
            resume_scale,
            0,
            c_white,
            1
        );


        // RESUME 글씨
        if (resume_scale > 0.5)
        {
            var resume_text_y = resume_y;

            // Hover 프레임일 때 글씨 살짝 아래로
            if (resume_hover)
            {
                resume_text_y += 5;
            }

            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_set_color(c_white);

            draw_text(
                resume_x,
                resume_text_y,
                "RESUME"
            );
        }
    }


    // =================================================
    // EXIT 버튼
    // =================================================

    if (exit_scale > 0)
    {
        var exit_frame = 0;

        if (exit_hover)
        {
            exit_frame = 1;
        }

        draw_sprite_ext(
            spr_menu_button,
            exit_frame,
            exit_x,
            exit_y,
            exit_scale,
            exit_scale,
            0,
            c_white,
            1
        );


        // EXIT 글씨
        if (exit_scale > 0.5)
        {
            var exit_text_y = exit_y;

            if (exit_hover)
            {
                exit_text_y += 5;
            }

            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_set_color(c_white);

            draw_text(
                exit_x,
                exit_text_y,
                "EXIT"
            );
        }
    }


    // =================================================
    // DRAW 설정 복구
    // =================================================

    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}