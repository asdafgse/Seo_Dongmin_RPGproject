// =====================================
// VICTORY - RETURN TO MAIN MENU
// =====================================

if (keyboard_check_pressed(vk_escape))
{
    // 플레이어 제거 (HUD도 함께 제거)
    with (obj_player)
    {
        instance_destroy();
    }

    // 메인 메뉴로 이동
    room_goto(rm_main_menu);
}