import 'package:http_request_utils/body_utils.dart';

class ServiceOption {
  String id = "";
  String name = "";
  String? description;

  ServiceOption ({
    required this.id,
    required this.name,
    required this.description
  });

  ServiceOption.empty ();

  factory ServiceOption.fromJson  (dynamic json) {
    return ServiceOption (
      id: jsonField<String> (json, ["_id", "\$oid"], nullable: false),
      name: jsonField<String> (json, ["name",],  nullable: false),
      description: jsonField<String> (json, ["description",]),
    );
  }

  Map<String, bool> isComplete () {
    bool name = this.name.isNotEmpty;
    
    return {
      "name": !name,
      "total": name
    };
  }

  Map<String, dynamic> toJson () {
    return {
      "name": name,
      "description": description,
    };
  }
}