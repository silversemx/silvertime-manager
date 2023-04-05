import 'package:silvertime/include.dart';

class CustomDropdownFormField<T> extends StatelessWidget {
  final T value;
  final List<T> items;
  final int? hintItem;
  final void Function (T?) onChanged;
  final String Function (T) name;
  final String label;
  final bool? validation;
  final bool? disable;
  final bool nullOnEmptyString;
  final EdgeInsets? margin;
  final num? itemWidth;
  final TextStyle? labelStyle;
  final TextStyle? textStyle;
  final Color? dropdownColor;

  const CustomDropdownFormField({ 
    Key? key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.name,
    required this.label,
    required this.validation,
    this.dropdownColor,
    this.hintItem,
    this.itemWidth,
    this.labelStyle,
    this.textStyle,
    this.nullOnEmptyString = false,
    this.disable,
    this.margin
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle itemTextStyle = textStyle ?? Theme.of(context).textTheme.bodyText1!;

    return Container(
      margin: margin ?? const EdgeInsets.only(bottom: 16),
      child: IgnorePointer(
        ignoring: disable ?? false,
        child: Opacity(
          opacity: (disable?? false) ? 0.5 : 1,
          child: DropdownButtonFormField<T>(
            value: value,
            items: items
            .map<DropdownMenuItem<T>> (
              (item) => DropdownMenuItem(
                value: item,
                enabled: items.indexOf(item) != hintItem,
                child: SizedBox(
                  width: itemWidth?.toDouble(),
                  child: Text (
                    name (item), 
                    style: itemTextStyle.copyWith(
                      color: items.indexOf(item) == hintItem 
                      ? itemTextStyle.color!.withOpacity(0.7)
                      : null  
                    ),
                    maxLines: 2,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              )
            ).toList(),
            onChanged: (T? val) {
              if (val is String && val.isEmpty && nullOnEmptyString) {
                onChanged (null);
              } else {
                onChanged(val);
              }
            },
            elevation: 0,
            borderRadius: BorderRadius.circular(20),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: labelStyle,
              // enabledBorder: Theme.of(context).inputDecorationTheme
              // .enabledBorder!.copyWith(
              //   borderSide: (validation ?? false) ?
              //   const BorderSide (
              //     color: UIColors.error
              //   )
              //   : null
              // ),
              errorStyle: Theme.of(context).textTheme.caption?.copyWith(
                color: Colors.red
              ),
            ),
            focusColor: UIColors.hint,
            dropdownColor: textStyle != null
            ? getColorContrast(textStyle!.color!)
            : dropdownColor ?? Theme.of(context).scaffoldBackgroundColor,
            validator: (T? value) {
              if (hintItem != null) {
                if (value == items [hintItem!]) {
                  return S.of(context).notSelected;
                }
              } else if (validation ?? false) {
                return S.of(context).missingValue;
              }
              return null;
            },
          ),
        ),
      ),
    );
  }
}