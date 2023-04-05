import 'package:http_request_utils/body_utils.dart';

class ServiceAction {
  String id = "";
  String service = "";
  String name = "";
  String description = "";
  DateTime date = DateTime.now ();
  int value;

  ServiceAction ({
    required this.id,
    required this.service,
    required this.name,
    required this.description,
    required this.date,
    required this.value,
  });

  ServiceAction.empty ({this.value = 0});

  factory ServiceAction.fromJson (dynamic json) {
    return ServiceAction (
      id: jsonField<String> (json, ["_id", "\$oid"], nullable: false),
      service: jsonField<String> (json, ["service", "\$oid"], nullable: false),
      name: jsonField<String> (json, ["name"],  nullable: false),
      description: jsonField<String> (json, ["description"],  nullable: false),
      date: DateTime.fromMillisecondsSinceEpoch(
        jsonField<int> (json, ["date", "\$date"]),
      ),
      value: jsonField<int> (json, ["value"], nullable: false),
    );
  }

  Map<String, bool> isComplete () {
    bool name = this.name.isNotEmpty;
    bool description = this.description.isNotEmpty;

    return {
      "name": !name,
      "description": !description,
      "total": name &&
        description
    };
  }

  Map<String, dynamic> toJson (){
    return {
      "name": name,
      "description": description
    };
  }
}