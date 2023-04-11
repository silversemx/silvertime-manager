import 'package:provider/provider.dart';
import 'package:silvertime/include.dart';
import 'package:silvertime/models/resources/disk.dart';
import 'package:silvertime/models/resources/types.dart';
import 'package:silvertime/providers/resources/disks.dart';
import 'package:silvertime/widgets/custom_table_full_data.dart';
import 'package:silvertime/widgets/in_app_messages/status_update_dialog.dart';
import 'package:silvertime/widgets/resources/disks/disk_dialog.dart';

class DiskData extends StatelessWidget {
  const DiskData({super.key});
  List<String> columns (BuildContext context) => [
    "Id", 
    S.of(context).name, 
    S.of(context).type,
    S.of(context).size,
    S.of(context).path,
    S.of(context).status,
  ];

  List<DataCell> cells (BuildContext context, Disk disk) {
    return [
      DataCell(
        Center (
          child: SelectableText (
            disk.id,
            style: Theme.of(context).textTheme.headline4,
          ),
        )
      ),
      DataCell(
        Center (
          child: Tooltip(
            message: disk.description,
            waitDuration: Duration.zero,
            child: SelectableText (
              disk.name,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        )
      ),
      DataCell(
        Center (
          child: SelectableText (
            disk.type.name(context),
            style: Theme.of(context).textTheme.headline3!.copyWith(
              color: UIColors.error
            ),
          ),
        )
      ),
      DataCell(
        Center (
          child: SelectableText (
            disk.size.toString(),
            style: Theme.of(context).textTheme.headline4,
          ),
        )
      ),
      DataCell(
        Center (
          child: SelectableText (
            disk.path.toString(),
            style: Theme.of(context).textTheme.headline4,
          ),
        )
      ),
      DataCell(
        Center (
          child: disk.status.widget(context)
        ),
        onTap: () => showDialog (
          context: context,
          builder: (ctx) => StatusUpdateDialog<DiskStatus>(
            values: DiskStatus.values,
            getWidget: (status) => status.widget(context), 
            getHistory: () => Provider.of<Disks>(
              context, listen: false
            ).getDiskStatusHistory(
              disk.id
            ), 
            updateStatus: (status) => Provider.of<Disks> (
              context, listen: false
            ).updateDiskStatus(
              disk.id,
              status
            )
          ) 
        )
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Disks>(
      builder: (context, disks, _) {
        return ResourceDataWidget<Disk>(
          title: ResourceType.disks.name(context), 
          fetch: disks.getDisks, 
          dismiss: disks.dismiss,
          createSuccessfullyText: S.of(context).diskSuccessfullyCreated, 
          updateSuccessfullyText: S.of(context).diskSuccessfullyUpdated, 
          deleteSuccessfullyText: S.of(context).diskSuccessfullyDeleted, 
          dialogCall: ([Disk? disk]) {
            return DiskDialog (disk: disk);
          }, 
          id: (disk) => disk.id,
          deleteDataStream: disks.removeDisks, 
          deleteProgressDialogTitle: S.of(context).deletingDisks, 
          data: disks.disks, 
          cells: (disk) => cells (context, disk), 
          columns: columns (context),
          pages: disks.pages
        );
      }
    );
  }
}