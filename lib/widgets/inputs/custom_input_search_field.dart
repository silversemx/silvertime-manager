import 'dart:async';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http_request_utils/models/http_exception.dart';
import 'package:searchfield/searchfield.dart';
import 'package:silvertime/include.dart';
import 'package:silvertime/widgets/in_app_messages/error_dialog.dart';

class CustomInputSearchField<T> extends StatefulWidget {
  final SearchFieldListItem<T>? initialValue;
  final String label;
  final Future<List<T>?> Function (String?) fetch;
  final int seconds;
  final bool showSuggestions;
  final int maxSuggestionsInViewPort;
  final Future<String?> Function (String)? onSubmit;
  final Function (T)? onSuggestionTap;
  final SearchFieldListItem<T> Function (T)? searchFieldMap;
  final Function ()? clearSelection;
  final bool? validation;
  final bool fetchAfterSubmission;
  final Color? color;

  /// Custom Input search field to enable continuous writing while searching for a 
  /// value
  /// If [showSuggestions] is true, 
  /// then 
  /// [onSubmit], [onSuggestionTap], [clearSelection], [searchFieldMap] 
  /// must not be [NULL]
  const CustomInputSearchField({
    Key? key, 
    this.initialValue,
    required this.label,
    required this.fetch,
    this.searchFieldMap,
    this.onSubmit,
    this.onSuggestionTap,
    this.clearSelection,
    this.showSuggestions = true,
    this.maxSuggestionsInViewPort = 5,
    this.seconds = 2,
    this.validation,
    this.color,
    this.fetchAfterSubmission = false
  }) : assert (
    (
      showSuggestions 
      && onSubmit != null 
      && onSuggestionTap != null 
      && searchFieldMap != null
      && clearSelection != null
    )
    || !showSuggestions
  ), super(key: key);

  @override
  State<CustomInputSearchField<T>> createState() => _CustomInputSearchFieldState<T>();
}

class _CustomInputSearchFieldState<T> extends State<CustomInputSearchField<T>> {
  String _lastSearch = "";
  Timer? _timer;
  final TextEditingController _textController = TextEditingController();
  bool _searching = false;
  List<T> suggestions = [];
  bool _selected = false;

  @override
  void initState() {
    super.initState();
    Future.microtask (_fetchInfo);
    _listeners();
  }

  void _fetchInfo() async {
    setState(() {
      _searching = true;
    });
    try {
      if (widget.showSuggestions) {
        suggestions = (await widget.fetch (null))!;
      }
    } on HttpException catch(error) {
      showErrorDialog(context, exception: error);
    } finally {
      setState(() {
        _searching = false;
      });
    }
  }

  void _listeners () {
    _textController.addListener(() {
      if (_lastSearch != _textController.text && _textController.text.isNotEmpty) {
        if (_timer != null) {
          _timer?.cancel();
          _timer = null;
        }
        setState(() {
          _searching = true;
          _lastSearch = _textController.text;
        });
        _timer = Timer (
          Duration(seconds: widget.seconds), () async {
            List<dynamic>? values = await widget.fetch (_textController.text);
            if (widget.showSuggestions) {
              suggestions = List<T>.from (values!);
            }
            setState(() {
              _searching = false;
            });
          }
        );
      }
    });
  }

  InputDecoration get decoration => InputDecoration (
    labelText: widget.label,
    fillColor: widget.color,
    focusColor: widget.color,
    enabledBorder: (widget.validation ?? false)
    ? Theme.of(context).inputDecorationTheme.enabledBorder!.copyWith(
      borderSide: const BorderSide(
        color: UIColors.error,
        width: 1
      )
    )
    : null,
    suffix: _selected
    ? const SizedBox (
      width: 30,
      child: Icon (
        Icons.check, color: UIColors.inputSuccess,
      ),
    ) 
    : _searching ?
      SizedBox (
        width: 30,
        child: SpinKitDoubleBounce (
          color: Theme.of(context).primaryColor,
          size: 24,
        ),
      )
      : null
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchField<T>(
          suggestions: widget.showSuggestions
          ? suggestions.map<SearchFieldListItem<T>> (
            (T suggestion) => widget.searchFieldMap!(suggestion)
          ).toList()
          : [],
          searchInputDecoration: decoration,
          controller: _textController,
          maxSuggestionsInViewPort: widget.maxSuggestionsInViewPort,
          onSubmit: (text) async {
            if (widget.showSuggestions) {
              String? res = await widget.onSubmit! (text);
              if (res != null) {
                _textController.text = res;
                _textController.selection = TextSelection.collapsed(
                  offset: res.length
                );
                
                if (widget.fetchAfterSubmission) {
                  _textController.clear ();
                  _fetchInfo();
                } else {
                  setState(() {
                    _selected = true;
                  });
                }
              }
            }
          },
          onSuggestionTap: (suggestion) {
            if (widget.showSuggestions) {
              widget.onSuggestionTap!(suggestion.item as T);
              _textController.text = suggestion.searchKey;
              _textController.selection = TextSelection.collapsed(
                offset: suggestion.searchKey.length
              );
              
              if (widget.fetchAfterSubmission) {
                _textController.clear ();
                _fetchInfo();
              } else {
                setState(() {
                  _selected = true;
                });
              }
            }
            unfocus (context);
          },
        ),
        Visibility (
          visible: _selected && !widget.fetchAfterSubmission,
          child: TextButton (
            onPressed: () {
              if (widget.showSuggestions) {
                setState(() {
                  _selected = false;
                });
                widget.clearSelection !();
                _textController.clear();
              }
            },
            child: Text (
              S.of(context).clearSelection,
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                decoration: TextDecoration.underline
              ),
            ),
          ),
        )
      ],
    );
    
  }
}