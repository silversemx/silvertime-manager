
import 'package:silvertime/include.dart';

enum ResourceType {
  none,
  services,
  serviceTags,
  networks,
  machines,
  // storages
}

extension ResourceTypeExt on ResourceType {
  String name (BuildContext context) {
    switch (this) {
      case ResourceType.none:
        return S.of(context).selectOne;
      case ResourceType.services:
        return S.of(context).services;
      case ResourceType.serviceTags:
        return S.of(context).serviceTags;
      case ResourceType.networks:
        return S.of(context).networks;
      case ResourceType.machines:
        return S.of(context).machines;
      // case ResourceType.storages:
      //   return S.of(context).storages;
    }
  }
}

enum ResourceServiceType {
  none,
  instances,
  actions,
  options
}

extension ResourceServiceTypeExt on ResourceServiceType {
  String name (BuildContext context) {
    switch (this) {
      case ResourceServiceType.none:
        return S.of(context).selectOne;
      case ResourceServiceType.instances:
        return S.of(context).instances;
      case ResourceServiceType.actions:
        return S.of(context).actions;
      case ResourceServiceType.options:
        return S.of(context).options;
    }
  }
}