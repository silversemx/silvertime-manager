import 'package:http_request_utils/models/http_exception.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:silvertime/include.dart';
import 'package:silvertime/models/resources/types.dart';
import 'package:silvertime/providers/resources/services/services.dart';
import 'package:silvertime/style/container.dart';
import 'package:silvertime/widgets/in_app_messages/error_dialog.dart';
import 'package:silvertime/widgets/inputs/custom_dropdown_form.dart';
import 'package:silvertime/widgets/resources/services/instances/service_instance_data.dart';
import 'package:skeletons/skeletons.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});
  static const String routeName = "/resources/service";

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  ResourceServiceType _type = ResourceServiceType.none;
  bool _loading = true;

  ResourceServiceType get type => _type;

  set type (ResourceServiceType newType) {
    _type = newType;
    locator<SharedPreferences> ().setInt("service_type", newType.index);
    setState(() {});
  }
  
  @override
  void initState() {
    super.initState();
    _type = ResourceServiceType.values[
      locator<SharedPreferences> ().getInt("service_type") ?? 0
    ];
    Future.microtask(_fetchInfo);
  }

  void _fetchInfo() async {
    setState(() {
      _loading = true;
    });
    try {
      await Provider.of<Services> (context, listen: false).getService (
        getQueryParam(context, "service")!
      );
    } on HttpException catch(error) {
      showErrorDialog(context, exception: error);
      Navigator.of (context).pushReplacementNamed("/resources");
    } finally {
      setState(() {
        _loading = false;
      });
    }
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
            Provider.of<Services> (context, listen: false).service?.name ?? "N/A",
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
            child: CustomDropdownFormField<ResourceServiceType> (
              value: type,
              items: ResourceServiceType.values,
              label: S.of(context).type,
              dropdownColor: Theme.of(context).colorScheme.background,
              name: (val) => val.name (context),
              hintItem: 0,
              margin: EdgeInsets.zero,
              onChanged: (val) {
                type = val!;
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
      case ResourceServiceType.actions:
      case ResourceServiceType.none:
      case ResourceServiceType.options:
        return Container ();
      case ResourceServiceType.instances:
        return const ServiceInstanceData ();
    }
  }

  Widget _loadingState () {
    return Column (
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        SkeletonLine (
          style: SkeletonLineStyle (
            borderRadius: BorderRadius.circular(12),
            alignment: Alignment.topLeft,
            height: 24,
            width: 60           
          ),
        ),
        const SizedBox(height: 16),
        SkeletonAvatar (
          style: SkeletonAvatarStyle (
            width: double.infinity,
            borderRadius: BorderRadius.circular(12),
            height: MediaQuery.of(context).size.height * 0.6,
          ),
        )
      ],
    );
  }

  Widget _backArrow () {
    return SizedBox(
      width: double.infinity,
      child: Wrap (
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 16,
        runSpacing: 16,
        children: [
          IconButton (
            padding: EdgeInsets.zero,
            icon: const Icon (
              Icons.arrow_back,
              size: 32,
            ),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed("/resources");
            },
          ),
          Text (
            S.of(context).backToResources,
            style: Theme.of(context).textTheme.displaySmall,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.1
      ),
      child: _loading
      ? _loadingState()
      : Column (
         mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _backArrow (),
          const SizedBox(height: 16),
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