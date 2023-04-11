import 'package:provider/provider.dart';
import 'package:silvertime/include.dart';
import 'package:silvertime/models/status/maintenance/maintenance.dart';
import 'package:silvertime/providers/status/maintenances.dart';
import 'package:silvertime/widgets/custom_table_full_data.dart';
import 'package:silvertime/widgets/in_app_messages/status_update_dialog.dart';
import 'package:silvertime/widgets/status/maintenances/maintenance_dialog.dart';

class MaintenanceData extends StatelessWidget {
  const MaintenanceData({super.key});
  List<String> columns (BuildContext context) => [
    "Id", 
    S.of(context).name, 
    S.of(context).type,
    S.of(context).size,
    S.of(context).path,
    S.of(context).status,
  ];

  List<DataCell> cells (BuildContext context, Maintenance maintenance) {
    return [
      DataCell(
        Center (
          child: SelectableText (
            maintenance.id,
            style: Theme.of(context).textTheme.headline4,
          ),
        )
      ),
      DataCell(
        Center (
          child: SelectableText (
            maintenance.scope.name(context),
            style: Theme.of(context).textTheme.bodyText1,
          ),
        )
      ),
      DataCell(
        Center (
          child: SelectableText (
            maintenance.time.name(context),
            style: Theme.of(context).textTheme.bodyText1,
          ),
        )
      ),
      DataCell(
        Center (
          child: SelectableText (
            maintenance.start.dateTimeString,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        )
      ),
      DataCell(
        Center (
          child: SelectableText (
            maintenance.end?.dateTimeString ?? "N/A",
            style: Theme.of(context).textTheme.bodyText1,
          ),
        )
      ),
      DataCell(
        Center (
          child: maintenance.status.widget(context)
        ),
        onTap: () => showDialog (
          context: context,
          builder: (ctx) => StatusUpdateDialog<MaintenanceStatus>(
            values: MaintenanceStatus.values,
            getWidget: (status) => status.widget(context), 
            getHistory: () => Provider.of<Maintenances>(
              context, listen: false
            ).getMaintenanceStatusHistory(
              maintenance.id
            ), 
            updateStatus: (status) => Provider.of<Maintenances> (
              context, listen: false
            ).updateMaintenanceStatus(
              maintenance.id,
              status
            )
          ) 
        )
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Maintenances>(
      builder: (context, maintenances, _) {
        return ResourceDataWidget<Maintenance>(
          title: S.of(context).maintenance,
          fetch: maintenances.getMaintenances, 
          dismiss: maintenances.dismiss,
          createSuccessfullyText: S.of(context).maintenanceSuccessfullyCreated, 
          updateSuccessfullyText: S.of(context).maintenanceSuccessfullyUpdated, 
          deleteSuccessfullyText: S.of(context).maintenanceSuccessfullyDeleted, 
          dialogCall: ([Maintenance? maintenance]) {
            return MaintenanceDialog (maintenance: maintenance);
          }, 
          id: (maintenance) => maintenance.id,
          deleteDataStream: maintenances.removeMaintenances, 
          deleteProgressDialogTitle: S.of(context).deletingMaintenances, 
          data: maintenances.maintenances, 
          cells: (maintenance) => cells (context, maintenance), 
          columns: columns (context),
          pages: maintenances.pages
        );
      }
    );
  }
}