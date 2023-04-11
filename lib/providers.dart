import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:silvertime/providers/auth.dart';
import 'package:silvertime/providers/resources/disks.dart';
import 'package:silvertime/providers/resources/machines.dart';
import 'package:silvertime/providers/resources/networks.dart';
import 'package:silvertime/providers/resources/services/actions.dart';
import 'package:silvertime/providers/resources/services/instances.dart';
import 'package:silvertime/providers/resources/services/options.dart';
import 'package:silvertime/providers/resources/services/services.dart';
import 'package:silvertime/providers/resources/services/tags.dart';
import 'package:silvertime/providers/roles.dart';
import 'package:silvertime/providers/status/maintenances.dart';
import 'package:silvertime/providers/ui.dart';
import 'package:silvertime/providers/users.dart';

final List<SingleChildWidget> mainProviders = [
  ChangeNotifierProvider.value(
    value: UI ()
  ),
  ChangeNotifierProvider.value(
    value: Auth ()
  ),
];

final List<SingleChildWidget> userProviders = [
  ChangeNotifierProxyProvider<Auth, Roles>(
    create: (ctx) => Roles(), 
    update: (ctx, auth, roles) => roles!..update (auth)
  ),
  ChangeNotifierProxyProvider<Auth, Users>(
    create: (ctx) => Users (), 
    update: (ctx, auth, users) => users!..update (auth)
  ),
];

final List<SingleChildWidget> resourceServicesProviders = [
  ChangeNotifierProxyProvider<Auth, Services>(
    create: (ctx) => Services (), 
    update: (ctx, auth, services) => services!..update(auth)
  ),
  ChangeNotifierProxyProvider2<Auth, Services, ServiceActions>(
    create: (ctx) => ServiceActions (), 
    update: (ctx, auth, services, actions) => actions!..updateServices(
      auth, services
    )
  ),
  ChangeNotifierProxyProvider2<Auth, Services, ServiceInstances>(
    create: (ctx) => ServiceInstances (), 
    update: (ctx, auth, services, instances) => instances!..updateServices(
      auth, services
    )
  ),
  ChangeNotifierProxyProvider2<Auth, Services, ServiceOptions>(
    create: (ctx) => ServiceOptions (), 
    update: (ctx, auth, services, options) => options!..updateServices(
      auth, services
    )
  ),
  ChangeNotifierProxyProvider2<Auth, Services, ServiceTags>(
    create: (ctx) => ServiceTags (), 
    update: (ctx, auth, services, tags) => tags!..updateServices(
      auth, services
    )
  ),
];

final List<SingleChildWidget> resourceProviders = [
  ChangeNotifierProxyProvider<Auth, Disks>(
    create: (ctx) => Disks (), 
    update: (ctx, auth, disks) => disks!..update(auth)
  ),
  ChangeNotifierProxyProvider<Auth, Machines>(
    create: (ctx) => Machines (), 
    update: (ctx, auth, machines) => machines!..update (auth)
  ),
  ChangeNotifierProxyProvider<Auth, Networks>(
    create: (ctx) => Networks (), 
    update: (ctx, auth, networks) => networks!..update (auth)
  ),
  ...resourceServicesProviders,
];

final List<SingleChildWidget> statusProviders = [
  ChangeNotifierProxyProvider<Auth, Maintenances>(
    create: (ctx) => Maintenances(), 
    update: (ctx, auth, maintenances) => maintenances!..update(auth)
  )
];