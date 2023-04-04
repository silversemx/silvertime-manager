import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:silvertime/include.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const String routeName = "/splash";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

enum CirclesSide {
  left,
  right
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin{
  late AnimationController _animationController;
  late Animation<double> _logoOpacity;
  late Animation<double> _logoBeat;
  late Animation<double> _titleOpacity;
  late Animation<double> _circlesPosition;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    initAnimation ();
  }

  void initAnimation () async {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration (seconds: 4)
    );

    _logoOpacity = Tween<double> (begin: 0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController, 
        curve: const Interval (
          0.0, 0.8,
          curve: Curves.fastOutSlowIn
        )
      )
    );

    _logoBeat = Tween<double> (begin: -0.5, end: 1.0).animate(
      CurvedAnimation (
        parent: _animationController,
        curve: const Interval (
          0.0, 1.0,
          curve: Curves.elasticInOut
        )
      )
    );

    _circlesPosition = Tween<double> (begin: 2, end: 0.4).animate(
      CurvedAnimation(
        parent: _animationController, 
        curve: const Interval (
          0.0, 0.5,
          curve: Curves.elasticInOut
        )
      )
    );

    _titleOpacity = Tween<double> (begin: 0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController, 
        curve: const Interval (
          // 0.0,0.0,
          0.4, 0.8,
          curve: Curves.fastOutSlowIn
        )
      )
    );

    _animationController.forward();
    _animationController.addListener(() {
      if (_animationController.isCompleted) {
        setState(() {
          _loading = true;
        });
        // TODO: Make some requests
        setState(() {
          _loading = false;
        });

        Navigator.of (context).pushReplacementNamed("/home");
      }
    });
  }

  

  List<Widget> _circles ({CirclesSide side = CirclesSide.right}) {
    double y = -MediaQuery.of(context).size.height * 0.15;
    double defase = -MediaQuery.of(context).size.width * (
      _circlesPosition.value
    );
    return [
      Positioned (
        top: y,
        bottom: y,
        right: side == CirclesSide.right 
        ? defase : null,
        left: side == CirclesSide.left
        ? defase : null,
        child: Center(
          child: Container (
            width: MediaQuery.of(context).size.width * 0.6,
            height: MediaQuery.of(context).size.width * 0.6,
            decoration: BoxDecoration (
              color: Theme.of(context).primaryColorLight,
              shape: BoxShape.circle,
              
            ),
            
          ),
        ),
      ),
      Positioned (
        top: y,
        bottom: y,
        right: side == CirclesSide.right 
        ? defase : null,
        left: side == CirclesSide.left
        ? defase : null,
        child: Center(
          child: Container (
            width: MediaQuery.of(context).size.width * 0.55,
            height: MediaQuery.of(context).size.width * 0.55,
            decoration: BoxDecoration (
              color: Theme.of(context).primaryColorDark,
              shape: BoxShape.circle,
              
            ),
            
          ),
        ),
      ),
      Positioned (
        top: y,
        bottom: y,
        right: side == CirclesSide.right 
        ? defase : null,
        left: side == CirclesSide.left
        ? defase : null,
        child: Center(
          child: Container (
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.width * 0.5,
            decoration: const BoxDecoration (
              color: UIColors.primary,
              shape: BoxShape.circle,
              
            ),
            
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, _) {
          return Stack(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 52
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Opacity(
                      opacity: _logoOpacity.value,
                      child: Transform.scale(
                        scale: _logoBeat.value,
                        child: Hero(
                          tag: "logo",
                          child: Image.asset(
                            "assets/logos/silvertime.png",
                            height: MediaQuery.of(context).size.height * 0.2,
                            filterQuality: FilterQuality.medium,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    Opacity(
                      opacity: _titleOpacity.value,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text (
                            "silvertime",
                              style: Theme.of(context).textTheme.merge (
                                GoogleFonts.ralewayTextTheme()
                              ).headline1!.copyWith(
                                color: UIColors.primary
                              ),
                          ),
                          const SizedBox(height: 16),
                          RichText (
                            textAlign: TextAlign.center,
                            text: TextSpan (
                              text: "powered by\n",
                              style: Theme.of(context).textTheme.bodyText2,
                              children: [
                                TextSpan(
                                  text: "silverse",
                                  style: Theme.of(context).textTheme.merge (
                                    GoogleFonts.ralewayTextTheme()
                                  ).headline2
                                )
                              ]
                            ),
                          )
                        ],
                      ),
                      
                    ),
                  ],
                ),
              ),
              ..._circles(side: CirclesSide.left),
              ..._circles(side: CirclesSide.right),
              Positioned (
                bottom: 32,
                left: 0,
                right: 0,
                child: Visibility(
                  visible: _loading,
                  child: Center (
                    child: SpinKitDualRing(
                      color: Theme.of(context).primaryColor,
                      size: 24,
                    ),
                  ),
                ),
              )
            ],
          );
        }
      )
    );
  }
}