import 'package:auth/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpCodeField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final int length;
  final bool hasError;

  const OtpCodeField({
    required this.controller,
    required this.focusNode,
    this.length = 4,
    this.hasError = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Opacity(
          opacity: 0.0,
          child: SizedBox(
            width: 1,
            height: 1,
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              keyboardType: TextInputType.number,
              showCursor: false,
              maxLength: length,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: const InputDecoration(
                border: InputBorder.none,
                counterText: '',
              ),
            ),
          ),
        ),

        ListenableBuilder(
          listenable: Listenable.merge([controller, focusNode]),
          builder: (context, child) {
            final String text = controller.text;
            final TextSelection selection = controller.selection;
            int targetFocusIndex = selection.baseOffset;
            if (targetFocusIndex >= length) {
              targetFocusIndex = length - 1;
            } else if (targetFocusIndex < 0) {
              targetFocusIndex = text.length;
            }

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(length, (int i) {
                final bool isFocused =
                    focusNode.hasFocus && (targetFocusIndex == i);

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: GestureDetector(
                    onTap: () {
                      focusNode.requestFocus();
                      SystemChannels.textInput.invokeMethod('TextInput.show');
                      if (i <= text.length) {
                        if (i == text.length) {
                          controller.selection = TextSelection.collapsed(
                            offset: i,
                          );
                        } else {
                          controller.selection = TextSelection(
                            baseOffset: i,
                            extentOffset: i + 1,
                          );
                        }
                      }
                    },
                    child: _OtpCell(
                      char: text.length > i ? text[i] : '',
                      isFocused: isFocused,
                      hasError: hasError,
                    ),
                  ),
                );
              }),
            );
          },
        ),
      ],
    );
  }
}

class _OtpCell extends StatelessWidget {
  final String char;
  final bool isFocused;
  final bool hasError;

  const _OtpCell({
    required this.char,
    required this.isFocused,
    required this.hasError,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: hasError
              ? AppColors.borderError
              : (isFocused ? AppColors.blue : AppColors.grey400),
          width: isFocused ? 2 : 1,
        ),
      ),
      child: Text(
        char,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
