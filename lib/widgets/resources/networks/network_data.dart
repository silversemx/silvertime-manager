import 'package:provider/provider.dart';
import 'package:silvertime/include.dart';
import 'package:silvertime/models/resources/network.dart';
import 'package:silvertime/models/resources/types.dart';
import 'package:silvertime/providers/resources/networks.dart';
import 'package:silvertime/widgets/custom_table_full_data.dart';
import 'package:silvertime/widgets/resources/networks/network_dialog.dart';

class NetworkData extends StatelessWidget {
  const NetworkData({super.key});
  List<String> columns (BuildContext context) => [
    "Id", 
    S.of(context).name, 
    S.of(context).type,
    S.of(context).address,
    S.of(context).region,
    S.of(context).tier
  ];

  List<DataCell> cells (BuildContext context, Network network) {
    return [
      DataCell(
        Center (
          child: SelectableText (
            network.id,
            style: Theme.of(context).textTheme.headline4,
          ),
        )
      ),
      DataCell(
        Center (
          child: Tooltip(
            message: network.description,
            waitDuration: Duration.zero,
            child: SelectableText (
              network.name,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        )
      ),
      DataCell(
        Center (
          child: SelectableText (
            network.type.name(context),
            style: Theme.of(context).textTheme.headline3!.copyWith(
              color: UIColors.error
            ),
          ),
        )
      ),
      DataCell(
        Center (
          child: SelectableText (
            network.address,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        )
      ),
      DataCell(
        Center (
          child: SelectableText (
            network.region,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        )
      ),
      DataCell(
        Center (
          child: SelectableText (
            network.tier.toString(),
            style: Theme.of(context).textTheme.headline4,
          ),
        )
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Networks>(
      builder: (context, networks, _) {
        return ResourceDataWidget<Network>(
          title: ResourceType.networks.name(context), 
          fetch: networks.getNetworks, 
          dismiss: networks.dismiss,
          createSuccessfullyText: S.of(context).networkSuccessfullyCreated, 
          updateSuccessfullyText: S.of(context).networkSuccessfullyUpdated, 
          deleteSuccessfullyText: S.of(context).networkSuccessfullyDeleted, 
          dialogCall: ([Network? network]) {
            return NetworkDialog (network: network);
          }, 
          id: (network) => network.id,
          deleteDataStream: networks.removeNetworks, 
          deleteProgressDialogTitle: S.of(context).deletingNetworks, 
          data: networks.networks, 
          cells: (network) => cells (context, network), 
          columns: columns(context), 
          pages: networks.pages
        );
      }
    );
  }
}