import 'package:silvertime/include.dart';

typedef HoverWidgetBuilder = Widget Function (
  BuildContext context, bool isHover
);

class HoverWidget extends StatefulWidget {
  final HoverWidgetBuilder builder;
  const HoverWidget({ Key? key, required this.builder }) : super(key: key);

  @override
  State<HoverWidget> createState() => _HoverWidgetState();
}

class _HoverWidgetState extends State<HoverWidget> {
  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          isHover = true;
        });
      },
      onExit: (_){
        setState(() {
          isHover = false;
        });
      },
      child: widget.builder (context, isHover),
    );
  }
}