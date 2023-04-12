import 'package:http_request_utils/models/http_exception.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';
import 'package:silvertime/include.dart';
import 'package:silvertime/models/resources/service/service.dart';
import 'package:silvertime/models/resources/service/service_tag.dart';
import 'package:silvertime/providers/resources/services/services.dart';
import 'package:silvertime/providers/resources/services/tags.dart';
import 'package:silvertime/style/container.dart';
import 'package:silvertime/widgets/in_app_messages/error_dialog.dart';
import 'package:silvertime/widgets/inputs/custom_dropdown_form.dart';
import 'package:silvertime/widgets/inputs/custom_input_field.dart';
import 'package:silvertime/widgets/inputs/custom_input_search_field.dart';
import 'package:silvertime/widgets/quill/quill_editor.dart';
import 'package:silvertime/widgets/utils/confirm_row.dart';
import 'package:skeletons/skeletons.dart';

class ServiceDialog extends StatefulWidget {
  final Service? service;
  const ServiceDialog({super.key, this.service});

  @override
  State<ServiceDialog> createState() => _ServiceDialogState();
}

class _ServiceDialogState extends State<ServiceDialog> {
  late Service service;
  bool _loading = true;
  bool _saving = false;
  Map<String, bool> validation = {};
  final _formKey = GlobalKey<FormState> ();
  final ScrollController _scrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();
    service = widget.service ?? Service.empty ();
    Future.microtask(() => _fetchInfo ());
  }

  void _fetchInfo() async {
    setState(() {
      _loading = true;
    });
    try {
      await Provider.of<ServiceTags> (context, listen: false).getServiceTags(
        limit: 0
      );
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

  Widget _tag (ServiceTag tag) {
    return InkWell(
      onTap: () {
        service.removeTagValue (tag.value);

        setState(() {});
      },
      child: Container (
        decoration: containerDecoration.copyWith(
          color: UIColors.primary
        ),
        padding: const EdgeInsets.all(16),
        child: Text (
          tag.name,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: UIColors.white
          ),
        ),
      ),
    );
  }

  Widget _tagsInput () {
    return Consumer<ServiceTags>(
      builder: (context, tags, _) {
        if (_loading) {
          return SkeletonAvatar (
            style: SkeletonAvatarStyle (
              borderRadius: BorderRadius.circular(20),
              height: 52,
              width: double.infinity
            ),
          );
        } else if (tags.tags.isEmpty) {
          return Container(
            decoration: containerDecoration,
            padding: const EdgeInsets.all(16),
            child: Text (
              S.of (context).noInformation,
              style: Theme.of(context).textTheme.displaySmall,
            ),
          );
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomInputSearchField<ServiceTag>  (
              label: S.of(context).serviceTags,
              fetchAfterSubmission: true,
              fetch: (String? text) async {
                return tags.tags.where (
                  (tag) => (
                    (text?.isEmpty ?? true) ||
                    tag.name.formattedSearchText.contains(
                      text?.formattedSearchText ?? ""
                    ) 
                  ) && !tagsFromMask(service.tagsMask, tags.tags).contains (
                    tag
                  )
                
                ).toList();
              },
              onSuggestionTap: (suggestion) {
                setState(() {
                  service.addTagValue(suggestion.value);
                });
              },
              onSubmit: (text) async {
                ServiceTag? tag = tags.tags.firstWhereOrNull(
                  (element) => element.name.formattedSearchText.contains(
                    text.formattedSearchText
                  )
                );

                if (tag != null) {
                  setState(() {
                    service.addTagValue(tag.value);
                  });
                  
                  return tag.name;
                }

                return null;
              },
              searchFieldMap: (tag) => SearchFieldListItem(
                tag.name,
                item: tag
              ),
              clearSelection: () {},
            ),
            const SizedBox(height: 16),
            Container (
              width: double.infinity,
              constraints: BoxConstraints (
                maxHeight: MediaQuery.of(context).size.height * 0.2,
              ),
              child: SingleChildScrollView (
                child: Wrap (
                  alignment: WrapAlignment.spaceEvenly,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: tagsFromMask(
                    service.tagsMask, tags.tags
                  ).map<Widget> (
                    (tag) => _tag (tag)
                  ).toList(),
                ),
              ),
            )
          ],
        );
      }
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
          Container (
            margin: const EdgeInsets.only(bottom: 16),
            height: MediaQuery.of(context).size.height * 0.4,
            child: QuillEditorWidget (
              label: S.of(context).description,
              initialValue: service.description,
              onUpdate: (val) {
                service.description = val;
              },
            ),
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
          ),
          _tagsInput()
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