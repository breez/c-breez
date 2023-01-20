import 'package:synchronized/synchronized.dart';

class ValidatorHolder {
  final lock = Lock();
  var valid = false;
}
