import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:http_request_utils/body_utils.dart';
import 'package:provider/provider.dart';
import 'package:silvertime/include.dart';
import 'package:silvertime/models/status/interruption/interruption.dart';
import 'package:silvertime/providers/status/interruptions.dart';
import 'package:silvertime/widgets/in_app_messages/error_dialog.dart';
import 'package:silvertime/widgets/quill/quill_editor.dart';
import 'package:silvertime/widgets/utils/confirm_row.dart';
import 'package:silvertime/widgets/utils/time_picker.dart';

class SolveInterruptionDialog extends StatefulWidget {
  final Interruption interruption;
  const SolveInterruptionDialog({super.key, required this.interruption});

  @override
  State<SolveInterruptionDialog> createState() => _SolveInterruptionDialogState();
}

class _SolveInterruptionDialogState extends State<SolveInterruptionDialog> {
  final ScrollController _scrollController = ScrollController();
  bool _saving = false;
  String solution = "";
  bool _missingSolution = false;
  DateTime end = DateTime.now ();

  void _save () async {
    if (solution.isNotEmpty) {
      Duration duration = end.difference(widget.interruption.start);
      setState(() {
        _missingSolution = false;
        _saving = true;
      }); 
      try {
        await Provider.of<Interruptions> (context, listen: false).solveInterruption (
          widget.interruption.id, solution, end, duration
        );

        Navigator.of(context).pop (true);
      } on HttpException catch (error) {
        showErrorDialog(context, exception: error);
      } finally {
        if (mounted) {
          setState(() {
            _saving = false;
          });
        }
      }
    } else {
      setState(() {
        _missingSolution = true;
      });
    }
  }

  Widget _dateTimePicker () {
    DateTime today = DateTime.now();
    DateTime firstDate = DateTime.now ().subtract(const Duration (days: 365));
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text (
          S.of(context).end,
          style: Theme.of(context).textTheme.displayMedium,  
        ),
        SizedBox(
          width: 250,
          height: 250,
          child: DayPicker.single (
            firstDate: firstDate,
            lastDate: today,
            onChanged: (DateTime day) {
              if (day.equalsIgnoreTime(DateTime.now ())){
                setState(() {
                  end = DateTime.now ();
                });
              } else {
                setState(() {
                  end = DateTime (
                    day.year, day.month, day.day
                  );
                });
              }
            },
            selectedDate: end,
            datePickerStyles: DatePickerRangeStyles(
              currentDateStyle: Theme.of(context).textTheme.displaySmall,
              selectedDateStyle: Theme.of(context).textTheme.displaySmall!.copyWith(
                color: UIColors.white
              ),
              selectedSingleDateDecoration: BoxDecoration (
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColor
              )
            )
          ),
        ),
        TimePicker (
          initialTime: end,
          onChanged: (val) {
            setState(() {
              end = val;
            });
          },
          allowPastDates: true,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.2,
        vertical: 32
      ),
      child: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Container (
            padding: const EdgeInsets.symmetric(
              horizontal: 16
            ),
            child: Column (
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                Text (
                  S.of(context).solveInterruption,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 16),
                SizedBox (
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: QuillEditorWidget (
                    label: S.of(context).solution,
                    onUpdate: (val) {
                      solution = val;
                    },
                    validation: _missingSolution,
                  ),
                ),
                const SizedBox(height: 16),
                _dateTimePicker  (),
                const SizedBox(height: 16),
                ConfirmRow (
                  okayLoading: _saving,
                  onPressedOkay: _save,
                  onPressedCancel: Navigator.of(context).pop,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}