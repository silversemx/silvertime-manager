import 'package:http_request_utils/body_utils.dart';

class StatusUpdate<T> {
  T previousStatus;
  T currentStatus;
  DateTime date;

  StatusUpdate ({
    required this.previousStatus,
    required this.currentStatus,
    required this.date
  });

  factory StatusUpdate.fromJson (dynamic json, List<T> values) {
    return StatusUpdate (
      previousStatus: values [ 
        jsonField<int> (json, ["prev_status",], defaultValue: 0) 
      ],
      currentStatus: values [ 
        jsonField<int> (json, ["current_status",], defaultValue: 0) 
      ],
      date: DateTime.fromMillisecondsSinceEpoch(
        jsonField<int> (json, ["date", "\$date"]),
      )
    );  
  }
}