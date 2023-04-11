import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http_request_utils/models/http_exception.dart';
import 'package:provider/provider.dart';
import 'package:silvertime/include.dart';
import 'package:silvertime/models/user/user.dart';
import 'package:silvertime/providers/roles.dart';
import 'package:silvertime/providers/users.dart';
import 'package:silvertime/style/container.dart';
import 'package:silvertime/widgets/buttons/create_button.dart';
import 'package:silvertime/widgets/custom_table.dart';
import 'package:silvertime/widgets/in_app_messages/confirm_dialog.dart';
import 'package:silvertime/widgets/in_app_messages/error_dialog.dart';
import 'package:silvertime/widgets/in_app_messages/progress_dialog.dart';
import 'package:silvertime/widgets/in_app_messages/status_snackbar.dart';
import 'package:silvertime/widgets/inputs/custom_dropdown_form.dart';
import 'package:silvertime/widgets/users/user_dialog.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});
  static const String routeName = "/users";

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  bool _loading = true;
  List<String> get columns => [
    "Id",
    S.of(context).name,
    S.of(context).email,
    S.of(context).status,
    S.of(context).editUser
  ];
  int _currentPage = 0;
  Set<String> selectedUsers = {};

  set currentPage (int newPage) {
    _currentPage = newPage;
    fetchUsers ();
  }

  String? _role;
  String? get role => _role;
  UserStatus? _status;
  UserStatus? get status => _status;

  set role (String? data) {
    _role = data;
    _currentPage = 0;
    fetchUsers();
  }

  set status (UserStatus? data) {
    _status = data;
    _currentPage = 0;
    fetchUsers();
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(_fetchInfo);
  }

  Future<void> fetchUsers ({bool showError = true}) async {
    try {
      await Provider.of<Users> (context, listen: false).getUsers (
        skip: 20 * _currentPage, limit: 20,
        role: role, status: status
      );
    } on HttpException catch (error) {
      if (showError) {
        showErrorDialog(context, exception: error);
      } else {
        rethrow;
      }
    }
  }

  void _fetchInfo() async {
    setState(() {
      _loading = true;
    });
    try {
      await Provider.of<Roles> (context, listen: false).getRoles (limit: 0);
      await fetchUsers(showError: false);
    } on HttpException catch(error) {
      showErrorDialog(context, exception: error);
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _createUser () async {
    bool? retval = await showDialog (
      context: context,
      builder: (ctx) => const UserDialog ()
    );

    if (retval ?? false) {
      showStatusSnackbar(
        context, 
        S.of(context).userSuccessfullyCreated
      );
    }
  }

  void _updateUser (User user) async {
    bool? retval = await showDialog (
      context: context,
      builder: (ctx) => UserDialog (
        user: user
      )
    );

    if (retval ?? false) {
      showStatusSnackbar(
        context, 
        S.of(context).userSuccessfullyUpdated
      );
    }
  }

  Future<void> _deleteUsers () async {
    bool? retval = await showConfirmDialog (
      context,
      title: S.of(context).areYouSure, 
      body: S.of(context).thisActionCantBeUndone
    );

    if (retval ?? false) {
      Users users = Provider.of<Users> (context, listen: false);
      try {
        await showDialog(
          context: context, 
          builder: (ctx) => ProgressDialog(
            progress: users.removeUsers(
              selectedUsers
            ),
            title: S.of(context).deletingUsers,
          )
        );

        if (users.users.length == 1 && _currentPage > 0) {
          _currentPage --;
        }
        selectedUsers.clear ();
        fetchUsers();
      } on HttpException catch (error) {
        showErrorDialog(context, exception: error);
        if (error.status != 502 || error.status != 504) {
          fetchUsers();
        }
      }
    }
  }

  Widget _title () {
    return SizedBox(
      width: double.infinity,
      child: Wrap (
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text (
            S.of(context).users,
            style: Theme.of(context).textTheme.displayLarge,
          ),
          Row (
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Visibility(
                visible: selectedUsers.isNotEmpty,
                child: Container(
                  margin: const EdgeInsets.only(right: 32),
                  child: CreateButton (
                    width: 200,
                    color: UIColors.error,
                    onPressed: _deleteUsers,
                    text: S.of(context).deleteSelected (selectedUsers.length),
                  ),
                ),
              ),
              CreateButton (
                onPressed: _createUser,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _filters () {
    return Container (
      decoration: containerDecoration,
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child: Wrap (
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 16,
        runSpacing: 32,
        children: [
          SizedBox(
            width: constrainedBigWidth(
              context, MediaQuery.of(context).size.width * 0.25,
              constraintWidth: 200
            ),
            child: CustomDropdownFormField<UserStatus> (
              value: status ?? UserStatus.none,
              items: UserStatus.values,
              label: S.of(context).status,
              name: (status) => status.name(context),
              margin: EdgeInsets.zero,
              onChanged: (val) {
                setState(() {
                  status = val;
                });
              },
              validation: false,
            ),
          ),
          Consumer<Roles> (
            builder: (context, roles, _) {
              return SizedBox(
                width: constrainedBigWidth(
                  context, MediaQuery.of(context).size.width * 0.25,
                  constraintWidth: 200
                ),
                child: CustomDropdownFormField<String> (
                  value: role ?? "",
                  items: roles.roles.map<String> (
                    (role) => role.id
                  ).toList()
                  ..insert (0, ""),
                  label: S.of(context).role,
                  name: (val) {
                    if (val.isEmpty) {
                      return S.of(context).selectOne;
                    } else {
                      return roles.roles.firstWhere(
                        (element) => element.id == val
                      ).name;
                    }
                  },
                  margin: EdgeInsets.zero,
                  onChanged: (val) {
                    if (val?.isEmpty ?? true) {
                      setState(() {
                        role = null;
                      });
                    }
                    setState(() {
                      role = val;
                    });
                  },
                  validation: false,
                ),
              );
            }
          ),
        ],
      ),
    );
  }

  DataRow _user (User user) {
    return DataRow (
      onSelectChanged: (val){
        if (val!) {
          setState(() {
            selectedUsers.add (user.id);
          });
        } else {
          setState(() {
            selectedUsers.remove(user.id);
          });
        }
      },
      selected: selectedUsers.contains(user.id),
      cells: [
        DataCell (
          Center (
            child: SelectableText (
              user.id,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          )
        ),
        DataCell (
          Center (
            child: SelectableText (
              "${user.firstName} ${user.lastName}",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          )
        ),
        DataCell (
          Center (
            child: SelectableText (
              user.email,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          )
        ),
        DataCell (
          Center (
            child: user.status.widget(context)
          )
        ),
        DataCell(
          Center (
            child: IconButton (
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
              icon: const Icon (
                FontAwesomeIcons.penToSquare,
                size: 24,
              ),
              onPressed: () => _updateUser (user),
            ),
          )
        )
      ]
    );
  }

  Widget _users () {
    return ConstrainedBox(
      constraints: BoxConstraints (
        minHeight: MediaQuery.of(context).size.height * 0.7
      ),
      child: LayoutBuilder(
        builder: (ctx, constraints) {
          return Consumer<Users>  (
            builder: (ctx, users, _) {
              if (users.users.isEmpty && !_loading) {
                return Center (
                  child: Text (
                    S.of(context).noInformation,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                );
              } else {
                List<DataRow> rows = users.users.map<DataRow> (
                  (user) => _user (user)
                ).toList();

                return CustomTable (
                  constraints: constraints,
                  columns: columns,
                  pages: users.userPages,
                  rows: rows,
                  loading: _loading,
                  onPageUpdate: (newPage) => currentPage = newPage,
                );
              }
            },
          );
        }
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
      child: Column (
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          _title (),
          const SizedBox(height: 16),
          _filters (),
          const SizedBox(height: 16),
          _users ()
        ],
      ),
    );
  }
}