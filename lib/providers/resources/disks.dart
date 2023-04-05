import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_request_utils/body_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:silvertime/include.dart';
import 'package:silvertime/models/history/status_update.dart';
import 'package:silvertime/models/resources/disk.dart';
import 'package:silvertime/models/resources/storage.dart';
import 'package:silvertime/providers/auth.dart';

class Disks extends AuthProvider {
  List<Disk> _disks = [];
  List<Disk> get disks => _disks;
  Disk? _disk;
  Disk? get disk => _disk;
  SharedPreferences prefs = locator<SharedPreferences> ();

  void dismiss () {
    prefs.remove ("disk");
    unloadDisk();
    unloadDisks ();
  }

  Future<void> nullCheck () async {
    int failedTimes = 0;
    while (_disk == null) {
      await Future.delayed(const Duration (milliseconds: 100));

      failedTimes ++;
      if (failedTimes > 10) {
        throw HttpException("Missing disk info");
      }
    }
  }

  int _skip = 0, _limit = 20;
  int _pages = 0;
  int get pages => _pages;

  Future<void> getDisks ({int skip = 0, int limit = 20}) async {
    const  url = "$serverURL/api/resources/disks";

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
          _disks = decoded["disks"].map<Disk> (
            (disk) => Disk.fromJson(disk)
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

  Future<void> _getDisksInternal () => getDisks(
    skip: _skip, limit: _limit
  );

  void unloadDisks () => _disks = [];

  void sort (int filter, int sort) {
    if(filter == 0) {
      _disks.sort((a,b) => a.name.compareTo(b.name) * sort);
    } else if (filter == 1) {
      _disks.sort(
        (a,b) => a.date.compareTo(b.date) * sort
      );
    }
    notifyListeners();
  }

  Future<void> getDisk (String id) async {
    final url = "$serverURL/api/resources/disks/$id/info";
    
    try {
      prefs.setString ("disk", id);
      final res = await http.get(Uri.parse(url), 
        headers: {"Authorization": auth.token!}
      );
    
      switch(res.statusCode){
        case 200:
          final decoded = json.decode(res.body);
          _disk = Disk.fromJson(decoded);
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

  void unloadDisk () => _disk = null;

  Future<void> createDisk (Disk disk) async {
    const url = "$serverURL/api/resources/disks/create";
    
    try {
      notifyListeners();
      final res = await http.post(Uri.parse(url), 
        headers: {"Authorization": auth.token!},
        body: json.encode(disk.toJson())
      );
    
      switch(res.statusCode){
        case 200:
          _getDisksInternal ();
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

  Future<void> updateDisk (String id, Disk disk) async {
    final url = "$serverURL/api/resources/disks/$id/update";
    
    try {
      final res = await http.put(Uri.parse(url), 
        headers: {"Authorization": auth.token!},
        body: json.encode (disk.toJson())
      );
    
      switch(res.statusCode){
        case 200:
          _getDisksInternal ();
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

  Stream<double> removeDisks (Iterable<String> disks) async* {
    int total = disks.length;

    int current = 0;
    for (String disk in disks) {
      await removeDisk(disk);
      yield ++current / total;
    }

    yield 1;
  }

  Future<void> removeDisk (String id) async {
    final url = "$serverURL/api/resources/disks/$id/remove";
    
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

  Future<List<StatusUpdate<DiskStatus>>> getDiskStatusHistory (String id) async {
    final url = "$serverURL/api/resources/disks/$id/history";
    
    try {
      final res = await http.get(Uri.parse(url), 
        headers: {"Authorization": auth.token!}
      );
    
      switch(res.statusCode){
        case 200:
          final decoded = json.decode(res.body);
          return decoded.map<StatusUpdate<DiskStatus>> (
            (statusUpdate) => StatusUpdate.fromJson(
              statusUpdate, DiskStatus.values
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

  Future<void> updateDiskStatus (String disk, DiskStatus status) async {
    final url = "$serverURL/api/resources/disks/$disk/status/update";
    
    try {
      final res = await http.put(Uri.parse(url), 
        headers: {"Authorization": auth.token!},
        body: json.encode ({
          "status": status.index
        })
      );
    
      switch(res.statusCode){
        case 200:
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

  Future<void> getStorages ({int skip = 0, int limit = 20}) async {
    
    await nullCheck();

    final url = "$serverURL/api/resources/storages?disk=${_disk?.id}";
    
    try {
      final res = await http.get(Uri.parse(url), 
        headers: {"Authorization": auth.token!}
      );
    
      switch(res.statusCode){
        case 200:
          final decoded = json.decode(res.body);
          _disk?.storages = decoded["storages"].map<Storage> ((storage) => Storage.fromJson(storage)).toList ();
          _disk?.pages = (decoded ["count"] / limit).ceil ();
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

  void unloadStorages () => disk?.storages = [];

}