part of 'theme.dart';

Color getColorWithOpacity(Color color, double opacity) {
  return color.withAlpha(Color.getAlphaFromOpacity(opacity));
}

class AppColors {
  static const Color primary = Color.fromARGB(255, 218, 212, 198);
  static const Color text = Colors.black;
  static const Color button = Color.fromARGB(255, 44, 44, 44);
  static const Color redButton = Color.fromARGB(255, 182, 16, 33);
  static const Color disabledButton = Color.fromARGB(255, 95, 95, 95);
  static const Color grey = Colors.grey;
  static const Color white = Colors.white;
  static const Color blue = Colors.blue;
  static const Color deepPurple = Colors.deepPurple;
  static const Color orange = Colors.orange;
  static const Color buttonText = Colors.white;
  static const Color green = Colors.green;
  static final Color red = Color(0xFFD50718);
}
