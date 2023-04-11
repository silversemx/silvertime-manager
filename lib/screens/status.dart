import 'package:shared_preferences/shared_preferences.dart';
import 'package:silvertime/include.dart';
import 'package:silvertime/style/container.dart';
import 'package:silvertime/widgets/inputs/custom_dropdown_form.dart';
import 'package:silvertime/widgets/status/interruptions/interruption_data.dart';
import 'package:silvertime/widgets/status/maintenances/maintenance_data.dart';

enum StatusType {
  none,
  maintenance,
  interruption
}

extension StatusTypeExt on StatusType {
  String name (BuildContext context) {
    switch (this) {
      case StatusType.none:
        return S.of(context).selectOne;
      case StatusType.maintenance:
        return S.of(context).maintenance;
      case StatusType.interruption:
        return S.of(context).interruptions;
    }
  }
}

class StatusScreen extends StatefulWidget {
  const StatusScreen({Key? key}) : super (key: key);
  static const String routeName = "/status";

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  StatusType _type = StatusType.none;
  StatusType get type => _type;

  set type (StatusType newType) {
    _type = newType;
    locator<SharedPreferences> ().setInt("status_type", _type.index);
  }

  @override
  void initState() {
    super.initState();
    _type = StatusType.values [
      locator<SharedPreferences> ().getInt("status_type") ?? 0
    ];
  }

  Widget _title () {
    return SizedBox (
      width: double.infinity,
      child: Wrap (
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 16,
        runSpacing: 32,
        children: [
          Text (
            S.of(context).status,
            style: Theme.of(context).textTheme.displayLarge,
          ),
          Container (
            decoration: containerDecoration,
            padding: const EdgeInsets.all(16),
            width: constrainedWidth(
              context, 
              MediaQuery.of(context).size.width * 0.4,
              shouldConstraint: MediaQuery.of(context).size.width < 800,
            ),
            child: CustomDropdownFormField<StatusType> (
              value: type,
              items: StatusType.values,
              label: S.of(context).type,
              name: (val) => val.name (context),
              onChanged: (val) {
                setState(() {
                  type = val!;
                });
              },
              validation: false,
              margin: EdgeInsets.zero,
              hintItem: 0,
              dropdownColor: Theme.of(context).colorScheme.background,
            ),
          )
        ],
      ),
    );
  }

  Widget _data () {
    switch (type) {
      case StatusType.none:
        return Container ();
      case StatusType.maintenance:
        return const MaintenanceData();
      case StatusType.interruption:
        return const InterruptionData ();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.1
      ),
      child: Column (
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          _title (),
          const Divider (
            thickness: 0.5,
            height: 48,
          ),
          const SizedBox(height: 16),
          Visibility(
            visible: type != StatusType.none,
            child: _data ()
          )
        ],
      ),
    );
  }
}