import 'package:silvertime/include.dart';

enum WorkerSpeed {
  none,
  general,
  common,
  priority,
  background,
  backup
}

extension WorkerSpeedExt on WorkerSpeed {
  String name (BuildContext context) {
    switch (this) {
      case WorkerSpeed.none:
        return S.of(context).workerInstanceSpeed_none;
      case WorkerSpeed.general:
        return S.of(context).workerInstanceSpeed_general;
      case WorkerSpeed.common:
        return S.of(context).workerInstanceSpeed_common;
      case WorkerSpeed.priority:
        return S.of(context).workerInstanceSpeed_priority;
      case WorkerSpeed.background:
        return S.of(context).workerInstanceSpeed_background;
      case WorkerSpeed.backup:
        return S.of(context).workerInstanceSpeed_backup;
    }
  }
}