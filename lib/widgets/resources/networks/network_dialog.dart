import 'package:http_request_utils/models/http_exception.dart';
import 'package:provider/provider.dart';
import 'package:silvertime/include.dart';
import 'package:silvertime/models/resources/network.dart';
import 'package:silvertime/providers/resources/networks.dart';
import 'package:silvertime/widgets/in_app_messages/error_dialog.dart';
import 'package:silvertime/widgets/inputs/custom_dropdown_form.dart';
import 'package:silvertime/widgets/inputs/custom_input_field.dart';
import 'package:silvertime/widgets/utils/confirm_row.dart';

class NetworkDialog extends StatefulWidget {
  final Network? network;
  const NetworkDialog({super.key, this.network});

  @override
  State<NetworkDialog> createState() => _NetworkDialogState();
}

class _NetworkDialogState extends State<NetworkDialog> {
  late Network network;
  bool _saving = false;
  Map<String, bool> validation = {};
  final _formKey = GlobalKey<FormState> ();
  final ScrollController _scrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();
    network = widget.network ?? Network.empty ();
  }

  void _save () async {
    bool formValidation = _formKey.currentState!.validate();
    setState(() {
      validation = network.isComplete();
    });

    if (validation ["total"]! && formValidation) {
      setState(() {
        _saving = true;
      });
      try { 
        if (widget.network == null) {
          await Provider.of<Networks> (context, listen: false).createNetwork(
            network
          );
        } else {
          await Provider.of<Networks> (context, listen: false).updateNetwork (
            widget.network!.id, network
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
            initialValue: network.name,
            label: S.of(context).name,
            type: TextInputType.text,
            action: TextInputAction.next,
            onChanged: (val) {
              network.name = val;
            },
            requiredValue: true,
            validation: validation ["name"],
          ),
          CustomInputField (
            initialValue: network.description,
            label: S.of(context).description,
            type: TextInputType.text,
            action: TextInputAction.next,
            onChanged: (val) {
              network.description = val;
            },
            requiredValue: true,
            validation: validation ["description"],
          ),
          CustomDropdownFormField<NetworkType> (
            value: network.type,
            items: NetworkType.values,
            label: S.of(context).type,
            hintItem: 0,
            name: (val) => val.name(context),
            onChanged: (val) {
              setState(() {
                network.type = val!;
              });
            },
            validation: validation['type'],
          ),
          CustomInputField (
            initialValue: network.address,
            label: S.of(context).address,
            type: TextInputType.text,
            action: TextInputAction.next,
            onChanged: (val) {
              network.address = val;
            },
            requiredValue: true,
            validation: validation ["address"],
          ),
          CustomInputField (
            initialValue: network.region,
            label: S.of(context).region,
            type: TextInputType.text,
            action: TextInputAction.next,
            onChanged: (val) {
              network.region = val;
            },
            requiredValue: true,
            validation: validation ["region"],
          ),
          CustomInputField (
            initialValue: network.tier.toString(),
            label: S.of(context).tier,
            type: TextInputType.number,
            action: TextInputAction.next,
            acceptZeros: false,
            onChanged: (val) {
              network.tier = num.tryParse(val) ?? 0;
            },
            requiredValue: true,
            validation: validation ["tier"],
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
                widget.network == null
                ? S.of(context).createNetwork
                : S.of(context).editNetwork,
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