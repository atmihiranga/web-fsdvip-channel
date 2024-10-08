import 'package:flutter/foundation.dart';

printDebug(String message) {
  if (kDebugMode) {
    print(message);
  }
}
