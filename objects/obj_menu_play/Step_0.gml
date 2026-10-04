// =====================================================
// 버튼 등장 애니메이션
// =====================================================

image_xscale = lerp(image_xscale, target_scale, 0.2);
image_yscale = lerp(image_yscale, target_scale, 0.2);

// 거의 원래 크기가 되면 정확히 1로 고정
if (abs(image_xscale - target_scale) < 0.01)
{
    image_xscale = target_scale;
    image_yscale = target_scale;
}