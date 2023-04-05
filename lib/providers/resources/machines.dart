import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_request_utils/body_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:silvertime/include.dart';
import 'package:silvertime/models/history/status_update.dart';
import 'package:silvertime/models/resources/machine/machine.dart';
import 'package:silvertime/models/resources/machine/machine_configuration.dart';
import 'package:silvertime/providers/auth.dart';

class Machines extends AuthProvider {
  List<Machine> _machines = [];
  List<Machine> get machines => _machines;
  Machine? _machine;
  Machine? get machine => _machine;
  SharedPreferences prefs = locator<SharedPreferences> ();

  void dismiss () {
    _machine = null;
    prefs.remove ("machine");
    notifyListeners();
  }

  Future<void> nullCheck () async {
    int failedTimes = 0;
    while (_machine == null) {
      await Future.delayed(const Duration (milliseconds: 100));

      failedTimes ++;
      if (failedTimes > 10) {
        throw HttpException("Missing machine info");
      }
    }
  }

  int _skip = 0, _limit = 20;
  int _pages = 0;
  int get pages => _pages;


  Future<void> getMachines ({int skip = 0, int limit = 20}) async {
    const  url = "$serverURL/api/resources/machines";

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
          _machines = decoded["machines"].map<Machine> (
            (machine) => Machine.fromJson(machine)
          ).toList();
          if (limit > 0) {
            _pages = (decoded ['count'] / limit).ceil();
          } else {
            _pages = 1;
          }
          notifyListeners();
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

  Future<void> _getMachinesInternal () => getMachines(skip: _skip, limit: _limit);

  void unloadMachines () => _machines = [];

  void sort (int filter, int sort) {
    if(filter == 0) {
      _machines.sort((a,b) => a.name.compareTo(b.name) * sort);
    } else if (filter == 1) {
      _machines.sort(
        (a,b) => a.date.compareTo(b.date) * sort
      );
    }
    notifyListeners();
  }

  Future<void> getMachine (String id) async {
    final url = "$serverURL/api/resources/machines/$id/info";
    
    try {
      prefs.setString ("machine", id);
      final res = await http.get(Uri.parse(url), 
        headers: {"Authorization": auth.token!}
      );
    
      switch(res.statusCode){
        case 200:
          final decoded = json.decode(res.body);
          _machine = Machine.fromJson(decoded);
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

  void unloadMachine () => _machine = null;

  Future<void> createMachine (Machine machine) async {
    const url = "$serverURL/api/resources/machines/create";
    
    try {
      notifyListeners();
      final res = await http.post(Uri.parse(url), 
        headers: {"Authorization": auth.token!},
        body: json.encode(machine.toJson())
      );
    
      switch(res.statusCode){
        case 200:
          _getMachinesInternal ();
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

  Future<void> updateMachine (String id, Machine machine) async {
    final url = "$serverURL/api/resources/machines/$id/update";
    
    try {
      final res = await http.put(Uri.parse(url), 
        headers: {"Authorization": auth.token!},
        body: json.encode (machine.toJson())
      );
    
      switch(res.statusCode){
        case 200:
          _getMachinesInternal ();
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

  Stream<double> removeMachines (Iterable<String> machines) async* {
    int total = machines.length;
    int current = 0;
    for (String machine in machines) {
      await removeMachine(machine);
      yield (++current / total);
    }

    yield 1;
  }

  Future<void> removeMachine (String id) async {
    final url = "$serverURL/api/resources/machines/$id/remove";
    
    try {
      final res = await http.delete(Uri.parse(url), 
        headers: {"Authorization": auth.token!}
      );
    
      switch(res.statusCode){
        case 200:
          // Fetch in screen to recalc current page
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

  Future<List<StatusUpdate<MachineStatus>>> getMachineStatusHistory (String id) async {
    final url = "$serverURL/api/resources/machines/$id/history";
    
    try {
      final res = await http.get(Uri.parse(url), 
        headers: {"Authorization": auth.token!}
      );
    
      switch(res.statusCode){
        case 200:
          final decoded = json.decode(res.body);
          return decoded.map<StatusUpdate<MachineStatus>> (
            (statusUpdate) => StatusUpdate.fromJson(
              statusUpdate, MachineStatus.values
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

  Future<void> updateMachineStatus (String machine, MachineStatus status) async {
    final url = "$serverURL/api/resources/machines/$machine/status/update";
    
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

  Future<MachineConfiguration> getMachineConfiguration () async {
    await nullCheck();
    final url = "$serverURL/api/resources/machines/${machine?.id}/configuration";
    
    try {
      final res = await http.get(Uri.parse(url), 
        headers: {"Authorization": auth.token!}
      );
    
      switch(res.statusCode){
        case 200:
          final decoded = json.decode(res.body);
          return MachineConfiguration.fromJson(decoded);
        case 404:
          return MachineConfiguration.empty ();
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
  
  Future<void> updateMachineConfiguration (
    MachineConfiguration configuration
    ) async {
    final url = "$serverURL/api/resources/machines/${
      machine?.id
    }/configuration/update";
    
    try {
      final res = await http.post(Uri.parse(url), 
        headers: {"Authorization": auth.token!},
        body: json.encode ({
          "machine": machine?.id,
          ...configuration.toJson()
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

}