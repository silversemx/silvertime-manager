import 'dart:async';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http_request_utils/models/http_exception.dart';
import 'package:silvertime/include.dart';
import 'package:silvertime/models/history/status_update.dart';
import 'package:silvertime/widgets/in_app_messages/confirm_dialog.dart';
import 'package:silvertime/widgets/in_app_messages/error_dialog.dart';
import 'package:silvertime/widgets/quill/quill_editor.dart';
import 'package:silvertime/widgets/quill/quill_reader.dart';
import 'package:silvertime/widgets/utils/confirm_row.dart';

class StatusUpdateDialog<T> extends StatefulWidget {
  final T? currentValue;
  final List<T> values;
  final bool Function (T)? displayStatus;
  final Future<List<StatusUpdate<T>>> Function () getHistory;
  final Future<void> Function (T, [String? text]) updateStatus;
  final Widget Function (T) getWidget;
  final bool text;
  const StatusUpdateDialog({
    Key? key, this.currentValue, 
    required this.values,
    required this.getWidget,
    required this.getHistory,
    required this.updateStatus,
    this.text = false,
    this.displayStatus,
  }) : super(key: key);

  @override
  State<StatusUpdateDialog<T>> createState() => _StatusUpdateDialogState<T>();
}

class _StatusUpdateDialogState<T> extends State<StatusUpdateDialog<T>> {
  bool _loading = false;
  bool _updating = false;
  List<StatusUpdate<T>> history = [];
  final ScrollController _scrollController = ScrollController();
  String? text;
  T? status;

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

  void updateStatus (T status) async {
    try {
      setState(() {
        _updating = true;
      });
      await widget.updateStatus (status, widget.text ? text : null);
      _fetchInfo();
    } on HttpException catch (error) {
      showErrorDialog(context, exception: error);
    } finally {
      setState(() {
        _updating = false;
      });
    }
  }

  Widget _statusUpdateData (StatusUpdate<T> data) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row (
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            widget.getWidget (data.previousStatus),
            Icon (
              Icons.keyboard_double_arrow_right, 
              size: 24, 
              color: Theme.of(context).primaryColor
            ),
            widget.getWidget (data.currentStatus),
          ],
        ),
        widget.text && data.text != null
        ? QuillReaderWidget (
          value: data.text,
        )
        : Container (),
        Text (
          data.date.dateString,
          style: Theme.of(context).textTheme.bodyLarge,
        )
      ],
    );
  }

  Widget _updateStatusInput () {
    return Column (
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text (
          S.of(context).updateStatus,
          style: Theme.of(context).textTheme.displaySmall,
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
            crossAxisAlignment: WrapCrossAlignment.start,
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
                      if (widget.text) {
                        setState(() {
                          this.status = status;
                        });
                      } else {
                        updateStatus(status);
                      }
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        widget.getWidget (status),
                        Visibility (
                          visible: widget.text && this.status == status,
                          child: Container (
                            margin: const EdgeInsets.only(
                              top: 8
                            ),
                            width: 16,
                            height: 16,
                            decoration: const BoxDecoration (
                              color: UIColors.error,
                              shape: BoxShape.circle
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }
              }
            ).toList()
          ),
        ),
        const SizedBox(height: 16),
        Container (
          height: MediaQuery.of(context).size.height * 0.4,
          padding: const EdgeInsets.all(16),
          child: QuillEditorWidget (
            label: S.of (context).description,
            onUpdate: (val) {
              setState(() {
                text = val;
              });
            },
          ),
        ),
        const SizedBox(height: 16),
        Visibility(
          visible: widget.text,
          child: ConfirmRow (
            onPressedOkay: () async {
              bool? retval = await showConfirmDialog (
                context,
                title: S.of(context).areYouSure,
                body: S.of(context).thisActionCantBeUndone
              );
              
              if (retval ?? false) {
                updateStatus(status as T);
              }
            },
            okayActive: text != null && status != null,
            onPressedCancel: Navigator.of(context).pop,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.3
      ),
      child: Scrollbar(
        controller: _scrollController,
        child: Container (
          padding: const EdgeInsets.symmetric(horizontal: 32),
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
          : SingleChildScrollView (
            controller: _scrollController,
            child: Column(
              children: [
                const SizedBox(height: 32),
                Text (
                  S.of(context).history,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: ListView.builder(
                    itemCount: history.length,
                    itemBuilder: (ctx, i) {
                      return _statusUpdateData(history[i]);
                    }
                  ),
                ),
                const Divider (),
                _updateStatusInput()
              ],
            ),
          ),
        ),
      ),
    );
  }
}