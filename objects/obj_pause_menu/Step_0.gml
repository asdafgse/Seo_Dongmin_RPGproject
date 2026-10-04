// =====================================================
// ESC - 메뉴 열기 / 닫기
// =====================================================

if (keyboard_check_pressed(vk_escape))
{
    menu_open = !menu_open;

    // 메뉴를 새로 열었을 때
    if (menu_open)
    {
        menu_scale = 0;

        button_timer = 0;
        resume_scale = 0;
        exit_scale = 0;

        resume_hover = false;
        exit_hover = false;
    }
}


// =====================================================
// 메뉴가 닫혀 있으면
// =====================================================

if (!menu_open)
{
    resume_hover = false;
    exit_hover = false;
    exit;
}


// =====================================================
// 게시판 등장 애니메이션
// =====================================================

menu_scale = lerp(
    menu_scale,
    1,
    0.2
);

if (abs(menu_scale - 1) < 0.01)
{
    menu_scale = 1;
}


// =====================================================
// 게시판이 나온 후 버튼 등장
// =====================================================

if (menu_scale >= 0.95)
{
    button_timer++;

    // RESUME 먼저 등장
    if (button_timer >= 5)
    {
        resume_scale = lerp(
            resume_scale,
            1,
            0.25
        );

        if (abs(resume_scale - 1) < 0.01)
        {
            resume_scale = 1;
        }
    }

    // EXIT은 조금 늦게 등장
    if (button_timer >= 12)
    {
        exit_scale = lerp(
            exit_scale,
            1,
            0.25
        );

        if (abs(exit_scale - 1) < 0.01)
        {
            exit_scale = 1;
        }
    }
}


// =====================================================
// GUI 크기 / 중앙 위치
// =====================================================

var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();

var center_x = gui_w / 2;
var center_y = gui_h / 2;


// =====================================================
// 버튼 위치
// =====================================================

var resume_x = center_x;
var resume_y = center_y + 20;

var exit_x = center_x;
var exit_y = center_y + 85;


// =====================================================
// GUI 마우스 위치
// =====================================================

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);


// =====================================================
// 클릭 영역 크기
// =====================================================

var button_w = 200;
var button_h = 45;


// =====================================================
// RESUME Hover
// 버튼이 충분히 나온 뒤에만 작동
// =====================================================

if (resume_scale > 0.8)
{
    resume_hover = point_in_rectangle(
        mx,
        my,
        resume_x - button_w / 2,
        resume_y - button_h / 2,
        resume_x + button_w / 2,
        resume_y + button_h / 2
    );
}
else
{
    resume_hover = false;
}


// =====================================================
// EXIT Hover
// =====================================================

if (exit_scale > 0.8)
{
    exit_hover = point_in_rectangle(
        mx,
        my,
        exit_x - button_w / 2,
        exit_y - button_h / 2,
        exit_x + button_w / 2,
        exit_y + button_h / 2
    );
}
else
{
    exit_hover = false;
}


// =====================================================
// 마우스 클릭
// =====================================================

if (mouse_check_button_pressed(mb_left))
{
    // RESUME
    if (resume_hover)
    {
        audio_play_sound(
            snd_ui_click,
            1,
            false
        );

        menu_open = false;
    }

    // EXIT
    else if (exit_hover)
    {
        audio_play_sound(
            snd_ui_click,
            1,
            false
        );

        room_goto(rm_main_menu);
    }
}