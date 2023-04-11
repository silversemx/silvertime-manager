import 'package:http_request_utils/models/http_exception.dart';
import 'package:provider/provider.dart';
import 'package:silvertime/include.dart';
import 'package:silvertime/models/resources/service/service_tag.dart';
import 'package:silvertime/providers/resources/services/tags.dart';
import 'package:silvertime/widgets/in_app_messages/error_dialog.dart';
import 'package:silvertime/widgets/inputs/custom_input_field.dart';
import 'package:silvertime/widgets/utils/confirm_row.dart';

class ServiceTagDialog extends StatefulWidget {
  final ServiceTag? serviceTag;
  const ServiceTagDialog({super.key, this.serviceTag});

  @override
  State<ServiceTagDialog> createState() => _ServiceTagDialogState();
}

class _ServiceTagDialogState extends State<ServiceTagDialog> {
  late ServiceTag serviceTag;
  bool _saving = false;
  Map<String, bool> validation = {};
  final _formKey = GlobalKey<FormState> ();
  final ScrollController _scrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();
    serviceTag = widget.serviceTag ?? ServiceTag.empty ();
  }

  void _save () async {
    bool formValidation = _formKey.currentState!.validate();
    setState(() {
      validation = serviceTag.isComplete();
    });

    if (validation ["total"]! && formValidation) {
      setState(() {
        _saving = true;
      });
      try { 
        if (widget.serviceTag == null) {
          await Provider.of<ServiceTags> (context, listen: false).createServiceTag(
            serviceTag
          );
        } else {
          await Provider.of<ServiceTags> (context, listen: false).updateServiceTag (
            widget.serviceTag!.id, serviceTag
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
            initialValue: serviceTag.name,
            label: S.of(context).name,
            type: TextInputType.text,
            action: TextInputAction.next,
            onChanged: (val) {
              serviceTag.name = val;
            },
            requiredValue: true,
            validation: validation ["name"],
          ),
          CustomInputField (
            initialValue: serviceTag.description,
            label: S.of(context).description,
            type: TextInputType.text,
            action: TextInputAction.next,
            onChanged: (val) {
              serviceTag.description = val;
            },
            requiredValue: true,
            validation: validation ["description"],
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
                  widget.serviceTag == null
                  ? S.of(context).createServiceTag
                  : S.of(context).editServiceTag,
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