import 'package:http_request_utils/body_utils.dart';
import 'package:silvertime/include.dart';
import 'package:silvertime/models/resources/service/service.dart';
import 'package:silvertime/models/resources/service/service_option.dart';

enum ServiceInstanceType {
  none,
  local,
  cloud,
  other
}

extension ServiceInstanceTypeExt on ServiceInstanceType {
  String name (BuildContext context) {
    switch (this) {
      case ServiceInstanceType.none:
        return S.of(context).serviceInstanceType_none;
      case ServiceInstanceType.local:
        return S.of(context).serviceInstanceType_local;
      case ServiceInstanceType.cloud:
        return S.of(context).serviceInstanceType_cloud;
      case ServiceInstanceType.other:
        return S.of(context).serviceInstanceType_other;
    }
  }
}

class ServiceInstance {
  String id = "";
  String service = "";
  String machine = "62b27d97890442e063207b48";
  String name = "";
  String description = "";
  ServiceOption? options;
  String publicAddress = "";
  String privateAddress = "";
  String internalAddress = "";
  num weight = 0;
  int index = -1;
  ServiceInstanceType type = ServiceInstanceType.none;
  ServiceStatus status = ServiceStatus.none;
  DateTime date = DateTime.now ();

  ServiceInstance({
    required this.id,
    required this.service,
    required this.machine,
    required this.name,
    required this.description,
    required this.publicAddress,
    required this.privateAddress,
    required this.internalAddress,
    required this.weight,
    required this.index,
    required this.type,
    required this.status,
    required this.date,
    this.options
  });

  ServiceInstance.empty ();

  factory ServiceInstance.fromJson (dynamic json) {
    return ServiceInstance (
      id: jsonField<String> (json, ["_id", "\$oid"], nullable: false),
      service: jsonField<String> (json, ["service", "\$oid"], nullable: false),
      machine: jsonField<String> (json, ["machine", "\$oid"], nullable: false),
      name: jsonField<String> (json, ["name",], nullable: false),
      description: jsonField<String> (json, ["description",], nullable: false),
      publicAddress: jsonField<String> (json, ["public_address",],  defaultValue: ""),
      privateAddress: jsonField<String> (json, ["private_address",],  defaultValue: ""),
      internalAddress: jsonField<String> (json, ["internal_address",],  defaultValue: ""),
      weight: jsonField<num> (json, ["weight",],  nullable: false),
      index: jsonField<int> (json, ["instance_idx",],  nullable: false),
      type: ServiceInstanceType.values [ jsonField<int> (json, ["instance_type",],  nullable: false) ],
      status: ServiceStatus.values [ jsonField<int> (json, ["status",],  nullable: false) ],
      date: DateTime.fromMillisecondsSinceEpoch(
        jsonField<int> (json, ["date", "\$date"]) ?? 0,  
      ),
      options: jsonClassField<ServiceOption> (json, ["options",], ServiceOption.fromJson, skipException: true),
    );
  }

  Map<String, bool> isComplete () {
    bool name = this.name.isNotEmpty;
    bool description = this.description.isNotEmpty;
    bool machine = this.machine.isNotEmpty;
    // bool internalAddress = this.internalAddress.isNotEmpty;
    bool weight = this.weight > 0;
    bool type = this.type != ServiceInstanceType.none;

    return {
      "name": !name,
      "description": !description,
      "machine": !machine,
      // "internalAddress": !internalAddress,
      "weight": !weight,
      "type": !type,
      "total": name &&
        description &&
        machine &&
        // internalAddress &&
        weight &&
        type
    };
  }

  Map<String, dynamic> toJson ()  {
    return {
      "name": name,
      "description": description,
      "public_address": publicAddress,
      "private_address": privateAddress,
      "internal_address": internalAddress,
      "options": options?.id,
      "machine": machine,
      "weight": weight,
      "instance_type": type.index,
    };
  }

}