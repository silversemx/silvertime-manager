import 'package:http_request_utils/body_utils.dart';
import 'package:silvertime/include.dart';


enum StorageType {
  none,
  local,
  cloud
}

extension StorageTypeExt on StorageType {
  String name (BuildContext context) {
    switch (this) {
      case StorageType.none:
        return S.of(context).machineType_none;
      case StorageType.local:
        return S.of(context).machineType_local;
      case StorageType.cloud:
        return S.of(context).machineType_cloud;
    }
  }
}

enum StorageGoal {
  none,
  general,
  uploads,
  output,
  recon,
  backup,
  temp,
  cache
}

extension StorageGoalExt on StorageGoal {
  String name (BuildContext context) {
    switch (this) {
      case StorageGoal.none:
        return S.of(context).storageGoal_none;
      case StorageGoal.general:
        return S.of(context).storageGoal_general;
      case StorageGoal.uploads:
        return S.of(context).storageGoal_uploads;
      case StorageGoal.output:
        return S.of(context).storageGoal_output;
      case StorageGoal.recon:
        return S.of(context).storageGoal_recon;
      case StorageGoal.backup:
        return S.of(context).storageGoal_backup;
      case StorageGoal.temp:
        return S.of(context).storageGoal_temp;
      case StorageGoal.cache:
        return S.of(context).storageGoal_cache;
    }
  }
}

enum StorageScope {
  none,
  general,
  service,
  organization,
  project
}

extension StorageScopeExt on StorageScope {
  String name (BuildContext context) {
    switch (this){
      case StorageScope.none:
        return S.of(context).storageScope_none;
      case StorageScope.general:
        return S.of(context).storageScope_general;
      case StorageScope.service:
        return S.of(context).storageScope_service;
      case StorageScope.organization:
        return S.of(context).storageScope_organization;
      case StorageScope.project:
        return S.of(context).storageScope_project;
    }
  }
}

enum StorageStatus {
  none,
  created,
  available,
  down,
  maintenance,
  deprecated,
  removed
}

extension StorageStatusExt on StorageStatus {
  String name (BuildContext context){
    switch (this) {
      case StorageStatus.none:
        return S.of(context).status_none;
      case StorageStatus.created:
        return S.of(context).status_created;
      case StorageStatus.available:
        return S.of(context).status_available;
      case StorageStatus.down:
        return S.of(context).status_down;
      case StorageStatus.maintenance:
        return S.of(context).status_maintenance;
      case StorageStatus.deprecated:
        return S.of(context).status_deprecated;
      case StorageStatus.removed:
        return S.of(context).status_removed;
    }
  }

  Color get color {
    switch (this) {
      case StorageStatus.none:
        return Colors.grey;
      case StorageStatus.created:
        return Colors.blue;
      case StorageStatus.available:
        return Colors.green;
      case StorageStatus.down:
        return Colors.red;
      case StorageStatus.maintenance:
        return Colors.orange;
      case StorageStatus.deprecated:
        return Colors.purple;
      case StorageStatus.removed:
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

class Storage {
  String id = "";
  String disk = "";
  String alias = "";
  String name = "";
  String description = "";
  String path = "";
  StorageType type = StorageType.none;
  StorageGoal goal = StorageGoal.none;
  StorageScope scope = StorageScope.none;
  StorageStatus status = StorageStatus.none;
  DateTime date = DateTime.now ();

  Storage({
    required this.id,
    required this.disk,
    required this.alias,
    required this.name,
    required this.description,
    required this.path,
    required this.type,
    required this.goal,
    required this.scope,
    required this.status,
    required this.date
  });

  Storage.empty ();

  factory Storage.fromJson (dynamic json) {
    return Storage (
      id: jsonField<String> (json, ["_id", "\$oid"]),
      disk: jsonField<String> (json, ["disk", "\$oid"]),
      alias: jsonField<String> (json, ["alias"]),
      name: jsonField<String> (json, ["name"]),
      description: jsonField<String> (json, ["description"]),
      path: jsonField<String> (json, ["path"]),
      type: StorageType.values [jsonField<int> (json, ["storage_type"])],
      goal: StorageGoal.values [jsonField<int> (json, ["goal"])],
      scope: StorageScope.values [jsonField<int> (json, ["scope"])],
      status: StorageStatus.values [jsonField<int> (json, ["status"])],
      date: DateTime.fromMillisecondsSinceEpoch(
        jsonField<int> (json, ["date", "\$date"])??0,
      )
    );
  }

  Map<String, bool> isComplete () {
    bool disk = this.disk.isNotEmpty;
    bool type = this.type != StorageType.none;
    bool goal = this.goal != StorageGoal.none;
    bool scope = this.scope != StorageScope.none;
    bool alias = this.alias.isNotEmpty;
    bool name = this.name.isNotEmpty;
    bool description = this.description.isNotEmpty;
    bool path = this.path.isNotEmpty;

    return {
      "machine": !disk,
      "type": !type,
      "goal": !goal,
      "scope": !scope,
      "alias": !alias,
      "name": !name,
      "description": !description,
      "path": !path,
      "total": disk && 
        type && 
        goal && 
        scope && 
        alias && 
        name && 
        description && 
        path
    };
  }

  Map<String, dynamic> toJson () {
    return {
      "alias": alias,
      "name": name,
      "description": description,
      "disk": disk,
      "path": path,
      "storage_type": type.index,
      "goal": goal.index,
      "scope": scope.index
    };
  }
}