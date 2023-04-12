import 'package:http_request_utils/models/http_exception.dart';
import 'package:provider/provider.dart';
import 'package:silvertime/include.dart';
import 'package:silvertime/models/resources/service/service_instance.dart';
import 'package:silvertime/providers/resources/services/instances.dart';
import 'package:silvertime/widgets/in_app_messages/error_dialog.dart';
import 'package:silvertime/widgets/inputs/custom_dropdown_form.dart';
import 'package:silvertime/widgets/inputs/custom_input_field.dart';
import 'package:silvertime/widgets/utils/confirm_row.dart';

class ServiceInstanceDialog extends StatefulWidget {
  final ServiceInstance? instance;
  const ServiceInstanceDialog({super.key, this.instance});

  @override
  State<ServiceInstanceDialog> createState() => _ServiceInstanceDialogState();
}

class _ServiceInstanceDialogState extends State<ServiceInstanceDialog> {
  late ServiceInstance instance;
  bool _saving = false;
  Map<String, bool> validation = {};
  final _formKey = GlobalKey<FormState> ();
  final ScrollController _scrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();
    instance = widget.instance ?? ServiceInstance.empty ();
  }

  void _save () async {
    bool formValidation = _formKey.currentState!.validate();
    setState(() {
      validation = instance.isComplete();
    });

    if (validation ["total"]! && formValidation) {
      setState(() {
        _saving = true;
      });
      try { 
        if (widget.instance == null) {
          await Provider.of<ServiceInstances> (
            context, listen: false
          ).createInstance(
            instance
          );
        } else {
          await Provider.of<ServiceInstances> (
            context, listen: false
          ).updateInstance (
            widget.instance!.id, instance
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

  Widget _form () {
    return Form (
      key: _formKey,
      child: Column (
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomInputField (
            initialValue: instance.name,
            label: S.of(context).name,
            type: TextInputType.text,
            action: TextInputAction.next,
            onChanged: (val) {
              instance.name = val;
            },
            requiredValue: true,
            validation: validation ["name"],
          ),
          CustomInputField (
            initialValue: instance.description,
            label: S.of(context).description,
            type: TextInputType.text,
            action: TextInputAction.next,
            onChanged: (val) {
              instance.description = val;
            },
            requiredValue: true,
            validation: validation ["description"],
          ),
          CustomDropdownFormField<ServiceInstanceType> (
            value: instance.type,
            items: ServiceInstanceType.values,
            label: S.of(context).type,
            hintItem: 0,
            name: (val) => val.name(context),
            onChanged: (val) {
              setState(() {
                instance.type = val!;
              });
            },
            validation: validation['type'],
          ),
          //TODO: Add machine and options
          CustomInputField (
            initialValue: instance.publicAddress,
            label: S.of(context).publicAddress,
            type: TextInputType.text,
            action: TextInputAction.next,
            onChanged: (val) {
              instance.publicAddress = val;
            },
            requiredValue: false,
            validation: validation ["publicAddress"],
          ),
          CustomInputField (
            initialValue: instance.privateAddress,
            label: S.of(context).privateAddress,
            type: TextInputType.text,
            action: TextInputAction.next,
            onChanged: (val) {
              instance.privateAddress = val;
            },
            requiredValue: false,
            validation: validation ["privateAddress"],
          ),
          CustomInputField (
            initialValue: instance.internalAddress,
            label: S.of(context).internalAddress,
            type: TextInputType.text,
            action: TextInputAction.next,
            onChanged: (val) {
              instance.internalAddress = val;
            },
            requiredValue: false,
            validation: validation ["internalAddress"],
          ),
          CustomInputField (
            initialValue: instance.weight.toString(),
            label: S.of(context).weight,
            type: TextInputType.text,
            action: TextInputAction.next,
            onChanged: (val) {
              instance.weight = num.tryParse(val) ?? 0;
            },
            requiredValue: true,
            acceptZeros: false,
            validation: validation ["weight"],
          ),
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
                  widget.instance == null
                  ? S.of(context).createServiceInstance
                  : S.of(context).editServiceInstance,
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