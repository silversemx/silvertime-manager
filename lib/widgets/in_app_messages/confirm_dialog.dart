import 'package:silvertime/include.dart';

Future showConfirmDialog(
  BuildContext context, {
    required String title, required String body, String? okay, String? cancel
  }
) {
  okay ??= S.of(context).okay;
  cancel ??= S.of(context).cancel;
  return showDialog(

    context: context,
    builder: (ctx) => Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.3
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: Theme.of(context).textTheme.headline2),
            const SizedBox(height: 16,),
            Text(body, style: Theme.of(context).textTheme.bodyText1),
            const SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.transparent)
                  ),
                  child: Text(okay!, 
                    style: Theme.of(context).textTheme.headline3?.copyWith(
                      color: Theme.of(context).primaryColorDark
                    ) 
                  ),
                  onPressed: (){
                    Navigator.of(context).pop(true);
                  },
                ),
                TextButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.transparent)
                  ),
                  child: Text(cancel!, 
                    style: Theme.of(context).textTheme.headline3?.copyWith(
                      color: UIColors.hint
                    ) 
                  ),
                  onPressed: (){
                    Navigator.of(context).pop(false);
                  },
                )
              ],
            )
          ],
        ),
      ),
    )
  );
}