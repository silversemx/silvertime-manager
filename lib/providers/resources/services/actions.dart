import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_request_utils/body_utils.dart';
import 'package:silvertime/include.dart';
import 'package:silvertime/models/resources/service/service_action.dart';
import 'package:silvertime/providers/resources/services/services.dart';

class ServiceActions extends ServicesProvider {
  List<ServiceAction> _actions = [];
  List<ServiceAction> get actions => _actions;

  int _skip = 0, _limit = 20;
  int _pages = 0;
  int get pages => _pages;

  Future<void> getActions ({int skip = 0, int limit = 20}) async {
    await services.nullCheck();

    const url = "$serverURL/api/resources/actions";

    Map<String, String> queryParams = {
      "service": services.service?.id ?? "",
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
          _actions = decoded['actions'].map<ServiceAction>(
            (action) => ServiceAction.fromJson(action)
          ).toList ();
          
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

  Future<void> _getActionsInternal () => getActions(skip: _skip, limit: _limit);

  Future<void> createAction (ServiceAction action) async {
    const url = "$serverURL/api/resources/actions/create";
    
    try {
      final res = await http.post(Uri.parse(url), 
        headers: {"Authorization": auth.token!},
        body: json.encode({
          ...action.toJson(),
          "service": services.service?.id
        })
      );
    
      switch(res.statusCode){
        case 200:
          _getActionsInternal ();
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

  Future<List<ServiceAction>> getAllActions () async {
    const url = "$serverURL/api/resources/actions";
    
    try {
      final res = await http.get(Uri.parse(url), 
        headers: {"Authorization": auth.token!}
      );
    
      switch(res.statusCode){
        case 200:
          final decoded = json.decode(res.body);
          return decoded.map<ServiceAction> (
            (action) => ServiceAction.fromJson (action)
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
}