import 'package:http_request_utils/body_utils.dart';

class StatusUpdate<T> {
  T previousStatus;
  T currentStatus;
  String? text;
  DateTime date;

  StatusUpdate ({
    required this.previousStatus,
    required this.currentStatus,
    required this.date,
    this.text,
  });

  factory StatusUpdate.fromJson (dynamic json, List<T> values) {
    return StatusUpdate (
      previousStatus: values [ 
        jsonField<int> (json, ["prev_status",], defaultValue: 0) 
      ],
      currentStatus: values [ 
        jsonField<int> (json, ["current_status",], defaultValue: 0) 
      ],
      text: jsonField<String> (json, ["text",]),
      date: DateTime.fromMillisecondsSinceEpoch(
        jsonField<int> (json, ["date", "\$date"]),
      )
    );  
  }
}