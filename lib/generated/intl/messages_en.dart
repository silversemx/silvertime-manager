// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(selected) => "Delete Selected: ${selected}";

  static String m1(name) => "Welcome Back, ${name}!";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "about": MessageLookupByLibrary.simpleMessage("About"),
        "aboutAstra": MessageLookupByLibrary.simpleMessage("About AstraZeneca"),
        "actions": MessageLookupByLibrary.simpleMessage("Actions"),
        "activeUsers": MessageLookupByLibrary.simpleMessage("Active Users"),
        "anErrorOcurred":
            MessageLookupByLibrary.simpleMessage("An error ocurred"),
        "areYouSure": MessageLookupByLibrary.simpleMessage("Are you sure?"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "clearSelection":
            MessageLookupByLibrary.simpleMessage("Clear selection"),
        "cookiesAdvice":
            MessageLookupByLibrary.simpleMessage("Cookies advertisement"),
        "create": MessageLookupByLibrary.simpleMessage("Create"),
        "createUser": MessageLookupByLibrary.simpleMessage("Create User"),
        "dailyAccess":
            MessageLookupByLibrary.simpleMessage("Average Daily Access"),
        "deleteSelected": m0,
        "editUser": MessageLookupByLibrary.simpleMessage("Edit User"),
        "email": MessageLookupByLibrary.simpleMessage("Email"),
        "emptyFieldValidation":
            MessageLookupByLibrary.simpleMessage("Empty field validation"),
        "error": MessageLookupByLibrary.simpleMessage("Error"),
        "error_400": MessageLookupByLibrary.simpleMessage(
            "The data wasn\'t validated correctly"),
        "error_401": MessageLookupByLibrary.simpleMessage("Unauthorized"),
        "error_404":
            MessageLookupByLibrary.simpleMessage("No information was found"),
        "error_500": MessageLookupByLibrary.simpleMessage(
            "Something unexpected happened, retry later"),
        "error_502": MessageLookupByLibrary.simpleMessage(
            "Server is down or not responding, wait a few minutes"),
        "error_504": MessageLookupByLibrary.simpleMessage(
            "Timeout reached, check your internet connection"),
        "home": MessageLookupByLibrary.simpleMessage("Home"),
        "inAuthorization": MessageLookupByLibrary.simpleMessage("in auth"),
        "inDashboard": MessageLookupByLibrary.simpleMessage("in Dashboard"),
        "inServer": MessageLookupByLibrary.simpleMessage("in server"),
        "invalid": MessageLookupByLibrary.simpleMessage("Invalid"),
        "invalidEmail": MessageLookupByLibrary.simpleMessage("Invalid Email"),
        "legal": MessageLookupByLibrary.simpleMessage("Legal"),
        "missingValue": MessageLookupByLibrary.simpleMessage("Missing value"),
        "mobile": MessageLookupByLibrary.simpleMessage("Mobile"),
        "monthlyAccess":
            MessageLookupByLibrary.simpleMessage("Average Monthly Access"),
        "name": MessageLookupByLibrary.simpleMessage("Name"),
        "noInformation":
            MessageLookupByLibrary.simpleMessage("No information was found"),
        "okay": MessageLookupByLibrary.simpleMessage("Okay"),
        "platformOverview":
            MessageLookupByLibrary.simpleMessage("Platform overview"),
        "resources": MessageLookupByLibrary.simpleMessage("Resources"),
        "role": MessageLookupByLibrary.simpleMessage("Role"),
        "selectOne": MessageLookupByLibrary.simpleMessage("Select One"),
        "status": MessageLookupByLibrary.simpleMessage("Status"),
        "success": MessageLookupByLibrary.simpleMessage("Success"),
        "thisActionCantBeUndone": MessageLookupByLibrary.simpleMessage(
            "This action can\'t be undone!"),
        "unexpected": MessageLookupByLibrary.simpleMessage("Unexpected"),
        "userStatus_active": MessageLookupByLibrary.simpleMessage("Active"),
        "userStatus_blocked": MessageLookupByLibrary.simpleMessage("Blocked"),
        "userStatus_inactive": MessageLookupByLibrary.simpleMessage("Inactive"),
        "userStatus_none": MessageLookupByLibrary.simpleMessage("None"),
        "userStatus_removed": MessageLookupByLibrary.simpleMessage("Removed"),
        "userSuccessfullyCreated":
            MessageLookupByLibrary.simpleMessage("User successfully created!"),
        "userSuccessfullyUpdated":
            MessageLookupByLibrary.simpleMessage("User successfully updated!"),
        "username": MessageLookupByLibrary.simpleMessage("Username"),
        "users": MessageLookupByLibrary.simpleMessage("Users"),
        "web": MessageLookupByLibrary.simpleMessage("Web"),
        "weeklyAccess":
            MessageLookupByLibrary.simpleMessage("Average Weekly Access"),
        "welcomeBack": m1,
        "yourAccount": MessageLookupByLibrary.simpleMessage("Your Account")
      };
}
