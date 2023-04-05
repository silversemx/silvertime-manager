import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_request_utils/body_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:silvertime/include.dart';
import 'package:silvertime/models/resources/network.dart';
import 'package:silvertime/providers/auth.dart';

class Networks extends AuthProvider {
  List<Network> _networks = [];
  List<Network> get networks => _networks;
  Network? _network;
  Network? get network => _network;
  SharedPreferences prefs = locator<SharedPreferences> ();

  void dismiss () {
    prefs.remove ("network");
    unloadNetwork();
    unloadNetworks();
  }

  int _skip = 0, _limit = 20;
  int _pages = 0;
  int get pages => _pages;

  Future<void> getNetworks ({int skip = 0, int limit = 20}) async {
    const  url = "$serverURL/api/resources/networks";

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
          _networks = decoded["networks"].map<Network> (
            (network) => Network.fromJson(network)
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

  Future<void> _getNetworksInternal () => getNetworks(
    skip: _skip, limit: _limit
  );

  void unloadNetworks () => _networks = [];

  void sort (int filter, int sort) {
    if(filter == 0) {
      _networks.sort((a,b) => a.name.compareTo(b.name) * sort);
    } else if (filter == 1) {
      _networks.sort(
        (a,b) => a.date.compareTo(b.date) * sort
      );
    }
    notifyListeners();
  }

  Future<void> getNetwork (String id) async {
    final url = "$serverURL/api/resources/networks/$id/info";
    
    try {
      prefs.setString ("network", id);
      final res = await http.get(Uri.parse(url), 
        headers: {"Authorization": auth.token!}
      );
    
      switch(res.statusCode){
        case 200:
          final decoded = json.decode(res.body);
          _network = Network.fromJson(decoded);
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

  void unloadNetwork () => _network = null;

  Future<void> createNetwork (Network network) async {
    const url = "$serverURL/api/resources/networks/create";
    
    try {
      notifyListeners();
      final res = await http.post(Uri.parse(url), 
        headers: {"Authorization": auth.token!},
        body: json.encode(network.toJson())
      );
    
      switch(res.statusCode){
        case 200:
          _getNetworksInternal();
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

  Future<void> updateNetwork (String id, Network network) async {
    final url = "$serverURL/api/resources/networks/$id/update";
    
    try {
      final res = await http.put(Uri.parse(url), 
        headers: {"Authorization": auth.token!},
        body: json.encode (network.toJson())
      );
    
      switch(res.statusCode){
        case 200:
          _getNetworksInternal();
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

  Stream<double> removeNetworks (Iterable<String> networks) async* {
    int total = networks.length;

    int current = 0;
    for (String network in networks) {
      await removeNetwork(network);
      yield ++current / total;
    }

    yield 1;
  }

  Future<void> removeNetwork (String id) async {
    final url = "$serverURL/api/resources/networks/$id/remove";
    
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

  // Future<List<NetworkStatusUpdate>> getNetworkStatusHistory (String id) async {
  //   final url = serverURL + "/api/resources/networks/$id/history";
    
  //   try {
  //     final res = await http.get(Uri.parse(url), 
  //       headers: {"Authorization": auth.token!}
  //     );
    
  //     switch(res.statusCode){
  //       case 200:
  //         final decoded = json.decode(res.body);
  //         return decoded.map<NetworkStatusUpdate> (
  //           (statusUpdate) => NetworkStatusUpdate.fromJson(statusUpdate)
  //         ).toList ();
  //       default:
  //         throw HttpException(
          //   res.body, route: url, code: Code.request, status: res.statusCode
          // );
  //     }
  //   } on HttpException {
  //     rethrow;
  //   } catch (error, bt) {
  //     if(runtime == "Development"){
  //       Completer().completeError(error, bt);
  //     }
  //     throw HttpException(error.toString(), code: Code.system, route: url);
  //   }
  // }

}