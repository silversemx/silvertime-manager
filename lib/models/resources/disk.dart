import 'package:http_request_utils/body_utils.dart';
import 'package:silvertime/include.dart';
import 'package:silvertime/models/resources/storage.dart';

enum DiskStatus {
  none,
  created,
  available,
  down,
  deprecated,
  removed
}

extension DiskStatusExt on DiskStatus {
  String name (BuildContext context){
    switch (this) {
      case DiskStatus.none:
        return S.of(context).status_none;
      case DiskStatus.created:
        return S.of(context).status_created;
      case DiskStatus.available:
        return S.of(context).status_available;
      case DiskStatus.down:
        return S.of(context).status_down;
      case DiskStatus.deprecated:
        return S.of(context).status_deprecated;
      case DiskStatus.removed:
        return S.of(context).status_removed;
    }
  }

  Color get color {
    switch (this) {
      case DiskStatus.none:
        return Colors.grey;
      case DiskStatus.created:
        return Colors.blue;
      case DiskStatus.available:
        return Colors.green;
      case DiskStatus.down:
        return Colors.red;
      case DiskStatus.deprecated:
        return Colors.purple;
      case DiskStatus.removed:
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

enum DiskType {
  none,
  standard,
  balanced,
  ssd,
  extreme
}

extension DiskTypeExt on DiskType {
  String name (BuildContext context) {
    switch (this) {
      case DiskType.none:
        return S.of(context).diskType_none;
      case DiskType.standard:
        return S.of(context).diskType_standard;
      case DiskType.balanced:
        return S.of(context).diskType_balanced;
      case DiskType.ssd:
        return S.of(context).diskType_ssd;
      case DiskType.extreme:
        return S.of(context).diskType_extreme;
    }
  }
}

class Disk {
  String id = "";
  String name = "";
  String description = "";
  DiskStatus status = DiskStatus.none;
  DiskType type = DiskType.none;
  String image = "";
  num size = 0;
  String deviceName = "";
  String path = "";
  String format = "";
  DateTime date = DateTime.now ();

  // Local Fields
  List<Storage> storages = [];
  num pages = 0;

  Disk ({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.type,
    required this.image,
    required this.size,
    required this.deviceName,
    required this.path,
    required this.format,
    required this.date
  });

  Disk.empty ();

  factory Disk.fromJson (dynamic json) {
    return Disk (
      id: jsonField<String> (json, ["_id", "\$oid"], nullable: false),
      name: jsonField<String> (json, ["name",],  nullable: false),
      description: jsonField<String> (json, ["description",],  nullable: false),
      status: DiskStatus.values [ jsonField<int> (json, ["status",],  nullable: false) ],
      type: DiskType.values [ jsonField<int> (json, ["disk_type",],  nullable: false) ],
      image: jsonField<String> (json, ["image",],  nullable: false),
      size: jsonField<num> (json, ["size",],  nullable: false),
      deviceName: jsonField<String> (json, ["device_name",],  nullable: false),
      path: jsonField<String> (json, ["path",],  nullable: false),
      format: jsonField<String> (json, ["format",],  nullable: false),
      date: DateTime.fromMillisecondsSinceEpoch(
        jsonField<int> (json, ["date", "\$date"]),
      )
    );
  }

  Map<String, bool> isComplete () {
    bool name = this.name.isNotEmpty;
    bool description = this.description.isNotEmpty;
    bool type = this.type != DiskType.none;
    bool image = this.image.isNotEmpty;
    bool size = this.size > 0;
    bool deviceName = this.deviceName.isNotEmpty;
    bool path = this.path.isNotEmpty;
    bool format = this.format.isNotEmpty;

    return {
      "name": !name,
      "description": !description,
      "type": !type,
      "image": !image,
      "size": !size,
      "deviceName": !deviceName,
      "path": !path,
      "format": !format,   
      "total": name &&
        description &&
        type &&
        image &&
        size &&
        deviceName &&
        path &&
        format  
    };
  }

  Map<String, dynamic> toJson () {
    return {
      "name": name,
      "description": description,
      "disk_type": type.index,
      "image": image,
      "size": size,
      "device_name": deviceName,
      "path": path,
      "format": format,
    };
  }

}