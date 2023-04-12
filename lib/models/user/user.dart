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
        style: Theme.of(context).textTheme.headlineMedium!.copyWith(
          color: getColorContrast(color)
        ),
      ),
    );
  }
}

class User {
  String id = "";
  String firstName = "";
  String lastName = "";
  String username = "";
  String email = "";
  UserStatus status = UserStatus.none;
  String role = "";
  DateTime date = DateTime.now ();

  User({
      required this.id,
      required this.role,
      this.firstName = "",
      this.lastName  = "",
      this.username = "",
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
    required this.firstName,
    required this.lastName,
    required this.email
  });

  User.empty ();

  factory User.fromToken (dynamic json) {
    print (json);
    return User(
      id: jsonField<String> (json, ["user",],  nullable: false),
      username: jsonField<String> (json, ["username",],  nullable: false),
      role: json["role"] ?? "",
    );
  }

  Map<String, bool> isComplete () {
    bool firstName = this.firstName.isNotEmpty;
    bool lastName = this.lastName.isNotEmpty;
    bool username = this.username.isNotEmpty;
    bool email = this.email.isNotEmpty;
    bool role = this.role.isNotEmpty;

    return {
      "firstName": !firstName,
      "lastName": !lastName,
      "username": !username,
      "role": !role,
      "total": 
        firstName &&
        lastName &&
        email &&
        role
    };
  }

  factory User.fromJson (dynamic json) {
    return User (
      id: jsonField<String> (json, ["_id", "\$oid"], nullable: false),
      firstName: jsonField<String> (json, ["first_name",],  nullable: false),
      lastName: jsonField<String> (json, ["last_name",],  nullable: false),
      username: jsonField<String> (json, ["usrname",],  defaultValue: ""),
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

  @override
  int get hashCode => Object.hash (id, firstName, lastName, email);

  @override
  bool operator ==(dynamic other)  {
    return other.id == id &&
      other.firstName == firstName && 
      other.lastName == lastName && 
      other.username == username &&
      other.email == email;
  }

  Map<String, dynamic> toJson () {
    return {
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "username": username,
      "user_type": 1
    };
  }
}