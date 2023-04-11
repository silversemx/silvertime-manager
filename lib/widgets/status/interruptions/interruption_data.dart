import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:silvertime/include.dart';
import 'package:silvertime/models/status/interruption/interruption.dart';
import 'package:silvertime/providers/status/interruptions.dart';
import 'package:silvertime/widgets/custom_table_full_data.dart';
import 'package:silvertime/widgets/in_app_messages/status_snackbar.dart';
import 'package:silvertime/widgets/in_app_messages/status_update_dialog.dart';
import 'package:silvertime/widgets/status/interruptions/interruption_dialog.dart';
import 'package:silvertime/widgets/status/interruptions/solve_interruption_dialog.dart';

class InterruptionData extends StatefulWidget {
  const InterruptionData({super.key});

  @override
  State<InterruptionData> createState() => _InterruptionDataState();
}

class _InterruptionDataState extends State<InterruptionData> {
  List<String> columns (BuildContext context) => [
    "Id", 
    S.of(context).title,
    S.of(context).service,
    S.of(context).instance,
    S.of(context).scope,
    S.of(context).execution,
    S.of(context).start,
    S.of(context).end,
    S.of(context).status,
  ];

  List<DataCell> cells (BuildContext context, Interruption interruption) {
    return [
      DataCell(
        Center (
          child: SelectableText (
            interruption.id,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        )
      ),
      DataCell(
        Center (
          child: ConstrainedBox(
            constraints: BoxConstraints (
              maxWidth: constrainedWidth(context, 80),
            ),
            child: SelectableText (
              interruption.title,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),
        )
      ),
      DataCell(
        Center (
          child: SelectableText (
            interruption.serviceName ?? "N/A",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        onTap: () async {
          if (interruption.service != null) {
            await Clipboard.setData(ClipboardData(text: interruption.service));
            showStatusSnackbar(context, S.of(context).serviceIdCopiedToClipboard);
          }
        }
      ),
      DataCell(
        Center (
          child: SelectableText (
            interruption.instanceName ?? "N/A",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        onTap: () async {
          if (interruption.instance != null) {
            await Clipboard.setData(ClipboardData(text: interruption.instance));
            showStatusSnackbar(context, S.of(context).instanceIdCopiedToClipboard);
          }
        }
      ),
      DataCell(
        Center (
          child: SelectableText (
            interruption.scope.name(context),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        )
      ),
      DataCell(
        Center (
          child: SelectableText (
            interruption.execution.name(context),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        )
      ),
      DataCell(
        Center (
          child: SelectableText (
            interruption.start.dateTimeString,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        )
      ),
      DataCell(
        Center (
          child: SelectableText (
            interruption.end?.dateTimeString ?? "N/A",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        )
      ),
      DataCell(
        Center (
          child: interruption.status.widget(context)
        ),
        onTap: () => showDialog (
          context: context,
          builder: (ctx) => StatusUpdateDialog<InterruptionStatus>(
            values: InterruptionStatus.values,
            getWidget: (status) => status.widget(context), 
            getHistory: () => Provider.of<Interruptions>(
              context, listen: false
            ).getInterruptionStatusHistory(
              interruption.id
            ), 
            updateStatus: (status) => Provider.of<Interruptions> (
              context, listen: false
            ).updateInterruptionStatus(
              interruption.id,
              status
            )
          ) 
        )
      ),
    ];
  }

  void _solve (Interruption interruption) async {
    bool? retval = await showDialog (
      context: context,
      builder: (ctx) => SolveInterruptionDialog (
        interruption: interruption,
      )
    );

    if (retval ?? false) {
      showStatusSnackbar(context, S.of (context).interruptionSuccessfullySolved);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Interruptions>(
      builder: (context, interruptions, _) {
        return ResourceDataWidget<Interruption>(
          title: S.of(context).interruptions,
          fetch: interruptions.getInterruptions, 
          dismiss: interruptions.dismiss,
          createSuccessfullyText: S.of(context).interruptionSuccessfullyCreated, 
          updateSuccessfullyText: S.of(context).interruptionSuccessfullyUpdated, 
          deleteSuccessfullyText: S.of(context).interruptionSuccessfullyDeleted, 
          dialogCall: ([Interruption? interruption]) {
            return InterruptionDialog (interruption: interruption);
          }, 
          id: (interruption) => interruption.id,
          deleteDataStream: interruptions.removeInterruptions, 
          deleteProgressDialogTitle: S.of(context).deletingInterruptions, 
          data: interruptions.interruptions, 
          cells: (interruption) => cells (context, interruption), 
          columns: columns (context),
          pages: interruptions.pages,
          actions: (Interruption interruption) {
            return [
              Visibility(
                visible: interruption.status.index < InterruptionStatus.solved.index,
                child: Container(
                  margin: const EdgeInsets.only(top: 16),
                  child: ElevatedButton (
                    child: Padding (
                      padding: const EdgeInsets.all(8),
                      child: Text (
                        S.of (context).solve,
                        style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          color: UIColors.white
                        ),
                      ),
                    ),
                    onPressed: () {
                      _solve (interruption);
                    },
                  ),
                ),
              )
            ];
          }
        );
      }
    );
  }
}