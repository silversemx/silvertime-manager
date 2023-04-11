import 'package:flutter/services.dart';
import 'package:searchfield/searchfield.dart';
import 'package:silvertime/include.dart';

class TimePicker extends StatefulWidget {
  final DateTime initialTime;
  final Function (DateTime) onChanged;
  final bool allowPastDates;
  const TimePicker({
    super.key, 
    required this.initialTime, 
    required this.onChanged, 
    this.allowPastDates = false
  });

  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  final TextEditingController _hourController = TextEditingController();
  final TextEditingController _minuteController = TextEditingController();
  final FocusNode _hourFocus = FocusNode ();
  final FocusNode _minuteFocus = FocusNode ();

  @override
  void dispose() {
    super.dispose();
  }

  void _listeners () {
    _hourController.addListener(() {
      if (_hourController.text.isNotEmpty) {
        if (!_hourController.text.contains(
          RegExp (r'^[012]{0,1}[0-9]{1}$')
        )) {
          _hourController.clear ();
          _hourController.selection = const TextSelection.collapsed(offset: 0);
        }
      }
    });

    _hourFocus.addListener(() {
      if (!_hourFocus.hasFocus) {
        if (_hourController.text.isNotEmpty) {
          if (
            !_hourController.text.contains(
              RegExp (r'^[012]{0,1}[0-9]{1}$')
            ) || !getHours().contains(int.parse (_hourController.text))
          ) {
            _hourController.clear ();
            _hourController.selection = const TextSelection.collapsed(offset: 0);
          } else {
            _updateHour(
              int.parse (_hourController.text)
            );
          }
        }
      }
    });

    _minuteController.addListener(() {
      if (_minuteController.text.isNotEmpty) {
        if (!_minuteController.text.contains(
          RegExp (r'^[0-5]{0,1}[0-9]{1}$')
        )) {
          _minuteController.clear ();
          _minuteController.selection = const TextSelection.collapsed(offset: 0);
        }
      }
    });

    _minuteFocus.addListener(() {
      if (!_minuteFocus.hasFocus) {
        if (_minuteController.text.isNotEmpty) {
          if (
            !_minuteController.text.contains(
              RegExp (r'^[0-5]{0,1}[0-9]{1}$')
            ) || !getMinutes().contains(int.parse (_minuteController.text))
          ) {
            _minuteController.clear ();
            _minuteController.selection = const TextSelection.collapsed(offset: 0);
          } else {
            _updateMinutes(
              int.parse (_minuteController.text)
            );
          }
        }
      }
    });
  }

  void _updateHour (int hour) {
    DateTime currTime = widget.initialTime.copyWith(hour: hour);
    widget.onChanged (currTime);
  }

  void _updateMinutes (int minutes) {
    DateTime currTime = widget.initialTime.copyWith(minute: minutes);
    widget.onChanged (currTime);
  }

  void _initControllers () {
    _hourController.text = widget.initialTime.hour.toString ().padLeft(2, "0");
    _minuteController.text = widget.initialTime.minute.toString ().padLeft(2, "0");
  }

  @override
  void initState() {
    super.initState();
    _initControllers();
    _listeners ();
  }

  List<int> generateHoursForToday () {
    DateTime now = DateTime.now ();
    int currHour = now.hour;
    List<int> retval =[];
    for (int i = currHour; i<24; i++) {
      retval.add (i);
    }

    return retval;
  }

  List<int> generateMinutesForToday () {
    DateTime now = DateTime.now ();
    int minute = now.minute;
    List<int> retval = [];
    for (int i = minute; i<60; i++) {
      retval.add (i);
    }

    return retval;
  }

  List<int> getHours () {
    return (
      (
        widget.initialTime.equalsIgnoreTime(DateTime.now ()) 
        && !widget.allowPastDates
      )
      ? generateHoursForToday ()
      : List.generate (24, (i) => i)
    );
  }

  List<int> getMinutes () {
    return (
      (widget.initialTime.equalsIgnoreTime(
        DateTime.now (), checkHour: true
      ) && !widget.allowPastDates)
      ? generateMinutesForToday ()
      : List.generate (60, (i) => i)
    );
  }

  Widget _hourInput () {
    List<int> hours = getHours ();

    return SizedBox(
      width: 100,
      child: SearchField<int> (
        focusNode: _hourFocus,
        controller: _hourController,
        suggestions: hours.map<SearchFieldListItem<int>> (
          (val) => SearchFieldListItem<int> (
            val.toString().padLeft(2, "0"),
            item: val,
          )
        ).toList (),
        maxSuggestionsInViewPort: hours.length,
        inputType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(
            RegExp(r'^[012]{0,1}[0-9]{1}$'),
            replacementString: "",
          ),
        ],
        searchInputDecoration: InputDecoration (
          labelText: S.of(context).hour,
        ),
        textInputAction: TextInputAction.next,
        autoCorrect: true,
        onSuggestionTap: (suggestion) {
          _updateHour (suggestion.item!);
          _hourFocus.unfocus();
        },
        onSubmit: (val) {
          if (
            hours.containsLambda((hour) => hour.toString() == val)
          ) {
            _updateHour(int.parse (val));
          } else {
            _hourController.clear ();
            _hourController.selection = const TextSelection.collapsed(offset: 0);
          }
        },
      ),
    );
  }

  Widget _minuteInput () {
    List<int> minutes = getMinutes();

    return SizedBox(
      width: 100,
      child: SearchField<int> (
        focusNode: _minuteFocus,
        controller: _minuteController,
        suggestions: minutes.map<SearchFieldListItem<int>> (
          (val) => SearchFieldListItem<int> (
            val.toString().padLeft(2, "0"),
            item: val,
          )
        ).toList (),
        maxSuggestionsInViewPort: minutes.length,
        inputType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(
            RegExp(r'^[0-5]{0,1}[0-9]{1}$'),
            replacementString: "",
          ),
        ],
        searchInputDecoration: InputDecoration (
          labelText: S.of(context).minutes,
        ),
        textInputAction: TextInputAction.next,
        autoCorrect: true,
        onSuggestionTap: (suggestion) {
          _updateMinutes (suggestion.item!);
          unfocus(context);
        },
        onSubmit: (val) {
          if (
            minutes.containsLambda((minute) => minute.toString() == val)
          ) {
            _updateMinutes (int.parse(val));
          } else {
            _minuteController.clear ();
            _minuteController.selection = const TextSelection.collapsed(offset: 0);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Future.microtask (() => _initControllers ());
    return Column (
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text (
          S.of(context).hrs24Format,
          style: Theme.of(context).textTheme.caption,
        ),
        const SizedBox(height: 16),
        Row (
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _hourInput(),
            Text (":", style: Theme.of(context).textTheme.headline2,),
            _minuteInput()
          ],
        )
      ],
    );
  }
}