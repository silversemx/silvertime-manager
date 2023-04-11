import 'package:http_request_utils/body_utils.dart';
import 'package:silvertime/include.dart';
import 'package:silvertime/models/status/maintenance/maintenance_types.dart';
import 'package:silvertime/models/system/types.dart';

export 'package:silvertime/models/status/maintenance/maintenance_types.dart';
export 'package:silvertime/models/system/types.dart';


class Maintenance {
  String id = "";
  String? service;
  ExecutionScope scope = ExecutionScope.none;
  MaintenanceTime time = MaintenanceTime.none;
  MaintenanceStatus status = MaintenanceStatus.none;
  DateTime start = DateTime.now ().copyWith(
    second: 0, millisecond: 0, microsecond: 0
  );
  DateTime? end;
  String text = "";
  DateTime date = DateTime.now ();

  Maintenance ({
    required this.id,
    required this.scope,
    required this.time,
    required this.text,
    required this.date,
    required this.start,
    this.service,
    this.end,
  });

  Maintenance.empty ();

  factory Maintenance.fromJson (dynamic json) {
    return Maintenance (
      id: jsonField<String> (json, ["_id", "\$oid"], nullable: false),
      scope: ExecutionScope.values[ 
        jsonField<int> (json, ["scope",], defaultValue: 0)
      ],
      time: MaintenanceTime.values[ 
        jsonField<int> (json, ["time",], defaultValue: 0)
      ],
      text: jsonField<String> (json, ["text",], nullable: false),
      start: dateTimefromMillisecondsNoZero(
        jsonField<int> (json, ["start", "\$date"]),
        defaultNow: true
      )!,
      service: jsonField<String> (json, ["service", "\$oid"]),
      end: dateTimefromMillisecondsNoZero(
        jsonField<int> (json, ["end", "\$date"]),
      ),
      date: dateTimefromMillisecondsNoZero(
        jsonField<int> (json, ["date", "\$date"]),
        defaultNow: true
      )!
    );
  }

  Map<String, bool> isComplete () {
    bool scope = this.scope != ExecutionScope.none;
    bool service = this.scope == ExecutionScope.global 
    || (this.service?.isNotEmpty ?? false);
    bool time = this.time != MaintenanceTime.none;
    bool text = this.text.isNotEmpty;
    bool start = this.start.isAfter(
      DateTime.now ().subtract(
        const Duration (seconds: 1)
      )
    );
    bool end = this.time != MaintenanceTime.range 
      || (this.end?.isAfter(this.start) ?? false);

    return {
      "service": !service,
      "scope": !scope,
      "time": !time,
      "text": !text,
      "start": !start,
      "end": !end,
      "total": service &&
        scope &&
        time &&
        text &&
        start &&
        end
    };
  }

  Map<String, dynamic> toJson () {
    return {
      "service": service,
      "scope": scope.index,
      "time": time.index,
      "text": text,
      "start": start.millisecondsSinceEpoch,
      "end": end?.millisecondsSinceEpoch,
    };
  }
}