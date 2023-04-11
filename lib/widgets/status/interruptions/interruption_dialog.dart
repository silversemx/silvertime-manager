import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:http_request_utils/models/http_exception.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';
import 'package:silvertime/include.dart';
import 'package:silvertime/models/resources/service/service.dart';
import 'package:silvertime/models/resources/service/service_instance.dart';
import 'package:silvertime/models/status/interruption/interruption.dart';
import 'package:silvertime/providers/resources/services/instances.dart';
import 'package:silvertime/providers/resources/services/services.dart';
import 'package:silvertime/providers/status/interruptions.dart';
import 'package:silvertime/widgets/in_app_messages/error_dialog.dart';
import 'package:silvertime/widgets/inputs/custom_dropdown_form.dart';
import 'package:silvertime/widgets/inputs/custom_input_field.dart';
import 'package:silvertime/widgets/inputs/custom_input_search_field.dart';
import 'package:silvertime/widgets/quill_editor.dart';
import 'package:silvertime/widgets/utils/confirm_row.dart';
import 'package:silvertime/widgets/utils/time_picker.dart';
import 'package:skeletons/skeletons.dart';

class InterruptionDialog extends StatefulWidget {
  final Interruption? interruption;
  const InterruptionDialog({super.key, this.interruption});

  @override
  State<InterruptionDialog> createState() => _InterruptionDialogState();
}

