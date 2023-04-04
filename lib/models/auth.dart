
import 'package:diacritic/diacritic.dart';
import 'package:flutter_work_utils/flutter_utils.dart';

class AuthInfo {
  String _username = "";
  String get username => _username;
  String _password = "";
  String get password => _password;
  String _confirmPassword = "";
  String get confirmPassword => _confirmPassword;

  set username (String username) {
    _username = removeDiacritics(username.toLowerCase()).replaceAll(RegExp(r"\s+"), "");
  }

  set password (String password) {
    _password = password.diggest;
  }

  set confirmPassword(String password) {
    _confirmPassword = password.diggest;
  }

  AuthInfo.empty();

  Map<String, dynamic> toJsonSignup(){
    return {
      "username": username,
      "password": password,
      "confirm": confirmPassword
    };
  }

  Map<String, dynamic> toJsonLogin(){
    return {
      "username": username,
      "password": password,
    };
  }
}