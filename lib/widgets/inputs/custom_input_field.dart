import 'package:email_validator/email_validator.dart';
import 'package:flutter/services.dart';
import 'package:silvertime/include.dart';

class CustomInputField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? initialValue;
  final bool hideInput;
  final TextInputAction action;
  final TextStyle? labelStyle;
  final TextStyle? textStyle;
  final bool validation;
  final bool missing;
  final bool enable;
  final bool requiredValue;
  final EdgeInsets margin;
  final TextInputType type;
  final Function(String) onChanged;
  final Function(String)? onCompleted;
  final Function()? onTap;
  final int? maxLength;
  final Widget? suffix;
  final bool autoUpdate;
  final bool acceptZeros;
  final List<TextInputFormatter> inputFormatters;

  const CustomInputField(
    {
      Key? key, 
      required this.label,
      required this.type,
      required this.onChanged,
      this.labelStyle,
      this.textStyle,
      this.controller,
      this.initialValue = "",
      this.onCompleted,
      this.onTap,
      this.requiredValue = true,
      this.enable = true,
      this.missing = false,
      this.action = TextInputAction.next,
      this.margin = const EdgeInsets.only(bottom: 16),
      this.hideInput = false,
      this.validation = false,
      this.autoUpdate = true,
      this.suffix,
      this.maxLength,
      this.hint,
      this.acceptZeros = true,
      this.inputFormatters = const []
    }
  ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    TextStyle _labelStyle = labelStyle 
      ?? Theme.of(context).inputDecorationTheme.labelStyle!;
    List<TextInputFormatter> formatters = List.from (inputFormatters);

    if (type == TextInputType.number) {
      formatters.add (
        FilteringTextInputFormatter.allow(
          RegExp(r'^[0-9]+[,.]{0,1}[0-9]*$'),
          replacementString: "",
        )
      );
    }

    return Container(
      margin: margin,
      child: TextFormField(
        key: autoUpdate ? Key(initialValue.toString()) : null,
        controller: controller,
        initialValue: controller != null 
          ? null 
          : !acceptZeros && initialValue == "0" 
            ? null 
            : initialValue,
        inputFormatters: inputFormatters,
        enabled: enable,
        readOnly: onTap != null,
        autocorrect: type != TextInputType.emailAddress,
        enableSuggestions: type != TextInputType.emailAddress,
        textCapitalization: type == TextInputType.name 
        ? TextCapitalization.words 
        : TextCapitalization.none,
        keyboardType: type,
        cursorHeight: 18,
        textInputAction: action,
        obscureText: hideInput,
        style: textStyle ?? Theme.of(context).textTheme.bodyText1,
        onChanged: onChanged,
        maxLength: maxLength,
        onTap: onTap,
        maxLengthEnforcement: maxLength == null 
          ? MaxLengthEnforcement.none 
          :  MaxLengthEnforcement.enforced,
        onFieldSubmitted: onCompleted ?? (_) {
          unfocus(context);
        },
        decoration: InputDecoration(
          suffix: suffix,
          isDense: true,
          labelText: label + (requiredValue ? "*" : ""),
          labelStyle: _labelStyle.copyWith(
            color: validation ? Theme.of(context).secondaryHeaderColor : null
          ),
          hintText: hint,
          errorStyle: Theme.of(context).textTheme.caption?.copyWith(
            color: Colors.red
          ),
          enabledBorder: validation 
          ? Theme.of(context).inputDecorationTheme.enabledBorder!.copyWith(
            borderSide: BorderSide(
              color: Theme.of(context).secondaryHeaderColor,
              width: 1
            )
          )
          : null
        ),
        validator: (value) {
          if((value?.isEmpty ?? true) && requiredValue) {
            return S.of(context).missingValue;
          } else if (
            type == TextInputType.emailAddress && !EmailValidator.validate(value!)
          ) {
            return S.of(context).invalidEmail;
          } else if (validation) {
            return S.of(context).error;
          }
          
          return null;
        },
      ),
    );
  }
}