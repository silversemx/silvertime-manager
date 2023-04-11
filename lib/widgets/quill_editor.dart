import 'dart:convert';

import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:silvertime/include.dart';
import 'package:silvertime/style/container.dart';

class QuillEditorWidget extends StatefulWidget {
  final String? initialValue;
  final String label;
  final Function (String) onUpdate;
  final bool? validation;
  const QuillEditorWidget({ 
    Key? key,
    required this.label, 
    required this.onUpdate,
    this.initialValue,
    this.validation
  }) : super(key: key);

  @override
  State<QuillEditorWidget> createState() => _QuillEditorWidgetState();
}

class _QuillEditorWidgetState extends State<QuillEditorWidget> {
  quill.QuillController? _controller = quill.QuillController.basic();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _updateQuillController();
    super.initState();
  }

  void _updateQuillController() {
    if (widget.initialValue != null && widget.initialValue!.isNotEmpty ) {
      _controller = quill.QuillController(
        document: quill.Document.fromJson(
          json.decode(widget.initialValue??"{}"),
        ),
        selection: const TextSelection.collapsed(offset: 0)
      );
    } else {
      _controller = quill.QuillController.basic();
    }

    _controller!.addListener(() {
      widget.onUpdate (json.encode(_controller!.document.toDelta().toJson()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(onKey: (FocusNode node, RawKeyEvent event) {
        return KeyEventResult.skipRemainingHandlers;
      }),
      onKey: (RawKeyEvent event) {},
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: containerDecoration.copyWith(
          color: Theme.of(context).scaffoldBackgroundColor
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.label, style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(height: 16,),
                  SizedBox(
                    height: 50,
                    child: quill.QuillToolbar.basic(
                      showCodeBlock: false,
                      showSmallButton: false,
                      showInlineCode: false,
                      controller: _controller!,
                    ),
                  ),
                  const SizedBox(height: 16,),
                  Expanded(
                    child: Scrollbar(
                      controller: _scrollController,
                      thumbVisibility: true,
                      child: quill.QuillEditor(
                        placeholder: "Enter text",
                        focusNode: FocusNode(),
                        textCapitalization: TextCapitalization.none,
                        scrollController: _scrollController,
                        // scrollPhysics: const NeverScrollableScrollPhysics(),
                        autoFocus: false,
                        padding: EdgeInsets.zero,
                        expands: true,
                        scrollable: true,
                        controller: _controller!,
                        readOnly: false,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Visibility (
                    visible: widget.validation ?? false,
                    child: Text (
                      S.of(context).missingValue,
                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: UIColors.error
                      ),
                    ),
                  )
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}