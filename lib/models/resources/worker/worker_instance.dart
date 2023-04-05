import 'package:http_request_utils/body_utils.dart';
import 'package:silvertime/include.dart';
import 'package:silvertime/models/resources/worker/worker_speed.dart';

export 'package:silvertime/models/resources/worker/worker_speed.dart';

enum WorkerInstanceStatus {
  none,
  ready,
  available,
  working,
  stopped,
  ended,
  maintenance,
  deprecated,
  removed
}

extension WorkerInstanceStatusExt on WorkerInstanceStatus {
  String name (BuildContext context) {
    switch (this) {
      case WorkerInstanceStatus.none:
        return S.of(context).status_none;
      case WorkerInstanceStatus.ready:
        return S.of(context).status_ready;
      case WorkerInstanceStatus.available:
        return S.of(context).status_available;
      case WorkerInstanceStatus.working:
        return S.of(context).status_working;
      case WorkerInstanceStatus.stopped:
        return S.of(context).status_stopped;
      case WorkerInstanceStatus.ended:
        return S.of(context).status_ended;
      case WorkerInstanceStatus.maintenance:
        return S.of(context).status_maintenance;
      case WorkerInstanceStatus.deprecated:
        return S.of(context).status_deprecated;
      case WorkerInstanceStatus.removed:
        return S.of(context).status_removed;
    }
  }

  Color get color {
    switch (this) {
      case WorkerInstanceStatus.none:
        return Colors.grey;
      case WorkerInstanceStatus.ready:
        return Colors.blue;
      case WorkerInstanceStatus.available:
        return Colors.green;
      case WorkerInstanceStatus.working:
        return Colors.orange;
      case WorkerInstanceStatus.stopped:
        return Colors.red;
      case WorkerInstanceStatus.ended:
        return Colors.red[800]!;
      case WorkerInstanceStatus.maintenance:
        return Colors.purple;
      case WorkerInstanceStatus.deprecated:
        return Colors.purpleAccent;
      case WorkerInstanceStatus.removed:
        return Colors.black;
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

class WorkerInstance {
  String id = "";
  String worker = "";
  String name = "";
  String description = "";
  String? organization;
  WorkerSpeed speed = WorkerSpeed.none;
  WorkerInstanceStatus status = WorkerInstanceStatus.none;
  DateTime date = DateTime.now ();

  WorkerInstance({
    required this.id,
    required this.worker,
    required this.name,
    required this.description,
    required this.speed,
    required this.status,
    required this.date,
    this.organization,
  });

  WorkerInstance.empty ();

  factory WorkerInstance.fromJson (dynamic json) {
    return WorkerInstance (
      id: jsonField<String> (json, ["_id", "\$oid"], nullable: false),
      worker: jsonField<String> (json, ["worker", "\$oid"], nullable: false),
      name: jsonField<String> (json, ["name",], nullable: false),
      description: jsonField<String> (json, ["description",], nullable: false),
      speed: WorkerSpeed.values [ jsonField<int> (json, ["speed",], defaultValue: 0) ],
      status: WorkerInstanceStatus.values [ jsonField<int> (json, ["status",],  nullable: false) ],
      date: DateTime.fromMillisecondsSinceEpoch(
        jsonField<int> (json, ["date", "\$date"]) ?? 0,  
      ),
      organization: jsonField<String> (json, ["organization", "\$oid"]),
    );
  }

  Map<String, bool> isComplete () {
    bool name = this.name.isNotEmpty;
    bool description = this.description.isNotEmpty;
    bool speed = this.speed != WorkerSpeed.none;

    return {
      "name": !name,
      "description": !description,
      "speed": !speed,
      "total": name &&
        description &&
        speed
    };
  }

  Map<String, dynamic> toJson ()  {
    return {
      "name": name,
      "description": description,
      "organization": organization,
      "speed": speed.index
    };
  }

}