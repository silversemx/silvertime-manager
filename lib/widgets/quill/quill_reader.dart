import 'dart:convert';

import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:silvertime/include.dart';

class QuillReaderWidget extends StatefulWidget {
  final String? value;
  const QuillReaderWidget({ Key? key, this.value }) : super(key: key);

  @override
  State<QuillReaderWidget> createState() => _QuillReaderWidgetState();
}

class _QuillReaderWidgetState extends State<QuillReaderWidget> {
  quill.QuillController? _controller = quill.QuillController.basic();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode ();

  @override
  void initState() {
    _updateQuillController();
    super.initState();
  }

  @override
  void reassemble() {
    _updateQuillController();
    super.reassemble();
  }

  void _updateQuillController() {
    if (widget.value != null && widget.value!.isNotEmpty ) {
      _controller = quill.QuillController(
        document: quill.Document.fromJson(
          json.decode(widget.value??"{}"),
        ),
        selection: const TextSelection.collapsed(offset: 0)
      );
    } else {
      _controller = quill.QuillController.basic();
    }

  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: (RawKeyEvent event) {},
      child: LayoutBuilder(
        builder: (context, constraints) {
          return quill.QuillEditor(
            focusNode: FocusNode(canRequestFocus:  false),
            textCapitalization: TextCapitalization.none,
            scrollController: _scrollController,
            scrollPhysics: const NeverScrollableScrollPhysics(),
            autoFocus: false,
            padding: EdgeInsets.zero,
            expands: false,
            scrollable: false,
            controller: _controller!,
            readOnly: true,
          );
        }
      ),
    );
  }
}