import 'package:http_request_utils/models/http_exception.dart';
import 'package:provider/provider.dart';
import 'package:silvertime/include.dart';
import 'package:silvertime/models/resources/service/service.dart';
import 'package:silvertime/providers/resources/services/services.dart';
import 'package:silvertime/widgets/in_app_messages/error_dialog.dart';
import 'package:silvertime/widgets/inputs/custom_dropdown_form.dart';
import 'package:silvertime/widgets/inputs/custom_input_field.dart';
import 'package:silvertime/widgets/utils/confirm_row.dart';

class ServiceDialog extends StatefulWidget {
  final Service? service;
  const ServiceDialog({super.key, this.service});

  @override
  State<ServiceDialog> createState() => _ServiceDialogState();
}

class _ServiceDialogState extends State<ServiceDialog> {
  late Service service;
  bool _saving = false;
  Map<String, bool> validation = {};
  final _formKey = GlobalKey<FormState> ();
  final ScrollController _scrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();
    service = widget.service ?? Service.empty ();
  }

  void _save () async {
    bool formValidation = _formKey.currentState!.validate();
    setState(() {
      validation = service.isComplete();
    });

    if (validation ["total"]! && formValidation) {
      setState(() {
        _saving = true;
      });
      try { 
        if (widget.service == null) {
          await Provider.of<Services> (context, listen: false).createService(
            service
          );
        } else {
          await Provider.of<Services> (context, listen: false).updateService (
            widget.service!.id, service
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
            initialValue: service.alias,
            label: S.of(context).alias,
            type: TextInputType.text,
            action: TextInputAction.next,
            onChanged: (val) {
              service.alias = val;
            },
            requiredValue: true,
            validation: validation ["alias"] ,
          ),
          CustomInputField (
            initialValue: service.name,
            label: S.of(context).name,
            type: TextInputType.text,
            action: TextInputAction.next,
            onChanged: (val) {
              service.name = val;
            },
            requiredValue: true,
            validation: validation ["name"],
          ),
          CustomInputField (
            initialValue: service.description,
            label: S.of(context).description,
            type: TextInputType.text,
            action: TextInputAction.next,
            onChanged: (val) {
              service.description = val;
            },
            requiredValue: true,
            validation: validation ["description"],
          ),
          CustomDropdownFormField<ServiceType> (
            value: service.type,
            items: ServiceType.values,
            label: S.of(context).type,
            hintItem: 0,
            name: (val) => val.name(context),
            onChanged: (val) {
              setState(() {
                service.type = val!;
              });
            },
            validation: validation['type'],
          )
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
                  widget.service == null
                  ? S.of(context).createService
                  : S.of(context).editService,
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