
import 'package:silvertime/include.dart';

enum ResourceType {
  none,
  services,
  serviceTags,
  disks,
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
      case ResourceType.disks:
        return S.of(context).disks;
      case ResourceType.networks:
        return S.of(context).networks;
      case ResourceType.machines:
        return S.of(context).machines;
      // case ResourceType.storages:
      //   return S.of(context).storages;
    }
  }
}