class _InterruptionDialogState extends State<InterruptionDialog> {
  late Interruption interruption;
  bool _saving = false;
  bool _loading = true;
  bool _loadingInstance = false;
  Map<String, bool> validation = {};
  final _formKey = GlobalKey<FormState> ();
  final ScrollController _scrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();
    Future.microtask(_fetchInfo);
    interruption = widget.interruption ?? Interruption.empty ();
  }

  Future<void> _fetchInstances () async {
    await Provider.of<ServiceInstances> (
      context, listen: false
    ).getInstances(service: interruption.service, limit: 0);
  }

  void _fetchInfo() async {
    setState(() {
      _loading = true;
    });
    try {
      await Provider.of<Services> (context, listen: false).getServices (limit: 0);
      if (interruption.service != null) {
        setState(() {
          _loadingInstance = true;
        });
        await _fetchInstances ();
      }
    } on HttpException catch(error) {
      showErrorDialog(context, exception: error);
    } finally {
      setState(() {
        _loading = false;
        _loadingInstance = false;
      });
    }
  }

  void _selectService (String? id) {
    setState(() {
      interruption.service = id;
      interruption.instance = null;
    });
    _fetchInstances ();

  }

  void _save () async {
    bool formValidation = _formKey.currentState!.validate();
    setState(() {
      validation = interruption.isComplete();
    });

    if (validation ["total"]! && formValidation) {
      setState(() {
        _saving = true;
      });
      try { 
        if (widget.interruption == null) {
          await Provider.of<Interruptions> (
            context, listen: false
          ).createInterruption(
            interruption
          );
        } else {
          await Provider.of<Interruptions> (
            context, listen: false
          ).updateInterruption (
            widget.interruption!.id, interruption
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
    DateTime firstDate = DateTime.now ().subtract(const Duration (days: 365));

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
                interruption.start = period.start;
                interruption.end = period.end;
  
                if (interruption.start.equalsIgnoreTime(today)){
                  interruption.start = interruption.start.copyWith (
                    hour: today.hour , minute: today.minute
                  );
                }

                if (interruption.end!.equalsIgnoreTime (today)) {
                  interruption.end = interruption.end!.copyWith (
                    hour: today.hour , minute: today.minute + 5
                  );
                }
                setState(() { });
              },
              selectedPeriod: DatePeriod (
                interruption.start, interruption.end!
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
                      initialTime: interruption.start,
                      onChanged: (val) {
                        setState(() {
                          interruption.start = val;
                        });
                      },
                      allowPastDates: true,
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
                      initialTime: interruption.end!,
                      onChanged: (val) {
                        setState(() {
                          interruption.end = val;
                        });
                      },
                      allowPastDates: true,
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
    DateTime firstDate = DateTime.now ().subtract(const Duration (days: 365));
    
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
                  interruption.start = DateTime.now ();
                });
              } else {
                setState(() {
                  interruption.start = DateTime (
                    day.year, day.month, day.day
                  );
                });
              }
            },
            selectedDate: interruption.start,
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
          initialTime: interruption.start,
          onChanged: (val) {
            setState(() {
              interruption.start = val;
            });
          },
          allowPastDates: true,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _timePicker () {
    switch (interruption.status) {
      case InterruptionStatus.detected:
        return _startPicker();
      case InterruptionStatus.investigating:
        return _startPicker();
      case InterruptionStatus.monitoring:
        return _startPicker();
      case InterruptionStatus.solved:
        return _rangePicker();
      case InterruptionStatus.none:
      case InterruptionStatus.removed:
        return Container ();
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
            initialValue: interruption.service  != null
            ? SearchFieldListItem(
              services.services.firstWhereOrNull (
                (service) => service.id == interruption.service
              )?.name ?? "",
              item: services.services.firstWhereOrNull(
                (element) => element.id == interruption.service
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
              _selectService(null);
            },
            onSuggestionTap: (suggestion) {
              _selectService (suggestion.id);
            },
            onSubmit: (serviceName) async {
              Service? serviceFound = services.services.firstWhereOrNull(
                (element) => element.name.formattedSearchText.contains(
                  serviceName.formattedSearchText
                )
              );

              if (serviceFound != null) {
                _selectService (serviceFound.id);

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

  Widget _instanceInput () {
    return Consumer<ServiceInstances> (
      builder: (ctx, instances, _) {
        if (_loadingInstance) {
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
        } else if (instances.instances.isEmpty) {
          return Container (
            color: Theme.of(context).scaffoldBackgroundColor,
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            child: Text (
              S.of(context).noInstances,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        } else {
          return CustomInputSearchField<ServiceInstance> (
            initialValue: interruption.instance  != null
            ? SearchFieldListItem(
              instances.instances.firstWhereOrNull (
                (instance) => instance.id == interruption.instance
              )?.name ?? "",
              item: instances.instances.firstWhereOrNull(
                (element) => element.id == interruption.instance
              )
            )
            : null,
            fetch: (search) async {
              if (search?.isNotEmpty ?? false) {
                return instances.instances.where (
                  (instance) => instance.name.contains (search!)
                ).toList();
              } else {
                return instances.instances;
              }
            },
            searchFieldMap: (instance) => SearchFieldListItem<ServiceInstance> (
              instance.name,
              item: instance
            ),
            label: S.of(context).instance,
            clearSelection: () {
              setState(() {
                interruption.instance = null;
              });
            },
            onSuggestionTap: (suggestion) {
              setState(() {
                interruption.instance = suggestion.id;
              });
            },
            onSubmit: (instanceName) async {
              ServiceInstance? instanceFound = instances.instances.firstWhereOrNull(
                (element) => element.name.formattedSearchText.contains(
                  instanceName.formattedSearchText
                )
              );

              if (instanceFound != null) {
                setState(() {
                  interruption.instance = instanceFound.id;
                });

                return instanceName;
              }
              return null;
            },
            
            showSuggestions: true,
            validation: validation ['instance'],
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
            type: TextInputType.name,
            onChanged: (val) {
              interruption.title = val;
            },
            action: TextInputAction.next,
            validation: validation['title'],
          ),
          CustomDropdownFormField<ExecutionExit> (
            value: interruption.exit,
            items: ExecutionExit.values,
            label: S.of(context).exit,
            hintItem: 0,
            name: (val) => val.name(context),
            onChanged: (val) {
              setState(() {
                interruption.exit = val!;
              });
            },
            validation: validation['scope'],
          ),
          CustomDropdownFormField<ExecutionType> (
            value: interruption.execution,
            items: ExecutionType.values,
            label: S.of(context).execution,
            hintItem: 0,
            name: (val) => val.name(context),
            onChanged: (val) {
              setState(() {
                interruption.execution = val!;
              });
            },
            validation: validation['execution'],
          ),
          CustomDropdownFormField<ExecutionScope> (
            value: interruption.scope,
            items: interruptionScopes,
            label: S.of(context).scope,
            hintItem: 0,
            name: (val) => val.name(context),
            onChanged: (val) {
              setState(() {
                interruption.scope = val!;
              });
            },
            validation: validation['scope'],
          ),
          Visibility(
            visible: [
              ExecutionScope.service,
              ExecutionScope.instance
            ].contains(interruption.scope),
            child: _serviceInput()
          ),
          const SizedBox(height: 16),
          Visibility(
            visible: [
              ExecutionScope.instance
            ].contains(interruption.scope),
            child: _instanceInput()
          ),
          const SizedBox(height: 16),
          CustomDropdownFormField<InterruptionStatus> (
            value: interruption.status,
            items: interruptionCreateValues,
            label: S.of(context).status,
            hintItem: 0,
            name: (val) => val.name(context),
            onChanged: (val) {
              if (val == InterruptionStatus.solved) {
                interruption.end = DateTime.now ();
              } else {
                interruption.end = null;
              }

              interruption.status = val!;

              setState(() {});
            },
            validation: validation['status'],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: QuillEditorWidget(
              initialValue: interruption.description,
              label: S.of(context).description, 
              onUpdate: (text) {
                interruption.description = text;
              }
            ),
          ),
          const SizedBox(height: 16),
          Visibility(
            visible: interruption.status == InterruptionStatus.solved,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: QuillEditorWidget(
                initialValue: interruption.solution,
                label: S.of(context).solution, 
                onUpdate: (text) {
                  interruption.solution = text;
                }
              ),
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
                  widget.interruption == null
                  ? S.of(context).createInterruption
                  : S.of(context).editInterruption,
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