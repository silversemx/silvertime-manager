import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_request_utils/body_utils.dart';
import 'package:silvertime/include.dart';
import 'package:silvertime/models/resources/service/service_option.dart';
import 'package:silvertime/providers/resources/services/services.dart';

class ServiceOptions extends ServicesProvider {
  List<ServiceOption> _options = [];
  List<ServiceOption> get options => _options;

  int _skip = 0, _limit = 20;
  int _pages = 0;
  int get pages => _pages;

  Future<void> getServiceOptions ({int skip = 0, int limit = 20}) async {
    const url = "$serverURL/api/resources/options";

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
          _options = decoded["options"].map<ServiceOption> ((option) => ServiceOption.fromJson(option)).toList ();
          notifyListeners();
          if (limit > 0) {
            _pages = (decoded ['count'] / limit).ceil ();
          } else {
            _pages = 1;
          }
        break;
        default:
          throw HttpException(res.body, code: Code.request, status: res.statusCode, route: url);
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

  Future<void> _getServiceOptionsInternal () => getServiceOptions(
    skip: _skip, limit: _limit
  );

  void unloadServiceOptions () => _options = [];

  Future<void> createServiceOption (ServiceOption option) async {
    const url = "$serverURL/api/resources/options/create";
    
    try {
      final res = await http.post(Uri.parse(url), 
        headers: {"Authorization": auth.token!},
        body: json.encode ({
          ...option.toJson(),
        })
      );
    
      switch(res.statusCode){
        case 200:
          _getServiceOptionsInternal ();
        break;
        default:
          throw HttpException(res.body, code: Code.request, status: res.statusCode, route: url);
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

  Future<void> updateServiceOption (String id, ServiceOption option) async {
    final url = "$serverURL/api/resources/options/$id/update";
    
    try {
      final res = await http.put(Uri.parse(url), 
        headers: {"Authorization": auth.token!},
        body: json.encode ({
          ...option.toJson(),
        })
      );
    
      switch(res.statusCode){
        case 200:
          _getServiceOptionsInternal ();
        break;
        default:
          throw HttpException(res.body, code: Code.request, status: res.statusCode, route: url);
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