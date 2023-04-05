import 'package:http_request_utils/body_utils.dart';

class WorkerEvent {
  String id = "";
  String worker = "";
  String name = "";
  String description = "";
  int value = 0;
  DateTime date = DateTime.now ();


  WorkerEvent({
    required this.id,
    required this.worker,
    required this.name,
    required this.description,
    required this.value,
    required this.date,
  });

  WorkerEvent.empty ();

  factory WorkerEvent.fromJson (dynamic json) {
    return WorkerEvent (
      id: jsonField<String> (json, ["_id", "\$oid"], nullable: false),
      worker: jsonField<String> (json, ["worker", "\$oid"], nullable: false),
      name: jsonField<String> (json, ["name",],  nullable: false),
      description: jsonField<String> (json, ["description",],  nullable: false),
      value: jsonField<int> (json, ["value",],  nullable: false),
      date: DateTime.fromMillisecondsSinceEpoch(
        jsonField<int> (json, ["date", "\$date"]),
      )
    );
  }

  Map<String, bool> isComplete () {
    bool name = this.name.isNotEmpty;
    bool description = this.description.isNotEmpty;
    bool value = this.value > 0;

    return {
      "name": !name,
      "description": !description,
      "value": !value,
      "total": name &&
        description &&
        value
    };
  }

  Map<String, dynamic> toJson () {
    return {
      "name": name,
      "description": description,
      "value": value
    };
  }
}
