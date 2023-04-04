// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:intl/intl.dart';
import 'package:silvertime/values.dart';

class CookieManager {
  static void setCookie (String name, String value, {bool remove = false}) {
    final DateTime now = remove 
      ? DateTime(0) 
      : DateTime.now().add(const Duration (days: 30));

    String expires = "expires=${
      DateFormat ('EEE, MMM d, yyyy h:mm:ss').format(now.toUtc())
    } UTC;";

    document.cookie = "$name=${
      remove 
        ? "" 
        : value
    };${expires}domain=$domain;path=/;";
  }

  static void removeCookie (String name) {
    setCookie(name, "value", remove: true);
  }

  static String? getCookie (String name) {
    name = "$name=";
    String decodedCookie = Uri.decodeComponent(document.cookie!);
    List<String> cookies = decodedCookie.split(";");
    for (int i = 0; i < cookies.length; i++) {
      String cookie = cookies [i];
      if (cookie.isNotEmpty) {
        while (cookie[0] == ' ') {
          cookie = cookie.substring(1);
        }
        if (cookie.indexOf(name) == 0) {
          return cookie.substring(name.length, cookie.length);
        }
      }
    }
    return null;
  }
}