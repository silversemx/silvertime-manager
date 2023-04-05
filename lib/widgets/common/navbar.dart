import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:silvertime/include.dart';

class Navbar extends StatelessWidget  implements PreferredSizeWidget {
  final bool changeColor;
  const Navbar({Key? key, this.changeColor = false}): super (key: key);

  static const double navbarHeight = kToolbarHeight + 16;

  Widget _label (BuildContext context, String text, String route) {
    return TextButton (
      onPressed: (){
        NavigationService nav = locator<NavigationService> ();
        nav.navigateTo(route);
      },
      child: Text (
        text.toUpperCase(),
        style: Theme.of(context).textTheme.headline3!.copyWith(
          color: changeColor ? UIColors.white : null
        ),
      ),
    );
  }

  Widget _lightWidth (BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: 48,
        child: DropdownButtonFormField2(
          onChanged: (_){},
          customButton:  Icon (
            Icons.menu,
            color: changeColor 
            ? UIColors.white
            : UIColors.primary
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 200,
            width: MediaQuery.of(context).size.width,
            padding: null,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only (
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12)
              ),
              color: changeColor
              ? UIColors.primary
              : UIColors.white
            ),
            elevation: 0,
            offset: const Offset(-20, 0),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(40),
              thickness: MaterialStateProperty.all(6),
              thumbVisibility: MaterialStateProperty.all(true),
            )
          ),
          decoration: const InputDecoration (
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none
          ),
          items: [
            DropdownMenuItem<String> (
              value: "/home",
              alignment: Alignment.centerLeft,
              child: _label(context, S.of(context).home, "/home"),
            ),
            DropdownMenuItem<String> (
              value: "/users",
              alignment: Alignment.centerLeft,
              child: _label(context, S.of(context).users, "/users"),
            ),
            DropdownMenuItem<String> (
              value: "/resources",
              alignment: Alignment.centerLeft,
              child: _label(context, S.of(context).resources, "/resources"),
            )
          ]
        ),
      ),
    );
  }

  Widget _normalWidth (BuildContext context) {
    return Row (
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
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
          child: constraints.maxWidth < 660
          ? _lightWidth (context)
          : _normalWidth (context),
        );
      }
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(navbarHeight);
}