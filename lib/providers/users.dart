import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_request_utils/body_utils.dart';
import 'package:silvertime/include.dart';
import 'package:silvertime/models/user/user.dart';
import 'package:silvertime/providers/auth.dart';

class Users extends AuthProvider {
  List<User> _users = [];
  List<User> get users => _users;

  int _userPages = 0;
  int get userPages => _userPages;
  int _skip = 0, _limit = 20;
  String? _username, _role;
  UserStatus? _status;

  Future<void> getUsers ({
    int skip = 0, int limit = 20,
    String? username, UserStatus? status, String? role
  }) async {
    await Future.delayed(const Duration (seconds: 3));

    _userPages = 1;
    const url = "$serverURL/api/users";
    
    Map<String, String> queryParams = {
      "skip": skip.toString(),
      "limit": limit.toString()
    };

    if (username != null) {
      queryParams ['username'] = username;
    }
    if (status != null) {
      queryParams ['status'] = status.index.toString();
    }
    if (role != null) {
      queryParams ['role'] = role;
    }

    _skip = skip;
    _limit = limit;
    _username = username;
    _status = status;
    _role = role;

    try {
      final res = await http.get(
        Uri.parse(url).replace(
          queryParameters: queryParams
        ), 
        headers: {"Authorization": auth.token!}
      );
    
      switch(res.statusCode){
        case 200:
          final decoded = json.decode(res.body);
          _users = decoded ['users'].map<User> (
            (user) => User.fromJson (user)
          ).toList ();

          if (limit > 0) {
            _userPages = (decoded ['count'] / limit).ceil ();
          } else {
            _userPages = 1;
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

  Future<void> _getUsersInternal () => getUsers (
    skip: _skip, limit: _limit, username: _username, status: _status, role: _role
  );

  Future<void> createUser (User user) async {
    const url = "$serverURL/api/users/create";
    
    try {
      final res = await http.post(Uri.parse(url), 
        headers: {"Authorization": auth.token!},
        body: json.encode (
          user.toJson()
        )
      );
    
      switch(res.statusCode){
        case 200:
          _getUsersInternal();
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

  Future<void> updateUser (String id, User user) async {
    final url = "$serverURL/api/users/$id/update";
    
    try {
      final res = await http.put(Uri.parse(url), 
        headers: {"Authorization": auth.token!},
        body: json.encode (
          user.toJson()
        )
      );
    
      switch(res.statusCode){
        case 200:
          _getUsersInternal();
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

  Stream<double> removeUsers (Iterable<String> users) async* {
    int total = users.length;
    int current = 0;
    for (String user in users) {
      await removeUser(user);
      yield ++current / total;
    }
    yield 1;
  }

  Future<void> removeUser (String user) async {
    final url = "$serverURL/api/users/$user/remove";
    
    try {
      final res = await http.delete(Uri.parse(url), 
        headers: {"Authorization": auth.token!},
      );
    
      switch(res.statusCode){
        case 200:
          // Fetch is made in screen controller
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