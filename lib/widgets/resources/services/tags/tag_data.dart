import 'package:provider/provider.dart';
import 'package:silvertime/include.dart';
import 'package:silvertime/models/resources/service/service_tag.dart';
import 'package:silvertime/models/resources/types.dart';
import 'package:silvertime/providers/resources/services/tags.dart';
import 'package:silvertime/widgets/custom_table_full_data.dart';
import 'package:silvertime/widgets/resources/services/tags/tag_dialog.dart';

class ServiceTagData extends StatelessWidget {
  const ServiceTagData({super.key});

  List<String> columns (BuildContext context) => [
    "Id", 
    S.of(context).name, 
    S.of(context).value
  ];

  List<DataCell> cells (BuildContext context, ServiceTag serviceTag) {
    return [
      DataCell(
        Center (
          child: SelectableText (
            serviceTag.id,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        )
      ),
      DataCell(
        Center (
          child: Tooltip(
            message: serviceTag.description,
            waitDuration: Duration.zero,
            child: SelectableText (
              serviceTag.name,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        )
      ),
      DataCell(
        Center (
          child: SelectableText (
            serviceTag.value.toString(),
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
              color: UIColors.error
            ),
          ),
        )
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ServiceTags>(
      builder: (context, serviceTags, _) {
        return ResourceDataWidget<ServiceTag>(
          title: ResourceType.serviceTags.name(context),
          fetch: serviceTags.getServiceTags, 
          dismiss: serviceTags.dismiss,
          createSuccessfullyText: S.of(context).serviceTagSuccessfullyCreated, 
          updateSuccessfullyText: S.of(context).serviceTagSuccessfullyUpdated, 
          deleteSuccessfullyText: S.of(context).serviceTagSuccessfullyDeleted, 
          dialogCall: ([ServiceTag? serviceTag]) {
            return ServiceTagDialog (serviceTag: serviceTag);
          }, 
          id: (serviceTag) => serviceTag.id,
          deleteDataStream: serviceTags.removeServiceTags, 
          deleteProgressDialogTitle: S.of(context).deletingServiceTags, 
          data: serviceTags.tags, 
          cells: (serviceTag) => cells (context, serviceTag), 
          columns: columns(context),
          pages: serviceTags.pages
        );
      }
    );
  }
}