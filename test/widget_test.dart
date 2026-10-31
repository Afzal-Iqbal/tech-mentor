import 'package:flutter_test/flutter_test.dart';
import 'package:tech_saathi_ai/app/theme/app_colors.dart';

void main() {
  test('AppColors design system tokens test', () {
    expect(AppColors.primaryBrand.value, 0xFF168C83);
    expect(AppColors.primaryBackground.value, 0xFFF8FAF9);
    expect(AppColors.primaryText.value, 0xFF24332F);
  });
}
