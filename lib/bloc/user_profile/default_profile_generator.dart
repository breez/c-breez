import "dart:math";
import 'dart:ui';

import 'package:c_breez/bloc/user_profile/profile_animal.dart';
import 'package:c_breez/bloc/user_profile/profile_color.dart';
import 'package:c_breez/utils/locale.dart';

class DefaultProfile {
  final String color;
  final String animal;

  const DefaultProfile(
    this.color,
    this.animal,
  );

  String buildName(Locale locale) {
    switch (locale.languageCode) {
      case 'es':
      case 'fr':
      case 'pt':
        return "$animal $color";

      case 'en':
      case 'fi':
      default:
        return "$color $animal";
    }
  }
}

DefaultProfile generateDefaultProfile() {
  final texts = getSystemAppLocalizations();
  final random = Random();

  const colors = ProfileColor.values;
  const animals = ProfileAnimal.values;

  final randomColor = colors.elementAt(random.nextInt(colors.length));
  final randomAnimal = animals.elementAt(random.nextInt(animals.length));

  return DefaultProfile(
    randomColor.name(texts),
    randomAnimal.name(texts),
  );
}
