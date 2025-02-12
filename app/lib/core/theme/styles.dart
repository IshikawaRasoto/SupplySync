part of 'theme.dart';

class AppStyles {
  static ButtonStyle primaryButtonStyle() => ElevatedButton.styleFrom(
        backgroundColor: AppColors.button,
        foregroundColor: AppColors.buttonText,
        padding: const EdgeInsets.symmetric(vertical: 16),
      );

  static ButtonStyle redButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppColors.redButton,
    foregroundColor: AppColors.buttonText,
    padding: const EdgeInsets.symmetric(vertical: 16),
  );
}
