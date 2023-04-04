import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:silvertime/include.dart';

enum SnackBarStatus {
  success,
  error,
  warning,
  information,
  loading
}

extension SnackbarStatusExt on SnackBarStatus {
  Color get color {
    switch (this) {
      case SnackBarStatus.success:
        return UIColors.inputSuccess;
      case SnackBarStatus.error:
        return UIColors.error;
      case SnackBarStatus.warning:
        return Colors.yellow[700]!;
      case SnackBarStatus.information:
      case SnackBarStatus.loading:
        return Colors.blue;
    }
  }
}


void showStatusSnackbar (
  BuildContext context, String content, 
  {Duration? duration, SnackBarStatus status = SnackBarStatus.success}
) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar (
      content: status == SnackBarStatus.loading
      ? SizedBox(
        width: double.infinity,
        height: 30,
        child: Center (
          child: SpinKitDoubleBounce (
            color: getColorContrast(status.color),
            size: 24,
          ),
        ),
      )
      : Text (
        content, 
        style: Theme.of(context).textTheme.headline3!.copyWith(
          color: getColorContrast(status.color)
        ),
      ),
      duration: duration ?? const Duration (seconds: 4),
      backgroundColor: status.color,
    )
  );
}