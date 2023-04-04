import 'package:http_request_utils/body_utils.dart';
import 'package:silvertime/include.dart';

enum UserStatus {
  none,
  active,
  inactive,
  blocked,
  removed
}

extension UserStatusExt on UserStatus {
  String name (BuildContext context) {
    switch (this) {
      case UserStatus.none:
        return S.of(context).userStatus_none;
      case UserStatus.active:
        return S.of(context).userStatus_active;
      case UserStatus.inactive:
        return S.of(context).userStatus_inactive;
      case UserStatus.blocked:
        return S.of(context).userStatus_blocked;
      case UserStatus.removed:
        return S.of(context).userStatus_removed;
    }
  }

  Color get color {
    switch (this) {
      case UserStatus.none:
        return Colors.grey;
      case UserStatus.active:
        return Colors.green;
      case UserStatus.inactive:
        return Colors.blue;
      case UserStatus.blocked:
        return Colors.red;
      case UserStatus.removed:
        return const Color.fromARGB(255, 92, 12, 12);
    }
  }

  Widget widget (BuildContext context) {
    return Container (
      margin: const EdgeInsets.symmetric(
        vertical: 8
      ),
      padding: const EdgeInsets.all (8),
      decoration: BoxDecoration (
        color: color,
        borderRadius: BorderRadius.circular(24)
      ),
      child: Text (
        name (context),
        style: Theme.of(context).textTheme.headline4!.copyWith(
          color: getColorContrast(color)
        ),
      ),
    );
  }
}

class User {
  String id = "";
  String name = "";
  String email = "";
  String username = "";
  UserStatus status = UserStatus.none;
  String role = "";
  DateTime date = DateTime.now ();

  User({
      required this.id,
      required this.username,
      required this.role,
      this.name = "",
      this.email = "",
      this.status = UserStatus.none,
      DateTime? date
  }) {
    if (date != null ) {
      this.date = DateTime.now ();
    }
  }

  User.light ({
    required this.id,
    required this.name,
    required this.username,
    required this.email
  });

  User.empty ();

  factory User.fromToken (dynamic json) {
    return User(
      id: jsonField<String> (json, ["user",],  nullable: false),
      username: json["username"] ??"",
      role: json["role"] ?? "",
    );
  }

  Map<String, bool> isComplete () {
    bool name = this.name.isNotEmpty;
    bool username = this.username.isNotEmpty;

    return {
      "name": !name,
      "username": !username,
      "total": 
        name &&
        username
    };
  }

  factory User.fromJson (dynamic json) {
    return User (
      id: jsonField<String> (json, ["_id", "\$oid"], nullable: false),
      name: jsonField<String> (json, ["name",],  nullable: false),
      username: jsonField<String> (json, ["username",],  nullable: false),
      email: jsonField<String> (json, ["email",]) ?? "",
      status: UserStatus.values [ 
        jsonField<int> (json, ["status",],  nullable: false) 
      ],
      role: jsonField<String> (json, ["role", "\$oid"],  nullable: false),
      date: DateTime.fromMillisecondsSinceEpoch(
        jsonField<int> (json, ["date", "\$date"]) ?? 0,
      )
    );
  }

  factory User.fromJsonInfo (dynamic json) {
    return User (
      id: jsonField<String> (json, ["_id", "\$oid"], nullable: false),
      name: jsonField<String> (json, ["name",],  nullable: false),
      username: jsonField<String> (json, ["username",],  nullable: false),
      email: jsonField<String> (json, ["email",]) ?? "",
      status: UserStatus.values [ 
        jsonField<int> (json, ["status",],  nullable: false) 
      ],
      role: jsonField<String> (json, ["role", "_id", "\$oid"],  nullable: false),
      date: DateTime.fromMillisecondsSinceEpoch(
        jsonField<int> (json, ["date", "\$date"]) ?? 0,
      )
    );
  }

  factory User.fromJsonCache (dynamic json) {
    return User (
      id: jsonField<String> (json, ["_id"], nullable: false),
      name: jsonField<String> (json, ["name",],  nullable: false),
      username: jsonField<String> (json, ["username",],  nullable: false),
      email: jsonField<String> (json, ["email",]) ?? "",
      status: UserStatus.values [ 
        jsonField<int> (json, ["status",],  nullable: false) 
      ],
      role: jsonField<String> (json, ["role"],  nullable: false),
      date: DateTime.now ()
    );
  }

  factory User.fromJsonStaff (dynamic json) {
    return User (
      id: jsonField<String> (json, ["_id", "\$oid"], nullable: false),
      name: jsonField<String> (json, ["name",],  nullable: false),
      username: jsonField<String> (json, ["username",],  nullable: false),
      email: jsonField<String> (json, ["email",]) ?? "",
      role: jsonField<String> (json, ["role", "\$oid"],  nullable: false),
      date: DateTime.fromMillisecondsSinceEpoch(
        jsonField<int> (json, ["date", "\$date"]) ?? 0,
      )
    );
  }

  factory User.fromJsonLight (dynamic json ) {
    return User.light (
      id: jsonField<String> (json, ["_id", "\$oid"], nullable: false),
      name: jsonField<String> (json, ["name"],  nullable: false),
      username: jsonField<String> (json, ["username"],  nullable: false),
      email: jsonField<String> (json, ["email",],  defaultValue: "No email"),
    );
  }

  factory User.fromJsonSearch (dynamic json) {
    return User (
      id: jsonField<String> (json, ["_id"], nullable: false),
      name: jsonField<String> (json, ["name",],  nullable: false),
      username: jsonField<String> (json, ["username",],  nullable: false),
      email: jsonField<String> (json, ["email",]) ?? "",
      status: UserStatus.values [ 
        jsonField<int> (json, ["status",],  nullable: false) 
      ],
      role: jsonField<String> (json, ["role"],  nullable: false),
      date: DateTime.now ()
    );
  }

  factory User.from (User user) {
    return User (
      id: user.id,
      name: user.name,
      role: user.role,
      username: user.username,
      email: user.email,
      date: user.date,
      status: user.status
    );
  }

  @override
  int get hashCode => Object.hash (id, name, username, email);

  @override
  bool operator ==(dynamic other)  {
    return other.id == id &&
      other.name == name && 
      other.username == username && 
      other.email == email;
  }

  Map<String, dynamic> toJson () {
    return {
      "name": name,
      "email": email,
      "username": username,
    };
  }
}