import 'dart:ui';

class BreezColors {
  BreezColors._(); // this basically makes it so you can instantiate this class

  static const Map<int, Color> blue = <int, Color>{
    200: Color.fromRGBO(0, 117, 255, 1.0),
    300: Color.fromRGBO(51, 69, 96, 1.0),
    500: Color.fromRGBO(5, 93, 235, 1.0),
    800: Color.fromRGBO(51, 255, 255, 0.3),
    900: Color.fromRGBO(19, 85, 191, 1.0),
  };

  static const Map<int, Color> white = <int, Color>{
    200: Color(0x99ffffff),
    300: Color(0xccffffff),
    400: Color(0xdeffffff),
    500: Color(0xFFffffff),
  };

  static const Map<int, Color> grey = <int, Color>{
    500: Color(0xFF4d5d75),
    600: Color(0xFF334560),
  };

  static const Map<int, Color> red = <int, Color>{
    500: Color(0xFFff2036),
    600: Color(0xFFff1d24),
  };
  static const Map<int, Color> logo = <int, Color>{
    1: Color.fromRGBO(0, 156, 249, 1.0),
    2: Color.fromRGBO(0, 137, 252, 1.0),
    3: Color.fromRGBO(0, 120, 253, 1.0),
  };
}
