import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_request_utils/body_utils.dart';
import 'package:silvertime/include.dart';
import 'package:silvertime/models/user/role.dart';
import 'package:silvertime/providers/auth.dart';

class Roles extends AuthProvider {
  List<Role> roles = [];

  int _skip = 0, _limit = 20;
  int _rolePages = 0;

  int get rolePages => _rolePages;

  Future<void> getRoles ({int skip = 0, int limit = 20}) async {
    const url = "$serverURL/api/admin/roles";

    Map<String, String> queryParams = {
      "skip": skip.toString(),
      "limit": limit.toString(),
    };

    _skip = skip;
    _limit = limit;
    
    try {
      final res = await http.get(
        Uri.parse(url).replace(queryParameters: queryParams), 
        headers: {"Authorization": auth.token!}
      );
    
      switch(res.statusCode){
        case 200:
          final decoded = json.decode(res.body);
          roles = decoded ['roles'].map<Role> (
            (role) => Role.fromJson (role)
          ).toList ();

          if (limit > 0) {
            _rolePages = (decoded ['count'] / limit).ceil ();
          } else {
            _rolePages = 1;
          }
          notifyListeners();
        break;
        default:
          throw HttpException(
            res.body, code: Code.request, status: res.statusCode, route: url
          );
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

  Future<void> _getRolesInternal () => getRoles(skip: _skip, limit: _limit);
  
  Future<void> createRole (Role role) async {
    const url = "$serverURL/api/admin/roles/create";
    
    try {
      final res = await http.post(Uri.parse(url), 
        headers: {"Authorization": auth.token!},
        body: json.encode (role.toJson())
      );
    
      switch(res.statusCode){
        case 200:
          _getRolesInternal();
        break;
        default:
          throw HttpException(
            res.body, code: Code.request, status: res.statusCode, route: url
          );
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

  Future<void> updateRole (String id, Role role) async {
    final url = "$serverURL/api/admin/roles/$id/update";
    
    try {
      final res = await http.put(Uri.parse(url), 
        headers: {"Authorization": auth.token!},
        body: json.encode (role.toJson())
      );
    
      switch(res.statusCode){
        case 200:
          _getRolesInternal();
        break;
        default:
          throw HttpException(
            res.body, code: Code.request, status: res.statusCode, route: url
          );
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

  Future<void> removeRole (String id) async {
    final url = "$serverURL/api/admin/roles/$id/remove";
    
    try {
      final res = await http.get(Uri.parse(url), 
        headers: {"Authorization": auth.token!}
      );
    
      switch(res.statusCode){
        case 200:
          // Fetch is made in screen
        break;
        default:
          throw HttpException(
            res.body, code: Code.request, status: res.statusCode, route: url
          );
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


}