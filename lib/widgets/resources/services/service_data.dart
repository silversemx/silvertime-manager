import 'package:provider/provider.dart';
import 'package:silvertime/include.dart';
import 'package:silvertime/models/resources/service/service.dart';
import 'package:silvertime/models/resources/types.dart';
import 'package:silvertime/providers/resources/services/services.dart';
import 'package:silvertime/widgets/custom_table_full_data.dart';
import 'package:silvertime/widgets/in_app_messages/status_update_dialog.dart';
import 'package:silvertime/widgets/resources/services/service_dialog.dart';

class ServiceData extends StatelessWidget {
  const ServiceData({super.key});

  List<String> columns (BuildContext context) => [
    "Id", 
    S.of(context).alias,
    S.of(context).name, 
    S.of(context).type,
    S.of(context).status
  ];

  List<DataCell> cells (BuildContext context, Service service) {
    return [
      DataCell(
        Center (
          child: SelectableText (
            service.id,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        )
      ),
      DataCell(
        Center (
          child: SelectableText (
            service.alias,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        )
      ),
      DataCell(
        Center (
          child: SelectableText (
            service.name,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        )
      ),
      DataCell(
        Center (
          child: SelectableText (
            service.type.name(context),
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
              color: UIColors.error
            ),
          ),
        )
      ),
      DataCell(
        Center (
          child: service.status.widget(context)
        ),
        onTap: () => showDialog (
          context: context,
          builder: (ctx) => StatusUpdateDialog<ServiceStatus>(
            values: ServiceStatus.values,
            getWidget: (status) => status.widget(context), 
            getHistory: () => Provider.of<Services>(
              context, listen: false
            ).getServiceStatusHistory(
              service.id
            ), 
            updateStatus: (status, [String? text]) => Provider.of<Services> (
              context, listen: false
            ).updateServiceStatus(
              service.id, 
              status
            )
          ) 
        )
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Services>(
      builder: (context, services, _) {
        return ResourceDataWidget<Service>(
          title: ResourceType.services.name(context),
          fetch: services.getServices,
          dismiss: services.dismiss,
          createSuccessfullyText: S.of(context).serviceSuccessfullyCreated, 
          updateSuccessfullyText: S.of(context).serviceSuccessfullyUpdated, 
          deleteSuccessfullyText: S.of(context).serviceSuccessfullyDeleted, 
          dialogCall: ([Service? service]) {
            return ServiceDialog (service: service);
          }, 
          id: (service) => service.id,
          deleteDataStream: services.removeServices, 
          deleteProgressDialogTitle: S.of(context).deletingServices, 
          data: services.services, 
          cells: (service) => cells (context, service), 
          columns: columns(context),
          access: (service) async {
            locator<NavigationService> ().navigateTo(
              "/resources/service",

              queryParams: {
                "service": service.id
              }
            );
          },
          pages: services.pages
        );
      }
    );
  }
}