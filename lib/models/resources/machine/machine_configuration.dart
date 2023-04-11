import 'package:http_request_utils/body_utils.dart';
import 'package:silvertime/models/resources/network.dart';

class GPU {
  String gpuType = "";
  num count = 0;

  GPU ({
    required this.gpuType,
    required this.count
  });

  GPU.empty ();

  factory GPU.fromJson (dynamic json) {
    return GPU (
      gpuType: jsonField<String> (json, ["gpu_type"],  nullable: false),
      count: jsonField<num> (json, ["count"],  nullable: false),
    );
  }

  bool get isNotEmpty {
    bool gpuType = this.gpuType.isNotEmpty;
    bool count = this.count > 0;

    return gpuType && count;
  }

  Map<String, dynamic> toJson () {
    return {
      "gpu_type": gpuType,
      "count": count
    };
  }
}

class Networking {
  String hostname = "";
  String internal = "";
  Network external = Network.empty();

  Networking ({
    required this.hostname,
    required this.internal,
    required this.external
  });

  Networking.empty ();

  factory Networking.fromJson (dynamic json) {
    return Networking (
      hostname: jsonField<String> (json, ["hostname"],  nullable: false),
      internal: jsonField<String> (json, ["internal"],  nullable: false),
      external: Network.fromJson(
        jsonField<dynamic> (json, ["external"], nullable: false)
      ),
    );
  }

  bool get isNotEmpty {
    bool hostname = this.hostname.isNotEmpty;
    bool internal = this.internal.isNotEmpty;
    bool external = this.external.id.isNotEmpty;

    return hostname &&
      internal &&
      external;
  }

  Map<String, dynamic> toJson () {
    return {
      "hostname": hostname,
      "internal": internal,
      "external": external.id,
    };
  }
}

class MachineConfiguration {
  String id = "";
  String machine = "";
  String platform = "";
  String series = "";
  String template = "";
  int cores = 0;
  num memory = 0;
  GPU gpus = GPU.empty ();
  Networking networking = Networking.empty ();

  MachineConfiguration ({
    required this.id,
    required this.machine,
    required this.platform,
    required this.series,
    required this.template,
    required this.cores,
    required this.memory,
    required this.gpus,
    required this.networking,
  });

  MachineConfiguration.empty ();

  factory MachineConfiguration.fromJson (dynamic json) {
    return MachineConfiguration (
      id: jsonField<String> (json, ["_id", "\$oid"], nullable: false),
      machine: jsonField<String> (json, ["machine", "\$oid"], nullable: false),
      platform: jsonField<String> (json, ["platform"],  nullable: false),
      series: jsonField<String> (json, ["series",],  nullable: false),
      template: jsonField<String> (json, ["template",],  nullable: false),
      cores: jsonField<int> (json, ["cores",],  nullable: false),
      memory: jsonField<num> (json, ["memory"],  nullable: false),
      gpus: GPU.fromJson( jsonField<dynamic> (json, ["gpus",],  nullable: false) ),
      networking: Networking.fromJson(
        jsonField<dynamic> (json, ["networking"],  nullable: false),
      )
    );
  }

  Map<String, bool> isComplete () {
    bool platform = this.platform.isNotEmpty;
    bool series = this.series.isNotEmpty;
    bool template = this.template.isNotEmpty;
    bool cores = this.cores > 0;
    bool memory = this.memory > 0;
    bool gpus = this.gpus.isNotEmpty;
    bool networking = this.networking.isNotEmpty;

    return {
      "platform": !platform,
      "series": !series,
      "template": !template,
      "cores": !cores,
      "memory": !memory,
      "gpus": !gpus,
      "networking": !networking,
      "total": platform &&
        series &&
        template &&
        cores &&
        memory &&
        gpus &&
        networking
    };
  }

  Map<String, dynamic> toJson () {
    return {
      "platform": platform,
      "series": series,
      "template": template,
      "cores": cores,
      "memory": memory,
      "gpus": gpus.toJson(),
      "networking": networking.toJson(),
    };
  }
}