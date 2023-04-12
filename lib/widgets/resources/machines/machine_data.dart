import 'package:provider/provider.dart';
import 'package:silvertime/include.dart';
import 'package:silvertime/models/resources/machine/machine.dart';
import 'package:silvertime/models/resources/types.dart';
import 'package:silvertime/providers/resources/machines.dart';
import 'package:silvertime/widgets/custom_table_full_data.dart';
import 'package:silvertime/widgets/in_app_messages/status_update_dialog.dart';
import 'package:silvertime/widgets/resources/machines/machine_dialog.dart';

class MachineData extends StatelessWidget {
  const MachineData({super.key});
  List<String> columns (BuildContext context) => [
    "Id", 
    S.of(context).alias, 
    S.of(context).name, 
    S.of(context).type,
    S.of(context).region,
    S.of(context).zone,
    S.of(context).status
  ];

  List<DataCell> cells (BuildContext context, Machine machine) {
    return [
      DataCell(
        Center (
          child: SelectableText (
            machine.id,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        )
      ),
      DataCell(
        Center (
          child: SelectableText (
            machine.alias,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        )
      ),
      DataCell(
        Center (
          child: Tooltip(
            message: machine.description,
            waitDuration: Duration.zero,
            child: SelectableText (
              machine.name,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        )
      ),
      DataCell(
        Center (
          child: SelectableText (
            machine.type.name(context),
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
              color: UIColors.error
            ),
          ),
        )
      ),
      DataCell(
        Center (
          child: SelectableText (
            machine.region,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        )
      ),
      DataCell(
        Center (
          child: SelectableText (
            machine.zone,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        )
      ),
      DataCell(
        Center (
          child: machine.status.widget(context)
        ),
        onTap: () => showDialog (
          context: context,
          builder: (ctx) => StatusUpdateDialog<MachineStatus>(
            values: MachineStatus.values,
            getWidget: (status) => status.widget(context), 
            getHistory: () => Provider.of<Machines>(
              context, listen: false
            ).getMachineStatusHistory(
              machine.id
            ), 
            updateStatus: (status, [String? text]) => Provider.of<Machines> (
              context, listen: false
            ).updateMachineStatus(
              machine.id, status
            )
          ) 
        )
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Machines>(
      builder: (context, machines, _) {
        return ResourceDataWidget<Machine>(
          title: ResourceType.machines.name(context), 
          fetch: machines.getMachines, 
          dismiss: machines.dismiss,
          createSuccessfullyText: S.of(context).machineSuccessfullyCreated, 
          updateSuccessfullyText: S.of(context).machineSuccessfullyUpdated, 
          deleteSuccessfullyText: S.of(context).machineSuccessfullyDeleted, 
          dialogCall: ([Machine? machine]) {
            return MachineDialog (machine: machine);
          }, 
          id: (machine) => machine.id,
          deleteDataStream: machines.removeMachines, 
          deleteProgressDialogTitle: S.of(context).deletingMachines, 
          data: machines.machines, 
          cells: (machine) => cells (context, machine), 
          columns: columns(context), 
          pages: machines.pages
        );
      }
    );
  }
}