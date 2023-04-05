import 'package:http_request_utils/body_utils.dart';
import 'package:silvertime/include.dart';

class Role {
  String id = "";
  String name = "";
  String description = "";
  DateTime date = DateTime.now ();

  Role ({
    required this.id,
    required this.name,
    required this.description,
    required this.date
  });
  
  Role.empty ();

  factory Role.fromJson (dynamic json) {
    return Role (
      id: jsonField<String> (json, ["_id", "\$oid"], nullable: false),
      name: jsonField<String> (json, ["name",],  nullable: false),
      description: jsonField<String> (json, ["description",],  nullable: false),
      date: dateTimefromMillisecondsNoZero(
        jsonField<int> (json, ["date", "\$date"]),
        defaultNow: true
      )!
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
      "description": description
    };
  }
}