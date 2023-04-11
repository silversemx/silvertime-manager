import 'package:silvertime/include.dart';

enum ExecutionExit {
  none,
  success,
  interruption,
  error,
  other
}

extension ExecutionExitExt on ExecutionExit {
  String name (BuildContext context) {
    switch (this) {
      case ExecutionExit.none:
        return S.of(context).executionExit_none;
      case ExecutionExit.success:
        return S.of(context).executionExit_success;
      case ExecutionExit.interruption:
        return S.of(context).executionExit_interruption;
      case ExecutionExit.error:
        return S.of(context).executionExit_error;
      case ExecutionExit.other:
        return S.of(context).executionExit_other;
    }
  }
}

enum ExecutionScope {
  none,
  global,
  service,
  instance
}

extension ExecutionScopeExt on ExecutionScope {
  String name (BuildContext context) {
    switch (this) {
      case ExecutionScope.none:
        return S.of(context).executionScope_none;
      case ExecutionScope.global:
        return S.of(context).executionScope_global;
      case ExecutionScope.service:
        return S.of(context).executionScope_service;
      case ExecutionScope.instance:
        return S.of(context).executionScope_instance;
    }
  }
}

List<ExecutionScope> get maintenanceScopes => [
  ExecutionScope.none,
  ExecutionScope.global,
  ExecutionScope.service,
];

List<ExecutionScope> get interruptionScopes => [
  ExecutionScope.none,
  ExecutionScope.global,
  ExecutionScope.service,
  ExecutionScope.instance,
];

enum ExecutionType {
  none,
  live,
  test,
  maintenance,
  other
}

extension ExecutionTypeExt on ExecutionType {
  String name (BuildContext context) {
    switch (this) {
      case ExecutionType.none:
        return S.of(context).executionType_none;
      case ExecutionType.live:
        return S.of(context).executionType_live;
      case ExecutionType.test:
        return S.of(context).executionType_test;
      case ExecutionType.maintenance:
        return S.of(context).executionType_maintenance;
      case ExecutionType.other:
        return S.of(context).executionType_other;
    }
  }
}