import 'package:google_fonts/google_fonts.dart';
import 'package:silvertime/include.dart';


class Footer extends StatelessWidget {
  const Footer({super.key});

  double minHeight(context) => MediaQuery.of(context).size.height * 0.15;

  Widget _silverseColumn (BuildContext context) {
    return ConstrainedBox (
      constraints: BoxConstraints (
        minHeight: minHeight (context)
      ),
      child: Column (
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text (
            "silverse",
            style: Theme.of(context).textTheme.merge (
              GoogleFonts.ralewayTextTheme()
            ).displayMedium!.copyWith(
              color: UIColors.white
            )
          ),
          const SizedBox(height: 16),
          Text (
            "Mexico City",
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: UIColors.white
            ),
          ),
          const SizedBox(height: 16),
          Text (
            "silversemx@gmail.com",
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: UIColors.white
            ),
          ),
          const SizedBox(height: 16),
          Text (
            "www.silverse.mx",
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              color: Theme.of(context).primaryColorDark
            ),
          )
          
        ],
      ),
    );
  }

  Widget _astraColumn (BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints (
        minHeight: minHeight(context)
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text (
            S.of(context).about,
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
              color: UIColors.white
            ),
          ),
          const SizedBox(height: 16),
          Image.asset (
            "assets/logos/astrazeneca-logo.png",
            height: 50,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.medium,
            alignment: Alignment.topCenter,
          ),
        ],
      ),
    );
  }

  Widget _legalColumn (BuildContext context) {
    return ConstrainedBox (
      constraints: BoxConstraints (
        minHeight: minHeight (context)
      ),
      child: Column (
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text (
            S.of(context).legal,
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
              color: UIColors.white
            ),
          ),
          const SizedBox(height: 16),
          Text (
            S.of(context).cookiesAdvice,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: UIColors.white
            ),
          )
        ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration (
        gradient: RadialGradient (
          colors: [
            UIColors.primary,
            Theme.of(context).primaryColorDark,
            Theme.of(context).primaryColorLight,
          ],
          focalRadius: 0.7,
          radius: 18,
          focal: Alignment.bottomLeft,
          center: Alignment.topRight,
          stops: const [
            0, 0.5, 1
          ],
        ),
        borderRadius: const BorderRadius.only (
          topRight: Radius.circular(24),
          topLeft: Radius.circular(24)
        )
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 24
      ),
      width: double.infinity,
      child: Wrap (
        alignment: WrapAlignment.spaceAround,
        crossAxisAlignment: WrapCrossAlignment.start,
        spacing: 8,
        runSpacing: 16,
        children: [
          _silverseColumn(context),
          _legalColumn(context),
          _astraColumn(context),
        ],
      ),
    );
  }
}