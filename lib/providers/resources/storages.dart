import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_request_utils/body_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:silvertime/include.dart';
import 'package:silvertime/models/history/status_update.dart';
import 'package:silvertime/models/resources/storage.dart';
import 'package:silvertime/providers/auth.dart';

class Storages extends AuthProvider {
  List<Storage> _storages = [];
  List<Storage> get storages => _storages;
  Storage? _storage;
  Storage? get storage => _storage;
  SharedPreferences prefs = locator<SharedPreferences> ();

  void dismiss () {
    _storage = null;
    prefs.remove ("storage");
    notifyListeners();
  }

  int _skip = 0, _limit = 20;
  int _pages = 0;
  int get pages => _pages;

  Future<void> getStorages ({int skip = 0, int limit = 20}) async {
    const  url = "$serverURL/api/resources/storages";
    
    Map<String, String> queryParams = {
      "skip": skip.toString(),
      "limit": limit.toString()
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
          _storages = decoded["storages"].map<Storage> (
            (storage) => Storage.fromJson(storage)
          ).toList();
          if (limit > 0) {
            _pages = (decoded ['count'] / limit).ceil ();
          } else {
            _pages = 1;
          }
        break;
        default:
          throw HttpException(
            res.body, route: url, code: Code.request, status: res.statusCode
          );
      }
      notifyListeners();
    } on HttpException {
      rethrow;
    } catch (error, bt) {
      if(runtime == "Development"){
        Completer().completeError(error, bt);
      }
      throw HttpException(error.toString(), code: Code.system, route: url);
    }
  }

  Future<void> _getStoragesInternal () => getStorages(
    skip: _skip, limit: _limit
  );

  void unloadStorages () => _storages = [];

  void sort (int filter, int sort) {
    if(filter == 0) {
      _storages.sort((a,b) => a.name.compareTo(b.name) * sort);
    } else if (filter == 1) {
      _storages.sort(
        (a,b) => a.date.compareTo(b.date) * sort
      );
    }
    notifyListeners();
  }

  Future<void> getStorage (String id) async {
    final url = "$serverURL/api/resources/storages/$id/info";
    
    try {
      prefs.setString ("storage", id);
      final res = await http.get(Uri.parse(url), 
        headers: {"Authorization": auth.token!}
      );
    
      switch(res.statusCode){
        case 200:
          final decoded = json.decode(res.body);
          _storage = Storage.fromJson(decoded);
        break;
        default:
          throw HttpException(
            res.body, route: url, code: Code.request, status: res.statusCode
          );
      }
      notifyListeners();
    } on HttpException {
      rethrow;
    } catch (error, bt) {
      if(runtime == "Development"){
        Completer().completeError(error, bt);
      }
      throw HttpException(error.toString(), code: Code.system, route: url);
    }
  }

  void unloadStorage () => _storage = null;

  Future<void> createStorage (Storage storage) async {
    const url = "$serverURL/api/resources/storages/create";
    
    try {
      notifyListeners();
      final res = await http.post(Uri.parse(url), 
        headers: {"Authorization": auth.token!},
        body: json.encode(storage.toJson())
      );
    
      switch(res.statusCode){
        case 200:
          _getStoragesInternal ();
        break;
        default:
          throw HttpException(
            res.body, route: url, code: Code.request, status: res.statusCode
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

  Future<void> updateStorage (String id, Storage storage) async {
    final url = "$serverURL/api/resources/storages/$id/update";
    
    try {
      final res = await http.put(Uri.parse(url), 
        headers: {"Authorization": auth.token!},
        body: json.encode (storage.toJson())
      );
    
      switch(res.statusCode){
        case 200:
          _getStoragesInternal ();
        break;
        default:
          throw HttpException(
            res.body, route: url, code: Code.request, status: res.statusCode
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

  Stream<double> removeStorages (List<String> storages) async* {
    int total = storages.length;

    int current = 0;
    for (String storage in storages) {
      await removeStorage(storage);
      yield ++current / total;
    }

    yield 1;
  }

  Future<void> removeStorage (String id) async {
    final url = "$serverURL/api/resources/storages/$id/remove";
    
    try {
      final res = await http.delete(Uri.parse(url), 
        headers: {"Authorization": auth.token!}
      );
    
      switch(res.statusCode){
        case 200:
          // Fetch in screen to calc pages
        break;
        default:
          throw HttpException(
            res.body, route: url, code: Code.request, status: res.statusCode
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

  Future<List<StatusUpdate>> getStorageStatusHistory (String id) async {
    final url = "$serverURL/api/resources/storages/$id/history";
    
    try {
      final res = await http.get(Uri.parse(url), 
        headers: {"Authorization": auth.token!}
      );
    
      switch(res.statusCode){
        case 200:
          final decoded = json.decode(res.body);
          return decoded.map<StatusUpdate<StorageStatus>> (
            (statusUpdate) => StatusUpdate.fromJson(
              statusUpdate, StorageStatus.values
            )
          ).toList ();
        default:
          throw HttpException(
            res.body, route: url, code: Code.request, status: res.statusCode
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

  Future<void> updateStorageStatus (String storage, StorageStatus status) async {
    final url = "$serverURL/api/resources/storages/$storage/status/update";
    
    try {
      final res = await http.put(Uri.parse(url), 
        headers: {"Authorization": auth.token!},
        body: json.encode ({
          "status": status.index
        })
      );
    
      switch(res.statusCode){
        case 200:
          _getStoragesInternal();
        break;
        default:
          throw HttpException(
            res.body, route: url, code: Code.request, status: res.statusCode
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