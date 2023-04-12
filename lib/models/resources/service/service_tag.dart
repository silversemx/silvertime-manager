import 'package:http_request_utils/body_utils.dart';

class ServiceTag  {
  String id = "";
  String name = "";
  String description = "";
  int value = 0;
  DateTime date = DateTime.now ();

  ServiceTag ({
    required this.id,
    required this.name,
    required this.description,
    required this.value,
    required this.date
  });

  ServiceTag.empty ();

  factory ServiceTag.fromJson (dynamic json) {
    return ServiceTag (
      id: jsonField<String> (json, ["_id", "\$oid"], nullable: false),
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
      "description": description
    };
  }

}

List<ServiceTag> tagsFromMask (int tagMask, List<ServiceTag> allTags) {
  return allTags.where (
    (tag) => tagMask & tag.value == tag.value
  ).toList();
}