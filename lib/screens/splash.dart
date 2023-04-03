import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:silvertime/include.dart';
import 'package:silvertime/style/colors.dart';

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
    return [
      Positioned (
        top: -MediaQuery.of(context).size.height * 0.15,
        bottom: 0,
        right: side == CirclesSide.right 
        ? -MediaQuery.of(context).size.width * (
          _circlesPosition.value + 0.06
        ) : null,
        left: side == CirclesSide.left
        ? -MediaQuery.of(context).size.width * (
          _circlesPosition.value + 0.06
        ) : null,
        child: SingleChildScrollView(
          child: Container (
            width: MediaQuery.of(context).size.height * 1.3,
            height: MediaQuery.of(context).size.height * 1.3,
            decoration: BoxDecoration (
              color: Theme.of(context).primaryColorLight,
              shape: BoxShape.circle,
              
            ),
            
          ),
        ),
      ),
      Positioned (
        top: -MediaQuery.of(context).size.height * 0.1,
        bottom: 0,
        right: side == CirclesSide.right 
        ? -MediaQuery.of(context).size.width * (
          _circlesPosition.value + 0.06
        ) : null,
        left: side == CirclesSide.left
        ? -MediaQuery.of(context).size.width * (
          _circlesPosition.value + 0.06
        ) : null,
        child: SingleChildScrollView(
          child: Container (
            width: MediaQuery.of(context).size.height * 1.2,
            height: MediaQuery.of(context).size.height * 1.2,
            decoration: BoxDecoration (
              color: Theme.of(context).primaryColorDark,
              shape: BoxShape.circle,
              
            ),
            
          ),
        ),
      ),
      Positioned (
        top: 0,
        bottom: 0,
        right: side == CirclesSide.right 
        ? -MediaQuery.of(context).size.width * (
          _circlesPosition.value
        ) : null,
        left: side == CirclesSide.left
        ? -MediaQuery.of(context).size.width * (
          _circlesPosition.value
        ) : null,
        child: SingleChildScrollView(
          child: Container (
            width: MediaQuery.of(context).size.height * 1,
            height: MediaQuery.of(context).size.height * 1,
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
                    Opacity(
                      opacity: _titleOpacity.value,
                      child: Text(
                        "Silvertime",
                        style: Theme.of(context).textTheme.headline1!.copyWith(
                          color: UIColors.primary
                        ),
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