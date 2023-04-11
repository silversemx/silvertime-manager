import 'package:http_request_utils/body_utils.dart';
import 'package:silvertime/include.dart';
import 'package:silvertime/models/status/interruption/interruption_status.dart';
import 'package:silvertime/models/system/types.dart';

class Interruption {
  String id = "";
  String? service;
  String? serviceInstance;
  ExecutionScope scope = ExecutionScope.none;
  ExecutionType execution = ExecutionType.none;
  ExecutionExit exit = ExecutionExit.none;
  DateTime start = DateTime.now ();
  DateTime? end;
  Duration duration = Duration.zero;
  InterruptionStatus status = InterruptionStatus.none;
  String description = "";
  String solution = "";
  DateTime date = DateTime.now ();

  Interruption ({
    required this.id,
    required this.scope,
    required this.execution,
    required this.exit,
    required this.start,
    required this.duration,
    required this.status,
    required this.description,
    required this.solution,
    required this.date,
    this.service,
    this.serviceInstance,
    this.end,
  });
  
  Interruption.empty ();

  factory Interruption.fromJson (dynamic json) {
    return Interruption (
      id: jsonField<String> (json, ["_id", "\$oid"], nullable: false),
      scope: ExecutionScope.values[
        jsonField<int> (json, ["scope",], defaultValue: 0) 
      ],
      execution: ExecutionType.values[
        jsonField<int> (json, ["",], defaultValue: 0) 
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
        (duration) => Duration (milliseconds: duration), nullable: false
      ),
      status: InterruptionStatus.values[ 
        jsonField<int> (json, ["status",], defaultValue: 0) 
      ],
      description: jsonField<String> (json, ["description",],  nullable: false),
      solution: jsonField<String> (json, ["solution",],  nullable: false),
      date: dateTimefromMillisecondsNoZero(
        jsonField<int> (json, ["date", "\$date"]),
        defaultNow: true
      )!,
      service: jsonField<String> (json, ["service", "\$oid"]),
      serviceInstance: jsonField<String> (json, ["service_instance", "\$oid"]),
      end: dateTimefromMillisecondsNoZero(
        jsonField<int> (json, ["date", "\$date"]),
      )
    );
  }

  Map<String, bool> isComplete () {
    bool scope = this.scope != ExecutionScope.none;
    bool execution = this.execution != ExecutionScope.none;
    bool exit = this.exit != ExecutionExit.none;
    bool description = this.description.isNotEmpty;
    bool solution = this.solution.isNotEmpty;
    bool service = this.scope == ExecutionScope.global || (
      this.service?.isNotEmpty ?? false
    );
    bool serviceInstance = this.scope != ExecutionScope.instance || (
      this.serviceInstance?.isNotEmpty ?? false
    );

    return {
      "scope": !scope,
      "execution": !execution,
      "exit": !exit,
      "description": !description,
      "solution": !solution,
      "service": !service,
      "serviceInstance": !serviceInstance,
      "total": scope &&
        execution &&
        exit &&
        description &&
        solution &&
        service &&
        serviceInstance
    };
  }

  Map<String, dynamic> toJson () => {
    "service": service,
    "serviceInstance": serviceInstance,
    "scope": scope.index,
    "execution": execution.index,
    "exit": exit.index,
    "start": start.millisecondsSinceEpoch,
    "end": end?.millisecondsSinceEpoch,
    "duration": duration.inMilliseconds,
    "description": description,
    "solution": solution,
  };
}