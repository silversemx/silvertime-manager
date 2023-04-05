import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_request_utils/body_utils.dart';
import 'package:silvertime/include.dart';
import 'package:silvertime/models/resources/service/service_instance.dart';
import 'package:silvertime/providers/resources/services/services.dart';

class ServiceInstances extends ServicesProvider {
  List<ServiceInstance> _instances = [];
  List<ServiceInstance> get instances => _instances;
  
  int _skip = 0, _limit = 20;
  int _pages = 0;
  int get pages => _pages;

  Future<void> getInstances ({int skip = 0, int limit = 20}) async {
    await services.nullCheck();
    
    String url = "$serverURL/api/resources/instances?service=${
      services.service?.id
    }";

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
          _instances = decoded["instances"].map<ServiceInstance>(
            (instance) => ServiceInstance.fromJson(instance)
          ).toList ();
          if (limit > 0) {
            _pages = (decoded ["count"] / limit).ceil ();
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
  void unloadInstances () => _instances = [];

  Future<void> _getInstancesInternal () => getInstances(skip: _skip, limit: _limit);

  Future<void> createInstance (ServiceInstance instance) async{
    const url = "$serverURL/api/resources/instances/create";
    
    try {
      final res = await http.post(Uri.parse(url), 
        headers: {"Authorization": auth.token!},
        body: json.encode (
          {
            ...instance.toJson(),
            "service": services.service?.id
          }
        )
      );
    
      switch(res.statusCode){
        case 200:
          _getInstancesInternal ();
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

  Future<void> updateInstance (ServiceInstance instance) async {
    final url = "$serverURL/api/resources/instances/${instance.id}/update";
    
    try {
      final res = await http.put(Uri.parse(url), 
        headers: {"Authorization": auth.token!},
        body: json.encode ({
          "service": services.service?.id,
          ...instance.toJson()
        })
      );
    
      switch(res.statusCode){
        case 200:
          _getInstancesInternal ();
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

  Stream<double> removeInstances (List<String> instances) async* {
    int total = instances.length;

    int current = 0;
    for (String instance in instances) {
      await removeInstance(instance);
      yield ++current / total;
    }

    yield 1;
  }

  Future<void> removeInstance (String instance) async {
    final url = "$serverURL/api/resources/instances/$instance/remove";
    
    try {
      final res = await http.delete(Uri.parse(url), 
        headers: {"Authorization": auth.token!}
      );
    
      switch(res.statusCode){
        case 200:
          // Fetch in screen to calc current page
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