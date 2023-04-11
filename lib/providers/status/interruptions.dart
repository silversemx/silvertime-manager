import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_request_utils/body_utils.dart';
import 'package:silvertime/include.dart';
import 'package:silvertime/models/history/status_update.dart';
import 'package:silvertime/models/status/interruption/interruption.dart';
import 'package:silvertime/providers/auth.dart';

class Interruptions extends AuthProvider {
  List<Interruption> _interruptions = [];
  List<Interruption> get interruptions => _interruptions;

  void dismiss () {
    _interruptions = [];
  }

  int _skip = 0, _limit = 20;
  int _pages = 0;
  int get pages => _pages;

  Future<void> getInterruptions ({int skip = 0, int limit = 20}) async {
    const url = "$serverURL/api/state/interruptions";

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
          _interruptions = decoded ['interruptions'].map<Interruption> (
            (interruption) => Interruption.fromJson(interruption)
          ).toList ();

          if (limit > 0) {
            _pages = (decoded ['count'] / limit).ceil ();
          } else {
            _pages = 1;
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

  Future<void> _getInterruptionsInternal () => getInterruptions(
    skip: _skip, limit: _limit
  );

  Future<void> createInterruption (Interruption interruption) async {
    const url = "$serverURL/api/state/interruptions/create";
    
    try {
      final res = await http.post(Uri.parse(url), 
        headers: {"Authorization": auth.token!},
        body: json.encode (interruption.toJson())
      );
    
      switch(res.statusCode){
        case 200:
          _getInterruptionsInternal ();
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

  Future<void> updateInterruption (String id, Interruption interruption) async {
    final url = "$serverURL/api/state/interruptions/$id/update";
    
    try {
      final res = await http.put(Uri.parse(url), 
        headers: {"Authorization": auth.token!},
        body: json.encode (interruption.toJson())
      );
    
      switch(res.statusCode){
        case 200:
          _getInterruptionsInternal ();
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

  Future<void> solveInterruption (
    String id, String solution, DateTime end, Duration duration
  ) async {
    final url = "$serverURL/api/state/interruptions/$id/solved";
    
    try {
      final res = await http.post(Uri.parse(url), 
        headers: {"Authorization": auth.token!},
        body: json.encode ({
          "solution": solution,
          "end": end.millisecondsSinceEpoch,
          "duration": duration.inMilliseconds
        })
      );
    
      switch(res.statusCode){
        case 200:
          _getInterruptionsInternal();
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


  Stream<double> removeInterruptions (Iterable<String> interruptions) async* {
    int total = interruptions.length;
    int current = 0;
    for (String id in interruptions) {
      await removeInterruption(id);
      yield total / current;
    }
    yield 1;
  }

  Future<void> removeInterruption (String id) async {
    const url = "$serverURL/api/state/interruptions/create";
    
    try {
      final res = await http.delete(Uri.parse(url), 
        headers: {"Authorization": auth.token!},
      );
    
      switch(res.statusCode){
        case 200:
          // Fetch in screen to calc pages
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

  Future<List<StatusUpdate<InterruptionStatus>>> getInterruptionStatusHistory (
    String id
  ) async {
    final url = "$serverURL/api/state/interruptions/$id/status/history";
    
    try {
      final res = await http.get(Uri.parse(url), 
        headers: {"Authorization": auth.token!}
      );
    
      switch(res.statusCode){
        case 200:
          final decoded = json.decode(res.body);
          return decoded.map<StatusUpdate<InterruptionStatus>> (
            (statusUpdate) => StatusUpdate.fromJson(
              statusUpdate, InterruptionStatus.values
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

  Future<void> updateInterruptionStatus (
    String interruption, InterruptionStatus status
  ) async {
    final url = "$serverURL/api/state/interruptions/$interruption/status/update";
    
    try {
      final res = await http.put(Uri.parse(url), 
        headers: {"Authorization": auth.token!},
        body: json.encode ({
          "status": status.index
        })
      );
    
      switch(res.statusCode){
        case 200:
          _getInterruptionsInternal();
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