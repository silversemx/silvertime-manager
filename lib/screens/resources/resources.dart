import 'package:shared_preferences/shared_preferences.dart';
import 'package:silvertime/include.dart';
import 'package:silvertime/models/resources/types.dart';
import 'package:silvertime/style/container.dart';
import 'package:silvertime/widgets/inputs/custom_dropdown_form.dart';
import 'package:silvertime/widgets/resources/machines/machine_data.dart';
import 'package:silvertime/widgets/resources/networks/network_data.dart';
import 'package:silvertime/widgets/resources/services/service_data.dart';
import 'package:silvertime/widgets/resources/services/tags/tag_data.dart';

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});
  static const String routeName = "/resources";

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  ResourceType _type = ResourceType.none;
  ResourceType get type => _type;

  set type (ResourceType type) {
    _type = type;
    locator<SharedPreferences> ().setInt("resource_type", type.index);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _type = ResourceType.values[
        locator<SharedPreferences> ().getInt("resource_type") ?? 0
      ];
    });
  }

  Widget _title () {
    return SizedBox(
      width: double.infinity,
      child: Wrap (
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 16,
        runSpacing: 32,
        children: [
          Text (
            S.of (context).resources,
            style: Theme.of(context).textTheme.displayLarge,
          ),
          Container(
            decoration: containerDecoration,
            padding: const EdgeInsets.all(16),
            width: constrainedWidth(
              context, 
              MediaQuery.of(context).size.width * 0.4,
              shouldConstraint: MediaQuery.of(context).size.width < 800
            ),
            child: CustomDropdownFormField<ResourceType> (
              value: type,
              items: ResourceType.values,
              label: S.of(context).type,
              dropdownColor: Theme.of(context).colorScheme.background,
              name: (val) => val.name (context),
              hintItem: 0,
              margin: EdgeInsets.zero,
              onChanged: (val) {
                setState(() {
                  type = val!;
                });
              },
              validation: false,
            ),
          )
        ],
      ),
    );
  }

  Widget _data () {
    switch (type) {
      case ResourceType.none:
      // case ResourceType.storages:
        return Container();
      case ResourceType.services:
        return const ServiceData();
      case ResourceType.serviceTags:
        return const ServiceTagData();
      case ResourceType.networks:
        return const NetworkData();
      case ResourceType.machines:
        return const MachineData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.1
      ),
      child: Column (
         mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          _title (),
          const Divider (
            height: 48,
            thickness: 0.5,
          ),
          const SizedBox(height: 16),
          Visibility(
            visible: type != ResourceType.none,
            child: _data ()
          )
        ]
      ),
    );
  }
}