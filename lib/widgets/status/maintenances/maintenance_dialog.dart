import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:http_request_utils/models/http_exception.dart';
import 'package:provider/provider.dart';
import 'package:silvertime/include.dart';
import 'package:silvertime/models/status/maintenance/maintenance.dart';
import 'package:silvertime/providers/status/maintenances.dart';
import 'package:silvertime/widgets/in_app_messages/error_dialog.dart';
import 'package:silvertime/widgets/inputs/custom_dropdown_form.dart';
import 'package:silvertime/widgets/utils/confirm_row.dart';
import 'package:silvertime/widgets/utils/time_picker.dart';

class MaintenanceDialog extends StatefulWidget {
  final Maintenance? maintenance;
  const MaintenanceDialog({super.key, this.maintenance});

  @override
  State<MaintenanceDialog> createState() => _MaintenanceDialogState();
}

class _MaintenanceDialogState extends State<MaintenanceDialog> {
  late Maintenance maintenance;
  bool _saving = false;
  Map<String, bool> validation = {};
  final _formKey = GlobalKey<FormState> ();
  final ScrollController _scrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();
    maintenance = widget.maintenance ?? Maintenance.empty ();
  }

  void _save () async {
    bool formValidation = _formKey.currentState!.validate();
    setState(() {
      validation = maintenance.isComplete();
    });

    if (validation ["total"]! && formValidation) {
      setState(() {
        _saving = true;
      });
      try { 
        if (widget.maintenance == null) {
          await Provider.of<Maintenances> (context, listen: false).createMaintenance(
            maintenance
          );
        } else {
          await Provider.of<Maintenances> (context, listen: false).updateMaintenance (
            widget.maintenance!.id, maintenance
          );
        }

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
    }
  }

  Widget _rangePicker () {
    DateTime today = DateTime.now();
    DateTime inAYear = today.add (const Duration (days: 365));
    DateTime firstDate = DateTime.fromMillisecondsSinceEpoch(
      today.millisecondsSinceEpoch
    );
    
    if (today.isAfter (maintenance.start)) {
      firstDate = DateTime.fromMillisecondsSinceEpoch(
        maintenance.start.millisecondsSinceEpoch
      )..subtract(
          const Duration (days: 1)
      );
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox (
            width: 250,
            height: 250,
            child: RangePicker (
              firstDate: firstDate,
              lastDate: inAYear,
              onChanged: (DatePeriod period) {
                maintenance.start = period.start;
                maintenance.end = period.end;
  
                if (maintenance.start.equalsIgnoreTime(today)){
                  maintenance.start = maintenance.start.copyWith (
                    hour: today.hour , minute: today.minute
                  );
                }

                if (maintenance.end!.equalsIgnoreTime (today)) {
                  maintenance.end = maintenance.end!.copyWith (
                    hour: today.hour , minute: today.minute + 5
                  );
                  print (maintenance.end);
                }
                setState(() { });
              },
              selectedPeriod: DatePeriod (
                maintenance.start, maintenance.end!
              ),
              datePickerStyles: DatePickerRangeStyles (
                selectedDateStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: UIColors.white
                ),
                selectedPeriodStartDecoration: BoxDecoration (
                  color: Theme.of(context).primaryColorLight,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12)
                  )
                ),
                selectedPeriodLastDecoration: BoxDecoration (
                  color: Theme.of(context).primaryColorLight,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomRight: Radius.circular(12)
                  )
                )
              ),
            )
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: Wrap (
              alignment: WrapAlignment.center,
              runSpacing: 32,
              spacing: 32,
              children: [
                Column (
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text (
                      S.of (context).start,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    const SizedBox(height: 8),
                    TimePicker (
                      initialTime: maintenance.start,
                      onChanged: (val) {
                        setState(() {
                          maintenance.start = val;
                        });
                      },
                      allowPastDates: false,
                    ),
                  ],
                ),
                Column (
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text (
                      S.of (context).end,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    const SizedBox(height: 8),
                    TimePicker (
                      initialTime: maintenance.end!,
                      onChanged: (val) {
                        setState(() {
                          maintenance.end = val;
                        });
                      },
                      allowPastDates: false,
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _startPicker () {
    DateTime today = DateTime.now();
    DateTime inAYear = today.add (const Duration (days: 365));
    DateTime firstDate = DateTime.fromMillisecondsSinceEpoch(
      today.millisecondsSinceEpoch
    );
    
    if (today.isAfter (maintenance.start)) {
      firstDate = DateTime.fromMillisecondsSinceEpoch(
        maintenance.start.millisecondsSinceEpoch
      )..subtract(
          const Duration (days: 1)
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 250,
          height: 250,
          child: DayPicker.single (
            firstDate: firstDate,
            lastDate: inAYear,
            onChanged: (DateTime day) {
              if (day.equalsIgnoreTime(DateTime.now ())){
                setState(() {
                  maintenance.start = day;
                });
              } else {
                setState(() {
                  maintenance.start = DateTime (
                    day.year, day.month, day.day
                  );
                });
              }
            },
            selectedDate: maintenance.start,
            datePickerStyles: DatePickerRangeStyles(
              currentDateStyle: Theme.of(context).textTheme.headline3,
              selectedDateStyle: Theme.of(context).textTheme.headline3!.copyWith(
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
          initialTime: maintenance.start,
          onChanged: (val) {
            setState(() {
              maintenance.start = val;
            });
          },
          allowPastDates: false,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _timePicker () {
    switch (maintenance.time) {
      case MaintenanceTime.none:
      case MaintenanceTime.other:
      return Container ();  
      case MaintenanceTime.free:
        return _startPicker();
      case MaintenanceTime.range:
        return _rangePicker ();
    }
  }

  Widget _form () {
    return Form (
      key: _formKey,
      child: Column (
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomDropdownFormField<ExecutionScope> (
            value: maintenance.scope,
            items: ExecutionScope.values,
            label: S.of(context).scope,
            hintItem: 0,
            name: (val) => val.name(context),
            onChanged: (val) {
              setState(() {
                maintenance.scope = val!;
              });
            },
            validation: validation['scope'],
          ),
          CustomDropdownFormField<MaintenanceTime> (
            value: maintenance.time,
            items: MaintenanceTime.values,
            label: S.of(context).time,
            hintItem: 0,
            name: (val) => val.name(context),
            onChanged: (val) {
              maintenance.time = val!;
              if (val == MaintenanceTime.range) {
                maintenance.end = DateTime.now ();
              } else {
                maintenance.end = null;
              }

              setState(() {
              });
            },
            validation: validation['time'],
          ),
          _timePicker (),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.2,
      ),
      child: Scrollbar(
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Container (
            padding: const EdgeInsets.all(16),
            child: Column (
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text (
                  widget.maintenance == null
                  ? S.of(context).createMaintenance
                  : S.of(context).editMaintenance,
                  style: Theme.of(context).textTheme.headline2,
                ),
                const SizedBox(height: 16),
                _form (),
                const SizedBox(height: 16),
                ConfirmRow (
                  onPressedOkay: _save,
                  onPressedCancel: Navigator.of(context).pop,
                  okayLoading: _saving,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}