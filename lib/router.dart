import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_work_utils/models/routing_data.dart';
import 'package:page_transition/page_transition.dart';
import 'package:silvertime/include.dart';
import 'package:silvertime/layout.dart';
import 'package:silvertime/screens/home.dart';
import 'package:silvertime/screens/not_found.dart';
import 'package:silvertime/screens/resources/resources.dart';
import 'package:silvertime/screens/resources/service.dart';
import 'package:silvertime/screens/splash.dart';
import 'package:silvertime/screens/status.dart';
import 'package:silvertime/screens/users.dart';

class RouterAdmin {
  static PageTransition getMaterialPageRoute(
    component, settings, dark, {layout = false}
  ) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    if (layout) {
      component = MainLayout(child: component);
    }

    var newComponent = AnnotatedRegion<SystemUiOverlayStyle>(
      value: !dark
      ? SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent
      ) :  SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent
      ),
      child: component,
    );
    
    return PageTransition(
      child: newComponent,
      type: PageTransitionType.fade,
      settings: settings
    );
  }

  static Route<dynamic> generateRoute (
    BuildContext context, RouteSettings settings
  ) {
    try {
      RoutingData routingData = settings.name!.getRoutingData;
      String? forceRoute;

      printLog (
        'queryParameters: ${routingData.queryParameters} path: ${settings.name}'
      );

      // bool auth = true;
      // bool auth = Provider.of<Auht> (context, listen: false).tryAutoLogin ();
      if (routingData.route != "/splash") {
        // if (!auth) {
        //   printWarning ("Not authenticated");
        //   printWarning ("Redirecting");
        // }
      }

      String routeToLook = forceRoute ?? routingData.route ?? "";

      bool dark = false;
      // bool dark = Provider.of<UI> (context, listen: false).modeVal == Mode.dark;

      switch (routeToLook) {
        case HomeScreen.routeName:
          return getMaterialPageRoute (
            const HomeScreen(),
            settings, dark, layout: true
          );
        case ResourcesScreen.routeName:
          return getMaterialPageRoute(
            const ResourcesScreen (), 
            settings, dark, layout: true
          );
        case ServiceScreen.routeName:
          return getMaterialPageRoute(
            const ServiceScreen(), 
            settings, dark, layout: true
          );
        case SplashScreen.routeName:
          return getMaterialPageRoute(
            const SplashScreen (), 
            settings, dark
          );
        case StatusScreen.routeName:
          return getMaterialPageRoute(
            const StatusScreen(), 
            settings, dark, layout: true
          );
        case UsersScreen.routeName:
          return getMaterialPageRoute(
            const UsersScreen(), 
            settings, dark, layout: true
          );
        default:
          settings = settings.copyWith (
            name: "/not-found",
            arguments: {}
          );

          return getMaterialPageRoute(
            const NotFoundScreen (), 
            settings, dark
          );
      }

    } catch (error, bt) {
      Completer().completeError(error, bt);
      return MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Error on auth!'),
          ),
        ),
      );
    }
  }
}