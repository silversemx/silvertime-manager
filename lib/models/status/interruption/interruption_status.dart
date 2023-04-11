import 'package:silvertime/include.dart';

enum InterruptionStatus {
  none,
  detected,
  investigating,
  monitoring,
  solved,
  removed
}

extension InterruptionStatusExt on InterruptionStatus {
  String name (BuildContext context) {
    switch (this) {
      case InterruptionStatus.none:
        return S.of(context).status_none;
      case InterruptionStatus.detected:
        return S.of(context).status_detected;
      case InterruptionStatus.investigating:
        return S.of(context).status_investigating;
      case InterruptionStatus.monitoring:
        return S.of(context).status_monitoring;
      case InterruptionStatus.solved:
        return S.of(context).status_solved;
      case InterruptionStatus.removed:
        return S.of(context).status_removed;
    }
  }
}