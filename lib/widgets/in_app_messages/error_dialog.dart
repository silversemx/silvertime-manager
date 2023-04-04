import 'dart:convert';

import 'package:http_request_utils/body_utils.dart';
import 'package:silvertime/include.dart';

Future<dynamic> showErrorDialog(
  BuildContext context, {
    HttpException? exception,
    String? title, 
    String? message,
  } 
){
  String exceptionMessage = "";

  if(exception != null) {
    try {
      var decodedMessage = json.decode (exception.message);
      for (String key in decodedMessage.keys) {
        exceptionMessage += "$key: ${decodedMessage [key]}\n";
      }
    } catch (error) {
      //Not a json
    }
    
    title = S.of(context).anErrorOcurred;
    title += " ";
    message = exception.message;
    switch(exception.code){
      case Code.request:
        title += S.of(context).inServer;
        switch(exception.status) {
          case 400:
            message = S.of(context).error_400;
          break;
          case 401:
            message = S.of(context).error_401;
          break;
          case 404:
            message = S.of(context).error_404;
          break;
          case 500:
            message = S.of(context).error_500;
          break;
          case 502:
            message = S.of(context).error_502;
          break;
          case 504:
            message = S.of(context).error_504;
          break;
        }
      break;
      case Code.system:
        title += S.of(context).inDashboard;
      break;
      case Code.unauthorized:
        title += S.of(context).inAuthorization;
      break;
      default:
        title += S.of(context).unexpected;
      break;
    }
  }

  return showDialog(
    context: context, 
    builder: (ctx) => Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.3
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: Theme.of(context).backgroundColor,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title!, textAlign: TextAlign.center, 
                  style: Theme.of(context).textTheme.headline2?.copyWith(
                    color: UIColors.error
                  )
                ),
                const SizedBox(height: 16,),
                Text(message!, textAlign: TextAlign.justify,
                  style: Theme.of(context).textTheme.bodyText1
                ),
                Visibility(
                  visible: true,
                  child: Text(
                    exceptionMessage,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: UIColors.error,
                      fontSize: 13
                    ),
                  )
                ),
                Visibility(
                  visible: exception?.route != null,
                  child: Text(
                    exception?.route ?? "No Route",
                    style: Theme.of(context).textTheme.bodyText2,
                  )
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        S.of(context).okay, 
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                          color: Theme.of(context).primaryColorDark
                        )
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    )
  );
}