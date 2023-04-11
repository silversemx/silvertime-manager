import 'package:http_request_utils/models/http_exception.dart';
import 'package:provider/provider.dart';
import 'package:silvertime/include.dart';
import 'package:silvertime/models/resources/machine/machine.dart';
import 'package:silvertime/providers/resources/machines.dart';
import 'package:silvertime/widgets/in_app_messages/error_dialog.dart';
import 'package:silvertime/widgets/inputs/custom_dropdown_form.dart';
import 'package:silvertime/widgets/inputs/custom_input_field.dart';
import 'package:silvertime/widgets/utils/confirm_row.dart';

class MachineDialog extends StatefulWidget {
  final Machine? machine;
  const MachineDialog({super.key, this.machine});

  @override
  State<MachineDialog> createState() => _MachineDialogState();
}

class _MachineDialogState extends State<MachineDialog> {
  late Machine machine;
  bool _saving = false;
  Map<String, bool> validation = {};
  final _formKey = GlobalKey<FormState> ();
  final ScrollController _scrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();
    machine = widget.machine ?? Machine.empty ();
  }

  void _save () async {
    bool formValidation = _formKey.currentState!.validate();
    setState(() {
      validation = machine.isComplete();
    });

    if (validation ["total"]! && formValidation) {
      setState(() {
        _saving = true;
      });
      try { 
        if (widget.machine == null) {
          await Provider.of<Machines> (context, listen: false).createMachine(
            machine
          );
        } else {
          await Provider.of<Machines> (context, listen: false).updateMachine (
            widget.machine!.id, machine
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
            initialValue: machine.alias,
            label: S.of(context).alias,
            type: TextInputType.text,
            action: TextInputAction.next,
            onChanged: (val) {
              machine.alias = val;
            },
            requiredValue: true,
            validation: validation ["alias"],
          ),
          CustomInputField (
            initialValue: machine.name,
            label: S.of(context).name,
            type: TextInputType.text,
            action: TextInputAction.next,
            onChanged: (val) {
              machine.name = val;
            },
            requiredValue: true,
            validation: validation ["name"],
          ),
          CustomInputField (
            initialValue: machine.description,
            label: S.of(context).description,
            type: TextInputType.text,
            action: TextInputAction.next,
            onChanged: (val) {
              machine.description = val;
            },
            requiredValue: true,
            validation: validation ["description"],
          ),
          CustomDropdownFormField<MachineType> (
            value: machine.type,
            items: MachineType.values,
            label: S.of(context).type,
            hintItem: 0,
            name: (val) => val.name(context),
            onChanged: (val) {
              setState(() {
                machine.type = val!;
              });
            },
            validation: validation['type'],
          ),
          CustomInputField (
            initialValue: machine.region,
            label: S.of(context).region,
            type: TextInputType.text,
            action: TextInputAction.next,
            onChanged: (val) {
              machine.region = val;
            },
            requiredValue: true,
            validation: validation ["region"],
          ),
          CustomInputField (
            initialValue: machine.zone,
            label: S.of(context).zone,
            type: TextInputType.text,
            action: TextInputAction.next,
            onChanged: (val) {
              machine.zone = val;
            },
            requiredValue: true,
            validation: validation ["zone"],
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
                  widget.machine == null
                  ? S.of(context).createMachine
                  : S.of(context).editMachine,
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