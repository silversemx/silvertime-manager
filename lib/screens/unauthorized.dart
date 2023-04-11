import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:silvertime/include.dart';

class UnauthorizedScreen extends StatefulWidget {
  const UnauthorizedScreen({super.key});
  static const String routeName = "/unauthorized";

  @override
  State<UnauthorizedScreen> createState() => _UnauthorizedScreenState();
}

class _UnauthorizedScreenState extends State<UnauthorizedScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      // Provider.of<Auth>(context, listen: false).redirect();
    });

  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      child: Column (
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text (
            S.of (context).youAreNotAuthenticated
          ),
          const SizedBox(height: 16),
          SpinKitDualRing(
            color: Theme.of(context).primaryColor,
            size: 32,
          )
        ],
      ),      
    );
  }
}