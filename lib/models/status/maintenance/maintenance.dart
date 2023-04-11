import 'package:http_request_utils/body_utils.dart';
import 'package:silvertime/include.dart';
import 'package:silvertime/models/status/maintenance/maintenance_types.dart';
import 'package:silvertime/models/system/types.dart';

export 'package:silvertime/models/status/maintenance/maintenance_types.dart';
export 'package:silvertime/models/system/types.dart';


class Maintenance {
  String id = "";
  String? service;
  String? serviceName;
  ExecutionScope scope = ExecutionScope.none;
  MaintenanceTime time = MaintenanceTime.none;
  MaintenanceStatus status = MaintenanceStatus.none;
  DateTime start = DateTime.now ().copyWith(
    second: 0, millisecond: 0, microsecond: 0
  );
  DateTime? end;
  String title = "";
  String text = "";
  DateTime date = DateTime.now ();

  Maintenance ({
    required this.id,
    required this.scope,
    required this.time,
    required this.title,
    required this.text,
    required this.date,
    required this.start,
    required this.status,
    this.service,
    this.serviceName,
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
      title: jsonField<String> (json, ["title",],  nullable: false),
      text: jsonField<String> (json, ["text",], nullable: false),
      start: dateTimefromMillisecondsNoZero(
        jsonField<int> (json, ["start", "\$date"]),
        defaultNow: true
      )!,
      status: MaintenanceStatus.values[
        jsonField<int> (json, ["status",], defaultValue: 0)
      ],
      service: jsonField<String> (json, ["service", "_id", "\$oid"]),
      serviceName: jsonField<String> (json, ["service", "name"]),
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
    bool title = this.title.isNotEmpty;
    bool text = this.text.isNotEmpty;
    bool start = this.start.isAfter(
      DateTime (0)
    );
    bool end = this.time != MaintenanceTime.range 
      || (this.end?.isAfter(this.start) ?? false);

    return {
      "service": !service,
      "scope": !scope,
      "time": !time,
      "title": !title,
      "text": !text,
      "start": !start,
      "end": !end,
      "total": service &&
        scope &&
        title &&
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
      "title": title,
      "text": text,
      "start": start.millisecondsSinceEpoch,
      "end": end?.millisecondsSinceEpoch,
    };
  }
}