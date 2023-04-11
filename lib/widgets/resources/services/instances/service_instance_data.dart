import 'package:provider/provider.dart';
import 'package:silvertime/include.dart';
import 'package:silvertime/models/resources/service/service.dart';
import 'package:silvertime/models/resources/service/service_instance.dart';
import 'package:silvertime/models/resources/types.dart';
import 'package:silvertime/providers/resources/services/instances.dart';
import 'package:silvertime/widgets/custom_table_full_data.dart';
import 'package:silvertime/widgets/in_app_messages/status_update_dialog.dart';
import 'package:silvertime/widgets/resources/services/instances/service_instance_dialog.dart';

class ServiceInstanceData extends StatelessWidget {
  const ServiceInstanceData({super.key});

  List<String> columns (BuildContext context) => [
    "Id", 
    S.of(context).name, 
    S.of(context).type,
    S.of(context).address,
    S.of(context).weight,
    S.of(context).status,
  ];
  //TODO: Add machine and options

  List<DataCell> cells (BuildContext context, ServiceInstance instance) {
    return [
      DataCell(
        Center (
          child: SelectableText (
            instance.id,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        )
      ),
      DataCell(
        Center (
          child: Tooltip(
            message: instance.description,
            waitDuration: Duration.zero,
            child: SelectableText (
              instance.name,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        )
      ),
      DataCell(
        Center (
          child: SelectableText (
            instance.type.name(context),
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
              color: UIColors.error
            ),
          ),
        )
      ),
      DataCell(
        Center (
          child: SelectionArea (
            child: Column (
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text (
                  instance.publicAddress.emptyText("No public"),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text (
                  instance.privateAddress.emptyText("No private"),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text (
                  instance.internalAddress.emptyText("No internal"),
                  style: Theme.of(context).textTheme.bodyMedium,
                )
              ],
            ),
          ),
        )
      ),
      DataCell(
        Center (
          child: SelectableText (
            instance.weight.toString(),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        )
      ),
      DataCell(
        Center (
          child: instance.status.widget(context)
        ),
        onTap: () => showDialog (
          context: context,
          builder: (ctx) => StatusUpdateDialog<ServiceStatus>(
            values: ServiceStatus.values,
            getWidget: (status) => status.widget(context), 
            getHistory: () => Provider.of<ServiceInstances>(
              context, listen: false
            ).getServiceStatusHistory(
              instance.id,
            ), 
            updateStatus: (status) => Provider.of<ServiceInstances> (
              context, listen: false
            ).updateServiceStatus(
              instance.id, 
              status
            )
          ) 
        )
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ServiceInstances>(
      builder: (context, instances, _) {
        return ResourceDataWidget<ServiceInstance>(
          title: ResourceServiceType.instances.name(context),
          fetch: instances.getInstances,
          dismiss: instances.dismiss,
          createSuccessfullyText: S.of(context).instanceSuccessfullyCreated, 
          updateSuccessfullyText: S.of(context).instanceSuccessfullyUpdated, 
          deleteSuccessfullyText: S.of(context).instanceSuccessfullyDeleted, 
          dialogCall: ([ServiceInstance? instance]) {
            return ServiceInstanceDialog (instance: instance);
          }, 
          id: (instance) => instance.id,
          deleteDataStream: instances.removeInstances, 
          deleteProgressDialogTitle: S.of(context).deletingServiceInstances, 
          data: instances.instances, 
          cells: (instance) => cells (context, instance), 
          columns: columns(context),
          pages: instances.pages
        );
      }
    );
  }
}