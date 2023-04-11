import 'dart:async';
import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:http/http.dart' as http;
import 'package:http_request_utils/body_utils.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:silvertime/cookies.dart';
import 'package:silvertime/include.dart';
import 'package:silvertime/models/user/user.dart';

class AuthProvider extends ChangeNotifier {
  late Auth _auth;

  Auth get auth => _auth;

  void update (Auth auth) {
    _auth = auth;
  }
}

class Auth extends ChangeNotifier {
  String? _token;
  bool get isAuth => _token != null;

  String? get token => _token;

  User? _userValues;
  User? get userValues => _userValues;
  bool _checkingAccess = false;

  void redirect() {
    String url = loginURL;

    html.window.open(url, "_self", "");
  }

  Future<void> checkToken() async {
    if(token == null) {
      return;
    }
    const url = "$serverURL/api/users/auth";
    
    try {
      final res = await http.get(Uri.parse(url), 
        headers: {"Authorization": token!}
      );
    
      switch(res.statusCode){
        case 401:
          String? token = CookieManager.getCookie(jwtKey);
          if(token != null){
            CookieManager.removeCookie(jwtKey);
          }
          _token = null;
          _userValues = null;
          notifyListeners();
        break;

      }
    } on HttpException {
      rethrow;
    } catch (error, bt) {
      if(runtime == "Development"){
        Completer().completeError(error, bt);
      }
      throw HttpException(error.toString(), code: Code.system, route: url);
    }
  }

  Future<void> checkAccess () async {
    if (_checkingAccess) {
      return;
    }
    _checkingAccess = true;
    const url = "$serverURL/api/apps/access?app=$alias";
    
    try {
      final res = await http.get(Uri.parse(url), 
        headers: {"Authorization": token!}
      );

      _checkingAccess = false;
    
      switch(res.statusCode){
        case 200:
        break;
        default:
          printWarning ("Not authorized, redirecting!");
          redirect ();
      }
    } on HttpException {
      rethrow;
    } catch (error, bt) {
      if(runtime == "Development"){
        Completer().completeError(error, bt);
      }
      throw HttpException(error.toString(), code: Code.system, route: url);
    }
  }

  bool tryAutoLogin() {
    _token = CookieManager.getCookie(jwtKey);
    if (_token == null && forcedBearerToken.isNotEmpty) {
      _token = "Bearer $forcedBearerToken";
      CookieManager.setCookie(jwtKey, _token!);
    }
    
    if(_token == null) {
      return false;
    }

    printSuccess("Authenticated");
    _userValues = User.fromToken(Jwt.parseJwt(_token!));
    return true;
  }

  Future<void> getInfo([String? id]) async {
    final url = "$serverURL/api/users/${id??_userValues?.id??"NoId"}/info";

    try {
      final res = await http.get(Uri.parse(url), 
        headers: {"Authorization": token!}
      );
    
      switch(res.statusCode){
        case 200:
          final decoded = json.decode(res.body);
          _userValues = User.fromJson(decoded);
          notifyListeners();
        break;
        default:
          throw HttpException(
            res.body, route: url, status: res.statusCode, code: Code.request
          );
      }
    } on HttpException {
      rethrow;
    } catch (error) {
      throw HttpException(error.toString(), code: Code.system, route: url);
    }
  }

  Future<void> _internalLogout () async {
    const url = "$serverURL/api/users/logout";
    
    try {
      final res = await http.get(Uri.parse(url), 
        headers: {"Authorization": token!}
      );
    
      switch(res.statusCode){
        case 200:
        break;
        default:
          //ERROR LOGGING OUT
        break;
      }
    } on HttpException {
      rethrow;
    } catch (error, bt) {
      if(runtime == "Development"){
        Completer().completeError(error, bt);
      }
      throw HttpException(error.toString(), code: Code.system, route: url);
    }
  }

  void logout () async{
    await _internalLogout();
    CookieManager.setCookie(jwtKey, '', remove:true);
  }

}