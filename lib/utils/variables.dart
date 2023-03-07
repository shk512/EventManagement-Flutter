import 'package:event_management/services/spf.dart';
import 'package:geolocator/geolocator.dart';

enum myTab { mail, phone }

enum Menu { edit, delete }

enum Time { morning, evening, both }

enum Type { perhead, lumpsum }

enum Hall { nothing }

class Variable {
  static String? selectedHall;
}

class location {
  static String? currentAddress;
}
