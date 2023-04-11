import 'package:http_request_utils/body_utils.dart';
import 'package:silvertime/include.dart';
import 'package:silvertime/models/status/interruption/interruption_types.dart';
import 'package:silvertime/models/system/types.dart';

export 'package:silvertime/models/status/interruption/interruption_types.dart';
export 'package:silvertime/models/system/types.dart';

class Interruption {
  String id = "";
  String title = "";
  String? service;
  String? serviceName;
  String? instance;
  String? instanceName;
  ExecutionScope scope = ExecutionScope.none;
  ExecutionType execution = ExecutionType.none;
  ExecutionExit exit = ExecutionExit.none;
  DateTime start = DateTime.now ();
  DateTime? end;
  Duration duration = Duration.zero;
  InterruptionStatus status = InterruptionStatus.none;
  String description = "";
  String? solution;
  DateTime date = DateTime.now ();

  Interruption ({
    required this.id,
    required this.title,
    required this.scope,
    required this.execution,
    required this.exit,
    required this.start,
    required this.duration,
    required this.status,
    required this.description,
    required this.date,
    this.service,
    this.serviceName,
    this.instance,
    this.instanceName,
    this.solution,
    this.end,
  });
  
  Interruption.empty ();

  factory Interruption.fromJson (dynamic json) {
    return Interruption (
      id: jsonField<String> (json, ["_id", "\$oid"], nullable: false),
      title: jsonField<String> (json, ["title",],  nullable: false),
      scope: ExecutionScope.values[
        jsonField<int> (json, ["scope",], defaultValue: 0) 
      ],
      execution: ExecutionType.values[
        jsonField<int> (json, ["execution"], defaultValue: 0) 
      ],
      exit: ExecutionExit.values[
        jsonField<int> (json, ["exit",], defaultValue: 0) 
      ],
      start: dateTimefromMillisecondsNoZero(
        jsonField<int> (json, ["start", "\$date"]),
        defaultNow: true
      )!,
      duration: jsonClassField<Duration> (
        json, ["duration"], 
        (duration) => Duration (milliseconds: duration), defaultValue: Duration.zero
      ),
      status: InterruptionStatus.values[ 
        jsonField<int> (json, ["status",], defaultValue: 0) 
      ],
      description: jsonField<String> (json, ["description",],  defaultValue: ""),
      solution: jsonField<String> (json, ["solution",]),
      date: dateTimefromMillisecondsNoZero(
        jsonField<int> (json, ["date", "\$date"]),
        defaultNow: true
      )!,
      service: jsonField<String> (json, ["service", "_id", "\$oid"]),
      serviceName: jsonField<String> (json, ["service", "name",]),
      instance: jsonField<String> (json, ["service_instance", "_id", "\$oid"]),
      instanceName: jsonField<String> (json, ["service_instance", "name",]),
      end: dateTimefromMillisecondsNoZero(
        jsonField<int> (json, ["date", "\$date"]),
      )
    );
  }

  Map<String, bool> isComplete () {
    bool title = this.title.isNotEmpty;
    bool scope = this.scope != ExecutionScope.none;
    bool execution = this.execution != ExecutionType.none;
    bool exit = this.exit != ExecutionExit.none;
    bool description = this.description.isNotEmpty;
    bool status = this.status != InterruptionStatus.none;
    bool solution =  this.status != InterruptionStatus.solved  || (
      this.solution?.isNotEmpty ?? false
    );
    bool service = this.scope == ExecutionScope.global || (
      this.service?.isNotEmpty ?? false
    );
    bool instance = this.scope != ExecutionScope.instance || (
      this.instance?.isNotEmpty ?? false
    );

    return {
      "title": !title,
      "scope": !scope,
      "execution": !execution,
      "exit": !exit,
      "description": !description,
      "status": !status,
      "solution": !solution,
      "service": !service,
      "instance": !instance,
      "total": title &&
        scope &&
        execution &&
        exit &&
        description &&
        status &&
        solution &&
        service &&
        instance
    };
  }

  Map<String, dynamic> toJson () => {
    "title": title,
    "service": service,
    "instance": instance,
    "scope": scope.index,
    "execution": execution.index,
    "exit": exit.index,
    "start": start.millisecondsSinceEpoch,
    "end": end?.millisecondsSinceEpoch,
    "duration": duration.inMilliseconds,
    "description": description,
    "status": status.index,
    "solution": solution,
  };
}