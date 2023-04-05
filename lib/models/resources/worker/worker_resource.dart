import 'package:http_request_utils/body_utils.dart';

class WorkerResource {
  String id = "";
  String? organization;
  String name = "";
  String description = "";
  int value = 0;
  DateTime date = DateTime.now ();

  WorkerResource ({
    required this.id,
    required this.name,
    required this.description,
    required this.value,
    required this.date,
    this.organization,
  });

  WorkerResource.empty ();

  factory WorkerResource.fromJson (dynamic json) {
    return WorkerResource(
      id: jsonField<String> (json, ["_id", "\$oid"], nullable: false),
      organization: jsonField<String> (json, ["organization", "\$oid"]), 
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

    return {
      "name": !name,
      "description": !description,
      "total": name && description
    };
  }

  Map<String, dynamic> toJson () {
    return {
      "name": name,
      "description": description,
      "organization": organization
    };
  }
}