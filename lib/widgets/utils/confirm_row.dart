import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:silvertime/include.dart';

class ConfirmRow extends StatelessWidget {
  final String? okay;
  final String? cancel;
  final bool okayActive;
  final bool okayLoading;
  final bool cancelLoading;
  final bool cancelActive;
  final void Function()? onPressedOkay;
  final void Function()? onPressedCancel;
  final List<Widget>? leftChildren;
  
  const ConfirmRow(
    { 
      Key? key,
      required this.onPressedOkay,
      required this.onPressedCancel,
      this.okay,
      this.cancel,
      this.okayLoading = false,
      this.cancelLoading = false,
      this.okayActive = true,
      this.cancelActive = true,
      this.leftChildren = const []
    }
  ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ...(leftChildren??[]),
        TextButton(
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(Colors.transparent)
          ),
          onPressed: okayActive ? onPressedOkay : null,
          child: okayLoading 
          ? SpinKitFadingCube(
            color: Theme.of(context).primaryColor,
            size: 16
          )
          : Text(okay ?? S.of (context).okay, 
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: Theme.of(context).primaryColor.withOpacity(
                okayActive ? 1 : 0.5
              )
            ) 
          ),
        ),
        TextButton(
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(Colors.transparent)
          ),
          onPressed: cancelActive ?  onPressedCancel : null,
          child: cancelLoading 
          ? SpinKitFadingCube(
            color: Theme.of(context).primaryColor,
            size: 16
          )
          : Text(cancel ?? S.of (context).cancel, 
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: Theme.of(context).hintColor.withOpacity(
                cancelActive ? 1 : 0.5
              )
            ) 
          )
        )
      ],
    );
  }
}