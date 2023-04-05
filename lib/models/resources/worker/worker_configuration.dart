import 'package:http_request_utils/body_utils.dart';

enum WorkerConfigType {
  none,
  template,
  instance
}

class WorkerConfiguration {
  String id = "";
  String worker = "";
  String? workerInstance;
  WorkerConfigType type = WorkerConfigType.none;
  int logsExp = 0;
  int historySize = 0;
  int failsSize = 0;
  DateTime date = DateTime.now ();

  WorkerConfiguration ({
    required this.id,
    required this.worker,
    required this.type,
    required this.logsExp,
    required this.historySize,
    required this.failsSize,
    required this.date,
    this.workerInstance
  });

  WorkerConfiguration.empty ();

  factory WorkerConfiguration.fromJson (dynamic json) {
    return WorkerConfiguration (
      id: jsonField<String> (json, ["_id", "\$oid"], nullable: false),
      worker: jsonField<String> (json, ["worker", "\$oid"], nullable: false),
      type: WorkerConfigType.values[ jsonField<int> (json, ["config_type",], defaultValue: 0) ],
      logsExp: jsonField<int> (json, ["logs_exp",],  nullable: false),
      historySize: jsonField<int> (json, ["history_size",],  nullable: false),
      failsSize: jsonField<int> (json, ["fails_size",],  nullable: false),
      date: DateTime.fromMillisecondsSinceEpoch(
        jsonField<int> (json, ["date", "\$date"]),
      ),
      workerInstance: jsonField<String> (json, ["worker_instance", "\$oid"]),
    );
  }

  factory WorkerConfiguration.instance (WorkerConfiguration template, String workerInstance) {
    return WorkerConfiguration (
      id: "",
      worker: template.worker,
      type: WorkerConfigType.instance,
      workerInstance: workerInstance,
      logsExp: template.logsExp,
      historySize: template.historySize,
      failsSize: template.failsSize,
      date: DateTime.now ()
    );
  }

  Map<String, bool> isComplete () {
    bool type = this.type != WorkerConfigType.none;
    bool logsExp = this.logsExp > 0;
    bool workerInstance = this.type != WorkerConfigType.instance || this.workerInstance != null;

    return {
      "type": !type,
      "logsExp": !logsExp,
      "workerInstance": !workerInstance,
      "total": type &&
        logsExp &&
        workerInstance
    };
  }

  Map<String, dynamic> toJson () => {
    "worker": worker,
    "config_type": type.index,
    "logs_exp": logsExp,
    "history_size": historySize,
    "fails_size": failsSize,
    "worker_instance": workerInstance,
  };
}