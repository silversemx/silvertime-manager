import 'package:http_request_utils/models/http_exception.dart';
import 'package:provider/provider.dart';
import 'package:silvertime/include.dart';
import 'package:silvertime/models/user/user.dart';
import 'package:silvertime/providers/roles.dart';
import 'package:silvertime/providers/users.dart';
import 'package:silvertime/widgets/in_app_messages/error_dialog.dart';
import 'package:silvertime/widgets/inputs/custom_dropdown_form.dart';
import 'package:silvertime/widgets/inputs/custom_input_field.dart';
import 'package:silvertime/widgets/utils/confirm_row.dart';
import 'package:skeletons/skeletons.dart';

class UserDialog extends StatefulWidget {
  final User? user;
  const UserDialog({super.key, this.user});

  @override
  State<UserDialog> createState() => _UserDialogState();
}

class _UserDialogState extends State<UserDialog> {
  late User user;
  bool _loading = true;
  bool _saving = false;
  final _formKey = GlobalKey<FormState> ();
  Map<String, bool> validation = {};
  String password = "", confirm = "";

  @override
  void initState() {
    super.initState();
    Future.microtask(_fetchInfo);
    user = widget.user ?? User.empty ();
  }

  void _fetchInfo() async {
    setState(() {
      _loading = true;
    });
    try {
      await Provider.of<Roles> (context, listen: false).getRoles (limit: 0);
    } on HttpException catch(error) {
      showErrorDialog(context, exception: error);
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void _save () async {
    setState(() {
      validation = user.isComplete();
    });
    bool formComplete = _formKey.currentState!.validate();
    if (validation ["total"]! && formComplete) {
      try {
        setState(() {
          _saving = true;
        });
        if (widget.user == null) {
          await Provider.of<Users> (context, listen: false).createUser(
            user, password, confirm
          );
        } else {
          await Provider.of<Users> (context, listen: false).updateUser(
            widget.user!.id, user
          );
        }
        Navigator.of(context).pop (true);
      } on HttpException catch (error) {
        showErrorDialog (context, exception: error);
      } finally {
        if (mounted) {
          setState(() {
            _saving = false;
          });
        }
      }
    }
  }

  Widget _form () {
    return Form (
      key: _formKey,
      child: Column (
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomInputField (
            initialValue: user.firstName,
            label: S.of(context).firstName,
            type: TextInputType.name,
            onChanged: (val) {
              user.firstName = val;
            },
            action: TextInputAction.next,
          ),
          CustomInputField (
            initialValue: user.lastName,
            label: S.of(context).lastName,
            type: TextInputType.name,
            onChanged: (val) {
              user.lastName = val;
            },
            action: TextInputAction.next,
          ),
          CustomInputField (
            initialValue: user.email,
            label: S.of(context).email,
            type: TextInputType.emailAddress,
            onChanged: (val) {
              user.email = val;
            },
            action: TextInputAction.next,
          ),
          CustomInputField (
            initialValue: user.username,
            label: S.of(context).username,
            type: TextInputType.text,
            onChanged: (val) {
              user.username = val;
            },
            action: TextInputAction.next,
          ),
          Consumer<Roles>(
            builder: (context, roles, _) {
              if (_loading) {
                return SkeletonAvatar (
                  style: SkeletonAvatarStyle (
                    borderRadius: BorderRadius.circular(20),
                    height: 30,
                    width: double.infinity
                  ),
                );
              } else {
                return CustomDropdownFormField<String> (
                  value: user.role,
                  items: roles.roles.map<String> (
                    (role) => role.id
                  ).toList()
                  ..insert (0, ""),
                  name: (val) {
                    if (val.isEmpty) {
                      return S.of(context).selectOne;
                    } else {
                      return roles.roles.firstWhere ((role) => role.id == val).name;
                    }
                  },
                  label: S.of (context).role,
                  onChanged: (val) {
                    user.role = val!;
                  },
                  validation: validation ['role'],
                  hintItem: 0,
                );
              }
            }
          ),
          Visibility(
            visible: widget.user == null,
            child: CustomInputField (
              label: S.of(context).password,
              type: TextInputType.visiblePassword,
              hideInput: true,
              onChanged: (val) {
                setState(() {
                  password = val;
                });
              },
              action: TextInputAction.next,
            ),
          ),
          Visibility(
            visible: widget.user == null,
            child: CustomInputField (
              label: S.of(context).confirmPassword,
              type: TextInputType.visiblePassword,
              hideInput: true,
              onChanged: (val) {
                setState(() {
                  confirm = val;
                });
              },
              action: TextInputAction.done,
              validation: password != confirm,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: UIColors.white,
      insetPadding: EdgeInsets.symmetric(
        horizontal: constrainedBigWidth(
          context, MediaQuery.of(context).size.width * 0.3,
          constraintWidth: 40
        )
      ),
      child: Container (
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
        ),
        child: Column (
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Text (
              widget.user == null
              ? S.of(context).createUser
              : S.of(context).editUser,
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 16),
            _form (),
            const SizedBox(height: 16),
            ConfirmRow (
              okayLoading: _saving,
              onPressedOkay: _save,
              onPressedCancel: Navigator.of(context).pop,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}