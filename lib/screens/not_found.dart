import 'package:silvertime/include.dart';

class NotFoundScreen extends StatefulWidget {
  const NotFoundScreen({super.key});
  static const String routeName = "/not-found";

  @override
  State<NotFoundScreen> createState() => _NotFoundScreenState();
}

class _NotFoundScreenState extends State<NotFoundScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center (
        child: Text ("NOT FOUND"),
      ),
    );
  }
}