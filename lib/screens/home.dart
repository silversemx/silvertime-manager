import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:silvertime/include.dart';
import 'package:silvertime/providers/auth.dart';
import 'package:silvertime/style/container.dart';

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
        Consumer<Auth>(
          builder: (context, auth, _) {
            return Text (
              S.of (context).welcomeBack (auth.userValues?.username ?? "N/A"),
              style: Theme.of(context).textTheme.displayLarge,
            );
          }
        )
      ],
    );
  }

  Widget _overview (String title, IconData icon, {required Widget child}) {
    return Container (
      constraints: BoxConstraints (
        maxWidth: constrainedBigWidth(
          context, MediaQuery.of(context).size.width * 0.37,
          constraintWidth: 300
        )
      ),
      decoration: containerDecoration,
      padding: const EdgeInsets.all(16),
      child: Column (
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text (
                title,
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(width: 16),
              Icon (
                icon,
                size: 24,
                color: UIColors.hint,
              ),
            ],
          ),
          const Divider (
            endIndent: 35,
            thickness: 0.1,
          ),
          const SizedBox(height: 16),
          child
        ],
      ),
    );
  }

  Widget _accessData ({
    required num daily, required num monthly, required num weekly, required num users
  }) {
    return Column (
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan (
            text: S.of(context).dailyAccess,
            style: Theme.of(context).textTheme.displaySmall,
            children: [
              const TextSpan (
                text: "  "
              ),
              TextSpan (
                text: daily.toStringAsFixed(0),
                style: Theme.of(context).textTheme.bodyLarge
              )
            ]
          )
        ),
        const SizedBox(height: 16),
        RichText(
          text: TextSpan (
            text: S.of(context).weeklyAccess,
            style: Theme.of(context).textTheme.displaySmall,
            children: [
              const TextSpan (
                text: "  "
              ),
              TextSpan (
                text: weekly.toStringAsFixed(0),
                style: Theme.of(context).textTheme.bodyLarge
              )
            ]
          )
        ),
        const SizedBox(height: 16),
        RichText(
          text: TextSpan (
            text: S.of(context).monthlyAccess,
            style: Theme.of(context).textTheme.displaySmall,
            children: [
              const TextSpan (
                text: "  "
              ),
              TextSpan (
                text: monthly.toStringAsFixed(0),
                style: Theme.of(context).textTheme.bodyLarge
              )
            ]
          )
        ),
        const SizedBox(height: 16),
        RichText(
          text: TextSpan (
            text: S.of(context).activeUsers,
            style: Theme.of(context).textTheme.displaySmall,
            children: [
              const TextSpan (
                text: "  "
              ),
              TextSpan (
                text: users.toStringAsFixed(0),
                style: Theme.of(context).textTheme.bodyLarge
              )
            ]
          )
        )
      ],
    );
  }

  Widget _webOverview () {
    return _overview(
      S.of(context).web, 
      FontAwesomeIcons.desktop, 
      child: Column (
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _accessData(daily: 170, monthly: 1500, weekly: 6225, users: 57)
        ],
      )
    );
  }

  Widget _mobileOverview () {
    return _overview(
      S.of(context).mobile, 
      FontAwesomeIcons.mobile, 
      child: Column (
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _accessData(daily: 280, monthly: 3500, weekly: 9225, users: 172)
        ],
      )
    );
  }  

  Widget _platformOverview () {
    return Column (
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text (
          S.of(context).platformOverview,
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const SizedBox(height: 16),
        SizedBox (
          width: double.infinity,
          child: Wrap (
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 16,
            runSpacing: 48,
            children: [
              _webOverview (),
              _mobileOverview()
            ],
          ),
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
          const Divider (
            height: 48,
          ),
          const SizedBox(height: 16),
          _platformOverview ()
        ],
      ),
    );
  }
}