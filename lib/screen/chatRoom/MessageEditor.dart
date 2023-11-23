import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class MessageEditor extends StatefulWidget {
  const MessageEditor({super.key});

  @override
  State<MessageEditor> createState() => _MessageEditorState();
}

class _MessageEditorState extends State<MessageEditor> {
  final QuillController _controller = QuillController.basic();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(5),
          ),
          border: Border.all(
            color: Theme.of(context).shadowColor,
            width: 1.0,
          ),
        ),
        child: QuillProvider(
          configurations: QuillConfigurations(
            controller: _controller,
            sharedConfigurations: const QuillSharedConfigurations(
              locale: Locale('ko'),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight,
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(5),
                    right: Radius.circular(5),
                  ),
                ),
                child: const QuillToolbar(),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: QuillEditor.basic(
                  focusNode: _focusNode,
                  configurations: const QuillEditorConfigurations(
                    readOnly: false,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// class MessageEditor extends StatefulWidget {
//   const MessageEditor({super.key});

//   @override
//   State<MessageEditor> createState() => _MessageEditorState();
// }

// class _MessageEditorState extends State<MessageEditor> {
//   late TextEditingController _textEditingController;
//   final FocusNode _focusNode = FocusNode();
//   TextStyle _appliedStyle = TextStyle();
//   bool fontBold = false;
//   bool fontItalic = false;
//   bool drawLine = false;
//   bool linkDialog = false;
//   bool codeField = false;

//   List<Map<String, dynamic>> menuButtons = [];

//   void _applyStyleToSelectedText(TextStyle style, String text) {
//     final TextEditingValue value = _textEditingController.value;
//     final TextSelection selection = _textEditingController.selection;

//     if (!selection.isCollapsed) {
//       final String selectedText =
//           value.text.substring(selection.start, selection.end);

//       final TextSpan newTextSpan = TextSpan(style: style, text: selectedText);

//       final TextSpan newSpan = TextSpan(
//         children: [
//           TextSpan(text: value.text.substring(0, selection.start)),
//           newTextSpan,
//           TextSpan(text: value.text.substring(selection.end)),
//         ],
//       );

//       final int cursorPos = selection.baseOffset;

//       _textEditingController.value = TextEditingValue(
//         text: newSpan.toPlainText(),
//         selection: TextSelection.collapsed(
//           offset: cursorPos + selectedText.length,
//         ),
//       );
//     }
//   }

//   void _sendMessage(String value) {}

//   @override
//   void initState() {
//     super.initState();
//     _textEditingController = TextEditingController();
//   }

//   @override
//   void dispose() {
//     _textEditingController.dispose();
//     _focusNode.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final textColor = Theme.of(context).textTheme.bodyText1!.color;
//     // 메뉴 리스트
//     menuButtons = [
//       {
//         'icon': Icons.format_bold,
//         'color': fontBold ? Theme.of(context).shadowColor : Colors.transparent,
//         'onPressed': () {
//           setState(() {
//             fontBold = !fontBold;
//             // _applyStyleToSelectedText(TextStyle(
//             //     fontWeight: fontBold ? FontWeight.bold : FontWeight.normal));
//           });
//         },
//       },
//       {
//         'icon': Icons.format_italic,
//         'color':
//             fontItalic ? Theme.of(context).shadowColor : Colors.transparent,
//         'onPressed': () {
//           setState(() {
//             fontItalic = !fontItalic;

//             // _applyStyleToSelectedText(TextStyle(
//             //     fontStyle: fontItalic ? FontStyle.italic : FontStyle.normal));
//           });
//         },
//       },
//       {
//         'icon': Icons.strikethrough_s,
//         'color': drawLine ? Theme.of(context).shadowColor : Colors.transparent,
//         'onPressed': () {
//           setState(() {
//             drawLine = !drawLine;

//             // _applyStyleToSelectedText(TextStyle(
//             //     decoration: drawLine
//             //         ? TextDecoration.lineThrough
//             //         : TextDecoration.none));
//           });
//         },
//       },
//       {
//         'icon': Icons.link,
//         'color':
//             linkDialog ? Theme.of(context).shadowColor : Colors.transparent,
//         'onPressed': () {
//           setState(() {
//             linkDialog = !linkDialog;
//           });
//         },
//       },
//       {
//         'icon': Icons.code,
//         'color': codeField ? Theme.of(context).shadowColor : Colors.transparent,
//         'onPressed': () {
//           setState(() {
//             codeField = !codeField;
//           });
//         },
//       },
//     ];

//     return Padding(
//       padding: EdgeInsets.all(20),
//       child: Container(
//         padding: EdgeInsets.all(5),
//         decoration: BoxDecoration(
//           color: Theme.of(context).scaffoldBackgroundColor,
//           borderRadius: const BorderRadius.all(
//             Radius.circular(5),
//           ),
//           border: Border.all(
//             color: Theme.of(context).shadowColor,
//             width: 1.0,
//           ),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: List.generate(
//                 menuButtons.length,
//                 (index) {
//                   return Container(
//                     margin: const EdgeInsets.only(right: 5),
//                     decoration: BoxDecoration(
//                       borderRadius: const BorderRadius.all(
//                         Radius.circular(5),
//                       ),
//                       color: menuButtons[index]['color'],
//                     ),
//                     child: IconButton(
//                       icon: Icon(
//                         menuButtons[index]['icon'],
//                         size: 16,
//                       ),
//                       color: textColor,
//                       onPressed: menuButtons[index]['onPressed'],
//                     ),
//                   );
//                 },
//               ).toList(),
//             ),
//             if (!codeField)
//               TextField(
//                 controller: _textEditingController,
//                 focusNode: _focusNode,
//                 decoration: const InputDecoration(
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.transparent),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.transparent),
//                   ),
//                   hintText: '메시지 보내기',
//                   hintStyle: TextStyle(fontSize: 12),
//                 ),
//                 keyboardType: TextInputType.multiline,
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: textColor,
//                   // fontWeight: fontBold ? FontWeight.bold : FontWeight.normal,
//                   // fontStyle: fontItalic ? FontStyle.italic : FontStyle.normal,
//                   // decoration: drawLine
//                   //     ? TextDecoration.lineThrough
//                   //     : TextDecoration.none,
//                 ),
//                 onChanged: (text) {
//                   _applyStyleToSelectedText(
//                       TextStyle(
//                         fontWeight:
//                             fontBold ? FontWeight.bold : FontWeight.normal,
//                         fontStyle:
//                             fontItalic ? FontStyle.italic : FontStyle.normal,
//                         decoration: drawLine
//                             ? TextDecoration.lineThrough
//                             : TextDecoration.none,
//                       ),
//                       text);
//                   ;
//                 },
//                 maxLines: null,
//                 onSubmitted: (String value) {
//                   _sendMessage(value);
//                 },
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
