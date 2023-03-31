import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_work_utils/models/routing_data.dart';
import 'package:page_transition/page_transition.dart';
import 'package:silvertime/include.dart';
import 'package:silvertime/layout.dart';
import 'package:silvertime/screens/not_found.dart';
import 'package:silvertime/screens/splash.dart';

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
        case SplashScreen.routeName:
          return getMaterialPageRoute(
            SplashScreen, 
            settings, dark
          );
        default:
          settings = settings.copyWith (
            name: "/not-found",
            arguments: {}
          );

          return getMaterialPageRoute(
            NotFoundScreen, 
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