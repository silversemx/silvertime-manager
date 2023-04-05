import 'dart:async';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http_request_utils/models/http_exception.dart';
import 'package:silvertime/include.dart';
import 'package:silvertime/models/history/status_update.dart';
import 'package:silvertime/widgets/in_app_messages/error_dialog.dart';

class StatusUpdateDialog<T> extends StatefulWidget {
  final T? currentValue;
  final List<T> values;
  final bool Function (T)? displayStatus;
  final Future<List<StatusUpdate<T>>> Function () getHistory;
  final Future<void> Function (T) updateStatus;
  final Widget Function (T) getWidget;
  const StatusUpdateDialog({
    Key? key, this.currentValue, 
    required this.values,
    required this.getWidget,
    required this.getHistory,
    required this.updateStatus,
    this.displayStatus,
  }) : super(key: key);

  @override
  State<StatusUpdateDialog<T>> createState() => _StatusUpdateDialogState<T>();
}

class _StatusUpdateDialogState<T> extends State<StatusUpdateDialog<T>> {
  bool _loading = false;
  bool _updating = false;
  List<StatusUpdate> history = [];

  @override
  void initState () {
    super.initState();
    Future.microtask(() => _fetchInfo ());
  }

  void _fetchInfo() async {
    setState(() {
      _loading = true;
    });
    try {
      history = await widget.getHistory ();
    } on HttpException catch(error, bt) {
      Completer().completeError (error, bt);
      showErrorDialog(context, exception: error);
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void updateStatus (dynamic status) async {
    try {
      setState(() {
        _updating = true;
      });
      await widget.updateStatus (status);
      _fetchInfo();
    } on HttpException catch (error) {
      showErrorDialog(context, exception: error);
    } finally {
      setState(() {
        _updating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.3
      ),
      child: Container (
        padding: const EdgeInsets.all(48),
        constraints: BoxConstraints (
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        child: _loading
        ? Center (
          child: SpinKitDoubleBounce(
            color: Theme.of(context).primaryColor,
            size: 24,
          ),
        )
        : Column(
          children: [
            Text (
              S.of(context).history,
              style: Theme.of(context).textTheme.headline2,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: history.length,
                itemBuilder: (ctx, i) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row (
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          widget.getWidget (history[i].previousStatus),
                          Icon (
                            Icons.keyboard_double_arrow_right, 
                            size: 24, 
                            color: Theme.of(context).primaryColor
                          ),
                          widget.getWidget (history[i].currentStatus),
                        ],
                      ),
                      Text (
                        history[i].date.dateString,
                        style: Theme.of(context).textTheme.bodyText1,
                      )
                    ],
                  );
                }
              ),
            ),
            const Divider (),
            Text (
              S.of(context).updateStatus,
              style: Theme.of(context).textTheme.headline3,
            ),
            const SizedBox(height: 4,),
            SizedBox(
              height: 100,
              width: double.infinity,
              child: _updating
              ? SpinKitDoubleBounce(
                color: Theme.of(context).primaryColor,
                size: 24,
              )
              : Wrap (
                alignment: WrapAlignment.spaceAround,
                crossAxisAlignment: WrapCrossAlignment.center,
                runSpacing: 16,
                children: widget.values
                .map(
                  (status) {
                    bool displayStatus = false;
                    if (widget.displayStatus != null) {
                      displayStatus = !widget.displayStatus! (status);
                    } else {
                      displayStatus = widget.values.indexOf(status) == 0;
                    }
                    
                    if (displayStatus) {
                      return Container();
                    } else {
                      return InkWell (
                        onTap: (){
                          updateStatus(status);
                        },
                        child: widget.getWidget (status),
                      );
                    }
                  }
                ).toList()
              ),
            )
          ],
        ),
      ),
    );
  }
}