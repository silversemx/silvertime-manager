import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:silvertime/include.dart';
import 'package:silvertime/providers.dart';
import 'package:silvertime/providers/ui.dart';
import 'package:silvertime/router.dart';
import 'package:silvertime/screens/splash.dart';
import 'package:silvertime/style/themes.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized ();
  setPathUrlStrategy();
  await setupLocator ();
  runApp(const SilverTime());
}

class SilverTime extends StatefulWidget {
  const SilverTime({super.key});

  @override
  State<SilverTime> createState() => _SilverTimeState();
}

class _SilverTimeState extends State<SilverTime> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();

  @override
  void didChangeDependencies() {
    precacheImage(const AssetImage ("assets/logos/silvertime.png"), context);
    precacheImage(const AssetImage ("assets/logos/silvertime0.5.png"), context);
    precacheImage(const AssetImage ("assets/logos/silvertime_white.png"), context);
    precacheImage(const AssetImage ("assets/logos/silvertime_white0.5.png"), 
      context
    );
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setApplicationSwitcherDescription(
      ApplicationSwitcherDescription(
      label: appName,
        primaryColor: Theme.of(context).primaryColor.value, // This line is required
      )
    );

    return MultiProvider(
      providers: [
        ...mainProviders,
        ...userProviders,
        ...resourceProviders,
      ],
      child: Consumer<UI>(
        builder: (ctx, ui, _) {
          ui.fetchSettings ();
          //Provider.of<Auth> (context, listen: false).tryAutoLogin ();
          return MaterialApp(
            title: appName,
            debugShowCheckedModeBanner: runtime == "Test",
            scaffoldMessengerKey: _scaffoldKey,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ThemeMode.light,
            initialRoute: SplashScreen.routeName,
            navigatorKey: locator<NavigationService> ().navigatorKey,
            builder: (cx, child) {
              return ScrollConfiguration(
                behavior: ScrollClean ().copyWith(
                  scrollbars: false
                ), 
                child: child ?? Container ()
              );
            },
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate
            ],
            supportedLocales: S.delegate.supportedLocales,
            locale: Locale (ui.locale),
            onGenerateRoute: (settings) => RouterAdmin.generateRoute (
              context, settings
            ),
            navigatorObservers: [
              locator<RouteObserver> ()
            ],
          );
        }, 
      ),
    );
  }
}