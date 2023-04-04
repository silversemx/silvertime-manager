import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:silvertime/include.dart';

class CreateButton extends StatefulWidget {
  final IconData? icon;
  final String? text;
  final double width;
  final Color? color;
  final bool useColorContrast;
  final Future<void> Function() onPressed;
  const CreateButton({ 
    Key? key, required this.onPressed, 
    this.width = 95, 
    this.text, 
    this.icon, 
    this.color,
    this.useColorContrast = false
  }) : 
  super(key: key);

  @override
  State<CreateButton> createState() => _CreateButtonState();
}

class _CreateButtonState extends State<CreateButton> {
  bool _loading = false;
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = widget.color ?? Theme.of(context).secondaryHeaderColor;
    return SizedBox(
      width: widget.width,
      child: ElevatedButton (
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            widget.color??Theme.of(context).primaryColorDark
          ),
          overlayColor: MaterialStateProperty.all(Colors.transparent)
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: _loading
            ? const SpinKitDoubleBounce(
              color: UIColors.white,
              size: 24,
            )
            : widget.icon != null
            ? Icon (
              widget.icon,
              color: getColorContrast(backgroundColor),
              size: 24,
            )
            : Text (
              widget.text ?? S.of(context).create,
              style: Theme.of(context).textTheme.headline3!.copyWith(
                color: widget.useColorContrast 
                ? getColorContrast(backgroundColor) 
                : UIColors.white
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        onPressed: () async {
          setState(() {
            _loading = true;
          });
          await widget.onPressed ();
          setState(() {
            _loading = false;
          });
        }
      ),
    );
  }
}