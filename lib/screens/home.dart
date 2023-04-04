import 'package:silvertime/include.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const String routeName = "/home";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool changeColor = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if(
        _scrollController.hasClients && _scrollController.offset > kToolbarHeight &&
        !changeColor
      ) {
        setState(() {
          changeColor = true;
        });
      } else if (
        _scrollController.hasClients && _scrollController.offset <= kToolbarHeight
      ) {
        setState(() {
          changeColor = false;
        });
      }
    });
  }

  Widget _title () {
    return Column (
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text (
          S.of (context).welcomeBack ("Juan"), //TODO: Substitute with real value
          style: Theme.of(context).textTheme.headline1,
        )
      ],
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.1
      ),
      child: Column (
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          _title (),
        ],
      ),
    );
  }
}