import 'package:http_request_utils/body_utils.dart';
import 'package:silvertime/include.dart';

enum NetworkType {
  none,
  standard,
  premium
}

extension NetworkTypeExt on NetworkType {
  String name (BuildContext context) {
    switch (this) {
      case NetworkType.none:
        return S.of(context).networkType_none;
      case NetworkType.standard:
        return S.of(context).networkType_standard;
      case NetworkType.premium:
        return S.of(context).networkType_premium;
    }
  }
}

class Network {
  String id = "";
  String name = "";
  String description = "";
  String address = "";
  String region = "";
  num tier = 0;
  DateTime date = DateTime.now ();
  NetworkType type = NetworkType.none;

  Network ({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.region,
    required this.tier,
    required this.type,
    required this.date,
  });

  Network.empty ();

  factory Network.fromJson (dynamic json) {
    return Network (
      id: jsonField<String> (json, ["_id", "\$oid"], nullable: false),
      name: jsonField<String> (json, ["name"],  nullable: false),
      description: jsonField<String> (json, ["description"],  nullable: false),
      address: jsonField<String> (json, ["address",],  nullable: false),
      region: jsonField<String> (json, ["region"],  nullable: false),
      tier: jsonField<num> (json, ["tier",],  nullable: false),
      type: NetworkType.values [ jsonField<int> (json, ["network_type",],  nullable: false) ],
      date: DateTime.fromMillisecondsSinceEpoch(
        jsonField<int> (json, ["date", "\$date"])
      )
    );
  }

  Map<String, bool> isComplete () {
    bool name = this.name.isNotEmpty;
    bool description = this.description.isNotEmpty;
    bool address = this.address.isNotEmpty;
    bool region = this.region.isNotEmpty;
    bool tier = this.tier > 0;
    bool type = this.type != NetworkType.none;

    return {
      "name": !name,
      "description": !description,
      "address": !address,
      "region": !region,
      "tier": !tier,
      "type": !type,
      "total": name &&
        description &&
        address &&
        region &&
        tier &&
        type
    };
  }

  Map<String, dynamic> toJson () {
    return {
      "name": name,
      "description": description,
      "address": address,
      "region": region,
      "tier": tier,
      "network_type": type.index,
    };
  }


}