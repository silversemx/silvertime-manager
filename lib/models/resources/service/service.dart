import 'package:http_request_utils/body_utils.dart';
import 'package:silvertime/include.dart';
import 'package:silvertime/models/resources/service/service_tag.dart';

enum ServiceType {
  none,
  core,
  recon,
  web,
  extra
}

extension ServiceTypeExt on ServiceType {
  String name (BuildContext context) {
    switch (this) {
      case ServiceType.none:
        return S.of(context).serviceType_none;
      case ServiceType.core:
        return S.of(context).serviceType_core;
      case ServiceType.recon:
        return S.of(context).serviceType_recon;
      case ServiceType.web:
        return S.of(context).serviceType_web;
      case ServiceType.extra:
        return S.of(context).serviceType_extra;
    }
  }
}

enum ServiceStatus {
  none,
  created,
  available,
  down,
  maintenance,
  deprecated,
  removed
}

extension ServiceStatusExt on ServiceStatus {
  String name (BuildContext context){
    switch (this) {
      case ServiceStatus.none:
        return S.of(context).status_none;
      case ServiceStatus.created:
        return S.of(context).status_created;
      case ServiceStatus.available:
        return S.of(context).status_available;
      case ServiceStatus.down:
        return S.of(context).status_down;
      case ServiceStatus.maintenance:
        return S.of(context).status_maintenance;
      case ServiceStatus.deprecated:
        return S.of(context).status_deprecated;
      case ServiceStatus.removed:
        return S.of(context).status_removed;
    }
  }

  Color get color {
    switch (this) {
      case ServiceStatus.none:
        return Colors.grey;
      case ServiceStatus.created:
        return Colors.blue;
      case ServiceStatus.available:
        return Colors.green;
      case ServiceStatus.down:
        return Colors.red;
      case ServiceStatus.maintenance:
        return Colors.orange;
      case ServiceStatus.deprecated:
        return Colors.purple;
      case ServiceStatus.removed:
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
        style: Theme.of(context).textTheme.headlineMedium!.copyWith(
          color: getColorContrast(color)
        ),
      ),
    );
  }
}

class Service {
  String id = "";
  String alias = "";
  String name = "";
  String description = "";
  ServiceType type = ServiceType.none;
  ServiceStatus status = ServiceStatus.none;
  DateTime date = DateTime.now();

  int tagsMask = 0;

  List<ServiceTag> tags (List<ServiceTag> all) {
    return Service.getTagsFromMask(tagsMask, all);
  }

  static getTagsFromMask (int mask, List<ServiceTag> all) {
    List<ServiceTag> retval = [];

    for (ServiceTag tag in all) {
      if (tag.value & mask == tag.value) {
        retval.add (tag);
      }
    }

    return retval;
  }

  void addTagValue (int value) {
    if (tagsMask > 0) {
      tagsMask = tagsMask | value;
    } else {
      tagsMask = value;
    }
  }

  void removeTagValue (int value) {
    tagsMask = tagsMask ^ value;
  }

  bool containsTag (int value) {
    return tagsMask & value == value && value > 0;
  }

  Service  ({
    required this.id,
    required this.alias,
    required this.name,
    required this.description,
    required this.type,
    required this.status,
    required this.date,
    required this.tagsMask
  });

  Service.tokenData ({
    required this.id,
    required this.type,
    required this.alias,
    required this.name,
  });
  
  Service.empty ();

  factory Service.fromJson (dynamic json) {
    return Service(
      id: jsonField<String> (json, ["_id", "\$oid"], nullable: false),
      alias: jsonField<String> (json, ["alias"], nullable: false),
      name: jsonField<String> (json, ["name"], nullable: false),
      description:jsonField<String> (json, ["description"], nullable: false),
      type: ServiceType.values [ jsonField<int> (json, ["service_type"]) ],
      status: ServiceStatus.values [ jsonField<int> (json, ["status"], nullable: false)],
      date: DateTime.fromMillisecondsSinceEpoch(
        jsonField<int> (json, ["date", "\$date"]) ?? 0,
      ),
      tagsMask:  jsonField<int> (json, ["tags",],  defaultValue: 0),
    );
  }

  factory Service.fromJsonTokenData (dynamic json) {
    return Service.tokenData (
      id: jsonField<String> (json, ["_id", "\$oid"], nullable: false),
      alias: jsonField<String> (json, ["alias"], nullable: false),
      name: jsonField<String> (json, ["name"], nullable: false),
      type: ServiceType.values [ jsonField<int> (json, ["service_type"]) ],
    );
  }

  Map<String, bool> isComplete (){
    bool alias = this.alias.isNotEmpty;
    bool name = this.name.isNotEmpty;
    bool description = this.description.isNotEmpty;
    bool type = this.type != ServiceType.none;

    return {
      "alias": !alias,
      "name": !name,
      "description": !description,
      "type": !type,
      "total": alias &&
        name &&
        type &&
        description 
    };
  }

  Map<String, dynamic> toJson () {
    return {
      "alias": alias,
      "name": name,
      "description": description,
      "service_type": type.index,
      "tags": tagsMask
    };
  }
}