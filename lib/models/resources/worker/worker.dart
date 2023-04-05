import 'package:http_request_utils/body_utils.dart';
import 'package:silvertime/include.dart';
import 'package:silvertime/models/resources/worker/worker_event.dart';
import 'package:silvertime/models/resources/worker/worker_instance.dart';
import 'package:silvertime/models/resources/worker/worker_resource.dart';


enum WorkerType {
  none,
  core,
  recon,
  web,
  other
}

extension WorkerTypeExt on WorkerType {
  String name (BuildContext context) {
    switch (this) {
      case WorkerType.none:
        return S.of(context).serviceType_none;
      case WorkerType.core:
        return S.of(context).serviceType_core;
      case WorkerType.recon:
        return S.of(context).serviceType_recon;
      case WorkerType.web:
        return S.of(context).serviceType_web;
      case WorkerType.other:
        return S.of(context).serviceType_other;
    }
  }
}

enum WorkerStatus {
  none,
  created,
  available,
  down,
  maintenance,
  deprecated,
  removed
}

extension WorkerStatusExt on WorkerStatus {
  String name (BuildContext context){
    switch (this) {
      case WorkerStatus.none:
        return S.of(context).status_none;
      case WorkerStatus.created:
        return S.of(context).status_created;
      case WorkerStatus.available:
        return S.of(context).status_available;
      case WorkerStatus.down:
        return S.of(context).status_down;
      case WorkerStatus.maintenance:
        return S.of(context).status_maintenance;
      case WorkerStatus.deprecated:
        return S.of(context).status_deprecated;
      case WorkerStatus.removed:
        return S.of(context).status_removed;
    }
  }

  Color get color {
    switch (this) {
      case WorkerStatus.none:
        return Colors.grey;
      case WorkerStatus.created:
        return Colors.blue;
      case WorkerStatus.available:
        return Colors.green;
      case WorkerStatus.down:
        return Colors.red;
      case WorkerStatus.maintenance:
        return Colors.orange;
      case WorkerStatus.deprecated:
        return Colors.purple;
      case WorkerStatus.removed:
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

class Worker {
  String id = "";
  String alias = "";
  String name = "";
  String description = "";
  WorkerType type = WorkerType.none;
  WorkerStatus status = WorkerStatus.none;
  WorkerResource resource = WorkerResource.empty();
  DateTime date = DateTime.now ();

  List<WorkerInstance> instances = [];
  num instancesCount = 0;
  num pages = 0;

  List<WorkerEvent> events = [];
  num eventPages = 0;

  Worker  ({
    required this.id,
    required this.alias,
    required this.name,
    required this.description,
    required this.type,
    required this.status,
    required this.resource,
    required this.date
  });

  Worker.empty ();

  factory Worker.fromJson (dynamic json) {
    return Worker (
      id: jsonField<String> (json, ["_id", "\$oid"], nullable: false),
      alias: jsonField<String> (json, ["alias",],  nullable: false),
      name: jsonField<String> (json, ["name",],  nullable: false),
      description: jsonField<String> (json, ["description",],  nullable: false),
      type: WorkerType.values [ jsonField<int> (json, ["worker_type",],  nullable: false) ],
      resource: jsonClassField<WorkerResource> (json, ["resource"], WorkerResource.fromJson, skipException: true, defaultValue: WorkerResource.empty()),
      status: WorkerStatus.values [ jsonField<int> (json, ["status",],  nullable: false) ],
      date: DateTime.fromMillisecondsSinceEpoch(
        jsonField<int> (json, ["date", "\$date"]),
      )
    );
  }

  Map<String, bool> isComplete () {
    bool type = this.type != WorkerType.none;
    bool alias = this.alias.isNotEmpty;
    bool name = this.name.isNotEmpty;
    bool description = this.description.isNotEmpty;
    bool resource = this.resource.id.isNotEmpty;

    return {
      "type": !type,
      "alias": !alias,
      "name": !name,
      "description": !description,
      "resource": !resource,
      "total": type &&
        alias &&
        name &&
        description &&
        resource
    };
  }

  Map<String, dynamic> toJson (){
    return {
      "worker_type": type.index,
      "alias": alias,
      "name": name,
      "description": description,
      "resource": resource.id,
    };
  }
}