import 'package:http_request_utils/body_utils.dart';
import 'package:silvertime/include.dart';

enum MachineType {
  none,
  local,
  cloud
}

extension MachineTypeExt on MachineType {
  String name (BuildContext context) {
    switch (this) {
      case MachineType.none:
        return S.of(context).machineType_none;
      case MachineType.local:
        return S.of(context).machineType_local;
      case MachineType.cloud:
        return S.of(context).machineType_cloud;
    }
  }
}

enum MachineStatus {
  none,
  created,
  available,
  down,
  maintenance,
  deprecated,
  removed
}

extension MachineStatusExt on MachineStatus {
  String name (BuildContext context){
    switch (this) {
      case MachineStatus.none:
        return S.of(context).status_none;
      case MachineStatus.created:
        return S.of(context).status_created;
      case MachineStatus.available:
        return S.of(context).status_available;
      case MachineStatus.down:
        return S.of(context).status_down;
      case MachineStatus.maintenance:
        return S.of(context).status_maintenance;
      case MachineStatus.deprecated:
        return S.of(context).status_deprecated;
      case MachineStatus.removed:
        return S.of(context).status_removed;
    }
  }

  Color get color {
    switch (this) {
      case MachineStatus.none:
        return Colors.grey;
      case MachineStatus.created:
        return Colors.blue;
      case MachineStatus.available:
        return Colors.green;
      case MachineStatus.down:
        return Colors.red;
      case MachineStatus.maintenance:
        return Colors.orange;
      case MachineStatus.deprecated:
        return Colors.purple;
      case MachineStatus.removed:
        return const Color.fromARGB(255, 92, 12, 12);
    }
  }

  Widget widget (BuildContext context) {
    return Container (
      margin: const EdgeInsets.symmetric(
        vertical: 8
      ),
      padding: const EdgeInsets.all (8),
      decoration: BoxDecoration (
        color: color,
        borderRadius: BorderRadius.circular(24)
      ),
      child: Text (
        name (context),
        style: Theme.of(context).textTheme.headline4!.copyWith(
          color: getColorContrast(color)
        ),
      ),
    );
  }
}

class Machine {
  String id = "";
  String alias = "";
  String name = "";
  String description = "";
  String region = "";
  String zone = "";
  MachineType type = MachineType.none;
  MachineStatus status = MachineStatus.none;
  DateTime date = DateTime.now ();

  Machine({
    required this.id,
    required this.alias,
    required this.name,
    required this.description,
    required this.region,
    required this.zone,
    required this.type,
    required this.status,
    required this.date,
  });

  Machine.empty ();

  factory Machine.fromJson (dynamic json) {
    return Machine (
      id: jsonField<String> (json, ["_id", "\$oid"]),
      alias: jsonField<String> (json, ["alias"]),
      name: jsonField<String> (json, ["name"]),
      description: jsonField<String> (json, ["description"]),
      region: jsonField<String> (json, ["region"],  nullable: false),
      zone: jsonField<String> (json, ["zone"],  nullable: false),
      type: MachineType.values [jsonField<int> (json, ["machine_type"])],
      status: MachineStatus.values [jsonField<int> (json, ["status"])],
      date: DateTime.fromMillisecondsSinceEpoch(
        jsonField<int> (json, ["date", "\$date"]) ?? 0,
      )
    );
  }

  Map<String, bool> isComplete () {
    bool type = this.type != MachineType.none;
    bool alias = this.alias.isNotEmpty;
    bool name = this.name.isNotEmpty;
    bool description = this.description.isNotEmpty;
    bool region = this.region.isNotEmpty;
    bool zone = this.zone.isNotEmpty;

    return {
      "type": !type,
      "alias": !alias,
      "name": !name,
      "description": !description,
      "region": !region,
      "zone": !zone,
      "total": type  &&
        alias &&
        name &&
        description &&
        region &&
        zone
    };
  }

  Map<String, dynamic> toJson () {
    return {
      "alias": alias,
      "name": name,
      "description": description,
      "region": region,
      "zone": zone,
      "machine_type": type.index,
    };
  }
}