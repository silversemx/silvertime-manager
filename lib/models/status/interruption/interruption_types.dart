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

  Color get color {
    switch (this) {
      case InterruptionStatus.none:
        return Colors.grey;
      case InterruptionStatus.detected:
        return Colors.orange;
      case InterruptionStatus.investigating:
        return Colors.blue;
      case InterruptionStatus.monitoring:
        return Colors.purple;
      case InterruptionStatus.solved:
        return Colors.green;
      case InterruptionStatus.removed:
        return Colors.red;
      
    }

  }

  Widget widget (BuildContext context) {
    return Container (
      decoration: BoxDecoration (
        borderRadius: BorderRadius.circular(20),
        color: color,
        boxShadow: [
          BoxShadow (
            offset: Offset.zero,
            blurRadius: 4,
            spreadRadius: 3,
            color: color.withOpacity(0.2)
          )
        ]
      ),
      padding: const EdgeInsets.all(4),
      child: Text (
        name (context),
        style: Theme.of(context).textTheme.headlineMedium!.copyWith(
          color: getColorContrast(color)
        ),
      ),
    );
  }

  
}

List<InterruptionStatus> get interruptionCreateValues  {
    return [
      InterruptionStatus.none,
      InterruptionStatus.detected,
      InterruptionStatus.investigating,
      InterruptionStatus.monitoring,
      InterruptionStatus.solved
    ];
  }