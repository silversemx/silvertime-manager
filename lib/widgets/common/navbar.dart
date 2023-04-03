import 'package:silvertime/include.dart';
import 'package:silvertime/style/colors.dart';

class Navbar extends StatelessWidget  implements PreferredSizeWidget {
  final bool changeColor;
  const Navbar({Key? key, this.changeColor = false}): super (key: key);

  Widget _label (BuildContext context, String text, String route) {
    return TextButton (
      onPressed: (){
        NavigationService nav = locator<NavigationService> ();
        nav.navigateTo(route);
      },
      child: Text (
        text.toUpperCase(),
        style: Theme.of(context).textTheme.headline3!.copyWith(
          color: changeColor ? Theme.of(context).backgroundColor : null
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: kToolbarHeight + 16,
      padding: const EdgeInsets.symmetric(
        horizontal: 32
      ),
      decoration: BoxDecoration (
        color: changeColor 
        ? UIColors.primary
        : Theme.of(context).backgroundColor,
        borderRadius: const BorderRadius.only  (
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24)
        )
      ),
      child: Row (
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row (
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Hero(
                tag: "logo",
                child: Image.asset (
                  changeColor
                  ? "assets/logos/silvertime_white0.5.png"
                  : "assets/logos/silvertime0.5.png",
                  height: kToolbarHeight - 8,
                  filterQuality: FilterQuality.high,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 16),
              _label (context, S.of(context).home, "/home"),
              _label (context, S.of(context).users, "/users"),
              _label (context, S.of(context).resources, "/resources"),
            ],
          ),
          Row (
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _label (context, S.of(context).yourAccount, "/account"),
            ],
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 16);
}