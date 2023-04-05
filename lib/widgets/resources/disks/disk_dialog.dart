import 'package:http_request_utils/models/http_exception.dart';
import 'package:provider/provider.dart';
import 'package:silvertime/include.dart';
import 'package:silvertime/models/resources/disk.dart';
import 'package:silvertime/providers/resources/disks.dart';
import 'package:silvertime/widgets/in_app_messages/error_dialog.dart';
import 'package:silvertime/widgets/inputs/custom_dropdown_form.dart';
import 'package:silvertime/widgets/inputs/custom_input_field.dart';
import 'package:silvertime/widgets/utils/confirm_row.dart';

class DiskDialog extends StatefulWidget {
  final Disk? disk;
  const DiskDialog({super.key, this.disk});

  @override
  State<DiskDialog> createState() => _DiskDialogState();
}

class _DiskDialogState extends State<DiskDialog> {
  late Disk disk;
  bool _saving = false;
  Map<String, bool> validation = {};
  final _formKey = GlobalKey<FormState> ();
  final ScrollController _scrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();
    disk = widget.disk ?? Disk.empty ();
  }

  void _save () async {
    bool formValidation = _formKey.currentState!.validate();
    setState(() {
      validation = disk.isComplete();
    });

    if (validation ["total"]! && formValidation) {
      setState(() {
        _saving = true;
      });
      try { 
        if (widget.disk == null) {
          await Provider.of<Disks> (context, listen: false).createDisk(
            disk
          );
        } else {
          await Provider.of<Disks> (context, listen: false).updateDisk (
            widget.disk!.id, disk
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
            initialValue: disk.name,
            label: S.of(context).name,
            type: TextInputType.text,
            action: TextInputAction.next,
            onChanged: (val) {
              disk.name = val;
            },
            requiredValue: true,
            validation: validation ["name"],
          ),
          CustomInputField (
            initialValue: disk.description,
            label: S.of(context).description,
            type: TextInputType.text,
            action: TextInputAction.next,
            onChanged: (val) {
              disk.description = val;
            },
            requiredValue: true,
            validation: validation ["description"],
          ),
          CustomDropdownFormField<DiskType> (
            value: disk.type,
            items: DiskType.values,
            label: S.of(context).type,
            hintItem: 0,
            name: (val) => val.name(context),
            onChanged: (val) {
              setState(() {
                disk.type = val!;
              });
            },
            validation: validation['type'],
          ),
          CustomInputField (
            initialValue: disk.image,
            label: S.of(context).image,
            type: TextInputType.text,
            action: TextInputAction.next,
            onChanged: (val) {
              disk.image = val;
            },
            requiredValue: true,
            validation: validation ["image"],
          ),
          CustomInputField (
            initialValue: disk.size.toString(),
            label: S.of(context).size,
            type: TextInputType.number,
            action: TextInputAction.next,
            acceptZeros: false,
            onChanged: (val) {
              disk.size = num.tryParse(val) ?? 0;
            },
            requiredValue: true,
            validation: validation ["size"],
          ),
          CustomInputField (
            initialValue: disk.deviceName,
            label: S.of(context).deviceName,
            type: TextInputType.number,
            action: TextInputAction.next,
            acceptZeros: false,
            onChanged: (val) {
              disk.deviceName = val;
            },
            requiredValue: true,
            validation: validation ["deviceName"],
          ),
          CustomInputField (
            initialValue: disk.path,
            label: S.of(context).path,
            type: TextInputType.number,
            action: TextInputAction.next,
            acceptZeros: false,
            onChanged: (val) {
              disk.path = val;
            },
            requiredValue: true,
            validation: validation ["path"],
          ),
          CustomInputField (
            initialValue: disk.format,
            label: S.of(context).format,
            type: TextInputType.number,
            action: TextInputAction.next,
            acceptZeros: false,
            onChanged: (val) {
              disk.format = val;
            },
            requiredValue: true,
            validation: validation ["format"],
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
        child: Container (
          padding: const EdgeInsets.all(16),
          child: Column (
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text (
                widget.disk == null
                ? S.of(context).createDisk
                : S.of(context).editDisk,
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
    );
  }
}