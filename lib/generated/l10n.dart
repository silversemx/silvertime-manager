// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `About`
  String get about {
    return Intl.message(
      'About',
      name: 'about',
      desc: '',
      args: [],
    );
  }

  /// `About AstraZeneca`
  String get aboutAstra {
    return Intl.message(
      'About AstraZeneca',
      name: 'aboutAstra',
      desc: '',
      args: [],
    );
  }

  /// `Actions`
  String get actions {
    return Intl.message(
      'Actions',
      name: 'actions',
      desc: '',
      args: [],
    );
  }

  /// `Active Users`
  String get activeUsers {
    return Intl.message(
      'Active Users',
      name: 'activeUsers',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Cookies advertisement`
  String get cookiesAdvice {
    return Intl.message(
      'Cookies advertisement',
      name: 'cookiesAdvice',
      desc: '',
      args: [],
    );
  }

  /// `Create`
  String get create {
    return Intl.message(
      'Create',
      name: 'create',
      desc: '',
      args: [],
    );
  }

  /// `Create User`
  String get createUser {
    return Intl.message(
      'Create User',
      name: 'createUser',
      desc: '',
      args: [],
    );
  }

  /// `Average Daily Access`
  String get dailyAccess {
    return Intl.message(
      'Average Daily Access',
      name: 'dailyAccess',
      desc: '',
      args: [],
    );
  }

  /// `Edit User`
  String get editUser {
    return Intl.message(
      'Edit User',
      name: 'editUser',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Empty field validation`
  String get emptyFieldValidation {
    return Intl.message(
      'Empty field validation',
      name: 'emptyFieldValidation',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message(
      'Error',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Invalid`
  String get invalid {
    return Intl.message(
      'Invalid',
      name: 'invalid',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Email`
  String get invalidEmail {
    return Intl.message(
      'Invalid Email',
      name: 'invalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Legal`
  String get legal {
    return Intl.message(
      'Legal',
      name: 'legal',
      desc: '',
      args: [],
    );
  }

  /// `Missing value`
  String get missingValue {
    return Intl.message(
      'Missing value',
      name: 'missingValue',
      desc: '',
      args: [],
    );
  }

  /// `Mobile`
  String get mobile {
    return Intl.message(
      'Mobile',
      name: 'mobile',
      desc: '',
      args: [],
    );
  }

  /// `Average Monthly Access`
  String get monthlyAccess {
    return Intl.message(
      'Average Monthly Access',
      name: 'monthlyAccess',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `No information was found`
  String get noInformation {
    return Intl.message(
      'No information was found',
      name: 'noInformation',
      desc: '',
      args: [],
    );
  }

  /// `Okay`
  String get okay {
    return Intl.message(
      'Okay',
      name: 'okay',
      desc: '',
      args: [],
    );
  }

  /// `Platform overview`
  String get platformOverview {
    return Intl.message(
      'Platform overview',
      name: 'platformOverview',
      desc: '',
      args: [],
    );
  }

  /// `Resources`
  String get resources {
    return Intl.message(
      'Resources',
      name: 'resources',
      desc: '',
      args: [],
    );
  }

  /// `Role`
  String get role {
    return Intl.message(
      'Role',
      name: 'role',
      desc: '',
      args: [],
    );
  }

  /// `Select One`
  String get selectOne {
    return Intl.message(
      'Select One',
      name: 'selectOne',
      desc: '',
      args: [],
    );
  }

  /// `Status`
  String get status {
    return Intl.message(
      'Status',
      name: 'status',
      desc: '',
      args: [],
    );
  }

  /// `User successfully created!`
  String get userSuccessfullyCreated {
    return Intl.message(
      'User successfully created!',
      name: 'userSuccessfullyCreated',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get username {
    return Intl.message(
      'Username',
      name: 'username',
      desc: '',
      args: [],
    );
  }

  /// `Users`
  String get users {
    return Intl.message(
      'Users',
      name: 'users',
      desc: '',
      args: [],
    );
  }

  /// `Active`
  String get userStatus_active {
    return Intl.message(
      'Active',
      name: 'userStatus_active',
      desc: '',
      args: [],
    );
  }

  /// `Blocked`
  String get userStatus_blocked {
    return Intl.message(
      'Blocked',
      name: 'userStatus_blocked',
      desc: '',
      args: [],
    );
  }

  /// `Inactive`
  String get userStatus_inactive {
    return Intl.message(
      'Inactive',
      name: 'userStatus_inactive',
      desc: '',
      args: [],
    );
  }

  /// `None`
  String get userStatus_none {
    return Intl.message(
      'None',
      name: 'userStatus_none',
      desc: '',
      args: [],
    );
  }

  /// `Removed`
  String get userStatus_removed {
    return Intl.message(
      'Removed',
      name: 'userStatus_removed',
      desc: '',
      args: [],
    );
  }

  /// `User successfully updated!`
  String get userSuccessfullyUpdated {
    return Intl.message(
      'User successfully updated!',
      name: 'userSuccessfullyUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Web`
  String get web {
    return Intl.message(
      'Web',
      name: 'web',
      desc: '',
      args: [],
    );
  }

  /// `Average Weekly Access`
  String get weeklyAccess {
    return Intl.message(
      'Average Weekly Access',
      name: 'weeklyAccess',
      desc: '',
      args: [],
    );
  }

  /// `Welcome Back, {name}!`
  String welcomeBack(String name) {
    return Intl.message(
      'Welcome Back, $name!',
      name: 'welcomeBack',
      desc: '',
      args: [name],
    );
  }

  /// `Your Account`
  String get yourAccount {
    return Intl.message(
      'Your Account',
      name: 'yourAccount',
      desc: '',
      args: [],
    );
  }

  /// `Clear selection`
  String get clearSelection {
    return Intl.message(
      'Clear selection',
      name: 'clearSelection',
      desc: '',
      args: [],
    );
  }

  /// `Delete Selected: {selected}`
  String deleteSelected(int selected) {
    return Intl.message(
      'Delete Selected: $selected',
      name: 'deleteSelected',
      desc: '',
      args: [selected],
    );
  }

  /// `Success`
  String get success {
    return Intl.message(
      'Success',
      name: 'success',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure?`
  String get areYouSure {
    return Intl.message(
      'Are you sure?',
      name: 'areYouSure',
      desc: '',
      args: [],
    );
  }

  /// `This action can't be undone!`
  String get thisActionCantBeUndone {
    return Intl.message(
      'This action can\'t be undone!',
      name: 'thisActionCantBeUndone',
      desc: '',
      args: [],
    );
  }

  /// `An error ocurred`
  String get anErrorOcurred {
    return Intl.message(
      'An error ocurred',
      name: 'anErrorOcurred',
      desc: '',
      args: [],
    );
  }

  /// `in auth`
  String get inAuthorization {
    return Intl.message(
      'in auth',
      name: 'inAuthorization',
      desc: '',
      args: [],
    );
  }

  /// `in Dashboard`
  String get inDashboard {
    return Intl.message(
      'in Dashboard',
      name: 'inDashboard',
      desc: '',
      args: [],
    );
  }

  /// `in server`
  String get inServer {
    return Intl.message(
      'in server',
      name: 'inServer',
      desc: '',
      args: [],
    );
  }

  /// `The data wasn't validated correctly`
  String get error_400 {
    return Intl.message(
      'The data wasn\'t validated correctly',
      name: 'error_400',
      desc: '',
      args: [],
    );
  }

  /// `Unauthorized`
  String get error_401 {
    return Intl.message(
      'Unauthorized',
      name: 'error_401',
      desc: '',
      args: [],
    );
  }

  /// `No information was found`
  String get error_404 {
    return Intl.message(
      'No information was found',
      name: 'error_404',
      desc: '',
      args: [],
    );
  }

  /// `Something unexpected happened, retry later`
  String get error_500 {
    return Intl.message(
      'Something unexpected happened, retry later',
      name: 'error_500',
      desc: '',
      args: [],
    );
  }

  /// `Server is down or not responding, wait a few minutes`
  String get error_502 {
    return Intl.message(
      'Server is down or not responding, wait a few minutes',
      name: 'error_502',
      desc: '',
      args: [],
    );
  }

  /// `Timeout reached, check your internet connection`
  String get error_504 {
    return Intl.message(
      'Timeout reached, check your internet connection',
      name: 'error_504',
      desc: '',
      args: [],
    );
  }

  /// `Unexpected`
  String get unexpected {
    return Intl.message(
      'Unexpected',
      name: 'unexpected',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'es'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
