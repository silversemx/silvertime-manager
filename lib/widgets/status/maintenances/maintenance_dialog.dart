import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:http_request_utils/models/http_exception.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';
import 'package:silvertime/include.dart';
import 'package:silvertime/models/resources/service/service.dart';
import 'package:silvertime/models/status/maintenance/maintenance.dart';
import 'package:silvertime/providers/resources/services/services.dart';
import 'package:silvertime/providers/status/maintenances.dart';
import 'package:silvertime/widgets/in_app_messages/error_dialog.dart';
import 'package:silvertime/widgets/inputs/custom_dropdown_form.dart';
import 'package:silvertime/widgets/inputs/custom_input_field.dart';
import 'package:silvertime/widgets/inputs/custom_input_search_field.dart';
import 'package:silvertime/widgets/quill/quill_editor.dart';
import 'package:silvertime/widgets/utils/confirm_row.dart';
import 'package:silvertime/widgets/utils/time_picker.dart';
import 'package:skeletons/skeletons.dart';

class MaintenanceDialog extends StatefulWidget {
  final Maintenance? maintenance;
  const MaintenanceDialog({super.key, this.maintenance});

  @override
  State<MaintenanceDialog> createState() => _MaintenanceDialogState();
}

class _MaintenanceDialogState extends State<MaintenanceDialog> {
  late Maintenance maintenance;
  bool _loading = true;
  bool _saving = false;
  Map<String, bool> validation = {};
  final _formKey = GlobalKey<FormState> ();
  final ScrollController _scrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();
    maintenance = widget.maintenance ?? Maintenance.empty ();
    Future.microtask(_fetchInfo);
  }

  void _fetchInfo() async {
    setState(() {
      _loading = true;
    });
    try {
      await Provider.of<Services> (context, listen: false).getServices (limit: 0);
    } on HttpException catch(error) {
      showErrorDialog(context, exception: error);
    } finally {
      setState(() {
        _loading = false;
      });
    }
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
    } else {
      showErrorDialog(
        context, title: S.of(context).missingValue, message: validation.toString()
      );
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
                }
                setState(() { });
              },
              selectedPeriod: DatePeriod (
                maintenance.start, maintenance.end!
              ),
              datePickerStyles: DatePickerRangeStyles (
                selectedDateStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
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
                      style: Theme.of(context).textTheme.headlineMedium,
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
                      style: Theme.of(context).textTheme.headlineMedium,
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
                  maintenance.start = DateTime.now ();
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
      return Container ();  
      case MaintenanceTime.free:
        return _startPicker();
      case MaintenanceTime.range:
        return _rangePicker ();
    }
  }

  Widget _serviceInput () {
    return Consumer<Services> (
      builder: (ctx, services, _) {
        if (_loading) {
          return SizedBox (
            width: double.infinity,
            child: SkeletonAvatar (
              style: SkeletonAvatarStyle (
                borderRadius: BorderRadius.circular(12),
                height: 24,
                width: double.infinity,
              ),
            ),
          );
        } else if (services.services.isEmpty) {
          return Container (
            color: Theme.of(context).scaffoldBackgroundColor,
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            child: Text (
              S.of(context).noServices,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        } else {
          return CustomInputSearchField<Service> (
            initialValue: maintenance.service  != null
            ? SearchFieldListItem(
              services.services.firstWhereOrNull (
                (service) => service.id == maintenance.service
              )?.name ?? "",
              item: services.services.firstWhereOrNull(
                (element) => element.id == maintenance.service
              )
            )
            : null,
            fetch: (search) async {
              if (search?.isNotEmpty ?? false) {
                return services.services.where (
                  (service) => service.name.contains (search!)
                ).toList();
              } else {
                return services.services;
              }
            },
            searchFieldMap: (service) => SearchFieldListItem<Service> (
              service.name,
              item: service
            ),
            label: S.of(context).service,
            clearSelection: () {
              setState(() {
                maintenance.service = null;
              });
            },
            onSuggestionTap: (suggestion) {
              setState(() {
                maintenance.service = suggestion.id;
              });
            },
            onSubmit: (serviceName) async {
              Service? serviceFound = services.services.firstWhereOrNull(
                (element) => element.name.formattedSearchText.contains(
                  serviceName.formattedSearchText
                )
              );

              if (serviceFound != null) {
                setState(() {
                  maintenance.service = serviceFound.id;
                });

                return serviceName;
              }
              return null;
            },
            
            showSuggestions: true,
            validation: validation ['service'],
          );
        }
      },
    );
  }

  Widget _form () {
    return Form (
      key: _formKey,
      child: Column (
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomInputField (
            label: S.of(context).title,
            type: TextInputType.text,
            initialValue: maintenance.title,
            onChanged: (val) {
              maintenance.title = val;
            },
            action: TextInputAction.next,
            validation: validation ['title'],
          ),
          CustomDropdownFormField<ExecutionScope> (
            value: maintenance.scope,
            items: maintenanceScopes,
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
          Visibility(
            visible: [
              ExecutionScope.service
            ].contains(maintenance.scope),
            child: _serviceInput(),
          ),
          const SizedBox(height: 16),
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
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: QuillEditorWidget(
              initialValue: maintenance.text,
              label: S.of(context).content, 
              onUpdate: (text) {
                maintenance.text = text;
              }
            ),
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
        vertical: 32
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
                  style: Theme.of(context).textTheme.displayMedium,
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